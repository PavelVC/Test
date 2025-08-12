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
    Exec: TButton;
    Panel2: TPanel;
    Param2: TEdit;
    Panel3: TPanel;
    Param1: TEdit;
    cbShowFiles: TCheckBox;
    Clear: TButton;
    GetDir: TButton;
    Button4: TButton;
    procedure ExecClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure GetDirClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure WriteLog(var Msg: TMessage); message WM_USER + 1;
  public
    function GetCaption: string; override;
  end;

implementation

{$R *.dfm}

procedure TFindStringInFileFrame.ExecClick(Sender: TObject);
begin
  Method([Application.MainForm.Handle, Handle, Param1.Text, Param2.Text, cbShowFiles.Checked]);
end;

procedure TFindStringInFileFrame.GetDirClick(Sender: TObject);
begin
  var S: string;
  with TOpenDialog.Create(nil) do
  try
    If Execute then Param1.Text := FileName;
  finally
    Free;
  end;
end;

procedure TFindStringInFileFrame.WriteLog(var Msg: TMessage);
begin
  Log.Lines.Add(Concat(FormatDateTime('dd.mm.yy hh.nn.ss', Now), ' ', pAnsiChar(Msg.LParam)));
end;

procedure TFindStringInFileFrame.Button4Click(Sender: TObject);
begin
  Method([Application.MainForm.Handle, 'ThreadTerminate']);
end;

procedure TFindStringInFileFrame.ClearClick(Sender: TObject);
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
