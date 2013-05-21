unit LuaClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Memory, guiclass, inputer, addresses, lua, lualib,
  Menus, log, eventQueue, PriorityQueue,settingsFormUnit;

type
  TLuaScripter = class(TLua)
  published
                // here is where I have to write all the damn functions xD


    procedure print(LuaState: TLuaState);

    // text
    procedure cast(LuaState: TLuaState);

    // items
    procedure useitem(LuaState: TLuaState);

    function getsetting(LuaState: TLuaState): integer;
    procedure setsetting(LuaState: TLuaState);
    procedure setpriority(LuaState: TLuaState);
    procedure say(LuaState: TLuaState);
  end;
  var
  tree: TsettingsForm;

implementation

uses
  Unit1;

procedure TLuaScripter.print(LuaState: TLuaState);
begin
  // not thread safe.
  AddLog( colorBlack, Lua_ToString(LuaState, 1) );
end;

{
  spells
}

procedure TLuaScripter.cast(LuaState: TLuaState);
var
  spell: string;
  hkIdent: integer;
begin

  spell := Lua_ToString(LuaState, 1);
  hkIdent := Gui.TibiaHotKey.Find(spell);

  if hkIdent > -1 then
  begin
    Gui.TibiaHotKey.ID := hkIdent;
    Gui.TibiaHotKey.ExecuteHotkey;
    sleep(50);
    if not Gui.TibiaHotKey.SendAutomatically then
      inputer.SendKey(VK_RETURN);
  end else
  begin
Gui.Chat.say(spell);
  end;

end;


{
  items
}

procedure TLuaScripter.useitem(LuaState: TLuaState);
var
  itemID: integer;
  itemlocation: string;
  uselocation: string;
begin
  itemID := Lua_ToInteger(LuaState, 1);
  itemlocation := Lua_ToString(LuaState, 2);
  uselocation := Lua_ToString(LuaState, 3);
  //
  Gui.Containers.useItem(itemID, itemlocation, uselocation)
end;

                             //for scripts
procedure TLuaScripter.setpriority(LuaState: TLuaState);
var
Priority, OverridePriority, ExpireTime, LifeTime, EventType: string;
event: TEvent;
begin
  Priority := Lua_ToString(LuaState, 1);
  OverridePriority := Lua_ToString(LuaState, 2);
  ExpireTime := Lua_ToString(LuaState, 3);
  LifeTime := Lua_ToString(LuaState, 4);
  EventType := Lua_ToString(LuaState, 5);
  //(TO DO) not sure if this goes here or in ScriptThreadUnit.pas
//              event.priority := StrToInt(mNode.Find('iPriority').Text);
//              event.overridePriority := StrToInt(mNode.Find('iOverridePriority').Text);
//              event.expireTime := StrToInt(mNode.Find('iExpireTime').Text);
//              event.lifeTime := StrToInt(mNode.Find('iLifeTime').Text);
//              event.eventType := StrToEventType(mNode.Find('cEventType').Text);
//              event.script := 'cast("'+ spell +'")' else event.script:= '';
//                EvtQueue.insert( event );
//tree.SETsetting(path,value);
end;


procedure TLuaScripter.setsetting(LuaState: TLuaState);
var
value, path: string;
begin
  path := Lua_ToString(LuaState, 1);
  value := Lua_ToString(LuaState, 2);
tree.SETsetting(path,value);
end;

function TLuaScripter.getsetting(LuaState: TLuaState): integer;
var
path,stri: string;
i: integer;
begin           //getsetting('Targeting/TargetingEnabled')
  path := Lua_ToString(LuaState, 1);
stri:= tree.GETsetting(path);
lua_pushlstring(LuaState,Pansichar(ansistring(stri)),length(stri));
result:= 1;
end;

procedure TLuaScripter.say(LuaState: TLuaState);
var
  word: string;
  channel: string;
begin
  word := Lua_ToString(LuaState, 1);
  channel := Lua_ToString(LuaState, 2);
Gui.Chat.say(word,channel);
end;


end.
