unit chat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Addresses, inputer,System.Math,StrUtils;

type
    TMessage = record
      sender: array[1..10,1..50] of string;
      msg: array[1..10,1..50] of string;
      level: array[1..10,1..50] of string;
      time: array[1..10,1..50] of string;
      channel: array[1..50] of string;   //u gonna open 50 damn chats? oh you slut.....
      type1: array[1..10,1..50] of string;
    end;
              {     TMessage = record
      sender: string;
      msg: string;
      level: string;
      time: string;
      channel: string;
      type1: string;
    end;    }

  TChat = class
  private

  public
function GetchatText: string;
function GetStatusBar: string;
    function isChannel( channel: string ): boolean;
    procedure say( text: string; channel: string='' );
  function GetMessages(): TMessage;
function SimulateWriting(word: string):boolean;
function ServerCount(itemname: string):integer;
  end;

implementation

uses
  Unit1;
function TChat.isChannel( channel: string ): boolean;
var
  addr: integer;
  name: string;
begin

  if channel = 'Default' then channel := 'Local Chat';
 addr := Memory.ReadPointer(Integer(ADDR_BASE) +  Addresses.guiPointer, [ $40, $30, $30, $30 ] );
  name := Memory.ReadString( addr );
  if (lowercase(name) <> lowercase(channel)) then
  result:= False
end;

procedure TChat.say( text: string; channel: string= '' );
var
  addr,z: integer;
  name: string;
begin

  if channel = 'Default' then channel := 'Local Chat';
  if channel = '' then     //for casting and so on :D
    begin
     SimulateWriting(text);
     exit;
    end;

                                          //fixed for 9.83
  addr := Memory.ReadPointer(Integer(ADDR_BASE) +  Addresses.guiPointer, [ $40, $30, $30, $30 ] );
  name := Memory.ReadString( addr );
  z:=0;
  while (lowercase(name) <> lowercase(channel)) and (z < 20) do
  begin
    Inputer.SendKey( VK_TAB );
    sleep(150);

    addr := Memory.ReadPointer(Integer(ADDR_BASE) +  Addresses.guiPointer, [ $40, $30, $30, $30 ] );
    name := Memory.ReadString( addr );
    z:=z+1;    //just so it doesn't loop 4ever in case the channel doesn't exist
  end;
  if z > 19 then exit;  //if channel doesn't exist don't fucking write a thing!

       SimulateWriting(text);
  //inputer.SendString( text );
  //inputer.SendKey(VK_RETURN);

end;

function TChat.GetchatText: string;
var
  num, num2, num3: Integer;
  chatText:string;
begin
    num := Memory.ReadInteger(Integer(ADDR_BASE) +guiPointer);
    num2 := Memory.ReadInteger((num + $40));
    num3 := Memory.ReadInteger(((num2 + $44)));
    num3 := Memory.ReadInteger(((num3 + $2c)));
    chatText := Memory.ReadString((num3));
 //   showmessage(chatText);
      Result := chatText;
end;

function TChat.GetStatusBar: string;
var
  time, num2, num3: Integer;
  StatusText:string;
begin
    StatusText := Memory.ReadString(Integer(ADDR_BASE) +lastStatusBar);
    //time til it dissapears
    time := Memory.ReadInteger(Integer(ADDR_BASE) +lastStatusBarTime);
 //   showmessage(inttostr(num));
if time <> 0 then           //if it isn't shown in screen anymore then gtfo u fucker ¬¬
      Result := StatusText
else Result:= '';
end;

function TChat.GetMessages(): TMessage;
var
  ptr,ptr2, name, addr,i,z,j,k,kmax,number: Integer;
  type2: byte;
  h: integer;
