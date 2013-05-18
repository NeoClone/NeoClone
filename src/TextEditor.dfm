object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Edit text'
  ClientHeight = 254
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EditText: TDScintilla
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 411
    Height = 248
    DllModule = 'SciLexer.dll'
    Align = alClient
  end
end
