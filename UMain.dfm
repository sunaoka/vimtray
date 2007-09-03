object ConfigForm: TConfigForm
  Left = 198
  Top = 402
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'VimTray'
  ClientHeight = 159
  ClientWidth = 462
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 14
    Top = 24
    Width = 48
    Height = 12
    Caption = '&VIM path:'
    FocusControl = editVimPath
  end
  object Label2: TLabel
    Left = 14
    Top = 56
    Width = 110
    Height = 12
    Caption = '&MRU (mru_files) path:'
    FocusControl = editMruPath
  end
  object lblURL: TLabel
    Left = 16
    Top = 126
    Width = 256
    Height = 12
    Cursor = crHandPoint
    Caption = '(C) 2007 SUNAOKA Norifumi <http://pocari.org/>.'
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clBtnShadow
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    OnClick = lblURLClick
    OnMouseEnter = lblURLMouseEnter
    OnMouseLeave = lblURLMouseLeave
  end
  object editVimPath: TEdit
    Left = 136
    Top = 20
    Width = 289
    Height = 20
    TabOrder = 0
  end
  object editMruPath: TEdit
    Left = 136
    Top = 52
    Width = 289
    Height = 20
    TabOrder = 2
  end
  object btnVimPath: TButton
    Left = 430
    Top = 20
    Width = 20
    Height = 20
    Caption = '...'
    TabOrder = 1
    OnClick = btnVimPathClick
  end
  object btnMruPath: TButton
    Left = 430
    Top = 52
    Width = 20
    Height = 20
    Caption = '...'
    TabOrder = 3
    OnClick = btnMruPathClick
  end
  object btnOK: TButton
    Left = 296
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 376
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object chkTab: TCheckBox
    Left = 14
    Top = 88
    Width = 120
    Height = 17
    Caption = 'Open &tab page'
    TabOrder = 6
  end
  object imgIcon: TImageList
    Left = 424
    Top = 80
  end
  object OpenDialog: TOpenDialog
    Left = 360
    Top = 80
  end
  object menuMRU: TPopupMenu
    Images = imgIcon
    Left = 392
    Top = 80
    object N1: TMenuItem
      Caption = '-'
    end
    object menuOpen: TMenuItem
      Caption = '&Open'
      Default = True
      OnClick = menuOpenClick
    end
    object menuConfig: TMenuItem
      Caption = '&Config...'
      OnClick = menuConfigClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object menuExit: TMenuItem
      Caption = 'E&xit'
      OnClick = menuExitClick
    end
  end
  object TrayIcon: TCoolTrayIcon
    CycleInterval = 0
    Hint = 'VimTray'
    Icon.Data = {
      0000010002002020100000000000E80200002600000010101000000000002801
      00000E0300002800000020000000400000000100040000000000800200000000
      0000000000000000000000000000000000000000800000800000008080008000
      0000800080008080000080808000C0C0C0000000FF0000FF000000FFFF00FF00
      0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
      0000000000044000000000000000000000000000000004000000000000000000
      008770000088808800880088800000000F887700208800880088008800000000
      0F8887702208800880088008800000000F888877020880088408800880000000
      0F8888877008800088448800800000000F888888770088008888888888000000
      0F8888888708880888088808800000000F888888887000200020000000000000
      0F8888888880880222222240000000000F88888888808802222222240000000A
      0F8888888888000222222222400000A20F888888788887702222222224000A22
      0F8888887F8888770222222222400A220F8888887FF8888770222222224000A2
      0F88888870FF8888770222222400000A0F888888700FF8888770222240000000
      0F8888887020FF8888770224000000000F88888870220FF88887704000000000
      0F888888702220FF88887700000000000F8888887022220FF888877000000000
      0F88888870222220FF888877000000000F888888702222220F88888770000000
      078888887702222220788888770000008888888888702222088888888700000F
      8888888888802220F88888888800000FFFFFFFFFFF0222A0FFFFFFFFF0000000
      0000000000A22A00000000000000000000000000000AA0000000000000000000
      0000000000000000000000000000FFFE7FFFFFFC3FFFFC780CC7F8300003F000
      0007F0000003F0000003F0000003F0000001F0000003F0000007F000000FE000
      0007C000000380000001000000000000000080000001C0000003E0000007F000
      000FF000001FF000000FF0000007F0000003F0000001E0000001C0000001C000
      0003E0001007FFFC3FFFFFFE7FFF280000001000000020000000010004000000
      0000C00000000000000000000000000000000000000000000000000080000080
      00000080800080000000800080008080000080808000C0C0C0000000FF0000FF
      000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000004400000000000
      0040040000000008700880808080000887208084808000088800808080800008
      88088088888000088880008808000208888080002024A2088888002222240A08
      887F8870224000088870F8870400000888700F8870000008887020F887000088
      88870088887000FFFFF020FFFF000000000AA0000000FE7F0000E4150000C000
      0000C0000000C0000000C000000080010000000000000000000080010000C003
      0000C0030000C00100008000000080010000C0430000}
    IconVisible = True
    IconIndex = 0
    PopupMenu = menuMRU
    OnMouseDown = TrayIconMouseDown
    Left = 328
    Top = 80
  end
end
