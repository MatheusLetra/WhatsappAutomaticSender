unit UPdr_Mensagens;

interface

uses Controls, Dialogs, SysUtils, Types, Windows, Forms, Graphics,
  System.Classes, ActiveX;

Procedure FocaComponente(Comp: TWinControl = nil);
Procedure Mensagem(Msg: String; Tipo: Char = 'I');
Procedure MensagemErro(Msg: String; Comp: TWinControl = nil);
Procedure MensagemBloqueio(Msg: String; Comp: TWinControl = nil);
// Matheus - Criei para nao exibir simbolo de erro na hora de bloquear
Function MensagemPergunta(Msg: String): Boolean;
// se o cara escolher sim, result = TRUE, senão result = FALSE
Procedure MensagemTempo(const Msg: string; const t: Cardinal = 1000);

procedure MensagemFormatada(Msg: String; Negrito: Boolean = False;
  Italico: Boolean = False; Maiusculo: Boolean = False; Cor: TColor = clBlack;
  Foco: TWinControl = nil; Tipo: String = 'I');
// Matheus - Criei pq a Amanda Teixeira pediu mensagem em negrito e não tinha

type
  TMensagemThread = class(TThread)
  private
    fsMensagem: String;
    fsBuffer: Integer;
    procedure ShowMensagem;
  protected
    procedure Execute; override;
  public
    constructor Create(AMensagem: String);
  published
    property Mensagem: String read fsMensagem write fsMensagem;
    property Buffer: Integer read fsBuffer write fsBuffer default 2000;
  end;

implementation

uses
  System.Variants, System.StrUtils;

Procedure FocaComponente(Comp: TWinControl = nil);
Begin
  Try
    if Assigned(Comp) and (Comp <> Nil) then
    begin
      if Comp.Enabled then
      begin
        Comp.Show;
        Comp.SetFocus;
      end;
    end;
  Finally
  end;
End;

Procedure Mensagem(Msg: String; Tipo: Char = 'I');
Begin
  // i: Informação
  // A: Aviso
  // E: Erro

  If trim(Msg) <> '' then
    Case Tipo of
      'A':
        MessageDlg(Msg, mtWarning, [mbok], 0);
      'E':
        MessageDlg(Msg, mtError, [mbok], 0);
      'I':
        MessageDlg(Msg, mtInformation, [mbok], 0);
    End;

End;

Procedure MensagemErro(Msg: String; Comp: TWinControl = nil);
Begin
  Mensagem(Msg, 'E');
  FocaComponente(Comp);
  Abort;
End;

Procedure MensagemBloqueio(Msg: String; Comp: TWinControl = nil);
begin
  Mensagem(Msg, 'I');
  FocaComponente(Comp);
  Abort;
end;

Function MensagemPergunta(Msg: String): Boolean;
Begin
  // se o cara escolher sim, result = TRUE, se escolher não result = FALSE
  Result := False;
  if trim(Msg) <> '' then
    Result := (MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes)
End;

Procedure MensagemTempo(const Msg: string; const t: Cardinal);
var // P: TPoint;
  R: TRect;
  X: Integer;
begin
  // GetCursorPos( P ) ;

  with THintWindow.Create(Application) do
    try
      // Application.HintColor := clSkyBlue ;
      Color := clHighlight;
      // Brush.Color := clHighlight ;
      Canvas.Brush.Color := clHighlight;
      Canvas.Refresh;

      { Calcula o retângulo }
      R := CalcHintRect(Screen.Width, Msg, nil);

      { Centraliza horizontalmente }
      X := R.Right - R.Left + 1;
      // R.Left := P.X ;
      R.Left := (Screen.Width - X) div 2;
      R.Right := R.Left + X;

      { Centraliza verticalmente }
      X := R.Bottom - R.Top + 1;
      // R.Top := P.Y - X ;
      R.Top := (Screen.Height - X) div 2;
      R.Bottom := R.Top + X;

      { Mostra }
      ActivateHint(R, Msg);
      Update;

      { Aguarda }
      Sleep(t);
    finally
      Free;
    end;
end;

{ TMensagemThread }

constructor TMensagemThread.Create(AMensagem: String);
begin
  inherited Create(False);
  fsMensagem := AMensagem;
  fsBuffer := 2000;
end;

procedure TMensagemThread.Execute;
begin
  inherited;
  CoInitialize(nil);
  ShowMensagem;
end;

procedure TMensagemThread.ShowMensagem;
begin
  while not Terminated do
  begin
    MensagemTempo(fsMensagem, fsBuffer);
    Application.ProcessMessages;
  end;
end;

procedure MensagemFormatada(Msg: String; Negrito: Boolean = False;
  Italico: Boolean = False; Maiusculo: Boolean = False; Cor: TColor = clBlack;
  Foco: TWinControl = nil; Tipo: String = 'I');
var
  MessageType: TMsgDlgType;
begin

  case AnsiIndexStr(Tipo, ['I', 'E', 'W']) of
    0:
      MessageType := mtInformation;
    1:
      MessageType := mtError;
    2:
      MessageType := mtWarning;
  end;

  with CreateMessageDialog(IfThen(Maiusculo, Msg.ToUpper, Msg), MessageType,
    [mbok]) do
  begin
    try
      Font.Color := Cor;

      if (Negrito) then
        Font.Style := [fsBold];

      if (Italico) then
        Font.Style := [fsItalic];

      ShowModal;
    finally
      Free;
    end;
  end;

  if (Foco <> nil) then
    FocaComponente(Foco);

  if (MessageType = mtError) then
    Abort;
end;

end.
