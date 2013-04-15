unit uAStar;

interface

{uses SysUtils, Windows, Classes, Math, Addresses;

type
  TPosition = record
    X, Y, Z: integer;
  end;

function AStar(TX, TY: integer): boolean;
function AStarFree: boolean;
function AStarDone: boolean;
function AStarNext: TPosition;    }

implementation
                                   {

type

  TasState = (asFree, asBusy, asDone);
  PasPoint = ^TasPoint;
  TasPoint = record
    X: integer;
    Y: integer;
    Score: integer;
    Parent: integer;
    Index: integer;
  end;

var

  Doneps, Openps: array of TasPoint;
  AStarState: TasState = asFree;
  Dx, Dy: integer;
  Steps: array of TPosition;
  Step: integer;

function GetPosition( x,y,z: integer): TPosition;
begin
  result.X := x;
  result.Y := y;
  result.Z := z;
end;

function AStarNext: TPosition;
begin
  if Step <= High(Steps) then
    Result := Steps[Step]
  else
    Result := GetPosition(0, 0, 0);
  Inc(Step);
end;

function AStarFree: boolean;
begin
  Result := (AStarState = asFree) or (AStarState = asDone);
end;

function AStarDone: boolean;
begin
  Result := AStarState = asDone;
end;

procedure AddOpen(Parent: integer; X, Y, Score: integer);
  function ScoreDist(X1, Y1, X2, Y2: integer): integer;
  begin
    Result := Round(SQRT(Power(X1-X2, 2) + Power(Y1-Y2, 2)));
  end;
var
  Map: TTile;
  I: integer;
  RScore: integer;
begin
  if High(Doneps) <> -1 then
    for I := 0 to High(Doneps) do
      if (Doneps[I].X = X) and (Doneps[I].Y = Y) then
        Exit;
  RScore := (ScoreDist(Dx, Dy, X, Y) * 10) + Score;
  if High(Openps) <> -1 then
    for I := 0 to High(Openps) do
      if (Openps[I].X = X) and (Openps[I].Y = Y) then
      begin
        if Openps[I].Score > RScore then
        begin
          Openps[I].Score := RScore;
          Openps[I].Parent := Parent;
        end;
        Exit;
      end;
  if not Me.CanSee(GetPosition(X, Y, Me.Z)) then
    Exit;
  Map := Tile;
  try
    if Map.Jump(X, Y, Me.Z) then
      if Map.CanWalk or ((X = Me.X) and (Y = Me.Y)) then
      begin
        SetLength(Openps, High(Openps)+2);
        Openps[High(Openps)].X := X;
        Openps[High(Openps)].Y := Y;
        Openps[High(Openps)].Score := RScore;
        Openps[High(Openps)].Parent := Parent;
      end;
  finally
    Map.Free;
  end;
end;

function AddDone(Parent: integer; X, Y, Score: integer): PasPoint;
begin
  SetLength(Doneps, High(Doneps)+2);
  Doneps[High(Doneps)].X := X;
  Doneps[High(Doneps)].Y := Y;
  Doneps[High(Doneps)].Score := Score;
  Doneps[High(Doneps)].Parent := Parent;
  Doneps[High(Doneps)].Index := High(Doneps);
  Result := @Doneps[High(Doneps)];
end;

procedure RemoveOpen(X, Y, Score: integer);
var
  I: integer;
begin
  if High(Openps) = -1 then
    Exit;
  for I := High(Openps) downto 0 do
    if (Openps[I].X = X) and (Openps[I].Y = Y) and (Openps[I].Score = Score) then
    begin
      Openps[I].Parent := Openps[High(Openps)].Parent;
      Openps[I].X := Openps[High(Openps)].X;
      Openps[I].Y := Openps[High(Openps)].Y;
      Openps[I].Score := Openps[High(Openps)].Score;
      SetLength(Openps, High(Openps));
    end;
end;

procedure AStarFinish(Point: integer);
begin

  try
    SetLength(Steps, High(Steps)+2);
    Steps[High(Steps)] := GetPosition(Doneps[Point].X, Doneps[Point].Y, Me.Z);
  except
    SetLength(Steps, High(Steps));
    Exit;
  end;

  if Doneps[Point].Score = -1 then
    Exit;

  if not InRange(Doneps[Point].Parent, 0, High(Doneps)) then
    Exit;

  AStarFinish(Doneps[Point].Parent);

end;

procedure CheckNode(Point: PasPoint);
  procedure BestNode;
  var
    Best: PasPoint;
    BestInit: TasPoint;
    Ret: PasPoint;
    I: integer;
  begin
    if High(Openps) = -1 then
    begin
      AStarState := asFree;
      Exit;
    end;
    BestInit.Score := MaxInt;
    Best := @BestInit;
    for I := 0 to High(Openps) do
      if Openps[I].Score < Best.Score then
        Best := @Openps[I];
    if Best.Score < MaxInt then
    begin
      Ret := AddDone(Best.Parent, Best.X, Best.Y, Best.Score);
      RemoveOpen(Best.X, Best.Y, Best.Score);
      CheckNode(Ret);
    end;
  end;
  procedure OpenNodes(Point: PasPoint);
  var
    X, Y: integer;
  begin
    for X := -1 to 1 do
      for Y := -1 to 1 do
        if (X <> 0) and (Y <> 0) then
          AddOpen(Point.Index, Point.X + X, Point.Y + Y, 30)
        else
          AddOpen(Point.Index, Point.X + X, Point.Y + Y, 10);
  end;
begin
  if (Point.X = Dx) and (Point.Y = Dy) then
  begin
    Step := 0;
    SetLength(Steps, 0);
    AStarFinish(Point.Index);
    AStarState := asDone;
  end else begin
    OpenNodes(Point);
    BestNode;
  end;
end;

function AStar(TX, TY: integer): boolean;
begin

  AStarState := asBusy;

  Result := False;

  if not Me.CanSee(GetPosition(TX, TY, Me.z)) then
  begin
    AStarState := asFree;
    Exit;
  end;

  Dx := TX;
  Dy := TY;

  SetLength(Openps, 0);
  SetLength(Doneps, 0);
  SetLength(Steps, 0);

  CheckNode(AddDone(0, Me.X, Me.Y, -1));

  Result := True;
  if AStarState = asBusy then
    AStarState := asFree;

end;
                }
end.
