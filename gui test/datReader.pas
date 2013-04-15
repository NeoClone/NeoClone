unit datReader;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, addresses;



type  //there are more in TibiaAPI-->https://code.google.com/p/tibiaapi/source/browse/branches/tibiaapi-current/tags/tibiaapi-971/tibiaapi/Addresses/DatItemAddresses.cs
  TFlag = (None = 0, IsGround = 1, TopOrder1 = 2, TopOrder2 = 4, TopOrder3 = 8,
    IsContainer = 16, IsStackable = 32, IsCorpse = 64, IsUsable = 128,
    IsWritable = 256, IsReadable = 512, IsFluidContainer = 1024,
    IsSplash = 2048, Blocking = 4096, IsImmovable = 8192,
    BlocksMissiles = 16384, BlocksPath = 32768, IsPickupable = 65536,
    IsHangable = 131072, IsHangableHorizontal = 262144,
    IsHangableVertical = 524288, IsRotatable = 1048576,
    IsLightSource = 2097152, Floorchange = 4194304, IsShifted = 8388608,
    HasHeight = 16777216, IsLayer = 33554432, IsIdleAnimation = 67108864,
    HasAutoMapColor = 134217728, HasHelpLens = 268435456, Unknown = 536870912,
    IgnoreStackpos = 1073741824);

type
  Item= record
    Flag: boolean;
    Name: string;
    end;

function DatAdress(id: integer): integer;
function getItem(id: integer; Flaag: TFlag= None): Item;
//procedure loadTibiaDat(filename: string);             ¨
implementation

uses
  Unit1;

function DatAdress(id: integer): integer;
var
  base, datadr: integer;
begin
  base := Memory.ReadInteger(Integer(ADDR_BASE) +  Addresses.DatPointer);
  datadr := Memory.ReadInteger(base + 8);
  datadr := datadr + Addresses.StepItems * (id - 100);
  result := datadr
end;

function getItem(id: integer; Flaag: TFlag= None): Item;
var
  adr: integer;
  flags: longword;
begin
//Flaag:= IsStackable;
  adr := DatAdress(id);
  result.Name := Memory.ReadString(adr);
  flags := Memory.ReadInteger(adr + addresses.FlagsOffset);
  If (flags and integer(Flaag) <> 0) Then
    result.Flag:= True
  else
    result.Flag:= False
end;







                            {$IFDEF True}
                //all of this is comented until {$ENDIF}
procedure loadTibiaDat(filename: string);
var
  f: File;
  index: integer;
  tmpI, i, ID_OFFSET: integer;
  w, nItems, nCreatures, nEffects, nMissile, nCount: word;
  b, optByte, optbyte2: byte;
  lWidth, lHeight, lBlendframes, lXdiv, lYdiv, lAnimcount, lRare, skipcount: integer;
  tmpName: string;
