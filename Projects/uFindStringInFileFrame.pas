unit uFindStringInFileFrame;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  uAbstractFrame;

type
  TFindStringInFileFrame = class(TAbstractFrame)
    Log: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Param2: TEdit;
    Panel3: TPanel;
    Param1: TEdit;
    cbShowFiles: TCheckBox;
    Button3: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    function GetCaption: string; override;
  end;

implementation

{$R *.dfm}

procedure TFindStringInFileFrame.Button1Click(Sender: TObject);
begin
  Log.Text := Log.Text + Method([Application.MainForm.Handle, Param1.Text, Param2.Text, cbShowFiles.Checked]);
end;

procedure TFindStringInFileFrame.Button2Click(Sender: TObject);
begin
  var S: string;
  with TOpenDialog.Create(nil) do
  try
    If Execute then Param1.Text := FileName;
  finally
    Free;
  end;
end;

procedure TFindStringInFileFrame.Button3Click(Sender: TObject);
begin
  Log.Clear;
end;

function TFindStringInFileFrame.GetCaption: string;
begin
  Result := ' Поиск подстроки в файле ';
end;

begin
  RegisterClasses([TFindStringInFileFrame]);
end.
