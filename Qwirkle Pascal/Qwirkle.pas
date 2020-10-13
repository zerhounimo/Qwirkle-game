program Qwirkle;


uses UMain, sysutils;


Procedure getArg(i : Integer; Var color, formes, nbtuiles : Integer; Var joueur : String);
	Begin
	If ParamStr(i) = '-j' Then
		joueur := ParamStr(i+1)
	Else If ParamStr(i) = '-c' Then
		color := StrToInt(ParamStr(i+1))
	Else If ParamStr(i) = '-f' Then
		formes := StrToInt(ParamStr(i+1))
	Else If ParamStr(i) = '-t' Then
		nbtuiles := StrToInt(ParamStr(i+1))
	End;


var color, formes, nbtuiles : Integer;
	joueur : String;
begin
	joueur := 'hh';
	color := 6;
	formes := 6;
	nbtuiles := 3;
	getArg(0, color, formes, nbtuiles, joueur);
	getArg(2, color, formes, nbtuiles, joueur);
	getArg(4, color, formes, nbtuiles, joueur);
	getArg(6, color, formes, nbtuiles, joueur);
	UMain.create(joueur, formes, color, nbtuiles); //nb de joueurs, nb de formes, nb de couleurs, nb de fois qu'est chaque pièce
end.
