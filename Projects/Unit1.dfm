object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = ' '#1058#1077#1089#1090#1086#1074#1072#1103' '#1079#1072#1076#1072#1095#1072
  ClientHeight = 513
  ClientWidth = 853
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Button1: TButton
    Left = 560
    Top = 482
    Width = 138
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 853
    Height = 476
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = ' '#1047#1072#1076#1072#1095#1080' '
      object TaskList: TListBox
        Left = 0
        Top = 0
        Width = 845
        Height = 446
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 15
        TabOrder = 0
        ExplicitTop = -35
        ExplicitHeight = 485
      end
    end
  end
  object Button2: TButton
    Left = 704
    Top = 482
    Width = 141
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
end
