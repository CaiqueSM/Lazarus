unit Tetramino_Shape;

{$mode objfpc}{$H+}

interface

uses
  Tetramino_source;

type

  Tetramino_S = class(Tetramino)
  public
    constructor Create;
  end;

  Tetramino_L = class(Tetramino)
  public
    constructor Create;
  end;

  Tetramino_I = class(Tetramino)
  public
    constructor Create;
    procedure Spin; override;
  end;

  Quadrado = class(Tetramino)
  public
    constructor Create;
    procedure Spin; override;
  end;

  Retangulo = class(Tetramino)
  public
    constructor Create;
  end;

  Tetramino_Linv = class(Tetramino)
  public
    constructor Create;
  end;

  Tetramino_Z = class(Tetramino)
  public
    constructor Create;
  end;

implementation

constructor Tetramino_S.Create();
begin
  {S em pé}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[0][1] := 1;
  Shape.Grid[1][1] := 1;
  Shape.Grid[1][2] := 1;
  Shape.Grid[2][1] := 1;
  Shape.Grid[2][2] := 1;
  Shape.Grid[3][2] := 1;
  Color      := 14;
  Direction  := 2;{vertical}
end;

constructor Tetramino_L.Create();
begin
  {L}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[0][1] := 1;
  Shape.Grid[1][1] := 1;
  Shape.Grid[2][1] := 1;
  Shape.Grid[3][1] := 1;
  Shape.Grid[3][2] := 1;
  Color      := 13;
  Direction  := 2;
end;

constructor Tetramino_I.Create();
begin
  {I}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[0][1] := 1;
  Shape.Grid[1][1] := 1;
  Shape.Grid[2][1] := 1;
  Shape.Grid[3][1] := 1;
  Color      := 12;
  Direction  := 4;
end;

procedure Tetramino_I.Spin;
var
  row, column: integer;
  Buffer:      TMatriz;

begin
  Buffer:= TMatriz.Create(Shape.Length);
  SetFalseTetraminoGrid(Buffer);
  for row := 0 to Shape.length - 1 do
  begin
    for column := 0 to Shape.length - 1 do
    begin
      if (Shape.Grid[row][column]) = 1 then
        Buffer.Grid[column + (Direction shr 2)][abs((row + 1) - Shape.length)] := 1;
    end;
  end;
  case Direction of
    1: Direction := Direction shl 2;
    4: Direction := Direction shr 2;
  end;
  SetFalseTetraminoGrid(Shape);
  Shape := Buffer;
end;

constructor Quadrado.Create();
begin
  {Quadrado}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[1][1] := 1;
  Shape.Grid[1][2] := 1;
  Shape.Grid[2][1] := 1;
  Shape.Grid[2][2] := 1;
  Color      := 8;
  Direction  := 3;
end;

procedure Quadrado.Spin;
begin
  Direction := 3;
end;

constructor Retangulo.Create();
begin
  {RETANGULO}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[1][0] := 1;
  Shape.Grid[1][1] := 1;
  Shape.Grid[1][2] := 1;
  Shape.Grid[1][3] := 1;
  Shape.Grid[2][0] := 1;
  Shape.Grid[2][1] := 1;
  Shape.Grid[2][2] := 1;
  Shape.Grid[2][3] := 1;
  Color      := 10;
  Direction  := 1;{horizontal}
end;

constructor Tetramino_Linv.Create();
begin
  {L invertido}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[0][2] := 1;
  Shape.Grid[1][2] := 1;
  Shape.Grid[2][2] := 1;
  Shape.Grid[3][1] := 1;
  Shape.Grid[3][2] := 1;
  Color      := 9;
  Direction  := 2;
end;

constructor Tetramino_Z.Create();
begin
  {Z}
  inherited Create();
  SetFalseTetraminoGrid(Shape);
  Shape.Grid[1][0] := 1;
  Shape.Grid[1][1] := 1;
  Shape.Grid[1][2] := 1;
  Shape.Grid[2][1] := 1;
  Shape.Grid[2][2] := 1;
  Shape.Grid[2][3] := 1;
  Color      := 6;
  Direction  := 1;
end;

end.

