unit SerPrestadores.Model.DAO.Entity.Config;

interface

type
  TDAOConfigEntity = class
  private
    FWhere: String;
    FOrderByClause: String;
    procedure SetWhere(const Value: String);
    procedure SetOrderByClause(const Value: String);
  public
    property WhereClause: String read FWhere write SetWhere;
    property OrderByClause: String read FOrderByClause write SetOrderByClause;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TConfigEntity }

constructor TDAOConfigEntity.Create;
begin

end;

destructor TDAOConfigEntity.Destroy;
begin

  inherited;
end;

procedure TDAOConfigEntity.SetOrderByClause(const Value: String);
begin
  FOrderByClause := Value;
end;

procedure TDAOConfigEntity.SetWhere(const Value: String);
begin
  FWhere := Value;
end;

end.
