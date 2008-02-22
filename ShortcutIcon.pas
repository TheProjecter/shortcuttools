unit ShortcutIcon;

interface
uses
  Registry,Windows,Dialogs;

type
  TShortcutIcon=class
    procedure ClearArrow;
    procedure MakeIconTransparent;
  end;

implementation

{ TShortcutIcon }

procedure TShortcutIcon.ClearArrow;
var
  Reg:TRegistry;
begin
  Reg := TRegistry.Create;
  try
     reg.RootKey := HKEY_CLASSES_ROOT;

     if reg.OpenKey('lnkfile',False) then
        Reg.DeleteValue('IsShortcut')
     else
        ShowMessage('Open Registery Error!');
  finally
    reg.Free;
  end;  
end;

procedure TShortcutIcon.MakeIconTransparent;
var   wnd:HWND;   
begin
    Wnd   :=   GetDesktopWindow;
    Wnd   :=   FindWindowEx(Wnd,   0,   'Progman',   nil);
    Wnd   :=   FindWindowEx(Wnd,   0,   'SHELLDLL_DefView',   nil);
    Wnd   :=   FindWindowEx(Wnd,   0,   'SysListView32',   nil);
    SendMessage(Wnd,   $1026,   0,   $ffffffff);
    SendMessage(Wnd,   $1024,   0,   $00ffffff);
    InvalidateRect(Wnd,   nil,   TRUE);
end;

end.
