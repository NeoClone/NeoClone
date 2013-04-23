unit contextmenus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Addresses;

type
  TContextMenu = class
  private

  public
//    function getSize(): TRect;
    function isMenu(): boolean;
    function Name(): string;
//    function itemRect( name: string ): TRect;

//    function contextMenu( menuItem: string; itemId: integer; locationFrom: string; index: integer = 0 ): boolean;
  end;

implementation

uses
  unit1;


function TContextMenu.isMenu(): boolean;
var
value: integer;
begin
  result:= False;
  value:= Memory.ReadInteger(Integer(ADDR_BASE) +  Addresses.Dialog);
   if (value = 12) or (value = 11) then
      result :=  True;
end;

function TContextMenu.Name(): string;
var
value: integer;
begin
  result:= '';
  if gui.ContextMenu.isMenu then  //if there is a Menu opened
    begin
      value:= Memory.ReadInteger(Integer(ADDR_BASE) +  Addresses.Dialog);
      if value = 11 then    //only take name if is NOT right click menu (ctrl+R.click also)
        begin
        value:= Memory.ReadInteger(Integer(ADDR_BASE) +  Addresses.DialogPointer);
        result:= Memory.ReadString(value + $54);
        end;
    end;
end;
                          {
function TContextMenu.getSize(): TRect;
var
  addr: integer;
begin
  addr := Memory.ReadInteger(Integer(ADDR_BASE) +  addresses.dialogPointer );

  result.Left := Memory.ReadInteger( addr + $14 );
  result.Top := Memory.ReadInteger( addr + $18 );
  result.Right := Memory.ReadInteger( addr + $1C );
  result.Bottom := Memory.ReadInteger( addr + $20 );
end;

function TContextMenu.isMenu(): boolean;
begin
  result := (Memory.ReadPointer(Integer(ADDR_BASE) +  Addresses.dialogPointer, [ $40 ] ) = 0);
end;

function TContextMenu.itemRect( name: string ): TRect;
var
  addr: integer;
  str: string;
  height: integer;
  r: TRect;
begin
  r := getSize();
  result.Top := r.Top + 4;
  result.Left := r.Left + 4;
  result.Right := r.Right;
  result.Bottom := 19;
  height := 4;

  addr := Memory.ReadPointer(Integer(ADDR_BASE) +  Addresses.dialogPointer, [ $24 ] );
  while addr <> 0 do
  begin
    str := Memory.ReadString( addr + Addresses.contextMenuItemName );

    if pos(lowercase(name), lowercase(str)) > 0 then break;

    height := height + memory.ReadInteger( addr + $20 );

    addr := Memory.ReadInteger( addr + $10 );
  end;

  result.Top := r.Top + height;
end;

function TContextMenu.contextMenu( menuItem: string; itemId: integer; locationFrom: string; index: integer = 0 ): boolean;
begin

end;
      }
end.
