unit SerPrestadores.Model.Provider;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  SerPrestadores.Utils,
  SerPrestadores.Model.Dao.Config,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.Success,
  SerPrestadores.Model.DAO.Entity.Config,
  SerPrestadores.Model.Provider.Entity,
  SerPrestadores.Model.Success.Entity;

type
  IModelProvider = interface
    function SetId(AIdProvider: Int64): IModelProvider;
    function SetName(AName: String): IModelProvider;
    function SetJSONProvider(AJSONProvider: TJSONObject): IModelProvider;

    function PostProvider: TJSONObject;
    function UpdateProvider: TJSONObject;
    function DeleteProvider: TJSONObject;
    function GetAllProviders: TJSONArray;
    function GetProviderById: TJSONObject;
    function GetProviderByNameLiked: TJSONArray;
  end;

  TModelProvider = class(TInterfacedObject, IModelProvider)
    private
      var FDAOConfig: TDAOConfigEntity;
      var FId: Int64;
      var FName: String;
      var FJSONProvider: TJSONObject;
      var FDAOProvider: IGenericDAO<TProviderEntity>;

      function SetId(AIdProvider: Int64): IModelProvider;
      function SetName(AName: String): IModelProvider;
      function SetJSONProvider(AJSONProvider: TJSONObject): IModelProvider;

      function PostProvider: TJSONObject;
      function UpdateProvider: TJSONObject;
      function DeleteProvider: TJSONObject;
      function GetAllProviders: TJSONArray;
      function GetProviderById: TJSONObject;
      function GetProviderByNameLiked: TJSONArray;

      procedure ValidateFieldsProvider;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: IModelProvider;
  end;

implementation

{ TModelProvider }

constructor TModelProvider.Create;
begin
  FId := 0;
  FName := '';
  FJSONProvider := nil;
  FDAOProvider := TGenericDAO<TProviderEntity>.New;
end;

function TModelProvider.DeleteProvider: TJSONObject;
begin
  Self.GetProviderById;

  FDAOProvider.Delete('id', FId.ToString);

  Result :=
    TModelSuccess
      .New
      .SetMsg('deleted provider')
      .GetEntity
      .GetJsonEntity;
end;

destructor TModelProvider.Destroy;
begin

  inherited;
end;

function TModelProvider.GetAllProviders: TJSONArray;
begin
  FDAOConfig :=
    TDAOConfig
      .New
      .SetOrderByClause('name desc')
      .GetConfig;

  Result :=
    FDAOProvider
      .Find(FDAOConfig);
end;

function TModelProvider.GetProviderById: TJSONObject;
begin
  Result := FDAOProvider.FindById(FId);
end;

function TModelProvider.GetProviderByNameLiked: TJSONArray;
begin
  FDAOConfig :=
    TDAOConfig
      .New
      .SetWhereClause('name like ' + QuotedStr(FName + '%'))
      .GetConfig;

  Result := FDAOProvider.Find(FDAOConfig);
end;

class function TModelProvider.New: IModelProvider;
begin
  Result := Self.Create;
end;

function TModelProvider.PostProvider: TJSONObject;
begin
  Self.ValidateFieldsProvider;

  FDAOProvider.Insert(FJSONProvider);

  Result :=
    TModelSuccess
      .New
      .SetMsg('created provider')
      .GetEntity
      .GetJsonEntity;
end;

function TModelProvider.SetId(AIdProvider: Int64): IModelProvider;
begin
  if AIdProvider <> 0 then
  begin
    FId := AIdProvider;
  end;
  Result := Self;
end;

function TModelProvider.SetJSONProvider(
  AJSONProvider: TJSONObject): IModelProvider;
begin
  if Assigned(AJSONProvider) then
  begin
    FJSONProvider := AJSONProvider;
  end;
  Result := Self;
end;

function TModelProvider.SetName(AName: String): IModelProvider;
begin
  if AName <> '' then
  begin
    FName := AName;
  end;
  Result := Self;
end;

function TModelProvider.UpdateProvider: TJSONObject;
begin
  Self.GetProviderById;
  Self.ValidateFieldsProvider;

  FJSONProvider.AddPair('id', FId);

  FDAOProvider.Update(FJSONProvider);

  Result :=
    TModelSuccess
      .New
      .SetMsg('updated provider')
      .GetEntity
      .GetJsonEntity;
end;

procedure TModelProvider.ValidateFieldsProvider;
var
  LFieldsToValidate: TStringList;
begin
  LFieldsToValidate := TStringList.Create;
  try
    LFieldsToValidate.Add('name');
    LFieldsToValidate.Add('phone');
    LFieldsToValidate.Add('email');
    LFieldsToValidate.Add('cpf');

    TUtils.ValidateFieldsString(FJSONProvider, LFieldsToValidate);
  finally
    LFieldsToValidate.DisposeOf;
  end;
end;

end.
