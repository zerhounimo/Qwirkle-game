program Screensaver;

uses gLib2D;

var
    size : integer;
    x, y, dx, dy : real;
begin
    size := 42;
    x := 42.;
    y := 42.;
    dx := 0.5;
    dy := 0.5;
    
    while true do
    begin
        gClear(WHITE);
            gBeginRects(nil); (* No texture *)
                gSetColor(AZURE);
                gSetScaleWH(size, size);
                gSetCoord(x, y);
                gSetAlpha(Trunc(x * 255 / G_SCR_W)); (* Useless alpha effect ;) *)
                gAdd(); 
            gEnd();
        gFlip();
        
        while (sdl_update = 1) do
            if (sdl_do_quit) then
                exit;
        
        x += dx;
        y += dy;
        
        if ((x < 0) or (x + size > G_SCR_W)) then
            dx := -dx;
        if ((y < 0) or (y + size > G_SCR_H)) then
            dy := -dy;
    end;
end.

(* EOF *)
