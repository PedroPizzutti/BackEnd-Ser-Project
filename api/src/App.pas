unit App;

interface

uses
  System.SysUtils,
  Winapi.Windows,
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  Horse.GBSwagger,
  SerPrestadores.Controller.Provider;

type
  TApp = class
  private
    var FApp: THorse;
    procedure RegisterMiddlewares;
    procedure RegisterRoutes;
    procedure PrintInfo;
  public
    procedure Start(const APort: Int64);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TApp }

constructor TApp.Create;
begin
  Self.FApp := THorse.Create;
  Self.RegisterMiddlewares;
  Self.RegisterRoutes;
  ReportMemoryLeaksOnShutdown := True;
end;

destructor TApp.Destroy;
begin
  inherited;
end;

procedure TApp.PrintInfo;
begin
  Writeln('--- SerPrestadores-Api ---');
  Writeln(Format('Server on: %s', [FApp.Host]));
  Writeln(Format('Port: %d', [FApp.Port]));
  Writeln('Press ENTER to stop the application...');
  Readln;
  THorse.StopListen;
  FreeConsole;
end;

procedure TApp.RegisterMiddlewares;
begin
  Self.FApp.Use(Jhonson);
  Self.FApp.Use(CORS);
  Self.FApp.Use(HorseSwagger);
end;

procedure TApp.RegisterRoutes;
begin
  THorseGBSwaggerRegister.RegisterPath(TControllerProvider);
end;

procedure TApp.Start(const APort: Int64);
begin
  try
    FApp.Listen(APort, Self.PrintInfo);
  except on E: Exception do
    Writeln('Initialization erro: ' + E.Message);
  end;
end;

end.
