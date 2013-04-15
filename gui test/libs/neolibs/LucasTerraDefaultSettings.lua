LUCASSETTINGS_LIB = '1.3'
print('Lucas Terra Default Settings Version: '..LUCASSETTINGS_LIB)
local changesettings = true
if changesettings then
	setsetting('Cavebot/Looting/MoveItemsQuickly', 'yes') -- Enable it if you like, just remove the '--' in the beginning
	setsetting('Cavebot/Pathfinding/WalkableIds', '140\n404\n831-834\n883\n2131-2135\n2314-2316\n2319\n2346-2385\n2418-2426\n2431-2434\n2441-2444\n2469\n2471-2473\n2478\n2480-2486\n2519\n2523\n2775-2812\n2981-2985\n2987-2988\n3503-3504\n3514\n3807\n5086-5088\n6114-6115\n6355-6362\n6371-6372\n7864\n8455\n8763\n9061-9062\n10207\n10209\n10216\n10286\n10287-10288\n11009')
	setsetting('Hud/DisplaysList/ActiveHotkeys/Enabled', 'yes')
	setsetting('Hud/HudPolicy', 'Show if focused')
	setsetting('Input/Keyboard/KeyboardMode', 'Simulate keyboard')
	setsetting('Input/Keyboard/StuckCtrlShiftPolicy', 'If cavebot on, release after 1 sec')
	setsetting('Input/Keyboard/TypeWaitTime', '20 to 45')
	setsetting('Input/Keyboard/PressWaitTime', '45 to 65')
	setsetting('Input/Mouse/MouseMode', 'Simulate mouse') --'Control mouse /permit'
	setsetting('Input/Mouse/ScrollMode', 'Use mouse wheel')
	setsetting('Input/Mouse/StuckCursorPolicy', 'If cavebot on, release instantly')
	setsetting('Input/Mouse/MoveSpeed', 'Instantaneous') --Instantaneous
	setsetting('Input/Mouse/ClickWaitTime', '20 to 35')
	setsetting('Input/OpenMenuPolicy', 'Confirm if cavebotting')
	setsetting('Hotkeys/HotkeyCondition', 'Client focus required')
	if not getsetting('Hotkeys/HotkeyList/HideUnhideBot/Script') then
		addhotkey("HideUnhideBot", "listas('dontlist')\nshowbot()\nwait(300)", "u", "ctrl")
	else
		setsetting('Hotkeys/HotkeyList/HideUnhideBot/Script', "listas('dontlist')\nshowbot()\nwait(300)")
	end
	if not getsetting('Hotkeys/HotkeyList/HideUnhideSettings/Script') then
		addhotkey("HideUnhideSettings", "listas('dontlist')\nshowsettings()\nwait(300)", "j", "ctrl")
	else
		setsetting('Hotkeys/HotkeyList/HideUnhideSettings/Script', "listas('dontlist')\nshowsettings()\nwait(300)")
	end
	if not getsetting('Hotkeys/HotkeyList/PauseHotkey/Script') then
		addhotkey("PauseHotkey", "if not $targeting or not $cavebot then\n	settargeting('on')\n	setcavebot('on')\n	setlooting('on')\n	listas('Cavebot Resumed')\nelse\n	settargeting('off')\n	setcavebot('off')\n	setlooting('off')\n	listas('Cavebot Paused.')\nend\nwait(300)", "pause")
	end
	setsetting('Hud/DisplaysList/RecentLoot/Script', 'init start\n    local items = {\n                        [0xFFFF00] = {"demonic essence"}, --yellow\n                        [0xD30303] = {"royal helmet", "boots of haste"}, --red\n                  }\n    local default = 0x01C001 --the color for messages with no rares (green)\n    local maxtime = 20000 --maxtime a message will stay on your screen\n    local maxmsgs = 10 --max of messages that will be showed on your screen\n    local showonlyrare = true --set this to true if you only want to show loots that have rare items inside\n    local alert = true --this this to true if you want to alert if you got a loot with a rare item \n    --dont change things below\n \n    local fontsize = 8\n    local fontspacing = fontsize+3\n    setfontstyle("Tahoma", fontsize, 0x01C001, 1)\n    setfontweight(75)\n    setjustify("right")\n \n    for i,j in pairs(items) do\n        table.lower(j)\n    end\n    local lootmsgs = {}\n    local pos = (maxmsgs+1)*fontspacing\ninit end\nauto(100)\nforeach newmessage m do\n    if m.type ~= MSG_STATUSLOG then\n        local temp = m.content:lootmsg()\n        local msgcolor = default\n        local msg = ""\n        if temp.name ~= "" then\n            msg = temp.name..": "\n            if temp.items[1] then\n                for i,j in ipairs(temp.items) do\n                    msg = msg..j.count.." "..j.name..", "\n                    for a,b in pairs(items) do\n                        if msgcolor == default and table.find(b, j.name) then\n                            msgcolor = a\n                            if alert then playsoundflash("loot.wav") end\n                        end\n                    end\n                end\n                msg = msg:sub(1,#msg-2)\n            else\n                msg = msg.."empty"\n            end\n            if msgcolor ~= default or not showonlyrare then\n                table.insert(lootmsgs, {msg = msg, color = msgcolor, time = $timems+maxtime})\n            end\n        end\n    end\nend\nlocal row = 0\nfor i=#lootmsgs, 1, -1 do\n    if maxtime == 0 or $timems <= lootmsgs[i].time then\n		setfontcolor(lootmsgs[i].color)\n        addtext(lootmsgs[i].msg,0,(maxmsgs-row)*fontspacing, border, lootmsgs[i].color)\n        row = row+1\n    end\n    if row >= maxmsgs then\n        break\n    end\nend\n \nsetposition($worldwin.right-5, $worldwin.bottom-3-pos)', false)
	setsetting('Hud/DisplaysList/GeneralInfo/Script', 'local fontsize = 8\nlocal fontspacing = fontsize+2\n\nsetposition($clientwin.x+153, $clientwin.y+8)\nsetfontstyle("Tahoma", fontsize, 0xAAAAAA, 1)\nsetfontweight(75)\n\naddtext("Ping: " .. $pingaverage, 2, 2)\naddtext("Exp/h: " .. num($exphour), 82, 2)\naddtext("Next: " .. num(exptolevel()), 202, 2)\naddtext("Time: " .. time(timetolevel()), 322, 2)\n', false)
	setsetting('Hud/DisplaysList/SpellTimers/Script', 'local row = 0\nlocal fontsize = 8\nlocal fontspacing = fontsize+2\n\nsetposition($clientwin.x+8, $clientwin.y+8)\nsetfontstyle("Tahoma", fontsize, 0, 1)\nsetfontweight(75)\n\nif $hastetime > 0 then \n	setfontcolor(0x64FF64)\n	addtext("Haste:     " .. timeshort($hastetime), 2, 2)\n	row = 1\nend\n\nif $mshieldtime > 0 then\n	setfontcolor(0x6464FF)\n	addtext("MShield:  " .. timeshort($mshieldtime), 2, 2+row*fontspacing)\n	row = row + 1\nend\n\nif $invistime > 0 then \n	setfontcolor(0xFF64FF)\n	addtext("Invis:     " .. timeshort($invistime), 2, 2+row*fontspacing)\n	row = row + 1\nend\n\nif $strenghtentime > 0 then \n	setfontcolor(0xFF4646)\n	addtext("Strenght: " .. timeshort($strenghtentime), 2, 2+row*fontspacing)\n	row = row + 1\nend')
	setsetting('Hud/DisplaysList/ActiveHotkeys/Script', 'local fontsize = 8\nlocal fontspacing = fontsize+3\n\nsetfontstyle("Tahoma", fontsize, 0xE4B31B, 1)\nsetfontweight(75)\n\nlocal row = 0\n\nlocal i = 0\nwhile isscript("hotkey", i) do\n	local listname = scriptlistname("hotkey", i)\n\n	if listname ~= "" then\n		setfontcolor(scriptlistcolor("hotkey", i))\n		addtext(listname, 2, 2+row*fontspacing)\n		row = row + 1\n	end\n	i=i+1\nend\n\nlocal i = 0\nwhile isscript("persistent", i) do\n	local listname = scriptlistname("persistent", i)\n\n	if listname ~= "" then\n		setfontcolor(scriptlistcolor("persistent", i))\n		addtext(listname, 2, 2+row*fontspacing)\n		row = row + 1\n	end\n	i=i+1\nend\n\nlocal i = 0\nwhile isscript("cavebot", i) do\n	local listname = scriptlistname("cavebot", i)\n\n	if listname ~= "" then\n		setfontcolor(scriptlistcolor("cavebot", i))\n		addtext(listname, 2, 2+row*fontspacing)\n		row = row + 1\n	end\n	i=i+1\nend\n\nsetposition($clientwin.x+7, $worldwin.bottom-1-row*fontspacing)')
end

--setxpmode(true)