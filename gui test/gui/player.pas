unit player;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Addresses, inputer,System.Math ,log, chat, xml.verysimple;

type

PlayerFlags = (Battle=$80, Bleeding=$8000,
              Buffed=$1000, Burning=2, CannotLogoutOrEnterProtectionZone=$2000,
              Cursed=$800, Dazzled=$400, Drowning=$100, Drunken=8, Energized=4,
              Freezing=$200, Hasted=$40, Manashielded=$10, Paralyzed=$20, Poisoned=1,
              WithinProtectionZone=$4000);

  TPlayer = class
  private
    FSAttack: integer;
    FSHealing: integer;
    FSSupport: integer;
    FSSpecial: integer;
    function getAttackEx(): integer;
    function getHealingEx(): integer;
  public
    function OnLine():boolean;
    function ID:integer;
    function Name():string;
    function connect( account: string; password: string; Char_list_position: integer):boolean;
   // function getName(): string;
    function getLocation(): TLocation;

    function HP(): integer;
    function HPMax(): integer;
function HpPerc: Integer;
    function Mana(): integer;
    function ManaMax(): integer;
    function ManaPerc(): integer;
function axe: Integer;
function axepc: Integer;
function cap: Integer;
function Exp: integer;
function ExpGainedStart: integer;
function DragMouseItem: Integer; //last item we moved
function distancepc: Integer;
function distance: Integer;
function clubpc: Integer;
function club: Integer;
function ExpHour: integer;
function fishing: Integer;
function fishingPC: Integer;
function fist: Integer;
function fistPC: Integer;
function flags: Integer;
function greensquare: Integer;
function IsWalk: boolean;
function level: Integer;
function mlevel: Integer;
function mlevelpc: Integer;
function Mount: boolean;
function outfit: Integer;
function offtrain: Integer;
function PlayerDirection: String;
function RedSquare: Integer;
function Shielding: Integer;
function Shieldingpc: Integer;
function Skull: Integer;
function Soul: Integer;
function Stamina: Integer;
function Sword: Integer;
function SwordPc: Integer;
function TibiaExpHour: Integer;
function UsedMouseItem: Integer;
function Visible: boolean;
function CheckFlag(flag: PlayerFlags): boolean;
function ExpToLevel(num: integer): Integer;
function Proximidade(X: Integer; Y: Integer): Integer;
function IsVisible(X: Integer; Y: Integer; Z: Integer): boolean;
//function TPlayer.IsVisible(creature: Creature): boolean;


    procedure AntiIdle();
    procedure EatFood( name: string ='');
    procedure setAttackEx( value: integer );
    procedure setHealingEx( value: integer );
    property AttackEx: integer read getAttackEx;
    property HealingEx: integer read getHealingEx;
  end;

var
xr: integer;      //we declare it 4eva
expstart: integer;
tickstarthour: cardinal;
delay_timeF: integer;     //for the EatFood() (this checks if we are full)
delay_timeI: integer;     //for the AntiIdle()

implementation

uses
  unit1,containers;


procedure TPlayer.setAttackEx( value: integer );
begin
  FSAttack := GetTickCount + value;
end;

function TPlayer.getAttackEx(): integer;
var
  val: integer;
begin
  val := FSAttack - GetTickCount;
  if val <= 0 then val := 0;
  result := val;
end;

procedure TPlayer.setHealingEx( value: integer );
begin
  FSHealing := GetTickCount + value;
end;

function TPlayer.getHealingEx(): integer;
var
  val: integer;
begin
  val := FSHealing - GetTickCount;
  if val <= 0 then val := 0;
  result := val;
end;

procedure TPlayer.AntiIdle();
var
  val: integer;
begin
  if (delay_timeI - GetTickCount) > 0 then exit;

  inputer.SendKeyDown(VK_CONTROL);
  inputer.SendKey(VK_UP);
  sleep(RandomRange(250,500));
  inputer.SendKey(VK_DOWN);
  inputer.SendKeyUp(VK_CONTROL);

  delay_timeI := GetTickCount + RandomRange(240000,360000); //Random(4min to 6min)
end;

