program sequencia_de_fibonacci;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Fibonacci_source, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R sequencia_de_fibonacci.rc}{$ENDIF}

begin
  {$I sequencia_de_fibonacci.lrs}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

