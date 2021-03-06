library huddll;

uses
  FMX.Forms,
  FMX.Dialogs,
  System.SysUtils,
  System.Classes,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

procedure showme(); stdcall export;
begin
  TForm1.showme();
end;

procedure closeme(); stdcall export;
begin
  TForm1.closeme();
end;

function gethandle(): integer; stdcall export;
begin
  result := TForm1.returnHandle();
end;

function addDisplay(): integer; stdcall export;
begin
  result := Form1.addDisplayF();
end;

procedure refreshDisplay( index: integer ); stdcall export;
begin
  Form1.redrawDisplayF( index );
end;

procedure delDisplay( index: integer ); stdcall export;
begin
  Form1.delDisplayF( index );
end;

procedure addDisplayItem( index: integer; item: string ); stdcall export;
begin
  Form1.addDisplayItemF( index, item );
end;

exports
  showme, closeme, gethandle, addDisplay, refreshDisplay, delDisplay, addDisplayItem;

begin
end.
