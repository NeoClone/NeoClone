unit netmsg;

interface

uses
  WinSock, Math, SysUtils, Dialogs, addresses, winapi.windows;

const
  MAXNETMSG_SIZE = 16384;

type
  TPacket = record
    buf: TBytes;
    len: integer;
  end;

  TNetMsg = class(TObject)
  public
    amsgsize, adatasize, areadpos : integer;
    amsgbuf : array[1..MAXNETMSG_SIZE] of byte;
    checksum: integer;

    procedure LoadPacket(p: TPacket);

    procedure Reset;
    procedure Dump(fn : string);
    procedure Skip(numbytes : word);
    procedure SkipString;
    procedure SkipOutfit;
    procedure SkipMount;
    procedure SkipLocation(x: integer = -1; y: integer = -1; z: integer = -1);
    procedure SkipItem( id: integer = -1 );
    procedure SkipMarketOffer( t: word );
    procedure SkipCreature( typ: integer = -1 );

    function isEOP : boolean;

    function GetByte : byte;
    function GetU16 : word;
    function GetU32 : cardinal;
    function GetString : string;
    function GetLocation : TLocation;

    function PeekByte : byte;
    function PeekU16 : word;
    function PeekU32 : cardinal;
    function PeekString : string;

    function GetByteOnPos(iPos: integer) : byte;

    procedure PutByte(B : byte);
    procedure PutU16(I : word);
    procedure PutU32(I : cardinal);
    procedure PutString(S : string);

    procedure OverwriteByte(b : byte);
    procedure OverwriteU16(i : word);
    procedure OverwriteU32(i : cardinal);
    procedure OverwriteString(S : string);

    function GetReadPos(): integer;
    procedure SetReadPos(i: integer);
    function GetPacketLength(): integer;

    function toString(): string;

    constructor Create; reintroduce; virtual;
    Destructor  Destroy; override;
  end;

implementation

uses
  unit1;

constructor TNetMsg.Create;
begin
  inherited Create;
  Reset;
end;

destructor TNetMsg.Destroy;
begin
  inherited;
end;

procedure TNetMsg.LoadPacket(p: TPacket);
var
  i: integer;
begin
  reset();
  for i := 1 to p.len do
  begin
    amsgbuf[i] := p.buf[i-1];
  end;

  areadpos := 1;
  amsgsize := p.len;
end;

procedure TNetMsg.Reset;
begin
    fillchar(amsgbuf,MAXNETMSG_SIZE,0);
    amsgsize := 0;
    adatasize := 0;
    areadpos := 0;
end;

procedure TNetMsg.Dump(fn : string);
var wbuf : array[1..1024] of byte; i, s : integer; f : file of byte;
begin
  assignfile(f, fn);
  rewrite(f);
  s := 0;
  repeat
    i := min(1024, amsgsize - s);
    move( (@amsgbuf[s+1])^, (@wbuf[1])^, i);
    blockwrite(f, wbuf, i);
    inc(s, i);
  until s = amsgsize + 2;
  closefile(f);
end;

procedure TNetMsg.Skip(numbytes : word);
begin
inc(areadpos,numbytes);
end;

procedure TNetMsg.SkipString;
var i : word;
begin
  i := getu16;
  skip(i);
end;

procedure TNetMsg.SkipOutfit;
var i : word;
begin
  i := getu16;
  if i <> 0 then // player
  begin
    skip(1); // head
    skip(1); // body
    skip(1); // legs
    skip(1); // feet
    skip(1); // addons
  end
  else
  begin
    skip(2); // creature outfit
  end;
end;

procedure TNetMsg.SkipMount;
begin
  Skip(2);
end;

procedure TNetMsg.SkipLocation(x: integer = -1; y: integer = -1; z: integer = -1);
begin
  if x = -1 then
    skip(2);
  if y = -1 then
    skip(2);
  if z = -1 then
    skip(1);
end;

procedure TNetMsg.SkipItem( id: integer = -1 );
begin
  if id = -1 then
    id := GetU16(); // item id
  if DatTiles[id].totalExtraBytes > 0 then
    skip(DatTiles[id].totalExtraBytes); // count
end;

procedure TNetMsg.SkipMarketOffer( t: word );
begin
  Skip(4);
  Skip(2);
  case t of
    65534, // REQUEST_OWN_OFFERS
    65535: // REQUEST_OWN_HISTORY
      begin
        Skip(2);
      end;
  end;

  Skip(2);
  Skip(4);
  case t of
    65534: ; // do nothing REQUEST_OWN_OFFERS
    65535: // REQUEST_OWN_HISTORY
      begin
        Skip(1);
      end;
    else
      begin
        SkipString();
      end;
  end;
end;

procedure TNetMsg.SkipCreature( typ: integer = -1 );
var
  tmpStr: array[0..10] of string;
  tmpInt: array[0..10] of integer;
  tmpWord: array[0..10] of word;
begin
  if typ = -1 then
    typ := GetU16();
  case typ of

    97: // UNKNOWNCREATURE
      begin
        Skip(4);
        Skip(4);
        Skip(1);
        SkipString();
        Skip(1);
        Skip(1);
        SkipOutfit();
        SkipMount();
        Skip(1);
        Skip(1);
        Skip(2);
        Skip(1);
        Skip(1);
        Skip(1);
        Skip(1);
      end;

    98: // OUTDATEDCREATURE
      begin
        Skip(4);
        Skip(1);
        Skip(1);
        SkipOutfit();
        SkipMount();
        Skip(1);
        Skip(1);
        Skip(2);
        Skip(1);
        Skip(1);
        Skip(1);
      end;

    99: // CREATURE
      begin
        Skip(4);
        Skip(1);
      end;

  end;
