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
  Ten spos�b zabijania threadu jest totalnie g�upi i powoduje memory leaki...
  oby to nie przeszkadza�o na d�u�sz� met�...

  jak bedzie przeszkadzac, powodowac problemy to oddzielimy eventy na pare thread�w

  - leczenie 1 thread
  - atakowanie 2 thread
  - lootowanie i skrypty 3 thread...

  ale to w koniecznosci
}

procedure TWatchDog.Execute;
var
  delCount, item: integer;
begin

  while not Terminated do
  begin
    {
      bo�e uchro� nasze systemy. Totalnie g�upie rozwi�zanie.
      nierozumiem jak EKX m�g� na takie co� wpa��... przemy�la� to chocia�?

      oj b�d� z tym problemy... m�wie Ci b�d�... wspomnisz me s�owa...
    }

    //sleep(1);
    // life time czyli jezeli event wykonuje sie za dlugo to zabija thread i tworzy od nowa
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
              chyba da si� to zrobi� inaczej, np:
              pobra� tablice index shuffledDeletion potem
              z kazdym delete odejmowac -1 do indexu(counta)

              musze to przemy�le�
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
