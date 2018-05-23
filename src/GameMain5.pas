program GameMain;
uses SwinGame, sgTypes;

type

 Shape = record
    x: Single;
    y: Single;
    width: Single;
    hight: Single;
    dragging: boolean;
 end;

ShapesType= array of Shape;




function DrawShape(var p:panel; shapes:ShapesType):ShapesType;

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
      end;
    end;
    //SetLength(dots, High(dots)+2);
   result := shapes;
end;


procedure Save(var shapes:ShapesType);
var
 myFile  : TextFile;
 i       : Integer;
 begin
 AssignFile(myFile, 'picture2.dat');
 Erase(myFile);
 ReWrite (myFile);
 WriteLn('Now Saving ...');
for i := Low(shapes) to High(shapes) do
  begin
   WriteLn(myFile, shapes[i].x:3:2);
   WriteLn(myFile, shapes[i].y:3:2);
   WriteLn(myFile, shapes[i].width:3:2);
   WriteLn(myFile, shapes[i].hight:3:2);
  end;
//AssignFile(myFile, 'picture.dat');
WriteLn(myFile,-1);
WriteLn('Save finished!');
CloseFile(myFile);
end;


function Read(var shapes:ShapesType):ShapesType;
var
 myFile  : TextFile;
 dotNumber       : Integer;
 i : Integer;
 check : String;
 xLocal :Single;
 yLocal :Single;
 widthLocal :Single;
 hightLocal :Single;
 begin
 i := 0;
 AssignFile(myFile, 'picture2.dat');
 Reset(myFile);
 WriteLn('Loading!');

 repeat
   SetLength(shapes, i+1);
   readLn(myFile, xLocal);
   if xLocal <> -1 then
    begin
     shapes[i].x := xLocal;
     readLn(myFile, yLocal);
     shapes[i].y := yLocal;
     readLn(myFile, widthLocal);
     shapes[i].width := widthLocal;
     readLn(myFile, hightLocal);
     shapes[i].hight := hightLocal;
    end;
    i := i+1;
 until xLocal = -1;
CloseFile(myFile);
result := shapes;
end;


function Menu(var shapes:ShapesType): ShapesType;
  var
     mouse_X: Single;
     mouse_Y: Single;
begin
     FillRectangle(ColorGrey ,0 ,0 ,40,40);
     FillRectangle(ColorGreen ,0 ,40 ,40,40);
     mouse_X := MouseX();
     mouse_Y := MouseY();
if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=0 ) and (mouse_Y <=  40) then
       begin
          Save(shapes);
          result := shapes;
       end
else if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=40 ) and (mouse_Y <=  80) then
       begin
          //WriteLn('TEST');
          result := Read(shapes);
       end;
end;



procedure Main();
  var
    p: Panel;
    shapes :ShapesType;
    i :Integer;
    castWidth :Integer;
    castHight :Integer;

begin
  OpenGraphicsWindow('Pintor', 800, 600);
  p := LoadPanel('newpanel.txt' );
  SetLength(shapes, 1);
  repeat // The game loop...
    ProcessEvents();
    ClearScreen(ColorWhite);
    GUISetBackgroundColor(ColorWhite);
    DrawFramerate(0,0);
    ShowPanel(p);
    DrawInterface();
    shapes := DrawShape(p,shapes);


    for  i := Low(shapes) to High(shapes) do
     begin
       if (shapes[i].width > 0) and  (shapes[i].hight > 0) then
         castWidth := round(shapes[i].width);
         castHight := round(shapes[i].hight);
         FillRectangle(ColorBlue, shapes[i].x,shapes[i].y ,castWidth,castHight);
         castWidth := 0;
         castHight := 0;
     end;

    Menu(shapes);
    RefreshScreen(100);
  until WindowCloseRequested();
end;

begin
  Main();
end.
