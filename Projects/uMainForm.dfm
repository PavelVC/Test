object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = ' '#1058#1077#1089#1090#1086#1074#1072#1103' '#1079#1072#1076#1072#1095#1072
  ClientHeight = 513
  ClientWidth = 1113
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  TextHeight = 17
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1113
    Height = 513
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = ' '#1046#1091#1088#1085#1072#1083' '
      object Log: TMemo
        Left = 0
        Top = 0
        Width = 1105
        Height = 481
        Align = alClient
        Lines.Strings = (
          '')
        TabOrder = 0
      end
    end
  end
end
