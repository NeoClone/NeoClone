unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Memory, guiclass, inputer, addresses, lua, lualib,
  Menus, luaClass, Vcl.ExtCtrls, Winapi.GDIPOBJ, EventQueue, PriorityQueue,
  Xml.VerySimple, parserThreadUnit, healerThreadUnit, settingsTemplates, hotkey,
  netmsg, datReader, afxCodeHook, PetriW.Pipes, player, VirtualTrees, chat,Equipment,
   gamewindow, containers,cooldown, Vcl.DBCtrls, sockets;

type
  TMain = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    View1: TMenuItem;
    Options1: TMenuItem;
    Help1: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Console1: TMenuItem;
    Button2: TButton;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Exit2: TMenuItem;
    N5: TMenuItem;
    oggleMobot1: TMenuItem;
    hudStart: TTimer;
    HideHUDDisplayfromtaskbar1: TMenuItem;
    hudSetup: TTimer;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Settings1: TMenuItem;
    map1: TMenuItem;
    Enginestates1: TMenuItem;
    Huddisplays1: TMenuItem;
    Waypointadd1: TMenuItem;
    Language1: TMenuItem;
    N1: TMenuItem;
    Pausebot1: TMenuItem;
    Pauseinput1: TMenuItem;
    Allowminimize1: TMenuItem;
    N2: TMenuItem;
    Focusclient1: TMenuItem;
    Resetexph1: TMenuItem;
    N4: TMenuItem;
    Findnewclient1: TMenuItem;
    Closebotwithclient1: TMenuItem;
    N6: TMenuItem;
    Httpsettings1: TMenuItem;
    Navigation1: TMenuItem;
    News1: TMenuItem;
    Updates1: TMenuItem;
    N7: TMenuItem;
    NeoClonesettings1: TMenuItem;
    Scripting1: TMenuItem;
    Scriptvariables1: TMenuItem;
    ScriptFunctions1: TMenuItem;
    ScriptEvents1: TMenuItem;
    ScriptLibraries1: TMenuItem;
    tibiaExeDialog: TOpenDialog;
    checkiflogged: TTimer;
    Label1: TLabel;
    Pings: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Console1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure oggleMobot1Click(Sender: TObject);
    procedure hudStartTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure HideHUDDisplayfromtaskbar1Click(Sender: TObject);
    procedure hudSetupTimer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure checkifloggedTimer(Sender: TObject);
    procedure Findnewclient1Click(Sender: TObject);
    procedure Enginestates1Click(Sender: TObject);
    procedure PingsTimer(Sender: TObject);
  private
    { Private declarations }
  public
    TProc: integer;
    THand: integer;

    procedure InitAll();
    procedure loadTibia();
    function getPing(): integer;
    procedure PipeDataReceived(AData: string; RawData: TBytes; len: integer);
  end;


  
var
  Main: TMain;
  shown: boolean;

  Memory: TMemory;
  GUI: TGUI;
  EvtQueue: TEventQueue;
  TibiaHotKey: TTibiaHotkey;
  settings, xmlSpellList, xmlItemList: TVerySimpleXML;

  LuaScript: TLuaScripter;
  LuaLibs: array[0..99] of TLuaLibrary;
  LuaLibsCount: integer;

  ParserThread: TParserThread;
  HealerThread: THealerThread;

  pipeServer: TPBPipeServer;
  pipeClient: TPBPipeClient;

  Player: TPlayer;
  Equipment: TGUIEquipment;
  GameWindow: TGameWindow;
  ADDR_BASE: pointer;          //if we declare this here we will be able
  Ping: integer = 0;              //to use it aaaaanywhere :DD:D:D

implementation

uses settingsFormUnit, log, unitLoadDLL, States;

{$R *.dfm}


procedure KillProcess(hWindowHandle: HWND);
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0, SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);
  if isWindow(hWindowHandle) then
  begin
    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then
    begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
        False, hprocessID);
      if processHandle <> 0 then
      begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
      end;
    end;
  end;
