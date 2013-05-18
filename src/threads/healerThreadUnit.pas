unit healerThreadUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Xml.VerySimple, settingsHelper, addresses, Vcl.Dialogs,
  eventQueue, PriorityQueue, math,StrUtils,settingsFormUnit, States, chat, cooldown;

type
  TxRange = record
    from: integer;
    too: integer;
    percent: boolean;
  end;

  THealerThread = class(TThread)
    FXml: TXmlNode;
  tree: TsettingsForm;
  public

  protected
    procedure Execute; override;
  end;

implementation

uses
  unit1;

function stringToxRange( value: string ): TxRange;
var
  above, percent, above0, percent0: boolean;
  val: string;
begin
result.percent := false;
result.too := 0;
result.from := 0;
  percent := (pos('%', value) > 0);
  above := (pos('above', value) > 0);
  percent0 := (pos('%', value) = 0);
  above0 := (pos('above', value) = 0);

  result.from := StrToInt(copy(value, 1, pos(' ', value) - 1));

  if above and percent then //first we have to put above+percent cause 
      begin                //if we change order it will NOT take "19 and Above %" (4example)     
      result.too := 0;
      result.percent:=  percent;
      end
  else  if percent0 and above0 then  
    result.too := StrToInt(copy(value, pos('to ', value) + 3, length(value)))
  else if percent then       
    begin                                  // "25 to 100 %"
    val:= copy(value, pos('to ', value)+3, Maxint);     // "100 %"
    //         "25..."      "100 %"                 5   -2 ==3-->"100"
    val:= copy(value, pos('to ', value) + 3, length(val)-2);    

    result.too := StrToInt(val);   // "100"

  result.percent := percent;
    end
  else if above then       
    result.too := 0
end;

procedure THealerThread.Execute;
var
  hp,hpMax, mp,mpMax, i,x,z: integer;
  pHp, pMp: integer;
  node, xNode, mNode,tNode: TXmlNode;
  tmp: array[0..5] of string;
  value,index1, spell,TrainSpell, itemId, itemName,spellCD_ID: string;
  index, spamRate, pingCon: integer;
  HealthRange, ManaRange,ManaMissing: TxRange;
  doHeal1,doHeal2, useSpell, emptyData, doTrain: boolean;
  event: TEvent;
  chat: TChat;
  CD: TCoolDown;
