unit LuaSyn;

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
{$ELSE}
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
{$ENDIF}
  SysUtils,
  Classes;

type
  TtkTokenKind = (
    tkComment,
    tkIdentifier,
    tkKey,
    tkLuaMString,
    tkNull,
    tkNumber,
    tkOctal,
    tkHex,
    tkFloat,
    tkSpace,
    tkString,
    tkUnknown);

  TRangeState = (rsUnKnown, rsLuaComment, rsLuaMComment, rsLuaMString, rsString1, rsString2);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

const
  MaxKey = 110;

type
  TSynLuaSyn = class(TSynCustomHighlighter)
  private
    fLineRef: string;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    fRange: TRangeState;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fIdentFuncTable: array[0 .. MaxKey] of TIdentFuncTableFunc;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fLuaMStringAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func17: TtkTokenKind;
    function Func21: TtkTokenKind;
    function Func22: TtkTokenKind;
    function Func25: TtkTokenKind;
    function Func26: TtkTokenKind;
    function Func35: TtkTokenKind;
    function Func38: TtkTokenKind;
    function Func42: TtkTokenKind;
    function Func45: TtkTokenKind;
    function Func48: TtkTokenKind;
    function Func51: TtkTokenKind;
    function Func52: TtkTokenKind;
    function Func57: TtkTokenKind;
    function Func61: TtkTokenKind;
    function Func62: TtkTokenKind;
    function Func67: TtkTokenKind;
    function Func68: TtkTokenKind;
    function Func70: TtkTokenKind;
    function Func71: TtkTokenKind;
    function Func81: TtkTokenKind;
    function Func82: TtkTokenKind;
    function Func102: TtkTokenKind;
    function Func110: TtkTokenKind;
    procedure IdentProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure SpaceProc;
    procedure CRProc;
    procedure LFProc;
    procedure LuaCommentOpenProc;
    procedure LuaCommentProc;
    procedure LuaMCommentOpenProc;
    procedure LuaMCommentProc;
    procedure LuaMStringOpenProc;
    procedure LuaMStringProc;
    procedure String1OpenProc;
    procedure String1Proc;
    procedure String2OpenProc;
    procedure String2Proc;
    procedure NumberProc;
  protected
    function GetSampleSource: string; override;
    function IsFilterStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
    function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; override;
    function GetEol: Boolean; override;
    function GetKeyWords: string;
    function GetTokenID: TtkTokenKind;
    //procedure SetLine(NewValue: String; LineNumber: Integer); override;
    function GetToken: String; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property LuaMStringAttri: TSynHighlighterAttributes read fLuaMStringAttri write fLuaMStringAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

