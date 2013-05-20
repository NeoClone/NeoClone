unit ScriptThreadUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Xml.VerySimple, settingsHelper, addresses, Vcl.Dialogs,
   math, StrUtils,settingsFormUnit, VirtualTrees, lua, lualib, log;

type
  TScriptThread = class(TThread)
    S1Xml: TXmlNode;  //Hotkeys tree
    S2Xml: TXmlNode;  //HUD tree
  tree: TsettingsForm;
  protected
    procedure Execute; override;
  end;

implementation

uses
  unit1;

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure ScriptThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{ ScriptThread }

procedure TScriptThread.Execute;
var
  Pnode: PVirtualNode;
  nodeData: ^TTreeData;
  spamRate, start, finish, res: integer;
  xNode, node, Script: TXmlNode;
  buffer, delay: string;
begin
    //we have to do one "if" for each type of Script (htkey,cavbot,persist,hud)
  while not Terminated do            //we will also check the nodeData.FirstRun

          try
  begin
    if  assigned(S1Xml) then   //if Hotkeys tree...
    begin
      spamRate := 3000; //we will change this after having finished the Scripter
      Pnode := settingsForm.PropTree.RootNode.FirstChild;
      Pnode:= PNode.FirstChild.NextSibling.NextSibling.NextSibling; //Hotkeys
//      nodeData := settingsForm.PropTree.GetNodeData( Pnode);
//      showmessage(nodeData.name);
      xNode := S1Xml.Find('lHotkeyList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
        begin
          Script:= node.Find('hScript');
        end;

      end;

      xNode := S1Xml.Find('lPersistentList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
          if (node.Find('bEnabled').Text = 'yes') then
          begin
            Script:= node.Find('hScript');
            if pos('auto(', Script.Text) > 0 then
            begin        //first we take the delay of the auto()
              buffer:= Script.Text;
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

                res := LuaScript.DoString( buffer );
                case res of
                      LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
                    end;
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

                res := LuaScript.DoString( buffer );
                case res of
                      LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
                    end;
                Script.FirstRun:= False;
              end;
            end
            else  //if not auto, we execute it just once.
            begin
              if not Script.FirstRun then break; //if it has been executed before
              buffer:= Script.Text;
              buffer:= StringReplace( buffer, '&amp;', '&', [rfReplaceAll] );
              buffer:= StringReplace( buffer, '&#xd;', #13, [rfReplaceAll] );
              buffer:= StringReplace( buffer, '&lt;', '<', [rfReplaceAll] );
              buffer:= StringReplace( buffer, '&gt;', '>', [rfReplaceAll] );
              buffer:= StringReplace( buffer, 'init start', ' ', [rfReplaceAll] );
              buffer:= StringReplace( buffer, 'init end', ' ', [rfReplaceAll] );

              res := LuaScript.DoString( buffer );
                case res of         //we have to fix the lag problem with Lua_ErrSyntax
                      LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
                      LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
                    end;
              Script.FirstRun:= False;
            end;

          end;

      end;

      xNode := S1Xml.Find('lCavebotList');
      if xNode.ChildNodes.Count > 0 then
      begin
        for node in xNode.ChildNodes do
          if (node.Find('bEnabled').Text = 'yes') and (tree.getsetting('Cavebot/CavebotEnabled') = 'yes') then
          begin
            Script:= node.Find('hScript');
          end;

      end;

    end;

    if  assigned(S2Xml) then   //if HUD tree...
    begin
      spamRate := 100;
      Pnode := settingsForm.PropTree.RootNode.FirstChild;
      Pnode:= PNode.FirstChild.NextSibling.NextSibling.NextSibling.NextSibling; //HUD
//      nodeData := settingsForm.PropTree.GetNodeData( Pnode);
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
        begin
        showmessage(exception.ToString);
        end;
    end;

end;

end.