begin

  ID_OFFSET := 99;

  AssignFile(f, filename);
  Reset(f, 1);

  BlockRead(f, i, 4);
  BlockRead(f, nItems, 2);
  BlockRead(f, nCreatures, 2);
  BlockRead(f, nEffects, 2);
  BlockRead(f, nMissile, 2);

  nCount := nItems + nCreatures + nEffects + nMissile;

  setlength( DatTiles, nCount );

  for index := 0 to nCount do
  begin
    DatTiles[index].isContainer := false;
    DatTiles[index].RWInfo := 0;
    DatTiles[index].fluidContainer := false;
    DatTiles[index].stackable := false;
    DatTiles[index].multiType := false;
    DatTiles[index].useable := false;
    DatTiles[index].notMoveable := false;
    DatTiles[index].alwaysOnTop := false;
    DatTiles[index].groundTile := false;
    DatTiles[index].blocking := false;
    DatTiles[index].blockPickupable := false;
    DatTiles[index].pickupable := false;
    DatTiles[index].blockingProjectile := false;
    DatTiles[index].canWalkThrough := false;
    DatTiles[index].noFloorChange := false;
    DatTiles[index].isDoor := false;
    DatTiles[index].isDoorWithLock := false;
    DatTiles[index].speed := 0;
    DatTiles[index].canDecay := false;
    DatTiles[index].haveExtraByte := false;
    DatTiles[index].haveExtraByte2 := false;
    DatTiles[index].totalExtraBytes := 0;
    DatTiles[index].isWater := false;
    DatTiles[index].stackPriority := 0;
    DatTiles[index].haveFish := false;
    DatTiles[index].floorChangeUP := false;
    DatTiles[index].floorChangeDOWN := false;
    DatTiles[index].requireRightClick := false;
    DatTiles[index].requireRope := false;
    DatTiles[index].requireShovel := false;
    DatTiles[index].isFood := false;
    DatTiles[index].isField := false;
    DatTiles[index].isDepot := false;
    DatTiles[index].moreAlwaysOnTop := false;
    DatTiles[index].usable2 := false;
    DatTiles[index].multiCharge := false;
    DatTiles[index].haveName := false;
    DatTiles[index].itemName := '';
  end;

  DatTiles[0].stackPriority := 0;
  DatTiles[97].stackPriority := 2;
  DatTiles[98].stackPriority := 2;
  DatTiles[99].stackPriority := 2;
  DatTiles[97].blocking := true;
  DatTiles[98].blocking := true;
  DatTiles[99].blocking := true;

  index := 100;

  repeat
    // read next byte
    BlockRead(f, optByte, 1);

    while (optByte <> $FF) and not eof(f) do
    begin

      case optByte of

        $00:
          begin
            DatTiles[index].groundTile := true;

            // read speed
            BlockRead(f, b, 1);
            DatTiles[index].speed := b;

            // if speed is 0 then blocking
            if b = 0 then
              DatTiles[index].blocking := true;

            // ignore next byte
            BlockRead(f, b, 1);
          end;

        $01: DatTiles[index].moreAlwaysOnTop := true;
        $02: DatTiles[index].alwaysOnTop := true;
        $03:
          begin
            DatTiles[index].canWalkThrough := true;
            DatTiles[index].alwaysOnTop := true;
          end;

        $04: DatTiles[index].isContainer := true;
        $05: DatTiles[index].stackable := true;
        $06: DatTiles[index].useable := true;
        $07: DatTiles[index].usable2 := true;
        $08:
          begin
            DatTiles[index].RWInfo := 3;
            BlockRead(f, b, 1); // max characters that can be written in it (0 unlimited)
            BlockRead(f, b, 1); // max number of  newlines ? 0, 2, 4, 7
          end;

        $09:
          begin
            DatTiles[index].RWInfo := 1;
            BlockRead(f, b, 1); // max characters that can be written in it (0 unlimited)
            BlockRead(f, b, 1); // always 4 max number of  newlines ?
          end;

        $0A: DatTiles[index].fluidContainer := true;
        $0B: DatTiles[index].multiType := true;
        $0C: DatTiles[index].blocking := true;
        $0D: DatTiles[index].notMoveable := true;
        $0E: DatTiles[index].blockingProjectile := true;
        $0F: ;// ignored
        $10: DatTiles[index].pickupable := true;
        $15:
          begin
            BlockRead(f, b, 1); // number of tiles around
            BlockRead(f, b, 1); // 0
            BlockRead(f, b, 1); // 215 for items , 208 for non items
            BlockRead(f, b, 1); // ??
          end;

        $11: ;// can see what is under (ladder holes, stairs holes etc)
        $1E: DatTiles[index].noFloorChange := true;
        $19:
          begin
            DatTiles[index].blockPickupable := false;
            BlockRead(f, b, 1); // always 8
            BlockRead(f, b, 1); // always 0
          end;

        $14: ; // unknown
        $18: BlockRead(f, i, 4); // dunno
        $1C: BlockRead(f, w, 2); // 2 bytes for colour (b and b)
        $17: DatTiles[index].floorChangeDOWN := true;
        $1A: DatTiles[index].canDecay := false;
        $1B: ;// wall items
        $12: ;// action possible
        $13: ;// walls 2 types of them same material (total 4 pairs)

        $1D:
          begin
            // line spot ...
            BlockRead(f, optbyte2, 1);
            case optbyte2 of
              $4C:
                begin
                  DatTiles[index].floorChangeUP := true;
                  DatTiles[index].requireRightClick := true;
                end;
              $4D: DatTiles[index].requireRightClick := true;
              $4E:
                begin
                  DatTiles[index].floorChangeUP := true;
                  DatTiles[index].requireRope := true;
                end;
              $4F: ;// switch
              $50: DatTiles[index].isDoor := true;
              $51: DatTiles[index].isDoorWithLock := true;
              $52: DatTiles[index].floorChangeUP := true;
              $53: DatTiles[index].isDepot := true;
              $55: ;// trash
              $56:
                begin
                  DatTiles[index].floorChangeDOWN := true;
                  DatTiles[index].requireShovel := true;
                  DatTiles[index].alwaysOnTop := true;
                  DatTiles[index].multiType := false;
                end;
              $57: ; // items with special description?
              $58: DatTiles[index].RWInfo := 1; // read only
            end;
            BlockRead(f, b, 1);
          end;

        $1F: ;// new flag since 8.57
        $20:
          begin
            BlockRead(f, w, 2); // unknown meaning
          end;

        $16: ;// new flag since tibia 8.57
        $21: // item group, something, and name (tibia 9.4)
          begin
            BlockRead(f, b, 1); // group 1
            BlockRead(f, b, 1); // group 2
            BlockRead(f, b, 1); // unknown meaning
            BlockRead(f, b, 1); // unknown meaning
            BlockRead(f, b, 1); // unknown meaning
            BlockRead(f, b, 1); // unknown meaning

            BlockRead(f, w, 2); // length of text
            for tmpI := 1 to w do
            begin
              BlockRead(f, b, 1);
              tmpName := tmpName + chr(b);
            end;

            DatTiles[index].haveName := true;
            DatTiles[index].itemName := tmpName;

            BlockRead(f, b, 1); // unknown meaning
            BlockRead(f, b, 1); // unknown meaning
            BlockRead(f, b, 1); // unknown meaning
            BlockRead(f, b, 1); // unknown meaning
          end;
      end; // end case

      BlockRead(f, optByte, 1); // next byte
    end; // end while

    if DatTiles[index].stackable or DatTiles[index].multiType or
       DatTiles[index].fluidContainer then
    begin
      DatTiles[index].haveExtraByte := true;
    end;

    if DatTiles[index].multiCharge then
    begin
      DatTiles[index].haveExtraByte := true;
    end;

    if DatTiles[index].alwaysOnTop then
    begin
      DatTiles[index].stackPriority := 3;
    end;

    if DatTiles[index].moreAlwaysOnTop then
    begin
      DatTiles[index].alwaysOnTop := true;
      DatTiles[index].stackPriority := 4;
    end;


    // cogido el resto de vb Blackdproxy, habra que convertirlo
    {
    ' add special cases of floor changers, for cavebot
    Select Case i
    ' ramps that change floor when you step in
    Case tileID_rampToNorth, tileID_rampToSouth, tileID_rampToRightCycMountain, _
     tileID_rampToLeftCycMountain, tileID_rampToNorth, tileID_desertRamptoUp, _
     tileID_jungleStairsToNorth, tileID_jungleStairsToLeft
      DatTiles(i).floorChangeUP = True
    Case tileID_grassCouldBeHole ' grass that will turn into a hole when you step in
      DatTiles(i).floorChangeDOWN = True
    End Select

    '[CUSTOM FLAGS FOR BLACKDPROXY]
    'water, for smart autofisher
    If i = tileID_waterWithFish Then
      DatTiles(i).isWater = True
      DatTiles(i).haveFish = True
    End If
    If i = tileID_waterEmpty Then
      DatTiles(i).isWater = True
    End If
    If TibiaVersionLong >= 781 Then
        If i = tileID_blockingBox Then
            DatTiles(i).blocking = True
        End If
    End If

    If TibiaVersionLong >= 760 Then

    If (i >= tileID_waterWithFish) And (i <= tileID_waterWithFishEnd) Then
      DatTiles(i).isWater = True
      DatTiles(i).haveFish = True
    End If
    If (i >= tileID_waterEmpty) And (i <= tileID_waterEmptyEnd) Then
      DatTiles(i).isWater = True
    End If

    End If
    ' food, for autoeater
    If i >= tileID_firstFoodTileID And i <= tileID_lastFoodTileID Then
      DatTiles(i).isFood = True
    End If
    If (i >= tileID_firstMushroomTileID) And (i <= tileID_lastMushroomTileID) Then
      DatTiles(i).isFood = True
    End If

    Select Case i ' special food
    Case &HA9, &H344, &H349, &H385, &HCB2, &H13E8, &H162E, &H1885, &H1886, &H18F8, &H18F9, &H18F9, &H18F9, &H1964, &H198D, &H198E, &H198F, &H1990, &H1991, &H19A9, &H19AE, &H1BF6, &H1BF7, &H1CCC, &H1CCD
      DatTiles(i).isFood = True
    End Select

    If (i >= 8010) And (i <= 8020) Then ' special food
      DatTiles(i).isFood = True
    End If


    ' fields, for a* smart path
    If i >= tileID_firstFieldRangeStart And i <= tileID_firstFieldRangeEnd Then
      DatTiles(i).isField = True
    End If
    If (i >= tileID_secondFieldRangeStart) And (i <= tileID_secondFieldRangeEnd) Then
      DatTiles(i).isField = True
    End If
    Select Case i
    Case tileID_campFire1, tileID_campFire2
      DatTiles(i).isField = True
    Case tileID_walkableFire1, tileID_walkableFire2, tileID_walkableFire3
      DatTiles(i).isField = False 'dont consider fields that doesnt do any harm
    End Select
    If i = tileID_woodenStairstoUp Then 'special stairs
      DatTiles(i).floorChangeUP = True
    End If
    If i = tileID_WallBugItem Then 'bug on walls, cant pick it!
      DatTiles(i).pickupable = False
    End If
    '[/CUSTOM FLAGS FOR BLACKDPROXY]
    }

    BlockRead(f, b, 1);
    lWidth := b;

    BlockRead(f, b, 1);
    lHeight := b;

    if (lWidth > 1) or (lHeight > 1) then
    begin
      // skip 1 byte
      BlockRead(f, b, 1);
    end;

    BlockRead(f, b, 1);
    lBlendframes := b;

    BlockRead(f, b, 1);
    lXdiv := b;

    BlockRead(f, b, 1);
    lYdiv := b;

    BlockRead(f, b, 1);
    lAnimcount := b;

    BlockRead(f, b, 1);
    lRare := b;

    if lRare > $1 then
    begin
      DatTiles[index].haveExtraByte2 := true;
    end;
    DatTiles[index].totalExtraBytes := 0;

    if DatTiles[index].haveExtraByte then
      inc(DatTiles[index].totalExtraBytes);

    if DatTiles[index].haveExtraByte2 then
      inc(DatTiles[index].totalExtraBytes);


    skipcount := (lWidth * lHeight * lBlendframes * lXdiv * lYdiv * lAnimcount * lRare * 2);

    for tmpI := 1 to skipcount do
    begin
      BlockRead(f, b, 2);  //Read 2 bytes T9.83, not 1 as T9.44 version
    end;

    index := index + 1;


  until ( Eof(f) );

  CloseFile(f);

end;
                        //end of commented section
                            {$ENDIF}
end.
