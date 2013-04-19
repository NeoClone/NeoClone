unit map;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Addresses;

type
  TMap = class
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

  end;

implementation

uses
  unit1;

function TMap.tileToAddress( index: integer; address: integer ): integer;// sprawdzi�
var
  addr: integer;
begin
  result := address + ( addresses.mapStepTile * index );
end;

function TMap.tileToAddress( index: integer ): integer;// sprawdzi�
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


end.