unit game_view;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, crt, graph;

procedure cenary(x, y: integer);
procedure Pause(x, y: integer);
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
procedure Pause(x, y: integer);
var
  Buffer: char;
begin
  repeat
    settextstyle(0, 0, 6);
    setcolor(white);
    SetFillStyle(11, Blink);
    bar(1, 1, x - 1, y - 1);
    outtextXY(((x div 2) - 112), ((y div 2) - 60), 'PAUSE');
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
  SetTextStyle(0,0,1);
  outTextXY(112, 248, 'GAME OVER');
  outTextXY(48, 264, 'Press [Y] to continue or');
  outTextXY(72, 280, 'Press [N] to exit.');
  repeat
    key := Ord(lowercase(readkey));
  until key in [Ord('n'), Ord('y')];
  case key of
    Ord('n'): Result := False;
    Ord('y'): Result := True;
  end;
end;

end.

