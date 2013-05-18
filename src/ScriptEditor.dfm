object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Edit script'
  ClientHeight = 268
  ClientWidth = 490
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
  object EditScript: TDScintilla
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 484
    Height = 262
    DllModule = 'SciLexer.dll'
    Align = alClient
  end
end
