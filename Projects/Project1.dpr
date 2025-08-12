program Project1;

uses
  ShareMem,
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uFindStringInFileFrame in 'uFindStringInFileFrame.pas' {FindStringInFileFrame: TFrame},
  uAbstractFrame in 'uAbstractFrame.pas' {AbstractFrame: TFrame},
  uFindFilesFrame in 'uFindFilesFrame.pas' {FindFilesFrame},
  uShellFrame in 'uShellFrame.pas' {ShellFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TShellFrame, ShellFrame);
  Application.Run;
end.
