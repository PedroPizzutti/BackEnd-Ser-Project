unit SerPrestadores.Model.Error.Entity;

interface

uses
  GBSwagger.Model.Attributes;

type
  [SwagClass('Error')]
  TErrorEntity = class
    private
    FErro: String;
    procedure SetErro(const Value: String);

    public
      [SwagString]
      [SwagProp('error', 'description error captured in exception')]
      property Erro: String read FErro write SetErro;
  end;

implementation

{ TErrorEntity }

procedure TErrorEntity.SetErro(const Value: String);
begin
  FErro := Value;
end;

end.
