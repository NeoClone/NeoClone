unit Memory;

interface

uses
  Classes, SysUtils, Windows, Messages, Variants, Dialogs, addresses,
  PSAPI, TlHelp32;

type
  TMemory = class
  private
    FTProc: integer;
  public
    function ReadBytes(Address: Integer; length: Integer): Tbytes;
    function ReadByte( addr: integer ): byte;
    function ReadWord(addr: Integer): integer;
    function ReadInteger( addr: integer ): integer;
    function ReadPointer( addr: integer; offsets: array of integer; firstClean: boolean = true ): integer;
    function ReadString( addr: Integer ): String;
    procedure ReadPacket(addr: Integer; var arr: array of byte);
   function GetModuleBaseAddress(pid: Cardinal; MName: String): Pointer;  {
	function ReadString_Multilevel(path: long): string; //for chatbox correction      }
  end;


implementation

uses
  unit1;



  { Returns Tibia.exe base address }
{ @author unknown }
function TMemory.GetModuleBaseAddress(pid: Cardinal; MName: String): Pointer;
var
  Modules         : Array of HMODULE;
  cbNeeded, i     : Cardinal;
  ModuleInfo      : TModuleInfo;
  ModuleName      : Array[0..MAX_PATH] of Char;
  PHandle         : THandle;
begin
  Result := nil;
  SetLength(Modules, 1024);
  PHandle := OpenProcess(PROCESS_QUERY_INFORMATION + PROCESS_VM_READ, False, pid);
  if (PHandle <> 0) then
  begin
    EnumProcessModules(PHandle, @Modules[0], 1024 * SizeOf(HMODULE), cbNeeded); //Getting the enumeration of modules
    SetLength(Modules, cbNeeded div SizeOf(HMODULE)); //Setting the number of modules
    for i := 0 to Length(Modules) - 1 do //Start the bucle
    begin
      GetModuleBaseName(PHandle, Modules[i], ModuleName, SizeOf(ModuleName)); //Getting the name of module
      if AnsiCompareText(MName, ModuleName) = 0 then //If the module name match with the name of module we are looking for...
      begin
        GetModuleInformation(PHandle, Modules[i], @ModuleInfo, SizeOf(ModuleInfo)); //Get the information of module
        Result := ModuleInfo.lpBaseOfDll; //Return the information we want (The image base address)
        CloseHandle(PHandle);
        Exit;
      end;
    end;
  end;
end;




function TMemory.ReadBytes(Address: Integer; length: Integer): Tbytes;
var
  NBR: NativeUInt;
lpBuffer: Tbytes;
begin
  FTProc := Main.TProc;
    setLength(lpBuffer, length);      //we declare the array length
    try
        ReadProcessMemory(FTProc, Ptr(Address), lpBuffer, Length, NBR)
    except
        on exception: Exception do
            showMessage(Concat('ReadMemory#13#10', exception.Message))
    end;
    begin
        Result := lpBuffer;
        exit
    end
end;

function TMemory.ReadByte(addr: Integer): byte;
var
  NBR: NativeUInt;
begin
  FTProc := Main.TProc;
  ReadProcessMemory(FTProc, Ptr(Addr), @result, 1, NBR);
end;

function TMemory.ReadWord(addr: Integer): integer;
var
  NBR: NativeUInt;
  aa: word;
begin
  FTProc := Main.TProc;
  ReadProcessMemory(FTProc, Ptr(Addr), @aa, 2, NBR);
  result := aa;
end;

function TMemory.ReadInteger(addr: Integer): integer;
var
  NBR: NativeUInt;
begin
  FTProc := Main.TProc;
  ReadProcessMemory(FTProc, Ptr(Addr), @result, 4, NBR);
end;

function TMemory.ReadPointer( addr: integer; offsets: array of integer; firstClean: boolean = true ): integer;
var
  NBR: NativeUInt;
  p, i: integer;
begin
  FTProc := Main.TProc;

  if firstClean then
    ReadProcessMemory(FTProc, Ptr(addr), @p, 4, NBR)
  else
    p := addr;

  for i := Low(offsets) to High(offsets) do
  begin
    p := p + offsets[i];
    ReadProcessMemory(FTProc, Ptr(p), @p, 4, NBR);
  end;

  result := p;
end;

function TMemory.ReadString(addr: Integer): String;
var
  NB : NativeUInt;
  Temp : ARRAY [1..255] OF Byte;
  I : Byte;
begin
  FTProc := Main.TProc;
  Result := '';
  ReadProcessMemory(FTProc, Ptr(Addr), @Temp[1], 255, NB);
  for I := 1 to 255 do
  begin
    if ((Temp[i] = 0) or (Temp[i] = $0F)) then
      Break;
    Result := Result + Chr(Temp[i]);
  end;
end;
                                 {
	function ReadString_Multilevel(path: long): string;
  var
  l,i: integer;
  begin

            l := Length(path);
            if (l > 0) then
            begin
                if (l = 1) then
                    result:= TMemory.ReadString(path[0])
                else
                    begin
                        result := TMemory.ReadInteger(path[0]);
                        for i := 1 to (i < l - 1) do
                          begin
                            result:= TMemory.ReadInteger(result + path[i]);

                            result:= TMemory.ReadString(result + path[l - 1]);
                            i:= i+1;
                          end;
                    end;
            end;
            result:= '';
  end;
                                }
procedure TMemory.ReadPacket(addr: Integer; var arr: array of byte);
var
  NB : NativeUInt;
  len: integer;
  I : Byte;
begin
  FTProc := Main.TProc;
  len := ReadWord(addr);
  ReadProcessMemory(FTProc, Ptr(Addr), @arr[1], len, NB);
end;

end.
