unit settingsFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, XML.VerySimple,
  Vcl.StdCtrls, Vcl.Samples.Spin, settingsTemplates, settingsHelper, Vcl.Menus;

type

  TPropertyEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: array[0..7] of TWinControl;        // One of the property editor classes.
    FEditCount: integer;
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
  protected

  public
    destructor Destroy; override;

    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
  end;

  TsettingsForm = class(TForm)
    PropTree: TVirtualStringTree;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Slot1: TMenuItem;
    Exchange1: TMenuItem;
    Examples1: TMenuItem;
    Clear1: TMenuItem;
    Load1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Exporttofile1: TMenuItem;
    Exportselectiontoclipboard1: TMenuItem;
    N2: TMenuItem;
    Importfromfile1: TMenuItem;
    Importfromclipboard1: TMenuItem;
    aaa1: TMenuItem;
    N3: TMenuItem;
    Save1: TMenuItem;
    Slot11: TMenuItem;
    Slot21: TMenuItem;
    Slot31: TMenuItem;
    Slot41: TMenuItem;
    Slot51: TMenuItem;
    N4: TMenuItem;
    Custom1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PropTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure PropTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure PropTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure PropTreeNodeDblClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure newItemClick(Sender: TObject);
    procedure deleteItemClick(Sender: TObject);
    procedure EditSpinChange(Sender: TObject);
    procedure Save(Sender: TObject);
    procedure Load(Sender: TObject);
    procedure Close(Sender: TObject);
    procedure Clear(Sender: TObject);
    procedure ClearHealRules(Sender: TObject);
  private
    { Private declarations }
  public
    function initHealer(): boolean;

    function check(): boolean;
    procedure RecursiveXmlTree( pNode, node: TXmlNode );
    procedure RecursivePropTree( node: PVirtualNode; xmlNode: TXmlNode; first: boolean = false );
    procedure SETSettingValue( arr: array of string; node: PVirtualNode; value: string );
    function FindSettingValue( arr: array of string; node: PVirtualNode ): string;
    function FindNode( node: PVirtualNode; name: string ): PVirtualNode;
    function FindNodeEx( name: string; index: integer = -1 ): PVirtualNode;

    function findXmlNode( nodeArr: TExplodeArray ): TXmlNode;
    function parentList( node: PVirtualNode ): TExplodeArray;
    function nameToFlagName( name: string; node: PVirtualNode ): string;

procedure SETsetting( path,value: string );
function getsetting( path: string ): string;

  end;

var
  settingsForm: TsettingsForm;

implementation

{$R *.dfm}

uses
  unit1, States,healerThreadUnit;

//----------------------------------------------------------------------------------------------------------------------

function TsettingsForm.nameToFlagName( name: string; node: PVirtualNode ): string;
var
  nodeData: ^TTreeData;
begin

  nodeData := PropTree.GetNodeData( node );

  case nodeData.dataType of

    xdStatic:
      begin
        result := 's' + name;
      end;

    xdBoolean:
      begin
        result := 'b' + name;
      end;

    xdInteger:
      begin
        result := 'i' + name;
      end;

    xdRange:
      begin
        result := 'r' + name;
      end;

    xdList:
      begin
        result := 'l' + name;
      end;

    xdTextList:
      begin
        result := 'u' + name;
      end;

    xdText:
      begin
        result := 't' + name;
      end;

    xdWayPoint:
      begin
        result := 'w' + name;
      end;

    xdComboBox:
      begin
        result := 'c' + name;
      end;

    xdRangePercent:
      begin
        result := 'x' + name;
      end;

    xdSubitem:
      begin
        result := 'e' + name;
      end;

  end;

end;


function TsettingsForm.findXmlNode( nodeArr: TExplodeArray ): TXmlNode;
var
  i: integer;
begin

  result := settings.Root;

  for i := 1 to length(nodeArr) - 1 do
  begin

    if assigned( result ) then
      result := result.Find( nodeArr[i] )
    else
      break;

  end;

end;


