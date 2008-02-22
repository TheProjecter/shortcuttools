program checkdesktop;

uses
  Forms,
  main in 'main.pas' {Form1},
  ShortcutIcon in 'ShortcutIcon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
