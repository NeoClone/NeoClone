unit LuaClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Memory, guiclass, inputer, addresses, lua, lualib,
  Menus, log, chat, containers,settingsFormUnit;

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
    procedure say(LuaState: TLuaState);
  end;
  var
  tree: TsettingsForm;
  chat: TChat;
  Container: TContainers;

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
chat.say(spell);
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
  Container.useItem(itemID, itemlocation, uselocation)
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
chat.say(word,channel);
end;


end.
