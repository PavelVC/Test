unit uMethodThread;

interface

uses
  Classes,
  Messages;

const
  UM_WRITELOG = WM_USER+1;
type
  TAbstractMethodThread = class(TThread)
  protected
  public
    Params: array of variant;
    procedure WriteLog;
  end;


implementation

{ TMethodThread }

procedure TAbstractMethodThread.WriteLog;
begin
end;

end.
