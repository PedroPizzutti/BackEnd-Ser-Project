unit SerPrestadores.Controller.Provider;

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
  SerPrestadores.Utils,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.Provider.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('providers', 'providers')]
  TControllerProvider = class(THorseGBSwagger)
    private
      var FDAO: IGenericDAO<TProviderEntity>;
      procedure ValidateProvider(AJSONObject: TJSONObject);

    public
      [SwagGET('', 'lists all the providers')]
      [SwagResponse(200, TProviderEntity, 'provider list' ,True)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Get;

      [SwagGET('/:id', 'list a provider in detail')]
      [SwagParamPath('id', 'provider id')]
      [SwagResponse(200, TProviderEntity, 'provider in detail')]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure GetById;

      [SwagGET('/search', 'lists all the providers with liked name')]
      [SwagParamQuery('name', 'filter by name')]
      [SwagResponse(200, TProviderEntity, 'filtered provider list')]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure GetByName;

      [SwagPOST('', 'create a provider')]
      [SwagResponse(201, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;

      [SwagPUT('/:id', 'update a provider')]
      [SwagParamPath('id', 'provider id')]
      [SwagResponse(200, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Put;

      [SwagDELETE('/:id', 'delete a provider')]
      [SwagParamPath('id', 'provider id')]
      [SwagResponse(204, nil)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Delete;
  end;

implementation

{ TControllerProvider }

procedure TControllerProvider.Delete;
var
  LIdProvider: Int64;
begin
  LIdProvider := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdProvider);

  FDAO := TGenericDAO<TProviderEntity>.New;
  FDAO.Find(LIdProvider);

  FDAO.Delete('id', LIdProvider.ToString);

  FResponse.Status(THTTPStatus.NoContent);
end;

procedure TControllerProvider.Get;
begin
  FDAO := TGenericDAO<TProviderEntity>.New;
  FResponse.Send<TJSONArray>(FDAO.Find);
end;

procedure TControllerProvider.GetById;
var
  LIdProvider: Int64;
begin
  LIdProvider := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdProvider);

  FDAO := TGenericDAO<TProviderEntity>.New;
  FResponse.Send<TJSONObject>(FDAO.Find(LIdProvider));
end;

procedure TControllerProvider.GetByName;
var
  LName : String;
begin
  LName := FRequest.Query.Items['name'];
  FDAO := TGenericDAO<TProviderEntity>.New;
  FResponse.Send<TJSONArray>(FDAO.FindByField('name', LName));
end;

procedure TControllerProvider.Post;
begin
  Self.ValidateProvider(FRequest.Body<TJSONObject>);

  FDAO := TGenericDAO<TProviderEntity>.New;
  FDAO.Insert(FRequest.Body<TJSONObject>);

  FResponse.Status(THTTPStatus.Created);
end;

procedure TControllerProvider.Put;
var
  LIdProvider: Int64;
  LRequest: TJSONObject;
begin
  LIdProvider := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdProvider);

  FDAO := TGenericDAO<TProviderEntity>.New;
  FDAO.Find(LIdProvider);

  LRequest := FRequest.Body<TJSONObject>;
  LRequest.AddPair('id', LIdProvider);

  Self.ValidateProvider(LRequest);

  FDAO.Update(LRequest);
end;

procedure TControllerProvider.ValidateProvider(AJSONObject: TJSONObject);
var
  LFieldsToValidate: TStringList;
begin
  LFieldsToValidate := TStringList.Create;
  try
    LFieldsToValidate.Add('name');
    LFieldsToValidate.Add('phone');
    LFieldsToValidate.Add('email');
    LFieldsToValidate.Add('cpf');

    TUtils.ValidateFieldsString(AJSONObject, LFieldsToValidate);
  finally
    LFieldsToValidate.DisposeOf;
  end;
end;

end.
