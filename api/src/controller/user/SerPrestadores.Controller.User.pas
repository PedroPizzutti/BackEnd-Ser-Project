unit SerPrestadores.Controller.User;

interface

uses
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils,
  System.Types,
  BCrypt,
  Horse,
  Horse.GBSwagger,
  Horse.Jhonson,
  Horse.Commons,
  Rest.Json,
  GBSwagger.Path.Attributes,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.User.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('users', 'Usuários')]
  TControllerUser = class(THorseGBSwagger)
    private
      var FDAO: IGenericDAO<TUserEntity>;
      procedure ValidateUser(AJSONObject: TJSONObject);

    public
      [SwagPOST('', 'Create a user')]
      [SwagResponse(201, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;
  end;

implementation

{ TControllerUser }

procedure TControllerUser.Post;
var
  LPassword: String;
  LEncryptedPassword: String;
  LJSONRequest: TJSONObject;
begin
  LJSONRequest := FRequest.Body<TJSONObject>;

  Self.ValidateUser(LJSONRequest);

  LPassword := LJSONRequest.GetValue<String>;
  LEncryptedPassword := TBCrypt.GenerateHash(LPassword);
  LJSONRequest.Get('password').JsonValue := TJSONString.Create(LEncryptedPassword);

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.Insert(LJSONRequest);

  FResponse.Status(THTTPStatus.Created);
end;

procedure TControllerUser.ValidateUser(AJSONObject: TJSONObject);
var
  LName: String;
  LEmail: String;
  LPassword: String;
  LNullFieldsList: TStringList;
begin
  LNullFieldsList := TStringList.Create;
  try
    if not AJSONObject.TryGetValue<String>('name', LName) then
    begin
      LNullFieldsList.Add('name');
    end;

    if not AJSONObject.TryGetValue<String>('email', LEmail) then
    begin
      LNullFieldsList.Add('email');
    end;

    if not AJSONObject.TryGetValue<String>('password', LPassword) then
    begin
      LNullFieldsList.Add('password');
    end;

    if LNullFieldsList.Count > 0 then
    begin
      var LMsg := '';
      if LNullFieldsList.Count = 1 then
      begin
        LMsg := 'campo obrigatório: ' + LNullFieldsList.Text;
      end
      else
      begin
        LMsg := 'campos obrigatórios: ' + LNullFieldsList.Text;
      end;

      raise EHorseException.New.Error(LMsg).Status(THTTPStatus.BadRequest);
    end;

  finally
    LNullFieldsList.DisposeOf;
  end;


end;

end.
