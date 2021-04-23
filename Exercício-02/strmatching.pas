unit strMatching; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

const MAXLEN = 999;
      Match= 0;
      Insert1= 1;
      Delete1= 2;

type

  { TFrmCasaStr }

cell = record
cost:integer;
parent:integer;
end ;
  TFrmCasaStr = class(TForm)
    btnCasaStr: TButton;
    txtDecT: TEdit;
    lblDecT: TLabel;
    lblMatrizC: TLabel;
    mmoTabela: TMemo;
    txtDist: TEdit;
    Label1: TLabel;
    txtSegStr: TEdit;
    lblSegStr: TLabel;
    txtPrimStr: TEdit;
    lblPrimStr: TLabel;
    procedure btnCasaStrClick(Sender: TObject);
    function string_compare (s:string; t:string ):integer;
    procedure reconstrua (s :string; t:string; i :integer; j:integer);
    procedure Match_out(s:string; t:string; i:integer; j:integer);
    procedure insert_out;
    procedure Delete_out;
    procedure Criar_Tabela;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FrmCasaStr: TFrmCasaStr;
  str1, str2 : String ;
  m: Array [0..MAXLEN,0..MAXLEN] of cell;

implementation

function indel ( c : char ) : integer ;
begin
indel := 1 ;
end ;
function char_match ( c : char ; d : char ) : Integer ;
begin
if ( upcase(c) <> upcase(d) ) then char_match := 1
else char_match := 0 ;
end ;

procedure Row_init(i:integer);
begin
  m[0][i].cost:=i;
  if i>0 then
    m[0][i].parent:=insert1
  else
    m[0][i].parent:=-1;
end;

procedure column_init(i:integer);
begin
  m[i][0].cost:=i;
  if i>0 then
    m[i][0].parent:=Delete1
  else
    m[0][i].parent:=-1;
end;

{ TFrmCasaStr }
//compara as duas strings
function TFrmCasaStr.string_compare (s:string; t:string ):integer;
var
   i,j,k:integer;
   opt : Array [ 0..2 ] of Integer ;
begin
  for i:=0 to Maxlen do
    begin
      row_init(i);
      column_init(i);
    end;
  for i:=1 to length(s) do
    begin
      for j:=1 to length(t) do
        begin
          opt[match]:=m[i-1][j-1].cost + char_match(s[i],t[j]);
          opt[insert1]:=m[i][j-1].cost + indel(t[j]);
          opt[delete1]:=m[i-1][j].cost + indel(s[i]);
          m[i][j].cost:=opt[match];
          m[i][j].parent:=match;
          for k:=insert1 to delete1 do
            begin
              if(opt[k] < m[i][j].cost)  then
               begin
                 m[i][j].cost:=opt[k];
                 m[i][j].parent:=k;
               end;
            end;
        end;
    end;
 result:=m[i][j].cost;
 txtdist.readonly:=true;
end;

procedure TFrmCasaStr.insert_out();
begin
  txtDecT.text:=(txtDecT.text+'I');
end;

procedure TFrmCasaStr.Delete_out();
begin
  txtDecT.text:=(txtDecT.text+'D');
end;

procedure TFrmCasaStr.Match_out(s:string; t:string; i:integer; j:integer);
begin
  if s[i] = t[j] then
   txtDecT.text:=(txtDecT.text+'M')
  else
   txtDecT.text:=(txtDecT.text+'S');
end;
//faz o Caminho inverso das decisões tomadas
procedure TFrmCasaStr.reconstrua (s :string; t:string; i :integer; j:integer);
begin
  TxtDecT.readonly:=true;
  if (m[i][j].parent = -1) then
   exit;
  if m[i][j].parent = match then
   begin
    reconstrua(s,t,i-1,j-1);
    match_out(s,t,i,j);
    exit;
   end;
  if m[i][j].parent = Insert1 then
   begin
    reconstrua(s,t,i,j-1);
    Insert_out();
    exit;
   end;
  if m[i][j].parent = delete1 then
   begin
    reconstrua(s,t,i-1,j);
    delete_out();
    exit;
   end;
end;
//imprime uma tabela (matriz de custo) com os valores de pontuação
//gerados na função String_compare
procedure TFrmCasaStr.Criar_Tabela();
var Tabela:Tstringlist;
    i,j:integer;
begin
 Tabela:=Tstringlist.create;
  for j:=0 to length(str2) do
   begin
    for i:=0 to length(str1) do
     begin
      mmotabela.Text:=(mmoTabela.text+formatFloat('00',m[i][j].cost)+'|');
     end;
     tabela.add(mmoTabela.text);
     mmoTabela.text:='';
  end;
 mmoTabela.lines:=Tabela;
 mmoTabela.readonly:=true;
end;

procedure TFrmCasaStr.btnCasaStrClick(Sender: TObject);
begin
TxtDecT.Clear;
mmoTabela.clear;
mmoTabela.Font.name:='courier New';
mmoTabela.Font.size:=9;
str1 :=txtPrimStr.Text;
str2:=txtSegStr.text;
txtDist.text:=inttostr(string_compare( str1 , str2));
reconstrua (str1,str2,length(str1),length(str2));
Criar_tabela();
end;

initialization
  {$I strmatching.lrs}

end.

