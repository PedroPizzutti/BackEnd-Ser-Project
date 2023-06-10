unit SerPrestadores.Controller.Auth;

interface

uses
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils,
  System.Types,
  BCrypt,
  Horse,
  Horse.JWT,
  JOSE.Types.Bytes,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  Horse.GBSwagger,
  Horse.Jhonson,
  Horse.Commons,
  Rest.Json,
  GBSwagger.Path.Attributes,
  SerPrestadores.Utils,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.User.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('auth', 'authentication')]
  TControllerAuth = class(THorseGBSwagger)
    private
      var FDAO: IGenericDAO<TUserEntity>;
      function ValidateLogin(AJSONObject: TJSONObject): String;
      procedure ValidateFieldsCreateUser(AJSONObject: TJSONObject);
      procedure ValidateFieldsLoginUser(AJSONObject: TJSONObject);
    public
      [SwagPOST('signup', 'create an user')]
      [SwagResponse(201, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;

      [SwagPOST('signin', 'generate a token')]
      [SwagResponse(201, nil)]
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
  LIdUser: Int64;
  LToken: String;
  LAuthorization: String;
begin
  LAuthorization := FRequest.Headers.Items['Authorization'];
  LToken := LAuthorization.Split([' '])[1];

  LIdUser := TUtils.GetUserIdByToken(LToken);

  FDAO := TGenericDAO<TUserEntity>.New;

  FResponse.Send<TJSONObject>(FDAO.FindById(LIdUser));
end;

procedure TControllerAuth.Post;
var
  LRequest: TJSONObject;
begin
  LRequest := FRequest.Body<TJSONObject>;

  Self.ValidateFieldsCreateUser(LRequest);

  TUtils.EncryptPasswordJSON(LRequest, 'password');

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.Insert(LRequest);

  FResponse.Status(THTTPStatus.Created);
end;

procedure TControllerAuth.PostToken;
var
  LIdUser: String;
  LRequest: TJSONObject;
  LResponse: TJSONObject;
begin
  LRequest := FRequest.Body<TJSONObject>;

  Self.ValidateFieldsLoginUser(LRequest);

  LIdUser := Self.ValidateLogin(LRequest);

  LResponse := TJSONObject.Create;
  LResponse.AddPair('token', TUtils.GenerateToken(LIdUser));

  FResponse.Status(THTTPStatus.Created).Send(LResponse);
end;

procedure TControllerAuth.ValidateFieldsCreateUser(AJSONObject: TJSONObject);
var
  LFieldsToValidate: TStringList;
begin
  LFieldsToValidate := TStringList.Create;
  try
    LFieldsToValidate.Add('name');
    LFieldsToValidate.Add('email');
    LFieldsToValidate.Add('password');

    TUtils.ValidateFieldsString(AJSONObject, LFieldsToValidate);
  finally
    LFieldsToValidate.DisposeOf;
  end;
end;

procedure TControllerAuth.ValidateFieldsLoginUser(AJSONObject: TJSONObject);
var
  LFieldsToValidate: TStringList;
begin
  LFieldsToValidate := TStringList.Create;
  try
    LFieldsToValidate.Add('email');
    LFieldsToValidate.Add('password');

    TUtils.ValidateFieldsString(AJSONObject, LFieldsToValidate);
  finally
    LFieldsToValidate.DisposeOf;
  end;
end;

function TControllerAuth.ValidateLogin(AJSONObject: TJSONObject): String;
var
  LIdUser: String;
  LPasswordUser: String;
  LEmailRequest: String;
  LPasswordRequest: String;
begin
  LEmailRequest := AJSONObject.GetValue<String>('email');
  LPasswordRequest := AJSONObject.GetValue<String>('password');

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.FindByFieldExactly('email', LEmailRequest);

  if FDAO.DataSet.RecordCount = 0 then
  begin
    raise EHorseException.New.Error('user not found').Status(THTTPStatus.BadRequest);
  end;

  LPasswordUser := FDAO.DataSet.FieldByName('password').AsString;

  if not TBCrypt.CompareHash(LPasswordRequest, LPasswordUser) then
  begin
    raise EHorseException.New.Error('wrong password').Status(THTTPStatus.BadRequest);
  end;

  LIdUser := FDAO.DataSet.FieldByName('id').AsString;

  Result := LIdUser;
end;

end.
