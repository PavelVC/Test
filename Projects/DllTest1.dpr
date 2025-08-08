library DllTest1;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters.

  Important note about VCL usage: when this DLL will be implicitly
  loaded and this DLL uses TWicImage / TImageCollection created in
  any unit initialization section, then Vcl.WicImageInit must be
  included into your library's USES clause. }

uses
  ShareMem,
  System.SysUtils,
  System.Classes,
  IOUtils;

function GetData(const Data: array of variant): ansistring; stdcall;
begin
  If (Length(Data) = 0) then
    Result := 'пераметр Data: string'
  else
    Result := Data[1] + ' test';
end;

function GetData2(const Data: array of variant): ansistring; stdcall;
begin
  If (Length(Data) = 0) then
    Result := 'пераметр Data: string'
  else
    Result := Data[1] + ' test2';
end;

function FindFiles(const Data: array of variant): ansistring; stdcall;
begin
  If (Length(Data) = 0) then
    Result := 'пераметры Path: string; FileName: string; Recursive: byte'
  else
  begin
    var FileArray: TArray<string> := TDirectory.GetFiles(Data[0], Data[1], TSearchOption(Data[2]));
    Result := Format('По маске %s%s найдено %d файлов'#13#10, [Data[0], Data[1], Length(Filearray)]);
    for var S: string in FileArray do Result := Result + S + #13#10;
  end;
end;

exports
  GetData,
  GetData2,
  FindFiles;

begin
end.
