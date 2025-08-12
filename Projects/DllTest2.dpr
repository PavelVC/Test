library DllTest2;

uses
  ShareMem,
  System.SysUtils,
  System.Classes,
  Windows,
  uMethodThread in 'D:\Projects\uMethodThread.pas';

type
  tMethodThread = class(TAbstractMethodThread)
  private
    const
      cMainHandle = 0;
      cFrameHandle = 1;
      cCommandLine = 2;
  protected
    procedure Execute; override;
  end;

{ tMethodThread }

procedure tMethodThread.Execute;
var
  StartInfo: TStartupInfoA;
  ProcInfo: TProcessInformation;
  WaitRes: cardinal;
  Title: AnsiString;
begin
  var Cmd: AnsiString := Params[cCommandLine];
  Title := Concat('������� Shell execute ', Cmd);
  WriteLog(Params[cMainHandle], Title + ' ��������');
  WriteLog(Params[cFrameHandle], '����������');
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  StartInfo.cb := SizeOf(StartInfo);
  StartInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow := SW_SHOWNORMAL;
  If CreateProcessA(nil, @Cmd[1],  nil, nil, False, CREATE_NO_WINDOW, nil, nil, StartInfo, ProcInfo) then
  begin
    repeat
      WaitRes := WaitForSingleObject(ProcInfo.hProcess, 250);
      WriteLog(Params[cFrameHandle], '$$progress$$');
    until BreakThread or Terminated or (WaitRes = WAIT_OBJECT_0);
    If BreakThread then
    begin
      TerminateProcess(ProcInfo.hProcess, 0);
      WriteLog(Params[cMainHandle], Title + ' ��������');
      BreakThread := False;
      Terminate;
      Exit;
    end;
  end
  else
    RaiseLastOSError;
  WriteLog(Params[cFrameHandle], '���������');
  WriteLog(Params[cMainHandle], Title + ' ���������');
end;

var
  MethodThread: tMethodThread;

function RunShellCommand(const Data: array of variant):ansistring; stdcall;
begin
  If (Length(Data) = 0) then
    Result := 'TShellFrame'
  else if ansistring(Data[1]) = 'ThreadTerminate' then
    MethodThread.BreakThread := True
  else
  begin
    MethodThread := TMethodThread.Create(Data);
    MethodThread.Start;
  end;
end;

exports RunShellCommand, TerminateThread;

begin
end.
