unit SerPrestadores.Model.User.Entity;

interface

uses
  Data.DB,
  GBSwagger.Model.Attributes,
  System.Classes,
  SimpleAttributes;

type
  [SwagClass('Users')]
  [Tabela('users')]
  TUserEntity = class
    private
      Fname: String;
      Femail: String;
      Fid: Int64;
      FprofilePic: String;
      Fpassword: String;
      procedure Setemail(const Value: String);
      procedure Setid(const Value: Int64);
      procedure Setname(const Value: String);
      procedure Setpassword(const Value: String);
      procedure SetprofilePic(const Value: String);
    public
      [SwagIgnore]
      [SwagNumber]
      [SwagProp('id', 'id')]
      [Campo('id'), Pk, AutoInc]
      property id: Int64 read Fid write Setid;

      [SwagString]
      [SwagRequired]
      [SwagProp('name', 'name')]
      [Campo('name'), NotNull]
      property name: String read Fname write Setname;

      [SwagString]
      [SwagRequired]
      [SwagProp('email', 'e-mail')]
      [Campo('email'), NotNull]
      property email: String read Femail write Setemail;

      [SwagString]
      [SwagRequired]
      [SwagProp('password', 'password')]
      [Campo('password'), NotNull]
      property password: String read Fpassword write Setpassword;

      [SwagString]
      [SwagProp('profilePic', 'profile picture')]
      [Campo('profilePic')]
      property profilePic: String read FprofilePic write SetprofilePic;
  end;

implementation

{ TUserEntity }

procedure TUserEntity.Setemail(const Value: String);
begin
  Femail := Value;
end;

procedure TUserEntity.Setid(const Value: Int64);
begin
  Fid := Value;
end;

procedure TUserEntity.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TUserEntity.Setpassword(const Value: String);
begin
  Fpassword := Value;
end;

procedure TUserEntity.SetprofilePic(const Value: String);
begin
  FprofilePic := Value;
end;

end.
