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
  SerPrestadores.Utils,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.User.Entity,
  SerPrestadores.Model.Success,
  SerPrestadores.Model.Success.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('users', 'user')]
  TControllerUser = class(THorseGBSwagger)
    private
      var FDAO: IGenericDAO<TUserEntity>;
      procedure ValidateFieldsUser(AJSONObject: TJSONObject);
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
      [SwagResponse(204, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Delete;
  end;

implementation

{ TControllerUser }

procedure TControllerUser.Delete;
var
  LIdUser: Int64;
begin
  LIdUser := FRequest.Params.Items['id'].ToInteger;

  TUtils.ValidateId(LIdUser);

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.FindById(LIdUser);

  FDAO.Delete('id', LIdUser.ToString);

  FResponse.Status(THTTPStatus.NoContent);
end;

procedure TControllerUser.GetById;
var
  LIdUser: Int64;
begin
  LIdUser := FRequest.Params.Items['id'].ToInteger;

  TUtils.ValidateId(LIdUser);

  FDAO := TGenericDAO<TUserEntity>.New;

  FResponse.Send<TJSONObject>(FDAO.FindById(LIdUser));
end;

procedure TControllerUser.Put;
var
  LIdUser: Int64;
  LRequest: TJSONObject;
  LResponse: TJSONObject;
begin
  LIdUser := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdUser);

  FDAO := TGenericDAO<TUserEntity>.New;
  FDAO.FindById(LIdUser);

  LRequest := FRequest.Body<TJSONObject>;
  LRequest.AddPair('id', LIdUser);

  Self.ValidateFieldsUser(LRequest);

  TUtils.EncryptPasswordJSON(LRequest, 'password');

  FDAO.Update(LRequest);

  LResponse :=
    TModelSuccess
      .New
      .SetMsg('user updated')
      .GetEntity
      .GetJsonEntity;

  FResponse.Send<TJSONObject>(LResponse);
end;

procedure TControllerUser.ValidateFieldsUser(AJSONObject: TJSONObject);
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

end.
