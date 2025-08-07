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
  StdCtrls;

type
  TForm1 = class(TForm)
   lb: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    procedure SearchForDLL;
    procedure PrepareDLL(FileName: string);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  AnsiStrings;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SearchForDLL;
end;

procedure TForm1.PrepareDLL(FileName: string);
type
  TExtProc = function(const Data: array of variant): AnsiString; stdcall;

var
  i: Integer;
  Name: PAnsiChar;
  Data: AnsiString;
  ExtProc: TExtProc;
  S: String;
  ImageBase: dword;
  DosHeader: PImageDosHeader;
  var PName: PDWord;

begin
  ImageBase := LoadLibrary(PChar(FileName));
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
            ExtProc := GetProcAddress(ImageBase, name);
            S := Name;
            If not ContainsText(S, 'wrapper') then
            begin
              Data := ExtProc([True]);
              lb.Items.Add(concat('   ', Name, ' (', Data, ')'));
              Data:='';
            end;
            inc(pname);
          end;
        end;
     end;
     FreeLibrary(ImageBase);
  end;
end;

procedure TForm1.SearchForDLL;
var SearchResult: TSearchRec;
begin
  If FindFirst('*.dll', faAnyFile, SearchResult) = 0 then
  begin
    repeat
      lb.Items.Add(SearchResult.Name);
      PrepareDll(SearchResult.Name);
    until FindNext(SearchResult) <> 0;
  end;
  FindClose(SearchResult);
end;

end.
---------------------------
