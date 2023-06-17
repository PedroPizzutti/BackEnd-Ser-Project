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
  SerPrestadores.Model.Provider,
  SerPrestadores.Utils,
  SerPrestadores.Model.Provider.Entity,
  SerPrestadores.Model.Success.Entity,
  SerPrestadores.Model.Error.Entity;

type
  [SwagPath('providers', 'providers')]
  TControllerProvider = class(THorseGBSwagger)
    public
      [SwagGET('', 'lists all the providers')]
      [SwagParamQuery('name', 'order by asc or desc')]
      [SwagResponse(200, TProviderEntity, 'provider list' ,True)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Get;

      [SwagGET('/:id', 'lists a provider in detail')]
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
      [SwagResponse(201, TSuccessEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Post;

      [SwagPUT('/:id', 'update a provider')]
      [SwagParamPath('id', 'provider id')]
      [SwagResponse(200, TSuccessEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Put;

      [SwagDELETE('/:id', 'delete a provider')]
      [SwagParamPath('id', 'provider id')]
      [SwagResponse(200, TSuccessEntity)]
      [SwagResponse(400, TErrorEntity)]
      [SwagResponse(500, TErrorEntity)]
      procedure Delete;
  end;

implementation

{ TControllerProvider }

procedure TControllerProvider.Delete;
var
  LIdProvider: Int64;
  LResponse: TJSONObject;
begin
  LIdProvider := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdProvider);

  LResponse :=
    TModelProvider
      .New
      .SetId(LIdProvider)
      .DeleteProvider;

  FResponse.Send<TJSONObject>(LResponse);
end;

procedure TControllerProvider.Get;
var
  LOrdenation: String;
  LResponse: TJSONArray;
begin
  LOrdenation := FRequest.Query.Items['name'];

  LResponse :=
    TModelProvider
      .New
      .SetOrder('name', LOrdenation)
      .GetAllProviders;

  FResponse.Send<TJSONArray>(LResponse);
end;

procedure TControllerProvider.GetById;
var
  LIdProvider: Int64;
  LResponse: TJSONObject;
begin
  LIdProvider := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdProvider);

  LResponse :=
    TModelProvider
      .New
      .SetId(LIdProvider)
      .GetProviderById;

  FResponse.Send<TJSONObject>(LResponse);
end;

procedure TControllerProvider.GetByName;
var
  LName : String;
  LResponse: TJSONArray;
begin
  LName := FRequest.Query.Items['name'];

  LResponse :=
    TModelProvider
      .New
      .SetName(LName)
      .GetProviderByNameLiked;

  FResponse.Send<TJSONArray>(LResponse);
end;

procedure TControllerProvider.Post;
var
  LResponse: TJSONObject;
begin
  LResponse :=
    TModelProvider
      .New
      .SetJSONProvider(FRequest.Body<TJSONObject>)
      .PostProvider;

  FResponse.Status(THTTPStatus.Created).Send<TJSONObject>(LResponse);
end;

procedure TControllerProvider.Put;
var
  LIdProvider: Int64;
  LResponse: TJSONObject;
begin
  LIdProvider := FRequest.Params.Items['id'].ToInteger;
  TUtils.ValidateId(LIdProvider);

  LResponse :=
    TModelProvider
      .New
      .SetId(LIdProvider)
      .SetJSONProvider(FRequest.Body<TJSONObject>)
      .UpdateProvider;

  FResponse.Send<TJSONObject>(LResponse);
end;

end.
