unit SerPrestadores.Resource.Connection;

interface

uses
  System.SysUtils,
  System.IOUtils,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  Data.DB,
  Horse,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Comp.UI,
  FireDAC.Comp.Client;

type
  IConnection = interface
    ['{2AFC1C37-4B00-49D8-8686-D0468274EB57}']
    function Connect: TFDConnection;
  end;

  TConnection = class(TInterfacedObject, IConnection)
    private
      var FConnection: TFDConnection;
      procedure DataBaseConfig;
      procedure Disconnect;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: IConnection;

      function Connect: TFDConnection;
    end;

implementation


{ TConnection }

function TConnection.Connect: TFDConnection;
begin
  try
    FConnection.Connected;
    Result := FConnection;
  except on E: Exception do
    raise EHorseException.New.Error('Connection with database fail: ' + E.Message).Status(THTTPStatus.InternalServerError);
  end;  
end;

constructor TConnection.Create;
begin
  FConnection := TFDConnection.Create(nil);
  Self.DataBaseConfig;
end;

procedure TConnection.DataBaseConfig;
begin
  FConnection.Params.DriverID := 'SQLite';
  {$IFDEF MSWINDOWS}
  FConnection.Params.Database := TDirectory.GetCurrentDirectory + '\bd\ser-prestadores.db';
  {$ELSE}
  FConnection.Params.Database :='/opt/api/bd/ser-prestadores.db';
  {$ENDIF}
  FConnection.Params.UserName := '';
  FConnection.Params.Password := '';
  FConnection.Params.Add('LockingMode=Normal');
end;

destructor TConnection.Destroy;
begin
  Self.Disconnect;
  FConnection.DisposeOf;
  inherited;
end;

procedure TConnection.Disconnect;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Connected := False;
  end;
end;

class function TConnection.New: IConnection;
begin
  Result := Self.Create;
end;

end.
