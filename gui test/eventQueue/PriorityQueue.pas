unit PriorityQueue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TEventType = ( etNormal, etUrgent );
  TEvent = record
    id: integer;
    priority: integer;
    overridePriority: integer;
    addTimeStamp: Cardinal;
    expireTime: Cardinal;
    startTimeStamp: Cardinal;
    lifeTime: Cardinal;
    eventType: TEventType;
    script: string;
    shuffledDeletion: boolean;
  end;

  TPriorityQueue = class
    FQueue: array of TEvent;
  private
    //FQueue: array of TEvent;
  public
    function insert( event: TEvent ): integer;
    procedure delete( index: integer );
    function maxPriority: integer;
    function countEvents: integer;

    function CountShuffledDeletion: integer;
    function GetFirstShuffledDeletion: integer;

    function pop( index: integer = -1 ): TEvent;
  end;

function StrToEventType( str: string ): TEventType;
implementation

function StrToEventType( str: string ): TEventType;
begin
  if pos(lowercase('Normal'), lowercase(str)) > 0 then
    result := etNormal
  else
    result := etUrgent;
end;

function TPriorityQueue.insert(event: TEvent): integer;
var
  res: integer;
begin

  SetLength(FQueue, length(FQueue) + 1);
  res := length(FQueue) - 1;

  randomize();
  FQueue[res].id := random(999999);
  FQueue[res].priority := event.priority;
  FQueue[res].overridePriority := event.overridePriority;
  FQueue[res].addTimeStamp := event.addTimeStamp;
  FQueue[res].expireTime := event.expireTime;
  FQueue[res].startTimeStamp := event.startTimeStamp;
  FQueue[res].lifeTime := event.lifeTime;
  FQueue[res].eventType := event.eventType;
  FQueue[res].script := event.script;
  FQueue[res].shuffledDeletion := false;

  result := res;
end;


procedure TPriorityQueue.delete( index: integer );
var
  i: integer;
begin

  // je¿eli podajemy z³¹ wartoœæ wtedy exit
  if index >= length(FQueue) then exit;
  //if index < 0 then exit;

  // przesuwamy wszystkie obiekty by móc skróciæ tablice
  if index = High(FQueue) then
    SetLength(FQueue, length(FQueue) - 1)
  else
  begin
    for i := index to High(FQueue) - 1 do
      FQueue[i] := FQueue[i + 1];
    SetLength(FQueue, length(FQueue) - 1);
  end;

end;


function TPriorityQueue.maxPriority: integer;
var
  i, maxId, lastmax: integer;
begin
  maxId := 0;
  lastmax := -1;
  for i := 0 to length(FQueue)-1 do
  begin
    if FQueue[i].eventType = etUrgent then
    begin
      result := i;
      exit;
    end;

    if lastmax < FQueue[i].priority then
    begin
      maxId := i;
      lastmax := FQueue[i].priority;
    end;
  end;
  result := maxId;
end;


function TPriorityQueue.countEvents: integer;
begin
  result := length(FQueue);
end;


function TPriorityQueue.pop( index: integer = -1 ): TEvent;
var
  id: integer;
begin

  if index > -1 then
  begin
    result := FQueue[index];
    delete( index );
    exit;
  end;

  id := maxPriority();
  result := FQueue[id];
  delete(id);

end;


function TPriorityQueue.CountShuffledDeletion: integer;
var
  i, count: integer;
begin

  count := 0;
  for i := 0 to countEvents-1 do
  begin
    if FQueue[i].shuffledDeletion then
    begin
      count := count + 1;
    end;
  end;

  result := count;

end;


function TPriorityQueue.GetFirstShuffledDeletion: integer;
var
  i: integer;
begin

  result := -1;
  for i := 0 to countEvents-1 do
  begin
    if FQueue[i].shuffledDeletion then
    begin
      result := i;
    end;
  end;

end;


end.
