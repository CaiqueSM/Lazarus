 {Feito por: Caique da silva machado em 06/01/2018}
 {Email: caique9machado@gmailcom}
program tetris_v4;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  Crt,
  graph,
  Tetramino_source,
  Tetramino_Shape,
  tetris_library,
  tetramino_controller { you can add units after this };

{$IFDEF WINDOWS}{$R tetris_v4.rc}{$ENDIF}
type
  TObjectArray = array[0..4096] of Tetramino;

const {Para o modo grafico}
  Gdriver: smallint = Detect;
  Gmode: smallint   = 0;

var
  Board:  Stage;
  Blocks: TObjectArray;
  key:    integer;

begin
  DetectGraph(Gdriver, Gmode);
  initGraph(Gdriver, Gmode, '');
  cenary;
  Board     := Stage.Create;
  Blocks[0] := Tetramino_S.Create;
  AddBlockInStage(Board.Grid, Blocks[0].Grid);
  while True do
  begin
    if keypressed then
    begin
      key := Ord(lowercase(readkey));
      RemoveBlockInStage(Board.Grid, Blocks[0].Grid, Blocks[0].PositionX,
        Blocks[0].PositionY);
      cleardevice;
      cenary;
      case key of
        Ord('s'): MoveBlockInStageDown(Blocks[0]);
        Ord('a'): MoveBlockInStageLeft(Blocks[0]);
        Ord('d'): MoveBlockInStageRigth(Blocks[0]);
        32: SpinBlockInStage(Blocks[0]);
      end;
      AddBlockInStage(Board.Grid, Blocks[0].Grid, Blocks[0].PositionX, Blocks[0].PositionY);
    end;
    DrawStage(Board.Grid, Blocks[0].Color);
    if key = 27 then
      break;
  end;
  Closegraph;
end.