end;

function TMain.getPing(): integer;

begin
if player.OnLine then        //each 10sec we check if player online
  begin                         //if we are logged we take the ping
  Ping := Memory.ReadInteger(Integer(ADDR_BASE) + addresses.Ping);
  end                           //else we OVERWRITE that value to 0, cause the address
  else Ping:= 0;               // will keep the last non-zero value
end;


procedure TMain.PingsTimer(Sender: TObject);
begin
Main.getPing();
end;

procedure TMain.PipeDataReceived(AData: string; RawData: TBytes; len: integer);
var
  packet: TPacket;
  i: integer;
begin
  if assigned(ParserThread) then
  begin
    setlength(packet.buf, len);
    for i := 0 to len do
    begin
      packet.buf[i] := RawData[i];
    end;
    packet.len := len;
    ParserThread.insert(packet);
  end;
end;

procedure Tmain.loadTibia();
var
pid, res: integer;
begin
  Main.THand := findwindow( 'tibiaclient', nil );
  GetWindowThreadProcessId(Main.THand, @pid);         //here I should add the MC support: something like "write the PID you took in this .txt, if you open a new bot client check first the .txt so you know which PID you CAN'T take"
  ADDR_BASE := Memory.GetModuleBaseAddress(pid, 'Tibia.exe');

  Main.TProc := OpenProcess(PROCESS_ALL_ACCESS, False, pid);
end;

procedure TMain.InitAll();
var
  pid, res: integer;
  Rec : TSearchRec;
  Path, cleanName: string;
Sname: string;
Player: TPlayer;
  busc: boolean;
begin

loadTibia();    //find window etc...
                               {  What is this for? :/
  // pipes
  pipeClient := TPBPipeClient.Create('\\.\pipe\pipe dll ' + inttostr(pid));
  pipeServer := TPBPipeServer.Create('\\.\pipe\pipe app ' + inttostr(pid));
  pipeServer.OnReceivedData := PipeDataReceived;

  if not pipeClient.SendData('test') then // por defecto  se ejecuta
  begin
    // zrobic sprawdzanie i zmienic sciezke dll'a
    // --hacer comprobar y cambiar la ruta de acceso DLL   (hecho)
    InjectLibrary( Main.TProc, extractFilePath(paramstr(0)) + 'packetdll\UniCore.dll' );
    sleep(100);
    pipeClient.SendData('init');
  end;
                        What is this for? :/  }
  Memory := TMemory.Create;
  GUI := TGUI.Create;

  TibiaHotKey := TTibiaHotKey.Create;
  LuaScript := TLuaScripter.Create( true ); // auto register
  EvtQueue := TEventQueue.Create();

  // xml libs
  xmlSpellList := TVerySimpleXML.Create;
  xmlSpellList.LoadFromFile(extractFilePath(paramstr(0)) + 'libs\spelllist.txt');

  xmlItemList := TVerySimpleXML.Create;
  xmlItemList.LoadFromFile(extractFilePath(paramstr(0)) + 'libs\itemlist.txt');

  settings := TVerySimpleXML.Create;
  settings.LoadFromString( loadCleanSettings() );
  settingsForm.RecursivePropTree(settingsForm.PropTree.RootNode, settings.Root, true);

  AddLog( colorPurple, 'NeoClone loaded successfully.' );

  // load user lua libs
  LuaLibsCount := 0;
  Path := IncludeTrailingPathDelimiter( extractFilePath(paramstr(0)) + 'libs' );
  if FindFirst (Path + '*.lua', faAnyFile - faDirectory, Rec) = 0 then
  begin
    try
      repeat
        LuaLibs[LuaLibsCount].luaFile := Rec.Name;
        cleanName := Copy(ExtractFileName(Rec.Name), 1, Length(ExtractFileName(Rec.Name)) - Length(ExtractFileExt(Rec.Name)));

        if fileexists( Path + cleanName ) then
        begin
          // dodac ladowanie pliku xml    -- añadir cargar el archivo xml
          LuaLibs[LuaLibsCount].xmlFile := Path + cleanName;
        end;

        res := LuaScript.DoString(LuaScript.getFile(Path + LuaLibs[LuaLibsCount].luaFile));
        case res of
          0: AddLog( colorPurple, 'Library file ' + LuaLibs[LuaLibsCount].luaFile + ' loaded successfully.' );
          LUA_ERRSYNTAX: AddLogError( 'library file ' + LuaLibs[LuaLibsCount].luaFile, LuaScript.getErrorText() );
          LUA_ERRRUN: AddLogError( 'library file ' + LuaLibs[LuaLibsCount].luaFile, LuaScript.getErrorText() );
          LUA_ERRMEM: AddLogError( 'library file ' + LuaLibs[LuaLibsCount].luaFile, LuaScript.getErrorText() );
          LUA_ERRERR: AddLogError( 'library file ' + LuaLibs[LuaLibsCount].luaFile, LuaScript.getErrorText() );
        end;

        LuaLibsCount := LuaLibsCount + 1;
      until FindNext(Rec) <> 0;
    finally      
      FindClose(Rec);
    end;
  end;


  // zrobiæ sprawdzanie     -- check itans plx  (doors,items,etc,caracteristics...)
 // loadTibiaDat(GetEnvironmentVariable('Programfiles') + '\Tibia\Tibia.dat');

  HealerThread := THealerThread.Create(true);
  HealerThread.FXml := settings.Root.Find('sHealer'); //active Healer!
  HealerThread.Start();

  // this takes some info from Packets, not all from Addresses!)
  {but idk how it works!
  ParserThread := TParserThread.Create;
                                                                  }
  //now we have to do the cavebot etc? :O

  //hudstart.Enabled := true;
