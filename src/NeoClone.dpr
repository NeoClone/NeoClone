program NeoClone;

uses
  Forms,
  Winapi.GDIPOBJ,
  Unit1 in 'Unit1.pas' {Main},
  containers in 'gui\containers.pas',
  guiclass in 'gui\guiclass.pas',
  addresses in 'addresses.pas',
  Memory in 'Memory.pas' {$R *.res},
  containerWindows in 'gui\containerWindows.pas',
  Inputer in 'Inputer.pas',
  Lua in 'lua\Lua.pas',
  LuaLib in 'lua\LuaLib.pas',
  chat in 'gui\chat.pas',
  gamewindow in 'gui\gamewindow.pas',
  map in 'gui\map.pas',
  log in 'log.pas' {logForm},
  LuaClass in 'lua\LuaClass.pas',
  unitLoadDLL in 'unitLoadDLL.pas',
  player in 'gui\player.pas',
  astar in 'astar.pas',
  uAstar in 'uAstar.pas',
  PriorityQueue in 'eventQueue\PriorityQueue.pas',
  eventQueue in 'eventQueue\eventQueue.pas',
  Xml.VerySimple in 'xml\Xml.VerySimple.pas',
  settingsHelper in 'featuresForms\settingsHelper.pas',
  settingsTemplates in 'featuresForms\settingsTemplates.pas',
  settingsFormUnit in 'featuresForms\settingsFormUnit.pas',
  healerThreadUnit in 'threads\healerThreadUnit.pas',
  Hotkey in 'gui\Hotkey.pas',
  parserThreadUnit in 'threads\parserThreadUnit.pas',
  netmsg in 'netmsg.pas',
  datReader in 'datReader.pas',
  afxCodeHook in 'afxCodeHook.pas',
  PetriW.Pipes in 'PetriW.Pipes.pas',
  parserThreadHelper in 'threads\parserThreadHelper.pas',
  contextmenus in 'gui\contextmenus.pas',
  States in 'States.pas' {EStates},
  equipment in 'gui\equipment.pas',
  cooldown in 'gui\cooldown.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TlogForm, logForm);
  Application.CreateForm(TsettingsForm, settingsForm);
  Application.CreateForm(TEStates, EStates);
  Main.InitAll();
  Application.Run;
end.
