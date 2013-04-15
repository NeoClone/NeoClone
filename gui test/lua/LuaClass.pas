unit LuaClass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Memory, guiclass, inputer, addresses, lua, lualib,
  Menus, log, chat, containers;

type
  TLuaScripter = class(TLua)
  published
                // here is where I have to write all the damn functions xD

    procedure ddd(LuaState: TLuaState);

    procedure print(LuaState: TLuaState);

    // text
    procedure cast(LuaState: TLuaState);

    // items
    procedure useitem(LuaState: TLuaState);

    procedure test1();
    procedure test2();
    procedure queuetest1();
    procedure say(LuaState: TLuaState);
  end;
  var
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

procedure TLuaScripter.ddd(LuaState: TLuaState);
begin
  showmessage('yupi!');
end;

procedure TLuaScripter.cast(LuaState: TLuaState);
var
  spell: string;
  hkIdent: integer;
begin

  spell := Lua_ToString(LuaState, 1);
  hkIdent := TibiaHotKey.Find(spell);

  if hkIdent > -1 then
  begin
    TibiaHotKey.ID := hkIdent;
    TibiaHotKey.ExecuteHotkey;
    sleep(50);
    if not TibiaHotKey.SendAutomatically then
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


procedure TLuaScripter.test1();
begin
  Inputer.SendString(' X ');
  sleep(1000);
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

procedure TLuaScripter.test2();
begin
  Inputer.SendString(' Z ');
  sleep(1000);
end;

procedure TLuaScripter.queuetest1;
begin

  while true do
  begin
    sleep(1000);
    Inputer.SendKeyChar(ord('X'));
  end;

end;


end.
