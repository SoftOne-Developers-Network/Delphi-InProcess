unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Open(const custcode, custName, custemail:string):string;
  end;


implementation

{$R *.dfm}

class function TForm1.Open(const custcode, custName, custemail:string):string;
var
  Form1: TForm1;
begin
  Form1:= TForm1.Create(nil);
  try
    with form1 do
    begin
      Edit1.Text := custcode;
      Edit2.Text := custName;
      Edit3.Text := custemail;
      if ShowModal=mrOk then
        Result:= 'Hello from DLL!  e mail Sended!'
      else Result:= '';
    end;
  finally
    Form1.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ModalResult:= mrOk;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

end.
