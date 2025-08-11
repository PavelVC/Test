unit Unit1;

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
  StdCtrls, Vcl.ComCtrls;

type
  TExtProc = function(const Data: array of variant): AnsiString; stdcall;
  tLibraries= class;
  TLibrary = class;

  TMainForm = class(TForm)
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TaskList: TListBox;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    Libraries: tLibraries;
    procedure SearchForDLL;
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
  AnsiStrings;

{$REGION ' TMainForm '}

procedure TMainForm.Button1Click(Sender: TObject);
var I: integer; Sa: string; P: pointer; Tab: TTabSheet; Memo: TMemo;
begin
  P := Libraries.Method['DllTest1.dll', 'FindFiles'];
  Sa := tExtProc(P)(['D:\Projects\', '*.*', 1]);
  Tab := TTabSheet.Create(PageControl1);
  with Tab do
  begin
    Visible :=True;
    Caption := 'Поиск файлов...';
    PageControl := PageControl1;
    PageControl1.ActivePage := Tab;
  end;
  Memo := TMemo.Create(Tab);
  Memo.Parent := Tab;
  Memo.Align := alClient;
  Memo.Text := Sa;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var I: integer; Sa: string; P: pointer; Tab: TTabSheet; Memo: TMemo;
begin
  P := Libraries.Method['DllTest1.dll', 'FindStringInFile'];
  Sa := tExtProc(P)(['D:\Заблудившийся\VIDEO_TS\VTS_06_1.VOB','34']);
  Tab := TTabSheet.Create(PageControl1);
  with Tab do
  begin
    Visible :=True;
    Caption := 'Поиск подстроки...';
    PageControl := PageControl1;
    PageControl1.ActivePage := Tab;
  end;
  Memo := TMemo.Create(Tab);
  Memo.Parent := Tab;
  Memo.Align := alClient;
  Memo.Text := Sa;
end;

constructor TMainForm.Create(AOwner: tComponent);
begin
  inherited;
  Libraries := tLibraries.Create;
end;

destructor TMainForm.Destroy;
begin
  Libraries.Free;;
  inherited;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SearchForDLL;
end;

procedure TMainForm.SearchForDLL;
var SearchResult: TSearchRec;
begin
end;

procedure TMainForm.TabControl1Change(Sender: TObject);
begin

end;

{$ENDREGION}

{$REGION ' tLibraries '}

constructor tLibraries.Create;
var I:integer;
begin
  var FileArray: TArray<string> := TDirectory.GetFiles('.', '*.dll');
  for var S: string in FileArray do AddObject(ExtractFileName(S), TLibrary.Create(S));
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

{ TLibrary }

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

end.
---------------------------
