unit afxCodeHook;

{$IMAGEBASE $13140000}

interface

uses
  Windows;

{$L 'srt.obj'}

function SizeOfProc(Proc: pointer): dword;
function InjectString(Process: LongWord; Text: ansistring): pchar;
function InjectMemory(Process: LongWord; Memory: Pointer; Len: dword): pointer;
function InjectThread(Process: dword; Thread: pointer; Info: pointer; InfoLen: dword; Results: boolean): THandle;
function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar; lpProcessAttributes, lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation; ModulePath: pchar): Boolean; stdcall;
function InjectLibrary(Process: LongWord; ModulePath: ansistring): Boolean;
function UninjectLibrary(Process: LongWord; ModulePath: ansistring): Boolean;
function InjectLibraryEx(Process: LongWord; Src: Pointer): Boolean;
function HookCode(TargetModule, TargetProc: string; NewProc: Pointer; var OldProc: Pointer): integer;
function UnhookCode(NewProc, OldProc: Pointer): integer;
function DeleteFileEx(Process: LongWord; FilePath: PChar): Boolean;
function DisableSFC: Boolean;
function IsNT: boolean;

function RT_GetVersion(pReserved: Pointer): LongWord; stdcall; external;
function xVirtualAllocEx(hProcess: LongWord; lpAddress: Pointer; dwSize: LongWord; flAllocationType: LongWord; flProtect: LongWord): Pointer; stdcall; external;
function xVirtualFreeEx(hProcess: LongWord; lpAddress: Pointer; dwSize: LongWord; dwFreeType: LongWord): Boolean; stdcall; external;
function xCreateRemoteThread(hProcess: LongWord; lpThreadAttributes: Pointer; dwStackSize: LongWord; lpStartAddress: Pointer; lpParameter: Pointer; dwCreationFlags: LongWord; lpThreadId: Pointer): LongWord; stdcall; external;
function xOpenThread(dwDesiredAccess: LongWord; bInheritHandle: Boolean; dwThreadId: LongWord): LongWord; stdcall; external;

implementation

type
  TImportFunction = packed record
    JumpInstruction: Word;
    AddressOfPointerToFunction: ^Pointer;
  end;

  TImageImportEntry = record
    Characteristics: dword;
    TimeDateStamp: dword;
    MajorVersion: word;
    MinorVersion: word;
    Name: dword;
    LookupTable: dword;
  end;

type
 TModuleList = array of cardinal;

type
  TImportItem = record
    Name: string;
    PProcVar: ^Pointer;
  end;

  TwordArr = array [0..0] of word;
  PwordArr = ^TwordArr;
  TdwordArr = array [0..0] of dword;
  PdwordArr = ^TdwordArr;

  PImageImportDescriptor = ^TImageImportDescriptor;
  TImageImportDescriptor = packed record
    OriginalFirstThunk: dword;
    TimeDateStamp: dword;
    ForwarderChain: dword;
    Name: dword;
    FirstThunk: dword;
  end;

  PImageBaseRelocation= ^TImageBaseRelocation;
  TImageBaseRelocation = packed record
    VirtualAddress: cardinal;
    SizeOfBlock: cardinal;
  end;

  TDllEntryProc = function(hinstDLL: HMODULE; dwReason: dword; lpvReserved: Pointer): Boolean; stdcall;

  TStringArray = array of string;

  TLibInfo = record
    ImageBase: Pointer;
    ImageSize: longint;
    DllProc: TDllEntryProc;
    DllProcAddress: Pointer;
    LibsUsed: TStringArray;
  end;

  PLibInfo = ^TLibInfo;
  PPointer = ^Pointer;

  TSections = array [0..100000] of TImageSectionHeader;

const
  IMPORTED_NAME_OFFSET = $00000002;
  IMAGE_ORDINAL_FLAG32 = $80000000;
  IMAGE_ORDINAL_MASK32 = $0000FFFF;

function SizeOfProc(Proc: pointer): dword;
var
  ByteLoop: dword;
begin
  ByteLoop := 0;
  while byte(pointer(dword(Proc) + ByteLoop)^) <> $C3 do Inc(ByteLoop);
  Result := ByteLoop + 1;
end;

function InjectString(Process: LongWord; Text: ansistring): pchar;
var
  BytesWritten: NativeUInt;
