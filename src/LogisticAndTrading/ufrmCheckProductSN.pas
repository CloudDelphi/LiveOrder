unit ufrmCheckProductSN;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBasic, StdCtrls, ADODB;

type
  TfrmCheckProductSN = class(TfrmBasic)
    Edit1: TEdit;
    Label1: TLabel;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    gProductTrackingID: string;
    procedure SetData; override;
    procedure SetUI; override;
    procedure SetAccess; override;
  public
    { Public declarations }
    class procedure EdtFromList(ProductTrackingID: integer);
  end;

implementation

uses DataModule;

{$R *.dfm}

{ TfrmCheckProductSN }

procedure TfrmCheckProductSN.SetData;
begin
  inherited;

end;

procedure TfrmCheckProductSN.SetUI;
begin
//  inherited;

end;

procedure TfrmCheckProductSN.SetAccess;
begin
  inherited;

end;

class procedure TfrmCheckProductSN.EdtFromList(ProductTrackingID: integer);
begin
  with TfrmCheckProductSN.Create(Application) do
  try
    gProductTrackingID := IntToStr(ProductTrackingID);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmCheckProductSN.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  strSql, ProductSerialNumber: string;
  adt1: TADODataSet;
  sl: TStringList;
begin
  inherited;
  if (Key = #13) then
  begin
    if Trim(Edit1.Text) = '' then
    begin
      ShowMessage('please input SN.');
      exit;
    end;
    sl := TStringList.Create;
    sl.CommaText := Trim(Edit1.Text);
    ProductSerialNumber := sl[1];
    sl.Free;
    adt1 := TADODataSet.Create(nil);
    try
      strSql := 'select * from ViewProductTracking '
        + ' where ProductTrackingID=' + gProductTrackingID
        + ' and ProductSerialNumber=''' + ProductSerialNumber + '''';
      DM.DataSetQuery(adt1, strSql);
      if adt1.RecordCount = 0 then
      begin
        ShowMessage('Serial Number is Wrong.');
        Edit1.Clear;
      end
      else
        Close;
    finally
      adt1.Free;
    end;
  end;
end;

end.

