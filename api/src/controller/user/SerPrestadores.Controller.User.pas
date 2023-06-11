unit SerPrestadores.Controller.User;

interface

uses
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils,
  System.Types,
  Horse,
  Horse.GBSwagger,
  Horse.Jhonson,
  Horse.Commons,
  Rest.Json,
  GBSwagger.Path.Attributes,
  SerPrestadores.Utils,
  SerPrestadores.Model.User.Entity,
  SerPrestadores.Model.User,
  SerPrestadores.Model.Success.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('users', 'user')]
  TControllerUser = class(THorseGBSwagger)
    public
      [SwagGET('/:id', 'lists a user in detail')]
      [SwagResponse(200, TUserEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure GetById;

      [SwagPut('/:id', 'update a user')]
      [SwagParamPath('id', 'user id')]
      [SwagResponse(200, TSuccessEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Put;

      [SwagDELETE('/:id', 'delete a user')]
      [SwagResponse(200, TSuccessEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Delete;
  end;

implementation

{ TControllerUser }

procedure TControllerUser.Delete;
var
  LIdUser: Int64;
  LToken: String;
  LAuthorization: String;
  LResponse: TJSONObject;
begin
  LIdUser := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdUser);

  LAuthorization := FRequest.Headers.Items['Authorization'];
  LToken := LAuthorization.Split([' '])[1];

  LResponse :=
    TModelUser
      .New
      .SetId(LIdUser)
      .SetToken(LToken)
      .DeleteUser;

  FResponse.Send<TJSONObject>(LResponse);
end;

procedure TControllerUser.GetById;
var
  LIdUser: Int64;
  LResponse: TJSONObject;
begin
  LIdUser := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdUser);

  LResponse :=
    TModelUser
      .New
      .SetId(LIdUser)
      .GetUserById;

  FResponse.Send<TJSONObject>(LResponse);
end;

procedure TControllerUser.Put;
var
  LIdUser: Int64;
  LResponse: TJSONObject;
  LToken: String;
  LAuthorization: String;
begin
  LIdUser := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdUser);

  LAuthorization := FRequest.Headers.Items['Authorization'];
  LToken := LAuthorization.Split([' '])[1];

  LResponse :=
    TModelUser
      .New
      .SetToken(LToken)
      .SetId(LIdUser)
      .SetJSONUser(FRequest.Body<TJSONObject>)
      .UpdateUser;

  FResponse.Send<TJSONObject>(LResponse);
end;

end.
