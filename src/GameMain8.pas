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
end;

CirclesType = array of Circle;

DotType = record
     x: Single;
     y: Single;
  end;

DotsType= array of DotType;

Shape = record
    x: Single;
    y: Single;
    width: Single;
    hight: Single;
    dragging: boolean;
 end;

ShapesType= array of Shape;

objects = (en, dot, rectangle);
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
  if IsDragging(p) and (mouse_X >= 40) and (mouse_Y >= 80) then//incorrect
    begin
      i := High(dots);
      WriteLn('i',i);
      FillCircle(ColorRed, mouse_X, mouse_Y, 5);
      dots[i].x := mouse_X;
      dots[i].y := mouse_Y;
      SetLength(dots, High(dots)+2);
      WriteLn('highdots',High(dots));

     SetLength(historys,High(historys)+2);
     historys[High(historys)] := dot;

    end;
    //SetLength(dots, High(dots)+2);
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
       WriteLn(i, 'th circle is start drowwing from ',circles[i].startX,' x.');
       WriteLn(i, 'th circle is start drowwing from ',circles[i].startY,' y.');

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

         WriteLn('shape ',i, 'has',circles[i].radius,'radius.');

         WriteLn('shape ',i, 'has center',circles[i].centerX,'x.');
         WriteLn('shape ',i, 'has center',circles[i].centerY,'y.');
         SetLength(circles, High(circles)+2);

         SetLength(historys,High(historys)+2);
         historys[High(historys)] := en;
      end;
    end;
    //SetLength(dots, High(dots)+2);
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
  if (mouse_X >= 40) and (mouse_Y >= 80) then//incorrect
    begin
      i := High(shapes);
    if (IsDragging(p) = true) and (shapes[i].dragging = false) then
     begin
       WriteLn(i, 'th shape is start drowwing.');
       shapes[i].dragging := true;
       shapes[i].x := mouse_X;
       shapes[i].y := mouse_Y;
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
         WriteLn('shape ',i, 'has',shapes[i].width,'width.');
         WriteLn('shape ',i, 'has',shapes[i].hight,'hight.');
         WriteLn('shape ',i, 'start from',shapes[i].x,'x.');
         WriteLn('shape ',i, 'start from',shapes[i].y,'y.');
         SetLength(shapes, High(shapes)+2);

         SetLength(historys,High(historys)+2);
         historys[High(historys)] := rectangle;

      end;
    end;
    //SetLength(dots, High(dots)+2);
   result := shapes;
end;

// function Menu(var shapes:ShapesType; p:Panel; p2:Panel): ShapesType;
//   var
//      mouse_X: Single;
//      mouse_Y: Single;
// begin
//      FillRectangle(ColorGrey ,0 ,0 ,40,40);
//      FillRectangle(ColorGreen ,0 ,40 ,40,40);
//      mouse_X := MouseX();
//      mouse_Y := MouseY();
// if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=0 ) and (mouse_Y <=  40) then
//        begin
//           WriteLn('SaveClicked');
//           Save(shapes,p2);
//           result := shapes;
//        end
// else if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=40 ) and (mouse_Y <=  80) then
//        begin
//           //WriteLn('TEST');
//           //DeactivatePanel(p);

//           //HidePanel(p);
//           result := Read(shapes,p2);
//           WriteLn('ReadClicked');
//           //ShowPanel(p);
//           //ActivatePanel(p);//necessary?
//        end;
// end;



procedure Main();
  var
    p: Panel;
    //p2: Panel;
    circles :CirclesType;
    shapes :ShapesType;
    dots :DotsType;
    historys :History;

    i :Integer;
    j :Integer;
    castRadius :Integer;
    castWidth :Integer;
    castHight :Integer;

    tool: objects;


begin
  OpenGraphicsWindow('Pintor', 800, 600);
  p := LoadPanel('newpanel.txt' );
  //p2 := LoadPanel('dialogpanel.txt');
  SetLength(circles, 1);
  //CreateBitmap('picture3.bmp', 800, 600);
  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    GUISetBackgroundColor(ColorWhite);
    DrawFramerate(0,0);
    ShowPanel(p);
    DrawInterface();

    tool := en;

    if     tool = en then
      circles := DrawCircle(p,circles,historys)
    else if tool = rectangle then
      shapes := DrawShape(p,shapes,historys)
    else if tool = dot then
        dots := DrowDot(p,dots,historys);




    for  i := Low(circles) to High(circles) do
     begin
       if (circles[i].centerX > 0) and  (circles[i].centerY > 0) then
        begin
         castRadius := round(circles[i].radius);
         FillCircle(ColorBlue, circles[i].centerX, circles[i].centerY, castRadius);
         castRadius := 0;
        end;
    end;

    for j := Low(historys) to High(historys) do 
     begin
        WriteLn(j,'th number of history is', historys[j]);
     end;

    //Menu(shapes,p,p2);
    RefreshScreen(100);
  until WindowCloseRequested();
end;

begin
  Main();
end.
