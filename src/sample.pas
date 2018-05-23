program GameMain;
uses SwinGame, sgTypes;

type

 DotType = record
     x: Single;
     y: Single;
  end;

DotsType= array of DotType;

function Picture(var p:panel; dots:DotsType):DotsType;

var 
  mouse_X: Single;
  mouse_Y: Single;
  i :Integer;
begin
  UpdateInterface();
  if IsDragging(p) then
    begin
      i := High(dots);
      mouse_X := MouseX();
      mouse_Y := MouseY();
      FillCircle(ColorRed, mouse_X, mouse_Y, 5);
   
      dots[i].x := mouse_X;
      dots[i].y := mouse_Y;
      SetLength(dots, High(dots)+2);
    end;
   result := dots;
end;


procedure Main();
  var
    p: Panel;
    dot :DotType;
    dots :DotsType;
    i :Integer;
begin
  OpenGraphicsWindow('Pintor', 800, 600);
  p := LoadPanel('newpanel.txt' );
  SetLength(dots, 1);
  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    GUISetBackgroundColor(ColorWhite);
    DrawFramerate(0,0);
    ShowPanel(p);
    DrawInterface();

    dots := Picture(p,dots);

    for  i := Low(dots) to High(dots) do
     begin
       FillCircle(ColorRed, dots[i].x, dots[i].y , 5);
     end;

    RefreshScreen(100);
  until WindowCloseRequested();
end;

begin
  Main();
end.
