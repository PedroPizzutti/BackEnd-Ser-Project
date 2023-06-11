unit SerPrestadores.Controller.Auth;

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
  SerPrestadores.Model.User,
  SerPrestadores.Model.User.Entity,
  SerPrestadores.Model.Token.Entity,
  SerPrestadores.Model.Success.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('auth', 'authentication')]
  TControllerAuth = class(THorseGBSwagger)
    public
      [SwagPOST('signup', 'create an user')]
      [SwagResponse(201, TSuccessEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;

      [SwagPOST('signin', 'generate a token')]
      [SwagResponse(201, TTokenEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure PostToken;

      [SwagGET('user', 'return the authenticated user')]
      [SwagResponse(200, TUserEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure GetLoggedUser;
  end;

implementation

{ TControllerAuth }

procedure TControllerAuth.GetLoggedUser;
var
  LResponse: TJSONObject;
  LToken: String;
  LAuthorization: String;
begin
  LAuthorization := FRequest.Headers.Items['Authorization'];
  LToken := LAuthorization.Split([' '])[1];

  LResponse :=
    TModelUser
      .New
      .SetToken(LToken)
      .GetUserIdByToken
      .GetUserById;

  FResponse.Send<TJSONObject>(LResponse);
end;

procedure TControllerAuth.Post;
var
  LRequest: TJSONObject;
  LResponse: TJSONObject;
begin
  LRequest := FRequest.Body<TJSONObject>;

  LResponse :=
    TModelUser
      .New
      .SetJSONUser(LRequest)
      .PostUser;

  FResponse.Status(THTTPStatus.Created).Send<TJSONObject>(LResponse);
end;

procedure TControllerAuth.PostToken;
var
  LRequest: TJSONObject;
  LResponse: TJSONObject;
begin
  LRequest := FRequest.Body<TJSONObject>;

  var LToken :=
    TModelUser
      .New
      .SetJSONUser(LRequest)
      .Login
      .GenerateToken;

  LResponse := TJSONObject.Create;
  LResponse.AddPair('token', LToken);

  FResponse.Status(THTTPStatus.Created).Send(LResponse);
end;

end.
