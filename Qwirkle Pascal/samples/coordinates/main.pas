program Coordinates;

uses gLib2D;

var
    rot : real;
begin
    rot := 0;
    
    while true do
    begin
        gClear(BLACK);
        gBeginRects(nil); (* nil -> white square *)
            gSetScaleWH(42, 42);
            gSetColor(RED); (* Red square *)
            
            gSetCoordMode(G_UP_LEFT);
            gSetCoord(0, 0);
            gSetRotation(rot);
            gAdd();
            
            gSetCoordMode(G_UP_RIGHT);
            gSetCoord(G_SCR_W, 0);
            gSetRotation(-rot);
            gAdd();
            
            gSetCoordMode(G_DOWN_RIGHT);
            gSetCoord(G_SCR_W, G_SCR_H);
            gSetRotation(rot);
            gAdd();
            
            gSetCoordMode(G_DOWN_LEFT);
            gSetCoord(0, G_SCR_H);
            gSetRotation(-rot);
            gAdd();
            
            gSetCoordMode(G_CENTER);
            gSetCoord(G_SCR_W div 2, G_SCR_H div 2);
            gSetRotation(rot);
            gAdd();
        gEnd();
        
        gFlip();
        
        while (sdl_update = 1) do
            if (sdl_do_quit) then (* Clic sur la croix pour fermer *)
                exit;
        
        rot += 0.2;
        if (rot > 360) then
            rot -= 360;
    end;
end.

(* EOF *)
