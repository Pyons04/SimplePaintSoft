program GameMain;
uses SwinGame,sgTypes;

procedure Main();
var
   mouse_X: Single;
   mouse_Y: Single;
  p: Panel;
  p2: Panel;
begin
    OpenGraphicsWindow('Read Text To Screen' ,800 ,600 );
    p := LoadPanel('newpanel.txt' );
    p2 := LoadPanel('dialogpanel.txt' );
    GUISetActiveTextbox('r');
    repeat
     LoadFont('arial', 30);
     ClearScreen(ColorWhite);
     GUISetBackgroundColor(ColorWhite);

     mouse_X := MouseX();
     mouse_Y := MouseY();

     DrawFramerate(0,0);
     ShowPanel(p);
     ShowPanelDialog(p2);
     ActivatePanel(p2);
     DrawInterface();

        FillRectangle(ColorGreen ,80 ,0 ,40,40);
        ProcessEvents();
        RefreshScreen(100);
        ProcessEvents();
    until  MouseClicked(LeftButton) and (mouse_X >= 80) and (mouse_X <= 120) and (mouse_Y >= 0) and (mouse_Y <= 40) or WindowCloseRequested();
   //WriteLn(TextBoxText(p2, myTextBox));
    //WriteLn(EndReadingText());
    WriteLn(TextBoxText(p2, 'myTextBox'));

    ReleaseAllResources();
end;

begin
    Main();
end.