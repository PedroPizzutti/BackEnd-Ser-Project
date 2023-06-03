unit App;

interface

uses
  System.SysUtils,
  Horse,
  Horse.CORS,
  Horse.Jhonson,
  Horse.GBSwagger;

type
  TApp = class
  private
    var FApp: THorse;
  public
    procedure Start(const APort: Int64);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TApp }

constructor TApp.Create;
begin
  //TODO
end;

destructor TApp.Destroy;
begin
  //TODO
  inherited;
end;

procedure TApp.Start(const APort: Int64);
begin
  try
    FApp.Listen(APort);
  except on E: Exception do
    raise Exception.Create('Initialization error: ' + E.Message);
  end;
end;

end.
