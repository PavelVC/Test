library DllTest1;

uses
  ShareMem,
  System.SysUtils,
  System.Classes,
  IOUtils,
  StrUtils,
  uMethodThread in 'uMethodThread.pas';

type
   tLogProc = procedure(Mess: string) of object;

function FindFiles(const Data: array of variant; LogProc: tLogProc): ansistring; stdcall;
begin
  If (Length(Data) = 0) then
    Result := 'TFindFilesFrame'
  else
  begin
    LogProc('������� TFindFilesFrame ' + Data[0] + ' ��������');
    Result := '';
    For var Sl: string in string(Data[1]).Split([',']) do
    begin
      var FileArray: TArray<string> := TDirectory.GetFiles(Data[0], Trim(Sl), TSearchOption(Data[2]));
      Result := Result + Format('�� ����� %s%s ������� %d ������'#13#10, [Data[0], Trim(Sl), Length(Filearray)]);
      If Data[3] then for var S: string in FileArray do Result := Result + S + #13#10;
    end;
    LogProc('������� TFindFilesFrame ' + Data[0] + ' ���������');
  end;
end;

function FindStringInFile(const Data: array of variant; LogProc: tLogProc): ansistring; stdcall;
var S: AnsiString; K, L: Integer; Sx, Sl: string;
begin
  If (Length(Data) = 0) then
    Result := 'TFindStringInFileFrame'
  else
  begin
    LogProc('������� FindStringInFile ' + Data[0] + ' ��������');
    Result := '';
    For Sl in string(Data[1]).Split([',']) do
    begin
      Sx := Trim(Sl);
      var Fs: TFilestream := TFileStream.Create(Data[0], fmOpenRead);
      Fs.Position := 0;
      SetLength(S, Fs.Size);
      Fs.Read(S[1], Fs.Size);
      Fs.Free;
      L := 0;
      K := Pos(Sx, S, 1);
      while K > 0 do
      begin
        Inc(L);
        If Data[2] then Result := Concat(Result, Format('%.*X (%D)', [8, K, K]), #$0d#$0A);
        K := Pos(Sx, S, K + 1);
      end;
      Result := Concat(Result, '������� ', L.ToString, ' ��������� ������ "', Sx, '" � ����� ', Data[0], #$0D#$0A);
    end;
    LogProc('������� FindStringInFile ' + Data[0] + ' ���������');
  end;
end;

exports
  FindFiles,
  FindStringInFile;

begin
end.



