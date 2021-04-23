unit showquery;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls;

type

  { TfrmShowQuery }

  TfrmShowQuery = class(TForm)
    btnClose: TButton;
    lsvResults: TListView;
    procedure btnCloseClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmShowQuery: TfrmShowQuery;

implementation

{ TfrmShowQuery }



procedure TfrmShowQuery.btnCloseClick(Sender: TObject);
begin
  close();
end;

initialization
  {$I showquery.lrs}

end.

