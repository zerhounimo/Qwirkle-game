program KeyControl;

uses gLib2D,SDL;

var
    image : gImage;
    alpha, x, y, w, h, rot : integer;
begin
    image := gTexLoad('tex.png'); (* Texture loading *)
    
    alpha := 255; (* Alpha = 255 => opaque *)
    x := G_SCR_W div 2; (* Middle of screen *)
    y := G_SCR_H div 2; (* Middle of screen *)
    w := image^.w; (* width = image width *)
    h := image^.h; (* height = image height *)
    rot := 0;
    
    SDL_EnableKeyRepeat(10, 10);  (* Si on reste appuyé sur la touche *)
    
    while true do
    begin
        (* Graphics *)
        gClear(BLACK);
            
            gBeginRects(image);
                gSetCoordMode(G_CENTER);
                gSetAlpha(alpha);
                gSetScaleWH(w, h);
                gSetCoord(x, y);
                gSetRotation(rot);
                gAdd();
            gEnd();
            
        gFlip();
        
        (* Controls *)
        while (sdl_update = 1) do
        begin
            if (sdl_do_quit) then
                exit;
            
            case sdl_get_keypressed of
                SDLK_RIGHT : inc(x, 2);
                SDLK_LEFT : dec(x, 2);
                SDLK_DOWN : inc(y, 2);
                SDLK_UP : dec(y, 2);
                
                SDLK_R : inc(rot, 2);
                SDLK_T : dec(rot, 2);
                
                SDLK_A : inc(alpha, 2);
                SDLK_Z : dec(alpha, 2);
                
                SDLK_F : inc(w, 2);
                SDLK_G : dec(w, 2);
                SDLK_V : inc(h, 2);
                SDLK_B : dec(h, 2);
            end;
        end;
    end;
end.

(* EOF *)
