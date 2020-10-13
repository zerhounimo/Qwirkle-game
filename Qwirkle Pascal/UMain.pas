{$mode objfpc}
{$m+}
unit UMain;
interface
uses Utils, UMap, UPlayer, UHuman, Glib2d, SDL_TTF, sysutils;

type
	listPlayer = array of Player;

	Main = 	class
	private
	nbJoueur, nbForme, nbCouleur, nbPiece : Integer;
	players : listPlayer;
	needUpdate : Boolean;
	selectPion : Ppion;
	selectPos : PPos;
	valid, piocher : Boolean;
	public
      	constructor create(nbJoueur2, nbForme2, nbCouleur2, nbPiece2 : Integer);
		procedure testPlayer();
		procedure createPlayers();
		procedure testMapSac();
		procedure addPlayer(pl : Player);
		procedure update(p : Player);
		procedure printMap();
		procedure updateScreen(p : Player);
		function getSelectPion() : Ppion;
		function getValid() : Boolean;
		function getPioche() : Boolean;
		procedure setSelectPion(p : Ppion);
		function getSelectPos() : Ppos;
end;

procedure create(nbJoueur2 : String; nbForme2, nbCouleur2, nbPiece2 : Integer);

var
	ma : Main;
	click : Boolean;
	var font : PTTF_Font;
	var first : Boolean;
	var check, cancel, pioche : gImage;

implementation


function Main.getValid() : Boolean;
begin
	exit(self.valid);
end;


function Main.getPioche() : Boolean;
begin
	exit(self.piocher);
end;

procedure Main.setSelectPion(p : Ppion);
begin
	self.selectPion := p;
end;

function Main.getSelectPion() : Ppion;
begin
	exit(self.selectPion);
end;



function Main.getSelectPos() : PPos;
begin
	exit(self.selectPos);
end;

constructor Main.create(nbJoueur2, nbForme2, nbCouleur2, nbPiece2 : Integer);
begin
	self.nbJoueur := nbJoueur2;
	self.nbForme := nbForme2;
	self.nbCouleur := nbCouleur2;
	self.nbPiece := nbPiece2;
	self.needUpdate := True;
	self.valid := False;
	self.piocher := False;
	selectPion := nil;
end;

procedure Main.updateScreen(p : Player);
var	playerhand : hand;
i : Integer;
	text: gImage;
begin
		gBeginRects(check); (* No texture *)
				gSetScaleWH(40, 40);
				gSetCoord(480,630);
				gAdd();
		gEnd();
		gBeginRects(cancel);
				gSetScaleWH(40, 40);
				gSetCoord(560,630);
				gAdd();
		gEnd();
		gBeginRects(pioche);
				gSetScaleWH(40, 40);
				gSetCoord(400,630);
				gAdd();
		gEnd();
	if (p.ClassType.InheritsFrom(Human)) then begin
		playerhand := p.getHand();
		for i := 0 to length(playerhand)-1 do begin
				if (playerhand[i] <> Nil) then begin
							gBeginRects(nil); (* No texture *)
									gSetColor(playerhand[i]^.color);
									gSetScaleWH(40, 40);
									gSetCoord((i+1)*40, 630);
									gAdd();
							gEnd();
							text := gTextLoad(IntToStr(playerhand[i]^.form), font);
							gBeginRects(text);
								gSetColor(WHITE);
								gSetCoord((i+1)*40+14, 640);
								gAdd();
							gEnd();
							gTexFree(text);
				end;
		end;
	end;
	(* affichage du nom *)
	text := gTextLoad(p.getName(), font);
	gBeginRects(text);
		gSetColor(WHITE);
		gSetCoord(15, 15); //abscisse, ordonnée
		gAdd();
	gEnd();
	gTexFree(text);
	(* affichage du score *)
	text := gTextLoad('Score : '+IntToStr(p.getScore()), font);
	gBeginRects(text);
		gSetColor(WHITE);
		gSetCoord(15, 35); //abscisse, ordonnée
		gAdd();
	gEnd();
	gTexFree(text);
end;

//rafraichit tout le temps la page (sans forcément en changer le contenu)
procedure Main.update(p : Player);
var i, c1, c2 : Integer;
	po1, po2 : pos;
	text: gImage;
