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
  mouse_X := MouseX();
  mouse_Y := MouseY();
  if IsDragging(p) and (mouse_X >= 20) and (mouse_Y >= 40) then
    begin
      i := High(dots);
      WriteLn('i',i);
      FillCircle(ColorRed, mouse_X, mouse_Y, 5);
      dots[i].x := mouse_X;
      dots[i].y := mouse_Y;
      SetLength(dots, High(dots)+2);
      WriteLn('highdots',High(dots));

      if i <> 0 then
      DrawLine(ColorRed, dots[i-1].x, dots[i-1].y,dots[i].x,dots[i].y);

    end;
    //SetLength(dots, High(dots)+2);
   result := dots;
end;


procedure Save(var dots:DotsType);
var
 myFile  : TextFile;
 dotNumber: Integer;
 i       : Integer;
 begin
 AssignFile(myFile, 'picture.dat');
 Erase(myFile);
 ReWrite (myFile);
 Write('Now Saving ... The number of dots is :',High(dots));
 dotNumber := High(dots);
 WriteLn(myFile, dotNumber);//the number of dots in this file
for i := Low(dots) to High(dots) do
  begin
   WriteLn(myFile, dots[i].x:3:2);
   WriteLn(myFile, dots[i].y:3:2);
  end;
end;


function Read(var dots:DotsType):DotsType;
var
 myFile  : TextFile;
 dotNumber       : Integer;
 i : Integer;
 begin
 i := 0;
 AssignFile(myFile, 'picture.dat');
 Reset(myFile);
 readLn(myFile, dotNumber);//the number of dots in this file.
repeat
   WriteLn('NowLoading.',i);
   SetLength(dots, i+1);
   readLn(myFile, dots[i].x);
   readLn(myFile, dots[i].y);
   i := i+1;
 until i = dotNumber;

result := dots;
end;


function Menu(var dots:DotsType): DotsType;
  var
     mouse_X: Single;
     mouse_Y: Single;
begin
     //FillRectangle(ColorGrey ,0 ,0 ,40,40);
     //FillRectangle(ColorGreen ,0 ,40 ,40,40);
     mouse_X := MouseX();
     mouse_Y := MouseY();
if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=0 ) and (mouse_Y <=  40) then
       begin
          Save(dots);
          result := dots;
       end
else if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=40 ) and (mouse_Y <=  80) then
       begin
          result := Read(dots);
       end;
end;



procedure Main();
  var
    p: Panel;
    dot :DotType;
    dots :DotsType;
    i :Integer;
    castStartX :Integer;
    castStartY :Integer;
    castEndX :Integer;
    castEndY :Integer;
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

       if (dots[i].x <> 0) and (dots[i].y <> 0) then
        begin
         FillCircle(ColorRed, dots[i].x, dots[i].y , 5);
           if i <> 0 then
             DrawThickLine(ColorRed, dots[i-1].x, dots[i-1].y, dots[i].x, dots[i].y, 10);
        end;
     end;

    Menu(dots);
    RefreshScreen(100);
  until WindowCloseRequested();
end;

begin
  Main();
end.