procedure TPlayer.EatFood( name: string = '');
var
id,p: integer;
containers: TContainers;
Chat: TChat;
Snode: TXMLnode;
Snodelist: TXMLNodelist;
begin    //if we were full we will wait 3.5 - 5min
        //X+5    -    X          > 0 then exit bro
  if (delay_timeF - GetTickCount) > 0 then exit;
  if name <> '' then        // if we want to eat just 1 item...
    begin
      id:= strtoint(xmlItemList.Root.FindEx2('name',lowercase(name)).Attribute['id']);
     //check status bar, if full gettickcount, and gettickcount+5min
        containers.useitem(id); //we need it in hotkeys for now, til Containers is fixed
        if (chat.GetStatusBar = 'You are full.') then
           delay_timeF := GetTickCount + RandomRange(210000,300000); //Random(3.5min to 5min)
    end else
      begin      // we want to eat ALL food.... xD  	<category name="food" />
        Snodelist:= XmlItemList.Root.FindEx('category','food');
        for SNode in Snodelist do
        begin
              id:= strtoint(SNode.Attribute['id']);         //we get ID of each item
                   //sleep(0);   //else will bug, wtf????
                if containers.useItem(id) then break;  //if we had used it (it was found) then stop loop
        end;
        SNode.Cleanupinstance;  //cleanin da streetz yo
        if (chat.GetStatusBar = 'You are full.') then
           delay_timeF := GetTickCount + RandomRange(210000,300000); //Random(3.5min to 5min)
      end;
end;


function TPlayer.OnLine():boolean;
var
  value: integer;
begin
  value := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerConected );
  if value <> 10 then            // 8 in 9.44
    result := false
  else
    result := true;
end;

function TPlayer.ID:integer;

begin
  result := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerID );
end;


function TPlayer.Name():string;
var
  value: integer;
  value2: integer;
  name: string;
  CreatureOffset: integer;
  i: integer;
  SID: integer;
begin                    //okay bro, get all the possible creatures, from 0 til finish
  for i := 0 to addresses.distBattleListMax -1 do
      begin              // the offsets of the first creature, second, third...
      CreatureOffset:= i * addresses.distBattleListStep;
                         // read the creature ID!
    value := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.battleListStart + addresses.distBattleListId + CreatureOffset);

        if  value = ID() then     //if it's us... stop searching and get our name.
          begin        //name here! \/
          result := Memory.ReadString(Integer(ADDR_BASE) + addresses.battleListStart + distBattleListName + CreatureOffset);
          break;         //ok, we stop it so the cpu keeps quiet xD
                          //en el attacker tendremos que poner que si id=0 deje de buscar!
          end;
      end;
end;


                                    //it needs the part of auxFormPointer (winddows etc)
function TPlayer.connect( account: string; password: string; Char_list_position: integer ):boolean;
var
  r: TRect;
  p: TPoint;
  addr, count, i, up, z, selected, pos, go: integer;
  found: boolean;
  name: string;

  address,address_end ,lastchar:Cardinal;
  Nick, World : string;
  Base_Address, remoteadr: Cardinal;
  nametype: Cardinal;
  ClientSelectedCharId: integer;
