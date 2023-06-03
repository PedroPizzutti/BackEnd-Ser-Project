unit SerPrestadores.Model.Provider.Entity;

interface

uses
  System.Classes,
  Data.DB,
  SimpleAttributes;

type
  [Tabela('PROVIDERS')]
  TProviderEntity = class
    private
      var FName: String;
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
      [Campo('id'), Pk, AutoInc]
      property Id: Int64 read FId write SetId;

      [Campo('name')]
      property Name: String read FName write SetName;

      [Campo('phone')]
      property Phone: String read FPhone write SetPhone;

      [Campo('email')]
      property Email: String read FEmail write SetEmail;

      [Campo('cpf')]
      property Cpf: String read FCpf write SetCpf;

      [Campo('bio')]
      property Bio: String read FBio write SetBio;

      [Campo('profile_pic')]
      property ProfilePic: String read FProfilePic write SetProfilePic;
  end;

implementation

{ TProvidersEntity }

procedure TProviderEntity.SetBio(const Value: String);
begin
  FBio := Value;
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
