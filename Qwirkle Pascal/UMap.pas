unit UMap;

interface

uses Utils;
var noeudMain : Pnoeud;

procedure placePoint(i, j : Integer; value : pion);
procedure resetPoint(i, j : Integer);
procedure createMain();
function getNoeud(i, j : Integer) : PNoeud;
function getValue(i, j : Integer) : PPion;
function getCoCoin(up, right : Boolean) : pos;
function getCoin(up, right : Boolean) : PNoeud;
function getNoeudOrNil(i, j : Integer) : PNoeud;
function getValueOrNil(i, j : Integer) : PPion;

implementation

function getCoin2(noeud : PNoeud; up, right : Boolean) : PNoeud;
begin
	if (up and (noeud^.up <> Nil)) then
		exit(getCoin2(noeud^.up, up, right))
	else if ((right = False) and (noeud^.left <> Nil)) then
		exit(getCoin2(noeud^.left, up, right))
	else if ((up = False) and (noeud^.down <> Nil)) then
		exit(getCoin2(noeud^.down, up, right))
	else if (right and (noeud^.right <> Nil)) then
		exit(getCoin2(noeud^.right, up, right))
	else
		exit(noeud);
end;


function getCoin(up, right : Boolean) : PNoeud;
begin
	exit(getCoin2(noeudMain,up, right));
end;

procedure getCoCoin2(noeud : PNoeud; up, right : Boolean; var po : pos);
begin
	if (up and (noeud^.up <> Nil)) then begin
		po.y := po.y + 1;
		getCoCoin2(noeud^.up, up, right, po);
	end else if ((right = False) and (noeud^.left <> Nil)) then begin
		po.x := po.x - 1;
		getCoCoin2(noeud^.left, up, right, po);
	end else if ((up = False) and (noeud^.down <> Nil)) then begin
		po.y := po.y - 1;
	  getCoCoin2(noeud^.down, up, right, po);
	end else if (right and (noeud^.right <> Nil)) then begin
		po.x := po.x + 1;
		getCoCoin2(noeud^.right, up, right, po);
	end;
end;

function getCoCoin(up, right : Boolean) : pos;
var po : pos;
begin
		po.x := 0;
		po.y := 0;
		getCoCoin2(noeudMain, up, right, po);
		exit(po);
end;


procedure init(var noeud : PNoeud);
begin
	new(noeud);
	noeud^.up := Nil;
	noeud^.down := Nil;
	noeud^.right := Nil;
	noeud^.left := Nil;
	noeud^.value := Nil;
end;

procedure createMain();
begin
	init(noeudMain);
end;

procedure create(noeud : PNoeud; i : Integer);
begin
	if (i = 0) then begin
		init(noeud^.up);
		noeud^.up^.down := noeud;
		if (noeud^.left <> Nil) then begin
			noeud^.up^.left := noeud^.left^.up;
			noeud^.up^.left^.right := noeud^.up;
		end;
		if (noeud^.right <> Nil) then
			create(noeud^.right, i);
	end else if (i = 1) then begin
		init(noeud^.right);
		noeud^.right^.left := noeud;
		if (noeud^.up <> Nil) then begin
			noeud^.right^.up := noeud^.up^.right;
			noeud^.right^.up^.down := noeud^.right;
		end;
		if (noeud^.down <> Nil) then
			create(noeud^.down, i);
	end else if (i = 2) then begin
		init(noeud^.down);
		noeud^.down^.up := noeud;
		if (noeud^.right <> Nil) then begin
			noeud^.down^.right := noeud^.right^.down;
			noeud^.down^.right^.left := noeud^.down;
		end;
		if (noeud^.left <> Nil) then
			create(noeud^.left, i);
	end else if (i = 3) then begin
		init(noeud^.left);
		noeud^.left^.right := noeud;
		if (noeud^.down <> Nil) then begin
			noeud^.left^.down := noeud^.down^.left;
			noeud^.left^.down^.up := noeud^.left;
		end;
		if (noeud^.up <> Nil) then
			create(noeud^.up, i);
	end;
end;

procedure createDir(noeud : PNoeud; i : Integer);
begin
	create(getCoin2(noeud, (i = 0) or (i = 1), (i = 1) or (i = 2)), i);
end;

function getNoeud2(i, j : Integer; noeud : PNoeud) : PNoeud;
begin
	if ((i = 0) and (j = 0)) then begin
		exit(noeud);
	end else if (i > 0) then begin
		if (noeud^.right = Nil) then
			createDir(noeud, 1);
		exit(getNoeud2(i - 1, j , noeud^.right));
	end else if (i < 0) then begin
		if (noeud^.left = Nil) then
			createDir(noeud, 3);
		exit(getNoeud2(i + 1, j , noeud^.left));
	end else if (j > 0) then begin
		if (noeud^.up = Nil) then
			createDir(noeud, 0);
		exit(getNoeud2(i, j - 1, noeud^.up));
	end else if (j < 0) then begin
		if (noeud^.down = Nil) then
			createDir(noeud, 2);
		exit(getNoeud2(i, j + 1, noeud^.down));
	end;
	exit(Nil);
end;

function getNoeud(i, j : Integer) : PNoeud;
begin
	exit(getNoeud2(i, j, noeudMain));
end;


function getNoeudOrNil2(i, j : Integer; noeud : PNoeud) : PNoeud;
begin
	if ((i = 0) and (j = 0)) then begin
		exit(noeud);
	end else if (i > 0) then begin
		if (noeud^.right = Nil) then
			exit(Nil);
		exit(getNoeudOrNil2(i - 1, j , noeud^.right));
	end else if (i < 0) then begin
		if (noeud^.left = Nil) then
			exit(Nil);
		exit(getNoeudOrNil2(i + 1, j , noeud^.left));
	end else if (j > 0) then begin
		if (noeud^.up = Nil) then
			exit(Nil);
		exit(getNoeudOrNil2(i, j - 1, noeud^.up));
	end else if (j < 0) then begin
		if (noeud^.down = Nil) then
			exit(Nil);
		exit(getNoeudOrNil2(i, j + 1, noeud^.down));
	end;
	exit(Nil);
end;

function getNoeudOrNil(i, j : Integer) : PNoeud;
begin
	exit(getNoeudOrNil2(i, j, noeudMain));
end;

function getValue2(i, j : Integer; noeud : PNoeud) : PPion;
var pn : PNoeud;
begin
	pn := getNoeud2(i, j, noeud);
	if (pn <> Nil) then exit(pn^.value);
	exit(Nil);
end;

function getValue(i, j : Integer) : PPion;
begin
	exit(getValue2(i, j, noeudMain));
end;

function getValueOrNil(i, j : Integer) : PPion;
var n : PNoeud;
begin
	n := getNoeudOrNil(i, j);
	if (n <> Nil) then exit(n^.value);
	exit(Nil);
end;

procedure placePoint(i, j : Integer; value : pion);
var p : PNoeud;
begin
	p := getNoeud2(i, j, noeudMain);
	if (p <> Nil) then begin
		new(p^.value);
		p^.value^ := value;
	end;
end;

procedure resetPoint(i, j : Integer);
var p : PNoeud;
begin
	p := getNoeud2(i, j, noeudMain);
	if (p <> Nil) then begin
		if (p^.value <> Nil) then
			dispose(p^.value);
		p^.value := Nil;
	end;
end;

Begin
end.
