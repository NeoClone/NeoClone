unit TextEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DScintillaCustom, DScintilla, settingsFormUnit;

type
  TForm2 = class(TForm)
    EditText: TDScintilla;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
Uses
Unit1;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
var           //this will add the new info ONLY if we close the window!
buffer: string;
begin          //we have to add the '&amp;' '&lt;' '&#xd;' for the Script Editor Window
buffer:= StringReplace( EditText.GetText, #13, '\n', [rfReplaceAll] ); //parse #13 to \n
buffer:= StringReplace( buffer, #10, '\n', [rfReplaceAll] ); //parse #10 to \n
buffer:= StringReplace( buffer, '\n\n', '\n', [rfReplaceAll] ); //parse doubles (noobie style) xD

settingsForm.SETsetting(settingsForm.getPathTextEditor, buffer); //setsetting(path, parse(txt))
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
EditText.SetHScrollBar(False);  //so we don't see that ugly bar. And we don't need it cause names/IDs aren't so long
end;

end.
