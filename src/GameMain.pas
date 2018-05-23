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
    //SetLength(dots, High(dots)+2);
   result := dots;
end;


procedure Save(var dots:DotsType);
var
 myFile  : TextFile;
 i       : Integer;
 begin
 AssignFile(myFile, 'picture.dat');
 Erase(myFile);
 ReWrite (myFile);
 WriteLn(myFile, High(dots));//the number of dots in this file
for i := Low(dots) to High(dots) do
  begin
   WriteLn(myFile, dots[i].x:2:2);
   WriteLn(myFile, dots[i].y:2:2);
  end;
  WriteLn(myFile, 'end');
  TakeScreenshot('Shot.bmp');
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
while i = dotNumber do
  begin
   readLn(myFile, dots[i].x);
   readLn(myFile, dots[i].y);
   i := i+1;
  end;

result := dots;
end;


procedure Menu(var dots:DotsType);
  var
     mouse_X: Single;
     mouse_Y: Single;
begin
     mouse_X := MouseX();
     mouse_Y := MouseY();
if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=0 ) and (mouse_Y <=  40) then
       begin
          Save(dots);
       end
else if MouseClicked(LeftButton) and (mouse_X >= 0) and (mouse_X <= 40) and (mouse_Y >=40 ) and (mouse_Y <=  80) then
       begin
          Read(dots);
       end;
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
     FillRectangle(ColorGrey ,0 ,0 ,40,40);
     FillRectangle(ColorGreen ,0 ,40 ,40,40);
     
    Menu(dots);
    RefreshScreen(100);
  until WindowCloseRequested();
end;

begin
  Main();
end.
