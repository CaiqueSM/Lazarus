unit Stage_Controller;

{$mode objfpc}{$H+}

interface

uses
  Tetramino_source, graph, SysUtils;

type
  ArrayOfLines = array[0..255] of integer;

function CheckLines(var Board: TBuffer): ArrayOfLines;
procedure EraseLines(var Board: TBuffer; NumberOfLine: ArrayOfLines);
procedure OrganizeStage(var Board: TBuffer; NumberOfLine: ArrayOfLines);
procedure DrawStage(var Board: TBuffer; Color: byte; Identity: integer);
function EndGame(var Board: TBuffer; Block: TMatriz;
  LastPositionX, LastPositionY: integer): boolean;
procedure Score(Line: ArrayOfLines; out TotalPoints: integer; var CleanLines: integer);
procedure HideBlockInStage(var Board: TBuffer; Identity: integer);

implementation

function CheckLines(var Board: TBuffer): ArrayOfLines;
var
  row, column, index: integer;
  FullLine: boolean;
begin
  index := -1;
  for row := 0 to length(Board) - 1 do
  begin
    FullLine := True;
    for column := 0 to length(Board[0]) - 1 do
    begin
      if Board[row][column] = 0 then
        FullLine := False;
    end;
    if FullLine then
    begin
      Inc(index);
      Result[index] := row;
    end;
  end;
  Result[index + 1] := MaxInt;
end;

procedure EraseLines(var Board: TBuffer; NumberOfLine: ArrayOfLines);
var
  row, column: integer;
begin
  row := 0;
  while NumberOfLine[row] <> MaxInt do
  begin
    for column := 0 to length(Board[0]) - 1 do
    begin
      Board[NumberOfLine[row]][column] := 0;
    end;
    Inc(row);
  end;
end;

procedure OrganizeStage(var Board: TBuffer; NumberOfLine: ArrayOfLines);
var
  column, row, index, LastLine, Count: integer;
begin
  index := 0;
  Count := 1;
  while NumberOfLine[index] <> MaxInt do
  begin
    LastLine := NumberOfLine[index];
    Inc(index);
  end;
  if index = 0 then
    exit;
  for row := 1 to index do
  begin
    if abs(NumberOfLine[index - row] - NumberOfLine[index - (row + 1)]) = 1 then
      Inc(Count)
    else
      break;
  end;
  for row := LastLine downto Count do
  begin
    for column := 0 to length(Board[0]) - 1 do
    begin
      Board[row][column] := Board[row - Count][column];
    end;
  end;
end;

procedure DrawStage(var Board: TBuffer; Color: byte; Identity: integer);
var
  row, column: integer;
  x, y: integer;
begin
  x := 0;
  y := 0;
  for row := 0 to rows do
  begin
    for column := 0 to columns do
    begin
      if Board[row][column] = Identity then
      begin
        Setfillstyle(1, Color);
        bar(x, y, x + 16, y + 16);
        rectangle(x, y, x + 16, y + 16);
      end;
      x := x + 16;
    end;
    x := 0;
    y := y + 16;
  end;
end;

procedure HideBlockInStage(var Board: TBuffer; Identity: integer);
begin
  SetColor(Black);
  DrawStage(Board, Black, Identity);
  SetColor(white);
end;

function EndGame(var Board: Tbuffer; Block: TMatriz;
  LastPositionX, LastPositionY: integer): boolean;
var
  row, column: integer;
begin
  for row := 0 to Block.length - 1 do
  begin
    for column := 0 to Block.length - 1 do
    begin
      if Block.Grid[row][column] = 1 then
      begin
        if Board[LastPositionY + row][LastPositionX + column] <> 0 then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
  end;
  Result := False;
end;

procedure Score(Line: ArrayOfLines; out TotalPoints: integer; var CleanLines: integer);
var
  index: integer = 0;
begin
  while Line[index] <> MaxInt do
  begin
    TotalPoints += 100;
    Inc(index);
    Inc(CleanLines);
  end;
  settextstyle(0, 0, 1);
  setcolor(white);
  outtextXY(120, 500, 'SCORE: ' + IntToStr(TotalPoints));
end;

end.

