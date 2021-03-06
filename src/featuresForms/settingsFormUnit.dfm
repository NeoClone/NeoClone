object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Neosettings -'
  ClientHeight = 294
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PropTree: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 551
    Height = 294
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    LineMode = lmBands
    ParentFont = False
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toEditable, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toEditOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCreateEditor = PropTreeCreateEditor
    OnEditing = PropTreeEditing
    OnGetText = PropTreeGetText
    OnNodeDblClick = PropTreeNodeDblClick
    Columns = <
      item
        Position = 0
        Width = 227
        WideText = 'Name'
      end
      item
        Position = 1
        Width = 320
        WideText = 'Value'
      end>
  end
  object MainMenu1: TMainMenu
    Left = 228
    Top = 76
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save
      end
    end
    object Slot1: TMenuItem
      Caption = 'Slot'
      object Slot11: TMenuItem
        Caption = 'Slot 1'
      end
      object Slot21: TMenuItem
        Caption = 'Slot 2'
      end
      object Slot31: TMenuItem
        Caption = 'Slot 3'
      end
      object Slot41: TMenuItem
        Caption = 'Slot 4'
      end
      object Slot51: TMenuItem
        Caption = 'Slot 5'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Custom1: TMenuItem
        Caption = 'Custom...'
      end
    end
    object Exchange1: TMenuItem
      Caption = 'Exchange'
      object Exporttofile1: TMenuItem
        Caption = 'Export selection to file...'
      end
      object Exportselectiontoclipboard1: TMenuItem
        Caption = 'Export selection to clipboard'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Importfromfile1: TMenuItem
        Caption = 'Import from file...'
      end
      object Importfromclipboard1: TMenuItem
        Caption = 'Import from clipboard'
      end
    end
    object Examples1: TMenuItem
      Caption = 'Examples'
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      object ClearCavebotHotkeys1: TMenuItem
        Caption = 'Clear Cavebot Hotkeys...'
        OnClick = ClearCavebotHotkeys1Click
      end
      object ClearDisplays1: TMenuItem
        Caption = 'Clear Displays...'
        OnClick = ClearDisplays1Click
      end
      object ClearHealrules1: TMenuItem
        Caption = 'Clear Heal Rules...'
        OnClick = ClearHealRules
      end
      object ClearHotkeys1: TMenuItem
        Caption = 'Clear Hotkeys...'
        OnClick = ClearHotkeys1Click
      end
      object ClearLoot1: TMenuItem
        Caption = 'Clear Loot Items...'
      end
      object ClearPersistent1: TMenuItem
        Caption = 'Clear Persistent...'
        OnClick = ClearPersistent
      end
      object ClearTrageting1: TMenuItem
        Caption = 'Clear Targeting Monsters...'
      end
      object ClearWaypoints1: TMenuItem
        Caption = 'Clear Waypoints...'
      end
      object blank: TMenuItem
        Caption = '----------------------------'
      end
      object ClearAll1: TMenuItem
        Caption = 'Clear All...'
        OnClick = Clear
      end
    end
    object aaa1: TMenuItem
      Caption = 'aaa'
      Visible = False
    end
  end
end