function TsettingsForm.parentList( node: PVirtualNode ): TExplodeArray;
var
  nodeData: ^TTreeData;
  pList: TExplodeArray;
  i: integer;
  pName: string;
begin

  nodeData := PropTree.GetNodeData( node );

  if assigned(nodeData) then
  begin
    setlength( pList, length(pList)+1 );
    pList[ length(pList)-1 ] := nameToFlagName(nodeData.name, node);

    node := node.Parent;
    nodeData := PropTree.GetNodeData( node );
    while assigned(nodeData) do
    begin

      setlength( pList, length(pList)+1 );
      pList[ length(pList)-1 ] := nameToFlagName(nodeData.name, node);

      node := node.Parent;
      nodeData := PropTree.GetNodeData( node );

    end;

  end;

  i := length(pList)-1;
  setlength( result, i+1 );
  for pName in pList do
  begin
    result[i] := pName;
    dec(i);
  end;

end;

procedure TsettingsForm.SETsetting( path,value: string );
var
  expl: TExplodeArray;
  i, d: integer;
  arr: array of string;
  str: string;
begin


  expl := explode( '/', path );
  setlength( arr, length(expl) );
  d := length(expl)-1;
  for str in expl do
  begin
    arr[d] := str;
    dec(d);
  end;

  settingsForm.SETSettingValue( arr, settingsForm.PropTree.RootNode.FirstChild, value)
end;


function TsettingsForm.getsetting( path: string ): string;
var
  expl: TExplodeArray;
  i, d: integer;
  arr: array of string;
  str: string;
begin

  result := '';

  expl := explode( '/', path );
  setlength( arr, length(expl) );
  d := length(expl)-1;
  for str in expl do
  begin
    arr[d] := str;
    dec(d);
  end;

  result := settingsForm.FindSettingValue( arr, settingsForm.PropTree.RootNode.FirstChild)
end;


procedure TsettingsForm.Clear(Sender: TObject);
begin                            //we have to delete  NeoSettings (first child)
  settingsForm.PropTree.DeleteNode(settingsForm.PropTree.RootNode.FirstChild, True);
  settings := TVerySimpleXML.Create;   //create new settingsXML
  settings.LoadFromString( loadCleanSettings() );  //add new stuff to the XML
              //apply that XML to the new Tree
  settingsForm.RecursivePropTree(settingsForm.PropTree.RootNode, settings.Root, true);
  HealerThread.FXml := settings.Root.Find('sHealer'); //reassign Healer again!
end;


procedure TsettingsForm.ClearHealRules(Sender: TObject);
var
Node1: PVirtualNode;
  node: PVirtualNode;
  xmlItem: TVerySimpleXML;
  pList: TExplodeArray;
  xmlNode: TXmlNode;
  nodeData: ^TTreeData;
  i: integer;
begin
              // NeoSettings=(first child)    -->Node1= parent of our node
Node1:= settingsForm.PropTree.RootNode.FirstChild.FirstChild.NextSibling.NextSibling;
            {
  settings := TVerySimpleXML.Create;   //create new settingsXML
      }
//kk, we take the Node wich we are going to remove -->Node1 is parent!
  node := Node1.Firstchild;
//  nodedata:= proptree.GetNodeData(node);
//  showmessage(nodedata.name);
  pList := settingsForm.parentList( node ); //now we do shit to get it in Xml yo!
  xmlNode := settingsForm.findXmlNode( pList );
               //we delete the visual Tree
  PropTree.DeleteNode( Node1.FirstChild, false );

//  showmessage(inttostr(xmlNode.Parent.ChildNodes.IndexOf(xmlNode)));
  i:= xmlNode.Parent.ChildNodes.IndexOf(xmlNode);
  xmlNode.Parent.ChildNodes.Delete(i);   //Delete Xml

  settings.LoadFromString( loadCleanSettings() );  //add new stuff to the XML
              //apply that XML to the new Tree
  settingsForm.RecursivePropTree(Node1, settings.Root.Find('sHealer').Find('lHealRules'));
                     //now we move it to first position as before
  proptree.MoveTo(Node1.LastChild, Node1,amAddChildFirst,false);

    PropTree.EndEditNode;  //we finish doing that, cleaning it now and so...

  HealerThread.FXml := settings.Root.Find('sHealer'); //reassign Healer again!
