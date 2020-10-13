{$mode objfpc}
{$m+}
unit UPlayer;
interface

uses Utils, chaine, UMap;

type Player = 	class
	private
	name : String;
	playerhand : hand;
	playedPos : posPion;
	playedPion : posCartes;
	score : integer;
	public
      	constructor create(nom : String); // constructor une function qui est appelée à la création de la classe
	function getName() : String;
	function getHand() : hand;
	function getPlayedPos() : posPion;
	function getPlayedPion() : posCartes;
	procedure setHand(phand : hand);
	function play() : Boolean; virtual; abstract; // Fonction abstract = les filles de Player doivent la définir, virtual : pas défini ici
	procedure pioche(i : Integer);
	procedure poser(p1 : pion; x, y : integer);
	procedure addHand(pi : pion);
	procedure cancel();
	procedure supprHand(pi : pion);
	procedure reputinSac(a : posCartes);
	function verifPlace(carte : pion; coord : pos; listCoord : posPion) : boolean;
	procedure setScore(i : integer);
	function getScore() : integer;
	procedure clearPosed();

end;


implementation

uses UMain;

	
function Player.getPlayedPos() : posPion;
begin
	exit(self.playedPos);
end;


function Player.getPlayedPion() : posCartes;
begin
	exit(self.playedPion);
end;

procedure Player.setScore(i : integer);
begin
	self.score := i;
end;

function Player.getScore() : integer;
begin
	exit(self.score);
end;
procedure Player.clearPosed();
var
	i : integer;
begin
	for i := 0 to 5 do begin
		self.playedPos[i] := Nil;
		self.playedPion[i] := Nil;
	end;
end;

procedure Player.cancel();
var i : Integer;
begin
	for i := 0 to length(playedPion)-1 do begin
		if (playedPion[i] <> Nil) then begin
				addHand(playedPion[i]^);
				if (playedPos[i] <> Nil) then 
				UMap.resetPoint(playedPos[i]^.x, playedPos[i]^.y);
			end;
	end;
	clearPosed();
	UMain.ma.setSelectPion(Nil);
end;

//vérifie qu'un pion est plaçable à un endroit
function Player.verifPlace(carte : pion; coord : pos; listCoord : posPion) : boolean;
var
	p1, p2 : Pnoeud;
	x, y, i : Integer;
	isx, isy : boolean;
