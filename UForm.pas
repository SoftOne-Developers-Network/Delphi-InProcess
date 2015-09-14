unit UForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ComObj,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, DBGrids, DB, ComCtrls;

type
  TFrmTest = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Image1: TImage;
    ds: TDataSource;
    DBGrid1: TDBGrid;
    Button2: TButton;
    Button3: TButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    XObjIntf: OleVariant;
    ACustumerObj,ACustTable: Variant;
    procedure WMDestroy(var Message:TMessage); message WM_DESTROY;
  public
    { Public declarations }
    constructor Create2(AOwner: TComponent; AParentHandle:integer; const AObjectInf:Variant);
  end;

implementation

{$R *.dfm}

{ TFrmTest }

constructor TFrmTest.Create2(AOwner: TComponent; AParentHandle: integer; const AObjectInf: Variant);
begin
  inherited Create(AOwner);
  XObjIntf:= AObjectInf;
  ACustumerObj:= XObjIntf.CreateObj('CUSTOMER');
  ACustTable:= ACustumerObj.FindTable('CUSTOMER');
end;

procedure TFrmTest.Button1Click(Sender: TObject);
begin
  ACustumerObj.DBInsert;
  ACustTable.Edit;
  ACustTable.code:= Edit1.Text;
  ACustTable.name := Edit2.Text;
  ACustumerObj.DBPost;
  ShowMessage('Customer data posted!');
  ACustumerObj.PRINTFORM(2, 'Microsoft Office Document Image Writer', '');
end;

procedure TFrmTest.WMDestroy(var Message: TMessage);
begin
  ShowMessage('Form Destroy!');
end;

procedure TFrmTest.Button3Click(Sender: TObject);
begin
  XObjIntf.EXCEPTION('JohnG');
end;

end.
