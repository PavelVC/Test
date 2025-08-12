unit uShellFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uAbstractFrame;

type
  TShellFrame = class(TAbstractFrame)
    Log: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    Param1: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
  private
    procedure WriteLog(var Msg: TMessage); message WM_USER + 1;
  public
    function GetCaption: string; override;
  end;

var
  ShellFrame: TShellFrame;

implementation

{$R *.dfm}

{ TShellFrame }

procedure TShellFrame.Button1Click(Sender: TObject);
begin
  Log.Lines.Add('>' + Param1.Text);
  Invalidate;
  Method([Application.MainForm.Handle, Handle, Param1.Text]);
end;

procedure TShellFrame.Button2Click(Sender: TObject);
begin
  Method([Application.MainForm.Handle, 'ThreadTerminate']);
end;

procedure TShellFrame.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Case Key of
    VK_RETURN: Log.Lines.Add(Method([Application.MainForm.Handle, Handle, Param1.Text]));
  else
    Exit;
  end;
  Key := 0;
end;

function TShellFrame.GetCaption: string;
begin
  Result := 'Выполнение CLI команд';
end;

procedure TShellFrame.WriteLog(var Msg: TMessage);
begin
  var S: AnsiString := pAnsiChar(Msg.LParam);
  if S = '$$progress$$' then
    Log.Lines[Log.Lines.Count - 1] := Log.Lines[Log.Lines.Count - 1] + '.'
  else
    Log.Lines.Add(S);
end;

begin
  RegisterClasses([TShellFrame]);
end.
