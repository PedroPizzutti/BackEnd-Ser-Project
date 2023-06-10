unit SerPrestadores.Utils;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON,
  BCrypt,
  Horse,
  Horse.JWT,
  JOSE.Types.Bytes,
  JOSE.Core.JWT,
  JOSE.Core.Builder;

type
  TUtils = class
  public
    class function GenerateToken(AIdUser: String): String;
    class procedure EncryptPasswordJSON(var AJSONObject: TJSONObject; const APasswordField: String);
    class procedure ValidateId(const AId: Int64);
    class procedure ValidateFieldsString(const AJSONObject: TJSONObject; const AFieldList: TStringList);
  end;

implementation

{ TUtils }

class procedure TUtils.EncryptPasswordJSON(var AJSONObject: TJSONObject;
  const APasswordField: String);
var
  LPassword: String;
  LEncryptedPassword: String;
begin
  try
    AJSONObject.TryGetValue<String>(APasswordField, LPassword);
    if LPassword <> '' then
    begin
      LEncryptedPassword := TBCrypt.GenerateHash(LPassword);
      AJSONObject.Get(APasswordField).JsonValue := TJSONString.Create(LEncryptedPassword);
    end;
  except on E: Exception do
    raise EHorseException.New.Error('encrypt error - ' + E.Message).Status(THTTPStatus.InternalServerError);
  end;
end;

class function TUtils.GenerateToken(AIdUser: String): String;
var
  LJWT: TJWT;
begin
  LJWT := TJWT.Create;
  try
    LJWT.Claims.Issuer := 'SerPrestadores';
    LJWT.Claims.Subject := AIdUser;
    LJWT.Claims.Expiration := Now + 1;

    Result := TJOSE.SHA256CompactToken('SER', LJWT);
  finally
    LJWT.DisposeOf;
  end;
end;

class procedure TUtils.ValidateFieldsString(const AJSONObject: TJSONObject;
  const AFieldList: TStringList);
var
  LField: String;
  LNullFields: TStringList;
begin
  LNullFields := TStringList.Create;
  try
    for var LCount := 0 to (AFieldList.Count - 1) do
    begin
      if not AJSONObject.TryGetValue<String>(AFieldList[LCount], LField) then
      begin
        LNullFields.Add(AFieldList[LCount]);
      end;
    end;

    if LNullFields.Count > 0 then
    begin
      var LMsg := '';
      if LNullFields.Count = 1 then
      begin
        LMsg := 'Required field: ' + LNullFields.Text;
      end
      else
      begin
        LMsg := 'Required fields: ' + LNullFields.Text;
      end;

      raise EHorseException.New.Error(LMsg).Status(THTTPStatus.BadRequest);
    end;
  finally
    LNullFields.DisposeOf;
  end;
end;

class procedure TUtils.ValidateId(const AId: Int64);
begin
  if Aid <= 0 then
  begin
    raise EHorseException.New.Error('It is necessary to informe an id').Status(THTTPStatus.BadRequest);
  end;
end;

end.
