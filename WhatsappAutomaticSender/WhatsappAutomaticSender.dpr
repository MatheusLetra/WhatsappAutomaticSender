program WhatsappAutomaticSender;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {Frm_Principal},
  UApiRest in 'src\utils\UApiRest.pas',
  UPdr_Mensagens in 'src\utils\UPdr_Mensagens.pas',
  UFuncoes in 'src\utils\UFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  Application.Run;
end.
