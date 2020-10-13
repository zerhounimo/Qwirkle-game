Program MouseControl;

uses gLib2D;

var
    bgcolor, color: gColor;
    radius: integer;

function distance(x1,y1,x2,y2: integer):real;
begin
   distance := sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
end;

begin
    gClear(BLACK);
    color := WHITE;
    bgcolor := BLACK;
    radius := 150;

    while true do
    begin
        gClear(bgcolor);      
        gFillCircle(G_SCR_W div 2, G_SCR_H div 2, radius, color);
             
        while (sdl_update = 1) do
            if (sdl_do_quit) then
                exit;
	
	    if distance(G_SCR_W div 2, G_SCR_H div 2,sdl_get_mouse_x,sdl_get_mouse_y)<=radius then
            begin
		    gFillCircle(G_SCR_W div 2, G_SCR_H div 2, radius/3, GREEN);
		    if sdl_mouse_left_down then begin color:=BLUE; bgcolor:=BLACK; end
		    else if sdl_mouse_right_down then begin color:=RED; bgcolor:=BLACK; end
		    else if sdl_mouse_left_up then begin color:=WHITE; bgcolor:=BLACK; end
		    else if sdl_mouse_right_up then begin color:=WHITE; bgcolor:=BLACK; end;
	    end else
            begin
		    if sdl_mouse_left_down then begin color:=WHITE; bgcolor:=BLUE; end
		    else if sdl_mouse_right_down then begin color:=WHITE; bgcolor:=RED; end
		    else if sdl_mouse_left_up then begin color:=WHITE; bgcolor:=BLACK; end
		    else if sdl_mouse_right_up then begin color:=WHITE; bgcolor:=BLACK; end;
	    end;
	        gFlip();
    end;

end.

(* EOF *)
