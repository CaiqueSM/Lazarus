unit GamePad;

{$mode objfpc}{$H+}

interface

uses
  Crt, Game_Models;

type

  Event = function(var Board: stage; var Block: person): boolean;

  { Button }

  Button = class
  private
    ButtonKey:     integer;
    ButtonAction:  Event;
    ButtonPressed: boolean;
  public
    property Key: integer Read ButtonKey;
    property Action: Event Read ButtonAction Write ButtonAction;
    property Pressed: boolean Read ButtonPressed Write ButtonPressed;
  public
    constructor Create(NameButton: integer);
  end;

  TButtonSet = array[0..255] of Button;

  { TListButton }

  TListButton = class
  private
    TListButtons: TButtonSet;
    TListIndex:   integer;
    TListNext:    integer;

  public
    property Buttons: TButtonSet Read TListButtons Write TListButtons;
    property Index: integer Read TListIndex Write TListIndex;

  public
    constructor Create;
    procedure AddInList(b: Button);
    function Next: Button;
  end;

  { GamePad }

  TGamePad = class
  private
    GameButtonSet: TListButton;
    GameState:     boolean;

  public
    property ButtonSet: TListButton Read GameButtonSet Write GameButtonSet;
    property State: boolean Read GameState Write GameState;

  public
    constructor Create;
    procedure KeyDown(var Board: Stage; var Block: Person);
    destructor Destroy; override;
  end;


implementation

{ Button }

constructor Button.Create(NameButton: integer);
begin
  ButtonKey := NameButton;
  Pressed   := False;
  action    := nil;
end;

{ GamePad }

constructor TGamePad.Create;
begin
  State     := True;
  ButtonSet := TListButton.Create;
end;

procedure TGamePad.KeyDown(var Board: Stage; var Block: Person);
var
  index: integer = 0;
  key:   integer;
begin
  if keypressed then
  begin
    key := Ord(LowerCase(readkey));
    if key = 27 then
    begin
      State := False;
      exit;
    end;
    while ButtonSet.Buttons[index] <> nil do
    begin
      if key = ButtonSet.Buttons[index].Key then
      begin
        ButtonSet.Buttons[index].Pressed := True;
        ButtonSet.Buttons[index].Action(Board, Block);
        break;
      end
      else
        ButtonSet.Buttons[index].Pressed := False;
      Inc(index);
    end;
  end;
end;

destructor TGamePad.Destroy;
begin
  inherited Destroy;
end;

{ TListButton }

constructor TListButton.Create;
begin
  TListIndex := -1;
  TListNext  := -1;
end;

procedure TListButton.AddInList(b: Button);
begin
  Inc(Index);
  Buttons[Index]     := b;
  Buttons[Index + 1] := nil;
end;

function TListButton.Next: Button;
begin
  Inc(TListNext);
  Result := Buttons[TListNext];
  if Buttons[TListNext] = nil then
    TListNext := -1;
end;

end.

