program SerPrestadores;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'src\App.pas',
  SerPrestadores.Resource.Connection in 'src\resource\connection\SerPrestadores.Resource.Connection.pas',
  SerPrestadores.Model.Dao.GenericDAO in 'src\model\genericDao\SerPrestadores.Model.Dao.GenericDAO.pas',
  SerPrestadores.Model.Provider.Entity in 'src\model\provider\entity\SerPrestadores.Model.Provider.Entity.pas',
  SerPrestadores.Controller.Provider in 'src\controller\provider\SerPrestadores.Controller.Provider.pas',
  SerPrestadores.Model.Error.Entity in 'src\model\error\entity\SerPrestadores.Model.Error.Entity.pas';

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