{$IFDEF SYN_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SYNS_FilterLua = 'Lua Files (*.lua, *.lpr)|*.lua;*.lpr';
  SYNS_LangLua = 'Lua';
  SYNS_AttrLuaMString = 'LuaMString';
  SYNS_AttrNumber = 'Numbers';

resourcestring
  SYNS_FriendlyAttrLuaMString = 'LuaMString';
  //SYNS_FriendlyAttrNumber = 'Numbers';


var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable : array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I: Char;
begin
  for I := #0 to #255 do
  begin
    case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else
      Identifiers[I] := False;
    end;
    case I in ['_', 'A'..'Z', 'a'..'z'] of
      True:
        begin
          if (I > #64) and (I < #91) then
            mHashTable[I] := Ord(I) - 64
          else if (I > #96) then
            mHashTable[I] := Ord(I) - 95;
        end;
    else
      mHashTable[I] := 0;
    end;
  end;
end;

procedure TSynLuaSyn.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do
  begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  fIdentFuncTable[17] := Func17;
  fIdentFuncTable[21] := Func21;
  fIdentFuncTable[22] := Func22;
  fIdentFuncTable[25] := Func25;
  fIdentFuncTable[26] := Func26;
  fIdentFuncTable[35] := Func35;
  fIdentFuncTable[38] := Func38;
  fIdentFuncTable[42] := Func42;
  fIdentFuncTable[45] := Func45;
  fIdentFuncTable[48] := Func48;
  fIdentFuncTable[51] := Func51;
  fIdentFuncTable[52] := Func52;
  fIdentFuncTable[57] := Func57;
  fIdentFuncTable[61] := Func61;
  fIdentFuncTable[62] := Func62;
  fIdentFuncTable[67] := Func67;
  fIdentFuncTable[68] := Func68;
  fIdentFuncTable[70] := Func70;
  fIdentFuncTable[71] := Func71;
  fIdentFuncTable[81] := Func81;
  fIdentFuncTable[82] := Func82;
  fIdentFuncTable[102] := Func102;
  fIdentFuncTable[110] := Func110;
end;

function TSynLuaSyn.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in ['_', 'a'..'z', 'A'..'Z'] do
  begin
    inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  fStringLen := ToHash - fToIdent;
end;

function TSynLuaSyn.KeyComp(const aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if Temp^ <> aKey[i] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end else Result := False;
end;

function TSynLuaSyn.Func17: TtkTokenKind;
begin
  if KeyComp('if') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func21: TtkTokenKind;
begin
  if KeyComp('do') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func22: TtkTokenKind;
begin
  if KeyComp('and') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func25: TtkTokenKind;
begin
  if KeyComp('in') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func26: TtkTokenKind;
begin
  if KeyComp('end') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func35: TtkTokenKind;
begin
  if KeyComp('or') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func38: TtkTokenKind;
begin
  if KeyComp('nil') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func42: TtkTokenKind;
begin
  if KeyComp('for') then Result := tkKey else
    if KeyComp('break') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func45: TtkTokenKind;
begin
  if KeyComp('else') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func48: TtkTokenKind;
begin
  if KeyComp('local') then Result := tkKey else
    if KeyComp('false') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func51: TtkTokenKind;
begin
  if KeyComp('then') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func52: TtkTokenKind;
begin
  if KeyComp('not') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func57: TtkTokenKind;
begin
  if KeyComp('loaddll') then Result := tkIdentifier else Result := tkIdentifier;
end;

function TSynLuaSyn.Func61: TtkTokenKind;
begin
  if KeyComp('asd') then Result := tkIdentifier else Result := tkIdentifier;
end;

function TSynLuaSyn.Func62: TtkTokenKind;
begin
  if KeyComp('while') then Result := tkKey else
    if KeyComp('print') then Result := tkIdentifier else
      if KeyComp('elseif') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func67: TtkTokenKind;
begin
  if KeyComp('asd') then Result := tkIdentifier else Result := tkIdentifier;
end;

function TSynLuaSyn.Func68: TtkTokenKind;
begin
  if KeyComp('true') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func70: TtkTokenKind;
begin
  if KeyComp('asd') then Result := tkIdentifier else
    if KeyComp('asd') then Result := tkIdentifier else
      if KeyComp('dofile') then Result := tkIdentifier else Result := tkIdentifier;
end;

function TSynLuaSyn.Func71: TtkTokenKind;
begin
  if KeyComp('repeat') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func81: TtkTokenKind;
begin
  if KeyComp('until') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func82: TtkTokenKind;
begin
  if KeyComp('asd') then Result := tkIdentifier else
    if KeyComp('asd') then Result := tkIdentifier else
      if KeyComp('beep') then Result := tkIdentifier else Result := tkIdentifier;
end;

function TSynLuaSyn.Func102: TtkTokenKind;
begin
  if KeyComp('return') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.Func110: TtkTokenKind;
begin
  if KeyComp('function') then Result := tkKey else Result := tkIdentifier;
end;

function TSynLuaSyn.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TSynLuaSyn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey <= MaxKey then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;
end;

procedure TSynLuaSyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      '-': fProcTable[I] := LuaCommentOpenProc;
      '[': fProcTable[I] := LuaMStringOpenProc;
      '"': fProcTable[I] := String1OpenProc;
      '''': fProcTable[I] := String2OpenProc;
      #1..#9, #11, #12, #14..#32 : fProcTable[I] := SpaceProc;
      '0'..'9': fProcTable[I] := NumberProc;
      'A'..'Z', 'a'..'z', '_': fProcTable[I] := IdentProc;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

procedure TSynLuaSyn.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    inc(Run);
  until not (fLine[Run] in [#1..#32]);
end;

procedure TSynLuaSyn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynLuaSyn.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TSynLuaSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynLuaSyn.LuaCommentOpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '-') and
     (fLine[Run + 1] = '[') and
     (fLine[Run + 2] = '[') then
  begin
    LuaMCommentOpenProc;
  end
  else if (fLine[Run] = '-') then
  begin
    fRange := rsLuaComment;
    LuaCommentProc;
    fTokenID := tkComment;
  end
  else
    fTokenID := tkIdentifier;
end;

procedure TSynLuaSyn.LuaCommentProc;
begin
  fTokenID := tkComment;
  repeat
    if (fLine[Run] = '@') and
       (fLine[Run + 1] = '') and
       (fLine[Run + 2] = '') and
       (fLine[Run + 3] = '') and
       (fLine[Run + 4] = '@') and
       (fLine[Run + 5] = '') and
       (fLine[Run + 6] = '') and
       (fLine[Run + 7] = '@') then
    begin
      Inc(Run, 8);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TSynLuaSyn.LuaMCommentOpenProc;
begin
  fRange := rsLuaMComment;
  LuaMCommentProc;
  fTokenID := tkComment;
end;

procedure TSynLuaSyn.LuaMCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = ']') and
           (fLine[Run + 1] = ']') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynLuaSyn.LuaMStringOpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '[') then
  begin
    fRange := rsLuaMString;
    LuaMStringProc;
    fTokenID := tkLuaMString;
  end
  else
    fTokenID := tkIdentifier;
end;

procedure TSynLuaSyn.LuaMStringProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkLuaMString;
      repeat
        if (fLine[Run] = ']') and
           (fLine[Run + 1] = ']') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynLuaSyn.NumberProc;
var
  idx1: Integer; // token[1]
  i: Integer;
begin
  idx1 := Run;
  Inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in
    ['0'..'9', 'A'..'F', 'a'..'f', '.', 'u', 'U', 'l', 'L', 'x', 'X', '-', '+'] do
  begin
    case FLine[Run] of
      '.':
        if FLine[Succ(Run)] = '.' then
          Break
        else
          if (fTokenID <> tkHex) then
            fTokenID := tkFloat
          else // invalid
          begin
            fTokenID := tkUnknown;
            Exit;
          end;
      '-', '+':
        begin
          if fTokenID <> tkFloat then // number <> float. an arithmetic operator
            Exit;
          if not (FLine[Pred(Run)] in ['e', 'E']) then
            Exit; // number = float, but no exponent. an arithmetic operator
          if not (FLine[Succ(Run)] in ['0'..'9', '+', '-']) then // invalid
          begin
            Inc(Run);
            fTokenID := tkUnknown;
            Exit;
          end
        end;
      '0'..'7':
        if (Run = Succ(idx1)) and (FLine[idx1] = '0') then // octal number
          fTokenID := tkNumber; // Jean-Franois Goulet - Changed for token Number because token Octal was plain text and cannot be modified...
      '8', '9':
        if (FLine[idx1] = '0') and
           ((fTokenID <> tkHex) and (fTokenID <> tkFloat)) then // invalid octal char
             fTokenID := tkUnknown;
      'a'..'d', 'A'..'D':
        if fTokenID <> tkHex then // invalid char
          Break;
      'e', 'E':
        if (fTokenID <> tkHex) then
          if FLine[Pred(Run)] in ['0'..'9'] then // exponent
          begin
            for i := idx1 to Pred(Run) do
              if FLine[i] in ['e', 'E'] then // too many exponents
              begin
                fTokenID := tkUnknown;
                Exit;
              end;
            if not (FLine[Succ(Run)] in ['0'..'9', '+', '-']) then
              Break
            else
              fTokenID := tkFloat
          end
          else // invalid char
            Break;
      'f', 'F':
        if fTokenID <> tkHex then
        begin
          for i := idx1 to Pred(Run) do
            if FLine[i] in ['f', 'F'] then // declaration syntax error
            begin
              fTokenID := tkUnknown;
              Exit;
            end;
          if fTokenID = tkFloat then
          begin
            if fLine[Pred(Run)] in ['l', 'L'] then // can't mix
              Break;
          end
          else
            fTokenID := tkFloat;
        end;
      'l', 'L':
        begin
          for i := idx1 to Pred(Run) do
            if FLine[i] in ['l', 'L'] then // declaration syntax error
            begin
              fTokenID := tkUnknown;
              Exit;
            end;
          if fTokenID = tkFloat then
            if fLine[Pred(Run)] in ['f', 'F'] then // can't mix
              Break;
        end;
      'u', 'U':
        if fTokenID = tkFloat then // not allowed
          Break
        else
          for i := idx1 to Pred(Run) do
            if FLine[i] in ['u', 'U'] then // declaration syntax error
            begin
              fTokenID := tkUnknown;
              Exit;
            end;
      'x', 'X':
        if (Run = Succ(idx1)) and   // 0x... 'x' must be second char
           (FLine[idx1] = '0') and  // 0x...
           (FLine[Succ(Run)] in ['0'..'9', 'a'..'f', 'A'..'F']) then // 0x... must be continued with a number
             fTokenID := tkHex
           else // invalid char
           begin
             if (not Identifiers[fLine[Succ(Run)]]) and
                (FLine[Succ(idx1)] in ['x', 'X']) then
             begin
               Inc(Run); // highlight 'x' too
               fTokenID := tkUnknown;
             end;
             Break;
           end;
    end; // case
    Inc(Run);
  end; // while
  if FLine[Run] in ['A'..'Z', 'a'..'z', '_'] then
    fTokenID := tkUnknown;
end;

procedure TSynLuaSyn.String1OpenProc;
begin
  Inc(Run);
  fRange := rsString1;
  String1Proc;
  fTokenID := tkString;
end;

procedure TSynLuaSyn.String1Proc;
begin
  fTokenID := tkString;
  repeat
    if (((fLine[Run] = '"') and (fLine[Run - 1] <> '\')) or ((fLine[Run - 1] = '\') and (fLine[Run - 2] = '\') and (fLine[Run] = '"'))) then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TSynLuaSyn.String2OpenProc;
begin
  Inc(Run);
  fRange := rsString2;
  String2Proc;
  fTokenID := tkString;
end;

procedure TSynLuaSyn.String2Proc;
begin
  fTokenID := tkString;
  repeat
    if (fLine[Run] = '''') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

constructor TSynLuaSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment, SYNS_FriendlyAttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clGray;
  AddAttribute(fCommentAttri);

  fIdentifierAttri := TSynHighLighterAttributes.Create(SYNS_AttrIdentifier, SYNS_FriendlyAttrIdentifier);
  AddAttribute(fIdentifierAttri);

  fKeyAttri := TSynHighLighterAttributes.Create(SYNS_AttrReservedWord, SYNS_FriendlyAttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);

  fLuaMStringAttri := TSynHighLighterAttributes.Create(SYNS_AttrLuaMString, SYNS_FriendlyAttrLuaMString);
  fLuaMStringAttri.Foreground := clNavy;
  AddAttribute(fLuaMStringAttri);

  fNumberAttri := TSynHighLighterAttributes.Create(SYNS_AttrNumber, SYNS_FriendlyAttrNumber);
  fNumberAttri.Foreground := clBlue;
  AddAttribute(fNumberAttri);

  fSpaceAttri := TSynHighLighterAttributes.Create(SYNS_AttrSpace, SYNS_FriendlyAttrSpace);
  AddAttribute(fSpaceAttri);

  fStringAttri := TSynHighLighterAttributes.Create(SYNS_AttrString, SYNS_FriendlyAttrString);
  fStringAttri.Foreground := clNavy;
  AddAttribute(fStringAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterLua;
  fRange := rsUnknown;
end;

procedure TSynLuaSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end;

procedure TSynLuaSyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynLuaSyn.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsLuaMComment: LuaMCommentProc;
    rsLuaMString: LuaMStringProc;
  else
    begin
      fRange := rsUnknown;
      fProcTable[fLine[Run]];
    end;
  end;
end;

function TSynLuaSyn.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER : Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD    : Result := fKeyAttri;
    SYN_ATTR_STRING     : Result := fStringAttri;
    SYN_ATTR_WHITESPACE : Result := fSpaceAttri;
  else
    Result := nil;
  end;
end;

function TSynLuaSyn.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynLuaSyn.GetKeyWords: string;
begin
  Result :=
    'and,break,do,dofile,else,elseif,end,exit,false,for,function,if,in,loa' +
    'ddll,local,nil,not,or,print,repeat,return,Sleep,then,true,type,until,w' +
    'hile';
end;

function TSynLuaSyn.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynLuaSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynLuaSyn.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkLuaMString: Result := fLuaMStringAttri;
    tkNumber, tkFloat: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkUnknown: Result := fIdentifierAttri;
  else
    Result := nil;
  end;
end;

function TSynLuaSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynLuaSyn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TSynLuaSyn.GetSampleSource: string;
begin
  Result := 'Sample source for: '#13#10 +
            'Lua Syntax Parser/Highlighter';
end;

function TSynLuaSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterLua;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TSynLuaSyn.GetLanguageName: string;
begin
  Result := SYNS_LangLua;
end;

procedure TSynLuaSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynLuaSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynLuaSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynLuaSyn);
{$ENDIF}
end.
