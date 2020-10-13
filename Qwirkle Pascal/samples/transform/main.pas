program Transform;

uses gLib2D;

var
    rot : real;
    i, branches : integer;
begin
    rot := 0;
    branches := 8;
    
    while true do
    begin
        gClear(WHITE);
        
        gBeginRects(nil);
            gSetScaleWH(45, 45);
            gSetCoordMode(G_CENTER);
            gSetCoord(G_SCR_W div 2, G_SCR_H div 2);
            gSetRotation(rot);
            gSetColor(AZURE);
            gAdd();
            gSetRotation(-rot);
            
            for i := 0 to branches - 1 do
            begin
                gPush();
                gSetalpha(200);
                gSetCoordRelative(90, 0);
                gAdd();
                
                gPush();
                gSetalpha(127);
                gSetCoordRelative(90, -30);
                gAdd();
                
                gPop();
                gSetScaleWH(15, 15);
                gSetCoordRelative(90, 30);
                gAdd();
                
                gPop();
                gSetRotationRelative(360 / branches);
            end;
        gEnd();
        
        gFlip();
        
        rot += 0.1;
        if (rot > 360) then
            rot -= 360;
            
        while (sdl_update = 1) do
            if (sdl_do_quit) then
                exit;
    end;
end.

(* EOF *)
