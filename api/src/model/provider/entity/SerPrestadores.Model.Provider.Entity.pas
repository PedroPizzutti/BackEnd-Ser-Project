unit SerPrestadores.Model.Provider.Entity;

interface

uses
  System.Classes,
  Data.DB,
  SimpleAttributes;

type
  [Tabela('PROVIDERS')]
  TProvidersEntity = class
    private
      var FName: String;
      var FEmail: String;
      var FCpf: String;
      var FBio: String;
      var FPhone: String;
      var FId: Int64;
      var FProfilePic: TBlobType;
      procedure SetBio(const Value: String);
      procedure SetCpf(const Value: String);
      procedure SetEmail(const Value: String);
      procedure SetId(const Value: Int64);
      procedure SetName(const Value: String);
      procedure SetPhone(const Value: String);
      procedure SetProfilePic(const Value: TBlobType);
    public
      [Campo('id'), Pk, AutoInc]
      property Id: Int64 read FId write SetId;

      [Campo('profiele_pic')]
      property ProfilePic: TBlobType read FProfilePic write SetProfilePic;

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
  end;

implementation

{ TProvidersEntity }

procedure TProvidersEntity.SetBio(const Value: String);
begin
  FBio := Value;
end;

procedure TProvidersEntity.SetCpf(const Value: String);
begin
  FCpf := Value;
end;

procedure TProvidersEntity.SetEmail(const Value: String);
begin
  FEmail := Value;
end;

procedure TProvidersEntity.SetId(const Value: Int64);
begin
  FId := Value;
end;

procedure TProvidersEntity.SetName(const Value: String);
begin
  FName := Value;
end;

procedure TProvidersEntity.SetPhone(const Value: String);
begin
  FPhone := Value;
end;

procedure TProvidersEntity.SetProfilePic(const Value: TBlobType);
begin
  FProfilePic := Value;
end;

end.
