object ShellFrame: TShellFrame
  Left = 0
  Top = 0
  Caption = 'ShellFrame'
  ClientHeight = 576
  ClientWidth = 998
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnKeyDown = FormKeyDown
  TextHeight = 17
  object Log: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 992
    Height = 535
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 541
    Width = 992
    Height = 32
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Button1: TButton
      AlignWithMargins = True
      Left = 838
      Top = 3
      Width = 149
      Height = 24
      Align = alRight
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
      TabOrder = 0
      OnClick = Button1Click
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 89
      Height = 30
      Align = alLeft
      BevelOuter = bvNone
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '
      TabOrder = 1
    end
    object Param1: TEdit
      AlignWithMargins = True
      Left = 89
      Top = 3
      Width = 584
      Height = 24
      Margins.Left = 0
      Margins.Right = 0
      Align = alLeft
      TabOrder = 2
      Text = 
        '"C:\Program Files\7-Zip\7z.exe" a -mx5 -r0 d:\Proj.zip C:\Projec' +
        'ts'
      ExplicitHeight = 23
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 712
      Top = 3
      Width = 120
      Height = 24
      Align = alRight
      Caption = #1055#1088#1077#1088#1074#1072#1090#1100
      TabOrder = 3
      OnClick = Button2Click
    end
  end
end
