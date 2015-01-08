{ *************************************************************************** }
{                                                                             }
{ Martin Ji Technology and Business Library            }
{ Copyright (c) 2008 mj Software Corporation           }
{
{ Include Arithmetic,Business, DBGridEh           }
{                                                 }
{ *************************************************************************** }



unit uMJ;

interface
uses DB, ADODB, StdCtrls, SysUtils, StrUtils, Forms, Classes, ShellApi,
  Windows, Controls, Menus, ComCtrls, Math, Dialogs, DBGridEh, Graphics,
  ExtCtrls, IdMessage, IdSMTP, comObj, variants, winsock, DBLookupEh, Buttons,
  IdAttachment;

type
  TLoginEmailServer = record //��¼�ʼ������������Ϣ��¼
    SMTPHost: string;
    SMTPPort: integer;
    Username: string;
    Password: string;
    SmtpAuthType: integer; //������֤��ʽ��0��������֤��1����Ҫ��֤
  end;

  PStrRec = ^TStrRec;
  TStrRec = record
    str1: string;
    str2: string;
    str3: string;
    str4: string;
    str5: string;
    str6: string;
    str7: string;
    str8: string;
    str9: string;
    str10: string;
    str11: string;
    str12: string;
    str13: string;
  end;

  PlantSet = set of Byte;

  TGlobalVars = class
    CurLoginID: integer;
    CurUser: string;
    CurUserLevel: integer;
    CurUserDisplayName: string;
    CurUserPlantID: string;
    CurUserPlantIDSet: PlantSet;
    CurUserPlant: string;
    CurUserBusinessID: string;
    CurUserBusiness: string;
    CurUserMFDisplayName: string;
    CurCommunicatorID: integer;
    {
    CurUserCode: string;
    CurUserMail: string;     }
    CurState: boolean; //trueΪ��ǰ�ѵ�½��falseΪͷ�ε�½
    CurUserLonginTime: tdatetime; //�����½ʱ��
   // CurUserBusiness: string;
    ExportExcelListView: string; //����EXCEL�Ŀؼ���
    SetScreenScale: string;
    ScreenWidth: string;
    ScreenHeight: string;
    TfrmProcessTradingOrderFrozenCols: string;
  end;


(*
  CurLoginID: integer;
  CurUser: string;
  CurUserLevel: integer;
  CurUserDisplayName: string;
  CurUserPlantID: string;
  CurUserPlantIDSet: PlantSet;
  CurUserPlant: string;
  CurUserMFDisplayName: string;
  {
  CurUserCode: string;
  CurUserMail: string;     }
  CurState: boolean; //trueΪ��ǰ�ѵ�½��falseΪͷ�ε�½
  CurUserLonginTime: tdatetime; //�����½ʱ��
 // CurUserBusiness: string;
           *)

  TCommon = class
  private
  public
  end;



{ 1.Arithmetic }
function IsNumberic(Vaule: string): Boolean; //�ж�Vaule�ǲ�������
function mjGetRound(R: Double): Integer;
function mjCovFileDate(Fd: _FileTime): TDateTime;
function mjGetFileTime(const Tf: string): TDateTime;
function mjSmallTOBig(small: real): string;
function mjSplit(src, dec: string): TStringList;
function mjPosEnd(const substr, str: string): integer;
function mjSymbolCount(const str: string): integer;

{ 2.Business }
procedure mjOpenFormByTemplate(FormName: string;
  FormClass: TFormClass; AOwner: TComponent = nil; modal: boolean = false);

//procedure mjSplitSchedule(DataSet: TDataSet);
procedure mjOpenForm(FormClass: TFormClass; AOwner: TComponent = nil; modal: boolean = false); //�򿪴���
procedure mjReadOnlyAllGrid(Sender: TObject);
//procedure mjCloseAllForm(parentFrm : TForm);
//procedure mjCreateMDIForm(aForm: TForm; AFormClass: TFormClass);
function mjCreateModalForm(FormClass: TFormClass; AOwner: TComponent = nil): TForm;


{ 3.ADODataset / DBGridEh }
procedure mjOpenAllADT(Sender: TObject);
procedure mjCloseAllADT(Sender: TObject);
procedure mjRefreshAllADT(Sender: TObject);

procedure mjDBGridEhSort(Sender: TObject; ACol: Integer; Column: TColumnEh);
procedure mjDBGridEhOpenTitleButton(Sender: TObject);
procedure mjDBGridEhDragDropInSameDBTable(dbgFrom, dbgTo: TDBGridEh;
  StateStr, aState: string);
procedure mjDBGridEhDragDropInSameDBTable2(dbgFrom, dbgTo: TDBGridEh;
  StateStr, aState, aDate: string);

{4. other}
{function mjSendEmail(poSMTPServer: TLoginEmailServer; poBody: Tstrings; psFromEmial,
  psToEmail, psSubject: string; psContentType: string;
  CCToEmail: string; poAttachmentPath: TStrings): integer;}
procedure mjSendOutlookMail(Email, Subject: string; Body: Widestring; Filename: string);
function mjGetHz(s: string): string;
//function mjKillTask(ExeFileName: string): Integer;
function mjGetLocalIpList(var IpList: TStringList): Integer;
procedure mjDisabledMenu(mainForm: TForm); //ʹ���в˵�������
procedure mjEnabledMenu(mainForm: TForm; menuname: string); //����û��ɲ����Ĳ˵�
function mjCheckKey(var Key: char; str: string): boolean;
procedure mjGetOrder(ListB: TlistBox);
function mjCClearData(form: TForm): boolean;
function mjGetMemoryInfo: integer;
function mjShowAbout(): boolean;
//procedure mjDraw(form: tform); //���ƴ���߿�
procedure mjLockForm(Panel1: TPanel);
procedure mjUnLockForm(Panel1: TPanel);
function mjGetBuildInfo: string; //��ȡ�汾��
function mjGetVarType(const v: Variant): string;
procedure mjSendMailReport(mailFrom, mailRecipient, mailSubject, mailBody: string);
function mjSendEmail(poSMTPServer: TLoginEmailServer; poBody: Tstrings; psFromEmial,
  psToEmail, psSubject: string; psContentType: string; CCToEmail: string; poAttachmentPath: TStrings): integer;



function gVars: TGlobalVars;

implementation

uses DataModule;

var
  fGlobalVars: TGlobalVars = nil;

function gVars: TGlobalVars;
begin
  if fGlobalVars = nil then
    fGlobalVars := TGlobalVars.Create;
  Result := fGlobalVars;
end;

function IsNumberic(Vaule: string): Boolean; //�ж�Vaule�ǲ�������
var
  i: integer;
begin
  result := true; //���÷���ֵΪ �ǣ��棩
  Vaule := trim(Vaule); //ȥ�ո�
  if Vaule = '' then
    Result := false
  else
  begin
    for i := 1 to length(Vaule) do //׼��ѭ��
    begin
      if not (Vaule[i] in ['0'..'9']) then //���Vaule�ĵ�i���ֲ���0-9�е���һ��
      begin
        if not (Vaule[i] in ['.']) then
        begin
          result := false; //����ֵ ���ǣ��٣�
          exit; //�˳�����
        end;
      end;
    end;
  end;
end;

function mjGetRound(R: Double): Integer;
var
  x: double;
begin
{
  if R < 0 then
    Result := Trunc(R - 0.5)
  else
    Result := Trunc(R + 0.5);
}
  x := R - Trunc(R);
  if x >= 0.5 then
    Result := Trunc(R) + 1
  else
    Result := Trunc(R);
end;

function mjCovFileDate(Fd: _FileTime): TDateTime;
var
  Tct: _SystemTime;
  Temp: _FileTime;
begin
  FileTimeToLocalFileTime(Fd, Temp);
  FileTimeToSystemTime(Temp, Tct);
  mjCovFileDate := SystemTimeToDateTime(Tct);
end;

function mjGetFileTime(const Tf: string): TDateTime;
  {   ��ȡ�ļ�ʱ�䣬Tf��ʾĿ���ļ�·��������   }
var
  Tp: TSearchRec; {   ����TpΪһ�����Ҽ�¼   }
begin
  FindFirst(Tf, faAnyFile, Tp); {   ����Ŀ���ļ�   }
  Result := mjCovFileDate(Tp.FindData.ftCreationTime);
      {   �����ļ��Ĵ���ʱ��   }
 // FindClose(Tp);
end;

function mjSmallTOBig(small: real): string;
var
  SmallMonth, BigMonth: string;
  wei1, qianwei1: string[2];
  qianwei, dianweizhi, qian: integer; //wei,
begin
  {-------   �޸Ĳ�����ֵ����ȷ   -------}
  {С������λ������Ҫ�Ļ�Ҳ���ԸĶ���ֵ}
  qianwei := -2;

  {ת���ɻ�����ʽ����Ҫ�Ļ�С�����Ӷ༸����}
  Smallmonth := formatfloat('0.00', small);
  {---------------------------------}

  dianweizhi := pos('.', Smallmonth); {С�����λ��}

  {ѭ��Сд���ҵ�ÿһλ����Сд���ұ�λ�õ����}
  for qian := length(Smallmonth) downto 1 do
  begin
  {��������Ĳ���С����ͼ���}
    if qian <> dianweizhi then
    begin

  {λ���ϵ���ת���ɴ�д}
      case strtoint(copy(Smallmonth, qian, 1)) of

        1: wei1 := 'Ҽ'; 2: wei1 := '��';
        3: wei1 := '��'; 4: wei1 := '��';
        5: wei1 := '��'; 6: wei1 := '½';
        7: wei1 := '��'; 8: wei1 := '��';
        9: wei1 := '��'; 0: wei1 := '��';
      end;

  {�жϴ�дλ�ã����Լ�������real���͵����ֵ������˭����ô��Ǯ}
      case qianwei of
        -3: qianwei1 := '��';
        -2: qianwei1 := '��';
        -1: qianwei1 := '��';
        0: qianwei1 := 'Ԫ';
        1: qianwei1 := 'ʰ';
        2: qianwei1 := '��';
        3: qianwei1 := 'ǧ';
        4: qianwei1 := '��';
        5: qianwei1 := 'ʰ';
        6: qianwei1 := '��';
        7: qianwei1 := 'ǧ';
        8: qianwei1 := '��';
        9: qianwei1 := 'ʮ';
        10: qianwei1 := '��';
        11: qianwei1 := 'ǧ';
      end;

      inc(qianwei);
      BigMonth := wei1 + qianwei1 + BigMonth; {��ϳɴ�д���}
    end;
  end;
  mjSmallTOBig := BigMonth;
end;

function mjSplit(src, dec: string): TStringList;
var
  i: integer;
  str: string;
begin
  result := TStringList.Create;
  repeat
    i := pos(dec, src);
    str := copy(src, 1, i - 1);
   { if (str = '') and (i > 0) then
    begin
      delete(src, 1, length(dec));
      continue;
    end; }
    if i > 0 then
    begin
      result.Add(str);
      delete(src, 1, i + length(dec) - 1);
    end;
  until i <= 0;
  //if src <> '' then
  result.Add(src);
end;

function mjPosEnd(const substr, str: string): integer;
var
  tmp: string;
  i, j, flag: integer;
begin
  j := 0;
  flag := -1;
  tmp := str;
  i := pos(substr, tmp);
  while i <> 0 do
  begin
    delete(tmp, i, 1);
    inc(flag);
    j := i;
    i := pos(substr, tmp);
  end;
  result := j + flag;
end;

function mjSymbolCount(const str: string): integer;
var
  i, j: integer;
begin
  j := 0;
  for i := 1 to Length(str) do
  begin
    if str[i] = ',' then
    begin
      j := j + 1;
    end;
  end;
  Result := j;
end;

{ 2. }

procedure mjOpenForm(FormClass: TFormClass;
  AOwner: TComponent = nil; modal: boolean = false);
var
  i: integer;
  AForm, Child: TForm;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType = FormClass then
    begin
      Child := Screen.Forms[i];
      if Child.WindowState = wsMinimized then
        Child.WindowState := wsNormal;
      Child.BringToFront;
      Child.Setfocus;
      TForm(AForm) := Child;
      exit;
    end;
  Child := TForm(FormClass.NewInstance);
  Child.Position := poScreenCenter;
  TForm(AForm) := Child;
  if not assigned(aowner) then aowner := application;

  if modal then
  begin
    Child.Create(AOwner);
    if Child.FormStyle = fsMDIChild then
      Child.FormStyle := fsNormal;
    Child.Visible := false;
    Child.ShowModal;
    exit;
  end
  else
  begin
    Child.Create(AOwner);
    if Child.FormStyle = fsNormal then
      Child.FormStyle := fsMDIChild;
    Child.WindowState := wsMaximized;
    Child.Show;
  end;
end;

function mjCreateModalForm(FormClass: TFormClass;
  AOwner: TComponent = nil): TForm;
var
  i: integer;
  AForm, Child: TForm;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType = FormClass then
    begin
      Child := Screen.Forms[i];
      if Child.WindowState = wsMinimized then
        Child.WindowState := wsNormal;
      Child.BringToFront;
      Child.Setfocus;
      TForm(AForm) := Child;
      Result := Child;
      exit;
    end;
  Child := TForm(FormClass.NewInstance);
  TForm(AForm) := Child;
  if not assigned(aowner) then aowner := application;

  Child.Create(AOwner);
  if Child.FormStyle = fsMDIChild then
    Child.FormStyle := fsNormal;
  Child.Visible := false;
  Child.ShowModal;
  Result := Child;
  exit;
end;

procedure mjOpenFormByTemplate(FormName: string;
  FormClass: TFormClass; AOwner: TComponent = nil; modal: boolean = false);
var
  i: integer;
  AForm, Child: TForm;
begin
  for i := 0 to Screen.FormCount - 1 do
  begin
    if (Screen.Forms[i].ClassType = FormClass)
      and (Screen.Forms[i].Name = FormName) then
    begin
      Child := Screen.Forms[i];
      if Child.WindowState = wsMinimized then
        Child.WindowState := wsNormal;
      Child.BringToFront;
      Child.Setfocus;
      TForm(AForm) := Child;
      exit;
    end;
  end;
  Child := TForm(FormClass.NewInstance);
  TForm(AForm) := Child;
  if not assigned(aowner) then aowner := application;

  if modal then
  begin
    Child.Create(AOwner);
    if Child.FormStyle = fsMDIChild then
      Child.FormStyle := fsNormal;
    Child.Visible := false;
    Child.ShowModal;
    exit;
  end
  else
  begin
    Child.Create(AOwner);
    if Child.FormStyle = fsNormal then
      Child.FormStyle := fsMDIChild;
    Child.WindowState := wsMaximized;
    Child.Show;
  end;
end;
{
procedure mjOpenFormByTemplate(adt_from: TADODataSet; FormName: string;
  FormClass: TFormClass; AOwner: TComponent = nil; modal: boolean = false);
var
  i, j: integer;
  AForm, Child: TForm;
begin
  for i := 0 to Screen.FormCount - 1 do
  begin
    if (Screen.Forms[i].ClassType = FormClass)
      and (Screen.Forms[i].Name = FormName) then
    begin
      Child := Screen.Forms[i];
      if Child.WindowState = wsMinimized then
        Child.WindowState := wsNormal;
      Child.BringToFront;
      Child.Setfocus;
      TForm(AForm) := Child;
      exit;
    end;
  end;
  Child := TForm(FormClass.NewInstance);
  TForm(AForm) := Child;
  if not assigned(aowner) then aowner := application;

  if modal then
  begin
    Child.Create(AOwner);
    Child.Name := FormName;
    if Child.FormStyle = fsMDIChild then
      Child.FormStyle := fsNormal;
    Child.Visible := false;

    Child.ShowModal;
    exit;
  end
  else
  begin
  //�˴� Child.Create(AOwner);�Ǳ���������ͨ�õ��������ڣ���Ϊ�˴�
  //���������������ڴ�������һЩ�����򴴽��Ĵ��岻����
    Child.Create(AOwner);

    Child.Name := FormName;
    if Child.FormStyle = fsNormal then
      Child.FormStyle := fsMDIChild;
    Child.WindowState := wsMaximized;

    for i := 0 to TComponent(Child).ComponentCount - 1 do
    begin
      if SameText(TComponent(Child).Components[i].ClassName, TDBGridEh.ClassName)
        and (TDBGridEh(TComponent(Child).Components[i]).DataSource <> nil) then
      begin
        TDBGridEh(TComponent(Child).Components[i]).DataSource.DataSet := adt_from;
        TDBGridEh(TComponent(Child).Components[i]).DataSource.DataSet.Active := true;
        for j := 0 to adt_from.FieldCount - 1 do
        begin
          //TDBGridEh(TComponent(Child).Components[i]).Columns[j].Width := adt_from.Fields[j].DisplayWidth;
          TDBGridEh(TComponent(Child).Components[i]).Columns[j].STFilter.ListSource := TDBGridEh(TComponent(Child).Components[i]).DataSource;
          TDBGridEh(TComponent(Child).Components[i]).Columns[j].STFilter.ListField := adt_from.Fields[j].FieldName;
          TDBGridEh(TComponent(Child).Components[i]).Columns[j].STFilter.KeyField := adt_from.Fields[j].FieldName;
          TDBGridEh(TComponent(Child).Components[i]).Columns[j].STFilter.DataField := adt_from.Fields[j].FieldName;
        end;
        TDBGridEh(TComponent(Child).Components[i]).Columns[0].Footer.ValueType := fvtCount;
      end;
    end;

    Child.Show;
  end;
end;

procedure mjCloseAllForm(parentFrm : TForm);
var
  i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].ClassType <> parentFrm then
      if Screen.Forms[i].ClassType <> TLoginDlg then
//          if Screen.Forms[i].ClassType<>TCalendarF then
//              Screen.Forms[i].Close;
        Screen.FormCount;
end;

}

