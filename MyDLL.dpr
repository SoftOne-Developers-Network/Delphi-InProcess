library MyDLL;
uses
  SysUtils,
  Classes,
  variants,
  Windows,
  Dialogs,
  Forms,
  ActiveX,
  ComObj,
  ExtCtrls,
  unit3,
  Controls,
  IniFiles,
  UForm in 'UForm.pas' {FrmTest};


{$R *.res}

type
  TMyObject =  Class(TObject)
  private
    FData: OleVariant;
    FSoftOne: OleVariant;
    FTimer: TTimer;
    FMemIni : TMemIniFile;
    FSections: TStrings;
    procedure OnTimerEvent(ASender:TObject);
  public
    constructor Create(AObject: OleVariant);
    destructor Destroy; override;
  end;

var
  FMyObject: TMyObject;

{ TMyObject }

constructor TMyObject.Create(AObject: OleVariant);
var
  ASQL: string;
  k: integer;
  Strs:TStrings;
begin
  inherited Create;
  FSoftOne:= AObject;
  FTimer:= TTimer.Create(nil);
  FTimer.Interval:= 15000;
  FTimer.OnTimer := OnTimerEvent;
  FTimer.Enabled:= True;
  FData := FSoftOne.GETSQLDATASET('Select CODE, NAME FROM TRDR WHERE SODTYPE=13',null);
  ShowMessage('Demon Started! Hello!!');
end;

destructor TMyObject.Destroy;
begin
  inherited;
end;

procedure TMyObject.OnTimerEvent(ASender: TObject);
begin
  ShowMessage('Hello from DLL');
end;


function CustPost(UserPointer:Pointer; const UserData:OleVariant):OleVariant; stdcall;
var
  CustTable: OleVariant;
  s: string;
begin
  ShowMessage(Format('List=%s, Form=%s',[UserData.LIST, UserData.FORM]));
  CustTable:= UserData.FINDTABLE('CUSTOMER');
  s:=TForm1.Open(CustTable.Code, CustTable.Name, CustTable.EMail);
  if s<>'' then
  begin
    CustTable.edit;
    CustTable.Remarks:=CustTable.Remarks+' '+s;
  end else UserData.EXCEPTION('S T O P !');
end;

function Initialize(Mode: integer; const ObjectName:OleVariant; const ObjectIntf:OleVariant; var UserPointer:Pointer):OleVariant; stdcall;
begin
  case mode of
    0:  begin
          Result:='CUSTOMER';
          if Assigned(FMyObject) then FMyObject.Free;
          FMyObject:= TMyObject.Create(ObjectIntf);
        end;
    1 : if SameText(ObjectName,'CUSTOMER') then
        begin
          Result:= ObjectIntf;
          ObjectIntf.AddMethod('ON_POST', Integer(@CustPost));
        end;
    2: if SameText(ObjectName,'CUSTOMER') then
       begin

       end;
  end; { case }
end;

function InitForm(Handle:integer; const ObjIntf:Variant):integer; stdcall;
var AFrm: TFrmTest;
begin
  AFrm:= TFrmTest.Create2(nil, Handle, ObjIntf);
  Result:= AFrm.Handle;
  AFrm.Visible:=True;
end;

exports
  Initialize,
  InitForm;

begin
end.