begin
  result := false;

  if OnLine() then exit;
  
  // showmessage('cargamos vars');
  ClientSelectedCharId := Memory.ReadInteger(Integer(ADDR_BASE) + charListSelectedChar);
    
  // we must do some maths to know how many chars are loaded
  address := Memory.ReadInteger(Integer(ADDR_BASE) + charListPointer);
  address_end := Memory.ReadInteger(Integer(ADDR_BASE) + charListEnd);
  lastchar := ((address_end - address) div charListStep) ;
  // showmessage('ya hemos cargado vars');
            
  r := GUI.getSize();

  p.X := r.Left + 122;              //80     83
  p.Y := r.Bottom + 553;           //550    548

  // zamykamy wszystkie okna
  inputer.SendKey(VK_ESCAPE);
  sleep(500);

  // klikamy Enter Game
  inputer.SendClickPoint(p);
  sleep(1000);

  // wprowadzamy nazwe konta
  inputer.SendString(account);
  sleep(100);

  // przechodzimy do pola hasla
  inputer.SendKey(VK_TAB);
  sleep(100);

  // wprowadzamy haslo
  inputer.SendString(password);
  sleep(100);

  // klikamy enter by sie zalogowac
  inputer.SendKey(VK_RETURN);
  sleep(4000);
                  
  // wybieramy postac   --elegir un pj
  //count := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.charListLength );
  //addr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.charListPointer );
  
  
         //LOOOOOOOL, just noticed that when the function begins it closes every
         //single fcking window, so no problems of positions (cause of relogging)
           {
  if lastchar <> 0 then   //if you were logged before...
  begin  
      for z := 1 to lastchar -1 do //amount of characters, we don't know wich one we were... 
       begin                   // so we just press all the possible KEY UP, just in case
         Inputer.SendKey(VK_UP); // we are on the last one      
        sleep(150);
       // showmessage(inttostr(z)+' up');
      end;
  end;
            }
  begin    
    for z := 1 to Char_list_position -1 do     // amounts of key downs to do
      begin                                     //til we get to our char
        Inputer.SendKey(VK_DOWN);
        sleep(150);
       // showmessage(inttostr(z)+' down');
      end;
        Inputer.SendKey(VK_RETURN);             //now enter and wait
        sleep(4000); 
                  //addr := addr + addresses.charListStep +addresses.charListName;  
  end; 
  {   
  for i := 1 to lastchar do //amount of characters
  begin
  //  name := Memory.ReadString(Integer(ADDR_BASE) +  ClientSelectedCharId + charListName );
                  // character position in the list: 1, 2,3...
    if i = Char_list_position then
    begin
      pos := i;
      found := true;
      break;
    end;
    //addr := addr + addresses.charListStep +addresses.charListName;
  end;

  if found = false then exit;
     {
  selected := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.charListSelectedChar );

  if selected > count-1 then selected := 0;

  go := pos - selected;

  // jezeli wartosc go jest powyzej zera, nie zamieniaj wartosci i idz w dol
  if go > 0 then
  begin
    for i := 0 to go - 1 do
    begin
      Inputer.SendKey(VK_DOWN);
      sleep(150);
    end;
  end;

  // jezeli wartosc go jest ponizej zera, usun przecinek i idz w gore
  if go < 0 then
  begin
    go := abs(go);
    for i := 0 to go - 1 do
    begin
      Inputer.SendKey(VK_UP);
      sleep(150);
    end;
  end;
           
  // po wybraniu postaci, naciskamy enter
  Inputer.SendKey(VK_RETURN);
  sleep(4000);
                            }
  // jezeli nie udalo sie zalogowac, przerywa i zwraca false
  if not OnLine() then exit;

  // wszystko ok i zwraca true
  result := true;

end;
 {
function TPlayer.getName(): string;
var
  i, addr, selected: integer;
begin
  addr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.charListPointer );
  selected := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.charListSelectedChar );

  result := Memory.ReadString( addr + ( selected * addresses.charListStep ) );
end;
  }
function TPlayer.getLocation(): TLocation;
begin
  result.x := Memory.ReadInteger(Integer(ADDR_BASE) +  playerXPos );
  result.y := Memory.ReadInteger(Integer(ADDR_BASE) +  playerYPos );
  result.z := Memory.ReadInteger(Integer(ADDR_BASE) +  playerZPos );
end;

function TPlayer.hp(): integer;
begin
  xr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerXor );
  result := xr xor Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerHp );
end;

function TPlayer.HPmax(): integer;
begin
  xr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerXor );
    // Here we do the XOR stuff
  result := xr xor Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerHpMax );
end;

function TPlayer.Mana(): integer;
begin
  xr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerXor );
  result := xr xor Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerMana );
end;

function TPlayer.ManaMax(): integer;
begin
  xr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerXor );
  result := xr xor Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerManaMax );
end;

function TPlayer.axepc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerAxePC));
end;

function TPlayer.Cap: Integer;
begin //we use the xor in the player cap Integer, and then we take out 2 ceros,
    // then Truncation so we get the same result as in Tibia GUI
  xr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.playerXor );
    Result := Trunc((xr xor Memory.ReadInteger(Integer(ADDR_BASE) +playerCap))/100);
end;

function TPlayer.club: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerClub)
end;

function TPlayer.clubpc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerclubPC));
end;

function TPlayer.distance: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerdistance)
end;

function TPlayer.distancepc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerdistancePC));
end;

function TPlayer.DragMouseItem: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerDragMouseItem)
end;

function TPlayer.Exp: integer;
begin
if expstart=0 then                 //we declare it if we haven't done it yet
expstart:=  Memory.ReadInteger(Integer(ADDR_BASE) +playerexp);

    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerexp);
