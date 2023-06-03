program SerPrestadores;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'src\App.pas',
  SerPrestadores.Resource.Connection in 'src\resource\connection\SerPrestadores.Resource.Connection.pas';

var
  App: TApp;
begin
  App := TApp.Create;
  try
    App.Start(9000);
  finally
    App.DisposeOf;
  end;
end.
