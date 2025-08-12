library DllTest2;

uses
  ShareMem,
  System.SysUtils,
  System.Classes,
  Windows,
  uMethodThread in 'uMethodThread.pas';

type
  tLogProc = procedure(Mess: string) of object;

  tMethodThread = class(TAbstractMethodThread)
  private
    CommandLine: AnsiString;
    MainFormHandle: HWND;
  protected
    procedure Execute; override;
  end;

var
  Result: AnsiString;
  BreakThread: boolean;

{ tMethodThread }

procedure tMethodThread.Execute;
var
  StartInfo: TStartupInfoA;
  ProcInfo: TProcessInformation;
  WaitRes: cardinal;
begin
  Result := Concat('Задание Shell execute ', CommandLine, ' запущено');
  PostMessage(MainFormHandle, UM_WRITELOG, 0, UIntPtr(@Result[1]));
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  StartInfo.cb := SizeOf(StartInfo);
  StartInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow := SW_SHOWNORMAL;
  If CreateProcessA(nil, pAnsiChar(@CommandLine[1]),  nil, nil, False, CREATE_NO_WINDOW, nil, nil, StartInfo, ProcInfo) then
  begin
    repeat
      WaitRes := WaitForSingleObject(ProcInfo.hProcess, 50);
    until BreakThread or Terminated or (WaitRes = WAIT_OBJECT_0);
    If BreakThread then
    begin
      Result := 'Задание Shell execute прервано';
      TerminateProcess(ProcInfo.hProcess, 0);
      PostMessage(MainFormHandle, UM_WRITELOG, 0, UIntPtr(@Result[1]));
      BreakThread := False;
      Terminate;
      Exit;
    end;
  end
  else
    RaiseLastOSError;
  Result := 'Задание Shell execute выполнено';
  PostMessage(MainFormHandle, UM_WRITELOG, 0, UIntPtr(@Result[1]));
end;

function RunShellCommand(const Data: array of variant; LogProc: tLogProc):ansistring; stdcall;
var
  StartInfo: TStartupInfoA;
  ProcInfo: TProcessInformation;
begin
  If (Length(Data) = 0) then
    Result := 'TShellFrame'
  else if Data[1] = 'ThreadTerminate' then
    BreakThread := True
  else
  with TMethodThread.Create(True) do
  begin
    MainFormHandle := Data[0];
    FreeOnTerminate := True;
    CommandLine := Data[1];
    BreakThread := False;
    Start;
  end;
end;

exports RunShellCommand, TerminateThread;

begin
end.
