unit SerPrestadores.Model.Dao.GenericDAO;

interface

uses
  System.SysUtils,
  System.JSON,
  Data.DB,
  REST.Json,
  Horse,
  SimpleInterface,
  SimpleDAO,
  SimpleAttributes,
  SimpleQueryFiredac,
  DataSetConverter4D,
  DataSetConverter4D.Impl,
  DataSetConverter4D.Helper,
  DataSetConverter4D.Util,
  SerPrestadores.Resource.Connection;

type
  IGenericDAO<T: class> = interface
    ['{208A66C3-802F-4EEA-9950-D30411E42797}']
    procedure Insert(const AJSONObject: TJSONObject);

    function Find: TJSONArray; overload;
    function Find(const AId: Int64): TJSONObject; overload;
    function FindByField(const AField: String; const AValue: String): TJSONArray;
    function Update(const AJSONObject: TJSONObject): TJSONObject;
    function Delete(AField: String; AValue: String): TJSONObject;
    function DAO: ISimpleDAO<T>;
    function DataSet: TDataSet;
    function DataSetAsJSONArray: TJSONArray;
    function DataSetAsJSONObject: TJSONObject;
  end;

  TGenericDAO<T: class, constructor> = class(TInterfacedObject, IGenericDAO<T>)
    private
      var FDAO: ISimpleDAO<T>;
      var FConnection: IConnection;
      var FDataSource: TDataSource; 
      var FSimpleQuery: ISimpleQuery;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: IGenericDAO<T>;

      procedure Insert(const AJSONObject: TJSONObject);

      function Find: TJSONArray; overload;
      function Find(const AId: Int64): TJSONObject; overload;
      function FindByField(const AField: String; const AValue: String): TJSONArray;
      function Update(const AJSONObject: TJSONObject): TJSONObject;
      function Delete(AField: String; AValue: String): TJSONObject;
      function DAO: ISimpleDAO<T>;
      function DataSet: TDataSet;
      function DataSetAsJSONArray: TJSONArray;
      function DataSetAsJSONObject: TJSONObject;
  end;



implementation

{ TGenericDAO<T> }

constructor TGenericDAO<T>.Create;
begin
  FDataSource := TDataSource.Create(nil);
  FConnection := TConnection.New;
  FSimpleQuery := TSimpleQueryFiredac.New(FConnection.Connect);
  FDAO := TSimpleDAO<T>.New(FSimpleQuery).DataSource(FDataSource); 
end;

function TGenericDAO<T>.DAO: ISimpleDAO<T>;
begin
  Result := FDAO;
end;

function TGenericDAO<T>.DataSet: TDataSet;
begin
  Result := FDataSource.DataSet;
end;

function TGenericDAO<T>.DataSetAsJSONArray: TJSONArray;
begin
  Result := FDataSource.DataSet.AsJSONArray;
end;

function TGenericDAO<T>.DataSetAsJSONObject: TJSONObject;
begin
  Result := FDataSource.DataSet.AsJSONObject;
end;

function TGenericDAO<T>.Delete(AField, AValue: String): TJSONObject;
begin
  FDAO.Delete(AField, AValue);
  Result := FDataSource.DataSet.AsJSONObject;
end;

destructor TGenericDAO<T>.Destroy;
begin
  FDataSource.DisposeOf;
  inherited;
end;

function TGenericDAO<T>.Find: TJSONArray;
begin
  try
    FDAO.Find;
    Result := FDataSource.DataSet.AsJSONArray;
  except on E: Exception do
    raise EHorseException.New.Error(E.Message).Status(THTTPStatus.InternalServerError);
  end;
end;

function TGenericDAO<T>.Find(const AId: Int64): TJSONObject;
begin
  try
    FDAO.Find(AId);

    if FDataSource.DataSet.RecordCount = 0 then
    begin
      raise EHorseException.New.Error('Provider não existe na base de dados').Status(THTTPStatus.BadRequest);
    end;

    Result := FDataSource.DataSet.AsJSONObject;
  except on E: Exception do
    raise EHorseException.New.Error(E.Message).Status(THTTPStatus.InternalServerError);
  end;
end;

function TGenericDAO<T>.FindByField(const AField, AValue: String): TJSONArray;
begin
  try
    FDAO
      .SQL
      .Where(QuotedStr(AField)+ ' LIKE ' + QuotedStr('%' + AField +'%'))
      .&End
      .Find;

    Result := FDataSource.DataSet.AsJSONArray;
  except on E: Exception do
    raise EHorseException.New.Error(E.Message).Status(THTTPStatus.InternalServerError);
  end;
end;

procedure TGenericDAO<T>.Insert(const AJSONObject: TJSONObject);
begin
  try
    FDAO.Insert(TJson.JsonToObject<T>(AJSONObject));
  except on E: Exception do
    raise EHorseException.New.Error(E.Message).Status(THTTPStatus.InternalServerError);
  end;
end;

class function TGenericDAO<T>.New: IGenericDAO<T>;
begin
  Result := Self.Create;
end;

function TGenericDAO<T>.Update(const AJSONObject: TJSONObject): TJSONObject;
begin
  try
    FDAO.Update(TJson.JsonToObject<T>(AJSONObject));
    Result := FDataSource.DataSet.AsJSONObject;
  except on E: Exception do
    raise EHorseException.New.Error(E.Message).Status(THTTPStatus.InternalServerError);
  end;
end;

end.
