Program EasyUse;

uses gLib2D, SDL_TTF;

var
    text : gImage;
    font : PTTF_Font;
    i: integer;
begin
    randomize;
    gClear(BLACK); (* Pour lancer la librairie et pouvoir charger la police *)
    font := TTF_OpenFont('font.ttf', 35);
    text := gTextLoad('Hello World!', font);
    while true do
    begin
        gClear(BLACK);
	gDrawLine(0,0,300,100,YELLOW);
	for i:= 0 to 50 do gDrawPixel(4*i,4*i,YELLOW);
        
        gDrawRect(100, 0, 600, 600, AZURE);
        gDrawCircle(G_SCR_W div 2, G_SCR_H div 2, 300, WHITE);
        gFillRect(-212 + G_SCR_W div 2, -212 + G_SCR_H div 2, 424, 424, ORANGE);
        gFillCircle(G_SCR_W div 2, G_SCR_H div 2 - 50, 25, CHARTREUSE);
        
        gBlit(G_SCR_W div 2 - text^.w div 2, G_SCR_H div 2 - text^.h div 2, text, text^.w, text^.h);
        
        gFlip();
        
        while (sdl_update = 1) do
            if (sdl_do_quit) then
                exit;
    end;
end.

