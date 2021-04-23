program mysql_api_avancada_prj;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mysql_api_avancada, LResources, showquery
  { you can add units after this };

{$IFDEF WINDOWS}{$R mysql_api_avancada_prj.rc}{$ENDIF}

begin
  {$I mysql_api_avancada_prj.lrs}
  Application.Initialize;
  Application.CreateForm(TfrmTryMySQL, frmTryMySQL);
  Application.CreateForm(TfrmShowQuery, frmShowQuery);
  Application.Run;
end.

