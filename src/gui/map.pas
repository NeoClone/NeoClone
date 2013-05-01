unit map;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Addresses, datReader, Xml.VerySimple, log, settingsFormUnit,
  Math, Player;

type

  TMap = class

    GameMap: array[0..7,0..13,0..$11] of TTileMap;

  public

    function tileToAddress( index: integer; address: integer ): integer; overload;
    function tileToAddress( index: integer ): integer; overload;

    function getTile( index: integer; address: integer = 0 ): TTile; overload;
    function getTile( location: TLocation ): TTile; overload;
    function getTileFromAddress( address: integer ): TTile;

    function getPlayerTile( address: integer = 0 ): TTile;

    function tileTopItem( tile: TTile ): TItem;

    function tileToLocal( index: integer ): TLocation;
    function tileToGlobal( Tile: TTile; playerTile: TTile ): TLocation;

    function globalToLocal( loc: TLocation ): TLocation;
    function localToGlobal( loc: TLocation ): TLocation;
    function toTileNumber( local: TLocation ): integer;

    procedure Update;
    function TileGround(X: Integer; Y: Integer; Z: Integer; update: boolean= true): TTileMap;
    function TopTileItem(X: Integer; Y: Integer; Z: Integer; update: boolean=true): Integer;
    function IsWalkeable(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
    function IsTrapped(update: boolean= true): boolean;
    function IsShootable(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
    function IsPassable(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
    function IsItemOnTile(ID: Integer; X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
    function IsForceUse(X: Integer; Y: Integer; Z: Integer): boolean;
    function IsCreatureOnTile(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
    function FindTilePlayer(): Integer;
  end;

var
playerMapIndex: integer=0;
  tree: TsettingsForm;
//strArray: self.manager_0.Cavebot.WalkableIds.Split(New(array[1] of Char, ( ( ';' );

implementation

uses
  unit1;

function TMap.tileToAddress( index: integer; address: integer ): integer;// sprawdziæ
var
  addr: integer;
begin
  result := address + ( addresses.mapStepTile * index );
end;

function TMap.tileToAddress( index: integer ): integer;// sprawdziæ
var
  addr: integer;
begin
  addr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.mapPointer );

  result := addr + ( addresses.mapStepTile * index );
end;

function TMap.getTile( index: integer; address: integer = 0 ): TTile;
var
  addr, addr2, i: integer;
begin
  if address = 0 then
    addr := tileToAddress( index )
  else
    addr := tileToAddress( index, address );

  result.itemCount := Memory.ReadInteger( addr + addresses.mapTileObjectCount );
  addr2 := addr + addresses.mapTileOrder;

  for i := 0 to result.itemCount - 1 do
  begin
    result.order[i] := Memory.ReadInteger( addr2 );
    addr2 := addr2 + addresses.mapTileOrderStep;
  end;

  addr := addr + addresses.mapTileObjects;
  for i := 0 to result.itemCount - 1 do
  begin

    result.items[i].id := Memory.ReadInteger( addr + addresses.mapTileObjectsId );
    result.items[i].data := Memory.ReadInteger( addr + addresses.mapTileObjectsData );
    result.items[i].dataEx := Memory.ReadInteger( addr + addresses.mapTileObjectsDataEx );

    addr := addr + addresses.mapStepTileObject;
  end;

end;

function TMap.getTile( location: TLocation ): TTile;
var
  local: TLocation;
  num, minFloor, maxFloor, i: integer;
  playerTile: TTile;
begin
  local := globalToLocal( location );
  num := toTileNumber( local );
  playerTile := getPlayerTile();

  minFloor := 0;
  maxFloor := 0;
                            
  for i := 0 to 7 do
  begin
    if ( playerTile.index >= Addresses.mapMaxTiles * i ) and
       ( playerTile.index <= Addresses.mapMaxTiles * (i + 1) )then
    begin
      minFloor := Addresses.mapMaxTiles * i;
      maxFloor := Addresses.mapMaxTiles * (i + 1) - 1;
      break
    end;
  end;
  if (num > maxFloor) then
    num := num - maxFloor + minFloor - 1
  else 
  if (num < minFloor) then 
    num := maxFloor - minFloor + num + 1;
    
  result := GetTile( num );
end;

function TMap.getTileFromAddress( address: integer ): TTile;
var
  addr, addr2, i: integer;
begin
  addr := address;

  result.itemCount := Memory.ReadInteger( addr + addresses.mapTileObjectCount );

  addr2 := addr + addresses.mapTileOrder;

  for i := 0 to result.itemCount - 1 do
  begin
    result.order[i] := Memory.ReadInteger( addr2 );
    addr2 := addr2 + addresses.mapTileOrderStep;
  end;
  
  addr := addr + addresses.mapTileObjects;
  for i := 0 to result.itemCount - 1 do
  begin

    result.items[i].id := Memory.ReadInteger( addr + addresses.mapTileObjectsId );
    result.items[i].data := Memory.ReadInteger( addr + addresses.mapTileObjectsData );
    result.items[i].dataEx := Memory.ReadInteger( addr + addresses.mapTileObjectsDataEx );

    addr := addr + addresses.mapStepTileObject;
  end;

end;

function TMap.getPlayerTile( address: integer = 0 ): TTile;
var
  i,j, playerId: integer;
  t: TTile;
begin
  if address = 0 then
    address := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.mapPointer );

  playerId := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.selfId );

  for i := 0 to addresses.mapMaxTiles-1 do
  begin
    t := getTile( i, address );

    if t.itemCount > 0 then
    begin
      for j := 0 to t.itemCount - 1 do
      begin
        if (t.items[j].id = $63) and (t.items[j].data = playerId) then
        begin
          result := t;
          result.index := i;
          result.global := GUI.Player.getLocation();
          result.local := TileToLocal( i );
          break;
        end;
      end;
    end;
  end;

end;

function TMap.tileTopItem( tile: TTile ): TItem;
var
  i: Integer;
  bStack, bIndex: integer;
begin
  bStack := -1;
  bIndex := -1;
  for i := 0 to tile.itemCount-1 do
  begin
    if bStack < tile.order[i] then
    begin
      bStack := tile.order[i];
      bIndex := i;
    end;
  end;

  result.id := tile.items[bIndex].id;
  result.count := tile.items[bIndex].data;
end;

function TMap.tileToLocal( index: integer ): TLocation;
begin
  result.z := round(index / (14 * 18));
  result.y := round((index - result.z * 14 * 18) / 18);
  result.x := round((index - result.z * 14 * 18) - result.y * 18);
end;

function TMap.tileToGlobal( Tile: TTile; playerTile: TTile ): TLocation; // what the, what the..?
var
  loc: TLocation;
  playerMemLoc, playerGloLoc: TLocation;
  diffX, diffY, maxX, maxY: integer;
begin

  loc := Tile.local;
  playerMemLoc := playerTile.local;

  diffX := 8 - playerMemLoc.x;
  diffY := 6 - playerMemLoc.y;
  loc.x := loc.x + diffX;
  loc.y := loc.y + diffY;

  maxY := addresses.mapMaxY - 1;
  maxX := addresses.mapMaxX;

  if loc.x > maxX then
  begin
    loc.x := loc.x - addresses.mapMaxX;
    loc.y := loc.y + 1;
  end else
  if loc.x < 0 then
  begin
    loc.x := loc.x + addresses.mapMaxX;
    loc.y := loc.y - 1;
  end else
  if loc.y > maxY then
  begin
    loc.y := loc.y - addresses.mapMaxY;
  end else
  if loc.y < 0 then
  begin
    loc.y := loc.y + addresses.mapMaxY;
  end;

  playerGloLoc := playerTile.global;

  result.x := playerGloLoc.x + ( loc.x - 8 );
  result.y := playerGloLoc.y + ( loc.y - 6 );
  result.z := playerGloLoc.z + ( loc.z - playerMemLoc.z );

end;

function TMap.globalToLocal( loc: TLocation ): TLocation;
var
  playerLoc: TLocation;
  zz, PlayerZPlane: integer;
begin
  playerLoc := GUI.Player.getLocation();

  if playerLoc.z <= GROUND_LAYER then
  begin
    PlayerZPlane := ( MAPSIZE_Z - 1 ) - playerLoc.z;
  end
  else
  begin
    PlayerZPlane := UNDERGROUND_LAYER;
  end;

  zz := playerLoc.z - loc.z;
  result.x := loc.x - (playerLoc.x - 8) - zz;
  result.y := loc.y - (playerLoc.y - 6) - zz;
  result.z := PlayerZPlane + zz;
end;

function TMap.localToGlobal( loc: TLocation ): TLocation;
var
  playerLoc: TLocation;
  zz, PlayerZPlane: integer;
begin
  playerLoc := GUI.Player.getLocation();

  if playerLoc.z <= GROUND_LAYER then
  begin
    PlayerZPlane := ( MAPSIZE_Z - 1 ) - playerLoc.z;
  end
  else
  begin
    PlayerZPlane := UNDERGROUND_LAYER;
  end;

  zz := loc.z - PlayerZPlane;
  result.x := loc.x + (playerLoc.x - 8) + zz;
  result.y := loc.y + (playerLoc.y - 6) + zz;
  result.z := playerLoc.z - zz;
end;

function TMap.toTileNumber( local: TLocation ): integer;
begin
  result := local.x + local.y * 18 + local.z * 14 * 18;
end;

              //this is from Ibot

procedure TMap.Update;
var
iD, num2,i,j,k,m,num7,num8: integer;
buffer: Tbytes;
stri: string;
begin               try
  map.playerMapIndex:=0;
  FillChar(GameMap,SizeOf(GameMap),0);    //we reset the array
    iD := gui.Player.ID;
    num2 := ((Memory.ReadInteger(Integer(ADDR_BASE) + addresses.mapStart)) - 4);
    i := 0;
    while ((i < 8)) do
    begin
        buffer := Memory.Readbytes((num2 + (((i * 14) * $12) * $a8)), $a560);
//        for i := 0 to $a560 do
//               showmessage(inttostr( buffer[$2c + (num8 * addresses.mapStep)]));
        Sleep(1);
        j := 0;
        while ((j < 14)) do
        begin
            k := 0;
            while ((k < $12)) do
            begin
                num8 := ((j * $12) + k);
                GameMap[i, j, k].Id := PlongWord(@(buffer[addresses.distMapID + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Count := PlongInt(@(buffer[addresses.distMapCount + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order1 := PlongInt(@(buffer[(0*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order2 := PlongInt(@(buffer[(1*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order3 := PlongInt(@(buffer[(2*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order4 := PlongInt(@(buffer[(3*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order5 := PlongInt(@(buffer[(4*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order6 := PlongInt(@(buffer[(5*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order7 := PlongInt(@(buffer[(6*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order8 := PlongInt(@(buffer[(7*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order9 := PlongInt(@(buffer[(8*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                GameMap[i, j, k].Order10 := PlongInt(@(buffer[(9*4 + addresses.distMapOrder) + (num8 * addresses.mapStep)]))^;
                num7 := (($2c + (num8 * addresses.mapStep)) + 4);
                m := 0;            //if there aren't any more items stop, or the cache will trick us!!! ;]
                while ((m < 10) and (m < GameMap[i, j, k].Count)) do
                begin
                    GameMap[i, j, k].Items[m].Index := m;
                    GameMap[i, j, k].Items[m].Volume := PlongInt(@(buffer[(addresses.distMapItemVolume + num7) + (m * 12)]))^;
                    GameMap[i, j, k].Items[m].Count := PlongInt(@(buffer[(addresses.distMapItemCount + num7) + (m * 12)]))^;
                    GameMap[i, j, k].Items[m].ID := PlongInt(@(buffer[(addresses.distMapItemID + num7) + (m * 12)]))^;
                                            //first ID= ground(and unmovable items above it)/ next ID= creatures/ then all items
                    if ((m < GameMap[i, j, k].Count) and ((GameMap[i, j, k].Items[m].ID = $63) and (GameMap[i, j, k].Items[m].Count = iD))) then
                        begin
                        map.playerMapIndex := ((((i * 14) * $12) + (j * $12)) + k);
                        end;
                    inc(m)
                end;
                inc(k)
            end;
            inc(j)
        end;
        inc(i)
    end
    except
        on exception: Exception do
          begin
            stri := 'Gui:Map:Update ';
            log.AddLog(colorRed,Concat(stri, ' - ', exception.ToString),true);
          end;
    end;
end;

function TMap.TileGround(X: Integer; Y: Integer; Z: Integer; update: boolean= true): TTileMap;
var
num,num1,num2,num3,num4,num5,num6,num7,num8,num9,num10:integer;
Tile: TTileMap;
begin
    if (update) then
    begin
        Gui.Map.Update;
        Sleep(1)
    end;                           //252
    num7 := (map.playerMapIndex div $fc);
    num4 := ((map.playerMapIndex - ((num7 * 14) * $12)) div $12);
    num6 := ((map.playerMapIndex - ((num7 * 14) * $12)) - (num4 * $12));
    num8 := (Y - Gui.Player.getLocation.y);
    num9 := (X - Gui.Player.getLocation.x);
    num1 := (((map.playerMapIndex + ((0 * 14) * $12)) + (num8 * $12)) + num9);
    num2 := num7;
    num3 := 0;
    num := 0;
    num5 := (Y - Gui.Player.getLocation.y);
    num10 := (X - Gui.Player.getLocation.x);
    num := (num6 + num10);
    if (num < 0) then
        num := ($12 + num)
    else
        if (num > $11) then
            dec(num, $12);
        if (num = $11) then
            ;
        if (num6 = $11) then
            ;
        inc(num3, (num4 + num5));
        if (num3 > 13) then
            dec(num3, 14);
        if (num3 < 0) then
            num3 := (14 + num3);
        if (((num2 >= 0) and (num3 >= 0)) and (num >= 0)) then
            Tile := Gui.Map.GameMap[num2, num3, num];
        begin
            Result := Tile;
            exit
        end
    end;

function TMap.TopTileItem(X: Integer; Y: Integer; Z: Integer; update: boolean=true): Integer;
var
j,i: integer;
XMap: TTileMap;
begin
    Xmap := Gui.Map.TileGround(X, Y, Z, update);

  i:= 0 ;
  j:= Xmap.Items[i].Id;

while j<>0 do
begin   //this is to get those items which alter ID order (check map.update--> Items.ID)
  if (not (getItem(j, TopOrder1).Flag or getItem(j, TopOrder2).Flag or getItem(j, TopOrder3).Flag))
      and (j <> $63)   //if there is a creature
      and (not getItem(j, IsImmovable).Flag) then //if item is always there (ground, map items, etc)
      begin
       result:= Xmap.Items[i].Id;
       exit;    //we got our item, now end the function
      end
  else
      begin
        inc(i);
        j:= Xmap.Items[i].Id;
        z:= 0;
      end;
end;
result:= z;
end;

function TMap.IsWalkeable(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
var
flag, flag3, isUnpassable, isAvoid: boolean;
Xmap: TTileMap;
i,j, item1: integer;
begin
settingsForm.getWalkableIds; //we get the WalkableIDs from list

    flag := true;
    Xmap := Gui.Map.TileGround(X, Y, Z, update);
    if (Xmap.Count = 0) then
        begin
            Result := false;
            exit
        end;
    i := 1; //first item, not floor
    while ((i < Xmap.Count)) do
    begin
        item1 := Xmap.Items[i].ID;
        isUnpassable := getItem(item1, Blocking).Flag; //isUnpassable
        isAvoid := getItem(item1, BlocksPath).Flag;   //isAvoid
        flag3 := ((Xmap.Items[i].ID = $63) and (Xmap.Items[i].Count <> Gui.Player.ID));

        if (isUnpassable or flag3) then
            begin
                Result := false;
                exit
            end;
        if (isAvoid) then
        begin
          j := 0;
              flag:= false;  //we reset this for the avoidable or not
          while (j < (strArray.Count)) do
          begin
                  //checking if is in the list...
            if (Xmap.Items[i].ID = strtoint(strArray[j])) then
              begin
                flag := true;
                break;
              end;
              inc(j)
          end;
            
          if flag = false then   //if we didn't found our ID in the walkableIDs...
          begin
              Result := false;
              exit
          end; 
        end;     //end of not isAvoid

        inc(i)
    end;  //end of while (number of items on tile)
    
    begin
        Result := flag;
        exit
    end
end;

function TMap.IsTrapped(update: boolean= true): boolean;
var
flag,flag4,flag6, isUnpassable, isAvoid: boolean;
num,num2,zPos,i,j,k,item1,m: integer;
Xmap: TTileMap;
begin
    flag := true;
    num := (Gui.Player.getLocation.X - 1);
    num2 := (Gui.Player.getLocation.Y - 1);
    zPos := Gui.Player.getLocation.Z;

    if (update) then
        Gui.Map.Update;

    settingsForm.getWalkableIds; //we get the WalkableIDs from list

    i := 0;
    while ((i < 3)) do
    begin
        j := 0;
        while ((j < 3)) do
        begin
            Xmap := Gui.Map.TileGround((num + i), (num2 + j), zPos, false);
            flag4 := false;
            if (Xmap.Count = 0) then
                flag4 := true;
            k := 0;
            while ((k < Xmap.Count)) do
            begin
                item1 := Xmap.Items[k].ID;

                isUnpassable := getItem(item1, Blocking).Flag;
                isAvoid := getItem(item1, BlocksPath).Flag;
                flag6 := ((Xmap.Items[k].ID = $63) and (Xmap.Items[k].Count <> Gui.Player.ID));
                                   //we should add here the IsPassable()
                if (isUnpassable or flag6) then
                begin
                    flag4 := true;
                    break;
                end;

                if (isAvoid) then
                begin
                    flag4 := true;
                    m := 0;
                    while (m < strArray.Count) do  // count = length
                    begin
                        if (Xmap.Items[k].ID = strtoint(strArray[m])) then
                            flag4 := false;
                        inc(m)
                    end
                end;
                inc(k)
            end;

            if (((i <> 1) or (j <> 1)) and not flag4) then
            begin
                flag := false;
                begin
                    Result := false;
                    exit
                end
            end;
            inc(j)
        end;
        inc(i)
    end;
    begin
        Result := flag;
        exit
    end
end;

function TMap.IsShootable(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
var
flag: boolean;
max: double;
XDistance,XSign,num5,YDistance,YSign,num8,num9,num10,zPos,i,j,item1: integer;
Xmap: TTileMap;
begin

    if (X > Gui.Player.getLocation.X) then
    XSign:= 1 else XSign:= -1;
    if (Y > Gui.Player.getLocation.Y) then
    YSign:= 1 else YSign:= -1;
    XDistance := Abs(X - Gui.Player.getLocation.X);
    YDistance := Abs(Y - Gui.Player.getLocation.Y);
    max := Sqrt(Sqr(XDistance) + Sqr(YDistance));
    if (((XDistance > 8) or (YDistance > 5)) or (Z <> Gui.Player.getLocation.Z)) then
        begin
            Result := false;
            exit
        end;
    if (update) then
    begin
        Gui.Map.Update;
        Sleep(1)
    end;
    i := 1;
    while (i <= max) do
    begin
        num5 := Ceil((i * XDistance) / max) * XSign;  //div
        num8 := Ceil((i * YDistance) / max) * YSign;  //div
        num9 := (Gui.Player.getLocation.X + num5);
        num10 := (Gui.Player.getLocation.Y + num8);
        zPos := Gui.Player.getLocation.Z;
        Xmap := Gui.Map.TileGround(num9, num10, zPos, false);
        if (Xmap.Count = 0) then
            begin
                Result := false;
                exit
            end;
        j := 0;
        while ((j < Xmap.Count)) do
        begin
            item1:= Xmap.Items[j].ID;
            if getItem(item1, BlocksMissiles).Flag then //isUnsight
            begin
                    Result := false;
                    exit
            end;
            inc(j)
        end;
        inc(i)
    end;
    begin
        Result := true;
        exit
    end
end;

function TMap.IsPassable(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
var
Xmap: TTileMap;
i, item1,item1_C: integer;
flag4, flag5, isUnpassable: boolean;
begin
    Xmap := Gui.Map.TileGround(X, Y, Z, update);
    if (Xmap.Count = 0) then
        begin
            Result := false;
            exit
        end;
    i := 0;
    while ((i < Xmap.Count)) do
    begin
        item1:= Xmap.Items[i].ID;
        item1_C:= Xmap.Items[i].Count;
        isUnpassable := getItem(item1, Blocking).Flag;
        flag4 := ((item1 = $63) and (item1_C <> Gui.Player.ID)); //if there is a creature the Item.Count is its ID

        if (Gui.Player.CheckFlag(WithinProtectionZone) or (tree.getsetting('Cavebot/Pathfinding/WalkThroughPlayers') = 'yes')) then
        begin
          if flag4 = True then            //is the same as "not flag4"?
            flag4:= False else flag4:= True   //     ^  I think it should be "flag4:= false"
        end
        else flag5:= true;
                                        // type= monster? idk.. xD
//        if ((not  flag5) and (Gui.Battlelist.Creature(item1_C).Type <> $40)) then
//            flag4 := false;          //we will uncomment this once we have the Battlelist
        if (isUnpassable or flag4) then
            begin
                Result := false;
                exit
            end;
        inc(i)
    end;
    begin
        Result := true;
        exit
    end
end;

function TMap.IsItemOnTile(ID: Integer; X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
var
Xmap: TTileMap;
Count,i: integer;
begin
    Xmap := Gui.Map.TileGround(X, Y, Z, update);
    Count := Xmap.Count;
    i := 0;
    while ((i < Count)) do
    begin
        if ((Xmap.Items[i].ID = ID) and (Xmap.Items[i].Count <> Gui.Player.ID)) then
            begin
                Result := true;
                exit
            end;
        inc(i)
    end;
    begin
        Result := false;
        exit
    end
end;
                      //for Corpses (looter) I suppose
function TMap.IsForceUse(X: Integer; Y: Integer; Z: Integer): boolean;
var
Xmap: TTileMap;
i, item1: integer;
isForceUse, issContainer: boolean;
begin
    Xmap := Gui.Map.TileGround(X, Y, Z, false);
    i := 0;
    while ((i < Xmap.Count)) do
    begin
        item1 := Xmap.Items[i].ID;
        isForceUse := getItem(item1, IsCorpse).Flag;
        issContainer := getItem(item1, IsContainer).Flag;
        if (not (not isForceUse or issContainer)) then  //isForceUse and not(isContainer), right?
            begin
                Result := true;
                exit
            end;
        inc(i)
    end;
    begin
        Result := false;
        exit
    end
end;

function TMap.IsCreatureOnTile(X: Integer; Y: Integer; Z: Integer; update: boolean= true): boolean;
var
Xmap: TTileMap;
Count,i: integer;
begin
    Xmap := Gui.Map.TileGround(X, Y, Z, update);
    Count := Xmap.Count;
    i := 0;
    while ((i < Count)) do
    begin
        if (Xmap.Items[i].ID = $63) then
            begin
                Result := true;
                exit
            end;
        inc(i)
    end;
    begin
        Result := false;
        exit
    end
end;

function TMap.FindTilePlayer(): Integer;
var
iD, i,j,k,Count,m: integer;
begin

  if not gui.Player.OnLine then exit;
      //not needed gui.map.update? then how do we fill the array?
    iD := Gui.Player.ID;
    i := 0;
    while ((i < 8)) do
    begin
        j := 0;
        while ((j < 14)) do
        begin
            k := 0;
            while ((k < $12)) do
            begin   //I think we need  "Xmap := Gui.Map.TileGround(X, Y, Z, update);"
                count := Gui.Map.GameMap[i, j, k].Count;
                if (count <= 10) then
                    m := 0;
                    while ((m < count)) do
                    begin
                        if ((Gui.Map.GameMap[i, j, k].Items[m].ID = $63) and (Gui.Map.GameMap[i, j, k].Items[m].Count = iD)) then
                            begin
                                Result := ((((i * 14) * $12) + (j * $12)) + k);
                                exit
                            end;
                        inc(m)
                    end;
                inc(k)
            end;
            inc(j)
        end;
        inc(i)
    end;
    begin
        Result := -1;
        exit
    end
end;


end.
                                              {$IFDEF True}
                //all of this is comented until {$ENDIF}

                public static bool IsShootable(this Location location, Client client)
{
    int XSign = (location.X > client.PlayerLocation.X) ? 1 : -1 ;
    int YSign = (location.Y > client.PlayerLocation.Y) ? 1 : -1;
    double XDistance = Math.Abs(location.X - client.PlayerLocation.X);
    double YDistance = Math.Abs(location.Y - client.PlayerLocation.Y);
    double max = location.Distance();
    Location check;

    // This checks if location is on viewable screen, someone might to remove that for some reason
    if (Math.Abs(XDistance) > 8 || Math.Abs(YDistance) > 5)
    {
        return false;
    }

    for (int i = 1; i <= max; i++)
    {
        check = client.PlayerLocation.Offset((int)Math.Ceiling(i * XDistance / max) * XSign, (int)Math.Ceiling(i * YDistance / max) * YSign, 0);
        Tile tile = client.Map.GetTile(check);

        if (tile != null)
        {
            if (tile.Ground.GetFlag(Tibia.Addresses.DatItem.Flag.BlocksMissiles))
            {
                return false;
            }

            Item item = tile.Items.FirstOrDefault(tileItem => tileItem.GetFlag(Tibia.Addresses.DatItem.Flag.BlocksMissiles));

            if (item != null)
            {
                return false;
            }
        }
    }

    return true;
}

------------------------------------------------------------------------------------------
bool Map::checkSightLine(const Position& fromPos, const Position& toPos) const
{
        Position start = fromPos;
        Position end = toPos;

        int32_t x, y, z;
        int32_t dx, dy, dz;
        int32_t sx, sy, sz;
        int32_t ey, ez;

        dx = abs(start.x - end.x);
        dy = abs(start.y - end.y);
        dz = abs(start.z - end.z);

        int32_t max = dx, dir = 0;
        if(dy > max)
        {
                max = dy;
                dir = 1;
        }

        if(dz > max)
        {
                max = dz;
                dir = 2;
        }

        switch(dir)
        {
                case 1:
                        //x -> y
                        //y -> x
                        //z -> z
                        std::swap(start.x, start.y);
                        std::swap(end.x, end.y);
                        std::swap(dx, dy);
                        break;
                case 2:
                        //x -> z
                        //y -> y
                        //z -> x
                        std::swap(start.x, start.z);
                        std::swap(end.x, end.z);
                        std::swap(dx, dz);
                        break;
                default:
                        //x -> x
                        //y -> y
                        //z -> z
                        break;
        }

        sx = ((start.x < end.x) ? 1 : -1);
        sy = ((start.y < end.y) ? 1 : -1);
        sz = ((start.z < end.z) ? 1 : -1);

        ey = ez = 0;
        x = start.x;
        y = start.y;
        z = start.z;

        int32_t lastrx = x, lastry = y, lastrz = z;
        for(; x != end.x + sx; x += sx)
        {
                int32_t rx, ry, rz;
                switch(dir)
                {
                        case 1:
                                rx = y; ry = x; rz = z;
                                break;
                        case 2:
                                rx = z; ry = y; rz = x;
                                break;
                        default:
                                rx = x; ry = y; rz = z;
                                break;
                }

                if(!(toPos.x == rx && toPos.y == ry && toPos.z == rz) && !(fromPos.x == rx && fromPos.y == ry && fromPos.z == rz))
                {
                        if(lastrz != rz && const_cast<Map*>(this)->getTile(lastrx, lastry, std::min(lastrz, rz)))
                                return false;

                        lastrx = rx; lastry = ry; lastrz = rz;
                        const Tile* tile = const_cast<Map*>(this)->getTile(rx, ry, rz);
                        if(tile && tile->hasProperty(BLOCKPROJECTILE))
                                return false;
                }

                ey += dy;
                ez += dz;
                if(2 * ey >= dx)
                {
                        y  += sy;
                        ey -= dx;
                }

                if(2 * ez >= dx)
                {
                        z  += sz;
                        ez -= dx;
                }
        }

        return true;
}
                        //end of commented section
                            {$ENDIF}
