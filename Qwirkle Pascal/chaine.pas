unit chaine;



interface

uses Utils;
FUNCTION longueur(tete : bout_sac) : INTEGER;
FUNCTION creerNoeud(elt : pion) : bout_sac;
FUNCTION creerNoeudD(elt : pion; tete : bout_sac) : bout_sac;
FUNCTION supprimerNoeudD(tete : bout_sac) : bout_sac;
procedure creerNoeudF(elt : pion; tete : bout_sac);
procedure supprimerNoeudF(tete : bout_sac);
procedure creerNoeudM(elt : pion; pos : INTEGER; tete : bout_sac);
procedure supprimerNoeudM(pos : INTEGER; tete : bout_sac);
Function rechercherK(teteListe : bout_sac; k: integer): pion;

implementation

FUNCTION longueur(tete : bout_sac) : INTEGER;
VAR n : INTEGER; tmp : bout_sac; 

BEGIN

n := 0;
tmp := tete;
	WHILE(tmp <> Nil) DO BEGIN
		n := n+1;
		tmp := tmp^.suivant;
	END;
longueur := n;

END;

FUNCTION creerNoeud(elt : pion) : bout_sac;
VAR nv : bout_sac;

BEGIN

new(nv);
nv^.valeur := elt;
nv^.suivant := Nil;
creerNoeud := nv;

END;

FUNCTION creerNoeudD(elt : pion; tete : bout_sac) : bout_sac;
VAR nv : bout_sac;

BEGIN

new(nv);
nv^.valeur := elt;
nv^.suivant := tete;
creerNoeudD := nv;

END;

FUNCTION supprimerNoeudD(tete : bout_sac) : bout_sac;

BEGIN

supprimerNoeudD := tete^.suivant;
dispose(tete);

END;

procedure creerNoeudF(elt : pion; tete : bout_sac);

VAR nv, l : bout_sac;

BEGIN

l := tete;
	while l^.suivant <> nil do
		l := l^.suivant;
new(nv);
nv^.valeur := elt;
nv^.suivant := Nil;
l^.suivant := nv;

END;

procedure supprimerNoeudF(tete : bout_sac);

VAR l : bout_sac; i, lng : integer;

BEGIN

l := tete;
lng := longueur(tete)-2;
	for i := 1 to lng do
		l := l^.suivant;
dispose(l^.suivant);
l^.suivant := nil;

END;


procedure creerNoeudM(elt : pion; pos : INTEGER; tete : bout_sac);
VAR l, l2, nv : bout_sac; i : integer;

BEGIN

l := tete;
l2 := tete;
for i:= 1 to pos-2 do
		l := l^.suivant;
	for i := 1 to pos-1 do
		l2 := l2^.suivant;
new(nv);
nv^.valeur := elt;
nv^.suivant := l2;
l^.suivant := nv;


END;

procedure supprimerNoeudM(pos : INTEGER; tete : bout_sac);

VAR l, l2 : bout_sac; i : integer;

BEGIN

l := tete;
l2 := tete;
	for i := 1 to pos-2 do
		l := l^.suivant;
	for i := 1 to pos do
		l2 := l2^.suivant;
dispose(l^.suivant);
l^.suivant := l2;

END;

Function rechercherK(teteListe : bout_sac; k: integer): pion;
Var i : integer; l : bout_sac;

begin

l := teteListe;
i := 1;
	while i < k do begin
		l := l^.suivant;
		i := i + 1;
	end;
rechercherK := l^.valeur;

end;

end.
