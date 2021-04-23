unit tetramino_controller;

{$mode objfpc}{$H+}

interface

uses
  Tetramino_Source, Tetramino_Shape, Crt, graph;

procedure AddBlockInStage(var Board: Tbuffer; Block: TMatriz;
  LastPositionX, LastPositionY, Identity: integer);
procedure RemoveBlockInStage(var Board: Tbuffer; Block: TMatriz;
  LastPositionX, LastPositionY: integer);
function CheckMoveBlockInStageToDown(PositionY: integer; Direction: smallint): boolean;
function CheckMoveBlockInStageToLeft(PositionX: integer; Direction: smallint): boolean;
function CheckMoveBlockInStageToRigth(PositionX: integer; Direction: smallint): boolean;
procedure MoveBlockInStageToDown(var Block: Tetramino);
procedure MoveBlockInStageToLeft(var Block: Tetramino);
procedure MoveBlockInStageToRigth(var Block: Tetramino);
function DetectCollisionDown(var Board: Tbuffer; var Block: TMatriz;
  LastPositionX, LastPositionY: integer): boolean;
function DetectCollisionLeft(var Board: Tbuffer; var Block: TMatriz;
  LastPositionX, LastPositionY: integer): boolean;
function DetectCollisionRight(var Board: Tbuffer; var Block: TMatriz;
  LastPositionX, LastPositionY: integer): boolean;
function CanSpin(var Board: TBuffer; var Block: Tetramino): boolean;
function ChooseABlock: Tetramino;

implementation

procedure AddBlockInStage(var Board: Tbuffer; Block: TMatriz;
  LastPositionX, LastPositionY, Identity: integer);
var
  row, column: integer;
begin
  for row := 0 to Block.length - 1 do
  begin
    for column := 0 to Block.length - 1 do
    begin
      if (Block.Grid[row][column]) = 1 then
      begin
        Board[LastPositionY + row][LastPositionX + column] :=
          Identity{Block[row][column]};
      end;
    end;
  end;
end;

procedure RemoveBlockInStage(var Board: Tbuffer; Block: TMatriz;
  LastPositionX, LastPositionY: integer);
var
  row, column: integer;
begin

  for row := 0 to Block.length - 1 do
  begin
    for column := 0 to Block.length - 1 do
    begin
      if Block.Grid[row][column] = 1 then
        Board[LastPositionY + row][LastPositionX + column] := 0{False};
    end;
  end;
end;

function CheckMoveBlockInStageToDown(PositionY: integer; Direction: smallint): boolean;
begin
  if Direction = 4 then
  begin
    if PositionY < (rows - (Direction shr 1) + 1) then
    begin
      Result := True;
      exit;
    end;
  end
  else
  if Direction = 3 then
  begin
    if PositionY < (rows - (Direction - 1)) then
    begin
      Result := True;
      exit;
    end;
  end
  else
  if PositionY < (rows - (Direction + 1)) then
  begin
    Result := True;
    exit;
  end;
  Result := False;
end;

function CheckMoveBlockInStageToLeft(PositionX: integer; Direction: smallint): boolean;
begin
  if (Direction = 3) or (Direction = 4) then
  begin
    if PositionX > -1 then
    begin
      Result := True;
      exit;
    end;
  end
  else
  if PositionX > (0 - (Direction - 1)) then
  begin
    Result := True;
    exit;
  end;
  Result := False;
end;

function CheckMoveBlockInStageToRigth(PositionX: integer; Direction: smallint): boolean;
begin
  if Direction = 4 then
  begin
    if PositionX < (columns - Direction shr 2) then
    begin
      Result := True;
      exit;
    end;
  end
  else
  if Direction = 3 then
  begin
    if PositionX < (columns - (Direction - 1)) then
    begin
      Result := True;
      exit;
    end;
  end
  else
  if Direction = 2 then
  begin
    if PositionX < (columns - Direction) then
    begin
      Result := True;
      exit;
    end;
  end
  else
  begin
    if PositionX < (columns - (Direction + 2)) then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

procedure MoveBlockInStageToDown(var Block: Tetramino);
begin
  Block.PositionY := Block.PositionY + 1;
end;

procedure MoveBlockInStageToLeft(var Block: Tetramino);
begin
  Block.PositionX := Block.PositionX - 1;
end;

procedure MoveBlockInStageToRigth(var Block: Tetramino);
begin
  Block.PositionX := Block.PositionX + 1;
end;

function DetectCollisionDown(var Board: Tbuffer; var Block: TMatriz;
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
        if Board[LastPositionY + row + 1][LastPositionX + column] <> 0 then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
  end;
  Result := False;
end;

function DetectCollisionRight(var Board: Tbuffer; var Block: TMatriz;
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
        if Board[LastPositionY + row][LastPositionX + column + 1] <> 0 then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
  end;
  Result := False;
end;

function DetectCollisionLeft(var Board: Tbuffer; var Block: TMatriz;
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
        if Board[LastPositionY + row][LastPositionX + column - 1] <> 0 then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
  end;
  Result := False;
end;

function CanSpin(var Board: TBuffer; var Block: Tetramino): boolean;
begin
  if Block.Direction = 2 then
  begin
    if not (DetectCollisionRight(Board, Block.Shape, Block.PositionX,
      Block.PositionY)) then
      if not (DetectCollisionLeft(Board, Block.Shape, Block.PositionX,
        Block.PositionY)) then
      begin
        Result := True;
        exit;
      end;
  end
  else
  begin
    if not (DetectCollisionDown(Board, Block.Shape, Block.PositionX,
      Block.PositionY)) then
    begin
      Result := True;
      exit;
    end;
  end;
  Result := False;
end;

function ChooseABlock: Tetramino;
var
  index: integer = 7;
begin
  case random(index) of
    0: Result := Tetramino_S.Create;
    1: Result := Quadrado.Create;
    2: Result := Tetramino_L.Create;
    3: Result := Tetramino_I.Create;
    4: Result := Tetramino_Linv.Create;
    5: Result := Tetramino_Z.Create;
    6: Result := Retangulo.Create;
    else
      Result := Retangulo.Create;
  end;
end;

end.

