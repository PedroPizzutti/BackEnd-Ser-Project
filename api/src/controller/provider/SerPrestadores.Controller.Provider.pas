unit SerPrestadores.Controller.Provider;

interface

uses
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.SysUtils,
  System.Types,
  GBSwagger.Path.Attributes,
  Horse,
  Horse.GBSwagger,
  Horse.Jhonson,
  Horse.Commons,
  Rest.Json,
  SerPrestadores.Model.Dao.GenericDAO,
  SerPrestadores.Model.Provider.Entity;

type
  [SwagPath('providers', 'Providers')]
  TControllerProvider = class(THorseGBSwagger)
    private
      procedure ValidateProvider(AJSONObject: TJSONObject);
    
    public
      [SwagGET('', 'Lists all the providers')]
      [SwagResponse(200)]
      [SwagResponse(400)]
      [SwagResponse(500)]
      procedure GetAll;

      [SwagPOST('', 'Create a provider')]
      [SwagResponse(201)]
      [SwagResponse(400)]
      [SwagResponse(500)]
      procedure Post;
  end;

implementation

{ TControllerProvider }

procedure TControllerProvider.GetAll;
var
  FDAO: IGenericDAO<TProviderEntity>;
begin
  FDAO := TGenericDAO<TProviderEntity>.New;
  FResponse.Send<TJSONArray>(FDAO.Find);
end;

procedure TControllerProvider.Post;
var
  FDAO: IGenericDAO<TProviderEntity>;
begin
  ValidateProvider(FRequest.Body<TJSONObject>);

  FDAO := TGenericDAO<TProviderEntity>.New;
  FDAO.Insert(FRequest.Body<TJSONObject>);

  FResponse.Status(THTTPStatus.Created);
end;

procedure TControllerProvider.ValidateProvider(AJSONObject: TJSONObject);
var
  LName: String;
  LPhone: String;
  LEmail: String;
  LCpf: String;
  LBio: String;
  LProfilePic: String;
  LNullFieldsList: TStringList;
begin
  LNullFieldsList := TStringList.Create;
  try
    if not AJSONObject.TryGetValue<String>('name', LName) then
    begin
      LNullFieldsList.Add('name');
    end;

    if not AJSONObject.TryGetValue<String>('phone', LPhone) then
    begin
      LNullFieldsList.Add('phone');
    end;

    if not AJSONObject.TryGetValue<String>('email', LEmail) then
    begin
      LNullFieldsList.Add('email');
    end;

    if not AJSONObject.TryGetValue<String>('cpf', LCpf) then
    begin
      LNullFieldsList.Add('cpf');
    end;

    if not AJSONObject.TryGetValue<String>('bio', LBio) then
    begin
      LNullFieldsList.Add('bio');
    end;

    if not AJSONObject.TryGetValue<String>('profilePic', LProfilePic) then
    begin
      LNullFieldsList.Add('profilePic');
    end;

    if LNullFieldsList.Count > 0 then
    begin
      var LMsg := '';
      if LNullFieldsList.Count = 1 then
      begin
        LMsg := 'campos obrigatórios: ' + LNullFieldsList.Text;
      end
      else if LNullFieldsList.Count > 1 then
      begin
        LMsg := 'campos obrigatórios: ' + LNullFieldsList.Text;
      end;

      raise EHorseException.New.Error(LMsg).Status(THTTPStatus.BadRequest);
    end;
  finally
    LNullFieldsList.DisposeOf;
  end;
end;

end.
