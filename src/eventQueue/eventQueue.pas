unit eventQueue;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PriorityQueue;

type
  TWatchDog = class(TThread)
  public

  protected
    procedure Execute; override;
  end;

  TQueueExecutor = class(TThread)
  public
    FEvent: TEvent;
    FRunningEvent: boolean;
  protected
    procedure Execute; override;
  end;

  TEventQueue = class
  private

  public
    function insert( event: TEvent ): integer;
  published
    constructor Create; overload;
    destructor Destroy; override;
  end;

var
  FPriorityQueue: TPriorityQueue;
  FQueueExecutor: TQueueExecutor;
  FWatchDog: TWatchDog;

implementation

uses
  unit1;

{
   This method of killing is totally g threadu the stupid and causes memory leaks ...
   This would not prevent the for the long-u ¿s the long run ...

   as will disturb, cause problems to separate the events for a few threadów

   - Treatment with 1 thread
   - Attacking two thread
   - Looted and scripts 3 thread ...

   but it's a necessity
}
procedure TWatchDog.Execute;
var
  delCount, item: integer;
begin

  while not Terminated do
  begin{
       Save the also because our systems. Totally silly g of Solution.
       He could not understand how the EKX such wpaœæ something ... the industry although this is?

       oh the bed of the problems ... I tell you the bed ... my mention of the word ...
     }

      sleep (1);   //else this it will eat 50% of the CPU
     // Life time or if the event takes too long to kill the thread and creates anew
    if FQueueExecutor.FRunningEvent then
    begin
      if ( GetTickCount >= (FQueueExecutor.FEvent.startTimeStamp + FQueueExecutor.FEvent.lifeTime)) then
      begin
        FQueueExecutor.FRunningEvent := false;
        FQueueExecutor.Terminate;
        terminatethread(FQueueExecutor.Handle, 0);
        FQueueExecutor.Free;

        FQueueExecutor := TQueueExecutor.Create(true);
        FQueueExecutor.Start;
      end;
    end;

    synchronize(
        procedure
        var
          i: integer;
        begin

          if FPriorityQueue.countEvents > 0 then
          begin
            for i := 0 to FPriorityQueue.countEvents-1 do
            begin
              if (GetTickCount >= ( FPriorityQueue.FQueue[i].addTimeStamp + FPriorityQueue.FQueue[i].expireTime )) then
              begin
                FPriorityQueue.FQueue[i].shuffledDeletion := true;
              end;
            end;

{
               I think of doing this can be different, for example:
               retrieve a tables index shuffledDeletion then
               with each subtract -1 to delete INDEX no (count)

               I have this industry
             }
            delCount := FPriorityQueue.CountShuffledDeletion();
            for i := 0 to delCount-1 do
            begin
              item := FPriorityQueue.GetFirstShuffledDeletion();
              FPriorityQueue.delete( item );
            end;

          end;

        end
    );

  end;

end;

procedure TQueueExecutor.Execute;
var
  dummy: TEvent;
begin

  while not Terminated do
  begin
    FEvent := dummy;
    FRunningEvent := false;
    sleep(1);
    if FPriorityQueue.countEvents > 0 then
    begin
      synchronize(
        procedure
        begin
          FEvent := FPriorityQueue.pop();
          FEvent.startTimeStamp := GetTickCount;
        end
      );
      FRunningEvent := true;
      LuaScript.DoString( FEvent.script );
    end;
  end;

end;

constructor TEventQueue.Create;
begin
  inherited;
  FQueueExecutor := TQueueExecutor.Create(true);
  FWatchDog := TWatchDog.Create(true);
  FPriorityQueue := TPriorityQueue.Create;
  FQueueExecutor.Start;
  FWatchDog.Start;
end;

destructor TEventQueue.Destroy;
begin
  FWatchDog.Free;
  FPriorityQueue.Free;
  FQueueExecutor.Free;
  inherited;
end;

function TEventQueue.insert( event: TEvent ): integer;
var
  OverrideEvent: boolean;
begin
  OverrideEvent := false;
  event.addTimeStamp := GetTickCount;
  result := FPriorityQueue.insert( event );

  if (FQueueExecutor.FRunningEvent) then
  begin
    if (event.eventType = etUrgent) then
    begin
      OverrideEvent := true;
    end;

    if (event.overridePriority >= FQueueExecutor.FEvent.priority) then
    begin
      OverrideEvent := true;
    end;

    if (FQueueExecutor.FEvent.eventType = etUrgent) then
    begin
      OverrideEvent := false;
    end;

    if (OverrideEvent) then
    begin
      FQueueExecutor.Terminate;
      terminatethread(FQueueExecutor.Handle, 0);
      FQueueExecutor.Free;

      FQueueExecutor := TQueueExecutor.Create(true);
      FQueueExecutor.Start;
    end;
  end;

end;

end.
