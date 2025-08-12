unit uFindFilesFrame;

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
  uAbstractFrame, Vcl.Dialogs;

type
  TFindFilesFrame = class(TAbstractFrame)
    Log: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Param2: TEdit;
    Panel3: TPanel;
    Param1: TEdit;
    cbScanSubDirs: TCheckBox;
    cbShowFiles: TCheckBox;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    function GetCaption: string; override;
  end;

implementation

{$R *.dfm}

uses
  IOUtils,
  FileCtrl;

procedure TFindFilesFrame.Button1Click(Sender: TObject);
begin
  Log.Text := Log.Text + Method([Application.MainForm.Handle, Param1.Text, Param2.Text, Ord(cbScanSubDirs.Checked), cbShowFiles.Checked]);
end;

procedure TFindFilesFrame.Button2Click(Sender: TObject);
begin
  var S: string;
  iF SelectDirectory('Выберите путь для поиска', s, s, []) then Param1.Text := S;
end;

procedure TFindFilesFrame.Button3Click(Sender: TObject);
begin
  Log.Clear;
end;

function TFindFilesFrame.GetCaption: string;
begin
  Result := ' Поиск файлов по маске ';
end;

begin
  RegisterClasses([TFindFilesFrame]);
end.