end;

function TPlayer.ExpGainedStart: integer;
begin
if expstart=0 then                 //we declare it if we haven't done it yet
expstart:=  Memory.ReadInteger(Integer(ADDR_BASE) +playerexp);

//showmessage(inttostr(expstart)+ ' '+inttostr(Exp));
    Result := Exp - player.expstart;
end;

function TPlayer.ExpHour: integer;
var
num, num2: integer;
begin
    num := 0;
    //num2 := 0;
    if tickstarthour = 0 then       //we declare it if we haven't done it yet
        tickstarthour:=gettickcount();

    if (ExpGainedStart > 0) then //if we have gained exp
    begin
        num2 := ((gettickcount() - tickStartHour) div 1000); // in seconds
        num := ((ExpGainedStart * 3600) div num2);
    end;
    begin
        Result := num;
        exit
    end
end;

function TPlayer.fishing: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerFish)
end;

function TPlayer.fishingpc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerFishPC));
end;


function TPlayer.fist: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerFist)
end;

function TPlayer.fistpc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerFistPC));
end;


function TPlayer.flags: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +addresses.playerFlags);
end;

function TPlayer.CheckFlag(flag: PlayerFlags): boolean;
var
flag2: boolean;
i: integer;
num3: single;
flags: integer;
begin
    flag2 := false;
    flags := self.Flags;
    try
        i := 0;
        while ((i <= 15)) do
        begin
            num3 :=  system.Math.Power(2, (15 - i));
            if ((flags - num3) >= 0) then
            begin
                if (flags <> 1) then
                    dec(flags, round(num3));
                if (ord(flag)) = num3 then //we write "ord" or else won't work...1h to fix it xD
                    flag2 := true
                end;
            inc(i)
        end
    finally
    end;
        Result := flag2;

end;

//PlayerFlags = (Battle=$80, Bleeding=$8000, Buffed=$1000, Burning=2, CannotLogoutOrEnterProtectionZone=$2000, Cursed=$800, Dazzled=$400, Drowning=$100, Drunken=8, Energized=4, Freezing=$200, Hasted=$40, Manashielded=$10, Paralyzed=$20, Poisoned=1, WithinProtectionZone=$4000);

function TPlayer.greensquare: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playergreensquare)
end;

function TPlayer.HpPerc: Integer;
begin
    Result := Trunc((Hp / HpMax) * 100)
end;

function TPlayer.ManaPerc: Integer;
begin
    Result := Trunc((Mana / ManaMax) * 100)
end;

function TPlayer.Axe: Integer;     //function Player.Int32_0: Integer; in ibot
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerAxe)
end;

function TPlayer.IsWalk: boolean;
var
i: integer;
begin
result:=false;
    i := 0;
    while ((i < $514)) do   //1300 max creatures in battlelist
    begin
        if (Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep))) = iD) then
        begin
            result:= (Memory.ReadInteger(((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep)) + distBattleListWalking)) <> 0);
            break;

        end;
        inc(i)
    end;
end;

function TPlayer.level: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerlevel)
end;

function TPlayer.mlevel: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playermagic)
end;

function TPlayer.mlevelpc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playermagicPC));
end;

function TPlayer.Mount: boolean;
var
i: integer;
begin
result:=false;
    i := 0;
    while ((i < $514)) do   //1300 max creatures in battlelist
    begin
        if (Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep))) = iD) then
        begin
            result:= (Memory.ReadInteger(((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep)) + distBattleListMountId)) <> 0);
            break;

        end;
        inc(i)
    end;
end;

function TPlayer.Offtrain: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerOffTrain)
end;

function TPlayer.Outfit: integer;
var
i: integer;
begin
    i := 0;
    while ((i < $514)) do   //1300 max creatures in battlelist
    begin
        if (Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep))) = iD) then
        begin
            result:= Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep)) + distBattleListOutfit);
            break;

        end;
        inc(i)
    end;
end;

function TPlayer.PlayerDirection: String;
var
i,num: integer;
begin
    i := 0;
    while ((i < $514)) do   //1300 max creatures in battlelist
    begin
        if (Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep))) = iD) then
        begin
            num:= Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep)) + distBattleListDirection);
            if num= 0 then
              result:= 'North'
            else if num= 1 then
              result:= 'East'
            else if num= 2 then
              result:= 'South'
            else if num= 3 then
              result:= 'West'
            else if num= 5 then
              result:= 'NorthRight'
            else if num= 6 then
              result:= 'SouthRight'
            else if num= 7 then
              result:= 'SouthLeft'
            else if num= 8 then
              result:= 'NorthLeft';
            break;

        end;
        inc(i)
    end;
