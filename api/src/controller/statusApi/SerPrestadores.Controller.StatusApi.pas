unit SerPrestadores.Controller.StatusApi;

interface

uses
  System.JSON,
  Horse,
  Horse.GBSwagger,
  GBSwagger.Path.Attributes,
  SerPrestadores.Model.Success,
  SerPrestadores.Model.Success.Entity,
  SerPrestadores.Model.Error.Entity,
  SerPrestadores.Resource.Connection;

type
  [SwagPath('statusapi', 'api status')]
  TControllerStatusApi = class(THorseGBSwagger)

  public
    [SwagGET('', 'check the api status')]
    [SwagResponse(200, TSuccessEntity)]
    [SwagResponse(400, TErrorEntity)]
    [SwagResponse(500, TErrorEntity)]
    procedure Get;

  end;

implementation

{ TControllerStatusApi }

procedure TControllerStatusApi.Get;
var
  LJSONRespose: TJSONObject;
begin
  TConnection
    .New
    .Connect;

  LJSONRespose :=
    TModelSuccess
      .New
      .SetMsg('Api is up and the connection with database is ok...')
      .GetEntity
      .GetJsonEntity;

  FResponse.Send<TJSONObject>(LJSONRespose);
end;

end.
