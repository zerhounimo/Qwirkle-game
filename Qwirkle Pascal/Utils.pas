unit Utils;


interface

Uses Crt, Glib2d;

type

	pion = record
		color : gColor;
		form : Integer;
	end;

	Ppion = ^pion;

	bout_sac = ^noeudS;

	noeudS = record
		valeur : pion;
		suivant : bout_sac;
	end;

	hand = array[0..5] of Ppion;

	posCartes = array of Ppion;
	pos = record
		x,y: integer;
	end;
	PPos = ^pos;
	posPion = array of Ppos;

//	map = array of array of pion;

	Pnoeud = ^noeud;
	mem = record
		val : integer;
		lespions : array of pion;
		ouysont : posPion;
	end;
	noeud = Record
		value : Ppion;
		up : Pnoeud;
		down : Pnoeud;
		right : Pnoeud;
		left : Pnoeud;
	end;

procedure creationSac(c, f, t : Integer);
function piocher(): pion;
function calcPoints(coord : posPion; nbCartes : integer) : integer;
function horizCompte(posit : Ppos) : integer;
function vertCompte(posit : ppos) : integer;

var sac : bout_sac;

operator = (x,y : gColor) r : boolean;


implementation
uses chaine, UMap;

operator = (x,y : gColor) r : boolean;  
begin  
	r := (x.r=y.r) and (x.g=y.g) and (x.b=y.b) and (x.a=y.a);  
end; 

procedure creationSac(c, f, t : Integer);
var res : bout_sac; p : pion; comp, i, j, k : Integer;	
begin

comp := 1;
for i := 0 to t-1 do
for j := 0 to c-1 do
for k := 0 to f-1 do begin
	case j of
		0: p.color := COULEUR1;
		1: p.color := COULEUR2;
		2: p.color := COULEUR3;
		3: p.color := COULEUR4;
		4: p.color := COULEUR5;
		5: p.color := COULEUR6;
		6: p.color := COULEUR7;
		7: p.color := COULEUR8;
		8: p.color := COULEUR9;
		9: p.color := COULEUR10;
		10: p.color := COULEUR11;
		11: p.color := COULEUR12;
	end;
	p.form := k+1;
	if (i = 0) and (j = 0) and (k = 0) then
		res := chaine.creerNoeud(p)
	else
		chaine.creerNoeudM(p, comp, res);
	comp := comp + 1;
end;
sac := res;
end;

function piocher(): pion;
var al, l: integer;

begin
l := longueur(sac);
al := random(l) + 1;
piocher := chaine.rechercherK(sac, al);
	if al = 1 then
		sac := chaine.supprimerNoeudD(sac)
	else if al = l then
		chaine.supprimerNoeudF(sac)
	else
		chaine.supprimerNoeudM(al, sac);

end;


(* Calcul des points pour un tour *)

function calcPoints(coord : posPion; nbCartes : integer) : integer;
var
	n, i : integer;
begin
	n := 0; //compteur de points
	n := n + horizCompte(coord[0]);
	n := n + vertCompte(coord[0]);
	if nbCartes>1 then
		if coord[0]^.y=coord[1]^.y then //pions placés horizontalement
			for i:=1 to nbCartes-1 do
				n := n + vertCompte(coord[i])
		else 
			for i:=1 to nbCartes-1 do
				n := n + horizCompte(coord[i]);
	calcPoints := n;	
end;

function horizCompte(posit : Ppos) : integer;
var
	n, i : integer;
begin
	n := 0;
	i := 0;
	while UMap.getValueOrNil(posit^.x-i, posit^.y)<>nil do begin //compte le nombre de pions à gauche (en comptant le pion central)
		i := i+1;
		n := n+1;
	end;
	i := 1;
	while UMap.getValueOrNil(posit^.x+i, posit^.y)<>nil do begin //nombre de pions à droite (sans compter le pion central)
		i := i+1;
		n := n+1;
	end;
	if n = 6 then n:=12; //Qwirkle
	if n = 1 then n:=0; //si le pion n'a pas de voisin, il ne marque pas de point en plus
	horizCompte := n;
end;

function vertCompte(posit : ppos) : integer;
var
	n, i : integer;
begin
	n := 0;
	i := 0;
	while UMap.getValueOrNil(posit^.x, posit^.y-i)<>nil do begin //nombre de pions en haut
		i := i+1;
		n := n+1;
	end;
	i := 1;
	while UMap.getValueOrNil(posit^.x, posit^.y+i)<>nil do begin //nombre de pions en bas
		i := i+1;
		n := n+1;
	end;
	if n = 6 then n:=12; //Qwirkle
	if n = 1 then n:=0;
	vertCompte := n;
end;

begin

randomize;

end.