end;

procedure TsettingsForm.Close(Sender: TObject);
begin
settingsForm.Hide();
end;

destructor TPropertyEditLink.Destroy;
var
  i: integer;
begin
  for i := 0 to FEditCount-1 do
  begin
    FEdit[i].Free;
  end;
  inherited;
end;

function TPropertyEditLink.BeginEdit: Boolean;
var
  i: integer;
begin
  Result := True;
  for i := 0 to FEditCount-1 do
  begin
    FEdit[i].Show;
    FEdit[i].SetFocus;
  end;
end;

function TPropertyEditLink.CancelEdit: Boolean;
var
  i: integer;
begin
  Result := True;
  for i := 0 to FEditCount-1 do
  begin
    FEdit[i].Hide;
  end;
end;

function TPropertyEditLink.EndEdit: Boolean;
var
  Data: ^TTreeData;
  P: TPoint;
  Dummy, i: Integer;
  pList: TExplodeArray;
  xmlNode: TXmlNode;
begin
  // Check if the place the user click on yields another node as the one we
  // are currently editing. If not then do not stop editing.
  GetCursorPos(P);
  P := FTree.ScreenToClient(P);
  Result := FTree.GetNodeAt(P.X, P.Y, True, Dummy) <> FNode;

  // pobieramy liste parentów
  pList := settingsForm.parentList( FNode );
  xmlNode := settingsForm.findXmlNode( pList );

  if Result then
  begin

    Data := FTree.GetNodeData(FNode);

    if FColumn = 1 then
    begin
      case Data.dataType of

        xdInteger:
          begin
            data.value := (FEdit[0] as TSpinEdit).Text;
          end;

        xdBoolean:
          begin
            data.value := (FEdit[0] as TComboBox).Text;
          end;

        xdComboBox:
          begin
            data.value := (FEdit[0] as TComboBox).Text;
          end;

        xdRange:
          begin

            data.value := inttostr((FEdit[0] as TSpinEdit).value) + ' ';

            if (FEdit[0] as TSpinEdit).Value > 0 then
            begin
              if ((FEdit[1] as TSpinEdit).Value = 0) then
              begin
                data.value := data.value + 'and above';
              end
              else
              begin
                data.value := data.value + 'to ' + inttostr((FEdit[1] as TSpinEdit).value);
              end;
            end
            else
            begin
              data.value := data.value + 'to ' + inttostr((FEdit[1] as TSpinEdit).value);
            end;

          end;

        xdRangePercent:
          begin

            data.value := inttostr((FEdit[0] as TSpinEdit).value) + ' ';

            if (FEdit[0] as TSpinEdit).Value > 0 then
            begin
              if ((FEdit[1] as TSpinEdit).Value = 0) then
              begin
                data.value := data.value + 'and above';
              end
              else
              begin
                data.value := data.value + 'to ' + inttostr((FEdit[1] as TSpinEdit).value);
              end;
            end
            else
            begin
              data.value := data.value + 'to ' + inttostr((FEdit[1] as TSpinEdit).value);
            end;

            if (FEdit[2] as TComboBox).Text = 'percent' then
              data.value := data.value + ' %';

          end;

      end;
    end
    else
    begin
      data.name := (FEdit[0] as TEdit).Text;
      xmlNode.NodeName := StringReplace( 'e' + data.name, ' ', '-', [rfReplaceAll] );
    end;

    xmlNode.Text := data.value;

    for i := 0 to FEditCount-1 do
      FEdit[i].Hide;
  end;
end;

function TPropertyEditLink.GetBounds: TRect;
begin
  Result := FEdit[0].BoundsRect;
end;

function TPropertyEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Data: ^TTreeData;
  i: integer;
  tmp: array[0..10] of string;
  percent, above: boolean;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  for i := 0 to FEditCount-1 do
  begin
    FEdit[i].Free;
    FEdit[i] := nil;
  end;

  Data := FTree.GetNodeData(Node);

  if Column = 1 then
  begin
    case Data.dataType of

      xdInteger:
        begin
          FEditCount := 1;
          FEdit[0] := TSpinEdit.Create(nil);
          with FEdit[0] as TSpinEdit do
          begin
            Visible := False;
            Parent := Tree;
            Text := Data.Value;
            width := 60;
            OnChange := settingsForm.EditSpinChange;
          end;
        end;

      xdBoolean:
        begin
          FEditCount := 1;
          FEdit[0] := TCombobox.Create(nil);
          with FEdit[0] as TCombobox do
          begin
            Style := csDropDownList;
            Visible := False;
            Parent := Tree;
            Items.Add('no');
            Items.Add('yes');
            ItemIndex := FindIndex( (FEdit[0] as TCombobox), Data.value );
          end;
        end;

      xdRange:
        begin
          tmp[0] := copy(Data.value, 1, pos(' ', Data.value) - 1);
          above := (pos('above', Data.value) > 0);

          if above then
            tmp[1] := '0'
          else
            tmp[1] := copy(Data.value, pos('to ', Data.value) + 3, length(Data.value));

          FEditCount := 2;
          FEdit[0] := TSpinEdit.Create(nil);
          with FEdit[0] as TSpinEdit do
          begin
            Visible := False;
            Parent := Tree;
            Text := tmp[0];
            width := 60;
            OnChange := settingsForm.EditSpinChange;
          end;

          FEdit[1] := TSpinEdit.Create(nil);
          with FEdit[1] as TSpinEdit do
          begin
            Visible := False;
            Parent := Tree;
            Text := tmp[1];
            width := 60;
            OnChange := settingsForm.EditSpinChange;
          end;
        end;

        xdRangePercent:
        begin
          tmp[0] := copy(Data.value, 1, pos(' ', Data.value) - 1);
          percent := (pos('%', Data.value) > 0);
          above := (pos('above', Data.value) > 0);

          if above then
            tmp[1] := '0'
          else
            tmp[1] := copy(Data.value, pos('to ', Data.value) + 3, length(Data.value));

          if percent then
            delete(tmp[1], pos(' %', tmp[1]), 2);

          FEditCount := 3;
          FEdit[0] := TSpinEdit.Create(nil);
          with FEdit[0] as TSpinEdit do
          begin
            Visible := False;
            Parent := Tree;
            Text := tmp[0];
            width := 60;
            OnChange := settingsForm.EditSpinChange;
          end;

          FEdit[1] := TSpinEdit.Create(nil);
          with FEdit[1] as TSpinEdit do
          begin
            Visible := False;
            Parent := Tree;
            Text := tmp[1];
            width := 60;
            OnChange := settingsForm.EditSpinChange;
          end;

          FEdit[2] := TCombobox.Create(nil);
          with FEdit[2] as TCombobox do
          begin
            Style := csDropDownList;
            Visible := False;
            Parent := Tree;
            Items.Add('exact');
            Items.Add('percent');

            if percent then
              ItemIndex := 1
            else
              ItemIndex := 0;

            Width := 60;
          end;
        end;

      xdComboBox:
        begin
          FEditCount := 1;
          FEdit[0] := TCombobox.Create(nil);
          with FEdit[0] as TCombobox do
          begin
            Style := csDropDownList;
            Visible := False;
            Parent := Tree;
            ComboAddItems( (FEdit[0] as TCombobox), Data.name );
            ItemIndex := FindIndex( (FEdit[0] as TCombobox), Data.value );
            Height := Node.NodeHeight;
          end;
        end;

      xdList:
        begin
          FEditCount := 1;
          FEdit[0] := TButton.Create(nil);
          with FEdit[0] as TButton do
          begin
            Visible := False;
            Parent := Tree;
            Height := Node.NodeHeight;
            Caption := '{ new }';
            OnClick := settingsForm.newItemClick;
          end;
        end;
                                  //we have to add "case" String: for scripts etc
      xdSubitem:
        begin
          FEditCount := 1;
          FEdit[0] := TButton.Create(nil);
          with FEdit[0] as TButton do
          begin
            Visible := False;
            Parent := Tree;
            Height := Node.NodeHeight;
            Caption := '{ remove }';
            OnClick := settingsForm.deleteItemClick;
          end;
        end

        else
        begin
          FEditCount := 1;
          FEdit[0] := TEdit.Create(nil);
          with FEdit[0] as TEdit do
          begin
            Visible := False;
            Parent := Tree;
            Text := Data.Value;
            //OnKeyDown := EditKeyDown;
          end;
        end;

    end;
  end
  else
  begin
    FEditCount := 1;
    FEdit[0] := TEdit.Create(nil);
    with FEdit[0] as TEdit do
    begin
      Visible := False;
      Parent := Tree;
      Text := Data.name;
      //OnKeyDown := EditKeyDown;
    end;
  end;

