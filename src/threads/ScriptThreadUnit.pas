unit ScriptThreadUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Xml.VerySimple, settingsHelper, addresses, Vcl.Dialogs,
   math, StrUtils,settingsFormUnit, VirtualTrees, lua, lualib, log;

type
  TScriptExecutor = class(TThread)
  public
    node: TXmlNode;
    PNode: PVirtualNode;
    name: string;
  protected
    procedure Execute; override;
  end;

  TScriptThread = class(TThread)
    S1Xml: TXmlNode;  //Hotkeys tree
    S2Xml: TXmlNode;  //HUD tree
  tree: TsettingsForm;
  protected
    procedure Execute; override;
  public
    procedure ShowLogError;
  end;

implementation

uses
  unit1;

var
ress: integer;
Scripter: TScriptExecutor;
ScriptThread: TScriptThread;

procedure TScriptExecutor.Execute;
var
  start, finish: integer;
  Script: TXmlNode;
  buffer, delay: string;
begin
  inherited;
  FreeOnTerminate := True;
while not Terminated do
begin
  sleep(10);
//  Application.ProcessMessages;
  if node.TimerStarted = null then Terminate;

  if name = 'Persistent' then
    if (node.Find('bEnabled').Text = 'yes') then
    begin
      Script:= node.Find('hScript');
      if Script.Text= '' then continue;  //performance purppose

      if pos('auto(', lowercase(Script.Text)) > 0 then
      begin        //first we take the delay of the auto()
        buffer:= lowercase(Script.Text);
        start:= pos('auto(', buffer)+5;
        finish:= 0;
        while finish = 0 do
        begin
          start:=start+1;
          if buffer[start] = ')' then finish:= start+1;
        end;
        start:= pos('auto(', buffer);
        delay:= copy(buffer,start+5,finish-(start+5)-1);  // "123,255"
        Delete(buffer,start,finish-start);  //delete "auto(123,255)"

        if Script.FirstRun then //if it is the first time we execute this...
        begin           //we have to filter the text....
          buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
          buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
          buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
          buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
          buffer:= StringReplace( buffer, 'init start', ' ', [rfReplaceAll] );  //we execute everything
          buffer:= StringReplace( buffer, 'init end', ' ', [rfReplaceAll] );

          ress := LuaScript.DoString( buffer );
            Synchronize(ScriptThread.ShowLogError);
          Script.FirstRun:= False;
        end
        else
        begin //if not FirstRun
    //                buffer:= Script.Text;
          buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
          buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
          buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
          buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
              //we take away the whole Init Block
          start:= pos('init start', buffer);
          finish:= pos('init end', buffer)+8;
          Delete(buffer,start,finish-start);

          ress := LuaScript.DoString( buffer );
            Synchronize(ScriptThread.ShowLogError);
          Script.FirstRun:= False;
        end;
      end
      else  //if not auto, we execute it just once.
      begin
        if not Script.FirstRun then continue; //we quit this loop if it has been executed before
        buffer:= lowercase(Script.Text);
        buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
        buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
        buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
        buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
        buffer:= StringReplace( buffer, 'init start', ' ', [rfReplaceAll] );
        buffer:= StringReplace( buffer, 'init end', ' ', [rfReplaceAll] );

        ress := LuaScript.DoString( buffer );
          Synchronize(ScriptThread.ShowLogError);
        Script.FirstRun:= False;
      end;
    end;
end;

    //(TO DO) not sure if this goes here or in ScriptThreadUnit.pas
//              event.priority := StrToInt(mNode.Find('iPriority').Text);
//              event.overridePriority := StrToInt(mNode.Find('iOverridePriority').Text);
//              event.expireTime := StrToInt(mNode.Find('iExpireTime').Text);
//              event.lifeTime := StrToInt(mNode.Find('iLifeTime').Text);
//              event.eventType := StrToEventType(mNode.Find('cEventType').Text);
//              event.script := 'cast("'+ spell +'")' else event.script:= '';
//                EvtQueue.insert( event );
end;

procedure TScriptThread.ShowLogError;  //Synchronize(ShowLogError);
begin  //we use Synchronize to update the GUI (Debug Log), else it will freeze
  case ress of
    LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
    LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
    LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
    LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
  end;
end;

procedure TScriptThread.Execute;
var
  Pnode: PVirtualNode;
  nodeData: ^TTreeData;
  spamRate, start, finish, i: integer;
  xNode, node, Script: TXmlNode;
  buffer, delay: string;
