unit addresses;

interface

uses
  System.SysUtils;

const
                         {
              //from insanus Bot
  LocalChat = 34655064;
  ServerLog = 34439776;
  WorldChat = 34655400;
  Advertising = 34437696;
  Help = 34671776;
  NPC = 34674672;
  PrivateM = 34675504;
               // finish from insanus bot
                          }
  // gui
  guiPointer = $3BF820; // 9.83

  {http://tpforums.org/forum/threads/5142-Reading-game-window-size-with-gui-pointer?highlight=window+height}
              ClientFirstChild = 36;
            ClientGameWindow = 48;
            ClientX = 20;
            ClientY = 24;
            ClientWidth = 28;
            ClientHeight = 32;


                                        {
  // dialog
  dialogPointer = $3AC5D0; // 9.44 // if value = 0 then "no dialog opened"  // 0x40, 0x24 - name
    contextMenuItemName = 36;
    contextMenuItemHeight = 19;
    contextMenuSeparatorHeight = 8;    }
  Dialog = $3C8FCC;            //9.85
    //12-->  Right click (also 1= left pressed; 2= right pressed)
    //11-->  normal menu        if = 11 then read Title name;
    DialogPointer = $3BF82C; // + 0x54 = name

  // containers
  ContainersAddr = $40958c; // 9.83
    ContainersStep = 492;    //9.83          // container1,container2, container3
    ContainersStepSlot = 12;  //9.83        //item1, item2,item3

	ContainersIsChild = 0;
	ContainersId = 12;
	ContainersName = 4;      //9.83
	ContainersAmout = 48;
	ContainersIsOpen = 40;       //9.83
	ContainersVolume = 56;
    ContainersItemsStart = 60;
	  ContainersItemCount = 4;
    ContainersItemId = 8;
    ContainersItemStep = 12;

	// old ??
	//ContainersIsOpen = 0;
    //ContainersId = 12;
    //ContainersName = 16;
    //ContainersVolume = 48;
    //ContainersIsChild = 52;
    //ContainersAmount = 56;
    //ContainersItemCount = 64;
    //ContainersItemId = 68;

  SlotSize = 34; // sta�e         -- constante
  SlotMargin = 3; // sta�e
  SlotXStart = 8; // sta�e
  SlotYStart = 16; // sta�e
  SlotMinOffset = 15; // moge sobie zmienic        -- Puedo cambiar el

  // players and utils
  selfConnected = $3c3e98; // 9.83 10 connected*// 0 = not connected, 8 = connected
  selfX = $58AEA8; // 9.84 // to bardzo si� zmienia...  -- Esto cambiar�a
  selfY = selfX - 4;       //9.83
  selfZ = selfX - 8;       //9.83

  selfXgo = $587EA0; // 9.83
  selfYgo = $587E98;       //9.83
  selfZgo = $550004;       //9.83

  selfXor = $3BA090; // 9.83
    selfHp = $550000; // 9.83
    selfHpMax = $587E9C; // 9.83
    selfMp = $3ba0e4; // 9.83
    selfMpMax = $3ba094; // 9.83
    selfSoul = $3BA0D0; // 9.83  blackd
    adrNameStart = $550008; // 9.83  blackd
    adrNChar = $550008; // 9.83  blackd

  selfMagic = $3ba0d4; // 9.83
  selfId = $587ea4; // 9.83 // selfID for Cupquake is 42486223 (??? always static?)
                            // selfID for Prutin      36831354

  RedSquare = $3BA0E0; // 9.83  blackd

  // character list
  charListPointer = $54CE98; // 9.83
  charListEnd = $54CE9C; // 9.83 charlistpointer + 4
  charListLength = charListPointer + $30; // can be static too   -- parece que no se usa
  charListSelectedChar = $54CF04; //9.83 //charListPointer + $80 in 9.44; // can be static too
    charListStep = 72;     //84
    charListName = 4;      //0
    charListWorld = 32;    //30

    dist_name_size=20;                     //nuevo \/
    dist_name_type=24;
    ClientSelectedCharId=0;
    ClientSelectedCharName='';
    ClientSelectedCharServer='';

    charListWorldIp = 60;
    charListWorldIpString = 64;
    charListWorldPort = 80;

  {                          blackd 9.83  (diferents con distinto formato)
adrCharListPtr=&H94CE98
adrCharListPtrEND=&H94CE9C     (mientras que antes nos daba listptr-selected=80, ahora da 108)
adrSelectedCharIndex=&H94CF04

                              blackd 9.70
adrCharListPtr=&H7BCC90
adrSelectedCharIndex=&H7BCD10
  }

  // map
  mapPointer = $5de6ac; // 9.83
    mapMaxTiles = 2016;
    mapStepTile = 168;     //9.83  //328 for 9.90?
    mapStepTileObject = 12;
    mapTileObjectCount = 0; // ok
    mapTileOrder = 4;
    mapTileOrderStep = 4;
    mapTileObjects = 48; // ok
    mapTileObjectsData = 0; // ok
    mapTileObjectsId = 4; // ok
    mapTileObjectsDataEx = 8; // ok
    mapMaxTileObjects = 10;
    mapMaxX = 18;
    mapMaxY = 14;
    mapMaxZ = 8;

  // hotkeys
  hotkeySendAutomaticallyStart = $3C8E68; // 9.84
    hotkeySendAutomaticallyStep = 1;
  hotkeyTextStart = $3C6998; // 9.84
    hotkeyTextStep = 256;
  hotkeyObjectStart = $3C8F30; // 9.84
    hotkeyObjectStep = 4;
  hotkeyObjectUseTypeStart = $3C8DC8; // 9.84
    hotkeyObjectUseTypeStep = 4;
    hotkeyMaxHotkeys = 36;

  lastChatPointer = $3F79B4; // +$14 + $48 //es posible $405ADC en 9.83?

  lastClickedId = $54F8E0;//9.83 now //53E400;

  colorRed = '#FF0000';
  colorBlack = '#000000';
  colorPurple = '#800080';

  num_trappers = 8;
  UNDERGROUND_LAYER = 2;
  GROUND_LAYER = 7;
  MAPSIZE_w = 10;
  MAPSIZE_X = 18;
  MAPSIZE_Y = 14;
  MAPSIZE_z = 8;
  MAP_MAX_Z = 15;

  FPSPointer = $58d1bc; // 9.83

  Ping = $5DB390;
                  { tibia.DAT INFO (ITEMS) }
  DatPointer = $3C68EC; //9.84
    StepItems = 136;
    FlagsOffset = 68;

 // ibot 2.0.2.6 T9.83
       auxFormPointer = $3ba6cc;   //this is the dialog of MEssage of the day, right click, etc if we sum $40 + $24
       battleListHeight = 176;    //CharDist in blackd
       battleListStart = $553008;   //9.85 same 9.84;
       charSelectNames = $54ce98;
       ChaseMode = $3c1830;
       clientTibiaTime = $5E2E78;    //9.84
       containerHeight = 492;
       containerItemHeight = 12;
       containerStart = $40958c;
       coolDownCategoryStart = $40CB54;   //9.84
       coolDownItems = coolDownCategoryStart + $10;  //9.84  //number of CD tags apart from the first 4
       coolDownItemsStart = coolDownItems - $4;
       dispMapArrayStep = 131240;
       distBattleListBlackSquare = 136;             // all of this you have to sum them
       distBattleListDirection = 56;                // battlelist_start + baseaddres + creature_offset
       distBattleListHpPerc = 140;                  // where creature_offset would be an array of i * battlelist_creature_step
       distBattleListId = 0;                        // then we have an array of all monsters (but will improve this with the 1shot-read post (tpforum)
       distBattleListLastTimeMove = 60;
       distBattleListMountId = 120;
       distBattleListStep = 176;
       distBattleListMax = 1300;
       distBattleListName = 4;
       distBattleListNext = 92;
       distBattleListOutfit = 96;
       distBattleListParty = 156;
       distBattleListPrevious = 88;
       distBattleListSkull = 152;
       distBattleListSpeed = 144;
       distBattleListType = 3;
       distBattleListVisible = 172;
       distBattleListWalking = 80;
       distBattleListWarIcon = 168;
       distBattleListYMove = 68;
       distBattleListXMove = 72;
       distBattleListDirection2 = 84;
       distBattleListX = 44;
       distBattleListY = 40;
       distBattleListZ = 36;
       distContainerID = 0;
       distContainerItemCount = 4;
       distContainerItemID = 8;
       distContainerItemVolume = 0;
       distContainerMaxSlots = 44;
       distContainerName = 4;
       distContainerOpen = 40;
       distContainerUsedSlots = 36;
       distMapArrayX = 65557;
       distMapArrayY = 65553;
       distMapArrayZ = 65548;
       distMapColor = 65536;
       distMapCount = 4;
       distMapID = 0;
       distMapItemCount = 4;
       distMapItemID = 8;
       distMapItemVolume = 0;
       distMapOrder = 8;
       equipamentsAmmo = 0;
       equipamentsAmmoAmount = -4;
       equipamentsAmulet = 96;
       equipamentsArmor = 72;
       equipamentsBoots = 24;
       equipamentsContainer = 84;
       equipamentsHelmet = 108;
       equipamentsLegs = 36;
       equipamentsRing = 12;
       equipamentsShield = 60;
       equipamentsStart = $9de624;
       equipamentsWeapon = 48;
       equipamentsWeaponAmmount = 44;
       FightMode = $3c3c60;
       FPSPtr = $58d1bc;
       Graphic = $3c3c3c;
       GuiStart = $3BF820;//9.85 same 9.84;
       htkItemStart = $3C8F30;     //9.84
       htkSendStart = $3C8E68;     //9.84
       htkTextStart = $3C6998;    //9.84
       htkTypeStart = $3C8DC8;    //9.84
       lastStatusBar = $40AC48;   //9.85
       lastStatusBarTime = lastStatusBar - $4; //now we have this static :D
       mapFristArray = $41be0c;
       mapStart = $5E1B54;  //9.85
       mapStep = 168;    //328 for 9.90?
       playerAccount = $54ceac;
       playerAxe = $587e84;
       playerAxePC = $3ba0f8;
       playerCap = $587E94;
       playerClub = $587e7c;
       playerClubPC = $3ba0f0;
       playerConected = $3C8FF8; //9.85 same 9.84;
       playerDistance = $587e88;
       playerDistancePC = $3ba0fc;
       playerDragMouseItem = $54c638;
       playerExp = $3ba0a0;
       playerFish = $587e90;
       playerFishPC = $3ba104;
       playerFist = $587e78;
       playerFistPC = $3ba0ec;
       playerFlags = $3BF1B4;    //9.85
       playerGreenSquare = $3BF1E8;   //9.84
       playerHp = $553000;//9.85 same 9.84;
       playerHpMax = $58AE9C;//9.85 same 9.84;
       playerID = $58AEA4;
       playerLevel = $3ba0cc;
       playerMagic = $3ba0d4;
       playerMagicPC = $3ba0dc;
       playerMana = $3BF244;//9.85 same 9.84;
       playerManaMax = $3BF1F4;//9.85 same 9.84;
       playerMapPos = $5de6c8;
       playerOffTrain = $3ba084;
       playerPassword = $54cec8;
       playerRedSquare = $3ba0e0;
       playerShield = $587e8c;
       playerShieldPC = $3ba100;
       playerSoul = $3ba0d0;
       playerStamina = $3ba118;
       playerSword = $587e80;
       playerSwordPC = $3ba0f4;
       playerUsedMouseItem = $54c604;
       playerVocation = $59a754;
       playerWhiteSquare = 0;
       playerXGo = $58AEA0;
       playerXor = $3BF1F0;//9.85 same 9.84;
       playerYPos = $58AEAC;
       playerXPos = playerYPos-4;
       playerYGo = $578e98;
       playerZGo = 0;
       playerZPos = playerYPos +4;
       TibiaExpHour = $407a8c;
       Version = $5B340D;  //9.85
       vipStart = $5501B8;//9.85 same 9.84;
       vipLenght = vipStart +4;

      // end ibot

     backpack_ptr=$5e28d0;
      bp_items=$3c;
      bp_offset1=$8;
      bp_offset2=$0;
      bp_offset3=$10;
      bp_offset4=$10;


  // settings
  settingsHealMethodSpellCount = 10;   //   10 first are casts,10 last items
  settingsHealMethod : array[0..19] of string = (
    'Light Healing', 'Intense Healing', 'Ultimate Healing', 'Heal Friend',
    'Divine Healing', 'Salvation', 'Wound Cleansing', 'Intense Wound Cleansing',
    'Recovery' ,'Intense Recovery',

    'Intense Healing Rune', 'Ultimate Healing Rune', 'Health Potion',
    'Strong Health Potion', 'Great Health Potion', 'Ultimate Health Potion',
    'Great Spirit Potion', 'Mana Potion', 'Strong Mana Potion', 'Great Mana Potion'
  );

  settingsManaTrainMethodSpellCount = 32;   // 32 first are casts
  settingsManaTrainMethod : array[0..75] of string = (       //casts
    'Blood rage', 'Challenge', 'Charge', 'Creature illusion','Cure bleeding','Cure burning',
    'Cure curse','Cure electrification', 'Cure poison','Divine healing','Find person', 'Food',
    'Great light','Haste','Heal friend','Intense healing','Intense recovery',
    'Intense wound cleansing', 'Invisible', 'Light healing', 'Light', 'Magic shield',
    'Mass healing','Protector','Recovery', 'Salvation', 'Sharpshooter','Strong haste',
    'Swift foot', 'Ultimate healing', 'Ultimate light','Wound cleansing',
                            '---------------------------------',   //paladin stuff
    'Conjure poisoned arrow', 'Conjure explosive arrow','Conjure arrow','Conjure bolt',
    'Conjure power bolt','Conjure sniper arrow','Conjure piercing bolt', 'Enchant spear',
    'Enchant staff',
                            '---------------------------------',   //runes
    'Animate dead rune','Avalanche rune','Chameleon rune','Convince creature rune',
    'Cure poison rune','Desintegrate rune', 'Destroy field rune', 'Energy bomb rune',
    'Energy field rune','Energy wall rune', 'Explosion rune','Fire bomb rune',
    'Fire field rune','Fire wall rune','Fireball rune','Great fireball rune',
    'Heavy magic missile rune','Holy missile rune','Icicle rune','Intense healing rune',
    'Light magic missile rune','Magic wall rune','Paralyze rune','Poison bomb rune',
    'Poison field rune','Poison wall rune','Soulfire rune','Stalagmite rune',
    'Stone shower rune', 'Sudden death rune', 'Thunderstorm rune','Ultimate healing rune',
    'Wild growth rune'
 );

type

  TLocation = record
    x: integer;
    y: integer;
    z: integer;
  end;

  TItem = record
    id: integer;
    count: integer;
  end;

  TContainer = record
    isOpened: boolean;
    isChild: boolean;
    name: string;
    itemId: integer;
    slots: integer;
    filled: integer;
    items: array[0..255] of TItem;
  end;

  TItemLoc = record
    found: boolean;
    x: integer;
    y: integer;
    z: integer;
    ground: boolean;
    containerName: string;
    container: integer;
    slot: integer;
  end;

  TTileItem = record
    id: integer;
    data: integer;
    dataEx: integer;
  end;

  TTileMap = record
      ID: LongWord;
      Count: integer;
      Order1: integer;
      Order2: integer;
      Order3: integer;
      Order4: integer;
      Order5: integer;
      Order6: integer;
      Order7: integer;
      Order8: integer;
      Order9: integer;
      Order10: integer;

      Items: array[0..9] of record
        Index: integer;
        Volume: integer;
        Count: integer;
        Id: integer;
      end;
  end;


  TTile = record
    itemCount: integer;
    items: array [0..mapMaxTileObjects-1] of TTileItem;
    order: array [0..mapMaxTileObjects-1] of integer;
    global: TLocation;
    local: TLocation;
    index: integer;
  end;

  TMethodPriority = record
    priority: integer;
    overridePriority: integer;
    expireTime: integer;
    lifeTime: integer;
    eventType: string;
  end;

  TLuaLibrary = record
    luaFile: string;
    xmlFile: string;
  end;

  TTibiaDatTile = record
    isContainer: boolean;
    RWInfo: integer;
    fluidContainer: boolean;
    stackable: boolean;
    multiType: boolean;
    useable: boolean;
    notMoveable: boolean;
    alwaysOnTop: boolean;
    groundTile: boolean;
    blocking: boolean;
    blockPickupable: boolean;
    pickupable: boolean;
    blockingProjectile: boolean;
    canWalkThrough: boolean;
    noFloorChange: boolean;
    isDoor: boolean;
    isDoorWithLock: boolean;
    speed: integer;
    canDecay: boolean;
    haveExtraByte: boolean;
    haveExtraByte2: boolean;
    totalExtraBytes: integer;
    isWater: boolean;
    stackPriority: integer;
    haveFish: boolean;
    floorChangeUP: boolean;
    floorChangeDOWN: boolean;
    requireRightClick: boolean;
    requireRope: boolean;
    requireShovel: boolean;
    isFood: boolean;
    isField: boolean;
    isDepot: boolean;
    moreAlwaysOnTop: boolean;
    usable2: boolean;
    multiCharge: boolean;
    haveName: boolean;
    itemName: string;
  end;

  SSpeechMessage =
  (
    ssSay = 1,
    ssWhisper = 2,
    ssYell = 3,
    ssPrivate = 4,
    ssChannel = 7,
    ssChannelHighlight = 8,
    ssSpell = 9,
    ssFromNpc = 10,
    ssGMBroadcast = 12,
    ssGMChannel = 13,
    ssGMPrivate = 14,
    ssBarkLow = 34,
    ssBarkLoud = 35
  );
//(CHANNEL=7, DEFAULT=1, INFO=$13, NPCTOPLAYER=5, PRIVATE=6, RAID_ADVANCE=$10, REDALERT=15, SEND=$15, STATUS=0, STATUSLOG=$12, WELCOME=$11, WHISPER=2, YELL=3);

  STextMessage =
  (
    stChannelManagement = 6,
    stLogin = 16,
    stAdmin = 17,
    stGame = 18,
    stFailure = 19,
    stLook = 20,
    stStatus = 28,
    stLoot = 29,
    stTradeNpc = 30,
    stGuild = 31,
    stPartyManagement = 32,
    stParty = 33,
    stHotkeyUse = 37,
    stMarket = 40,
    stReport = 36,
    stDamageDealed = 21,
    stDamageRecived = 22,
    stDamageOthers = 25,
    stHeal = 23,
    stExp = 24,
    stHealOthers = 26,
    stExpOthers = 27
  );

 { InPacketId =
  (
    inSelfAppear = $0A,
    //inGMAction = $0B,
    //inErrorMessage = $14,
    inFyiMessage = $15,
    inWaitingList = $16,
    inPing = $1E,
    inDeath = $28,
    inCanReportBugs = $32,
    inMapDescription = $64,
    inMoveNorth = $65,
    inMoveEast = $66,
    inMoveSouth = $67,
    inMoveWest = $68,
    inTileUpdate = $69,
    inTileAddThing = $6A,
    inTileTransformThing = $6B,
    inTileRemoveThing = $6C,
    inCreatureMove = $6D,
    inContainerOpen = $6E,
    inContainerClose = $6F,
    inContainerAddItem = $70,
    inContainerUpdateItem = $71,
    inContainerRemoveItem = $72,
    inInventorySetSlot = $78,
    inInventoryResetSlot = $79,
    inShopWindowOpen = $7A,
    inShopSaleGoldCount = $7B,
    inShopWindowClose = $7C,
    inSafeTradeRequestAck = $7D,
    inSafeTradeRequestNoAck = $7E,
    inSafeTradeClose = $7F,
    inWorldLight = $82,
    inMagicEffect = $83,
    inAnimatedText = $84,
    inProjectile = $85,
    inCreatureSquare = $86,
    inCreatureHealth = $8C,
    inCreatureLight = $8D,
    inCreatureOutfit = $8E,
    inCreatureSpeed = $8F,
    inCreatureSkull = $90,
    inCreatureShield = $91,
    inItemTextWindow = $96,
    inHouseTextWindow = $97,
    inPlayerStatus = $A0,
    inPlayerSkillsUpdate = $A1,
    inPlayerFlags = $A2,
    inCancelTarget = $A3,
    inSpellDelay = $A4,
    inSpellGoupDelay = $A5,
    inCreatureSpeech = $AA,
    inChannelList = $AB,
    inChannelOpen = $AC,
    inChannelOpenPrivate = $AD,
    inRuleViolationOpen = $AE,
    inRuleViolationRemove = $AF,
    inRuleViolationCancel = $B0,
    inRuleViolationLock = $B1,
    inPrivateChannelCreate = $B2,
    inChannelClosePrivate = $B3,
    inTextMessage = $B4,
    inPlayerWalkCancel = $B5,
    inFloorChangeUp = $BE,
    inFloorChangeDown = $BF,
    inOutfitWindow = $C8,
    inVipState = $D2,
    inVipLogin = $D3,
    inVipLogout = $D4,
    inQuestList = $F0,
    inQuestPartList = $F1,
    inShowTutorial = $DC,
    inAddMapMarker = $DD
  ); }

  NewInPacketId =
  (
    inOUTFIT = 200,
    inMESSAGE = 180,
    inPING = 30,
    inWAIT = 182,
    inBUDDYDATA = 210,
    inCREATUREPARTY = 145,
    inQUESTLOG = 240,
    inFIELDDATA = 105,
    inCLOSECONTAINER = 111,
    inLEFTROW = 104,
    inFULLMAP = 100,
    inMISSILEEFFECT = 133,
    inSPELLGROUPDELAY = 165,
    inBOTTOMROW = 103,
    inLOGINERROR = 20,
    inQUESTLINE = 241,
    inCREATURESKULL = 144,
    inTRAPPERS = 135,
    inBUDDYLOGIN = 211,
    inSNAPBACK = 181,
    inOBJECTINFO = 244,
    inCHANNELS = 171,
    inOPENCHANNEL = 172,
    inTOPFLOOR = 190,
    inPRIVATECHANNEL = 173,
    inLOGINWAIT = 22,
    inCREATEONMAP = 106,
    inCHALLENGE = 31,
    inCONTAINER = 110,
    inNPCOFFER = 122,
    inBUDDYLOGOUT = 212,
    inMARKETBROWSE = 249,
    inMARKETLEAVE = 247,
    inCOUNTEROFFER = 126,
    inMARKETENTER = 246,
    inCREATURESPEED = 143,
    inMARKCREATURE = 134,
    inSPELLDELAY = 164,
    inDELETEONMAP = 108,
    inCREATUREOUTFIT = 142,
    inAMBIENTE = 130,
    inPLAYERSKILLS = 161,
    inCREATUREUNPASS = 146,
    inDELETEINCONTAINER = 114,
    inCREATEINCONTAINER = 112,
    inCREATUREHEALTH = 140,
    inINITGAME = 10,
    inTOPROW = 101,
    inBOTTOMFLOOR = 191,
    inPLAYERDATA = 160,
    inCREATURELIGHT = 141,
    inTUTORIALHINT = 220,
    inPLAYERGOODS = 123,
    inPLAYERINVENTORY = 245,
    inMOVECREATURE = 109,
    inEDITLIST = 151,
    inCLOSETRADE = 127,
    inSETINVENTORY = 120,
    inCHANGEONMAP = 107,
    inDEAD = 40,
    inCHANGEINCONTAINER = 113,
    inDELETEINVENTORY = 121,
    inLOGINADVICE = 21,
    inCHANNELEVENT = 243,
    inMARKETDETAIL = 248,
    inTALK = 170,
    inCLOSENPCTRADE = 124,
    inRIGHTROW = 102,
    inGRAPHICALEFFECT = 131,
    inEDITTEXT = 150,
    inOPENOWNCHANNEL = 178,
    inCLEARTARGET = 163,
    inCLOSECHANNEL = 179,
    inAUTOMAPFLAG = 221,
    inOWNOFFER = 125,
    inPLAYERSTATE = 162
  );


var
  DatTiles: array of TTibiaDatTile;

function xmlItemId( str: string ): integer;
function IntToBool(inp: integer): boolean;
implementation

function xmlItemId( str: string ): integer;
begin
  if length(str) > 0 then
    result := StrToInt(str)
  else
    result := 0;
end;

function IntToBool(inp: integer): boolean;
begin
	{returns false for 0 values, true for all others}
	if inp = 0 then IntToBool := false else IntToBool := true;
end;


end.