var po1, po2 : pos;
begin
	isx := False;
	isy := False;
	po1 := getCoCoin(True, False);
	po2 := getCoCoin(False, True);
	p1 := UMap.getNoeudOrNil(coord.x, coord.y);
	if (p1 = Nil) then begin
		if (((coord.x > po2.x) and (coord.y > po1.y)) or ((coord.x > po2.x) and (coord.y < po2.y)) or ((coord.x < po1.x) and (coord.y > po1.y)) or ((coord.x < po1.x) and (coord.y < po2.y))) THEN
			exit(false);
		if (coord.x-1 > po2.x) or (coord.x+1 < po1.x) or (coord.y-1 > po1.y) or (coord.y+1 < po2.y) then exit(False);
		if (coord.x > po2.x) then begin
			p2 := UMap.getNoeud(po2.x, coord.y);
			if (p2^.value = Nil) then exit(False);
			while ((p2 <> nil) and (p2^.value <> nil)) do begin
				if (((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color))) then
					exit(false);
				p2 := p2^.left;
			end;
		end;
		if (coord.x < po1.x) then begin	
			p2 := UMap.getNoeud(po1.x, coord.y);
			if (p2^.value = Nil) then exit(False);
			while ((p2 <> nil) and (p2^.value <> nil)) do begin	
				if (((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color))) then
					exit(false);
				p2 := p2^.right;
			end;
		end;
		if (coord.y > po1.y) then begin
			p2 := UMap.getNoeud(coord.x, po1.y);
			if (p2^.value = Nil) then exit(False);
			while ((p2 <> nil) and (p2^.value <> nil)) do begin
				if (((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color))) then
				exit(false);
			p2 := p2^.down;
			end;
		end;
		if (coord.y < po2.y) then begin
			p2 := UMap.getNoeud(coord.x, po2.y);	
			if (p2^.value = Nil) then exit(False);
			while ((p2 <> nil) and (p2^.value <> nil)) do begin
				if (((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color))) then
					exit(false);
				p2 := p2^.up;
			end;
		end;
	end;
	for i := 0 to length(listCoord)-1 do begin
		if (listCoord[i] = Nil) then break;
		if (i = 0) then begin
			x := listCoord[i]^.x;
			y := listCoord[i]^.y;
		end else if ((i = 1) and (x = listCoord[i]^.x)) then begin
			isx := True;
		end else if ((i = 1) and (y = listCoord[i]^.y)) then begin
			isy := True;
		end else if (i = 1) then exit(false)
		else if ((i > 1) and ((isx and (x <> listCoord[i]^.x)) or (isy and (y <> listCoord[i]^.y)))) then begin
			exit(false);
			end;
	end;
	if (p1 <> Nil) then begin
	if (p1^.value <> nil) or (((p1^.up = nil) or (p1^.up^.value = nil)) and ((p1^.right = nil) or (p1^.right^.value = nil)) and ((p1^.down = nil) or (p1^.down^.value = nil)) and ((p1^.left = nil) or (p1^.left^.value = nil)) and ((coord.x <> 0) or (coord.y <> 0))) then
		exit(false);
	p2 := p1;
		while ((p2^.left <> nil) and (p2^.left^.value <> nil)) do begin
			p2 := p2^.left;
			if (((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color))) then
				exit(false);
		end;
	p2 := p1;
		while ((p2^.right <> nil) and (p2^.right^.value <> nil)) do begin
			p2 := p2^.right;
			if ((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color)) then
				exit(false);
		end;
	p2 := p1;
		while ((p2^.up <> nil) and (p2^.up^.value <> nil)) do begin
			p2 := p2^.up;
			if ((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color)) then
				exit(false);
		end;
	p2 := p1;
		while ((p2^.down <> nil) and (p2^.down^.value <> nil)) do begin
			p2 := p2^.down;
			if ((p2^.value^.form <> carte.form) and (p2^.value^.color <> carte.color)) or  ((p2^.value^.form = carte.form) and (p2^.value^.color = carte.color)) then
				exit(false);
		end;
	end;
	verifPlace := true;
end;

constructor Player.create(nom : String);
var i : Integer;
begin
	self.name := nom;
	for i := 0 to length(self.playerhand)-1 do
			self.playerhand[i] := Nil;
	self.score := 0;
	setlength(playedPos, 6);
	setlength(playedPion, 6);
	clearPosed();
end;

procedure Player.supprHand(pi : pion);
var j : Integer;

begin

	for j := 0 to length(getHand)-1 do
		if ((self.playerhand[j] <> Nil) and (self.playerhand[j]^.color = pi.color) and (self.playerhand[j]^.form = pi.form)) then begin
			dispose(self.playerhand[j]);
			self.playerhand[j] := Nil;
			break;
		end;

end;

procedure Player.reputinSac(a : posCartes);
var i : Integer;
begin
	for i := 0 to length(a)-1 do begin
		if (a[i] <> Nil) then begin
			chaine.creerNoeudF(a[i]^, Utils.sac);
		end;
	end;
end;

procedure Player.pioche(i : Integer);
var j : Integer;
begin
	for j := 0 to i-1 do
		addHand(Utils.piocher());

end;

procedure Player.addHand(pi : pion);
var i : Integer;
begin
	for i := 0 to length(self.playerhand)-1 do
		if (self.playerhand[i] = Nil) then begin
			new(self.playerhand[i]);
			self.playerhand[i]^ := pi;
			break;
		end;
end;


procedure Player.poser(p1 : pion; x, y : integer);
begin

supprHand(p1);
UMap.placePoint(x, y, p1);
end;



function Player.getName() : String;
begin
	exit(self.name);
end;


function Player.getHand() : hand;
begin
	exit(self.playerhand);
end;


procedure Player.setHand(phand : hand);
begin
	self.playerhand := phand;
end;






begin
end.