begin
  while not Terminated do

          try  //(TO DO) if we have deleted the script, remove all the variables, etc
  begin        //also: "init start    local softid = 6529 init end" will not work, cause next time we execute the script (FirstRun=False) the local won't load since it's from Init Block, therefore softID=nil.

    spamRate := 3000; //we will change this after having finished the Scripter

//           Scripter := TScriptExecutor.Create(True);
//            Scripter.PNode:=PNode;
//            Scripter.node:=node;
//            Scripter.Start;

    if  assigned(S1Xml) then   //if Hotkeys tree...
    begin
      Pnode := settingsForm.PropTree.RootNode.FirstChild;
      Pnode:= PNode.FirstChild.NextSibling.NextSibling.NextSibling; //Hotkeys
//      nodeData := settingsForm.PropTree.GetNodeData( Pnode);
//      showmessage(nodeData.name);
//----------------------Hotkeys----------------------------------------------------
      xNode := S1Xml.Find('lHotkeyList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
        begin
          Script:= node.Find('hScript');
        end;

      end;
//----------------------Persistent----------------------------------------------------
      xNode := S1Xml.Find('lPersistentList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
          if not node.TimerStarted then  //if it hasn't got any Thread Runing
          begin
            node.TimerStarted:= True;  //change state (control and so)

            Scripter := TScriptExecutor.Create(True);
              Scripter.PNode:=PNode;
              Scripter.node:=node;
              Scripter.name:='Persistent';
              Scripter.Start;

          end;  //for

      end;
//----------------------CaveBot----------------------------------------------------
      xNode := S1Xml.Find('lCavebotList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
          if (node.Find('bEnabled').Text = 'yes') and (tree.getsetting('Cavebot/CavebotEnabled') = 'yes') then
          begin
            Script:= node.Find('hScript');
            if Script.Text= '' then continue;  //performance purppose

            if pos('auto(', lowercase(Script.Text)) > 0 then
            begin        //first we take the delay of the auto()
              buffer:= lowercase(Script.Text);
              start:= pos('auto(', buffer)+5;
              finish:= 0;
              while finish = 0 do
              begin
                start:=start+1;
                if buffer[start] = ')' then finish:= start+1;
              end;
              start:= pos('auto(', buffer);
              delay:= copy(buffer,start+5,finish-(start+5)-1);  // "123,255"
              Delete(buffer,start,finish-start);  //delete "auto(123,255)"

              if Script.FirstRun then //if it is the first time we execute this...
              begin           //we have to filter the text....
                buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
                buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
                buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
                buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
                buffer:= StringReplace( buffer, 'init start', ' ', [rfReplaceAll] );  //we execute everything
                buffer:= StringReplace( buffer, 'init end', ' ', [rfReplaceAll] );

                ress := LuaScript.DoString( buffer );
                  Synchronize(ShowLogError);
                Script.FirstRun:= False;
              end
              else
              begin //if not FirstRun
//                buffer:= Script.Text;
                buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
                buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
                buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
                buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
                    //we take away the whole Init Block
                start:= pos('init start', buffer);
                finish:= pos('init end', buffer)+8;
                Delete(buffer,start,finish-start);

                ress := LuaScript.DoString( buffer );
                  Synchronize(ShowLogError);
                Script.FirstRun:= False;
              end;
            end
            else  //if not auto, we execute it just once.
            begin
              if not Script.FirstRun then continue; //we quit this loop if it has been executed before
              buffer:= lowercase(Script.Text);
              buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
              buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
              buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
              buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
              buffer:= StringReplace( buffer, 'init start', ' ', [rfReplaceAll] );
              buffer:= StringReplace( buffer, 'init end', ' ', [rfReplaceAll] );

              ress := LuaScript.DoString( buffer );
                Synchronize(ShowLogError);
              Script.FirstRun:= False;
            end;

          end;

      end;

    end;

    if  assigned(S2Xml) then   //if HUD tree...
    begin
      Pnode := settingsForm.PropTree.RootNode.FirstChild;
      Pnode:= PNode.FirstChild.NextSibling.NextSibling.NextSibling.NextSibling; //HUD
//----------------------HUD----------------------------------------------------
      xNode := S2Xml.Find('lDisplaysList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
          if (node.Find('bEnabled').Text = 'yes') then
          begin
            Script:= node.Find('hScript');
          end;

      end;

    end;
    sleep(spamRate);
    Application.ProcessMessages;
  end; //
     except
        on exception: Exception do
        begin //there is an AccessViolation when you try to close the bot while Lua Errors are being shown/executed
//        showmessage(exception.ToString);
        end;
    end;

end;

end.
