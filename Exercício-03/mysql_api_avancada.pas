unit mysql_api_avancada;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, MySQL4, showquery;

type

  { TfrmTryMySQL }

  TfrmTryMySQL = class(TForm)
    btnConnect: TButton;
    btnselectDB: TButton;
    btnExit: TButton;
    btnOpenQuery: TButton;
    cboDatabase: TComboBox;
    cboTable: TComboBox;
    Label5: TLabel;
    lblTable: TLabel;
    lblDataBase: TLabel;
    lstField: TListBox;
    MemResults: TMemo;
    stbTrymysql: TStatusBar;
    txtCommand: TEdit;
    Label4: TLabel;
    txtHost: TEdit;
    txtUsername: TEdit;
    txtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnConnectClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnOpenQueryClick(Sender: TObject);
    procedure btnselectDBClick(Sender: TObject);
    procedure cboDatabaseChange(Sender: TObject);
    procedure cboTableChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ShowString(const S:string);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmTryMySQL: TfrmTryMySQL;
  mySQLSock:pmysql;
  mysqlq:tmysql;

implementation

{ TfrmTryMySQL }

procedure TfrmTryMySQL.btnConnectClick(Sender: TObject);
var
 databasenamesbuffer:pmysql_res;
 adatabase:tmysql_row;
begin
 if mysqlsock<> nil then
  begin
   mysql_close(mysqlsock);
   cboDatabase.Clear;
   cboDatabaseChange(cboDatabase);
  end;
 mySQLsock:=mysql_real_connect(mysql_init(pmysql(@mysqlq)), pchar(txthost.text),
 pchar(txtusername.text),pchar(txtpassword.text),pchar('testdb'),0,nil,0);

 if mysqlsock = nil then
  begin
   showstring('Conexão ao servidor falhou.');
   showstring('O erro foi:'+ strPas(mysql_error(@mysqlq)));
  end
 else
  begin
   stbTryMySQL.simpleText:='Conectado ao Banco de Dados.';
   showstring('Host info :'+strpas(mysql_get_host_info(mySQLsock)));
   showstring('Info do servidor :'+strpas(mysql_stat(mysqlsock)));
   showstring('Info do cliente:'+strpas(mysql_get_client_info));
   {$ifdef unix}
   showstring('Porta mysql :'+intTOstr(mysql_port));
   showstring('Porta unix do Mysql:'+strpas(mysql_unix_port));
   {$endif}
   databasenamesBuffer:=mysql_list_dbs(mysqlsock,nil);
   try
    aDatabase:=mysql_fetch_row(databasenamesbuffer);
    while (aDatabase <> nil) do
     begin
      cboDatabase.items.add(aDatabase[0]);
      aDatabase:=mysql_fetch_row(databasenamesbuffer);
     end;
   finally
    mysql_free_result(databasenamesbuffer);
   end;
  end;
end;

procedure TfrmTryMySQL.btnExitClick(Sender: TObject);
begin
  close();
end;

procedure TfrmTryMySQL.btnOpenQueryClick(Sender: TObject);
var
 i:integer;
 tablebuffer:pmysql_res;
 recordBuffer:tmysql_row;
 aColumn:Tlistcolumn;
 field:pmysql_field;
