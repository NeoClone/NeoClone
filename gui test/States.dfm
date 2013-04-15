object EStates: TEStates
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Engine States'
  ClientHeight = 109
  ClientWidth = 97
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Cavebot: TCheckBox
    Left = 0
    Top = 0
    Width = 97
    Height = 17
    Caption = 'Cavebot'
    TabOrder = 0
    OnClick = CavebotClick
  end
  object Healer: TCheckBox
    Left = 0
    Top = 23
    Width = 97
    Height = 17
    Caption = 'Healer'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = HealerClick
  end
  object Looting: TCheckBox
    Left = 0
    Top = 46
    Width = 97
    Height = 17
    Caption = 'Looting'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    OnClick = LootingClick
  end
  object ManaTraining: TCheckBox
    Left = 0
    Top = 69
    Width = 97
    Height = 17
    Caption = 'ManaTraining'
    TabOrder = 3
    OnClick = ManaTrainingClick
  end
  object Targeting: TCheckBox
    Left = 0
    Top = 92
    Width = 97
    Height = 17
    Caption = 'Targeting'
    TabOrder = 4
    OnClick = TargetingClick
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 72
    Top = 32
  end
end
