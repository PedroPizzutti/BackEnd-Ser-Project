unit App;

interface

uses
  System.SysUtils,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  Horse,
  Horse.JWT,
  Horse.CORS,
  Horse.Jhonson,
  Horse.GBSwagger,
  Horse.HandleException,
  SerPrestadores.Controller.User,
  SerPrestadores.Controller.Auth,
  SerPrestadores.Controller.Provider;

type
  TApp = class
  private
    var FApp: THorse;

    function HorseJWTConfig: IHorseJWTConfig;

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

function TApp.HorseJWTConfig: IHorseJWTConfig;
var
  LHorseJWTConfig: IHorseJWTConfig;
begin
  LHorseJWTConfig :=
    THorseJWTConfig
      .New
      .SkipRoutes(['/signin', '/signup', '/swagger/doc/html', '/swagger/doc/json']);

  Result := LHorseJWTConfig;
end;

procedure TApp.PrintInfo;
begin
  Writeln('--- SerPrestadores-Api ---');
  Writeln(Format('Server on: %s', [FApp.Host]));
  Writeln(Format('Port: %d', [FApp.Port]));
  {$IFDEF MSWINDOWS}
  Writeln('Press ENTER to stop the application...');
  Readln;
  THorse.StopListen;
  FreeConsole;
  {$ENDIF}
end;

procedure TApp.RegisterMiddlewares;
begin
  Self.FApp.Use(Jhonson);
  Self.FApp.Use(CORS);
  Self.FApp.Use(HorseSwagger);
  Self.FApp.Use(HandleException);
  Self.FApp.Use(HorseJWT('SER', Self.HorseJWTConfig));
end;

procedure TApp.RegisterRoutes;
begin
  THorseGBSwaggerRegister.RegisterPath(TControllerUser);
  THorseGBSwaggerRegister.RegisterPath(TControllerAuth);
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
