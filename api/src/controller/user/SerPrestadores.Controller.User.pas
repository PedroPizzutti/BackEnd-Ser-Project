unit SerPrestadores.Controller.User;

interface

uses
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils,
  System.Types,
  GBSwagger.Path.Attributes,
  Horse,
  Horse.GBSwagger,
  Horse.Jhonson,
  Horse.Commons,
  Rest.Json,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.User.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('users', 'Usuários')]
  TControllerProvider = class(THorseGBSwagger)
    private
      var FDAO: IGenericDAO<TUserEntity>;
    public
      [SwagPOST('', 'Create a user')]
      [SwagResponse(201, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;
  end;

implementation

{ TControllerProvider }

procedure TControllerProvider.Post;
begin
  //TODO
end;

end.
