unit uMethodThread;

interface

uses
  Classes,
  Messages,
  Windows;

const
  UM_WRITELOG = WM_USER+1;

type
  TAbstractMethodThread = class(TThread)
  protected
    Params: array of variant;
    BreakThread: boolean;
  public
    Result: AnsiString;
    procedure WriteLog(H: THandle; Text: AnsiString);
    constructor Create(const Data: array of variant); overload;
  end;


implementation

{ TMethodThread }

constructor TAbstractMethodThread.Create(const Data: array of variant);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  BreakThread := False;
  SetLength(Params, Length(Data));
  for var I: integer := Low(Data) to High(Data) do Params[I] := Data[I];
end;

procedure TAbstractMethodThread.WriteLog(H: THandle; Text: AnsiString);
begin
  SendMessage(H, UM_WRITELOG, 0, UIntPtr(@Text[1]));
end;

end.
