unit FaseDois;

{$mode objfpc}{$H+}

interface

uses
  game_models,
  game_controller,
  game_view,
  Naves_Library,
  graph,
  crt,
  SysUtils, MMSystem;

type
  TShotArray = array[0..65535] of Shot;

procedure GameMissionTwo(var Score: integer);

implementation

procedure GameMissionTwo(var Score: integer);
var
  Board:  Stage;
  Tank:   player;
  TheMotherShip: MotherShip;
  Shots:  TShotArray;
  Key:    integer = 0;
  i:      integer;
  indexShot: integer = -1;
  ToLeft: boolean;
  ToRight: boolean;
begin
  Board := Stage.Create(39, 19);
  Tank  := player.Create(3, 3);
  Tank.Identity := 2;
  Tank.PositionX := Board.Grid.LengthN mod 2;
  Tank.PositionY := Board.Grid.LengthM - 3;
  Cenary(Board.Grid.LengthN * 16, Board.Grid.LengthM * 16);
  AddBlockInStage(Board.Grid, Tank.Shape, Tank.PositionX, Tank.PositionY,
    Tank.Identity);
  TheMotherShip := MotherShip.Create;
  ToRight := False;
  ToLeft  := True;
  TheMotherShip.Identity := 3;
  TheMotherShip.PositionX := Tank.PositionX;
  TheMotherShip.PositionY := 0;
  AddBlockInStage(Board.Grid, TheMotherShip.Shape, TheMotherShip.PositionX,
    TheMotherShip.PositionY,
    TheMotherShip.Identity);
  Drawstage(Board.Grid, Tank.Color, Tank.Identity);
  Drawstage(Board.Grid, TheMotherShip.Color, TheMotherShip.Identity);
  while Tank.State and TheMotherShip.State do
  begin
    ClearDevice;
    Cenary(Board.Grid.LengthN * 16, Board.Grid.LengthM * 16);
    if keypressed then
    begin
      RemoveBlockInStage(Board.Grid, Tank.Shape, Tank.PositionX, Tank.PositionY);
      RemoveBlockInStage(Board.Grid, TheMotherShip.Shape, TheMotherShip.PositionX,
      TheMotherShip.PositionY);
      Key := Ord(lowercase(readkey));
      if Key = Ord('p') then
        pause(Board.Grid.LengthN * 16, Board.Grid.LengthM * 16);
      if Key = Ord('a') then
      begin
        moveLeft(Board, Tank);
        moveLeft(Board, TheMotherShip);
      end;
      if Key = Ord('d') then
      begin
        moveRight(Board, Tank);
        moveRight(Board, TheMotherShip);
      end;
      if Key = 13 then
      begin
        if Tank.CanShot then
        begin
          Inc(indexShot);
          Shots[indexShot] :=
            Shot.Create(Tank.attack, Tank.PositionX + 1, Tank.PositionY - 2);
          SndPlaySound('Sounds/SOUND58.wav', SND_ASYNC);
          Shots[indexShot].Identity := indexShot + 63;
          AddBlockInStage(Board.Grid, Shots[indexShot].Shape,
            Shots[indexShot].PositionX,
            Shots[indexShot].PositionY, Shots[indexShot].Identity);
          Shots[indexShot].Shooter(Tank);
          Inc(Tank.Blast);
          if Tank.Blast = 3 then
            Tank.CanShot := False;
        end;
      end;
      AddBlockInStage(Board.Grid, Tank.Shape, Tank.PositionX,
        Tank.PositionY, Tank.Identity);
    end;//fim keypressed.
    for i := 0 to indexShot do
    begin
      if Shots[i].State then
      begin
        RemoveBlockInStage(Board.Grid, Shots[i].Shape, Shots[i].PositionX,
          Shots[i].PositionY);
        if Shots[i].Owner is player then
        begin
          Shots[i].State := not MoveUp(Board, Shots[i]);
          if not Shots[i].State then
          begin
            //Writeln(Shots[i].PositionX, ' ', Shots[i].PositionY, ' fora');
            if ((Shots[i].PositionX >= TheMotherShip.PositionX) and
              (Shots[i].PositionX <= TheMotherShip.PositionX +
              TheMotherShip.Shape.LengthN)) and
              (Shots[i].PositionY = (TheMotherShip.PositionY +
              TheMotherShip.Shape.LengthM)) then
            begin
              //Writeln(Shots[i].PositionX, ' ', Shots[i].PositionY, ' dentro');
              TheMotherShip.Life := TheMotherShip.Life - Shots[i].Damage;
              SetTextStyle(0, 0, 3);
              OutTextXY(Shots[i].PositionX * 16, Shots[i].PositionY * 16,
                '+'+IntToStr(Shots[i].Damage));
              Score := Score + Shots[i].Damage;
              if TheMotherShip.Life <= 0 then
              begin
                TheMotherShip.State := False;
                SndPlaySound('Sounds/Boom.wav', SND_ASYNC);
              end;
            end;
            Dec(Tank.Blast);
          end;
        end;
        if Shots[i].Owner is MotherShip then
        begin
          Shots[i].State := not MoveDown(Board, Shots[i]);
          if not Shots[i].State then
          begin
            if (Shots[i].PositionX >= Tank.PositionX) and
              (Shots[i].PositionX <= Tank.PositionX + Tank.Shape.LengthN) and
              (Tank.PositionY = Shots[i].PositionY - 1) then
            begin
              Tank.Life := Tank.Life - Shots[i].Damage;
              SetTextStyle(0, 0, 3);
              OutTextXY(Shots[i].PositionX * 16, Shots[i].PositionY * 16,
                '-'+IntToStr(Shots[i].Damage));
              if Tank.Life <= 0 then
                Tank.State := False;
            end;
            Dec(TheMotherShip.Blast);
          end;
        end;
        if Shots[i].State then
          AddBlockInStage(Board.Grid, Shots[i].Shape, Shots[i].PositionX,
            Shots[i].PositionY, Shots[i].Identity)
        else
          Shots[i].Owner.CanShot := True;
      end;
    end;//fim for.
    for i := 0 to indexShot do
      Drawstage(Board.Grid, Shots[i].Color, Shots[i].Identity);

    if (Tank.PositionX >= TheMotherShip.PositionX) and
      (Tank.PositionX <= TheMotherShip.PositionX + TheMotherShip.Shape.LengthN) then
    begin
      if TheMotherShip.CanShot then
      begin
        Inc(indexShot);
        Shots[indexShot] :=
          Shot.Create(TheMotherShip.attack, Tank.PositionX + Random(TheMotherShip.Blast),
          TheMotherShip.PositionY + 2);
        SndPlaySound('Sounds/SOUND58.wav', SND_ASYNC);
        Shots[indexShot].Identity := indexShot + 63;
        AddBlockInStage(Board.Grid, Shots[indexShot].Shape,
          Shots[indexShot].PositionX,
          Shots[indexShot].PositionY, Shots[indexShot].Identity);
        Shots[indexShot].Shooter(TheMotherShip);
        Inc(TheMotherShip.Blast);
        if TheMotherShip.Blast = 10 then
          TheMotherShip.CanShot := False;
      end;
    end;
    {if ToLeft then
      if not MoveLeft(Board, TheMotherShip) then
      begin
        ToLeft  := False;
        ToRight := True;
      end;
    if ToRight then
      if not MoveRight(Board, TheMotherShip) then
      begin
        ToLeft  := True;
        ToRight := False;
      end;}
    AddBlockInStage(Board.Grid, TheMotherShip.Shape, TheMotherShip.PositionX,
      TheMotherShip.PositionY, TheMotherShip.Identity);
    Drawstage(Board.Grid, Tank.Color, Tank.Identity);
    SetTextStyle(0, 0, 0);
    DrawStage(Board.Grid, TheMotherShip.Color, TheMotherShip.Identity);
    OutTextXy(310, 64, 'Mother Ship:' + IntToStr(TheMotherShip.Life));
    OutTextXy(310, 16, 'Life: ' + IntToStr(Tank.Life));
    OutTextXy(310, 32, 'Shots: ' + IntToStr(indexShot));
    OutTextXy(310, 48, 'X: ' + IntToStr(Tank.PositionX) + ' Y: ' +
      IntToStr(Tank.PositionY));
    OutTextXy(310, 480, 'Score: ' + IntToStr(Score));
    delay(100);
    if (Key = 27) then
      break;
  end;
end;

end.

