unit settingsTemplates;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

function loadCleanSettings(): string;

function loadCleanNewItem(): string;
function loadCleanNewRule(): string;
function loadCleanNewHotkey(): string;
function loadCleanNewPersistent(): string;
function loadCleanNewCavebot(): string;
function loadCleanNewDisplay(): string;
function loadCleanNewMonster(): string;
implementation
                //here is all the info (settings and so), if you want to change them use a Resource Editor (ResEdit)
{$R settingsTemplates.RES}

function loadCleanSettings(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleansettings', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewItem(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewitem', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewRule(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewrule', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewHotkey(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewhotkey', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewPersistent(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewpersistent', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewCavebot(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewcavebot', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewDisplay(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewdisplay', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

function loadCleanNewMonster(): string;
var
  resLoader: TResourceStream;
  str: TStringList;
begin
  str := TStringList.Create;
  resLoader := TResourceStream.Create(hInstance, 'cleannewmonster', RT_RCDATA);

  str.LoadFromStream(resLoader);
  result := str.Text;

  resLoader.Free;
  str.Free;
end;

end.
