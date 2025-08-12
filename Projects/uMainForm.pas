unit uMainForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Log: TMemo;
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AddPage(ImageBase: DWORD; PName: PDWORD);
    procedure AddPages(FileName: string);
    procedure WriteLog(var Msg: TMessage); message WM_USER + 1;
  public
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  IOUtils,
  AnsiStrings,
  uAbstractFrame;

{$REGION ' TMainForm '}

procedure TMainForm.AddPage(ImageBase: DWORD; PName: PDWORD);
var FrameClassName: string; Tab: TTabSheet; FrameClass: TAbstractFrameClass; Frame: TAbstractFrame;
begin
  var MethodName: pAnsiChar := PAnsiChar(PDWord(DWord(ImageBase) + PDword(pname)^));
  var ExtProc: TExtProc := GetProcAddress(ImageBase, MethodName);
  FrameClassName := ExtProc([]);
  If FrameClassName <> '' then
  begin
    Tab := TTabSheet.Create(PageControl1);
    with Tab do
    begin
      Visible :=True;
      PageControl := PageControl1;
    end;
    FrameClass := TAbstractFrameClass(FindClass(FrameClassName));
    If Assigned(FrameClass) then
    begin
      Frame:= FrameClass.Create(Self);
      With Frame do
      begin
        Parent := Tab;
        Align := alClient;
        Visible := True;
        Method := ExtProc;
        Tab.Caption := GetCaption;
        Visible := False;
      end;
    end
    else
      raise Exception.Create(Format('Класс %s не найден', [FrameClassName]));
  end;
end;

procedure TMainForm.AddPages(FileName: string);
var PName: PDWORD;
begin
  try
    FileName := ExtractFileName(FileName);
    var ImageBase: DWord := LoadLibrary(@FileName[1]);
    if (ImageBase = 0) then raise Exception.Create('Ошибка загрузки библиотеки ' + FileName);
    var DosHeader: PImageDosHeader := PImageDosHeader(ImageBase);
    if (DosHeader^.e_magic <> IMAGE_DOS_SIGNATURE) then raise Exception.Create('Ошибка DOS проверки сигнатуры библиотеки ' + FileName);
    var PEHeader: PImageNtHeaders := PImageNtHeaders(DWord(ImageBase) + DWord(DosHeader^._lfanew));
    if (PEHeader^.Signature <> IMAGE_NT_SIGNATURE) then raise Exception.Create('Ошибка NT проверки сигнатуры библиотеки ' + FileName);
    var PExport: PImageExportDirectory := PImageExportDirectory(ImageBase + DWord(PEHeader^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress));
    PName:= PDWord(ImageBase + DWord(PExport^.AddressOfNames));
    For var i: integer  := 0 to PExport^.NumberOfNames - 3 do
    begin
      AddPage(ImageBase, PName);
      inc(pname);
     end;
  except
    On E: exception do ;
  end;
end;

destructor TMainForm.Destroy;
begin
  inherited;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  var FileArray: TArray<string> := TDirectory.GetFiles(ExtractFilePath(ParamStr(0)), '*.dll');
  for var S: string in FileArray do AddPages(S);
  PageControl1.ActivePage := TabSheet1;
  Log.Clear;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
  TWinControl(PageControl1.ActivePage.Controls[0]).Visible := True;
end;

procedure TMainForm.WriteLog(var Msg: TMessage);
begin
  Log.Lines.Add(Concat(FormatDateTime('dd.mm.yy hh.nn.ss', Now), ' ', pAnsiChar(Msg.LParam)));
end;

{$ENDREGION}

end.
---------------------------
