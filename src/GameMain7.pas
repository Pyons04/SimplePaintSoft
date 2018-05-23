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

objects = (circle, dot, shape);

history = array of objects;

function DrawCircle(var p:panel; circles:CirclesType):CirclesType;

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
      end;
    end;
    //SetLength(dots, High(dots)+2);
   result := circles;
end;


// function SaveDialog(p2: Panel):String;
// var 
//   //fileNameFromInput: String;
//   mouse_X: Single;
//   mouse_Y: Single;
//   //enter: KeyCode;
// begin
//      repeat
//         ProcessEvents();
//         ClearScreen(ColorWhite);
//         GUISetBackgroundColor(ColorWhite);
//         DrawFramerate(0,0);
//         ShowPanel(p2);
//         DrawInterface();
//         mouse_X := MouseX();
//         mouse_Y := MouseY();

//         FillRectangle(ColorGreen ,200 ,0 ,40,40);
//         ProcessEvents();
//         //ClearScreen(ColorWhite );
//         if NOT ReadingText() then
//             StartReadingText(ColorRed ,40 ,LoadFont('Arial' ,12 )  ,10 ,10 );
//         RefreshScreen(100);
//         ProcessEvents();
//         //if WindowCloseRequested() then
//           // exit;
//     until MouseClicked(LeftButton) and (mouse_X >= 200) and (mouse_X <= 240) and (mouse_Y >= 0) and (mouse_Y <= 40);//or WindowCloseRequested();

//     result := EndReadingText();
//     HidePanel(p2);
// end;

// procedure Save(var shapes:ShapesType; p2:Panel);
// var
//  myFile  : TextFile;
//  i       : Integer;
//  nameOfFile: String;
//  fileNameFromDialog: String;
//  castHight :Integer;
//  castWidth :Integer;
//  begin
//  fileNameFromDialog := SaveDialog(p2);
//  //ChangeScreenSize(740,600);
// ChangeScreenSize(300,600);
// ClearScreen(ColorWhite);
// GUISetBackgroundColor(ColorWhite);
// for  i := Low(shapes) to High(shapes) do
//      begin
//        if (shapes[i].width > 0) and  (shapes[i].hight > 0) then
//          castWidth := round(shapes[i].width);
//          castHight := round(shapes[i].hight);
//          FillRectangle(ColorBlue, shapes[i].x,shapes[i].y ,castWidth,castHight);
//          castWidth := 0;
//          castHight := 0;
//      end;
// UpdateInterface();
// TakeScreenshot(fileNameFromDialog);
// ChangeScreenSize(800,600);
// //nameOfFile := 'picture3';
// //SaveBitmap(CreateBitmap(nameOfFile,800,600), 'picture3.bmp');
// end;

// function ReadDialog(p2: Panel):String;
// var 
//   //fileNameFromInput: String;
//   mouse_X: Single;
//   mouse_Y: Single;
//   //enter: KeyCode;
// begin
//      repeat
//         ProcessEvents();
//         ClearScreen(ColorWhite);
//         GUISetBackgroundColor(ColorWhite);
//         DrawFramerate(0,0);
//         ShowPanel(p2);
//         DrawInterface();
//         mouse_X := MouseX();
//         mouse_Y := MouseY();

//         FillRectangle(ColorGreen ,200 ,0 ,40,40);
//         ProcessEvents();
//         //ClearScreen(ColorWhite );
//         if NOT ReadingText() then
//             StartReadingText(ColorRed ,40 ,LoadFont('Arial' ,12 )  ,10 ,10 );
//         RefreshScreen(100);
//         ProcessEvents();
//         //if WindowCloseRequested() then
//           // exit;
//     until MouseClicked(LeftButton) and (mouse_X >= 200) and (mouse_X <= 240) and (mouse_Y >= 0) and (mouse_Y <= 40);//or WindowCloseRequested();

//     result := EndReadingText();
//     HidePanel(p2);
// end;


// function Read(var shapes:ShapesType; p2:Panel):ShapesType;
// var
//  myFile  : TextFile;
//  dotNumber       : Integer;
//  i : Integer;
//  check : String;
//  xLocal :Single;
//  yLocal :Single;
//  widthLocal :Single;
//  hightLocal :Single;
//  fileNameFromDialog: String;
//  begin
//  i := 0;
//  fileNameFromDialog := ReadDialog(p2);//take name of file from  dialog.

//  //if FileExists(fileNameFromDialog) then
//     //WriteLn('FileExist!');
//  AssignFile(myFile, fileNameFromDialog);
//  Reset(myFile);
//  WriteLn('Loading!');

//  repeat
//    SetLength(shapes, i+1);
//    readLn(myFile, xLocal);
//    if xLocal <> -1 then
//     begin
//      shapes[i].x := xLocal;
//      readLn(myFile, yLocal);
//      shapes[i].y := yLocal;
//      readLn(myFile, widthLocal);
//      shapes[i].width := widthLocal;
//      readLn(myFile, hightLocal);
//      shapes[i].hight := hightLocal;
//     end;
//     i := i+1;
//  until xLocal = -1;
// CloseFile(myFile);
// result := shapes;
// end;


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
    i :Integer;
    castRadius :Integer;

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

    circles := DrawCircle(p,circles);


    for  i := Low(circles) to High(circles) do
     begin
       if (circles[i].centerX > 0) and  (circles[i].centerY > 0) then
         castRadius := round(circles[i].radius);
         FillCircle(ColorBlue, circles[i].centerX, circles[i].centerY, castRadius);
         castRadius := 0;
     end;

    //Menu(shapes,p,p2);
    RefreshScreen(100);
  until WindowCloseRequested();
end;

begin
  Main();
end.