begin
  Result := xVirtualAllocEx(Process, nil, Length(Text) + 1, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(Process, Result, pansistring(Text), Length(Text) + 1, BytesWritten);
end;

function InjectMemory(Process: LongWord; Memory: Pointer; Len: dword): pointer;
var
  BytesWritten: NativeUInt;
begin
  Result := xVirtualAllocEx(Process, nil, Len, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  WriteProcessMemory(Process, Result, Memory, Len, BytesWritten);
end;

function InjectThread(Process: dword; Thread: pointer; Info: pointer; InfoLen: dword; Results: boolean): THandle;
var
  pThread, pInfo: pointer;
  BytesRead: NativeUInt;
  TID: dword;
begin
  pInfo := InjectMemory(Process, Info, InfoLen);
  pThread := InjectMemory(Process, Thread, SizeOfProc(Thread));
  Result := xCreateRemoteThread(Process, nil, 0, pThread, pInfo, 0, @TID);
  if Results then
  begin
    WaitForSingleObject(Result, INFINITE);
    ReadProcessMemory(Process, pInfo, Info, InfoLen, BytesRead);
  end;
end;

function GetModuleList: TModuleList;
var
  Module, Base: pointer;
  ModuleCount: integer;
  lpModuleName: array [0..MAX_PATH] of char;
  MemoryBasicInformation: TMemoryBasicInformation;
begin
  SetLength(Result, 10);
  ModuleCount := 0;
  Module := nil;
  Base := nil;
  while VirtualQueryEx(GetCurrentProcess, Module, MemoryBasicInformation, SizeOf(MemoryBasicInformation)) = SizeOf(MemoryBasicInformation) do
  begin
    if (MemoryBasicInformation.State = MEM_COMMIT) and (MemoryBasicInformation.AllocationBase <> Base) and (MemoryBasicInformation.AllocationBase = MemoryBasicInformation.BaseAddress) and (GetModuleFileName(dword(MemoryBasicInformation.AllocationBase), lpModuleName, MAX_PATH) > 0) then
    begin
      if ModuleCount = Length(Result) then SetLength(Result, ModuleCount * 2);
      Result[ModuleCount] := dword(MemoryBasicInformation.AllocationBase);
      Inc(ModuleCount);
    end;
    Base := MemoryBasicInformation.AllocationBase;
    dword(Module) := dword(Module) + MemoryBasicInformation.RegionSize;
  end;
  SetLength(Result, ModuleCount);
end;

function FunctionAddress(Code: Pointer): Pointer;
begin
  Result := Code;
  if TImportFunction(Code^).JumpInstruction = $25FF then Result := TImportFunction(Code^).AddressOfPointerToFunction^;
end;

function HookModules(ImageDosHeader: PImageDosHeader; TargetAddress, NewAddress: Pointer; var OldAddress: Pointer):integer;
var
  ImageNTHeaders : PImageNtHeaders;
  ImageImportEntry: ^TImageImportEntry;
  ImportCode: ^Pointer;
  OldProtect: dword;
  EndofImports: dword;
begin
  Result := 0;
  OldAddress := FunctionAddress(TargetAddress);
  if ImageDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then Exit;
  ImageNTHeaders := Pointer(integer(ImageDosHeader) + ImageDosHeader._lfanew);;
  if ImageNTHeaders <> nil then
  begin
    with ImageNTHeaders^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT] do
    begin
      ImageImportEntry := Pointer(dword(ImageDosHeader) + VirtualAddress);
      EndofImports := VirtualAddress + Size;
    end;
    if ImageImportEntry <> nil then
    begin
      while ImageImportEntry^.Name <> 0 do
      begin
        if ImageImportEntry^.LookUpTable > EndofImports then break;
        if ImageImportEntry^.LookUpTable <> 0 then
        begin
          ImportCode := Pointer(dword(ImageDosHeader) + ImageImportEntry^.LookUpTable);
          while ImportCode^ <> nil do
          begin
            if (ImportCode^ = TargetAddress) and VirtualProtect(ImportCode, 4, PAGE_EXECUTE_READWRITE, @OldProtect) then ImportCode^ := NewAddress;
            Inc(ImportCode);
          end;
        end;
        Inc(ImageImportEntry);
      end;
    end;
  end;
end;

function HookCode(TargetModule, TargetProc: string; NewProc: Pointer; var OldProc: Pointer): integer;
var
 ModuleLoop: integer;
 Modules: TModuleList;
 Module: hModule;
 Target: pointer;
begin
  Result := 0;
  Module := GetModuleHandle(pchar(TargetModule));
  Modules := GetModuleList;
  if Module = 0 then
  begin
    Module := LoadLibrary(pchar(TargetModule));
  end;
  Target := GetProcAddress(Module, pchar(TargetProc));
  if Target = nil then Exit;
  for ModuleLoop := 0 to High(Modules) do
  begin
    if (GetVersion and $80000000 = 0) or (Modules[ModuleLoop] < $80000000) then
    begin
      Result := HookModules(Pointer(Modules[ModuleLoop]), Target, NewProc, OldProc);
    end;
  end;
end;

function UnhookCode(NewProc, OldProc: Pointer): integer;
var
 ModuleLoop: integer;
 Modules: TModuleList;
begin
  Result := 0;
  Modules := GetModuleList;
  for ModuleLoop := 0 to High(Modules) do
  begin
    if (GetVersion and $80000000 = 0) or (Modules[ModuleLoop] < $80000000) then
    begin
      Result := HookModules(Pointer(Modules[ModuleLoop]), NewProc, OldProc, NewProc);
    end;
  end;
end;

function CreateProcessEx(lpApplicationName: PChar; lpCommandLine: PChar; lpProcessAttributes, lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: PChar; const lpStartupInfo: TStartupInfo; var lpProcessInformation: TProcessInformation; ModulePath: pchar): Boolean; stdcall;
var
  Parameters: pchar;
  Thread, ThreadID: dword;
begin
  Result := False;
  if not CreateProcess(lpApplicationName, lpCommandLine, lpProcessAttributes, lpThreadAttributes, bInheritHandles, dwCreationFlags or CREATE_SUSPENDED, lpEnvironment, lpCurrentDirectory, lpStartupInfo, lpProcessInformation) then Exit;
  Parameters := InjectString(lpProcessInformation.hProcess, ModulePath);
  Thread := xCreateRemoteThread(lpProcessInformation.hProcess, nil, 0, GetProcAddress(GetModuleHandle('KERNEL32.DLL'), 'LoadLibraryA'), Parameters, 0, @ThreadId);
  if Thread = 0 then Exit;
  CloseHandle(Thread);
  Result := True;
end;

function InjectLibrary(Process: LongWord; ModulePath: ansistring): Boolean;
var
  Parameters: Pointer;
  Thread, ThreadID: dword;
begin
  Result := False;
  Parameters := InjectString(Process, ModulePath);
  Thread := xCreateRemoteThread(Process, nil, 0, GetProcAddress(GetModuleHandle('KERNEL32.DLL'), 'LoadLibraryA'), Parameters, 0, @ThreadId);
  if Thread = 0 then Exit;
  CloseHandle(Thread);
  Result := True;
end;

function UninjectLibrary(Process: LongWord; ModulePath: ansistring): Boolean;
type
  TUninjectLibraryInfo = record
    pFreeLibrary: pointer;
    pGetModuleHandle: pointer;
    lpModuleName: pointer;
    pExitThread: pointer;
  end;
var
  UninjectLibraryInfo: TUninjectLibraryInfo;
  Thread: THandle;

  procedure UninjectLibraryThread(lpParameter: pointer); stdcall;
  var
    UninjectLibraryInfo: TUninjectLibraryInfo;
  begin
    UninjectLibraryInfo := TUninjectLibraryInfo(lpParameter^);
    asm
      @1:
      inc ecx
      push UninjectLibraryInfo.lpModuleName
      call UninjectLibraryInfo.pGetModuleHandle
      cmp eax, 0
      je @2
      push eax
      call UninjectLibraryInfo.pFreeLibrary
      jmp @1
      @2:
      push eax
      call UninjectLibraryInfo.pExitThread
    end;
  end;

begin
  Result := False;
  UninjectLibraryInfo.pGetModuleHandle := GetProcAddress(GetModuleHandle('kernel32'), 'GetModuleHandleA');
  UninjectLibraryInfo.pFreeLibrary := GetProcAddress(GetModuleHandle('kernel32'), 'FreeLibrary');
  UninjectLibraryInfo.pExitThread := GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  UninjectLibraryInfo.lpModuleName := InjectString(Process, ModulePath);
  Thread := InjectThread(Process, @UninjectLibraryThread, @UninjectLibraryInfo, SizeOf(TUninjectLibraryInfo), False);
  if Thread = 0 then Exit;
  CloseHandle(Thread);
  Result := True;
end;

function GetProcAddressEx(Process: LongWord; lpModuleName, lpProcName: pchar): pointer;
type
  TGetProcAddrExInfo = record
    pExitThread: pointer;
    pGetProcAddress: pointer;
    pGetModuleHandle: pointer;
    lpModuleName: pointer;
    lpProcName: pointer;
  end;
var
  GetProcAddrExInfo: TGetProcAddrExInfo;
  ExitCode: longword;
  Thread: THandle;

  procedure GetProcAddrExThread(lpParameter: pointer); stdcall;
  var
    GetProcAddrExInfo: TGetProcAddrExInfo;
  begin
    GetProcAddrExInfo := TGetProcAddrExInfo(lpParameter^);
    asm
      push GetProcAddrExInfo.lpModuleName
      call GetProcAddrExInfo.pGetModuleHandle
      push GetProcAddrExInfo.lpProcName
      push eax
      call GetProcAddrExInfo.pGetProcAddress
      push eax
      call GetProcAddrExInfo.pExitThread
    end;
  end;

begin
  Result := nil;
  GetProcAddrExInfo.pGetModuleHandle := GetProcAddress(GetModuleHandle('kernel32'), 'GetModuleHandleA');
  GetProcAddrExInfo.pGetProcAddress := GetProcAddress(GetModuleHandle('kernel32'), 'GetProcAddress');
  GetProcAddrExInfo.pExitThread := GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  GetProcAddrExInfo.lpProcName := InjectString(Process, lpProcName);
  GetProcAddrExInfo.lpModuleName := InjectString(Process, lpModuleName);
  Thread := InjectThread(Process, @GetProcAddrExThread, @GetProcAddrExInfo, SizeOf(GetProcAddrExInfo), False);
  if Thread <> 0 then
  begin
    WaitForSingleObject(Thread, INFINITE);
    GetExitCodeThread(Thread, ExitCode);
    Result := pointer(ExitCode);
  end;
end;

function MapLibraryNT(Process: LongWord; Dest, Src: Pointer): TLibInfo;
var
  ImageBase: pointer;
  ImageBaseDelta: integer;
  ImageNtHeaders: PImageNtHeaders;
  PSections: ^TSections;
  SectionLoop: integer;
  SectionBase: pointer;
  VirtualSectionSize, RawSectionSize: cardinal;
  OldProtect: cardinal;
  NewLibInfo: TLibInfo;

  function StrToInt(S: string): integer;
  begin
   Val(S, Result, Result);
  end;

  procedure Add(Strings: TStringArray; Text: string);
  begin
    SetLength(Strings, Length(Strings) + 1);
    Strings[Length(Strings) - 1] := Text;
  end;

  function Find(Strings: array of string; Text: string; var Index: integer): boolean;
  var
    StringLoop: integer;
  begin
    Result := False;
    for StringLoop := 0 to Length(Strings) - 1 do
    begin
      if lstrcmpi(pchar(Strings[StringLoop]), pchar(Text)) = 0 then
      begin
        Index := StringLoop;
        Result := True;
      end;
    end;
  end;

  function GetSectionProtection(ImageScn: cardinal): cardinal;
  begin
    Result := 0;
    if (ImageScn and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
    begin
    Result := Result or PAGE_NOCACHE;
    end;
    if (ImageScn and IMAGE_SCN_MEM_EXECUTE) <> 0 then
    begin
      if (ImageScn and IMAGE_SCN_MEM_READ)<> 0 then
      begin
        if (ImageScn and IMAGE_SCN_MEM_WRITE)<> 0 then
        begin
          Result := Result or PAGE_EXECUTE_READWRITE
        end
        else
        begin
          Result := Result or PAGE_EXECUTE_READ
        end;
      end
      else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_EXECUTE_WRITECOPY
      end
      else
      begin
        Result := Result or PAGE_EXECUTE
      end;
    end
    else if (ImageScn and IMAGE_SCN_MEM_READ)<> 0 then
    begin
      if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_READWRITE
      end
      else
      begin
        Result := Result or PAGE_READONLY
      end
    end
    else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
    begin
      Result := Result or PAGE_WRITECOPY
    end
    else
    begin
      Result := Result or PAGE_NOACCESS;
    end;
  end;

  procedure ProcessRelocs(PRelocs:PImageBaseRelocation);
  var
    PReloc: PImageBaseRelocation;
    RelocsSize: cardinal;
    Reloc: PWord;
    ModCount: cardinal;
    RelocLoop: cardinal;
  begin
    PReloc := PRelocs;
    RelocsSize := ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;
    while cardinal(PReloc) - cardinal(PRelocs) < RelocsSize do
    begin
      ModCount := (PReloc.SizeOfBlock - Sizeof(PReloc^)) div 2;
      Reloc := pointer(cardinal(PReloc) + sizeof(PReloc^));
      for RelocLoop := 0 to ModCount - 1 do
      begin
        if Reloc^ and $f000 <> 0 then Inc(pdword(cardinal(ImageBase) + PReloc.VirtualAddress + (Reloc^ and $0fff))^, ImageBaseDelta);
        Inc(Reloc);
      end;
      PReloc := pointer(Reloc);
    end;
  end;

  procedure ProcessImports(PImports: PImageImportDescriptor);
  var
    PImport: PImageImportDescriptor;
    Import: LPDword;
    PImportedName: pchar;
    ProcAddress: pointer;
    PLibName: pchar;
    ImportLoop: integer;

    function IsImportByOrdinal(ImportDescriptor: dword): boolean;
    begin
      Result := (ImportDescriptor and IMAGE_ORDINAL_FLAG32) <> 0;
    end;

  begin
    PImport := PImports;
    while PImport.Name <> 0 do
    begin
      PLibName := pchar(cardinal(PImport.Name) + cardinal(ImageBase));
      if not Find(NewLibInfo.LibsUsed, PLibName, ImportLoop) then
      begin
        InjectLibrary(Process, PLibName);
        Add(NewLibInfo.LibsUsed, PLibName);
      end;
      if PImport.TimeDateStamp = 0 then
      begin
        Import := LPDword(pImport.FirstThunk + cardinal(ImageBase))
      end
      else
      begin
        Import := LPDword(pImport.OriginalFirstThunk + cardinal(ImageBase));
      end;
      while Import^ <> 0 do
      begin
        if IsImportByOrdinal(Import^) then
        begin
          ProcAddress := GetProcAddressEx(Process, PLibName, pchar(Import^ and $ffff))
        end
        else
        begin
          PImportedName := pchar(Import^ + cardinal(ImageBase) + IMPORTED_NAME_OFFSET);
          ProcAddress := GetProcAddressEx(Process, PLibName, PImportedName);
        end;
        PPointer(Import)^ := ProcAddress;
        Inc(Import);
      end;
      Inc(PImport);
    end;
  end;

begin
  ImageNtHeaders := pointer(int64(cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  ImageBase := VirtualAlloc(Dest, ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_NOACCESS);
  ImageBaseDelta := cardinal(ImageBase) - ImageNtHeaders.OptionalHeader.ImageBase;
  SectionBase := VirtualAlloc(ImageBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_READWRITE);
  Move(Src^, SectionBase^, ImageNtHeaders.OptionalHeader.SizeOfHeaders);
  VirtualProtect(SectionBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders, PAGE_READONLY, OldProtect);
  PSections := pointer(pchar(@(ImageNtHeaders.OptionalHeader)) + ImageNtHeaders.FileHeader.SizeOfOptionalHeader);
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
  begin
    VirtualSectionSize := PSections[SectionLoop].Misc.VirtualSize;
    RawSectionSize := PSections[SectionLoop].SizeOfRawData;
    if VirtualSectionSize < RawSectionSize then
    begin
      VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
      RawSectionSize := VirtualSectionSize xor RawSectionSize;
      VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
    end;
    SectionBase := VirtualAlloc(PSections[SectionLoop].VirtualAddress + pchar(ImageBase), VirtualSectionSize, MEM_COMMIT, PAGE_READWRITE);
    FillChar(SectionBase^, VirtualSectionSize, 0);
    Move((pchar(src) + PSections[SectionLoop].PointerToRawData)^, SectionBase^, RawSectionSize);
  end;
  NewLibInfo.DllProc := TDllEntryProc(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + cardinal(ImageBase));
  NewLibInfo.DllProcAddress := pointer(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + cardinal(ImageBase));
  NewLibInfo.ImageBase := ImageBase;
  NewLibInfo.ImageSize := ImageNtHeaders.OptionalHeader.SizeOfImage;
  SetLength(NewLibInfo.LibsUsed, 0);
  if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0 then ProcessRelocs(pointer(ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress + cardinal(ImageBase)));
  if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress <> 0 then ProcessImports(pointer(ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress + cardinal(ImageBase)));
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
  begin
    VirtualProtect(PSections[SectionLoop].VirtualAddress + pchar(ImageBase), PSections[SectionLoop].Misc.VirtualSize, GetSectionProtection(PSections[SectionLoop].Characteristics), OldProtect);
  end;
  Result := NewLibInfo;
end;

function MapLibrary9X(Process: dword; Src: Pointer): TLibInfo;
var
  ImageBase: pointer;
  ImageBaseDelta: integer;
  ImageNtHeaders: PImageNtHeaders;
  PSections: ^TSections;
  SectionLoop: integer;
  SectionBase: pointer;
  VirtualSectionSize, RawSectionSize: cardinal;
  OldProtect: cardinal;
  NewLibInfo: TLibInfo;

  function StrToInt(S: string): integer;
  begin
   Val(S, Result, Result);
  end;

  procedure Add(Strings: TStringArray; Text: string);
  begin
    SetLength(Strings, Length(Strings) + 1);
    Strings[Length(Strings) - 1] := Text;
  end;

  function Find(Strings: array of string; Text: string; var Index: integer): boolean;
  var
    StringLoop: integer;
  begin
    Result := False;
    for StringLoop := 0 to Length(Strings) - 1 do
    begin
      if lstrcmpi(pchar(Strings[StringLoop]), pchar(Text)) = 0 then
      begin
        Index := StringLoop;
        Result := True;
      end;
    end;
  end;

  function GetSectionProtection(ImageScn: cardinal): cardinal;
  begin
    Result := 0;
    if (ImageScn and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
    begin
    Result := Result or PAGE_NOCACHE;
    end;
    if (ImageScn and IMAGE_SCN_MEM_EXECUTE) <> 0 then
    begin
      if (ImageScn and IMAGE_SCN_MEM_READ)<> 0 then
      begin
        if (ImageScn and IMAGE_SCN_MEM_WRITE)<> 0 then
        begin
          Result := Result or PAGE_EXECUTE_READWRITE
        end
        else
        begin
          Result := Result or PAGE_EXECUTE_READ
        end;
      end
      else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_EXECUTE_WRITECOPY
      end
      else
      begin
        Result := Result or PAGE_EXECUTE
      end;
    end
    else if (ImageScn and IMAGE_SCN_MEM_READ)<> 0 then
    begin
      if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
      begin
        Result := Result or PAGE_READWRITE
      end
      else
      begin
        Result := Result or PAGE_READONLY
      end
    end
    else if (ImageScn and IMAGE_SCN_MEM_WRITE) <> 0 then
    begin
      Result := Result or PAGE_WRITECOPY
    end
    else
    begin
      Result := Result or PAGE_NOACCESS;
    end;
  end;

  procedure ProcessRelocs(PRelocs:PImageBaseRelocation);
  var
    PReloc: PImageBaseRelocation;
    RelocsSize: cardinal;
    Reloc: PWord;
    ModCount: cardinal;
    RelocLoop: cardinal;
  begin
    PReloc := PRelocs;
    RelocsSize := ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].Size;
    while cardinal(PReloc) - cardinal(PRelocs) < RelocsSize do
    begin
      ModCount := (PReloc.SizeOfBlock - Sizeof(PReloc^)) div 2;
      Reloc := pointer(cardinal(PReloc) + sizeof(PReloc^));
      for RelocLoop := 0 to ModCount - 1 do
      begin
        if Reloc^ and $f000 <> 0 then Inc(pdword(cardinal(ImageBase) + PReloc.VirtualAddress + (Reloc^ and $0fff))^, ImageBaseDelta);
        Inc(Reloc);
      end;
      PReloc := pointer(Reloc);
    end;
  end;

  procedure ProcessImports(PImports: PImageImportDescriptor);
  var
    PImport: PImageImportDescriptor;
    Import: LPDword;
    PImportedName: pchar;
    LibHandle: HModule;
    ProcAddress: pointer;
    PLibName: pchar;
    ImportLoop: integer;

    function IsImportByOrdinal(ImportDescriptor: dword; HLib: THandle): boolean;
    begin
      Result := (ImportDescriptor and IMAGE_ORDINAL_FLAG32) <> 0;
    end;

  begin
    PImport := PImports;
    while PImport.Name <> 0 do
    begin
      PLibName := pchar(cardinal(PImport.Name) + cardinal(ImageBase));
      if not Find(NewLibInfo.LibsUsed, PLibName, ImportLoop) then
      begin
        LibHandle := LoadLibrary(PLibName);
        Add(NewLibInfo.LibsUsed, PLibName);
      end
      else
      begin
        LibHandle := cardinal(NewLibInfo.LibsUsed[ImportLoop]);
      end;
      if PImport.TimeDateStamp = 0 then
      begin
        Import := LPDword(pImport.FirstThunk + cardinal(ImageBase))
      end
      else
      begin
        Import := LPDword(pImport.OriginalFirstThunk + cardinal(ImageBase));
      end;
      while Import^ <> 0 do
      begin
        if IsImportByOrdinal(Import^, LibHandle) then
        begin
          ProcAddress := GetProcAddress(LibHandle, pchar(Import^ and $ffff))
        end
        else
        begin
          PImportedName := pchar(Import^ + cardinal(ImageBase) + IMPORTED_NAME_OFFSET);
          ProcAddress := GetProcAddress(LibHandle, PImportedName);
        end;
        PPointer(Import)^ := ProcAddress;
        Inc(Import);
      end;
      Inc(PImport);
    end;
  end;

begin
  ImageNtHeaders := pointer(int64(cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  ImageBase := xVirtualAllocEx(Process, nil, ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_NOACCESS);
  if ImageBase = nil then Exit;
  ImageBaseDelta := cardinal(ImageBase) - ImageNtHeaders.OptionalHeader.ImageBase;
  SectionBase := xVirtualAllocEx(Process, ImageBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_READWRITE);
  if SectionBase = nil then Exit;
  Move(Src^, SectionBase^, ImageNtHeaders.OptionalHeader.SizeOfHeaders);
  VirtualProtect(SectionBase, ImageNtHeaders.OptionalHeader.SizeOfHeaders, PAGE_READONLY, OldProtect);
  PSections := pointer(pchar(@(ImageNtHeaders.OptionalHeader)) + ImageNtHeaders.FileHeader.SizeOfOptionalHeader);
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
  begin
    VirtualSectionSize := PSections[SectionLoop].Misc.VirtualSize;
    RawSectionSize := PSections[SectionLoop].SizeOfRawData;
    if VirtualSectionSize < RawSectionSize then
    begin
      VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
      RawSectionSize := VirtualSectionSize xor RawSectionSize;
      VirtualSectionSize := VirtualSectionSize xor RawSectionSize;
    end;
    SectionBase := xVirtualAllocEx(Process, PSections[SectionLoop].VirtualAddress + pchar(ImageBase), VirtualSectionSize, MEM_COMMIT, PAGE_READWRITE);
    FillChar(SectionBase^, VirtualSectionSize, 0);
    Move((pchar(src) + PSections[SectionLoop].PointerToRawData)^, SectionBase^, RawSectionSize);
  end;
  NewLibInfo.DllProc := TDllEntryProc(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + cardinal(ImageBase));
  NewLibInfo.DllProcAddress := pointer(ImageNtHeaders.OptionalHeader.AddressOfEntryPoint + cardinal(ImageBase));
  NewLibInfo.ImageBase := ImageBase;
  SetLength(NewLibInfo.LibsUsed, 0);
  if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress <> 0 then ProcessRelocs(pointer(ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC].VirtualAddress + cardinal(ImageBase)));
  if ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress <> 0 then ProcessImports(pointer(ImageNtHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress + cardinal(ImageBase)));
  for SectionLoop := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do
  begin
    VirtualProtect(PSections[SectionLoop].VirtualAddress + pchar(ImageBase), PSections[SectionLoop].Misc.VirtualSize, GetSectionProtection(PSections[SectionLoop].Characteristics), OldProtect);
  end;
  Result := NewLibInfo;
end;

function InjectLibraryEx(Process: LongWord; Src: Pointer): Boolean;
type
  TDllLoadInfo = record
    Module: Pointer;
    EntryPoint: Pointer;
  end;
var
  Lib: TLibInfo;
  DllLoadInfo: TDllLoadInfo;
  BytesWritten: NativeUInt;
  ImageNtHeaders: PImageNtHeaders;
  pModule: Pointer;
  Offset: dword;

  procedure DllEntryPoint(lpParameter: pointer); stdcall;
  var
    LoadInfo: TDllLoadInfo;
  begin
    LoadInfo := TDllLoadInfo(lpParameter^);
    asm
      xor eax, eax
      push eax
      push DLL_PROCESS_ATTACH
      push LoadInfo.Module
      call LoadInfo.EntryPoint
      @noret:
      jmp @noret
    end;
  end;

begin
  Result := False;
  pModule := nil;
  ImageNtHeaders := pointer(int64(cardinal(Src)) + PImageDosHeader(Src)._lfanew);
  if IsNT then
  begin
    if Process <> GetCurrentProcess then
    begin
      Offset := $10000000;
      repeat
        Inc(Offset, $10000);
        pModule := VirtualAlloc(pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset), ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
        if pModule <> nil then
        begin
          VirtualFree(pModule, 0, MEM_RELEASE);
          pModule := xVirtualAllocEx(Process, pointer(ImageNtHeaders.OptionalHeader.ImageBase + Offset), ImageNtHeaders.OptionalHeader.SizeOfImage, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
        end;
      until ((pModule <> nil) or (Offset > $30000000));
      Lib := MapLibraryNT(Process, pModule, Src);
    end
    else
    begin
      Lib := MapLibrary9X(Process, Src);
    end;
  end
  else
  begin
    Lib := MapLibrary9X(Process, Src);
  end;
  if Lib.ImageBase = nil then Exit;
  DllLoadInfo.Module := Lib.ImageBase;
  DllLoadInfo.EntryPoint := Lib.DllProcAddress;
  if (IsNT and (Process <> GetCurrentProcess)) then WriteProcessMemory(Process, pModule, Lib.ImageBase, Lib.ImageSize, BytesWritten);
  if InjectThread(Process, @DllEntryPoint, @DllLoadInfo, SizeOf(TDllLoadInfo), False) <> 0 then Result := True
end;

function DeleteFileEx(Process: LongWord; FilePath: PChar): Boolean;
type
  TDeleteFileExInfo = record
    pSleep: pointer;
    lpModuleName: pointer;
    pDeleteFile: pointer;
    pExitThread: pointer;
  end;
var
  DeleteFileExInfo: TDeleteFileExInfo;
  Thread: THandle;

  procedure DeleteFileExThread(lpParameter: pointer); stdcall;
  var
    DeleteFileExInfo: TDeleteFileExInfo;
  begin
    DeleteFileExInfo := TDeleteFileExInfo(lpParameter^);
    asm
      @1:
      push 1000
      call DeleteFileExInfo.pSleep
      push DeleteFileExInfo.lpModuleName
      call DeleteFileExInfo.pDeleteFile
      cmp eax, 0
      je @1
      push eax
      call DeleteFileExInfo.pExitThread
    end;
  end;

begin
  Result := False;
  DeleteFileExInfo.pSleep := GetProcAddress(GetModuleHandle('kernel32'), 'Sleep');
  DeleteFileExInfo.pDeleteFile := GetProcAddress(GetModuleHandle('kernel32'), 'DeleteFileA');
  DeleteFileExInfo.pExitThread := GetProcAddress(GetModuleHandle('kernel32'), 'ExitThread');
  DeleteFileExInfo.lpModuleName := InjectString(Process, FilePath);
  Thread := InjectThread(Process, @DeleteFileExThread, @DeleteFileExInfo, SizeOf(TDeleteFileExInfo), False);
  if Thread = 0 then Exit;
  CloseHandle(Thread);
  Result := True;
end;

function DisableSFC: Boolean;
var
  Process, SFC, PID, Thread, ThreadID: dword;
begin
  Result := False;
  if not IsNT then Exit;
  SFC := LoadLibrary('sfc.dll');
  GetWindowThreadProcessID(FindWindow('NDDEAgnt', nil), @PID);
  Process := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  Thread := xCreateRemoteThread(Process, nil, 0, GetProcAddress(SFC, pchar(2 and $ffff)), nil, 0, @ThreadId);
  if Thread = 0 then Exit;
  CloseHandle(Thread);
  CloseHandle(Process);
  FreeLibrary(SFC);
  Result := True;
end;

function IsNT: boolean;
var
  Version: TOSVersionInfo;
begin
  Version.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(Version);
  Result := Version.dwPlatformId = VER_PLATFORM_WIN32_NT;
end;

end.

