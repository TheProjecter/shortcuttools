object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 576
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 8
    Top = 55
    Width = 658
    Height = 513
    ActivePage = ts_DeskIcon
    TabOrder = 0
    object ts1: TTabSheet
      Caption = 'Check Invisible ShortCut'
      ExplicitLeft = 20
      ExplicitTop = 40
      ExplicitWidth = 281
      ExplicitHeight = 165
      object lv_ShotCut: TListView
        Left = 0
        Top = 0
        Width = 647
        Height = 425
        Columns = <
          item
            Caption = 'Name'
            Width = 125
          end
          item
            Caption = 'Path'
            Width = 300
          end
          item
            Caption = 'IsCommon'
            Width = 75
          end
          item
            Caption = 'Exist'
          end>
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btn_Check: TButton
        Left = 572
        Top = 442
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 1
        OnClick = btn1Click
      end
      object btn1: TButton
        Left = 443
        Top = 442
        Width = 75
        Height = 25
        Caption = 'Check'
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object ts2: TTabSheet
      Caption = 'DeskTopAlign'
      ImageIndex = 1
      ExplicitLeft = 0
      object rb_Left: TRadioButton
        Left = 64
        Top = 40
        Width = 113
        Height = 17
        Caption = 'rb_Left'
        TabOrder = 0
      end
      object rb_Right: TRadioButton
        Left = 64
        Top = 80
        Width = 113
        Height = 17
        Caption = 'rb_Right'
        TabOrder = 1
      end
      object rb_Top: TRadioButton
        Left = 64
        Top = 120
        Width = 113
        Height = 17
        Caption = 'rb_Top'
        TabOrder = 2
      end
      object rb_Bottom: TRadioButton
        Left = 64
        Top = 160
        Width = 113
        Height = 17
        Caption = 'rb_Bottom'
        TabOrder = 3
      end
      object btn_Arrange: TButton
        Left = 536
        Top = 400
        Width = 75
        Height = 25
        Caption = 'Arrange'
        TabOrder = 4
        OnClick = btn_ArrangeClick
      end
      object rb_Cirlce: TRadioButton
        Left = 64
        Top = 200
        Width = 113
        Height = 17
        Caption = 'rb_Cirlce'
        TabOrder = 5
      end
    end
    object ts_DeskIcon: TTabSheet
      Caption = 'Shotcut Icon'
      ImageIndex = 2
      object chk_ClearArrow: TCheckBox
        Left = 40
        Top = 32
        Width = 233
        Height = 17
        Caption = 'Clear Shotcut Icon Arrow'
        TabOrder = 0
      end
      object chk_IconTrans: TCheckBox
        Left = 40
        Top = 72
        Width = 217
        Height = 17
        Caption = 'Make Shotcut Icon Transparent'
        TabOrder = 1
      end
      object btn_ShortcutIconApply: TButton
        Left = 480
        Top = 376
        Width = 75
        Height = 25
        Caption = 'Apply'
        TabOrder = 2
        OnClick = btn_ShortcutIconApplyClick
      end
    end
  end
  object pb_ScanSC: TProgressBar
    Left = 12
    Top = 521
    Width = 381
    Height = 24
    TabOrder = 1
    Visible = False
  end
end
