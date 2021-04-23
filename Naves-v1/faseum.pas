unit FaseUm;

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

const
  MaxShips = 3;

type
  TSpaceShipArray = array[0..MaxShips] of SpaceShip;
  TShotArray      = array[0..65535] of Shot;

procedure GameMissionOne(var Score: integer);

implementation

procedure GameMissionOne(var Score: integer);
var
  Board:   Stage;
  Tank:    player;
  Ships:   TSpaceShipArray;
  Shots:   TShotArray;
  Key:     integer;
  i, j:    integer;
  ShipsInCombat: integer;
  indexShip: integer = 0;
  indexShot: integer = -1;
  ToLeft:  array[0..MaxShips] of boolean;
  ToRight: array[0..MaxShips] of boolean;
begin
  Board := Stage.Create(39, 19);
  Tank  := player.Create(3, 3);
  Tank.Identity := 2;
  Tank.PositionX := Board.Grid.LengthN mod 2;
  Tank.PositionY := Board.Grid.LengthM - 3;
  Cenary(Board.Grid.LengthN * 16, Board.Grid.LengthM * 16);
  AddBlockInStage(Board.Grid, Tank.Shape, Tank.PositionX, Tank.PositionY,
    Tank.Identity);
  ShipsInCombat := MaxShips + 1;
  Randomize;
  for i := 0 to length(Ships) - 1 do
  begin
    ToRight[i] := False;
    ToLeft[i]  := True;
    Ships[i]   := SpaceShip.Create(3, 3);
    Ships[i].Identity := i + 3;
    Ships[i].PositionX := Random(16);
    Ships[i].PositionY := indexShip;
    AddBlockInStage(Board.Grid, Ships[i].Shape, Ships[i].PositionX, Ships[i].PositionY,
      Ships[i].Identity);
    indexShip := indexShip + 3;
  end;
  ClearDevice;
  Drawstage(Board.Grid, Tank.Color, Tank.Identity);
  for i := 0 to length(ships) - 1 do
    DrawStage(Board.Grid, Ships[i].Color, Ships[i].Identity);
  while Tank.State do
  begin
    clearDevice;
    Cenary(Board.Grid.LengthN * 16, Board.Grid.LengthM * 16);
    if keypressed then
    begin
      RemoveBlockInStage(Board.Grid, Tank.Shape, Tank.PositionX, Tank.PositionY);
      Key := Ord(lowercase(readkey));
      if Key = Ord('p') then
        pause(Board.Grid.LengthN * 16, Board.Grid.LengthM * 16);
      if Key = Ord('a') then
        moveLeft(Board, Tank);
      if Key = Ord('d') then
        moveRight(Board, Tank);
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
            for j := 0 to length(Ships) - 1 do
            begin
              if ((Shots[i].PositionX >= Ships[j].PositionX) and
                (Shots[i].PositionX <= Ships[j].PositionX +
                Ships[j].Shape.LengthN)) and
                ((Ships[j].PositionY) = Shots[i].PositionY - 1) then
              begin
                Ships[j].Life := Ships[j].Life - Shots[i].Damage;
                SetTextStyle(0, 0, 3);
                OutTextXY(Shots[i].PositionX * 16, Shots[i].PositionY * 16,
                  '+'+IntToStr(Shots[i].Damage));
                Score := Score + Shots[i].Damage;
                if Ships[j].Life <= 0 then
                begin
                  Ships[j].State := False;
                  SndPlaySound('Sounds/Boom.wav', SND_ASYNC);
                  Dec(ShipsInCombat);
                end;
              end;
            end;
            Dec(Tank.Blast);
          end;
        end;
        if Shots[i].Owner is SpaceShip then
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
    for i := 0 to length(Ships) - 1 do
    begin
      RemoveBlockInStage(Board.Grid, Ships[i].Shape, Ships[i].PositionX,
        Ships[i].PositionY);
      if Ships[i].State then
      begin
        if Ships[i].PositionX = Tank.PositionX then
        begin
          if Ships[i].CanShot then
          begin
            Inc(indexShot);
            Shots[indexShot] :=
              Shot.Create(Ships[i].attack, Ships[i].PositionX + 1,
              Ships[i].PositionY + 2);
            SndPlaySound('Sounds/SOUND58.wav', SND_ASYNC);
            Shots[indexShot].Identity := indexShot + 63;
            AddBlockInStage(Board.Grid, Shots[indexShot].Shape,
              Shots[indexShot].PositionX,
              Shots[indexShot].PositionY, Shots[indexShot].Identity);
            Shots[indexShot].Shooter(Ships[i]);
            Ships[i].CanShot := False;
          end;
        end;
        if ToLeft[i] then
          if not MoveLeft(Board, Ships[i]) then
          begin
            ToLeft[i]  := False;
            ToRight[i] := True;
          end;
        if ToRight[i] then
          if not MoveRight(Board, Ships[i]) then
          begin
            ToLeft[i]  := True;
            ToRight[i] := False;
          end;
        AddBlockInStage(Board.Grid, Ships[i].Shape, Ships[i].PositionX,
          Ships[i].PositionY, Ships[i].Identity);
      end;
    end;
    Drawstage(Board.Grid, Tank.Color, Tank.Identity);
    SetTextStyle(0, 0, 0);
    for i := 0 to length(ships) - 1 do
    begin
      DrawStage(Board.Grid, Ships[i].Color, Ships[i].Identity);
      OutTextXy(310, 64 + (i * 16), 'Ship ' + IntToStr(i) + ':' +
        IntToStr(Ships[i].Life));
    end;
    OutTextXy(310, 16, 'Life: ' + IntToStr(Tank.Life));
    OutTextXy(310, 32, 'Shots: ' + IntToStr(indexShot));
    OutTextXy(310, 48, 'X: ' + IntToStr(Tank.PositionX) + ' Y: ' +
      IntToStr(Tank.PositionY));
    OutTextXy(310, 480, 'Score: ' + IntToStr(Score));
    delay(100);
    if (Key = 27) or (ShipsInCombat = 0) then
      break;
  end;
end;

end.

