// originally written by William Cairns - http://www.cairnsgames.co.za
// http://www.pascalgamedevelopment.com/forums/profile.php?mode=viewprofile&u=65
// Enchanchements, additional code by Jernej L.
// http://www.gtatools.com
// please note that the path returned is REVERSED.
// Modified by Jordi Coll

unit astar;

interface

uses windows, dialogs, sysutils;

type
    AstarRec = packed record
        point: Tpoint;
        weight: integer;
    end;

    PInspectBlock = function(X, Y, Fx, Fy: integer): integer;

var
    Searching, Found: Boolean;
    Astack: array of AstarRec;
    Source, Goal: Tpoint;
    freedom: integer;

    CanGo: PInspectBlock;
    GRID: array of array of integer;
    GridDimensions: Tpoint;
    maxval: integer;
    patherror: boolean;
    Path: array of Tpoint;
    closestpoint: AstarRec;
    IsClosest: boolean;

    Offsets: array[0..7] of
    record
        DX, DY: Integer;
        Cost: Integer;
    end =
        ((DX: 0; DY: - 1; Cost: 10), //90° neighbour cubes
        (DX: - 1; DY: 0; Cost: 10),
        (DX: + 1; DY: 0; Cost: 10),
        (DX: 0; DY: + 1; Cost: 10),
        (DX: - 1; DY: - 1; Cost: 14), //45° diagonals
        (DX: + 1; DY: - 1; Cost: 14),
        (DX: - 1; DY: + 1; Cost: 14),
        (DX: + 1; DY: + 1; Cost: 14));

procedure FindPath(const src, dest, Gridsize: Tpoint; const diagonals, pleasefallback: boolean; const grabcallback: PInspectBlock);

implementation

procedure InspectBlock(X, Y: Integer);
var
    I: Integer;
    W: Integer;
    AX, AY, AW, ABV: Integer;
begin
    if (x = Source.x) and (y = Source.y) then
        W := 0
    else
        W := GRID[x, y];
    for I := 0 to freedom do
    begin
        AX := X + Offsets[I].DX;
        AY := Y + Offsets[I].DY;
        if (AX = Goal.X) and (AY = Goal.Y) then
        begin
            Found := True;
            Exit;
        end;

        if (AX >= 0) and
            (AY >= 0) and
            (AX <= GridDimensions.x - 1) and
            (AY <= GridDimensions.y - 1) = false then
            continue;

        if (ax = Source.x) and (ay = Source.y) then
            continue;
        if GRID[AX, AY] <> 0 then
            continue;

        ABV := CanGo(AX, AY, X, Y);
        AW := W + Offsets[I].Cost + ABV;

        if (ABV <> -1) then
        begin
            if ABV = 0 then
            begin
                Found := false;
                Searching := false;
                Exit;
            end;

            GRID[AX, AY] := AW;
            if aw > maxval then
                maxval := aw;

            if (ABS(Goal.X - AX) + ABS(Goal.Y - AY)) < closestpoint.weight then
            begin
                closestpoint.point.x := ax;
                closestpoint.point.y := ay;
                closestpoint.weight := (ABS(Goal.X - AX) + ABS(Goal.Y - AY));
            end;

            setlength(Astack, length(Astack) + 1);
            with Astack[length(Astack) - 1] do
            begin
                point.x := ax;
                point.y := ay;
                weight := aw;
            end;

        end;
    end;
end;

procedure Step;
var
    I, LC, X, Y: Integer;
begin
    if Found then
        Exit;
    if not Searching then
    begin
        InspectBlock(Source.X, Source.Y);
        Searching := True;
    end
    else
    begin
        if high(astack) = -1 then
        begin patherror := true;
            exit;
        end;
        LC := 0;
        for i := 0 to length(Astack) - 1 do
        begin
            if astack[i].weight < astack[LC].weight then
                LC := i;
        end;
        X := Astack[LC].point.x;
        Y := Astack[LC].point.y;
        move(astack[LC + 1], astack[LC], (length(Astack) - 1 - LC) * sizeof(AstarRec));
        setlength(Astack, length(Astack) - 1);
        InspectBlock(X, Y);
    end;
end;

procedure CalcBestPath;
var
    lowest: Tpoint;
    lowvalue: integer;
    finished: boolean;
    function findbestprev(pt: Tpoint): Tpoint;
    var
        i, ax, ay: integer;
    begin
        for I := 0 to freedom do
        begin
            AX := pt.X + Offsets[I].DX;
            AY := pt.Y + Offsets[I].DY;
            if (AX < 0) or
                (AY < 0) or
                (AX > GridDimensions.x - 1) or
                (AY > GridDimensions.y - 1) then
                continue;
            if (AX = source.X) and (AY = source.Y) then
            begin
                finished := True;
                Exit;
            end;
            if GRID[AX, AY] > 0 then
            begin
                if GRID[AX, AY] < lowvalue then
                begin
                    lowvalue := GRID[AX, AY];
                    lowest.x := ax;
                    lowest.y := ay;
                end;

            end;
        end;
    end;
begin
    if Found = false then
        exit;
    finished := false;
    lowvalue := maxint;
    lowest := Goal;
    repeat
        findbestprev(lowest);
        if not finished then
        begin
            setlength(Path, length(path) + 1);
            Path[length(path) - 1] := lowest;
        end;
    until (finished);
end;

procedure LookForPath;
begin
    repeat step;
    until (found = true) or (patherror = true);
end;

procedure FindPath(const src, dest, Gridsize: Tpoint; const diagonals, pleasefallback: boolean; const grabcallback: PInspectBlock);
begin
    Source := src;
    Goal := dest;
    freedom := 3;
    if diagonals then
        freedom := 7;

    CanGo := grabcallback;
    GridDimensions := Gridsize;
    Searching := false;
    Found := false;
    patherror := false;
    closestpoint.weight := maxint;
    IsClosest := false;
    setlength(Astack, 0);
    setlength(Path, 0);
    setlength(GRID, 0, 0);
    setlength(GRID, gridsize.x, gridsize.y);
    LookForPath;
    if (patherror = true) and (pleasefallback = true) then
    begin
        Goal := closestpoint.point;
        Searching := false;
        Found := false;
        patherror := false;
        closestpoint.weight := maxint;
        setlength(GRID, 0, 0);
        setlength(GRID, gridsize.x, gridsize.y);
        setlength(Path, length(path) + 1);
        Path[length(path) - 1] := closestpoint.point;
        LookForPath;
        CalcBestPath;
        IsClosest := true;
    end
    else if patherror = false then
        CalcBestPath;
end;

end.
