program GameMain;
uses SwinGame, sgTypes;

type

 Circle = record
   startX: Single;
   startY: Single;
   finishX :Single;
   finishY: Single;
   centerX: Single;
   centerY: Single;
   radius : Single;
   dragging: boolean;
   newshape: boolean;
end;

CirclesType = array of Circle;

DotType = record
     x: Single;
     y: Single;
     newshape: boolean;
  end;

DotsType= array of DotType;

Shape = record
    x: Single;
    y: Single;
    width: Single;
    hight: Single;
    dragging: boolean;
    newshape: boolean;
 end;

ShapesType= array of Shape;

objects = (en, pen, rectangle);
History = array of objects;


function DrowDot(var p:panel; dots:DotsType; historys:History):DotsType;

var 
  mouse_X: Single;
  mouse_Y: Single;
  i :Integer;
begin
  UpdateInterface();
  mouse_X := MouseX();
  mouse_Y := MouseY();
  if IsDragging(p) and (mouse_X <= 723) then

    begin
      i := High(dots);
      FillCircle(ColorRed, mouse_X, mouse_Y, 5);
      dots[i].x := mouse_X;
      dots[i].y := mouse_Y;
      dots[i].newshape := true;

      SetLength(dots, Length(dots)+1);
    end;

   result := dots;
end;

function DrawCircle(var p:panel; circles:CirclesType; historys:History):CirclesType;

var
  mouse_X: Single;
  mouse_Y: Single;
  i :Integer;
begin
  UpdateInterface();
  mouse_X := MouseX();
  mouse_Y := MouseY();
  if (mouse_X <= 723)  then//incorrect
    begin
      i := High(circles);
    if (IsDragging(p) = true) and (circles[i].dragging = false) then
     begin
       WriteLn(i, 'th circle is start drowwing.');
       circles[i].dragging := true;
       circles[i].startX := mouse_X;
       circles[i].startY := mouse_Y;
       circles[i].newshape := false;
       //WriteLn(i, 'th circle is start drowwing from ',circles[i].startX,' x.');
       //WriteLn(i, 'th circle is start drowwing from ',circles[i].startY,' y.');

     end

    else if (IsDragging(p) = true) and (circles[i].dragging = true) then
      begin
        WriteLn(i,'th shape is now dragging.')
      end

    else if (IsDragging(p) = false) and (circles[i].dragging = true) then
      begin
         circles[i].dragging := false;
         circles[i].finishX := mouse_X;
         circles[i].finishY := mouse_Y;
         circles[i].centerX := circles[i].finishX + circles[i].startX;
         circles[i].centerY := circles[i].finishY + circles[i].startY;
         circles[i].centerX := circles[i].centerX/2;
         circles[i].centerY := circles[i].centerY/2;
         circles[i].radius := (circles[i].finishX - circles[i].startX) * (circles[i].finishX - circles[i].startX) + (circles[i].finishY - circles[i].startY) * (circles[i].finishY - circles[i].startY);
         circles[i].radius := Sqrt(circles[i].radius)/2;

         //WriteLn('shape ',i, 'has',circles[i].radius,'radius.');
         //WriteLn('shape ',i, 'has center',circles[i].centerX,'x.');
         //WriteLn('shape ',i, 'has center',circles[i].centerY,'y.');
         SetLength(circles, Length(circles)+1);

         circles[i].newshape := true;

      end;
    end;
   result := circles;
end;


function DrawShape(var p:panel; shapes:ShapesType; historys:History):ShapesType;

var 
  mouse_X: Single;
  mouse_Y: Single;
  i :Integer;
begin
  UpdateInterface();
  mouse_X := MouseX();
  mouse_Y := MouseY();
  if (mouse_X <= 723) then//incorrect
    begin
      i := High(shapes);
    if (IsDragging(p) = true) and (shapes[i].dragging = false) then
     begin
       shapes[i].dragging := true;
       shapes[i].x := mouse_X;
       shapes[i].y := mouse_Y;
       shapes[i].newshape := false;
     end

    else if (IsDragging(p) = true) and (shapes[i].dragging = true) then
      begin
        WriteLn(i,'th shape is now dragging.')
      end

    else if (IsDragging(p) = false) and (shapes[i].dragging = true) then
      begin
         shapes[i].dragging := false;
         shapes[i].width := mouse_X - shapes[i].x;
         shapes[i].hight := mouse_Y - shapes[i].y;

         if shapes[i].hight < 0 then
           begin
              shapes[i].hight := shapes[i].hight * -1;
              shapes[i].y := shapes[i].y - shapes[i].hight;
           end;


          if shapes[i].width < 0 then
           begin
              shapes[i].width := shapes[i].width * -1;
              shapes[i].x := shapes[i].x - shapes[i].width;
          end;
         WriteLn('shape ',i, 'has',shapes[i].width,'width.');
         WriteLn('shape ',i, 'has',shapes[i].hight,'hight.');
         //WriteLn('shape ',i, 'start from',shapes[i].x,'x.');
         //WriteLn('shape ',i, 'start from',shapes[i].y,'y.');
         SetLength(shapes, Length(shapes)+1);

         shapes[i].newshape := true;


      end;
    end;
   result := shapes;
end;

