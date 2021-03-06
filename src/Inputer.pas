unit Inputer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

    procedure SendKeyDown(Key: Integer);
    procedure SendKeyUp(Key: Integer);

    procedure SendKey(Key: Integer);

    procedure SendKeyChar(Key: Integer);

    procedure SendClick(X, Y: Integer);
    procedure SendClickPoint(Point: TPoint);

    procedure SendRClick(X, Y: Integer);
    procedure SendRClickPoint(Point: TPoint);

    procedure SendScrollUp(X, Y: Integer);

    procedure SendDrag(BaseX, BaseY, TargetX, TargetY: Integer);
    procedure SendDragPoint(BasePoint, TargetPoint: TPoint);

    procedure SendString(Data: String);

implementation

uses
  unit1;

procedure SendKeyDown(Key: Integer);
begin
  PostMessage( Main.THand, WM_KEYDOWN, Key, 0 );
end;

procedure SendKeyUp(Key: Integer);
begin
  PostMessage( Main.THand, WM_KEYUP, Key, 0 );
end;

procedure SendKey(Key: Integer);
begin
  PostMessage( Main.THand, WM_KEYDOWN, Key, 0 );
end;

procedure SendKeyChar(Key: Integer);
begin
  PostMessage( Main.THand, WM_CHAR, Key, 0 );
end;

procedure SendClick(X, Y: Integer);
begin
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( Main.THand, WM_LBUTTONDOWN, 0, MakeLParam(X, Y) );
  //sleep(50);
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(X, Y) );
end;

procedure SendClickPoint(Point: TPoint);
begin

  //  if Main.Thand.WindowState then


  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  //GUI.SetCursorClient(point.X,point.Y);
  PostMessage( Main.THand, WM_LBUTTONDOWN, 0, MakeLParam(Point.X, Point.Y) );
  //sleep(50);
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(Point.X, Point.Y) );
end;

procedure SendRClick(X, Y: Integer);
begin
  PostMessage( Main.THand, WM_RBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( Main.THand, WM_RBUTTONDOWN, 0, MakeLParam(X, Y) );
  //sleep(50);
  PostMessage( Main.THand, WM_RBUTTONUP, 0, MakeLParam(X, Y) );
end;

procedure SendRClickPoint(Point: TPoint);
begin
  PostMessage( Main.THand, WM_RBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( Main.THand, WM_RBUTTONDOWN, 0, MakeLParam(Point.X, Point.Y) );
  //sleep(50);
  PostMessage( Main.THand, WM_RBUTTONUP, 0, MakeLParam(Point.X, Point.Y) );
end;

procedure SendScrollUp(X, Y: Integer);
begin
  gui.SetCursorClient(x,y);
 // WM_MOUSEHOVER
  PostMessage( Main.THand, WM_MOUSEHOVER, 0, MakeLParam(X, Y) );
  PostMessage( Main.THand, WM_MOUSEMOVE, 0, MakeLParam(x, y) );
  PostMessage( Main.THand, WM_MOUSEWHEEL, WHEEL_DELTA, MakeLParam(X, Y) );
end;

procedure SendString(Data: String);
var
  I: Integer;
begin
  for I := 0 to Length(Data) do
  begin
    SendKeyChar(Integer(Data[I]));
    sleep(50);
  end;
end;

procedure SendDrag(BaseX, BaseY, TargetX, TargetY: Integer);
begin
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( Main.THand, WM_LBUTTONDOWN, 0, MakeLParam(BaseX, BaseY) );
  //sleep(200);
  PostMessage( Main.THand, WM_MOUSEMOVE, 0, MakeLParam(BaseX, BaseY) );
  //sleep(200);
  PostMessage( Main.THand, WM_MOUSEMOVE, 0, MakeLParam(TargetX, TargetY) );
  //sleep(200);
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(TargetX, TargetY) );
  //sleep(200);
end;

procedure SendDragPoint(BasePoint, TargetPoint: TPoint);
begin
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(0, 0) );

  PostMessage( Main.THand, WM_LBUTTONDOWN, 0, MakeLParam(BasePoint.X, BasePoint.Y) );
  //sleep(200);
  PostMessage( Main.THand, WM_MOUSEMOVE, 0, MakeLParam(BasePoint.X, BasePoint.Y) );
  //sleep(200);
  PostMessage( Main.THand, WM_MOUSEMOVE, 0, MakeLParam(TargetPoint.X, TargetPoint.Y) );
  //sleep(200);
  PostMessage( Main.THand, WM_LBUTTONUP, 0, MakeLParam(TargetPoint.X, TargetPoint.Y) );
  //sleep(200);
end;

end.
