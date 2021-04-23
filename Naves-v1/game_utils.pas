unit game_utils;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, crt, graph, game_controller;

procedure cenary(x, y: integer);
procedure Pause;
procedure logo(GameName, AuthorName: string);
function PlayAgain: boolean;

implementation

{DESENHA O CENARIO}
procedure cenary(x, y: integer);
begin
  setcolor(white);
  settextstyle(0, 0, 0);
  rectangle(0, 0, x, y);
end;

{PAUSA O JOGO}
procedure Pause;
var
  Buffer: char;
begin
  repeat
    settextstyle(0, 0, 6);
    setcolor(white);
    SetFillStyle(11, Blink);
    bar(1, 1, 320, 480);
    outtextXY(48, 200, 'PAUSE');
    Buffer := lowercase(readkey);
  until Buffer = 'p';
end;

{LOGOTIPO}
procedure logo(GameName, AuthorName: string);
var
  i, j: integer;
begin
  settextstyle(0, 0, 6);
  outtextxy(16, 8, GameName);
  settextstyle(0, 0, 0);
  outtextxy(144, 116, 'v1.0');
  outtextxy(112, 132, 'programming:');
  randomize;
  repeat
    for i := 1 to length(AuthorName) do
    begin
      for j := 637 downto 60 + i * 8 do
      begin
        setcolor(BLINK);
        if AuthorName[i] <> ' ' then
        begin
          outTextxy(j, 148, AuthorName[i]);
          delay(1);
          setcolor(black);
          outtextxy(j, 148, AuthorName[i]);
        end
        else
          continue;
        if keypressed then
          break;
      end;
      setcolor(BLINK);
      outtextxy(60 + i * 8, 148, AuthorName[i]);
      if keypressed then
        break;
    end;
    outtextxy(68, 148, AuthorName);
    setcolor(WHITE);
    outtextXY(116, 200, 'CONTROLES');
    outtextXY(68, 216, 'A: MOVE PARA ESQUERDA');
    outtextXY(68, 232, 'D: MOVE PARA DIREITA');
    outtextXY(68, 248, 'S: MOVE PARA BAIXO');
    outtextXY(68, 264, 'ESPAÇO: GIRA A PEÇA');
    for i := 0 to 64 do
    begin
      outtextxy(72, 300, 'Precione uma tecla');
      setcolor(random(15) + 1);
      delay(4);
    end;
    delay(5000);
  until keypressed;
end;

function PlayAgain: boolean;
var
  key: integer;
begin
  outTextXY(48, 264, 'Press [ENTER] to continue or');
  outTextXY(64, 280, 'Press [ESC] to exit.');
  key := Ord(readkey);
  case key of
    27: Result := False;
    13: Result := True;
  end;
end;

function MoveDown(var Board: Stage; var Block: Person): boolean;
begin
  if not DetectCollisionDown(Board.Grid, Block.Shape, Block.PositionX,
    Block.PositionY) then
    if CheckMoveBlockInStageToDown(Block.PositionY, Block.Direction) then
    begin
      MoveBlockInStageToDown(Block);
      Result := False;
    end
    else
      Result := True;
end;

procedure MoveLeft(var Board: Stage; var Block: Person);
begin
  if not DetectCollisionLeft(Board.Grid, Block.Shape, Block.PositionX,
    Block.PositionY) then
    if CheckMoveBlockInStageToLeft(Block.PositionX, Block.Direction) then
      MoveBlockInStageToLeft(Block);
end;

procedure MoveRigth(var Board: Stage; var Block: Person);
begin
  if not DetectCollisionRight(Board.Grid, Block.Shape, Block.PositionX,
    Block.PositionY) then
    if CheckMoveBlockInStageToRigth(Block.PositionX, Block.Direction) then
      MoveBlockInStageToRigth(Block);
end;

procedure GamePad(key: integer; var Board: Stage; var Block: Person);
begin
  case key of
    Ord('s'):
    begin
      crash := MoveDown(Board, Blocks);
    end;
    Ord('a'):
    begin
      MoveLeft(Board, Block);
    end;
    Ord('d'):
    begin
      MoveRigth(Board, Block);
    end;
    32:
    begin
      if CanSpin(Board.Grid, Block) then
        Block.Spin;
    end;
    Ord('p'):
    begin
      pause;
      Draw(Board, Blocks, position);
    end;
  end;
end;

end.

