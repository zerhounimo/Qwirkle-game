{$mode objfpc}
{$m+}
unit UHuman;
interface
uses Utils, UPlayer, crt, UMap;

type
	Human = 	class(Player)
	public
    	constructor create(nom : String);
		function play() : Boolean; override;
  	end;

implementation

uses UMain;

constructor Human.create(nom : String);
begin
	inherited Create(nom); // appel de la fct de la mère
end;

function Human.play() : Boolean;
var
	i, j : integer;
begin
		i := 0;
		j := 0;
		if (UMain.ma.getValid()) then begin
				for i := 0 to 6 do begin
					if ((i < 6) and (getPlayedPion()[i] = Nil)) then begin
							break;
					end;
				end;
				if (i > 0) then begin
					for j := 0 to 6 do begin
						if ((j < 6) and (getPlayedPos()[j] = Nil)) then begin
								break;
						end;
					end;
					if (j > 0) then 
						setScore(getScore() + calcPoints(getPlayedPos(), i))
					else
						reputinSac(getPlayedPion());
					writeln(getName(), ' ', getScore());
					clearPosed();
					pioche(i);
					UMain.ma.setSelectPion(Nil);
					exit(True);
				end;
		end;
		if (UMain.ma.getSelectPion() <> Nil) THEN begin
			if (UMain.ma.getSelectPos() <> Nil) THEN begin
				for i := 0 to 6 do begin
					if ((i < 6) and (getPlayedPion()[i] = Nil)) then begin
						break;
					end;
				end;

				for j := 0 to 6 do begin
					if ((j < 6) and (getPlayedPos()[j] = Nil)) then begin
							break;
					end;
				end;
				if ((j > 0) or (i = 0)) then begin
					for i := 0 to 5 do begin
						if (getPlayedPos()[i] = Nil) then begin
								new(self.getPlayedPos()[i]);
								new(self.getPlayedPion()[i]);
								self.getPlayedPos()[i]^ := UMain.ma.getSelectPos()^;
								self.getPlayedPion()[i]^ := UMain.ma.getSelectPion()^;
								break;
						end;
					end;
					if (verifPlace(UMain.ma.getSelectPion()^, UMain.ma.getSelectPos()^, getPlayedPos())) then begin
						poser(UMain.ma.getSelectPion()^, UMain.ma.getSelectPos()^.x, UMain.ma.getSelectPos()^.y);
						UMain.ma.setSelectPion(Nil);
					end else begin
						dispose(self.getPlayedPos()[i]);
						dispose(self.getPlayedPion()[i]);
						self.getPlayedPos()[i] := Nil;
						self.getPlayedPion()[i] := Nil;
					end;
				end;
			end else if (UMain.ma.getPioche()) then begin
				for i := 0 to 6 do begin
					if ((i < 6) and (getPlayedPos()[i] = Nil)) then begin
							break;
					end;
				end;
				if (i = 0) then begin
					for i := 0 to 5 do begin
						if (getPlayedPion()[i] = Nil) then begin
							new(self.getPlayedPion()[i]);
							self.getPlayedPion()[i]^ := UMain.ma.getSelectPion()^;
							supprHand(getPlayedPion()[i]^);
							UMain.ma.setSelectPion(Nil);
							break;
						end;
					end;
				end;
			end;
		end;
	exit(False);
end;

begin
end.
