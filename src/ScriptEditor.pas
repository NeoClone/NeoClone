unit ScriptEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DScintillaCustom, DScintilla, DScintillaTypes,
  settingsFormUnit, lua, lualib, log;

type
  TForm3 = class(TForm)
    EditScript: TDScintilla;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
var           //this will add the new info ONLY if we close the window!
buffer: string;
res: integer;          //not working properly, neither the filter of $ after closing this.
begin          //we have to add the '&amp;' '&lt;' '&#xd;' '&gt; for the Script Editor Window
buffer:= StringReplace( EditScript.GetText, #13, '\n', [rfReplaceAll] ); //parse #13 to \n
buffer:= StringReplace( buffer, #10, '\n', [rfReplaceAll] ); //parse #10 to \n
buffer:= StringReplace( buffer, '\n\n', '\n', [rfReplaceAll] ); //parse doubles (noobie style) xD

settingsForm.SETsetting(settingsForm.getPathTextEditor, buffer); //setsetting(path, parse(txt))

    res := LuaScript.DoString( EditScript.GetText );
    case res of
          LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
          LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
          LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
          LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
        end;

//Form3.Destroy; //not sure if this + the "OnShow"--> create, will work :/
end;

procedure TForm3.FormCreate(Sender: TObject);
//  procedure SetColors(const Style: Integer; const Fore: Integer;
//    const Back: TColor = clWindow; const Bold: Boolean = False;
//    const Italic: Boolean = False; const Underline: Boolean = False;
//    const Font: string = 'Courier New'; const Size: Integer = 10);
//  begin
//    EditScript.StyleSetBack(Style, ColorToRGB(Back));
//    EditScript.StyleSetFore(Style, ColorToRGB(Fore));
//    EditScript.StyleSetFont(Style, Font);
//    EditScript.StyleSetSize(Style, Size);
//    EditScript.StyleSetBold(Style, Bold);
//    EditScript.StyleSetItalic(Style, Italic);
//    EditScript.StyleSetUnderline(Style, Underline);
//  end;
begin
EditScript.SetScrollWidth(430);
EditScript.Margins.Right:=1;
EditScript.Margins.Left:=0;
EditScript.Margins.Top:=1;
EditScript.Margins.Bottom:=1;
EditScript.SetMarginLeft(5);
EditScript.SetMarginWidthN(0,40);
EditScript.SetMarginWidthN(1,0);
EditScript.SetExtraAscent(2);
EditScript.SetExtraDescent(2);
//EditScript.SetLexerLanguage(lua);
  EditScript.SetLexer(SCLEX_LUA);
  EditScript.SetCodePage(CP_UTF8);

  // and some visual settings

//  SetColors(SCE_H_DEFAULT, clBlack);
//  SetColors(SCE_H_TAG, clblack, clWindow, True);
//  SetColors(SCE_H_TAGUNKNOWN, clgreen);
//  SetColors(SCE_H_ATTRIBUTE, clNavy);
//  SetColors(SCE_H_ATTRIBUTEUNKNOWN, clRed);
//  SetColors(SCE_H_NUMBER, clBlue);
//  SetColors(SCE_H_DOUBLESTRING, clBlue);
//  SetColors(SCE_H_SINGLESTRING, clBlue);
//  SetColors(SCE_H_OTHER, clBlack);
//  SetColors(SCE_H_COMMENT, clTeal);
//  SetColors(SCE_H_ENTITY, clPurple);
//  SetColors(SCE_H_TAGEND, clyellow);
//  SetColors(SCE_H_CDATA, clTeal);
// EditScript.StyleSetBack(STYLE_DEFAULT, clDefault); // setting up the default background color
//  EditScript.StyleSetFore(SCE_LUA_DEFAULT, clDefault); // Pascal specific default fore color
//  EditScript.StyleSetBack(SCE_LUA_DEFAULT, clDefault); // Pascal specific default back color
//  EditScript.StyleSetFore(SCE_LUA_IDENTIFIER, clDefault); // Pascal specific identifier fore color
//  EditScript.StyleSetBack(SCE_LUA_IDENTIFIER, clDefault); // Pascal specific identifier back color
//  EditScript.StyleSetBold(SCE_LUA_IDENTIFIER, True); // Pascal specific identifier bold font style
//  EditScript.StyleSetUnderline(SCE_LUA_IDENTIFIER, True); // Pascal specific identifier underline font style
//  EditScript.StyleSetFore(SCE_PAS_COMMENT, RGB(243, 236, 255)); // etc.
//  EditScript.StyleSetBack(SCE_PAS_COMMENT, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_COMMENT2, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_COMMENT2, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_COMMENTLINE, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_COMMENTLINE, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_NUMBER, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_NUMBER, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_HEXNUMBER, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_HEXNUMBER, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_WORD, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_WORD, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_STRING, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_STRING, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_STRINGEOL, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_STRINGEOL, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_CHARACTER, RGB(243, 236, 255));
//  EditScript.StyleSetBack(SCE_PAS_CHARACTER, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_OPERATOR, clRed);
//  EditScript.StyleSetBack(SCE_PAS_OPERATOR, clBlack);
//  EditScript.StyleSetFore(SCE_PAS_ASM, clRed);
//  EditScript.StyleSetBack(SCE_PAS_ASM, clBlack);
end;

end.
