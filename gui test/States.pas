unit States;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,settingsFormUnit,
  Vcl.ExtCtrls;

type
  TEStates = class(TForm)
    Cavebot: TCheckBox;
    Healer: TCheckBox;
    Looting: TCheckBox;
    ManaTraining: TCheckBox;
    Targeting: TCheckBox;
    Timer1: TTimer;
    procedure HealerClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CavebotClick(Sender: TObject);
    procedure LootingClick(Sender: TObject);
    procedure ManaTrainingClick(Sender: TObject);
    procedure TargetingClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  EStates: TEStates;
  tree: TsettingsForm;

implementation

{$R *.dfm}
     uses Unit1;


procedure TEStates.CavebotClick(Sender: TObject);
begin
Timer1.Enabled:= False;  //okay, we turn this off so it doesn't interefere
//just when we click (so before it changes)
if (tree.getsetting('Cavebot/CavebotEnabled') = 'yes') and not EStates.Cavebot.Checked then
tree.setsetting('Cavebot/CavebotEnabled','no')
else if (tree.getsetting('Cavebot/CavebotEnabled') = 'no') and EStates.Cavebot.Checked then
tree.setsetting('Cavebot/CavebotEnabled','yes');

Timer1.Enabled:= True;   //kk, I want my timer on again!
end;

procedure TEStates.HealerClick(Sender: TObject);
begin
Timer1.Enabled:= False;  //okay, we turn this off so it doesn't interefere
//just when we click (so before it changes)
if (tree.getsetting('Healer/HealerEnabled') = 'yes') and not EStates.healer.Checked then
tree.setsetting('Healer/HealerEnabled','no')
else if (tree.getsetting('Healer/HealerEnabled') = 'no') and EStates.healer.Checked then
tree.setsetting('Healer/HealerEnabled','yes');

Timer1.Enabled:= True;   //kk, I want my timer on again!
end;

procedure TEStates.LootingClick(Sender: TObject);
begin
Timer1.Enabled:= False;  //okay, we turn this off so it doesn't interefere
//just when we click (so before it changes)
if (tree.getsetting('Cavebot/Looting/LootingEnabled') = 'yes') and not EStates.Looting.Checked then
tree.setsetting('Cavebot/Looting/LootingEnabled','no')
else if (tree.getsetting('Cavebot/Looting/LootingEnabled') = 'no') and EStates.Looting.Checked then
tree.setsetting('Cavebot/Looting/LootingEnabled','yes');

Timer1.Enabled:= True;   //kk, I want my timer on again!
end;

procedure TEStates.ManaTrainingClick(Sender: TObject);
begin
Timer1.Enabled:= False;  //okay, we turn this off so it doesn't interefere
//just when we click (so before it changes)
if (tree.getsetting('Healer/ManaTraining/Enabled') = 'yes') and not EStates.Manatraining.Checked then
tree.setsetting('Healer/ManaTraining/Enabled','no')
else if (tree.getsetting('Healer/ManaTraining/Enabled') = 'no') and EStates.Manatraining.Checked then
tree.setsetting('Healer/ManaTraining/Enabled','yes');

Timer1.Enabled:= True;   //kk, I want my timer on again!
end;

procedure TEStates.TargetingClick(Sender: TObject);
begin
Timer1.Enabled:= False;  //okay, we turn this off so it doesn't interefere
//just when we click (so before it changes)
if (tree.getsetting('Targeting/TargetingEnabled') = 'yes') and not EStates.Targeting.Checked then
tree.setsetting('Targeting/TargetingEnabled','no')
else if (tree.getsetting('Targeting/TargetingEnabled') = 'no') and EStates.Targeting.Checked then
tree.setsetting('Targeting/TargetingEnabled','yes');

Timer1.Enabled:= True;   //kk, I want my timer on again!
end;

procedure TEStates.Timer1Timer(Sender: TObject);
begin
  if (tree.getsetting('Cavebot/CavebotEnabled') = 'yes') and not EStates.Cavebot.Checked then
       EStates.Cavebot.Checked:= True
  else if (tree.getsetting('Cavebot/CavebotEnabled') = 'no') and EStates.Cavebot.Checked then
  EStates.Cavebot.Checked:= False;

  if (tree.getsetting('Healer/HealerEnabled') = 'yes') and not EStates.Healer.Checked then
       EStates.healer.Checked:= True
  else if (tree.getsetting('Healer/HealerEnabled') = 'no') and EStates.Healer.Checked then
  EStates.healer.Checked:= False;

  if (tree.getsetting('Cavebot/Looting/LootingEnabled') = 'yes') and not EStates.Looting.Checked then
       EStates.Looting.Checked:= True
  else if (tree.getsetting('Cavebot/Looting/LootingEnabled') = 'no') and EStates.Looting.Checked then
  EStates.Looting.Checked:= False;

  if (tree.getsetting('Healer/ManaTraining/Enabled') = 'yes') and not EStates.Manatraining.Checked then
       EStates.Manatraining.Checked:= True
  else if (tree.getsetting('Healer/ManaTraining/Enabled') = 'no') and EStates.Manatraining.Checked then
  EStates.Manatraining.Checked:= False;

  if (tree.getsetting('Targeting/TargetingEnabled') = 'yes') and not EStates.Targeting.Checked then
       EStates.Targeting.Checked:= True
  else if (tree.getsetting('Targeting/TargetingEnabled') = 'no') and EStates.Targeting.Checked then
  EStates.Targeting.Checked:= False;
end;

end.
