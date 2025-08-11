object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = ' '#1058#1077#1089#1090#1086#1074#1072#1103' '#1079#1072#1076#1072#1095#1072
  ClientHeight = 513
  ClientWidth = 1113
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnShow = FormShow
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1113
    Height = 513
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    ExplicitWidth = 853
    object TabSheet1: TTabSheet
      Caption = ' '#1046#1091#1088#1085#1072#1083' '
      object TaskList: TListBox
        Left = 0
        Top = 0
        Width = 1105
        Height = 483
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 15
        TabOrder = 0
        ExplicitWidth = 845
      end
    end
  end
end
