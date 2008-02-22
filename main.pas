unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ShellAPI,ComObj,ShlObj,ActiveX,Registry, ComCtrls,Contnrs,
  CommCtrl;

type

  TShotCut=class
  private
    FName: string;
    FIsExists: Boolean;
    FIsCommon: Boolean;
    FPath: string;
    procedure SetIsCommon(const Value: Boolean);
    procedure SetIsExists(const Value: Boolean);
    procedure SetName(const Value: string);
    procedure SetPath(const Value: string);
  public
    property Name:string read FName write SetName;
    property IsCommon:Boolean read FIsCommon write SetIsCommon;
    property IsExists:Boolean read FIsExists write SetIsExists;
    property Path:string read FPath write SetPath;
  end;

  TGUtil=class
    class function ExtractFileNameWithoutExt(fileName:string):string;
  end;

  TForm1 = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    lv_ShotCut: TListView;
    ts2: TTabSheet;
    btn_Check: TButton;
    btn1: TButton;
    pb_ScanSC: TProgressBar;
    rb_Left: TRadioButton;
    rb_Right: TRadioButton;
    rb_Top: TRadioButton;
    rb_Bottom: TRadioButton;
    btn_Arrange: TButton;
    rb_Cirlce: TRadioButton;
    ts_DeskIcon: TTabSheet;
    chk_ClearArrow: TCheckBox;
    chk_IconTrans: TCheckBox;
    btn_ShortcutIconApply: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn_RightAlignClick(Sender: TObject);
    procedure btn_ArrangeClick(Sender: TObject);
    procedure btn_ShortcutIconApplyClick(Sender: TObject);
  private
    { Private declarations }
    function GetDesktopPath:string;
    function GetAllDesktopPath:string;
    function GetLinkFileName(lnkName:String):String;
    function GetAllLinks:TObjectList;

    function GetDesktopHandle:THandle;
    procedure AlignRight(rec:Integer);
    procedure AlignTop(rec:Integer);
    procedure AlignBottom(rec:Integer);
    procedure AlignLeft(rec:Integer);
    procedure AlignCircle(rec:Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ShortcutIcon;

{$R *.dfm}

procedure TForm1.AlignBottom(rec: Integer);
var
  Hand: THandle;
  h, I, j, DesktopHeight, DesktopWidth :integer;
  TempRect : TRect;
Begin
  Hand:=GetDesktopHandle;

  SystemParametersInfo(SPI_GetWorkArea,0,@TempRect,0);
  DesktopWidth:=TempRect.Right - TempRect.Left;
  DesktopHeight:= TempRect.Bottom - TempRect.Top;

  I:=0;
  J:=0;

  For h:=0 to Listview_GetItemCount(Hand)-1 do
  Begin
    If  i*rec>DesktopWidth  then
      Begin
      Inc(j);
      i:=0;
    End;

    SendMessage(Hand,LVM_SetItemPosition,h,MakeLparam(Rec*(i),DesktopHeight-rec*(j+1)));
    Inc(i);
  End;
end;

procedure TForm1.AlignCircle(rec: Integer);
var
 i, Count, CenterX, CenterY, TempR :integer;
 Hand: THandle;
 Radian: double;
 TempRect: TRect;
 DesktopHeight,DesktopWidth :integer;
 X, Y : Word;
begin
 Hand:=GetDesktopHandle;
 SystemParametersInfo(SPI_GetWorkArea,0,@TempRect,0); // 取得工作区域；
 DesktopWidth:=TempRect.Right - TempRect.Left; // 工作区的宽（即屏幕的宽）；
 DesktopHeight:= TempRect.Bottom - TempRect.Top; // 工作区的高（即屏幕的高）；
 CenterX:=DesktopWidth div 2; // 取得圆心 X 坐标；
 CenterY:=DesktopHeight div 2; // 圆心 Y 坐标；
 if CenterX>CenterY then
    TempR:=CenterY
 else
    TempR:=CenterX;
 if rec>TempR then
  rec:=TempR; // 半径不能超过屏幕中心点到四边的最短距离；
 Count:=Listview_GetItemCount(Hand); // 桌面上图标个数；
 Radian:=2*3.14159/Count; // 相邻图标间的弧度；
 for i:=0 to Count-1 do
  begin
 // 第一个图标排在正上方；
      X:=Integer(CenterX+Trunc(rec*Sin(i*Radian))); // 图标的X坐标；
      Y:=Integer(CenterY+Trunc(rec*Cos(i*Radian))); // 图标的Y坐标；
      SendMessage(Hand,LVM_SetItemPosition,i,MakeLparam(X, y)); // 设置坐标；
 end;
end;

procedure TForm1.AlignLeft(rec: Integer);
var
  Hand: THandle;
  h, I, j, DesktopHeight, DesktopWidth :integer;
  TempRect : TRect;
Begin
  Hand:=GetDesktopHandle;

  SystemParametersInfo(SPI_GetWorkArea,0,@TempRect,0);
  DesktopWidth:=TempRect.Right - TempRect.Left;
  DesktopHeight:= TempRect.Bottom - TempRect.Top;

  I:=0;
  J:=0;

  For h:=0 to Listview_GetItemCount(Hand)-1 do
  Begin
    If  j*rec>DesktopHeight  then
    Begin
      Inc(i);
      j:=0;
    End;

    SendMessage(Hand,LVM_SetItemPosition,h,MakeLparam(Rec*(i),Rec*(j-1)));
    Inc(j);
  End;

end;

procedure TForm1.AlignRight(rec: Integer);
var
  Hand: THandle;
  h, I, j, DesktopHeight, DesktopWidth :integer;
  TempRect : TRect;
Begin
  Hand:=GetDesktopHandle;

  SystemParametersInfo(SPI_GetWorkArea,0,@TempRect,0);
  DesktopWidth:=TempRect.Right - TempRect.Left;
  DesktopHeight:= TempRect.Bottom - TempRect.Top;

  I:=0;
  J:=0;

  For h:=0 to Listview_GetItemCount(Hand)-1 do
  Begin
    Inc(j);

    If  j*rec>DesktopHeight  then
      Begin
      Inc(i);
      J:=0;
    End;

    SendMessage(Hand,LVM_SetItemPosition,h,MakeLparam(DesktopWidth-Rec*(I+1),Rec*(j-1)));
  End;

end;

procedure TForm1.AlignTop(rec: Integer);
var
  Hand: THandle;
  h, I, j, DesktopHeight, DesktopWidth :integer;
  TempRect : TRect;
Begin
  Hand:=GetDesktopHandle;

  SystemParametersInfo(SPI_GetWorkArea,0,@TempRect,0);
  DesktopWidth:=TempRect.Right - TempRect.Left;
  DesktopHeight:= TempRect.Bottom - TempRect.Top;

  I:=0;
  J:=0;

  For h:=0 to Listview_GetItemCount(Hand)-1 do
  Begin
    If  i*rec>DesktopWidth  then
      Begin
      Inc(j);
      i:=0;
    End;

    SendMessage(Hand,LVM_SetItemPosition,h,MakeLparam(Rec*(i),Rec*(j-1)));
    Inc(i);
  End;

end;

procedure TForm1.btn1Click(Sender: TObject);
var
  item:TListItem;
  i: Integer;
  procedure DeleteLink(linkName:string;isCommon:Boolean);
  var
    fileName:string;
  begin
     if not IsCommon then
       fileName:=GetDesktopPath+'\'+linkName+'.lnk'
    else
       fileName := GetAllDesktopPath + '\' + linkName+'.lnk';

    DeleteFile(fileName);
  end;

  function ConvStrToBool(str:string):Boolean;
  begin
    if str='True' then
      result:=True
    else
      result:=False;
  end;
begin
  for i := lv_ShotCut.Items.Count - 1 to 0 do
  begin
    item:=lv_ShotCut.Items[i];

    if item.SubItems[2]='False' then
    begin
      DeleteLink(item.Caption,ConvStrToBool(item.SubItems[1]));
      item.Delete;
    end;
  end;
end;

procedure TForm1.btn_ArrangeClick(Sender: TObject);
begin
  if rb_Left.Checked then
    AlignLeft(77);

  if rb_Right.Checked then
    AlignRight(77);

  if rb_Top.Checked then
    AlignTop(77);

  if rb_Bottom.Checked then
    AlignBottom(77);

  if rb_Cirlce.Checked then
    AlignCircle(77);
end;

procedure TForm1.btn_RightAlignClick(Sender: TObject);
begin
  //AlignBottom(77);
  //AlignTop(77);
  AlignLeft(77);
end;

procedure TForm1.btn_ShortcutIconApplyClick(Sender: TObject);
var
  scu:TShortcutIcon;
begin
  scu := TShortcutIcon.Create;
  try
    if chk_ClearArrow.Checked then
      scu.ClearArrow;

    if chk_IconTrans.Checked then
      scu.MakeIconTransparent;
  finally
    scu.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  files:TObjectList;
  stemp:TShotCut;
  i:integer;
  function ConvertBoolToStr(bv:Boolean):string;
  begin
    if bv then
      result:='True'
    else
      result:='False';
  end;
begin

  try
   Cursor:=crHourGlass;
   pb_ScanSC.Visible:=true;
   files := GetAllLinks();

   pb_ScanSC.Min := 0;
   pb_ScanSC.Max := files.Count;

   for I := 0 to files.Count - 1 do
    begin
     stemp:=files.Items[i] as TShotCut;
      with lv_ShotCut.Items.Add do
      begin
        caption:=TGUtil.ExtractFileNameWithoutExt(stemp.Name);
        SubItems.Add(stemp.Path);
        SubItems.Add(ConvertBoolToStr(stemp.IsCommon));
        SubItems.Add(ConvertBoolToStr(stemp.IsExists));

        pb_ScanSC.StepIt;
      end;
    end;

  finally
     files.Free;
     Cursor:=crDefault;
     pb_ScanSC.Visible := false;
  end;
end;

function TForm1.GetAllDesktopPath: string;
var
  ppdl:PItemIDList;
  iRet:integer;
  path:array [0..MAX_PATH] of char;
begin
  iRet := SHGetSpecialFolderLocation(Handle,CSIDL_COMMON_DESKTOPDIRECTORY,ppdl);
  SHGetPathFromIDList(ppdl,path);

  result:=path;
end;

function TForm1.GetAllLinks: TObjectList;
var
  desktop : string;
  sr:TSearchRec;
  iRet:integer;
  sc:TShotCut;
  function GetLinkPath(sc:TShotCut):string;
  var
    fileName:string;
  begin
     if not sc.IsCommon then
       fileName:=GetDesktopPath+'\'+sc.Name
    else
       fileName := GetAllDesktopPath + '\' + sc.Name;

    result := GetLinkFileName(fileName);
  end;

  function GetLinkExists(sc:TShotCut):boolean;
  begin
    Result := FileExists(sc.Path);
  end;
begin
  result := TObjectList.Create;

  desktop := GetDesktopPath;

  iret := FindFirst(desktop+'\*.lnk',faSymLink,sr);

  if iRet=0 then
  begin
    sc:=TShotCut.Create;
    sc.Name:=sr.Name;
    sc.FIsCommon:=False;
    sc.Path:=GetLinkPath(sc);
    sc.FIsExists:=GetLinkExists(sc);
    Result.Add(sc);

    while FindNext(sr)=0 do
    begin
      sc:=TShotCut.Create;
      sc.Name:=sr.Name;
      sc.FIsCommon:=False;
      sc.Path := GetLinkPath(sc);
      sc.FIsExists:=GetLinkExists(sc);
      Result.Add(sc);
    end;
  end;

  FindClose(sr);

  desktop := GetAllDesktopPath;
  iret := FindFirst(desktop+'\*.lnk',faSymLink,sr);

  if iRet=0 then
  begin
   sc:=TShotCut.Create;
    sc.Name:=sr.Name;
    sc.FIsCommon:=True;
    sc.Path := GetLinkPath(sc);
    sc.FIsExists:=GetLinkExists(sc);
    Result.Add(sc);

    while FindNext(sr)=0 do
    begin
      sc:=TShotCut.Create;
      sc.Name:=sr.Name;
      sc.FIsCommon:=True;
      sc.Path := GetLinkPath(sc);
      sc.FIsExists:=GetLinkExists(sc);
      Result.Add(sc);
    end;
  end;

  FindClose(sr);
end;

function TForm1.GetDesktopHandle: THandle;
begin
  Result:=FindWindow('progman',nil);

  Result:=GetWindow(Result,GW_Child);

  Result:=GetWindow(Result,GW_Child);
end;

function TForm1.GetDesktopPath: string;
var
  ppdl:PItemIDList;
  iRet:integer;
  path:array [0..MAX_PATH] of char;
begin
  iRet := SHGetSpecialFolderLocation(Handle,CSIDL_DESKTOPDIRECTORY,ppdl);
  SHGetPathFromIDList(ppdl,path);

  result:=path;
end;

function TForm1.GetLinkFileName(lnkName: String): String;
 var
  aObj:   IUnknown;
  MyPFile:   IPersistFile;
  MyLink:   IShellLink;
  WFileName:   WideString;
  FileName:array[0..255]   of   char;
  pfd:WIN32_FIND_DATA;
 begin
  aObj   :=   CreateComObject(CLSID_ShellLink);
  MyPFile   :=   aObj   as   IPersistFile;
  MyLink   :=   aObj   as   IShellLink;

  WFileName   :=   lnkName;   //将一个String赋给WideString，转换过程由Delphi自动完成
  MyPFile.Load(PWChar(WFileName),   0);

  MyLink.GetPath(FileName,255,pfd,SLGP_UNCPRIORITY);

  result   :=   String(FileName);
 end;

{ TShotCut }

procedure TShotCut.SetIsCommon(const Value: Boolean);
begin
  FIsCommon := Value;
end;

procedure TShotCut.SetIsExists(const Value: Boolean);
begin
  FIsExists := Value;
end;

procedure TShotCut.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TShotCut.SetPath(const Value: string);
begin
  FPath := Value;
end;

{ TGUtil }

class function TGUtil.ExtractFileNameWithoutExt(fileName: string): string;
var
  aList: TStringList;
  i:integer;
begin
  aList := TStringList.Create;

  ExtractStrings(['.'],[],PAnsiChar(ExtractFileName(fileName)),aList);

  result:=aList[0];
  for I := 1 to aList.Count - 2 do
    result:=result+'.'+aList[i];
end;

end.