begin

  while not Terminated do

          try
  begin
    spamRate := 100;                   //canCast(spell, MYping*(pingCon/100))
    pingCon := strtoint(FXml.Find('sSettings').Find('iPingCompensation').Text);
                                       //canCast('exura', 200ms*(30%))
    if  assigned(FXml)
     and (GUI.Player.OnLine) and (tree.getsetting('Healer/HealerEnabled') = 'yes') then
    // and //((GUI.Player.HealingEx-pingCon) = 0) then
    //(GUI.Player.HealingEx = 0) then //cooldown
    begin    //fuck, fuck fuck, fuck... fuck.... (TO DO) we have to use Synchronize else it will bug if we put high delays (spamRate) in one... found this while trying to create the HUD script support
      hp := GUI.Player.HP;
      hpMax := GUI.Player.HPMax;
      mp := GUI.Player.Mana;
      mpMax := GUI.Player.ManaMax;
      pHp := GUI.Player.HpPerc;//round((hp * 100) / hpMax);
      pMp := GUI.Player.ManaPerc;//round((mp * 100) / mpMax);
      if (tree.getsetting('Healer/ManaTraining/Enabled') = 'yes') then
          begin
            Gui.Player.EatFood();     //once we've done the scripter we will add this there

            Gui.Player.AntiIdle();    //"NeoSettings--> examples-->antiidle/eatfood/etc"

            tNode := FXml.Find('sManaTraining');  //our tree

            value := tnode.Find('rManaMissing').Text;    //r like the rSpamRate
            ManaMissing.from:= strtoint(copy(value, 1, pos(' ', value) - 1));
              if (pos('above', value) > 0) then ManaMissing.too:= (mpMax -1) else
            ManaMissing.too:= strtoint(copy(value, pos('to ', value) + 3, length(value)));
            if (mpMax-mp >= ManaMissing.from) and (mpMax-mp <= ManaMissing.too) then //now WHILE cause if it bugs he will says the whole time the TrainSpell!
             begin

              index1 := tNode.Find('cTrainSpell').Text;
              TrainSpell := xmlSpellList.Root.FindEx2('name',lowercase(index1)).Attribute['words'];

              mNode := tNode.Find('sSpellPriority');

              value := tNode.Find('rSpamRate').Text;   // "r" cause is a Range

              tmp[0] := copy(value, 1, pos(' ', value) - 1);
              tmp[1] := copy(value, pos('to ', value) + 3, length(value));

              randomize();
              spamRate := RandomRange( StrToInt(tmp[0]), StrToInt(tmp[1]) );

              event.priority := StrToInt(mNode.Find('iPriority').Text);
              event.overridePriority := StrToInt(mNode.Find('iOverridePriority').Text);
              event.expireTime := StrToInt(mNode.Find('iExpireTime').Text);
              event.lifeTime := StrToInt(mNode.Find('iLifeTime').Text);
              event.eventType := StrToEventType(mNode.Find('cEventType').Text);

              if CD.canCast(TrainSpell, Round(Ping*(pingCon/100))) then
                event.script := 'cast("'+ TrainSpell +'")'
              else event.script:= '';

              EvtQueue.insert( event );
             end;

            sleep(spamRate);
            spamRate := 100;
          end;


      xNode := FXml.Find('lHealRules');   //l because is a list!

      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
        begin
          doHeal1 := false;
          doHeal2 := false;

          value := node.Find('xHealthRange').Text;    //x because is RangePercent!
          HealthRange := stringToxRange( value );

          value := node.Find('xManaRange').Text;
          ManaRange := stringToxRange( value );


          emptyData := (HealthRange.from = 0) and (HealthRange.too = 0);
          if not emptyData then
          begin
          //sleep(5000);
            // omg
            if not HealthRange.percent then     //we have health
            begin
              if HealthRange.too = 0 then HealthRange.too := hpMax;
              doHeal1 := (hp >= HealthRange.from) and (hp <= HealthRange.too);
            end else
            begin
              if HealthRange.too = 0 then HealthRange.too := 100;
              doHeal1 := (pHp >= HealthRange.from) and (pHp <= HealthRange.too);
            end;

            if not ManaRange.percent then    //we have mana
            begin
              if ManaRange.too = 0 then ManaRange.too := mpMax;
              doHeal2 := (mp >= ManaRange.from) and (mp <= ManaRange.too) and doHeal1;
            end else
            begin
              if ManaRange.too = 0 then ManaRange.too := 100;
              doHeal2 := (pMp >= ManaRange.from) and (pMp <= ManaRange.too) and doHeal1;
            end;
            if doHeal2 then   //we have mana and Health
            begin
              index := StringToCaseSelect(node.Find('cHealMethod').Text, settingsHealMethod);
              case index of

                 // spells
                0..(settingsHealMethodSpellCount-1):
                  begin
                    useSpell := true;
                    spell := xmlSpellList.Root.FindEx2('name',lowercase(settingsHealMethod[index])).Attribute['words'];
                  end;

                // items
                settingsHealMethodSpellCount..(length(settingsHealMethod)-1):
                  begin
                    useSpell := false;
                    itemid := xmlItemList.Root.FindEx2('name',lowercase(settingsHealMethod[index])).Attribute['id'];
             //       itemName := xmlItemList.Root.FindEx2('name',lowercase(settingsHealMethod[index])).Attribute['name'];
                    if length(itemid) = 0 then itemid := '0';
                  end;
              end;

              mNode := node.Find('sMethodPriority');

              value := node.Find('rSpamRate').Text;   // "r" cause is a Range

              tmp[0] := copy(value, 1, pos(' ', value) - 1);
              tmp[1] := copy(value, pos('to ', value) + 3, length(value));
              randomize();
              spamRate := RandomRange( StrToInt(tmp[0]), StrToInt(tmp[1]) );

              event.priority := StrToInt(mNode.Find('iPriority').Text);
              event.overridePriority := StrToInt(mNode.Find('iOverridePriority').Text);
              event.expireTime := StrToInt(mNode.Find('iExpireTime').Text);
              event.lifeTime := StrToInt(mNode.Find('iLifeTime').Text);
              event.eventType := StrToEventType(mNode.Find('cEventType').Text);
              if useSpell then
              begin
                if CD.canCast(spell, Round(Ping*(pingCon/100))) then
                event.script := 'cast("'+ spell +'")' else event.script:= '';
               // GUI.Player.setHealingEx(1000);
              //  inc(z);
              //  Main.label1.Caption:= inttostr (z);
              end
              else
              begin
          //      if I = 0 then I:=MAxint; //really high number
                event.script := 'useitem('+ itemId +')'; //for now it has to be in htkeys!
             //   X:= chat.ServerCount(itemName);
            //      if X<I then
              //    begin
              //    GUI.Player.setHealingEx(0);   //since we will spam the manas :/
              //    I:= X;
             //     end;
              //  inc(z);
              //  Main.label1.Caption:= inttostr (z);
              end;
              EvtQueue.insert( event );
            end;
          end;
        end;
      end;
    end;
    sleep(spamRate);
  end; //}
     except
        on exception: Exception do
        begin
      //  showmessage(exception.ToString);
        end;
    end;

end;

end.
