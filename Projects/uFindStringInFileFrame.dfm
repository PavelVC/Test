object FindStringInFileFrame: TFindStringInFileFrame
  Left = 0
  Top = 0
  ClientHeight = 464
  ClientWidth = 1150
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 17
  object Log: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1144
    Height = 423
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 429
    Width = 1144
    Height = 32
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Exec: TButton
      AlignWithMargins = True
      Left = 990
      Top = 3
      Width = 149
      Height = 24
      Align = alRight
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
      TabOrder = 0
      OnClick = ExecClick
    end
    object Panel2: TPanel
      Left = 339
      Top = 0
      Width = 105
      Height = 30
      Align = alLeft
      BevelOuter = bvNone
      Caption = #1052#1072#1089#1082#1072' '#1087#1086#1080#1089#1082#1072
      TabOrder = 1
    end
    object Param2: TEdit
      AlignWithMargins = True
      Left = 447
      Top = 3
      Width = 121
      Height = 24
      Align = alLeft
      TabOrder = 2
      ExplicitHeight = 23
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 129
      Height = 30
      Align = alLeft
      BevelOuter = bvNone
      Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1092#1072#1081#1083
      TabOrder = 3
    end
    object Param1: TEdit
      AlignWithMargins = True
      Left = 129
      Top = 3
      Width = 181
      Height = 24
      Margins.Left = 0
      Margins.Right = 0
      Align = alLeft
      TabOrder = 4
      ExplicitHeight = 23
    end
    object cbShowFiles: TCheckBox
      AlignWithMargins = True
      Left = 574
      Top = 3
      Width = 162
      Height = 24
      Align = alLeft
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1093#1086#1078#1076#1077#1085#1080#1103
      TabOrder = 5
    end
    object Clear: TButton
      AlignWithMargins = True
      Left = 830
      Top = 3
      Width = 154
      Height = 24
      Align = alRight
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099
      TabOrder = 6
      OnClick = ClearClick
    end
    object GetDir: TButton
      AlignWithMargins = True
      Left = 310
      Top = 2
      Width = 26
      Height = 26
      Margins.Left = 0
      Margins.Top = 2
      Margins.Bottom = 2
      Align = alLeft
      Caption = '...'
      TabOrder = 7
      OnClick = GetDirClick
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 704
      Top = 3
      Width = 120
      Height = 24
      Align = alRight
      Caption = #1055#1088#1077#1088#1074#1072#1090#1100
      TabOrder = 8
      OnClick = Button4Click
      ExplicitLeft = 762
    end
  end
end
