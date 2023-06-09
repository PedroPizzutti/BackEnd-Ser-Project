unit SerPrestadores.Controller.Auth;

interface

uses
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils,
  System.Types,
  BCrypt,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  Horse,
  Horse.JWT,
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
  [SwagPath('', 'authentication')]
  TControllerAuth = class(THorseGBSwagger)
    private
      var FDAO: IGenericDAO<TUserEntity>;
      procedure ValidateCreateUser(AJSONObject: TJSONObject);
      procedure ValidateLoginUser(AJSONObject: TJSONObject);
    public
      [SwagPOST('signup', 'create a user')]
      [SwagResponse(201, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;

      [SwagPOST('signin', 'auth a user')]
      [SwagResponse(201, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure PostToken;

  end;

implementation

{ TControllerAuth }

procedure TControllerAuth.Post;
var
  LRequest: TJSONObject;
begin
  LRequest := FRequest.Body<TJSONObject>;

  Self.ValidateCreateUser(LRequest);

  TUtils.EncryptPasswordJSON(LRequest, 'password');

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.Insert(LRequest);

  FResponse.Status(THTTPStatus.Created);
end;

procedure TControllerAuth.PostToken;
var
  LToken: TJWT;
  LRequest: TJSONObject;
  LResponse: TJSONObject;
  LIdUser: String;
  LPasswordUser: String;
  LEmailRequest: String;
  LPasswordRequest: String;
begin
  LRequest := FRequest.Body<TJSONObject>;

  Self.ValidateLoginUser(LRequest);

  LEmailRequest := LRequest.GetValue<String>('email');
  LPasswordRequest := LRequest.GetValue<String>('password');

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.FindByFieldExactly('email', LEmailRequest);

  if FDAO.DataSet.RecordCount = 0 then
  begin
    raise EHorseException.New.Error('user not found').Status(THTTPStatus.BadRequest);
  end;

  LIdUser := FDAO.DataSet.FieldByName('id').AsString;
  LPasswordUser := FDAO.DataSet.FieldByName('password').AsString;

  if not TBCrypt.CompareHash(LPasswordRequest, LPasswordUser) then
  begin
    raise EHorseException.New.Error('wrong password').Status(THTTPStatus.BadRequest);
  end;

  LToken := TJWT.Create;
  LResponse := TJSONObject.Create;
  try
    LToken.Claims.Issuer := 'SerPrestadores';
    LToken.Claims.Subject := LIdUser;
    LToken.Claims.Expiration := Now + 1;

    LResponse.AddPair('token', TJOSE.SHA256CompactToken('SER', LToken));

    FResponse.Status(THTTPStatus.Created).Send(LResponse);
  finally
    LToken.DisposeOf;
  end;
end;

procedure TControllerAuth.ValidateCreateUser(AJSONObject: TJSONObject);
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

procedure TControllerAuth.ValidateLoginUser(AJSONObject: TJSONObject);
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

end.
