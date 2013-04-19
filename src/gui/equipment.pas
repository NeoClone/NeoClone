unit equipment;

interface
                                 {all from Insanus Bot}
uses Memory, Types,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, containers, chat, gamewindow, player, contextmenus, addresses;

type
  TGUIEquipment = class
  private
    function GetEquipmentMinimized: Boolean;
    function GetEquipmentPos: TPoint;
    function GetAmuletPos: TPoint;
    function GetHelmetPos: TPoint;
    function GetBackpackPos: TPoint;
    function GetLHandPos: TPoint;
    function GetArmorPos: TPoint;
    function GetRHandPos: TPoint;
    function GetRingPos: TPoint;
    function GetLegsPos: TPoint;
    function GetArrowPos: TPoint;
    function GetBootsPos: TPoint;
  published
    property EquipmentPosition: TPoint read GetEquipmentPos;
    property EqAmuletPosition: TPoint read GetAmuletPos;
    property EqHelmetPosition: TPoint read GetHelmetPos;
    property EqBackpackPosition: TPoint read GetBackpackPos;
    property EqLHandPosition: TPoint read GetLHandPos;
    property EqArmorPosition: TPoint read GetArmorPos;
    property EqRHandPosition: TPoint read GetRHandPos;
    property EqRingPosition: TPoint read GetRingPos;
    property EqLegsPosition: TPoint read GetLegsPos;
    property EqArrowPosition: TPoint read GetArrowPos;
    property EqBootsPosition: TPoint read GetBootsPos;
    property EquipmentMinimized: Boolean read GetEquipmentMinimized;
    var

  Memory: TMemory;
  end;

implementation

uses Unit1;

function TGUIEquipment.GetEquipmentMinimized: Boolean;
var
  one: Integer;
begin
  Result := False;
  one := Memory.ReadInteger(Integer(ADDR_BASE) + Addresses.guiPointer);
  one := Memory.ReadInteger(one + $1AC);
  one := Memory.ReadInteger(one + $74);
  if (one = 0) then
  begin
    Result := True;
  end;
end;

function TGUIEquipment.GetEquipmentPos: TPoint;
var
  Res: TPoint;
  one: Integer;
begin
  Res.X := 0;//GUI.Window.Width - 170;
  if EquipmentMinimized then
  begin
    one := Memory.ReadInteger(Integer(ADDR_BASE) + Addresses.guiPointer);
    one := Memory.ReadInteger(one + $1AC);
    one := Memory.ReadInteger(one + $74);
    one := Memory.ReadInteger(one + $10);
    one := Memory.ReadInteger(one + $C);
    one := Memory.ReadInteger(one + $18);
    Res.Y := one + 7;
  end
  else
  begin
    one := Memory.ReadInteger(Integer(ADDR_BASE) + Addresses.guiPointer);
    one := Memory.ReadInteger(one + $19C);
    one := Memory.ReadInteger(one + $114);
    one := Memory.ReadInteger(one + $22C);
    one := Memory.ReadInteger(one + $C);
    one := Memory.ReadInteger(one + $18);
    Res.Y := one + 7;
  end;
  Result := Res;
end;

function TGUIEquipment.GetAmuletPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 10;
  Res.Y := Res.Y + 25;
  Result := Res;
end;

function TGUIEquipment.GetHelmetPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 50;
  Res.Y := Res.Y + 13;
  Result := Res;
end;

function TGUIEquipment.GetBackpackPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 86;
  Res.Y := Res.Y + 29;
  Result := Res;
end;

function TGUIEquipment.GetRHandPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 15;
  Res.Y := Res.Y + 61;
  Result := Res;
end;

function TGUIEquipment.GetArmorPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 50;
  Res.Y := Res.Y + 50;
  Result := Res;
end;

function TGUIEquipment.GetLHandPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 87;
  Res.Y := Res.Y + 64;
  Result := Res;
end;

function TGUIEquipment.GetRingPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 13;
  Res.Y := Res.Y + 101;
  Result := Res;
end;

function TGUIEquipment.GetLegsPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 51;
  Res.Y := Res.Y + 86;
  Result := Res;
end;

function TGUIEquipment.GetArrowPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 87;
  Res.Y := Res.Y + 103;
  Result := Res;
end;

function TGUIEquipment.GetBootsPos: TPoint;
var
  Res: TPoint;
begin
  Res := EquipmentPosition;
  Res.X := Res.X + 51;
  Res.Y := Res.Y + 125;
  Result := Res;
end;

end.