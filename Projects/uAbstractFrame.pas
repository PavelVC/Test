unit uAbstractFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  tExtProc = function(const Data: array of variant): AnsiString; stdcall;

type
  TAbstractFrame = class(TForm)
  private
    FMethod: TExtProc;
  public
    function GetCaption: string; virtual; abstract;
    property Method: TExtProc read FMethod write FMethod;
    constructor Create(AOwner: TComponent); override;
  end;

  TAbstractFrameClass = class of TAbstractFrame;

implementation

{$R *.dfm}

{ TAbstractFrame }

{ TAbstractFrame }

constructor TAbstractFrame.Create(AOwner: TComponent);
begin
  inherited;
  BorderStyle := bsNone;
  Align := alClient;
end;

end.
