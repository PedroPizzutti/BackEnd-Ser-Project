unit SerPrestadores.Model.Success;

interface

uses
  SerPrestadores.Model.Success.Entity;

type
  IModelSuccess = interface
    function GetEntity: TSuccessEntity;
    function SetMsg(AMsg: String): IModelSuccess;
  end;

  TModelSuccess = class(TInterfacedObject, IModelSuccess)
    private
      var FMsgSuccess: String;
      var FSuccessEntity: TSuccessEntity;

      function GetEntity: TSuccessEntity;
      function SetMsg(AMsg: String): IModelSuccess;

      procedure LoadEntity;

      constructor Create;
      destructor Destroy; override;
    public
      class function New: IModelSuccess;
  end;

implementation

{ TModelSuccess }

constructor TModelSuccess.Create;
begin
  FMsgSuccess := '';
  FSuccessEntity := TSuccessEntity.Create;
end;

destructor TModelSuccess.Destroy;
begin
  FSuccessEntity.DisposeOf;
  inherited;
end;

function TModelSuccess.GetEntity: TSuccessEntity;
begin
  Self.LoadEntity;
  Result := FSuccessEntity;
end;

procedure TModelSuccess.LoadEntity;
begin
  FSuccessEntity.Success := FMsgSuccess;
end;

class function TModelSuccess.New: IModelSuccess;
begin
  Result := Self.Create;
end;

function TModelSuccess.SetMsg(AMsg: String): IModelSuccess;
begin
  if AMsg <> '' then
  begin
    FMsgSuccess := AMsg;
  end;
  Result := Self;
end;

end.
