object logForm: TlogForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Log Console'
  ClientHeight = 206
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = LogShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 372
    Height = 185
    Style = lbOwnerDrawFixed
    Align = alClient
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnDrawItem = ListBox1DrawItem
  end
  object command: TEdit
    Left = 0
    Top = 185
    Width = 372
    Height = 21
    Align = alBottom
    TabOrder = 1
    OnKeyUp = commandKeyUp
  end
end
