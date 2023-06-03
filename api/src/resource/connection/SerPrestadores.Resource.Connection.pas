unit SerPrestadores.Resource.Connection;

interface

uses
  System.SysUtils,
  System.IOUtils,
  Winapi.Windows,
  Data.DB,
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
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Comp.Client;

type
  IConnection = interface
    ['{2AFC1C37-4B00-49D8-8686-D0468274EB57}']
    function Connect: TFDConnection;
  end;

type
  TConnection = class(TInterfacedObject, IConnection)
  private
    var FConnection: TFDConnection;
    procedure DataBaseConfig;
    procedure Disconnect;
  public
    function Connect: TFDConnection;

    class function New: IConnection;
    constructor Create;
    destructor Destroy; override;
  end;

implementation


{ TConnection }

function TConnection.Connect: TFDConnection;
begin
  try
    FConnection.Connected;
    Result := FConnection;
  except on E: Exception do
    raise Exception.Create('Connection with database fail: ' + E.Message);
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
  FConnection.Params.Database := TDirectory.GetCurrentDirectory + '\bd\ser-prestadores.db';
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