begin
 stbTryMysql.SimpleText:='Executando Query:'+txtcommand.text;
 showstring('Executando query:'+txtcommand.Text);
 frmShowQuery:=TfrmShowQuery.create(nil);
 try
  screen.cursor:=crHourGlass;
  try
   if (mysql_query(mySQlsock,pchar(txtcommand.text))<0) then
    begin
     showstring('Query Falhou'+strpas(mysql_error(mySQLsock)));
     raise(Exception.create('Query falhou.'));
    end
   else
    begin
     tablebuffer:=mysql_Store_result(mysqlsock);
     if tablebuffer<>nil then
      begin
       showstring('Numero de Registros retornados:'
                  +intTostr(mysql_num_rows(tableBuffer)));
       showstring('Numero de campos por registro:'
                  +intTostr(mysql_num_fields(tableBuffer)));
       try
        frmShowQuery.lsvResults.clear;
        for i:=0 to pred(mysql_num_fields(tableBuffer)) do
         begin
          acolumn:= frmShowQuery.lsvResults.columns.add;
          field:=mysql_fetch_field_direct (tableBuffer, i);
          acolumn.caption:=pchar(field^.name);
         end;
        recordbuffer:=mysql_fetch_row(tableBuffer);
        while (recordBuffer <> nil ) do
         begin
          with frmShowQuery.lsvResults.Items.Add do
           begin
            caption:=recordbuffer[0];
            for i:=1 to pred (mysql_num_fields(tableBuffer)) do
             subitems.add(recordBuffer[i]);
           end;
          recordbuffer:=mysql_fetch_row(tablebuffer);
         end;
       finally
        mysql_free_result(tablebuffer);
       end;
      end
     else
      begin
       showString('Query nao retornou resultado algum.');
      end;
    end;
  finally
   screen.cursor:=crDefault;
  end;
  frmShowQuery.showModal;
 finally
  frmshowQuery.free;
 end;
end;

procedure TfrmTryMySQL.btnselectDBClick(Sender: TObject);
var
 tablenamesBuffer:pmysql_res;
 aTable:tmysql_row;
begin
 if cbodatabase.ItemIndex <> -1 then
  begin
   showstring('Selecionado um Banco de Dados:'+cboDatabase.text);
   if mysql_select_db (mySqlsock, pchar(cboDatabase.text))<0 then
    begin
     btnOpenQuery.enabled:=false;
     showstring('Nao foi possivel conectar se ao banco de dados'+
                cboDatabase.text);
     showstring(mysql_error(mysqlsock));
    end
   else
    begin
     cboTable.clear;
     if mysql_query(mysqlsock,pchar('show tables')) = 0 then
      begin
       tablenamesBuffer:= mysql_store_result(mysqlsock);//mysql_list_tables(mysqlsock, nil);
       atable:= mysql_fetch_row(tablenamesBuffer);
      end;
     //else atable:=nil;
     while (atable<>nil) do
      begin
       cboTable.Items.add(aTable[0]);//modificado em 03/10/2016
       aTable:=mysql_fetch_row(tablenamesBuffer);
      end;
     mysql_free_result(tablenamesbuffer);
     btnOpenQuery.enabled:=true;
    end;
  end
 else
  begin
   showstring('Selecione um banco de Dados no comboBox');
  end;
  //cboTableChange(Sender);
end;

procedure TfrmTryMySQL.cboDatabaseChange(Sender: TObject);
begin
  btnselectDb.enabled:=(tcombobox(sender).items.count>0) and
  (tcombobox(sender).itemindex<> -1);
  if not btnSelectDB.Enabled then
   begin
    btnopenQuery.Enabled:=false;
    cboTable.text:=' ';
    cboTable.items.clear;
    lstField.clear;
   end;
end;

procedure TfrmTryMySQL.cboTableChange(Sender: TObject);
var
 stTable:string;
 fieldnamesBuffer:pmysql_res;
 stQuery:string;
 aField:mysql_row;
begin
 lstfield.clear;
 if cboTable.text <> ' ' then
 begin
  stTable:=cboTable.text;
  stQuery:=concat('show columns from ',stTable);
  showstring('Requisitando colunas de:'+stTable);
  if (mysql_query(mySqlsock,Pchar(stQuery))<0) then
   begin
    showString('Requisicao de coluna falhou.'+strpas(mysql_error(mySqlsock)));
   end
  else
   begin
    fieldnamesBuffer:=mysql_store_result(mySqlsock);
    try
     aField:=mysql_fetch_row(fieldnamesBuffer);
     while (afield<> nil) do
      begin
       lstField.items.add(aField[0]);
       afield:=mysql_fetch_row(fieldnamesBuffer);
      end;
    finally
     mysql_free_result(fieldnamesBuffer);
    end;
   end;
 end;
end;

procedure TfrmTryMySQL.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  mysql_close(mysqlsock);
  canclose:=true;
end;

procedure TfrmTryMySQL.ShowString(const S: string);
begin
  memResults.lines.add(s);
end;
initialization
  {$I mysql_api_avancada.lrs}

end.

