library DllTest1;

uses
  ShareMem,
  System.SysUtils,
  System.Classes,
  IOUtils,
  StrUtils,
  uMethodThread in 'uMethodThread.pas',
  Windows;

Type
  TFindFilesThread = class(TAbstractMethodThread)
  private
    const
      cMainHandle = 0;
      cFrameHandle = 1;
      cPath = 2;
      cMask = 3;
      cRecurse = 4;
      cShowFiles = 5;
  protected
    procedure Execute; override;
  end;

  TFindStringInFileThread = class(TAbstractMethodThread)
  private
    const
      cMainHandle = 0;
      cFrameHandle = 1;
      cFileName = 2;
      cMask = 3;
      cShowResult = 4;
  protected
    procedure Execute; override;
  end;

{$REGION ' TFindFilesThread '}

procedure TFindFilesThread.Execute;
var Title, SRes: AnsiString;
begin
  Title := 'Задание TFindFilesFrame ' + Params[cPath];
  WriteLog(Params[cMainHandle], Title + ' запущено');
  For var SMask: string in string(Params[cMask]).Split([',']) do
  begin
    SRes := '';
    var FileArray: TArray<string> := TDirectory.GetFiles(Params[cPath], Trim(SMask), TSearchOption(Params[cRecurse]));
    SRes := SRes + Format('По маске %s%s найдено %d файлов'#13#10, [Params[cPath], Trim(SMask), Length(Filearray)]);
    If Params[cShowFiles] then for var Sx: string in FileArray do
    begin
      if BreakThread then Break;
      SRes := SRes + Sx + #13#10;
    end;
    if BreakThread then Terminate;
    WriteLog(Params[cFrameHandle], SRes);
  end;
  If BreakThread then
    WriteLog(Params[cMainHandle], Title + ' прервано')
  else
    WriteLog(Params[cMainHandle], Title + ' выполнено');
end;

var FindFilesThread: TFindFilesThread;

function FindFiles(const Data: array of variant): ansistring; stdcall;
begin
  If (Length(Data) = 0) then
    Result := 'TFindFilesFrame'
  else if AnsiString(Data[1]) = 'ThreadTerminate' then
    FindFilesThread.BreakThread := True
  else
  begin
    FindFilesThread := TFindFilesThread.Create(Data);
    FindFilesThread.Start;
  end;
end;

{$ENDREGION}

{$REGION ' TFindStringInFileThread '}

procedure TFindStringInFileThread.Execute;
var Title:AnsiString; L, K: cardinal; SRes: AnsiString;
begin
  Title := 'Задание FindStringInFile ' + Params[cFileName];
  WriteLog(cMainHandle,Title + ' запущено');
  For var SMask: AnsiString in string(Params[cMask]).Split([',']) do
  begin
    SRes := '';
    var Sx: AnsiString := Trim(SMask);
    var Fs: TFilestream := TFileStream.Create(Params[cFileName], fmOpenRead);
    Fs.Position := 0;
    var S:AnsiString;
    SetLength(S, Fs.Size);
    Fs.Read(S[1], Fs.Size);
    Fs.Free;
    L := 0;
    K := Pos(Sx, S, 1);
    while K > 0 do
    begin
      Inc(L);
      If Params[cShowResult] then SRes := Concat(SRes, Format('%.*X (%D)', [8, K, K]), #$0d#$0A);
      K := Pos(Sx, S, K + 1);
      If BreakThread then Break;
    end;
    If BreakThread then Break;
    SRes := Concat(Result, 'Найдено ', L.ToString, ' вхождений строки "', Sx, '" в файле ', Params[cFileName], #$0D#$0A, SRes);
    WriteLog(Params[cFrameHandle], SRes);
  end;
  If BreakThread then
    WriteLog(Params[cMainHandle], Title + ' прервано')
  else
    WriteLog(Params[cMainHandle], Title + ' выполнено');
end;

var FindStringInFileThread: TFindStringInFileThread;

function FindStringInFile(const Data: array of variant): ansistring; stdcall;
var S: AnsiString; K, L: Integer; Sx, SMask: string;
begin
  If (Length(Data) = 0) then
    Result := 'TFindStringInFileFrame'
  else if AnsiString(Data[1]) = 'ThreadTerminate' then
    FindStringInFileThread.BreakThread := True
  else
  begin
    FindStringInFileThread := TFindStringInFileThread.Create(Data);
    FindStringInFileThread.Start;
  end;
end;

{$ENDREGION}

exports
  FindFiles,
  FindStringInFile;

begin
end.