end;

function TNetMsg.isEOP : boolean;
begin
  result := NOT (areadpos < (amsgsize));
end;

function TNetMsg.GetByte : byte;
begin
    result := amsgbuf[areadpos];
    inc(areadpos,1);
end;

function TNetMsg.GetU16 : word;
begin
result := word(amsgbuf[areadpos] or
                (amsgbuf[areadpos+1] shl 8));
inc(areadpos,2);
end;

function TNetMsg.GetU32 : cardinal;
begin
result := cardinal(amsgbuf[areadpos] or
                    (amsgbuf[areadpos+1] shl 8) or
                    (amsgbuf[areadpos+2] shl 16) or
                    (amsgbuf[areadpos+3] shl 24));
inc(areadpos,4);
end;

function TNetMsg.GetString : string;
var tam,a : integer;
begin
tam := getu16;

{ temporario, ate eu achar um metodo pra ler }
  setlength(result,tam);
  for a := 1 to tam do
   result[a] := chr(GetByteOnPos(areadpos+a-1));
{ end temp }

//result := copy(amsgbuf, areadpos, tam);
inc(areadpos,tam);
end;

function TNetMsg.GetLocation : TLocation;
begin
  result.x := GetU16(); // x
  result.y := GetU16(); // y
  result.z := GetByte(); // z
end;

function TNetMsg.PeekByte : byte;
begin
    result := amsgbuf[areadpos];
end;

function TNetMsg.PeekU16 : word;
begin
result := word(amsgbuf[areadpos] or
                (amsgbuf[areadpos+1] shl 8));
end;

function TNetMsg.PeekU32 : cardinal;
begin
result := cardinal(amsgbuf[areadpos] or
                    (amsgbuf[areadpos+1] shl 8) or
                    (amsgbuf[areadpos+2] shl 16) or
                    (amsgbuf[areadpos+3] shl 24));
end;

function TNetMsg.PeekString : string;
var tam,a : integer;
begin
tam := getu16;

{ temporario, ate eu achar um metodo pra ler }
  setlength(result,tam);
  for a := 1 to tam do
   result[a] := chr(GetByteOnPos(areadpos+a-1));
{ end temp }

//result := copy(amsgbuf, areadpos, tam);
dec(areadpos,2);
end;

function TNetMsg.GetByteOnPos(iPos: integer) : byte;
begin
    result := amsgbuf[iPos];
end;

procedure TNetMsg.PutByte(b : byte);
begin
amsgbuf[areadpos] := b;
inc(areadpos,1);
inc(amsgsize,1);
inc(adatasize, 1);
end;

procedure TNetMsg.PutU16(i : word);
begin
amsgbuf[areadpos] := byte(i);
amsgbuf[areadpos+1] := byte(i shr 8);
inc(areadpos,2);
inc(amsgsize,2);
inc(adatasize, 2);
end;

procedure TNetMsg.PutU32(i : cardinal);
begin
amsgbuf[areadpos] := byte(i);
amsgbuf[areadpos+1] := byte(i shr 8);
amsgbuf[areadpos+2] := byte(i shr 16);
amsgbuf[areadpos+3] := byte(i shr 24);
inc(areadpos,4);
inc(amsgsize,4);
inc(adatasize, 4);
end;

procedure TNetMsg.PutString(s : string);
var tam,a : integer;
begin
tam := length(s);
putu16(tam);
{ temporario, ate achar um metodo possivel }
for a := 1 to tam do
  amsgbuf[areadpos+a-1] := ord(s[a]);
{ end if }
//insert(s,amsgbuf,areadpos);
inc(areadpos,tam);
inc(amsgsize,tam);
inc(adatasize, tam);
end;

procedure TNetMsg.OverwriteByte(b : byte);
begin
amsgbuf[areadpos] := b;
inc(areadpos,1);
end;

procedure TNetMsg.OverwriteU16(i : word);
begin
amsgbuf[areadpos] := byte(i);
amsgbuf[areadpos+1] := byte(i shr 8);
inc(areadpos,2);
end;

procedure TNetMsg.OverwriteU32(i : cardinal);
begin
amsgbuf[areadpos] := byte(i);
amsgbuf[areadpos+1] := byte(i shr 8);
amsgbuf[areadpos+2] := byte(i shr 16);
amsgbuf[areadpos+3] := byte(i shr 24);
inc(areadpos,4);
end;

procedure TNetMsg.OverwriteString(s : string);
var tam,a : integer;
begin
  tam := length(s);
  putu16(tam);

  for a := 1 to tam do
      amsgbuf[areadpos+a-1] := ord(s[a]);
end;

function TNetMsg.GetReadPos(): integer;
begin
    result := areadpos;
end;

procedure TNetMsg.SetReadPos(i: integer);
begin
    areadpos := i;
end;

function TNetMsg.GetPacketLength(): integer;
begin
    result := amsgsize+4;
end;

function TNetMsg.toString(): string;
var
    i: integer;
begin
    result := '';

    for i := 1 to GetPacketLength() do
    begin
        if areadpos = i then
          result := result + '[' +inttohex(amsgbuf[i], 2) + '] '
        else
          result := result + inttohex(amsgbuf[i], 2) + ' ';
    end;
end;

end.
