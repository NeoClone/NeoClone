unit cooldown;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Addresses, inputer,System.Math,StrUtils;
 {
type
  TCD_Results = record
    CooldownTimeStart,
    CooldownTimeEnd,
    CooldownID,
    TibiaTime: integer;
  end;    }

type

  TCooldown = class
  private

  public                       //for Ping Compensation purpose
function canCast(spell: string; time_before: integer=0): boolean;// TCD_Results;
//function canCast(spell: string): boolean;
  end;

implementation

uses
  Unit1;
// I don't think we need to know how much time is the CD,
//we just check each 1sec if Cancast(cooldownid) and yea, that's all lol xD
// why 1sec? cause is the minimun for everything (runes,heal,etc)

                                  //for Ping Compensation purpose
function TCooldown.canCast(spell: string; time_before: integer=0): boolean;
var
num,num2,num3,num4,num5,num7,num8,num9,num10,i,Tibiatime: integer;
CategoryAttackTimeStart,CategoryAttackTimeEnd,
CategoryHealingTimeStart,CategoryHealingTimeEnd,
CategorySupportTimeStart,CategorySupportTimeEnd,
CategorySpecialTimeStart,CategorySpecialTimeEnd,
CoolDownID,CooldownTimeStart,CooldownTimeEnd: integer;
CoolDownCategory : string;
begin
if not player.OnLine then exit; //if we aren't logged it could crash!

    Tibiatime := Memory.ReadInteger(Integer(ADDR_BASE) + clientTibiaTime);
    num := Memory.ReadInteger(Integer(ADDR_BASE) + coolDownCategoryStart);
    num2 := Memory.ReadInteger((num));
    num3 := Memory.ReadInteger((num2));
    CategoryAttackTimeStart := Memory.ReadInteger(((num2 + 12))); //CD= 2sec
    CategoryAttackTimeEnd := Memory.ReadInteger(((num2 + $10)));
    CategoryHealingTimeStart := Memory.ReadInteger(((num3 + 12))); //CD= 1sec
    CategoryHealingTimeEnd := Memory.ReadInteger(((num3 + $10)));
    num3 := Memory.ReadInteger((num3));
    CategorySupportTimeStart := Memory.ReadInteger(((num3 + 12)));  //CD= 2sec
    CategorySupportTimeEnd := Memory.ReadInteger(((num3 + $10)));
    num3 := Memory.ReadInteger((num3));
    CategorySpecialTimeStart := Memory.ReadInteger(((num3 + 12))); //CD= ?sec
    CategorySpecialTimeEnd := Memory.ReadInteger(((num3 + $10)));
   // showmessage(inttostr(CategoryHealingTimeStart)+' '+inttostr(CategoryHealingTimeEnd)+' '+
   // inttostr(CategoryHealingTimeEnd-CategoryHealingTimeStart)+' '+inttostr(Tibiatime));

    num4 := Memory.ReadInteger(Integer(ADDR_BASE) + coolDownItems);
    num5 := Memory.ReadInteger(Integer(ADDR_BASE) + coolDownItemsStart);
    num5 := Memory.ReadInteger((num5));

    CooldownTimeStart := 0;
    CooldownTimeEnd := 0;

    i := 0;
    while ((i < num4)) do
    begin
        num7 := Memory.ReadInteger((num5));
        Memory.ReadInteger(((num5 + 4)));
        num8 := Memory.ReadInteger(((num5 + 8)));
        num9 := Memory.ReadInteger(((num5 + 12)));
        num10 := Memory.ReadInteger(((num5 + $10)));
        num5 := num7;
       // showmessage(inttostr(num10)+' '+inttostr(num9)+' '+inttostr(num8));
  CoolDownID:= strtoint(xmlSpellList.Root.FindEx2('words',lowercase(spell)).Attribute['CoolDownID']);


            if (CoolDownID = num8) then //we check if our spell is in the CD tags
            begin
                CooldownTimeStart := num9;
                CooldownTimeEnd := num10;
               // showmessage(inttostr(Tibiatime div 10000));
                if (CooldownTimeEnd - time_before) >= Tibiatime then
                  begin
                    result:= False;
                    exit;         //if we got our spell CD end this function False
                  end
                else break;       //if we got our spell CD and it has ended--> exit loop
            end;
        inc(i);
    end;
 // in case it didn't exit (not found tag_ID) then we check the 4 categories
                  //what is the Category of our spell?
CoolDownCategory:= (xmlSpellList.Root.FindEx2('words',lowercase(spell)).Attribute['group1']);

         //if category is this             //it hasn't finished yet
  if (CoolDownCategory = 'attack') and ((CategoryAttackTimeEnd - time_before) >= Tibiatime) then
      begin
          result:= False;
          exit; //so we don't get the last part of this function which sets result:= True.
      end       //if category is this             //it hasn't finished yet
  else if (CoolDownCategory = 'healing') and ((CategoryHealingTimeEnd - time_before) >= Tibiatime) then
      begin
          result:= False;
          exit; //so we don't get the last part of this function which sets result:= True.
      end       //if category is this             //it hasn't finished yet
  else if (CoolDownCategory = 'support') and ((CategorySupportTimeEnd - time_before) >= Tibiatime) then
      begin
          result:= False;
          exit; //so we don't get the last part of this function which sets result:= True.
      end       //if category is this             //it hasn't finished yet
  else if (CoolDownCategory = 'special') and ((CategorySpecialTimeEnd - time_before) >= Tibiatime) then
      begin
          result:= False;
          exit; //so we don't get the last part of this function which sets result:= True.
      end;


               result:= True;

end;

end.

