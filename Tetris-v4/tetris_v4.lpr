 {Feito por: Caique da silva machado em 06/01/2018}
 {Email: caique9machado@gmailcom}
program tetris_v4;

{$mode objfpc}{$H+}

uses
  Crt,
  graph,
  Tetramino_source,
  tetramino_shape,
  tetris_library,
  tetramino_controller,
  Stage_Controller { you can add units after this };

{$IFDEF WINDOWS}{$R tetris_v4.rc}{$ENDIF}
type
  TObjectArray = array[0..4096] of Tetramino;

const {Para o modo grafico}
  Gdriver: smallint = Detect;
  Gmode: smallint   = 0;

  function MoveDown(var Board: Stage; var Block: Tetramino): boolean;
  begin
    if not DetectCollisionDown(Board.Grid, Block.Shape, Block.PositionX,
      Block.PositionY) then
    begin
      if CheckMoveBlockInStageToDown(Block.PositionY, Block.Direction) then
      begin
        MoveBlockInStageToDown(Block);
        Result := False;
      end;
    end
    else
      Result := True;
  end;

  procedure MoveLeft(var Board: Stage; var Block: Tetramino);
  begin
    if not DetectCollisionLeft(Board.Grid, Block.Shape, Block.PositionX,
      Block.PositionY) then
      if CheckMoveBlockInStageToLeft(Block.PositionX, Block.Direction) then
        MoveBlockInStageToLeft(Block);
  end;

  procedure MoveRigth(var Board: Stage; var Block: Tetramino);
  begin
    if not DetectCollisionRight(Board.Grid, Block.Shape, Block.PositionX,
      Block.PositionY) then
      if CheckMoveBlockInStageToRigth(Block.PositionX, Block.Direction) then
        MoveBlockInStageToRigth(Block);
  end;

  procedure Draw(var Board: Stage; var Blocks: TObjectArray; LastPos: integer);
  var
    index: integer;
  begin
    cleardevice;
    cenary(321, 481);
    for index := 0 to LastPos do
      DrawStage(Board.Grid, Blocks[index].Color, Blocks[index].Identity);
  end;

  function run(): boolean;
  var
    Board:    Stage;
    Blocks:   TObjectArray;
    Lines:    ArrayOfLines;
    key:      integer = 0;
    crash:    boolean = False;
    position: integer = 0;
    points:   integer = 0;
    StartPos: integer = 8;
    Quit:     boolean = False;
    Time:     integer = 400;
    CleanLines: integer = 0;
  begin
    cenary(321, 481);
    logo('Caique da Silva Machado');
    Board    := Stage.Create;
    Lines[0] := MaxInt;
    randomize;
    cleardevice;
    while not Quit do
    begin
      Blocks[position] := ChooseABlock;
      Blocks[position].PositionX := StartPos;
      Blocks[position].Identity := position + 1;
      if EndGame(Board.Grid, Blocks[position].Shape, Blocks[position].PositionX,
        Blocks[position].PositionY) then
      begin
        break;
      end;
      AddBlockInStage(Board.Grid, Blocks[position].Shape, Blocks[position].PositionX,
        Blocks[position].PositionY, Blocks[position].Identity);
      while True do
      begin
        if keypressed then
        begin
          key := Ord(lowercase(readkey));
          HideBlockInStage(Board.Grid, Blocks[position].Identity);
          RemoveBlockInStage(Board.Grid, Blocks[position].Shape,
            Blocks[position].PositionX,
            Blocks[position].PositionY);
          cenary(321, 481);
          case key of
            Ord('s'):
            begin
              crash := MoveDown(Board, Blocks[position]);
            end;
            Ord('a'):
            begin
              MoveLeft(Board, Blocks[position]);
            end;
            Ord('d'):
            begin
              MoveRigth(Board, Blocks[position]);
            end;
            32:
            begin
              if CanSpin(Board.Grid, Blocks[position]) then
                Blocks[position].Spin;
            end;
            Ord('p'):
            begin
              pause;
              Draw(Board, Blocks, position);
            end;
          end;
          AddBlockInStage(Board.Grid, Blocks[position].Shape, Blocks[position].PositionX,
            Blocks[position].PositionY, Blocks[position].Identity);
          DrawStage(Board.Grid, Blocks[position].Color, Blocks[position].Identity);
        end;
        HideBlockInStage(Board.Grid, Blocks[position].Identity);
        RemoveBlockInStage(Board.Grid, Blocks[position].Shape,
          Blocks[position].PositionX,
          Blocks[position].PositionY);
        crash := MoveDown(Board, Blocks[position]);
        AddBlockInStage(Board.Grid, Blocks[position].Shape, Blocks[position].PositionX,
          Blocks[position].PositionY, Blocks[position].Identity);
        DrawStage(Board.Grid, Blocks[position].Color, Blocks[position].Identity);
        Score(Lines, points, CleanLines);
        Lines[0] := MaxInt;
        if (key = 27) then
        begin
          Quit := True;
          break;
        end;
        if crash then
        begin
          break;
        end;
        delay(Time - CleanLines);
      end;
      crash := False;
      Lines := CheckLines(Board.Grid);
      EraseLines(Board.Grid, Lines);
      OrganizeStage(Board.Grid, Lines);
      Draw(Board, Blocks, position);
      Inc(position);
    end;
    PaintHighScore(Points, 321, 481);
    Result := PlayAgain();
    ClearDevice;
  end;

begin
  DetectGraph(Gdriver, Gmode);
  initGraph(Gdriver, Gmode, '');
  while True do
  begin
    if not Run() then
      break;
  end;
  Closegraph;
end.