end;


procedure TPropertyEditLink.ProcessMessage(var Message: TMessage);
var
  i: integer;
begin
  for i := 0 to FEditCount-1 do
    FEdit[i].WindowProc(Message);
end;


procedure TPropertyEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);

  if (FEdit[0] is TEdit) or (FEdit[0] is TComboBox) then
  begin
    FEdit[0].BoundsRect := R;
    exit;
  end;

  if (FEdit[0] is TButton) then
  begin
    r.Right := R.Left + 100;
    FEdit[0].BoundsRect := R;
    exit;
  end;

  r.Right := R.Left + FEdit[0].Width;
  FEdit[0].BoundsRect := R;

  if Assigned(FEdit[1]) then
  begin
    r.Left := r.Left + FEdit[0].Width + 1;
    r.Right := r.Left + FEdit[1].Width;
    FEdit[1].BoundsRect := R;
  end;

  if Assigned(FEdit[2]) then
  begin
    r.Left := r.Left + FEdit[1].Width + 1;
    r.Right := r.Left + FEdit[2].Width;
    FEdit[2].BoundsRect := R;
  end;

end;

//----------------------------------------------------------------------------------------------------------------------
                         //we have created this here cause we will use it a lot while loading stuff
function TsettingsForm.initHealer(): boolean;
begin
  HealerThread:= THealerThread.Create(true);
  HealerThread.FXml := settings.Root.Find('sHealer'); //reassign Healer again!
  HealerThread.Start();
end;
             //here will go the other Threads initiations

procedure TsettingsForm.Save(Sender: TObject);
var
OpenDlg : TOpenDialog;
Path: string;
begin
  Path := IncludeTrailingPathDelimiter( extractFilePath(paramstr(0)));

  OpenDlg := TOpenDialog.Create(Self);
    OpenDlg.InitialDir:= Path + 'Scripts\';
    OpenDlg.Filter:= 'Scripts (*.xml)|*.xml';
    OpenDlg.Options:= [ofPathMustExist];

  if OpenDlg.Execute then begin    //we add the '.xml' if it isn't written
    if (pos('.xml', OpenDlg.Filename) = 0) then OpenDlg.FileName:=OpenDlg.FileName+ '.xml';
    settings.SaveToFile( OpenDlg.FileName );
  end;
 OpenDlg.Free;
end;

procedure TsettingsForm.Load(Sender: TObject);
var
OpenDlg : TOpenDialog;
Path: string;
Node1: PVirtualNode;
state: TEStates;
begin
//showmessage(settings.Root.NodeName);
  Path := IncludeTrailingPathDelimiter( extractFilePath(paramstr(0)));

  OpenDlg := TOpenDialog.Create(Self);
    OpenDlg.InitialDir:= Path + 'Scripts\';
    OpenDlg.Filter:= 'Scripts (*.xml)|*.xml';
    OpenDlg.Options:= [ofPathMustExist,ofFileMustExist];

  if OpenDlg.Execute then begin
    HealerThread.Terminate;
    Node1:= settingsForm.PropTree.RootNode;
       settings.LoadFromFile( OpenDlg.FileName );
     // showmessage('Loaded Settings.xml succesfully');

                  //apply that XML to the new Tree
      settingsForm.PropTree.DeleteNode(settingsForm.PropTree.RootNode.FirstChild, True);
      settingsForm.RecursivePropTree(Node1, settings.Root);
      settingsForm.initHealer();   //restart Healer
