unit Tetramino_source;

{$mode objfpc}{$H+}

interface

const
  rows    = 29;
  columns = 19;

type
  Row    = array of integer;
  Column = array of Row;

  TMatriz = class
  private
    TMatrizGrid:   Column;
    TMatrizLength: integer;
  public
    property Grid: Column Read TMatrizGrid Write TMatrizGrid;
    property Length: integer Read TMatrizLength;
  public
    constructor Create(Len: integer);
    procedure ReSize(Len: integer);
    destructor Destroy(); override;
  end;

  TBuffer = array[0..rows, 0..columns] of integer;

  Tetramino = class

  private
    TetraminoColor:     byte;
    TetraminoGrid:      TMatriz;
    TetraminoState:     boolean;
    TetraminoDirection: word;
    TetraminoPositionX: integer;
    TetraminoPositionY: integer;
    TetraminoIdentity:  integer;

  protected
    procedure SetFalseTetraminoGrid(var Shape: TMatriz);

  public
    property Color: byte Read TetraminoColor Write TetraminoColor;
    property Direction: word Read TetraminoDirection Write TetraminoDirection;
    property Shape: TMatriz Read TetraminoGrid Write TetraminoGrid;
    property State: boolean Read TetraminoState Write TetraminoState;
    property PositionX: integer Read TetraminoPositionX Write TetraminoPositionX;
    property PositionY: integer Read TetraminoPositionY Write TetraminoPositionY;
    property Identity: integer Read TetraminoIdentity Write TetraminoIdentity;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Spin; virtual;
  end;

  Stage = class

  private
    StageGrid: TBuffer;

  private
    procedure SetFalseStageGrid(var Grid: TBuffer);

  public
    property Grid: TBuffer Read StageGrid Write StageGrid;

  public
    constructor Create;
  end;

implementation
{Tetramino}
constructor Tetramino.Create;
begin
  PositionX := 0;
  PositionY := 0;
  Shape:= TMatriz.Create(4);
end;

destructor Tetramino.Destroy; overload;
begin
  Dispose(Pinteger(Self));
end;

procedure Tetramino.SetFalseTetraminoGrid(var Shape: TMatriz);
var
  row, column: integer;
begin
  for row := 0 to Shape.length - 1 do
    for column := 0 to Shape.length - 1 do
      Shape.Grid[row][column] := 0;
end;

procedure Tetramino.Spin;

var
  row, column: integer;
  Buffer:      TMatriz;

begin
  Buffer:= TMatriz.Create(Shape.Length);
  SetFalseTetraminoGrid(Buffer);
  for row := 0 to Shape.Length - 1 do
  begin
    for column := 0 to Shape.Length - 1 do
    begin
      if (Shape.Grid[row][column]) = 1 then
        Buffer.Grid[column][abs((row + 1) - Buffer.Length)] := 1;
    end;
  end;
  case Direction of
    1: Direction := Direction shl 1;
    2: Direction := Direction shr 1;
  end;
  SetFalseTetraminoGrid(Shape);
  Shape := Buffer;
end;
{Stage}
procedure Stage.SetFalseStageGrid(var Grid: TBuffer);
var
  row, column: integer;
begin
  for row := 0 to rows do
    for column := 0 to columns do
      Grid[row][column] := 0;
end;

constructor Stage.Create;
begin
  SetFalseStageGrid(Self.Grid);
end;
{TMatriz}
constructor TMatriz.Create(Len: integer);
begin
  TMatrizLength := Len;
  ReSize(Len);
end;

procedure TMatriz.ReSize(Len: integer);
var
  index: integer;
begin
  TMatrizLength := Len;
  SetLength(Grid, Len);
  for index := 0 to Len - 1 do
  begin
    SetLength(Grid[index], Len);
  end;
end;

destructor TMatriz.Destroy();
begin
  Grid := nil;
end;

end.

