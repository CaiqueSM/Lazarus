program Naves_V1;

{$mode objfpc}{$H+}

uses
  game_controller,
  game_view,
  Naves_Library,
  graph,
  crt,
  SysUtils, FaseUm, FaseDois{ you can add units after this };

{$IFDEF WINDOWS}{$R teste.rc}{$ENDIF}

const {Para o modo grafico}
  Gdriver: smallint = Detect;
  Gmode: smallint   = 0;

var
 Score: integer = 0;
begin
  DetectGraph(Gdriver, Gmode);
  initGraph(Gdriver, Gmode, '');
  cenary(480, 640);
  Logo('NavesV1', 'Caique da Silva Machado');
  repeat
  GameMissionOne(Score);
  GameMissionTwo(Score);
  until not PlayAgain;
  ClearDevice;
  CloseGraph;
end.