end;

function TPlayer.RedSquare: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerRedSquare)
end;

function TPlayer.Shielding: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerShield)
end;

function TPlayer.Shieldingpc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerShieldpc));
end;

function TPlayer.Skull: integer;
var
i: integer;
begin
    i := 0;
    while ((i < $514)) do   //1300 max creatures in battlelist
    begin
        if (Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep))) = iD) then
        begin
            result:= Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep)) + distBattleListSkull);
            break;

        end;
        inc(i)
    end;
end;

function TPlayer.Soul: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerSoul)
end;

function TPlayer.Stamina: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerStamina)
end;

function TPlayer.Sword: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerSword)
end;

function TPlayer.Swordpc: Integer;
begin
    Result := (100 - Memory.ReadInteger(Integer(ADDR_BASE) +playerSwordpc));
end;

function TPlayer.TibiaExpHour: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +addresses.TibiaExpHour)
end;

function TPlayer.UsedMouseItem: Integer;
begin
    Result := Memory.ReadInteger(Integer(ADDR_BASE) +playerUsedMouseItem)
end;

function TPlayer.Visible: boolean;
var
i: integer;
begin
result:=false;
    i := 0;
    while ((i < $514)) do   //1300 max creatures in battlelist
    begin
        if (Memory.ReadInteger((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep))) = iD) then
        begin
            result:= (Memory.ReadInteger(((Integer(ADDR_BASE) + battleListStart + (i * distBattleListStep)) + distBattleListVisible)) = 1);
            break;

        end;
        inc(i)
    end;
end;

function TPlayer.ExpToLevel(num: integer): Integer;
var
num2: integer;
begin
    num := (Level + 1);     //num^3
    num2 := (((round(50 * Power(num,3) / 3) - ((100 * num) * num)) + ((850 * num) div 3)) - 200);
    Result := (num2 - (Exp));
end;

function TPlayer.Proximidade(X: Integer; Y: Integer): Integer;
var
num,num3,num4: integer;
begin
    num := 0;
    try
        num3 := Abs(((getLocation.X - X)));
        num4 := Abs(((getLocation.Y - Y)));
        if (num3 > num4) then
            begin
                Result := num3;
                exit
            end;
        num := num4;
        Result := num;
        exit
    finally
    end;
end;

function TPlayer.IsVisible(X: Integer; Y: Integer; Z: Integer): boolean;
var
str: string;
num,num2:integer;
flag: boolean;
begin
    flag := false;
    try
        num := Abs(((getLocation.X - X)));
        num2 :=Abs(((getLocation.Y - Y)));
        if (((num <= 7) and (num2 <= 5)) and (getLocation.Z = Z)) then
            flag := true
    except
        on exception: Exception do
        begin
            str := 'Game:Player:IsVisibleXYZ'; //so we know what the fck u did, dumbass
      log.AddLog(colorRed,Concat(str, ' - ', exception.ToString),true);
        end;
    end;
    begin
        Result := flag;
        exit
    end
end;
     {we have to create the gui.Creature.pass before!, then just uncomment this
function TPlayer.IsVisible(creature: Creature): boolean;
var
str: string;
num,num2:integer;
flag: boolean;
begin
    flag := false;
    try
        if ((creature <> nil) and ((((creature.Visible = 1) and (creature.Id <> Tplayer.ID)) and (creature.HpPerc > 0)) and (getLocation.Z = creature.Z))) then
        begin
            num := Abs(((getLocation.X - creature.X) as Integer));
            num2 := Abs(((getLocation.Y - creature.Y) as Integer));
            if (((num <= 7) and (num2 <= 5)) and (getLocation.Z = creature.Z)) then
                flag := true
            end
    except
        on exception: Exception do
        begin
            str := 'Game:Player:IsVisible'; //so we know what the fck u did, dumbass
        log.AddLog(colorRed,Concat(str, ' - ', exception.ToString),true);
        end;
    end;
    begin
        Result := flag;
        exit
    end
end;
}







end.
