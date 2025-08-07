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
  System.Classes;

function GetData(const Data: array of variant): ansistring; stdcall;
begin
  If (TVarData(Data[0]).VType = vtBoolean) and Data[0] then
    Result := 'пераметр Data: string'
  else
    Result := Data[1] + ' test';
end;

function GetData2(const Data: array of variant): ansistring; stdcall;
begin
  If (TVarData(Data[0]).VType = vtBoolean) and Data[0] then
    Result := 'пераметр Data: string'
  else
    Result := Data[1] + ' test2';
end;

exports
  GetData,
  GetData2;

begin
end.