end;



procedure TMain.oggleMobot1Click(Sender: TObject);
begin
  ShowWindow(Main.Handle, SW_SHOW);
end;

procedure TMain.Settings1Click(Sender: TObject);
begin
  settingsForm.show();
end;

procedure TMain.Button1Click(Sender: TObject);
var
  addr, i,x,y,width,height, j,num,num2,num3: integer;
  d,s: TRect;
  p: TPoint;
  item: TItem;
  t,tt: TTile;
  l: TLocation;
    chattext,ss: string;
  Hotkey: TTibiaHotkey;
hp: integer;
containers: Tcontainers;
CD: TCooldown;
  r: TRect;
  chat:TChat;
begin

player.AntiIdle();
//if CD.canCast('exevo vis hur') then
//  showmessage('si')
//  else showmessage('no');
//showmessage(getItem(3068).name);
//settingsForm.SETsetting('Healer/HealerEnabled', 'yes');
//showmessage(inttostr(Ord(NewInPacketId.inPING)));
//if player.CheckFlag(WithinProtectionZone) then
//showmessage('estamos dentroooooooooo');
//player.Exphour;
//showmessage(' '+inttostr(player.clubpc)+' '+inttostr(player.distance)+' '+floattostr(player.Exp)+' ');
//showmessage(chat.GetMessages.sender[2]);
       //GameWindow.getSize();
                                 {
        num := Memory.ReadInteger(Integer(ADDR_BASE) +GUIpointer);
        x := 0;
        y := 0;
        num2 := Memory.ReadInteger(((num + $30)));
        x := Memory.ReadInteger(((num2 + $34)));
        y := Memory.ReadInteger(((num2 + $30)));
        width := Memory.ReadInteger(((num2 + $38)));
        height := Memory.ReadInteger(((num2 + 60)));
     showmessage(inttostr(x)+' '+inttostr(y)+' '+inttostr(width)+' '+inttostr(height));
                }
        {
      // 5 plus ...
 x := Memory.ReadInteger($14 + Memory.ReadInteger($24 + Memory.ReadInteger($30 + Memory.ReadInteger(Integer(ADDR_BASE) +GUIpointer))));
      // always 5?
 y := Memory.ReadInteger($18 + Memory.ReadInteger($24 + Memory.ReadInteger($30 + Memory.ReadInteger(Integer(ADDR_BASE) +GUIpointer))));
    //gamewindow.x
 width := Memory.ReadInteger($1C + Memory.ReadInteger($24 + Memory.ReadInteger($30 + Memory.ReadInteger(Integer(ADDR_BASE) +GUIpointer))));
    //gamewindow.y
 height := Memory.ReadInteger($20 + Memory.ReadInteger($24 + Memory.ReadInteger($30 + Memory.ReadInteger(Integer(ADDR_BASE) +GUIpointer))));
    showmessage(inttostr(x)+' '+inttostr(y)+' '+inttostr(width)+' '+inttostr(height));
                 }

