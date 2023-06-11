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
  SerPrestadores.Model.Error.Entity in 'src\model\error\entity\SerPrestadores.Model.Error.Entity.pas',
  SerPrestadores.Model.User.Entity in 'src\model\user\entity\SerPrestadores.Model.User.Entity.pas',
  SerPrestadores.Controller.User in 'src\controller\user\SerPrestadores.Controller.User.pas',
  SerPrestadores.Utils in 'src\utils\SerPrestadores.Utils.pas',
  SerPrestadores.Controller.Auth in 'src\controller\auth\SerPrestadores.Controller.Auth.pas',
  SerPrestadores.Controller.StatusApi in 'src\controller\statusApi\SerPrestadores.Controller.StatusApi.pas',
  SerPrestadores.Model.Success in 'src\model\success\SerPrestadores.Model.Success.pas',
  SerPrestadores.Model.Success.Entity in 'src\model\success\entity\SerPrestadores.Model.Success.Entity.pas',
  SerPrestadores.Model.Token.Entity in 'src\model\token\entity\SerPrestadores.Model.Token.Entity.pas';

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
