unit log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, addresses, lua, lualib;

type
  TlogForm = class(TForm)
    ListBox1: TListBox;
    command: TEdit;
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure commandKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LogShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  logForm: TlogForm;

function HexToTColor(sColor : string) : TColor;
procedure AddLog( color: string; log: string; popup: boolean = false );
procedure AddLog2( color: string; log: string; popup: boolean = false );
procedure AddLogError( where: string; log: string );
procedure SetHorizontalScrollBar(lb : TListBox);

implementation

{$R *.dfm}

uses
  unit1;

procedure AddLog( color: string; log: string; popup: boolean = false );
begin
  logForm.ListBox1.Items.Add( color + '|' + FormatDateTime('hh:nn:ss', time()) + '  ' + log );
  logForm.ListBox1.ItemIndex := logForm.ListBox1.Items.Count - 1;
  SetHorizontalScrollBar(logForm.ListBox1);

  if popup then
    logForm.Show;
end;

procedure AddLog2( color: string; log: string; popup: boolean = false );
begin
  logForm.ListBox1.Items.Add( color + '|' + FormatDateTime('hh:nn:ss', time()) + '  ' + log );
  logForm.ListBox1.ItemIndex := logForm.ListBox1.Items.Count - 1;
  SetHorizontalScrollBar(logForm.ListBox1);

  //if popup then
    logForm.Show;
end;

procedure AddLogError( where: string; log: string );
begin
  logForm.ListBox1.Items.Add( colorRed + '|' + FormatDateTime('hh:nn:ss', time()) + '  error in '+ where + ': ' + log );
  logForm.ListBox1.ItemIndex := logForm.ListBox1.Items.Count - 1;
  SetHorizontalScrollBar(logForm.ListBox1);
  if not logForm.Visible then
    logForm.Show;
end;

function HexToTColor(sColor : string) : TColor;
begin
   Result :=
     RGB(
       StrToInt('$'+Copy(sColor, 2, 2)),
       StrToInt('$'+Copy(sColor, 4, 2)),
       StrToInt('$'+Copy(sColor, 6, 2))
     ) ;
end;

function ColorToHex(Color : TColor) : string;
begin
   Result :=
     IntToHex(GetRValue(Color), 2) +
     IntToHex(GetGValue(Color), 2) +
     IntToHex(GetBValue(Color), 2) ;
end;

procedure SetHorizontalScrollBar(lb : TListBox);
var
  j, MaxWidth: integer;
  line: string;
begin
  MaxWidth := 0;
  for j := 0 to lb.Items.Count - 1 do
  begin
    line := copy(lb.Items[j], pos('|', lb.Items[j])+1, length(lb.Items[j]));
    if MaxWidth < lb.Canvas.TextWidth(line) then
      MaxWidth := lb.Canvas.TextWidth(line) ;

  end;
  SendMessage(lb.Handle,
              LB_SETHORIZONTALEXTENT,
              MaxWidth + 5, 0) ;
end;

procedure TlogForm.commandKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  res: integer;
begin
  if (key = VK_RETURN) and (length(command.Text) > 0) then
  begin
    res := LuaScript.DoString( command.Text );
    case res of
          LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
          LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
          LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
          LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
        end;
    command.Text := '';
  end;
end;

procedure TlogForm.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  line, chex: string;
  col: TColor;
begin
  line := ListBox1.Items[index];
  chex := copy(line, 0, pos('|', line)-1);
  line := copy(line, pos('|', line)+1, length(line));
  col := HexToTColor(chex);

  listbox1.Canvas.Brush.Color := clwhite;
  listbox1.Canvas.FillRect(Rect);

  if odSelected in State then
  begin
    listbox1.Canvas.Brush.Color := HexToTColor('#f4f4f4');
    listbox1.Canvas.FillRect(Rect);
  end;

  listbox1.Canvas.Font.Color := col;
  listbox1.Canvas.TextOut(rect.Left + 2, rect.Top + 1, line);

  if odSelected in State then
  begin
    listbox1.Canvas.DrawFocusRect(Rect);
  end;
  if not listbox1.Focused then listbox1.Canvas.DrawFocusRect(listbox1.ItemRect(listbox1.ItemIndex));
end;

procedure TlogForm.LogShow(Sender: TObject);
begin         //so we don't have to click the damn textbox every fcking time :/
  LogForm.command.SetFocus();
end;

end.
