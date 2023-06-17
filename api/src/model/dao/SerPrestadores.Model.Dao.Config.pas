unit SerPrestadores.Model.Dao.Config;

interface

uses
  SerPrestadores.Model.DAO.Entity.Config;

type
  IDAOConfig = interface
  ['{440D717C-07C8-4FD8-94D1-A1389DB7B351}']
    function SetWhereClause(AWhereClause: String): IDAOConfig;
    function SetOrderByClause(AOrderByClause: String): IDAOConfig;
    function GetConfig: TDAOConfigEntity;
  end;

  TDAOConfig = class(TInterfacedObject, IDAOConfig)
    private
      var FConfigEntity: TDAOConfigEntity;
      var FWhereClause: String;
      var FOrderByClause: String;

      procedure LoadEntity;

      function SetWhereClause(AWhereClause: String): IDAOConfig;
      function SetOrderByClause(AOrderByClause: String): IDAOConfig;
      function GetConfig: TDAOConfigEntity;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: IDAOConfig;
  end;

implementation

{ TDAOConfig }

constructor TDAOConfig.Create;
begin
  FConfigEntity := TDAOConfigEntity.Create;
  FWhereClause := '0 = 0';
  FOrderByClause := '1 asc';
end;

destructor TDAOConfig.Destroy;
begin
  FConfigEntity.DisposeOf;
  inherited;
end;

function TDAOConfig.GetConfig: TDAOConfigEntity;
begin
  Self.LoadEntity;
  Result := Self.FConfigEntity;
end;

procedure TDAOConfig.LoadEntity;
begin
  FConfigEntity.WhereClause := FWhereClause;
  FConfigEntity.OrderByClause := FOrderByClause;
end;

class function TDAOConfig.New: IDAOConfig;
begin
  Result := Self.Create;
end;

function TDAOConfig.SetOrderByClause(AOrderByClause: String): IDAOConfig;
begin
  if AOrderByClause <> '' then
  begin
    FOrderByClause := AOrderByClause;
  end;
  Result := Self;
end;

function TDAOConfig.SetWhereClause(AWhereClause: String): IDAOConfig;
begin
  if AWhereClause <> '' then
  begin
    FWhereClause := AWhereClause;
  end;
  Result := Self;
end;

end.
