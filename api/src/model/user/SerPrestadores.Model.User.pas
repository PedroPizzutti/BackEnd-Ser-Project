unit SerPrestadores.Model.User;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  BCrypt,
  Horse,
  Horse.JWT,
  JOSE.Types.Bytes,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  SerPrestadores.Utils,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.Success,
  SerPrestadores.Model.Success.Entity,
  SerPrestadores.Model.User.Entity;

type
  IModelUser = interface
    function SetJSONUser(AJSONUser: TJSONObject): IModelUser;
    function SetId(AIdUser: Int64): IModelUser;
    function SetToken(AToken: String): IModelUser;

    function PostUser: TJSONObject;
    function UpdateUser: TJSONObject;
    function DeleteUser: TJSONObject;
    function GetUserById: TJSONObject;
    
    function Login: IModelUser;
    function GenerateToken: String;
    function GetUserIdByToken: IModelUser;
  end;

  TModelUser = class(TInterfacedObject, IModelUser)
    private
      var FId: Int64;
      var FToken: String;
      var FJSONUser: TJSONObject;
      var FDAOUser: IGenericDAO<TUserEntity>;

      function SetJSONUser(AJSONUser: TJSONObject): IModelUser;
      function SetId(AIdUser: Int64): IModelUser;
      function SetToken(AToken: String): IModelUser;

      function PostUser: TJSONObject;
      function UpdateUser: TJSONObject;
      function DeleteUser: TJSONObject;
      function GetUserById: TJSONObject;
      
      function Login: IModelUser;
      function GenerateToken: String;
      function GetUserIdByToken: IModelUser;
      
      procedure ValidateFieldsUser;
      procedure ValidateFieldsLogin;
      procedure ValidateIdUserToken;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: IModelUser;
  end;

implementation

{ TModelUser }

constructor TModelUser.Create;
begin
  FId := 0;
  FToken := '';
  FJSONUser := nil;
  FDAOUser := TGenericDAO<TUserEntity>.New;
end;

function TModelUser.PostUser: TJSONObject;
begin
  Self.ValidateFieldsUser;

  TUtils.EncryptPasswordJSON(FJSONUser, 'password');

  FDAOUser.Insert(FJSONUser);

  Result := 
    TModelSuccess
      .New
      .SetMsg('user created')
      .GetEntity
      .GetJsonEntity;
end;

function TModelUser.DeleteUser: TJSONObject;
begin
  Self.ValidateIdUserToken;
  Self.GetUserById;

  FDAOUser.Delete('id', FId.ToString);

  Result :=
    TModelSuccess
      .New
      .SetMsg('user deleted')
      .GetEntity
      .GetJsonEntity;
end;

destructor TModelUser.Destroy;
begin

  inherited;
end;

function TModelUser.GenerateToken: String;
var
  LJWT: TJWT;
begin
  LJWT := TJWT.Create;
  try
    LJWT.Claims.Issuer := 'SerPrestadores';
    LJWT.Claims.Subject := FId.ToString;
    LJWT.Claims.Expiration := Now + 1;

    Result := TJOSE.SHA256CompactToken('SER', LJWT);
  finally
    LJWT.DisposeOf;
  end;
end;

function TModelUser.GetUserById: TJSONObject;
begin
  Result := FDAOUser.FindById(FId);
end;

function TModelUser.GetUserIdByToken: IModelUser;
var
  LJWT: TJWT;
begin
  LJWT := TJOSE.DeserializeOnly(FToken);
  FId := LJWT.Claims.Subject.ToInteger;
  Result := Self;
end;

function TModelUser.Login: IModelUser;
begin
  Self.ValidateFieldsLogin;

  FDAOUser.FindByFieldExactly('email', FJSONUser.GetValue<String>('email'));

  if FDAOUser.DataSet.RecordCount = 0 then
  begin
    raise EHorseException.New.Error('user not found').Status(THTTPStatus.BadRequest);
  end;
  
  var LPasswordUser := FDAOUser.DataSet.FieldByName('password').AsString;
  
  if not TBCrypt.CompareHash(FJSONUser.GetValue<String>('password'), LPasswordUser) then
  begin
    raise EHorseException.New.Error('wrong password').Status(THTTPStatus.BadRequest);
  end;

  FId := FDAOUser.DataSet.FieldByName('id').AsInteger;
  
  Result := Self;
end;

class function TModelUser.New: IModelUser;
begin
  Result := Self.Create;
end;

function TModelUser.SetId(AIdUser: Int64): IModelUser;
begin
  if AIdUser <> 0 then
  begin
    FId := AIdUser;
  end;
  Result := Self;
end;

function TModelUser.SetJSONUser(AJSONUser: TJSONObject): IModelUser;
begin
  if Assigned(AJSONUser) then
  begin
    FJSONUser := AJSONUser;
  end;
  Result := Self;
end;

function TModelUser.SetToken(AToken: String): IModelUser;
begin
  if AToken <> '' then
  begin
    FToken := AToken;
  end;
  Result := Self;
end;

function TModelUser.UpdateUser: TJSONObject;
begin
  Self.ValidateIdUserToken;
  Self.GetUserById;
  Self.ValidateFieldsUser;

  FJSONUser.AddPair('id', FId);
  TUtils.EncryptPasswordJSON(FJSONUser, 'password');

  FDAOUser.Update(FJSONUser);

  Result :=
    TModelSuccess
      .New
      .SetMsg('user updated')
      .GetEntity
      .GetJsonEntity;
end;

procedure TModelUser.ValidateFieldsUser;
var
  LFieldsToValidate: TStringList;
begin
  LFieldsToValidate := TStringList.Create;
  try
    LFieldsToValidate.Add('name');
    LFieldsToValidate.Add('email');
    LFieldsToValidate.Add('password');

    TUtils.ValidateFieldsString(FJSONUser, LFieldsToValidate);
  finally
    LFieldsToValidate.DisposeOf;
  end;
end;

procedure TModelUser.ValidateIdUserToken;
var
  LIdToken: Int64;
  LIdInformed: Int64;
begin
  LIdInformed := FId;
  Self.GetUserIdByToken;
  LIdToken := FId;

  if LIdToken <> LIdInformed then
  begin
    raise EHorseException.New.Error('not allowed').Status(THTTPStatus.Forbidden);
  end;
end;

procedure TModelUser.ValidateFieldsLogin;
var
  LFieldsToValidate: TStringList;
begin
  LFieldsToValidate := TStringList.Create;
  try
    LFieldsToValidate.Add('email');
    LFieldsToValidate.Add('password');

    TUtils.ValidateFieldsString(FJSONUser, LFieldsToValidate);
  finally
    LFieldsToValidate.DisposeOf;
  end;
end;

end.
