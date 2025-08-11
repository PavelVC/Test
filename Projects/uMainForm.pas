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
  tLibraries= class;
  TLibrary = class;

  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TaskList: TListBox;
//    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    Libraries: tLibraries;
    procedure AddPage(ImageBase: DWORD; PName: PDWORD);
    procedure AddPages(FileName: string);
  public
    constructor Create(AOwner: tComponent); override;
    destructor Destroy; override;
  end;

  tLibraries = class(tStringList)
  private
    Methods: tStringList;
    function GetMethod(LibraryName, MethodName: string): pointer;
  public
    property Method[LibraryName, MethodName: string]: pointer read GetMethod;
    constructor Create;
    destructor Destroy; override;
  end;

  TLibrary = class(tStringList)
  private
    ImageBase: dword;
    Description: string;
  public
    constructor Create(LibraryName: string);
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  IOUtils,
  AnsiStrings, uAbstractFrame;

{$REGION ' TMainForm '}

type
 TExtProc = function(const Data: array of variant): AnsiString; stdcall;

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

constructor TMainForm.Create(AOwner: tComponent);
begin
  inherited;
end;

destructor TMainForm.Destroy;
begin
  Libraries.Free;;
  inherited;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  var FileArray: TArray<string> := TDirectory.GetFiles(ExtractFilePath(ParamStr(0)), '*.dll');
  for var S: string in FileArray do AddPages(S);
  PageControl1.ActivePage := TabSheet1;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
  TWinControl(PageControl1.ActivePage.Controls[0]).Visible := True;
end;

{$ENDREGION}

{$REGION ' tLibraries '}

constructor tLibraries.Create;
begin
end;

destructor tLibraries.Destroy;
begin
  For var i: integer := 0 to Pred(Count) do Objects[I].Free;
  inherited;
end;

function tLibraries.GetMethod(LibraryName, MethodName: string): pointer;
var Lib: TLibrary;
begin
  Lib := TLibrary(Objects[IndexOfName(LibraryName)]);
  Result := Lib.Objects[Lib.IndexOfName(MethodName)];
end;

{$ENDREGION}

{$REGION ' TLibrary '}

constructor TLibrary.Create(LibraryName: string);
var
  I: integer;
  Name: PAnsiChar;
  Data: AnsiString;
  ExtProc: pointer;
  S: String;
  DosHeader: PImageDosHeader;
  PName: PDWord;
begin
  ImageBase := LoadLibrary(@LibraryName[1]);
  if (ImageBase <> 0) then
  begin
     DosHeader := PImageDosHeader(ImageBase);
     if (DosHeader^.e_magic = IMAGE_DOS_SIGNATURE) then
     begin
       var PEHeader: PImageNtHeaders := PImageNtHeaders(DWord(ImageBase) + DWord(DosHeader^._lfanew));
       if (PEHeader^.Signature = IMAGE_NT_SIGNATURE) then
       begin
         var PExport: PImageExportDirectory := PImageExportDirectory(ImageBase + DWord(PEHeader^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress));
         PName := PDWord(ImageBase + DWord(PExport^.AddressOfNames));
         For i := 0 to PExport^.NumberOfNames - 1 do
          begin
            name := PAnsiChar(PDWord(DWord(ImageBase) + PDword(pname)^));
            S := Name;
            If not ContainsText(S, 'wrapper') then
            begin
              ExtProc := GetProcAddress(ImageBase, name);
              AddObject(name, TObject(ExtProc));
              Data := TExtProc(ExtProc)([]);
              MainForm.TaskList.Items.Add(concat('   ', Name, ' (', Data, ')'));
              Data:='';
            end;
            inc(pname);
          end;
        end;
     end;
  end;
end;

destructor TLibrary.Destroy;
begin
  inherited;
  FreeLibrary(ImageBase);
end;

{$ENDREGION}

end.
---------------------------
