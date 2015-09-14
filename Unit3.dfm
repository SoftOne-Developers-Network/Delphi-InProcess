object Form1: TForm1
  Left = 282
  Top = 188
  Width = 622
  Height = 385
  Caption = 'Send Special e-Mail'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 606
    Height = 308
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 43
      Top = 26
      Width = 79
      Height = 13
      Caption = #922#969#948#953#954#972#962' '#960#949#955#940#964#951
    end
    object Label2: TLabel
      Left = 35
      Top = 68
      Width = 87
      Height = 13
      Caption = #917#960#969#957#965#956#943#945' '#960#949#955#940#964#951
    end
    object Label3: TLabel
      Left = 94
      Top = 111
      Width = 28
      Height = 13
      Caption = 'e-Mail'
    end
    object Label4: TLabel
      Left = 83
      Top = 154
      Width = 39
      Height = 13
      Caption = #922#949#943#956#949#957#959
    end
    object Edit1: TEdit
      Left = 136
      Top = 24
      Width = 169
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 136
      Top = 64
      Width = 249
      Height = 21
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 136
      Top = 104
      Width = 249
      Height = 21
      TabOrder = 2
    end
    object Memo1: TMemo
      Left = 136
      Top = 152
      Width = 441
      Height = 145
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 308
    Width = 606
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      606
      41)
    object Button1: TButton
      Left = 520
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #913#954#973#961#969#963#951
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 432
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #913#960#959#948#959#967#942
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