procedure mjReadOnlyAllGrid(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to TComponent(Sender).ComponentCount - 1 do
  begin
    if SameText(TComponent(Sender).Components[i].ClassName, TDBGridEh.ClassName) and (TDBGridEh(TComponent(Sender).Components[i]).DataSource <> nil) then
    begin
      TDBGridEh(TComponent(Sender).Components[i]).ReadOnly := true;
    end;
  end;
end;

{
procedure mjSplitSchedule(DataSet: TDataSet);
var
  model: string;
  qty, qty1: integer;
  a: array[1..1000] of TDateTime;
  bDTIndex, eDTIndex: integer;
  i, j, k, h: integer;
  period, bDT, eDT: TDateTime;
  dt1, dt2: string;
begin
  try
    Dm.DeleteSchedule2Hours();

    a[1] := StrToDateTime(formatdatetime('YYYY-mm-dd', floattodatetime(date - 20)) + ' 1:00');
    for h := 1 to 1000 do
    begin
      a[h] := a[1] + h * strtodatetime('2:00');
    end;

    for i := 1 to DataSet.RecordCount do
    begin
      bDT := DataSet.FieldByName('starttime').AsDateTime;
      eDT := DataSet.FieldByName('endtime').AsDateTime;
      period := eDT - bDT;
      qty := DataSet.FieldByName('qty').AsInteger;
      model := DataSet.FieldByName('model').AsString;

      bDTIndex := 1;
      eDTIndex := 1;
      for j := 1 to 1000 do
      begin
        if (bDT >= a[j]) and (bDT < a[j + 1]) then
        begin
          bDTIndex := j;
        end;
        if (eDT >= a[j]) and (eDT < a[j + 1]) then
        begin
          eDTIndex := j;
        end;
      end;

      if bDTIndex = eDTIndex then
      begin
        dt1 := DateTimeToStr(bDT);
        dt2 := DateTimeToStr(eDT);
        qty1 := qty;
        DM.AddSchedule2Hours(model, qty1, dt1, dt2);
      end
      else
      begin
        for k := bDTIndex to eDTIndex do
        begin
          if k = bDTIndex then
          begin
            dt1 := DateTimeToStr(bDT);
            dt2 := DateTimeToStr(a[k + 1]);
            qty1 := mjGetRound(qty * (a[k + 1] - bDT) / period);
          end
          else if k = eDTIndex then
          begin
            dt1 := DateTimeToStr(a[k]);
            dt2 := DateTimeToStr(eDT);
            qty1 := mjGetRound(qty * (eDT - a[k]) / period);
          end
          else
          begin
            dt1 := DateTimeToStr(a[k]);
            dt2 := DateTimeToStr(a[k + 1]);
            qty1 := mjGetRound(qty * (a[k + 1] - a[k]) / period);
          end;
          DM.AddSchedule2Hours(model, qty1, dt1, dt2);
        end;
      end;

      DataSet.Next;
    end;
  except on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;
}

{ 3. }

procedure mjOpenAllADT(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to TComponent(Sender).ComponentCount - 1 do
  begin
    if SameText(TComponent(Sender).Components[i].ClassName, TADODataSet.ClassName)
      and (TADODataSet(TComponent(Sender).Components[i]) <> nil) then
      //and not SameText(TADODataSet(TComponent(Sender).Components[i]).CommandText, EmptyStr) then
    begin
      //ShowMessage(TADODataSet(TComponent(Sender).Components[i]).Name);
      //TADODataSet(TComponent(Sender).Components[i]).Connection := ADOConnection1;
      TADODataSet(TComponent(Sender).Components[i]).Active := True;
    end;
  end;
end;

procedure mjCloseAllADT(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to TComponent(Sender).ComponentCount - 1 do
  begin
    if SameText(TComponent(Sender).Components[i].ClassName, TADODataSet.ClassName)
      and (TADODataSet(TComponent(Sender).Components[i]) <> nil) then
    begin
      //ShowMessage(TADODataSet(TComponent(Sender).Components[i]).Name);
      TADODataSet(TComponent(Sender).Components[i]).Filtered := False;
      TADODataSet(TComponent(Sender).Components[i]).Filter := EmptyStr;
      TADODataSet(TComponent(Sender).Components[i]).Active := False;
    end;
  end;
end;

procedure mjRefreshAllADT(Sender: TObject);
var
  i: Integer;
begin
  try
    for i := 0 to TComponent(Sender).ComponentCount - 1 do
    begin
      if SameText(TComponent(Sender).Components[i].ClassName, TADODataSet.ClassName) and (TADODataSet(TComponent(Sender).Components[i]) <> nil) then
      begin
        if TADODataSet(TComponent(Sender).Components[i]).Active then
        begin
          TADODataSet(TComponent(Sender).Components[i]).Requery();
        end;
      end;
    end;
  except on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure mjDBGridEhSort(Sender: TObject; ACol: Integer; Column: TColumnEh);
var
  FieldName, SortStr: string;
begin
  Screen.Cursor := crSQLWait;
  try
    if (Sender is TDBGridEh) and
      ((Sender as TDBGridEh).DataSource.DataSet <> nil) then
    begin
      if not ((Sender as TDBGridEh).DataSource.DataSet is
        TCustomADODataSet) then
        Exit;
      if not (Sender as TDBGridEh).DataSource.DataSet.Active then
        Exit;
      FieldName := Column.FieldName;
      if (Sender as
        TDBGridEh).DataSource.DataSet.FindField(FieldName).IsBlob then
        Exit;
      if (Sender as
        TDBGridEh).DataSource.DataSet.FieldByName(FieldName).FieldKind =
        fkData then
        SortStr := FieldName
      else if (Sender as
        TDBGridEh).DataSource.DataSet.FieldByName(FieldName).FieldKind =
        fkLookup then
        FieldName := (Sender as
          TDBGridEh).DataSource.DataSet.FieldByName(FieldName).KeyFields
      else
        FieldName := '';
      if (FieldName = '') or (Pos(';', FieldName) > 0) then
        Exit;
      case Column.Title.SortMarker of
        smNoneEh:
          begin
            Column.Title.SortMarker := smUpEh;
            TCustomADODataSet((Sender as
              TDBGridEh).DataSource.DataSet).Sort :=
              FieldName;
          end;
        smUpEh:
          begin
            Column.Title.SortMarker := smDownEh;
            TCustomADODataSet((Sender as
              TDBGridEh).DataSource.DataSet).Sort :=
              FieldName + ' DESC';
          end;
        smDownEh:
          begin
            Column.Title.SortMarker := smNoneEh;
            TCustomADODataSet((Sender as
              TDBGridEh).DataSource.DataSet).Sort := '';
          end;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure mjDBGridEhOpenTitleButton(Sender: TObject);
var
  i, k: integer;
begin
  for i := 0 to TComponent(Sender).ComponentCount - 1 do
  begin
    if SameText(TComponent(Sender).Components[i].ClassName, TDBGridEh.ClassName) and (TDBGridEh(TComponent(Sender).Components[i]).DataSource <> nil) then
    begin
      for k := 0 to TDBGridEh(TComponent(Sender).Components[i]).Columns.Count - 1 do
      begin
      //ShowMessage(TDBGridEh(TComponent(Sender).Components[i]).Columns[k].FieldName);
        TDBGridEh(TComponent(Sender).Components[i]).Columns[k].Title.TitleButton := true;
      end;
    end;
  end;
end;

procedure mjDBGridEhDragDropInSameDBTable(dbgFrom, dbgTo: TDBGridEh;
  StateStr, aState: string);
var
  i: Integer;

  procedure DoUpdate;
  begin
    if not (dbgFrom.DataSource.DataSet.State in [dsEdit]) then
      dbgFrom.DataSource.DataSet.Edit;
    dbgFrom.DataSource.DataSet.FieldByName(aState).Value := StateStr;
  end;
begin
  dbgFrom.DataSource.DataSet.DisableControls;
  dbgTo.DataSource.DataSet.DisableControls;
  dbgFrom.SaveBookmark;
  if dbgFrom.Selection.SelectionType = gstRecordBookmarks then
  begin
    for i := 0 to dbgFrom.SelectedRows.Count - 1 do
    begin
      dbgFrom.DataSource.DataSet.Bookmark := dbgFrom.SelectedRows[I];
      DoUpdate;
    end
  end
  else if dbgFrom.Selection.SelectionType = gstAll then
  begin
    dbgFrom.DataSource.DataSet.First;
    while not dbgFrom.DataSource.DataSet.EOF do
    begin
      DoUpdate;
      dbgFrom.DataSource.DataSet.Next;
    end;
    dbgFrom.Selection.Clear;
  end;
  dbgFrom.DataSource.DataSet.Active := False;
  dbgFrom.DataSource.DataSet.Active := True;
  dbgTo.DataSource.DataSet.Active := False;
  dbgTo.DataSource.DataSet.Active := True;
  dbgFrom.DataSource.DataSet.EnableControls;
  dbgTo.DataSource.DataSet.EnableControls;
end;

procedure mjDBGridEhDragDropInSameDBTable2(dbgFrom, dbgTo: TDBGridEh;
  StateStr, aState, aDate: string);
var
  i: Integer;

  procedure DoUpdate;
  begin
    if not (dbgFrom.DataSource.DataSet.State in [dsEdit]) then
      dbgFrom.DataSource.DataSet.Edit;
    dbgFrom.DataSource.DataSet.FieldByName(aState).Value := StateStr;
    if aDate = 'ATA2' then
      dbgFrom.DataSource.DataSet.FieldByName('ATA').Value := null
    else
      dbgFrom.DataSource.DataSet.FieldByName('ATA').Value := now;
  end;
begin
  dbgFrom.DataSource.DataSet.DisableControls;
  dbgTo.DataSource.DataSet.DisableControls;
  dbgFrom.SaveBookmark;
  if dbgFrom.Selection.SelectionType = gstRecordBookmarks then
  begin
    for i := 0 to dbgFrom.SelectedRows.Count - 1 do
    begin
      dbgFrom.DataSource.DataSet.Bookmark := dbgFrom.SelectedRows[I];
      DoUpdate;
    end
  end
  else if dbgFrom.Selection.SelectionType = gstAll then
  begin
    dbgFrom.DataSource.DataSet.First;
    while not dbgFrom.DataSource.DataSet.EOF do
    begin
      DoUpdate;
      dbgFrom.DataSource.DataSet.Next;
    end;
    dbgFrom.Selection.Clear;
  end;
  dbgFrom.DataSource.DataSet.Active := False;
  dbgFrom.DataSource.DataSet.Active := True;
  dbgTo.DataSource.DataSet.Active := False;
  dbgTo.DataSource.DataSet.Active := True;
  dbgFrom.DataSource.DataSet.EnableControls;
  dbgTo.DataSource.DataSet.EnableControls;
end;

{ 4. }
{
function mjSendEmail(poSMTPServer: TLoginEmailServer; poBody: Tstrings; psFromEmial,
  psToEmail, psSubject: string; psContentType: string;
  CCToEmail: string; poAttachmentPath: TStrings): integer;
var //psContentType��ȡֵ��'text/plain'�������ı�,'text/html'������html
  loIdMsgSend: TIdMessage;
  loSMTP: TIdSMTP;
  i: integer;
begin
  Result := 3;
  loIdMsgSend := nil;
  loSMTP := nil;
  try
    loIdMsgSend := TIdMessage.Create(nil);
    loSMTP := TIdSMTP.Create(nil);
    with loIdMsgSend do //��ʼ���ʼ�����Ϣ
    begin
      ContentType := psContentType;
      From.Text := psFromEmial;
      ReplyTo.EMailAddresses := psFromEmial;
      Recipients.EMailAddresses := psToEmail;
      CCList.EMailAddresses := CCToEmail;
      Subject := psSubject;
      Priority := mpNormal;
      ReceiptRecipient.Text := '';
      Body.Assign(poBody);
      if Assigned(poAttachmentPath) then
      begin
        for i := 0 to poAttachmentPath.Count - 1 do //��Ӹ�������
        begin
          TIdAttachment.Create(loIdMsgSend.MessageParts, poAttachmentPath.Strings[i]);
        end;
      end;
    end;
    with loSMTP do //��ʼ��SMTP��������Ϣ
    begin
      Host := poSMTPServer.SMTPHost;
      Port := poSMTPServer.SMTPPort;
      if poSMTPServer.SmtpAuthType = 1 then
        AuthenticationType := atLogin
      else
        AuthenticationType := atNone;
      Username := poSMTPServer.Username;
      Password := poSMTPServer.Password;
      try
        Connect; //���ӷ�����
      except
        result := 2;
        exit;
      end;
      try
        Send(loIdMsgSend); //�����ʼ�
      except
        Disconnect;
        Result := 1;
        exit;
      end;
      Disconnect;
    end;
    Result := 0;
  finally
    loIdMsgSend.Free;
    loSMTP.Free;
  end;
end;
}

procedure mjSendOutlookMail(Email, Subject: string; Body: Widestring; Filename: string);
const
  olMailItem = 0;
var
  Outlook: OleVariant;
  vMailItem: variant;
begin
  try
    Outlook := GetActiveOleObject('Outlook.Application');
  except
    Outlook := CreateOleObject('Outlook.Application');
  end;
  vMailItem := Outlook.CreateItem(olMailItem);
  //vMailItem.Recipients.Add(Email);
  vMailItem. to := Email;
  vMailItem.Subject := Subject;
  vMailItem.Body := Body;
  vMailItem.Attachments.Add(Filename);
  vMailItem.Send;

  VarClear(Outlook);
end;

function mjGetHz(s: string): string;
var
  hz: string; i: integer;
begin
  hz := '';
  for i := 1 to length(s) do
  begin
    if ByteType(s, i) <> mbSingleByte then {???}
      hz := hz + s[i];
  end;
  result := hz;
  {//demo
procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
begin
  s := '121��12df3��343��34��34��34��fdg��';
  ShowMessage(GetHz(s));
end;
  }
end;
     {
function mjKillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
        OpenProcess(PROCESS_TERMINATE,
        BOOL(0),
        FProcessEntry32.th32ProcessID),
        0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end; }

function mjGetLocalIpList(var IpList: TStringList): Integer;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  HostName: array[0..MAX_PATH] of char;
  NameLen: Integer;
  WSData: TWSAData;
  lpHostEnt: PHostEnt;
  I: Integer;
  pptr: PaPInAddr;
begin
  Result := 0;
  if WSAStartup(MakeWord(2, 0), WSData) <> 0 then Exit;
  try
    NameLen := sizeof(HostName);
    fillchar(HostName, NameLen, 0);
    NameLen := GetHostName(HostName, NameLen);
    if NameLen = SOCKET_ERROR then Exit;
    lpHostEnt := GetHostByName(HostName);
    if lpHostEnt = nil then Exit;
    I := 0;
    pPtr := PaPInAddr(lpHostEnt^.h_addr_list);
    IpList.Clear;
    while pPtr^[I] <> nil do
    begin
      IpList.ADD(inet_ntoa(pptr^[I]^));
      Inc(I);
    end;
    Result := IpList.Count;
  finally
    WSACleanup;
  end;
end;

procedure mjDisabledMenu(mainForm: TForm); //ʹ���в˵�������
var
  I: integer;
begin
  for i := 0 to mainForm.ComponentCount - 1 do
  begin
   { if (mainForm.Components[i] is TMenuItem) then
      (mainForm.Components[i] as TMenuItem).Enabled := false;
    if (mainForm.Components[i] is TToolButton) then
      (mainForm.Components[i] as TToolButton).Enabled := false;    }
    if (mainForm.Components[i] is TMenuItem) then
      (mainForm.Components[i] as TMenuItem).Visible := false;
    if (mainForm.Components[i] is TToolButton) then
      (mainForm.Components[i] as TToolButton).Visible := false;
  end;
end;

procedure mjEnabledMenu(mainForm: TForm; menuname: string); //����û��ɲ����Ĳ˵�
begin
{  if (mainForm.FindComponent(menuname) <> nil) then
  begin
    if (mainForm.FindComponent(menuname) is TMenuItem) then
      (mainForm.FindComponent(menuname) as TMenuItem).Enabled := true;
    if (mainForm.FindComponent(leftstr(menuname, length(menuname) - 4) + 'TB') is TToolButton) then
      (mainForm.FindComponent(leftstr(menuname, length(menuname) - 4) + 'TB') as
        TToolButton).Enabled := true;
  end;   }
  if (mainForm.FindComponent(menuname) <> nil) then
  begin
    if (mainForm.FindComponent(menuname) is TMenuItem) then
      (mainForm.FindComponent(menuname) as TMenuItem).Visible := true;
    if (mainForm.FindComponent(leftstr(menuname, length(menuname) - 4) + 'TB') is TToolButton) then
      (mainForm.FindComponent(leftstr(menuname, length(menuname) - 4) + 'TB') as
        TToolButton).Visible := true;
  end;
end;

function mjCheckKey(var Key: char; str: string): boolean;
begin
  result := false;
  if str = 'n' then //Ϊ����
  begin
    if (key in ['0'..'9']) then
      result := true;
  end
  else //str='s'Ϊ�ַ�
  begin
    if (key in ['a'..'z']) or (key in ['A'..'Z']) then
      result := true;
  end;
end;

//LISTBOXǰ�����*************************************************************

procedure mjGetOrder(ListB: TlistBox);
var
  i: integer;
  str: string;
begin
  for i := 0 to ListB.Items.Count - 1 do
  begin
    str := ListB.Items.Strings[i];
    ListB.Items.Strings[i] := inttostr(i + 1) + ')' + rightstr(str, length(str) - pos(')', str));
  end;
end;

//����ı����ı�**************************************************************

function mjCClearData(form: TForm): boolean;
var
  I: integer;
begin
  result := false;
  for i := 0 to form.ControlCount - 1 do
  begin
    if form.Controls[i] is TEdit then
      (form.Controls[i] as TEdit).Text := ''
    else if form.Controls[i] is TComboBox then
      (form.Controls[i] as TComboBox).ItemIndex := 0
    else if form.Controls[i] is TMemo then
      (form.Controls[i] as TMemo).Text := '';
  end;
end;

//������Դ

function mjGetMemoryInfo: integer;
var
  MS: TMemoryStatus;
begin
  MS.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(MS);
  result := MS.dwTotalPhys
end;
//��ȡϵͳ��Ϣ

function GetOSInfo: string;
var
  Platform: string;
  BuildNumber: Integer;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        Platform := 'Windows 95';
        BuildNumber := Win32BuildNumber and $0000FFFF;
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        Platform := 'Windows NT';
        BuildNumber := Win32BuildNumber;
      end;
  else
    begin
      Platform := 'Windows';
      BuildNumber := 0;
    end;
  end;

  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS)
    or (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if Win32CSDVersion = '' then
      result := Format('%s%s  %d.%d (Build %d)', [Platform, #13, Win32MajorVersion, Win32MinorVersion, BuildNumber])
    else
      result := Format('%s%s  %d.%d (Build %d: %s)', [Platform, #13, Win32MajorVersion, Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
    result := Format('%s%s  %d.%d', [Platform, #13, Win32MajorVersion, Win32MinorVersion])
end;

//��ʾ���ڴ���(window about)

function mjShowAbout(): boolean;
var
  hIcon, hInst: integer;
  sappname, sappver: string;
begin
  sappname := '��������ϵͳ';
  sappver := ' version 2.0';
  hInst := getwindowword(application.Handle, GWL_HINSTANCE);
  hIcon := ExtractIcon(hInst, pchar(application.exename), 0);
  Result := boolean(shellabout(application.Handle,
    pchar(SAppName), pchar(SAppName + sappver), hicon));
end;
{
procedure mjDraw(form: tform);
var
  dc: hDc;
  Pen: hPen;
  OldPen: hPen;
  OldBrush: hBrush;
begin
  dc := GetWindowDC(form.handle);
  //msg.Result := 1;
  Pen := CreatePen(PS_SOLID, 1, RGB(250, 55, 20));
  OldPen := SelectObject(dc, Pen);
  OldBrush := SelectObject(dc, GetStockObject(NULL_BRUSH));
  Rectangle(dc, 0, 0, form.Width, form.Height);
  SelectObject(dc, OldBrush);
  SelectObject(dc, OldPen);
  DeleteObject(Pen);
  ReleaseDC(form.Handle, form.Canvas.Handle);
end;
}
procedure mjLockForm(Panel1: TPanel);
var
  i: integer;
begin
  for i := 0 to Panel1.ControlCount - 1 do
  begin
    if Panel1.Controls[i] is TEdit then //Edit���
    begin
     // ((Panel1.Controls[i]) as TEdit).Text := '';
      ((Panel1.Controls[i]) as TEdit).Enabled := false;
      ((Panel1.Controls[i]) as TEdit).Color := clmenu;
    end
    else if panel1.Controls[i] is TComboBox then //ComboBox���
    begin
     // ((panel1.Controls[i]) as TComboBox).Text := '';
      ((panel1.Controls[i]) as TComboBox).Enabled := false;
      ((panel1.Controls[i]) as TComboBox).Color := clmenu;
    end
    else if panel1.Controls[i] is TDateTimePicker then //DateTimePicker���
    begin
      ((panel1.Controls[i]) as TDateTimePicker).Enabled := false;
      ((panel1.Controls[i]) as TDateTimePicker).Color := clmenu;
      //((panel1.Controls[i]) as TDateTimePicker).DateTime := now();
    end
    else if panel1.Controls[i] is TDBLookupComboboxEh then
    begin
      ((panel1.Controls[i]) as TDBLookupComboboxEh).Enabled := false;
      ((panel1.Controls[i]) as TDBLookupComboboxEh).Color := clmenu;
    end
    else if panel1.Controls[i] is TMemo then
    begin
      ((panel1.Controls[i]) as TMemo).Enabled := false;
      ((panel1.Controls[i]) as TMemo).Color := clmenu;
    end
    else if panel1.Controls[i] is TButton then
    begin
      ((panel1.Controls[i]) as TButton).Enabled := false;
    end
    else if panel1.Controls[i] is TSpeedButton then
    begin
      ((panel1.Controls[i]) as TSpeedButton).Enabled := false;
    end;
  end;
end;

procedure mjUnLockForm(Panel1: TPanel);
var
  i: integer;
begin
  for i := 0 to Panel1.ControlCount - 1 do
  begin
    if Panel1.Controls[i] is TEdit then //Edit���
    begin
      ((Panel1.Controls[i]) as TEdit).Enabled := true;
      ((Panel1.Controls[i]) as TEdit).Color := clWindow;
    end
    else if panel1.Controls[i] is TComboBox then //ComboBox���
    begin
     // ((panel1.Controls[i]) as TComboBox).Text := '';
      ((panel1.Controls[i]) as TComboBox).Enabled := true;
      ((panel1.Controls[i]) as TComboBox).Color := clWindow;
    end
    else if panel1.Controls[i] is TDateTimePicker then //DateTimePicker���
    begin
      ((panel1.Controls[i]) as TDateTimePicker).Enabled := true;
      ((panel1.Controls[i]) as TDateTimePicker).Color := clWindow;
      //((panel1.Controls[i]) as TDateTimePicker).DateTime := now();
    end
    else if panel1.Controls[i] is TDBLookupComboboxEh then
    begin
      ((panel1.Controls[i]) as TDBLookupComboboxEh).Enabled := true;
      ((panel1.Controls[i]) as TDBLookupComboboxEh).Color := clWindow;
    end
    else if panel1.Controls[i] is TMemo then
    begin
      ((panel1.Controls[i]) as TMemo).Enabled := true;
      ((panel1.Controls[i]) as TMemo).Color := clWindow;
    end
    else if panel1.Controls[i] is TButton then
    begin
      ((panel1.Controls[i]) as TButton).Enabled := true;
    end
    else if panel1.Controls[i] is TSpeedButton then
    begin
      ((panel1.Controls[i]) as TSpeedButton).Enabled := true;
    end;
  end;
end;

function mjGetBuildInfo: string; //��ȡ�汾��
var
  verinfosize: DWORD;
  verinfo: pointer;
  vervaluesize: dword;
  vervalue: pvsfixedfileinfo;
  dummy: dword;
  v1, v2, v3, v4: word;
begin
  verinfosize := getfileversioninfosize(pchar(paramstr(0)), dummy);
  if verinfosize = 0 then
  begin
    dummy := getlasterror;
    result := '0.0.0.0';
  end;
  getmem(verinfo, verinfosize);
  getfileversioninfo(pchar(paramstr(0)), 0, verinfosize, verinfo);
  verqueryvalue(verinfo, '\', pointer(vervalue), vervaluesize);
  with vervalue^ do
  begin
    v1 := dwfileversionms shr 16;
    v2 := dwfileversionms and $FFFF;
    v3 := dwfileversionls shr 16;
    v4 := dwfileversionls and $FFFF;
  end;
  result := inttostr(v1) + '.' + inttostr(v2) + '.' + inttostr(v3) + '.' + inttostr(v4);
  freemem(verinfo, verinfosize);
end;

function mjGetVarType(const v: Variant): string;
begin
  case VarType(v) of
    varEmpty: Result := 'Empty';
    varNull: Result := 'Null';
    varSmallint: Result := 'Smallint';
    varInteger: Result := 'Integer';
    varSingle: Result := 'Single';
    varDouble: Result := 'Double';
    varCurrency: Result := 'Currency';
    varDate: Result := 'Date';
    varOleStr: Result := 'OleStr';
    varDispatch: Result := 'Dispatch';
    varError: Result := 'Error';
    varBoolean: Result := 'Boolean';
    varVariant: Result := 'Variant';
    varUnknown: Result := 'Unknown';
    varShortInt: Result := 'ShortInt';
    varByte: Result := 'Byte';
    varWord: Result := 'Word';
    varLongWord: Result := 'LongWord';
    varInt64: Result := 'Int64';
    varStrArg: Result := 'StrArg';
    varString: Result := 'String';
    varAny: Result := 'Any';
    varTypeMask: Result := 'TypeMask';
    varArray: Result := 'Array';
    varByRef: Result := 'ByRef';
  end;
end;

procedure mjSendMailReport(mailFrom, mailRecipient, mailSubject, mailBody: string);
var
//  adt1: TADODataSet;
//  aFrom: string;
//  IdSMTP1: TIdSMTP;
//  IdMessage1: TIdMessage;
  poSMTPServer: TLoginEmailServer;
  aBody, aAttPath: TStrings;
begin
  if mailRecipient <> '' then
  begin
    if mailFrom = '' then
      mailFrom := 'admin.suzhou@emerson.com';
    poSMTPServer.SMTPHost := '10.16.67.249';
    poSMTPServer.SMTPPort := 25;
   // poSMTPServer.Username := '';
   // poSMTPServer.Password := '';
   // poSMTPServer.SmtpAuthType := '';

    aBody := TStringList.Create;
    aAttPath := TStringList.Create;
    aBody.Text := mailBody;
    mjSendEmail(poSMTPServer, aBody, mailFrom, mailRecipient, mailSubject, 'text/html', '', aAttPath);
    aBody.Free;
    aAttPath.Free;
  end;
end;

function mjSendEmail(poSMTPServer: TLoginEmailServer; poBody: Tstrings; psFromEmial,
  psToEmail, psSubject: string; psContentType: string; CCToEmail: string; poAttachmentPath: TStrings): integer;
var
  loIdMsgSend: TIdMessage;
  loSMTP: TIdSMTP;
  i: integer;
begin
  //Result := 3;
  loIdMsgSend := nil;
  loSMTP := nil;
  try
    loIdMsgSend := TIdMessage.Create(nil);
    loSMTP := TIdSMTP.Create(nil);
    with loIdMsgSend do
    begin
      ContentType := psContentType;
      From.Text := psFromEmial;
      ReplyTo.EMailAddresses := psFromEmial;
      Recipients.EMailAddresses := psToEmail;
      CCList.EMailAddresses := CCToEmail;
      Subject := psSubject;
      Priority := mpHigh;
      ReceiptRecipient.Text := '';
      Body.Assign(poBody);
      if Assigned(poAttachmentPath) then
      begin
        for i := 0 to poAttachmentPath.Count - 1 do
        begin
        //  TIdAttachment.Create(loIdMsgSend.MessageParts, poAttachmentPath.Strings[i]);
        end;
      end;
    end;
    with loSMTP do
    begin
      Host := poSMTPServer.SMTPHost;
      Port := poSMTPServer.SMTPPort;
{      if poSMTPServer.SmtpAuthType = 1 then
        AuthenticationType := atLogin
      else
        AuthenticationType := atNone;}
      Username := poSMTPServer.Username;
      Password := poSMTPServer.Password;
      try
        Connect;
        Send(loIdMsgSend);
      except
        result := 2;
        exit;
      end;
      Result := 0;
    end;
  finally
    loIdMsgSend.Free;
    loSMTP.Free;
  end;
end;
    
{
procedure TLoginDlg.Button1Click(Sender: TObject);
var
  List: TStringList;
  index: integer;
begin
  List := TStringList.Create;
  List.Add('aaa=111');
  List.Add('bbb=222');
  List.Add('ccc=333');
  List.Add('ddd=444');
  List.Add('dcdd');
  List.Sort;
  ShowMessage(IntToStr(List.IndexOf('dcdd'))); //3
  List.Find('ddd=444', index);
  ShowMessage(IntToStr(index)); //4
  ShowMessage(List.CommaText); //aaa=111,bbb=222,ccc=333,dcdd,ddd=444
  ShowMessage(List.Text);
  ShowMessage(List.Names[1]); //bbb
  ShowMessage(List.ValueFromIndex[1]); //222
  ShowMessage(List.Values['bbb']); //222
  //ValueFromIndex ���Ը�ֵ:
  List.ValueFromIndex[1] := '2';
  ShowMessage(List[1]); //bbb=2
  //����ͨ�� Values ��ֵ:
  List.Values['bbb'] := '22';
  ShowMessage(List[1]); //bbb=22
  ShowMessage(List.ValueFromIndex[3]); //cdd
  List.Free;
end;

  list := TStringList.Create;
  list.CommaText := adt1.Recordset.GetString(2, adt1.RecordCount, ',', '|', '');
  ShowMessage(list.CommaText);

 }

initialization
//   GlobalVars := TGlobalVars.Create;

finalization
  FreeAndNil(fGlobalVars);

end.