//      settingsForm.initTargeting/Cavebot/etc();   //restart other parts (Threads)
  end;
 OpenDlg.Free;
end;

function TsettingsForm.check(): boolean;
begin
result:=false;   //the problem is the FindNode (I've checked it)
if assigned(Findnode(PropTree.FocusedNode.Parent.FirstChild, 'NewRule1')) then
  result:= true;
end;

procedure TsettingsForm.deleteItemClick(Sender: TObject);
var                         //shiiiiiiiiit bro, spent like 2 days with this!
  node: PVirtualNode;
  xmlItem: TVerySimpleXML;
  pList: TExplodeArray;
  xmlNode: TXmlNode;
  nodeData: ^TTreeData;
  i: integer;
begin
//kk, we take the Node wich we are going to remove (the same as selected)
  node := PropTree.FocusedNode;
//  nodedata:= proptree.GetNodeData(node);
//  showmessage(nodedata.name);
  pList := settingsForm.parentList( node ); //now we do shit to get it in Xml yo!
  xmlNode := settingsForm.findXmlNode( pList );
  PropTree.DeleteNode( PropTree.FocusedNode );//kk, we delete the TreeView(visual GUI nub!)
  PropTree.EndEditNode;  //we finish doing that, cleaning it now and so...
//  showmessage(inttostr(xmlNode.Parent.ChildNodes.IndexOf(xmlNode)));
  i:= xmlNode.Parent.ChildNodes.IndexOf(xmlNode);
  //here we have to put the number of index (0 first,1 second,etc) that we want deleted
  xmlNode.Parent.ChildNodes.Delete(i);   //now we delete the Xml Code, else if we read it, it will still exist!
//  showmessage(inttostr(xmlNode.Parent.ChildNodes.Count));
end;

procedure TsettingsForm.newItemClick(Sender: TObject);
var
  node, fnode: PVirtualNode;
  nodeData: ^TTreeData;
  xmlItem: TVerySimpleXML;
  name: string;
  i: Integer;
  pList: TExplodeArray;
  xmlNode: TXmlNode;
