program Text;

uses gLib2D, SDL, SDL_TTF;

var
    text_image : gImage;
    font : PTTF_Font;
    
    rot : real;
begin
(* gClear : Juste pour lancer le mode graphique, et activer les polices *)
    gClear(BLACK);
    
    font := TTF_OpenFont('font.ttf', 45);
    text_image := gTextLoad('Texte de test avec rotation', font);
    
    rot := 0;
    
    while true do
    begin
        gClear(BLACK);
        
        gBeginRects(text_image);
            gSetCoordMode(G_CENTER);
            gSetCoord(G_SCR_W div 2, G_SCR_H div 2);
            gSetColor(CHARTREUSE);
            gSetRotation(rot);
            gAdd();
        gEnd();
        
        gFlip();
        
        while (sdl_update = 1) do
            if (sdl_do_quit) then
                exit;
        
        rot += 0.01;
        if (rot > 360) then
            rot -= 360;
    end;
end.

(* EOF *)
