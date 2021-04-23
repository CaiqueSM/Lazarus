program project_str_matching;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, strMatching, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R project_str_matching.rc}{$ENDIF}

begin
  {$I project_str_matching.lrs}
  Application.Initialize;
  Application.CreateForm(TFrmCasaStr, FrmCasaStr);
  Application.Run;
end.