begin
	if first then begin
		first := False;
		font := TTF_OpenFont('font.ttf', 20);
		check := gTexLoad('check.png');
		cancel := gTexLoad('cancel.png');
		pioche := gTexLoad('pioche.png');
	end;
	valid := False;
	piocher := False;
	if (selectPos <> Nil) THEn begin
		dispose(selectPos);
		selectPos := Nil;
	end;
	if selectPion<>nil then begin
			gBeginRects(nil); (* No texture *)
					gSetColor(selectPion^.color);
					gSetScaleWH(40, 40);
					gSetCoord(sdl_get_mouse_x-20, sdl_get_mouse_y-20);
					gAdd();
			gEnd();
			text := gTextLoad(IntToStr(selectPion^.form), font);
			gBeginRects(text);
				gSetColor(WHITE);
				gSetCoord(sdl_get_mouse_x-6, sdl_get_mouse_y-10);
				gAdd();
			gEnd();
			gTexFree(text);
	end;
	IF ((click) and (p.ClassType.InheritsFrom(Human))) THEN begin
		if ((sdl_get_mouse_x >= 0) and (sdl_get_mouse_y >= 0) and (sdl_get_mouse_x <= 600) and (sdl_get_mouse_y <= 600) and (selectPion<>nil)) then begin
			po1 := UMap.getCoCoin(True, False); //pion en haut à gauche
			po2 := UMap.getCoCoin(False, True); //pion en bas à droite
			c1 := (po2.x - po1.x + 3);
			c2 := (po1.y - po2.y + 3);
			if (c2 > c1) then c1 := c2;
			i := Trunc(600/c1);
			new(selectPos);

			selectPos^.x := Trunc(sdl_get_mouse_x/i)+po1.x-1;
			selectPos^.y := -Trunc(sdl_get_mouse_y/i)+po1.y+1;
		end else if ((sdl_get_mouse_y > 630) and (sdl_get_mouse_y < 670) and (sdl_get_mouse_x > 40) and (sdl_get_mouse_x < 280)) then
			selectPion := p.getHand()[Trunc((sdl_get_mouse_x)/40)-1]
			else if ((sdl_get_mouse_y > 630) and (sdl_get_mouse_y < 670) and (sdl_get_mouse_x > 480) and (sdl_get_mouse_x < 520)) then
				valid := True
			else if ((sdl_get_mouse_y > 630) and (sdl_get_mouse_y < 670) and (sdl_get_mouse_x > 560) and (sdl_get_mouse_x < 600)) then
				p.cancel()
			else if ((sdl_get_mouse_y > 630) and (sdl_get_mouse_y < 670) and (sdl_get_mouse_x > 400) and (sdl_get_mouse_x < 440)) then
				piocher := True;
	end;
	WHILE (sdl_update = 1) DO BEGIN
		IF (sdl_do_quit) THEN halt;
		IF sdl_mouse_left_down THEN click:= true;
		IF sdl_mouse_left_up THEN click:= false;
	END;
	updateScreen(p);
end;

procedure Main.testMapSac();
begin
	UMap.createMain();
	Utils.creationSac(nbCouleur, nbForme, nbPiece);
	writeln;
end;

procedure Main.createPlayers();
begin
	setlength(players, nbJoueur);
	addPlayer(Human.create('Jeanne'));
	addPlayer(Human.create('Joueur pour de vrai parce qu''il est vivant'));
end;

procedure Main.printMap();
var po1, po2 : pos;
var k, l, c1, c2, i, c  : Integer;
var no, no2 : PNoeud;
var font : PTTF_Font;
VAR text : gImage;
begin
	po1 := UMap.getCoCoin(True, False);
	po2 := UMap.getCoCoin(False, True);
	no := UMap.getCoin(True, False);
	c1 := (po2.x - po1.x + 3);
	c2 := (po1.y - po2.y + 3);
	if (c2 > c1) then c1 := c2;
	i := Trunc(600/c1);
	c := 0;
	font := TTF_OpenFont('font.ttf', i);
	for k := 0 to c1-1 do begin
		no2 := no;
		for l := 0 to c1-1 do begin
			if ((l = 0) or (k = 0) or (no2 = Nil) or (no2^.value = Nil)) then  begin
				if (c mod 2 = 0) then begin
					gBeginRects(nil); (* No texture *)
					gSetColor(BLACK);
					gSetScaleWH(i, i);
					gSetCoord(l*i, k*i);
					gAdd();
					gEnd();
				end
				else begin
						gBeginRects(nil); (* No texture *)
						gSetColor(GRAY);
						gSetScaleWH(i, i);
						gSetCoord(l*i, k*i);
						gAdd();
						gEnd();
				end;
			end else begin
				gBeginRects(nil); (* No texture *)
				    gSetColor(no2^.value^.color);
				    gSetScaleWH(i, i);
				    gSetCoord(l*i, k*i);
				    gAdd();
				gEnd();
				text := gTextLoad(IntToStr(no2^.value^.form), font);
				gBeginRects(text);
					gSetColor(WHITE);
				gSetCoord(l*i+i/4, k*i);
				gAdd();
			      gEnd();
				gTexFree(text);
			end;
			c := c + 1;
			if ((l > 0) and (k > 0) and (no2 <> Nil)) then no2 := no2^.right;
		end;
		if ((k > 0) and (no <> Nil)) then no := no^.down;
		if (c1 mod 2 = 0) then c := c + 1;
	end;
	TTF_CloseFont(font);
end;
procedure Main.testPlayer();
var i : Integer;
begin
	createPlayers();
	writeln;
	i := 0;
	first := True;
	WHILE true DO BEGIN
		gClear(WHITE);
		gBeginRects(nil); (* No texture *)
			gSetColor(BOUTEILLE);
			gSetScaleWH(700, 100);
			gSetCoord(0, 600);
		gAdd();
		gEnd();
		printMap();
		update(players[i]);
		gFlip();
		if (players[i].play()) then begin
			i := (i+1) mod length(players);
			//updateScreen(players[i]);
		end;
	END;
end;

procedure Main.addPlayer(pl : Player);
var i : Integer;
begin
	for i := 0 to length(players) do
		if players[i] = Nil then begin
			players[i] := pl;
			players[i].pioche(6);
			break;
		end;

end;
procedure create(nbJoueur2 : String; nbForme2, nbCouleur2, nbPiece2 : Integer);
begin
	ma := Main.create(length(nbJoueur2), nbForme2, nbCouleur2, nbPiece2);
	ma.testMapSac();
	ma.testPlayer();
end;



begin

end.
