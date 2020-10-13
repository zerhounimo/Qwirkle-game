
{$mode objfpc}
{$m+}
unit UComputer;
interface
uses Utils, UPlayer;

type Computer = 	class(Player)
	public
      	constructor create(nom : String);
	function play() : Boolean; override;
	procedure cancel(); override;
	function testPoint( pos : posCartes) : mem;
	function decPossiPlus() : pos;
  end;


implementation




constructor Computer.create(nom : String);
begin
	inherited Create(nom);
end;

procedure Computer.cancel();
begin

end;

function Computer.play() : Boolean;
begin
	//writeln(getName(), ' : flem de jouer');
	exit(True);
end;


// function qui rend la meilleur position pour des pions donnés en fonction de la valeur
function Computer.testPoint( pos : posCartes) : mem;
var h : hand;

Begin



End;

//rend la meilleur possibilité à jouer pour une main
function Computer.decPossiPlus() : pos;
Var h : hand; res : mem; i, j, k : Integer;

Begin

h := getHand;
for i := 0 to 5 do begin
	setlength(res.lespions,6);
	k := 1;
	for j := 0 to 5 do
		if j = 0 then begin // initialise le tableau de possibilité
			new(res.lespions[j]);
			res.lespions[j]^ := h[i]^;
		end else
			res.lespions[j] := nil;
	for j := i + 1 to 5 do begin // test toutes les possibilités avec la couleur en commun
// manque test possi doublon de merde !!!
		if ((h[j]^.color = h[i]^.color) and (h[j]^.form <> h[i]^.form)) and  then begin
			new(res.lespions[k]);
			res.lespions[k]^ := h[j]^;
			k := k +1;
		end;
	end;
	k := 1;
	for j := 0 to 5 do
		if j = 0 then begin
			new(res.lespions[j]);
			res.lespions[j]^ := h[i]^;
		end else
			res.lespions[j] := nil;
	for j := i + 1 to 5 do begin
		if (h[j]^.form = h[i]^.form) and (h[j]^.color <> h[i]^.color) then begin
			new(res.lespions[k]);
			res.lespions[k]^ := h[j]^;
			k := k +1;
		end;
	end;
end;

End;

begin
end.
