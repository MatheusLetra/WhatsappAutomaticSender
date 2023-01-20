unit UFuncoes;

interface

function GerarHTMLQRCode(Base64: String): String;

implementation

function GerarHTMLQRCode(Base64: String): String;
begin
  Result := '<img src="' + Base64 + '" alt="">';
end;

end.
