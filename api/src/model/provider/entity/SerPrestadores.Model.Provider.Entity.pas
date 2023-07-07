unit SerPrestadores.Model.Provider.Entity;

interface

uses
  Data.DB,
  GBSwagger.Model.Attributes,
  System.Classes,
  SimpleAttributes;

type
  [SwagClass('Providers')]
  [Tabela('providers')]
  TProviderEntity = class
    private
      var FName: String;
    FColor: String;
    procedure SetColor(const Value: String);
      var FEmail: String;
      var FCpf: String;
      var FBio: String;
      var FPhone: String;
      var FId: Int64;
      var FProfilePic: String;
      procedure SetBio(const Value: String);
      procedure SetCpf(const Value: String);
      procedure SetEmail(const Value: String);
      procedure SetId(const Value: Int64);
      procedure SetName(const Value: String);
      procedure SetPhone(const Value: String);
      procedure SetProfilePic(const Value: String);
    public
      [SwagIgnore]
      [SwagNumber]
      [SwagProp('id', 'id')]
      [Campo('id'), Pk, AutoInc]
      property Id: Int64 read FId write SetId;

      [SwagString]
      [SwagProp('name', 'name')]
      [SwagRequired]
      [Campo('name'), NotNull]
      property Name: String read FName write SetName;

      [SwagString]
      [SwagProp('phone', 'telephone')]
      [SwagRequired]
      [Campo('phone'), NotNull]
      property Phone: String read FPhone write SetPhone;

      [SwagString]
      [SwagProp('email', 'e-mail')]
      [SwagRequired]
      [Campo('email'), NotNull]
      property Email: String read FEmail write SetEmail;

      [SwagString]
      [SwagProp('cpf', 'cpf')]
      [SwagRequired]
      [Campo('cpf'), NotNull]
      property Cpf: String read FCpf write SetCpf;

      [SwagString]
      [SwagProp('bio', 'a little biography')]
      [Campo('bio'), NotNull]
      property Bio: String read FBio write SetBio;

      [SwagString]
      [SwagProp('profilePic', 'profile picture')]
      [Campo('profilePic')]
      property ProfilePic: String read FProfilePic write SetProfilePic;

      [SwagString]
      [SwagProp('color', 'color')]
      [Campo('color')]
      property Color: String read FColor write SetColor;
  end;

implementation

{ TProvidersEntity }

procedure TProviderEntity.SetBio(const Value: String);
begin
  FBio := Value;
end;

procedure TProviderEntity.SetColor(const Value: String);
begin
  FColor := Value;
end;

procedure TProviderEntity.SetCpf(const Value: String);
begin
  FCpf := Value;
end;

procedure TProviderEntity.SetEmail(const Value: String);
begin
  FEmail := Value;
end;

procedure TProviderEntity.SetId(const Value: Int64);
begin
  FId := Value;
end;

procedure TProviderEntity.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TProviderEntity.SetPhone(const Value: String);
begin
  FPhone := Value;
end;

procedure TProviderEntity.SetProfilePic(const Value: String);
begin
  FProfilePic := Value;
end;

end.
