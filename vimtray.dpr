program vimtray;

{$R 'manifest.res' 'manifest.rc'}

uses
  Forms,
  UMain in 'UMain.pas' {ConfigForm},
  UShell in 'UShell.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'VimTray';
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.Run;
end.