begin
     ptr := Memory.ReadPointer(Integer(ADDR_BASE) +  Addresses.guiPointer, [ $40, $3C ], true);
     ptr2:= ptr;
     kmax:= 0;     //here we reset the var for the next time we call this function....
          while ptr2 > 0 do
          begin
                ptr2 := Memory.ReadInteger(ptr2 + $10);  //next channel yo!
                kmax:= kmax +1;                         // let's check number of opened channels
          end;

            while (ptr > 0)   do
            for k := 1 to kmax do           //from first channel to last


            begin
                addr := Memory.ReadPointer(ptr, [$24, $10 ], false);
                result.channel[k] := Memory.ReadString(Memory.ReadInteger(ptr + $2C)); //actual channel
                number:= addr;
                //here we reset the var's for this new channel....
               i:=0;        //total number of msgs
               z:=0;       // number of msgs -5 (last 5msgs), we will see it later, don't worry bro...

                  while number > 0 do
                  begin
                    number := Memory.ReadInteger(number + $5C);
                    i:=i+1;   //this gives us the number of msgs in this chat
                  end;
                z:= (i- 10);     //yo, I just want last 10 msgs, don't come here with all ur bullshit

                while z > 0 do                //if there is just 1-5 msgs then don't do nothing!!!
                begin
                addr := Memory.ReadInteger(addr + $5C);    //kk, I don't want this msg, let's move to the next one
                z:=z-1;            //4msgs left til we begin taking them, 3msgs left, 2msgs,1, ready!
                end;

                while (addr > 0) do    //now begin taking the last 5 msgs
                for j:=10 downto 1 do

                begin
                  if trystrtoint(copy(memory.ReadString(addr + $8),0,1),h) =False then
                 break;

                    result.sender[j,k]:= Memory.ReadString(addr + $14);
                                  // showmessage(inttostr(z));
                    result.msg[j,k]:= Memory.ReadString(Memory.ReadInteger(addr + $4C));
                    result.level[j,k]:= Memory.ReadString(addr + $3C);
                    result.time[j,k]:= memory.ReadString(addr + $8);
                    type2:= Memory.ReadByte(addr + $4);
                      if type2 = 1 then
                        result.type1[j,k]:= 'Default'
                      else if type2 = 7 then
                        result.type1[j,k]:= 'Channel'
                      else if type2 = $13 then
                        result.type1[j,k]:= 'Info'
                      else if type2 = 5 then
                        result.type1[j,k]:= 'NPCtoplayer'
                      else if type2 = 6 then
                        result.type1[j,k]:= 'Private'
                      else if type2 = $10 then
                        result.type1[j,k]:= 'Raid_Advance'
                      else if type2 = 15 then
                        result.type1[j,k]:= 'RedAlert'
                      else if type2 = $15 then
                        result.type1[j,k]:= 'Send'
                      else if type2 = 0 then
                        result.type1[j,k]:= 'Status'
                      else if type2 = $12 then
                        result.type1[j,k]:= 'StatusLog'
                      else if type2 = $11 then
                        result.type1[j,k]:= 'Welcome'
                      else if type2 = 2 then
                        result.type1[j,k]:= 'Whisper'
                      else if type2 = 3 then
                        result.type1[j,k]:= 'Yell';

          //         showmessage(result.time[j,k]+'  j:'+inttostr(j)+'  k:'+inttostr(k));
                    addr := Memory.ReadInteger(addr + $5C);     //first msg, second, third...etc
               end;
                ptr := Memory.ReadInteger(ptr + $10);  //next channel yo!
            end;

//Messagetype (type1) = (CHANNEL=7, DEFAULT=1, INFO=$13, NPCTOPLAYER=5, PRIVATE=6, RAID_ADVANCE=$10, REDALERT=15,
// SEND=$15, STATUS=0, STATUSLOG=$12, WELCOME=$11, WHISPER=2, YELL=3);

{kk, so how the fuck do we use this function? just like this brah
for b:=1 to 50 do  //max number of channels
  begin
  for a:=1 to 5 do  //max number of msgs per channel
    chat.getmessages.msg[a,b];
  if chat.getmessages.channel[b] = null then break; //so we just read til last channel
  end;
}
end;


function Tchat.ServerCount(itemname: string):integer;
var
b,a,Begining,Ending: integer;
chat: Tchat;
info: string;
begin
result:= 0;
for b:=1 to 50 do  //max number of channels
  begin
  if chat.getmessages.channel[b] = 'Server Log' then break; //kk, if its the server log then stop counting!
  end;
for a:=1 to 10 do //max number of msgs in each channel
  begin      //take the first msg that has our itemname, then stop plx =(
  If AnsiContainsText(chat.getmessages.msg[a,b], itemname) then
    begin
    //let's parse it :D                   //13 chars of that "Using one of "
    Begining:= Ansipos('Using one of ',chat.getmessages.msg[a,b])+13;

    info:= Copy(chat.getmessages.msg[a,b], Begining,MaxInt);
    Ending:= Ansipos(' '+itemname,info);
    Delete(info,Ending,length(info));
    result:= strtoint(info);
    break;
    end;
  end;
//showmessage(chat.getmessages.msg[a,b]);
end;


//                        CORRECT WRITING IN CHAT like neo)

function Tchat.SimulateWriting(word: string):boolean;
var
s: string;
Length1: integer;
        begin
            s := GetChatText; //Current string in chat box.
            Length1 := Length(s);

            while (true) do
            begin
                if (s <> word) then// Start and keep writing while isn't the string target.
                begin
                    Length1 := Length(s);
                    if (s = copy(word,0,Length1)) then // If the current string match with the initial part of the string target, press next char.
                        inputer.SendKeyChar(ord(word[Length1+1]))
                    else  //press backspace otherwise.
                        inputer.SendKey(VK_Back);

                    Sleep(randomrange(40, 70));
                end
                else // If we already have our string target, press enter and break the method.
                begin
                        inputer.SendKey(VK_Return);
                    Sleep(randomrange(40, 70));
                    break;
                end;

                s := GetChatText; // recalculate the current string to press next char.
            end;
        end;
end.