begin

  node := PropTree.FocusedNode;
  nodeData := PropTree.GetNodeData( node );

  xmlItem := TVerySimpleXML.Create;
  case StringToCaseSelect(nodeData.name, ['ItemList', 'HealRules', 'HotkeyList',
                                          'PersistentList', 'CavebotList', 'DisplaysList',
                                          'Monsters']) of

    0: // ItemList
      begin
        xmlItem.LoadFromString( loadCleanNewItem() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

    1: // HealRules
      begin
        xmlItem.LoadFromString( LoadCleanNewRule() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

    2: // HotkeyList
      begin
        xmlItem.LoadFromString( loadCleanNewHotkey() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

    3: // PresistantList
      begin
        xmlItem.LoadFromString( loadCleanNewPersistent() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

    4: // Cavebot List
      begin
        xmlItem.LoadFromString( loadCleanNewCavebot() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

    5: // DisplaysList
      begin
        xmlItem.LoadFromString( loadCleanNewDisplay() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

    6: // Monsters
      begin
        xmlItem.LoadFromString( loadCleanNewMonster() );

        for i := 1 to 1000 do
        begin
          name := xmlItem.Root.NodeName;
          delete(name, 1, 1);
          name := name + inttostr(i);

          if not assigned( FindNode( node.FirstChild, name ) ) then
          begin
            xmlItem.Root.NodeName := 'e' + name;
            break;
          end;
        end;
      end;

  end;

  pList := settingsForm.parentList( node );
  xmlNode := settingsForm.findXmlNode( pList );

  if xmlNode.ChildNodes.Count = 0 then
    xmlNode.Text := '';

  RecursivePropTree(node, xmlItem.Root);
  RecursiveXmlTree( xmlNode, xmlItem.Root );
  xmlItem.Free;
end;


function TsettingsForm.FindNode( node: PVirtualNode; name: string ): PVirtualNode;
var
  nodeData: ^TTreeData;
begin

  result := nil;
  nodeData := PropTree.GetNodeData( node );

  while assigned(nodeData) do
  begin

    if nodeData.name = name then
    begin
      result := node;
      break;
    end;

    node := node.NextSibling;
    nodeData := PropTree.GetNodeData( node );
  end;

end;


function TsettingsForm.FindNodeEx( name: string; index: integer = -1 ): PVirtualNode;
var
  xNode: PVirtualNode;
  nodeData: ^TTreeData;
begin

  result := nil;
  if not assigned(PropTree.GetFirst()) then exit;

  xNode := PropTree.GetFirst();
  repeat
    xNode := PropTree.GetNext( xNode );
    nodeData := PropTree.GetNodeData( xNode );

    if index = -1 then
    begin
      if ( nodeData.name = name ) then
      begin
        result := xNode;
        break;
      end;
    end
    else
    begin
      if index = xNode.Index then
      begin
        result := xNode;
        break;
      end;
    end;

  until xNode = PropTree.GetLast();

end;

procedure TsettingsForm.SETSettingValue( arr: array of string; node: PVirtualNode; value: string );
var
  find, row: string;
  xNode: PVirtualNode;
  nodeData: ^TTreeData;
  xarr: array of string;
  i: Integer;
begin
  if length(arr) = 0 then
  begin
    nodeData := PropTree.GetNodeData( node );
    PropTree.BeginUpdate;
    nodeData.value:= value;
    PropTree.EndUpdate;
    exit;
  end;

  find := arr[ high(arr) ];

  setlength( xarr, length(arr) - 1 );
  for i := 0 to length(arr) - 2 do
    xarr[i] := arr[i];

  xNode := node.FirstChild;

  while Assigned(xNode) do
  begin

    nodeData := PropTree.GetNodeData( xNode );

    if lowercase(nodeData.name) = lowercase(find) then
    begin
      SETSettingValue( xarr, xNode, value );
      break;
    end;

    xNode := xNode.NextSibling;

  end;

end;

function TsettingsForm.FindSettingValue( arr: array of string; node: PVirtualNode ): string;
var
  find, row: string;
  xNode: PVirtualNode;
  nodeData: ^TTreeData;
  xarr: array of string;
  i: Integer;
begin
  result := '';
  if length(arr) = 0 then
  begin
    nodeData := PropTree.GetNodeData( node );
    result := nodeData.value;
    exit;
  end;

  find := arr[ high(arr) ];

  setlength( xarr, length(arr) - 1 );
  for i := 0 to length(arr) - 2 do
    xarr[i] := arr[i];

  xNode := node.FirstChild;

  while Assigned(xNode) do
  begin

    nodeData := PropTree.GetNodeData( xNode );

    if lowercase(nodeData.name) = lowercase(find) then
    begin
      result := FindSettingValue( xarr, xNode );
      break;
    end;

    xNode := xNode.NextSibling;

  end;

end;

procedure TsettingsForm.RecursiveXmlTree( pNode, node: TXmlNode );
var
  nodeList: TXmlNodeList;
  xNode: TXmlNode;
  i: integer;
begin

  xNode := pNode.AddChild( node.NodeName );
  xNode.Text := node.Text;

  nodeList := node.ChildNodes;

  if nodeList.Count > 0 then
  begin
    for i := 0 to nodeList.Count-1 do
    begin
      RecursiveXmlTree( xNode, nodeList.Items[i] );
    end;
  end;

end;

procedure TsettingsForm.RecursivePropTree( node: PVirtualNode; xmlNode: TXmlNode; first: boolean = false );
var
  xmlChildNode: TXmlNode;
  nodeData: ^TTreeData;
  i: integer;
  typ: Char;
begin

  if first then
    node := PropTree.AddChild( nil )
  else
  begin
    node := PropTree.AddChild( node );
  end;

  //node.NodeHeight := 20;
  nodeData := PropTree.GetNodeData( node );

  typ := xmlNode.NodeName[1];
  nodeData.name := xmlNode.NodeName;
  delete( nodeData.name, 1, 1 );

  case ord(typ) of

    ord('s'): // static
      begin
        nodeData.dataType := xdStatic;
        nodeData.value := '';
      end;

    ord('b'): // boolean
      begin
        nodeData.dataType := xdBoolean;
        nodeData.value := xmlNode.Text;
      end;

    ord('i'): // integer
      begin
        nodeData.dataType := xdInteger;
        nodeData.value := xmlNode.Text;
      end;

    ord('r'): // range
      begin
        nodeData.dataType := xdRange;
        nodeData.value := xmlNode.Text;
      end;

     //HealRules is here motherfcker... you said you were in "e", 3h looking for it ¬¬
    ord('l'): // list
      begin
        nodeData.dataType := xdList;
        nodeData.value := '..';
      end;

    ord('u'): // text list
      begin
        nodeData.dataType := xdTextList;
        nodeData.value := StringReplace( xmlNode.Text, '&#xd;', #13, [rfReplaceAll] );
      end;

    ord('t'): // text
      begin
        nodeData.dataType := xdText;
        nodeData.value := xmlNode.Text;
      end;

    ord('w'): // waypoint
      begin
        nodeData.dataType := xdWayPoint;
        nodeData.value := xmlNode.Text;

        if length(nodeData.name) = 0 then
          nodeData.name := copy( nodeData.value, 1, pos(' ', nodeData.value)-1 );
      end;

    ord('c'): // combobox
      begin
        nodeData.dataType := xdComboBox;
        nodeData.value := xmlNode.Text;
      end;

    ord('x'): // range percent
      begin
        nodeData.dataType := xdRangePercent;
        nodeData.value := xmlNode.Text;
      end;

    ord('e'): // subitem
      begin
        nodeData.dataType := xdSubitem;
        nodeData.name := StringReplace( nodeData.name, '-', ' ', [rfReplaceAll] );
        nodeData.value := '..';
      end;

  end;

  if xmlNode.ChildNodes.Count > 0 then
  begin
    for i := 0 to  xmlNode.ChildNodes.Count-1 do
    begin
      xmlChildNode := xmlNode.ChildNodes.Items[i];
      RecursivePropTree( node, xmlChildNode );
    end;
  end;
end;


procedure TsettingsForm.EditSpinChange(Sender: TObject);
begin
  if (Sender as TSpinEdit).Text = '' then
    (Sender as TSpinEdit).Value := 0;
end;

procedure TsettingsForm.FormCreate(Sender: TObject);
begin
  PropTree.NodeDataSize := sizeof(TVirtualNode);
end;

procedure TsettingsForm.PropTreeCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TPropertyEditLink.Create;
end;

procedure TsettingsForm.PropTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
var
  Data: ^TTreeData;

begin
  with Sender do
  begin
    Data := GetNodeData(Node);

    if (Node.Parent <> RootNode) and (Column = 0) and (Data.dataType in [xdSubitem]) then
      Allowed := true
    else
      Allowed := (Node.Parent <> RootNode) and (Column = 1) and not (Data.dataType in [xdStatic]);
  end;
end;

procedure TsettingsForm.PropTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  nodeData: ^TTreeData;
begin
  nodeData := Sender.GetNodeData(node);
  if Column = 0 then
    CellText := nodeData.name
  else
  begin
    CellText := nodeData.value;
  end;
end;

procedure TsettingsForm.PropTreeNodeDblClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
begin
  with Sender do
  begin
    // Start immediate editing as soon as another node gets focused.
    if Assigned(HitInfo.HitNode) and (HitInfo.HitNode.Parent <> RootNode) and not (tsIncrementalSearching in TreeStates) then
    begin
      // Note: the test whether a node can really be edited is done in the OnEditing event.
      EditNode(HitInfo.HitNode, 1);
    end;
  end;
end;

end.