function Menu(var tool:objects): objects;
  var
     mouse_X: Single;
     mouse_Y: Single;
begin
     mouse_X := MouseX();
     mouse_Y := MouseY();


if MouseClicked(LeftButton) and (mouse_X >= 723) and (mouse_Y <= 129) then
       begin
          //WriteLn('pen clicked');
          result := pen;
       end
else if MouseClicked(LeftButton) and (mouse_X >= 723) and (mouse_Y >= 129) and (mouse_Y <=260 )then
       begin
         //WriteLn('en clicked');
         result := en;
       end
else if MouseClicked(LeftButton) and (mouse_X >= 723) and (mouse_Y >= 260) and (mouse_Y <= 389) then
       begin
          //WriteLn('rectangle clicked');
          result := rectangle;
       end
else
       begin
         result := tool;
       end;
end;


procedure Main();
  var
    p: Panel;
    p1: Panel;
    p2: Panel;
    p3: Panel;

    circles :CirclesType;
    shapes :ShapesType;
    dots :DotsType;
    historys :History;

    i :Integer;
    castRadius :Integer;
    castWidth :Integer;
    castHight :Integer;
    castDots  :Integer;

    tool: objects;

    dotsIndex: Integer;
    shapesIndex: Integer;
    circlesIndex :Integer;

begin
  OpenGraphicsWindow('Pintor', 881, 643);
  p := LoadPanel('palet.txt' );
  p1 := LoadPanel('palet_circle_active.txt' );
  p2 := LoadPanel('palet_shape_active.txt' );
  p3 := LoadPanel('palet_pen_active.txt' );

  SetLength(circles, 1);
  SetLength(shapes, 1);
  SetLength(dots, 1);
  SetLength(historys,1);
   tool := pen;
  ShowSwinGameSplashScreen();

  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    GUISetBackgroundColor(ColorWhite);
    DrawFramerate(0,0);
    ShowPanel(p);
    ActivatePanel(p);
    DrawInterface();

    if     tool = en then

    begin

     if PanelVisible(p2) then
         HidePanel(p3);

      if PanelVisible(p3) then
         HidePanel(p3);

      ShowPanel(p1);
      ActivatePanel(p1);
      circles := DrawCircle(p,circles,historys);
        if circles[High(circles)-1].newshape then
         begin
           circles[High(circles)-1].newshape := false;
           historys[High(historys)] := en;
           SetLength(historys,Length(historys)+1);
         end;
    end

    else if tool = rectangle then
    begin

      if PanelVisible(p1) then
         HidePanel(p1);

      if PanelVisible(p3) then
         HidePanel(p3);
      ShowPanel(p2);
      ActivatePanel(p2);
      shapes := DrawShape(p,shapes,historys);
      if shapes[High(shapes)-1].newshape then
         begin
           //WriteLn(High(dots)-2,' is recteangle');
           shapes[High(shapes)-1].newshape := false;
           historys[High(historys)] := rectangle;
           //WriteLn(High(historys),' rectangle has been added.');
           SetLength(historys,Length(historys)+1);
         end;

    end

    else if tool = pen then
    begin

       if PanelVisible(p1) then
         HidePanel(p1);

      if PanelVisible(p2) then
         HidePanel(p2);

       ShowPanel(p3);
       ActivatePanel(p3);
       
        dots := DrowDot(p,dots,historys);

         if dots[High(dots)-1].newshape then
         begin
           //WriteLn(High(dots)-2,' is pen');
           dots[High(dots)-1].newshape := false;
           historys[High(historys)] := pen;
           WriteLn(High(historys),' pen has been added.');
           SetLength(historys,Length(historys)+1);
         end;

    end;

// Drowing Engine Start

    dotsIndex := 0;
    shapesIndex := 0;
    circlesIndex := 0;


    for  i := Low(historys) to High(historys) do
     begin
       if historys[i] = en then
        begin
         if (circles[circlesIndex].centerX > 0) and  (circles[circlesIndex].centerY > 0) then
          begin
           castRadius := round(circles[circlesIndex].radius);
           FillCircle(ColorBlue, circles[circlesIndex].centerX, circles[circlesIndex].centerY, castRadius);
           castRadius := 0;
           circlesIndex := circlesIndex +1;
          end;
        end //end of history=en

        else if historys[i] = rectangle then
         begin
         if (shapes[shapesIndex].width > 0) and  (shapes[shapesIndex].hight > 0) then
          begin
             castWidth := round(shapes[shapesIndex].width);
             castHight := round(shapes[shapesIndex].hight);
             FillRectangle(ColorBlue, shapes[shapesIndex].x,shapes[shapesIndex].y ,castWidth,castHight);
             castWidth := 0;
             castHight := 0;

             shapesIndex := shapesIndex+1;
          end;

         end//end of history = rectangle

        else if historys[i] = pen then
        begin

          if dots[dotsIndex].x > 0 then
           begin
            //WriteLn('Drow dots number :',dotsIndex);
            FillCircle(ColorRed, dots[dotsIndex].x, dots[dotsIndex].y , 5);
           end;
            dotsIndex := dotsIndex +1 ;
        end;

    end;//end of for i
// Drowing Engine End

    tool := Menu(tool);

    RefreshScreen(100);
  until WindowCloseRequested();


end;

begin
  Main();
end.
