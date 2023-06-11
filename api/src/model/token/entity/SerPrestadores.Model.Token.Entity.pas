unit SerPrestadores.Model.Token.Entity;

interface

uses
  GBSwagger.Model.Attributes;

type
  [SwagClass('Token')]
  TTokenEntity = class
    private
    FToken: String;
    procedure SetToken(const Value: String);

    public
      [SwagString]
      [SwagProp('token', 'bearer token')]
      property Token: String read FToken write SetToken;
  end;

implementation

{ TTokenEntity }

procedure TTokenEntity.SetToken(const Value: String);
begin
  FToken := Value;
end;

end.
