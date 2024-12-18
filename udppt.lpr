program udppt;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, anasayfafrm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title:='UDP Port Test';
  Application.Initialize;
  Application.CreateForm(TfrmAnaSayfa, frmAnaSayfa);
  Application.Run;
end.