{
 r := GUI.getSize();

  p.X := r.Left + 1303;              //80     83    //1209
  p.Y := r.Bottom + 166;           //550    548     //168

ShowMessage(' X: ' + Inttostr(p.X) + ' Y: ' + Inttostr(p.Y));
  // zamykamy wszystkie okna
  inputer.SendKey(VK_ESCAPE);
  sleep(500);

  // klikamy Enter Game
  inputer.SendClickPoint(p);
  sleep(1000);                 }
  //addr := GUI.Containers.Window.getAddressByName( 'expedition' );
 // GUI.Chat.say('kostas roxxx!!!!!','NPCs');

  // czytanie pozycji gold coina i umieszczanie tam kursora ;) easy!
  // Lectura de la posición en oro y moneda de colocar el cursor allí ;) fácil!
  {addr := Memory.ReadInteger( Integer(ADDR_BASE) + addresses.mapPointer );

  for i := 0 to addresses.mapMaxTiles-1 do
  begin
    t := GUI.GameWindow.Map.getTile( i, addr );

    if t.itemCount > 0 then
    begin
      for j := 0 to t.itemCount - 1 do
      begin
        if t.items[j].id = 3031 then            //gold coin
        begin
          tt := t;
          tt.local := GUI.GameWindow.Map.tileToLocal( i );
          tt.index := i;
          break;
        end;
      end;
    end;
  end;

  item := GUI.GameWindow.Map.tileTopItem( tt );
  showmessage(inttostr(item.id));

//  for i := 0 to tt.itemCount-1 do
//  begin
//    showmessage(inttostr(tt.items[i].data));
//  end;

  {l := GUI.GameWindow.Map.tileToGlobal( tt, GUI.GameWindow.Map.getPlayerTile() );

  d := GUI.GameWindow.getSize();
  s := GUI.GameWindow.absoluteToCursor( l.x, l.y );

  GUI.setCursorClient( d.Left + s.Left + round(s.Right / 2), d.Top + s.Top + round(s.Bottom / 2) );
  //}
end;

procedure TMain.Button2Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 10 do
  begin
    addDisplay();
  end;
end;

procedure TMain.Button3Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to 10 do
  begin
      addDisplayItem(i, '99:"Tahoma":14:'+inttostr(random($FFFFFF)));
      addDisplayItem(i, '50:100:' + inttostr(100+(i*20)) + ':"dupa: '+ inttostr(GetTickCount) +'"');
      refreshDisplay(i);
  end;
end;

procedure TMain.Button5Click(Sender: TObject);
var
  loc: Tlocation;
player: Tplayer;
begin
  loc := Player.getLocation();   //Gui.player.getLocation()
  loc.y := loc.y - 1;     //my char position.Y -1 (up of my char)
                             //id = 0¿?
  GUI.Containers.useItem( 0, GUI.ground(loc.x, loc.y, loc.z) );
end;

procedure TMain.checkifloggedTimer(Sender: TObject);
var
Sname: string;
  busc: boolean;
begin
 // comprobamos que se ha cargado  (debug mode xD)
  if (main.TProc <> 0) and (findwindow( 'tibiaclient', nil ) <> 0) then
  begin
     // showmessage('tibia cargado ' + inttostr(pid));
     // pondremos que si no ha cargado que ponga "no client", y que si carga ponga el char name
            //comprobar offsets
  //  busc:= hotkey.find('hola');


    if Player.OnLine() then
    begin
      Sname:= Player.Name();    //write name
     // Showmessage(Sname);
     Caption:= 'NeoClone v1.0 - ' + Sname;
     TrayIcon1.Hint:= 'NeoClone v1.0 - ' + Sname;
    end
    else
    begin
      Caption:= 'NeoClone v1.0 - ' + 'not logged';         //write "not logged"
      TrayIcon1.Hint:= 'NeoClone v1.0 - ' + 'not logged';
    end;
  end
  else //if findwindow( 'tibiaclient', nil ) = 0 then
  begin
      Main.TProc:= 0;
     Caption:= 'NeoClone v1.0 - ' + 'Tibia not found';        //write "no tibia found"
     TrayIcon1.Hint:= 'NeoClone v1.0 - ' + 'Tibia not found';
  end;

end;

procedure TMain.Console1Click(Sender: TObject);
begin
  logForm.show();
end;

procedure TMain.Enginestates1Click(Sender: TObject);
begin
 EStates.show();
end;

procedure TMain.Exit1Click(Sender: TObject);
var
  h: integer;
begin
  // brzydki hack ale inaczej nie umiem :(   -- ugly trick, but for rest I can't :(
//  h := gethandle();
//  KillProcess(h);

  application.Terminate;
end;

procedure TMain.Findnewclient1Click(Sender: TObject);
begin
loadTibia();
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  ShowWindow(Main.Handle, SW_HIDE);
  canclose := false;
  shown := false;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  shown := true;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  pipeServer.Free;
  pipeClient.Free;

  EvtQueue.Free;
  GUI.Free;
  LuaScript.Free;
  TibiaHotKey.Free;
  Memory.Free;

  HealerThread.Free;
  ParserThread.Free;

  settings.Free;
  xmlSpellList.Free;
  xmlItemList.Free;

  SetLength(DatTiles, 0);
end;

procedure TMain.HideHUDDisplayfromtaskbar1Click(Sender: TObject);
var
  h: integer;
begin
  h := gethandle();

  ShowWindow(h, SW_HIDE);
  SetWindowLong(h, GWL_EXSTYLE, GetWindowLong(h, GWL_EXSTYLE) or WS_EX_TOOLWINDOW); //WS_EX_TOOLWINDOW
  ShowWindow(h, SW_SHOW);
end;

procedure TMain.hudSetupTimer(Sender: TObject);
var
  h: integer;
begin
  h := gethandle();

  ShowWindow(h, SW_HIDE);
  SetWindowLong(h, GWL_EXSTYLE, GetWindowLong(h, GWL_EXSTYLE) or WS_EX_TOOLWINDOW or WS_EX_TRANSPARENT or WS_EX_TOPMOST); //WS_EX_TOOLWINDOW
  ShowWindow(h, SW_SHOW);
  hudSetup.Enabled := false;
end;

procedure TMain.hudStartTimer(Sender: TObject);
begin
  hudStart.Enabled := false;
  hudSetup.Enabled := true;
  showme();
end;

procedure TMain.TrayIcon1Click(Sender: TObject);
begin
  if shown then
  begin
    ShowWindow(Main.Handle, SW_HIDE);
    shown := false;
  end
  else
  begin
    ShowWindow(Main.Handle, SW_SHOW);
    shown := true;
  end;

end;

end.
