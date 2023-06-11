unit SerPrestadores.Model.Success.Entity;

interface

uses
  System.JSON,
  GBSwagger.Model.Attributes;

type
  [SwagClass('Success')]
  TSuccessEntity = class
    private
    FSucess: String;
    procedure SetSuccess(const Value: String);

    public
      [SwagString]
      [SwagProp('success', 'success description')]
      property Success: String read FSucess write SetSuccess;

      constructor Create;
      destructor Destroy; override;

      function GetJsonEntity: TJSONObject;
  end;

implementation

{ TSuccessEntity }

constructor TSuccessEntity.Create;
begin

end;

destructor TSuccessEntity.Destroy;
begin

  inherited;
end;

procedure TSuccessEntity.SetSuccess(const Value: String);
begin
  FSucess := Value;
end;

function TSuccessEntity.GetJsonEntity: TJSONObject;
var
  LJSONEntity: TJSONObject;
begin
  LJSONEntity := TJSONObject.Create;
  try
    LJSONEntity.AddPair('success', FSucess);
    Result := LJSONEntity.Clone as TJSONObject;
  finally
    LJSONEntity.DisposeOf;
  end;
end;

end.
