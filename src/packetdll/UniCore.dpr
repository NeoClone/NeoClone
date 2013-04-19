library UniCore;

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Dialogs,
  PetriW.Pipes in '..\PetriW.Pipes.pas';

const
  addrParserFunc = $460E70;
  addrCallGetNextPacket = $460EB3;
  addrRecvStream = $9E6EB0;

type
  TDummy = class
  public
    procedure PipeDataReceived(AData: string; RawData: TBytes; len: integer);
  end;

  TPacketStream = packed record
    pBuffer: pointer;
    dwSize: dword;
    dwPos: dword;
  end;
  PPacketStream = ^TPacketStream;

  FGetNextPacket = function(): integer;

{$R *.res}

var
  Packet: PPacketStream;
  oldGetNextPacket: FGetNextPacket;
  oldGetNextAddr: dword;
  pipeServer: TPBPipeServer;
  pipeClient: TPBPipeClient;
  dummy: TDummy;

function MyGetNextPacket(): integer; stdcall;
var
  packetSize: dword;
  amsgbuf : TBytes;
begin
  result := oldGetNextPacket();
  if result <> -1 then
  begin
    if Packet.dwPos-1 = 8 then
    begin
      packetSize := Packet.dwSize - Packet.dwPos + 1;
      setlength(amsgbuf, Packet.dwSize);

      CopyMemory(@amsgbuf[1], Packet.pBuffer, Packet.dwSize );
      pipeClient.SendDataEx( amsgbuf, Packet.dwPos, packetSize );

      setlength(amsgbuf, 0);
    end;
  end;
end;

function HookCall(dwAddress:dword;dwFunction:pointer):dword;
var
  callByte: array[0..4] of byte;
  dwOldProtect, dwNewProtect, dwNewCall, dwOldCall:dword;
begin
  callbyte[0] := $E8;
  callbyte[1] := $00;
  callbyte[2] := $00;
  callbyte[3] := $00;
  callbyte[4] := $00;

  dwNewCall := longword(dwFunction) - dwaddress - 5;
  CopyMemory(@callByte[1],@dwNewCall,4);

  VirtualProtectEx(GetCurrentProcess(), ptr(dwAddress), 5, PAGE_READWRITE, dwOldProtect);
  CopyMemory(@dwOldCall, ptr(dwAddress+1), 4);
  CopyMemory(ptr(dwAddress), @callByte, 5);
  VirtualProtectEx(GetCurrentProcess(), ptr(dwAddress), 5, dwOldProtect, dwNewProtect);
  result := dwAddress + dwOldCall + 5;
end;

procedure init();
begin
  pipeClient := TPBPipeClient.Create('\\.\pipe\pipe app ' + inttostr(GetCurrentProcessId()));
  oldGetNextAddr := HookCall( addrCallGetNextPacket, @MyGetNextPacket );
  oldGetNextPacket := ptr(oldGetNextAddr);
  Packet := ptr(addrRecvStream);
end;

procedure TDummy.PipeDataReceived(AData: string; RawData: TBytes; len: integer);
begin
  if AData = 'init' then
  begin
    init();
  end;
end;

begin
  dummy := TDummy.Create;
  pipeServer := TPBPipeServer.Create('\\.\pipe\pipe dll ' + inttostr(GetCurrentProcessId()));
  pipeServer.OnReceivedData := dummy.PipeDataReceived;
end.
