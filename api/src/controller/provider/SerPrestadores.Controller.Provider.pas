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
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.Provider.Entity;

type
  [SwagPath('providers', 'Providers')]
  TControllerProvider = class(THorseGBSwagger)
    public
      [SwagGET('', 'Lists all the providers')]
      [SwagResponse(200)]
      [SwagResponse(400)]
      [SwagResponse(500)]
      procedure GetAll;

      [SwagPOST('', 'Create a provider')]
      [SwagResponse(201)]
      [SwagResponse(400)]
      [SwagResponse(500)]
      procedure Post;
  end;

implementation

{ TControllerProvider }

procedure TControllerProvider.GetAll;
var
  FDAO: IGenericDAO<TProviderEntity>;
begin
  FDAO := TGenericDAO<TProviderEntity>.New;
  FResponse.Send<TJSONArray>(FDAO.Find);
end;

procedure TControllerProvider.Post;
var
  FDAO: IGenericDAO<TProviderEntity>;
  LEntity: TProviderEntity;
begin
  FDAO := TGenericDAO<TProviderEntity>.New;

  LEntity := TProviderEntity.Create;
  try;
    LEntity.Name := FRequest.Body<TJSONObject>.GetValue('name').ToString;
    LEntity.Phone := FRequest.Body<TJSONObject>.GetValue('phone').ToString;
    LEntity.Email := FRequest.Body<TJSONObject>.GetValue('email').ToString;
    LEntity.Cpf := FRequest.Body<TJSONObject>.GetValue('cpf').ToString;
    LEntity.Bio := FRequest.Body<TJSONObject>.GetValue('bio').ToString;
    LEntity.ProfilePic := FRequest.Body<TJSONObject>.GetValue('profilePic').ToString;

     FResponse.Send<TJSONObject>(FDAO.Insert(LEntity));
  finally
    LEntity.DisposeOf;
  end;
end;

end.
