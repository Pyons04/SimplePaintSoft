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
  if IsDragging(p) and (mouse_X >= 40) and (mouse_Y >= 80) then

    begin
      i := High(dots)-1;
      //WriteLn('i',i);
      FillCircle(ColorRed, mouse_X, mouse_Y, 5);
      dots[i].x := mouse_X;
      dots[i].y := mouse_Y;
      dots[i].newshape := true;

      SetLength(dots, High(dots)+2);
      //WriteLn('highdots :',High(dots)); //クリックしても配列の長さが増えていない。
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
  if (mouse_X >= 40) and (mouse_Y >= 80) then//incorrect
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

         //SetLength(historys,High(historys)+2);
         //historys[High(historys)] := en;
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
  if (mouse_X >= 40) and (mouse_Y >= 120) then//incorrect
    begin
      i := High(shapes);
    if (IsDragging(p) = true) and (shapes[i].dragging = false) then
     begin
       //WriteLn(i, 'th shape is start drowwing.');
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
         //WriteLn('shape ',i, 'has',shapes[i].width,'width.');
         //WriteLn('shape ',i, 'has',shapes[i].hight,'hight.');
         //WriteLn('shape ',i, 'start from',shapes[i].x,'x.');
         //WriteLn('shape ',i, 'start from',shapes[i].y,'y.');
         SetLength(shapes, Length(shapes)+1);

         shapes[i].newshape := true;


      end;
    end;
    //SetLength(dots, High(dots)+2);
   result := shapes;
end;

function Menu(var tool:objects): objects;
  var
     mouse_X: Single;
     mouse_Y: Single;
begin
     FillRectangle(ColorGrey ,0 ,0 ,40,40);
     FillRectangle(ColorGreen ,0 ,40 ,40,40);
     FillRectangle(ColorRed ,0 ,80 ,40,40);
     mouse_X := MouseX();
     mouse_Y := MouseY();


if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=0 ) and (mouse_Y <=  40) then
       begin
          //WriteLn('pen clicked');
          result := pen;
       end
else if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=40 ) and (mouse_Y <=  80) then
       begin
         //WriteLn('en clicked');
         result := en;
       end
else if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=80 ) and (mouse_Y <=  120) then
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
  OpenGraphicsWindow('Pintor', 800, 600);
  p := LoadPanel('newpanel.txt' );

  SetLength(circles, 1);
  SetLength(shapes, 1);
  SetLength(dots, 1);
  SetLength(historys,1);
  //CreateBitmap('picture3.bmp', 800, 600);
   tool := pen;


  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    GUISetBackgroundColor(ColorWhite);
    DrawFramerate(0,0);
    ShowPanel(p);
    DrawInterface();


    if     tool = en then

    begin
      circles := DrawCircle(p,circles,historys);
        if circles[High(circles)-1].newshape then
         begin
           //WriteLn(High(dots)-2,' is circles');
           circles[High(circles)-1].newshape := false;
           historys[High(historys)] := en;
           WriteLn(High(historys),' circle has been added.');
           SetLength(historys,Length(historys)+1);
         end;
    end

    else if tool = rectangle then
    begin
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
        dots := DrowDot(p,dots,historys);
         if dots[High(dots)-2].newshape then
         begin
           //WriteLn(High(dots)-2,' is pen');
           dots[High(dots)-2].newshape := false;
           historys[High(historys)] := pen;
           //WriteLn(High(historys),' pen has been added.');
           SetLength(historys,High(historys)+2);
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


    //WriteLn('tool is ',tool);
    RefreshScreen(100);
  until WindowCloseRequested();

WriteLn(high(historys));
Delay(10000);

end;

begin
  Main();
end.
