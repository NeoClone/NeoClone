-- Raphael's Library v3.1
--		Last updated: 10/06 - 18:57

--[[
 * Changelog v3.1
 *
 * - Reworked some parts of button and listbox classes, thanks to Tonin.
 * - Updates sstime(), since now all servers have the same sever save time.
 * - Added invitepary(..), joinparty(..), revokeparty(..), partyleadership(..) and leaveparty().
 *
--]]



RAPHAEL_LIB = "3.1"
print('Raphael\'s Library loaded. Last updated: 10/06 - 18:57 (v' .. RAPHAEL_LIB .. ')')

table.unpack = table.unpack or unpack
unpack = unpack or table.unpack


-- HUD Events
iEvent_MouseEnter = IEVENT_MOUSEENTER
iEvent_MouseLeave = IEVENT_MOUSELEAVE
iEvent_MouseMove  = IEVENT_MOUSEMOVE
iEvent_MiddleDown = IEVENT_MMOUSEDOWN
iEvent_MiddleUp   = IEVENT_MMOUSEUP
iEvent_RightDown  = IEVENT_RMOUSEDOWN
iEvent_RightUp    = IEVENT_RMOUSEUP
iEvent_LeftDown   = IEVENT_LMOUSEDOWN
iEvent_LeftUp     = IEVENT_LMOUSEUP
iEvent_KeyDown    = IEVENT_KEYDOWN
iEvent_KeyUp      = IEVENT_KEYUP


local skills = {
	magic = {$mlevelpc, nil, nil, nil, nil, nil, nil},
	fist = {$fistpc, nil, nil, nil, nil, nil, nil},
	club = {$clubpc, nil, nil, nil, nil, nil, nil},
	sword = {$swordpc, nil, nil, nil, nil, nil, nil},
	axe = {$axepc, nil, nil, nil, nil, nil, nil},
	distance = {$distancepc, nil, nil, nil, nil, nil, nil},
	shielding = {$shieldingpc, nil, nil, nil, nil, nil, nil},
	fishing = {$fishingpc, nil, nil, nil, nil, nil, nil}
}

function flasks() -- Working
	return itemcount(283) +  itemcount(284) + itemcount(285)
end

function dropflasks() -- Working
	local flaskids = {283, 284, 285}
	for i = 1, #flaskids do
		if itemcount(flaskids[i]) > 0 then
			moveitems(flaskids[i], 'ground')
			waitping()
		end
	end
end

function gold() -- Working
	return itemcount(3031) + itemcount(3035) * 100 + itemcount(3043) * 10000
end

function moveitemlist(locationto, locationfrom, ...) -- Working
	local t = {...}
	for i = 1, #t do
		if itemcount(t[i], locationfrom or '') > 0 then
			moveitems(t[i], locationto, locationfrom or '')
			waitping()
		end
	end
end

function npctalk(...) -- Working
	local arg = {...}

	-- Adjust settings to lower tab pressingtime.
	local presswait = get('PressWaitTime')
	set('PressWaitTime', '200 to 300')

	-- Checks for caps lock and normal wait parameters.
	local cc, nw
	if type(arg[#arg]) == 'boolean' then
		if type(arg[#arg-1]) == 'boolean' then
			if arg[#arg] then
				nw = true
			end
			if arg[#arg-1] then
				cc = true
			end
			table.remove(arg)
		elseif arg[#arg] then
			cc = true
		end
		table.remove(arg)
	end

	local f
	-- Sets the desired wait method.
	if nw then
		f = function()
				waitping()
				return true
			end
	else
		f = function(msg, type)
				local c = 0
				while c < 30 do
					foreach newmessage m do
						if m.sender == $name and m.content == msg and m.type == type then
							return true
						end
					end
					c = c + 1
					wait(90, 110)
				end
				return false
			end

		-- Makes all args string
		for k, v in ipairs(arg) do
			v = tostring(v)
		end
	end

	-- Checks the caps lock
	if cc then
		press("a")
		wait(200, 400)
		if $typedtext == "A" then
			table.upper(arg)
			--press("[CAPSLOCK]")
			--waitping()
		end
	end

	local p = false
	if not ischannel('NPCs') then
		while not p do
			say('Default', arg[1])
			p = f(arg[1], MSG_DEFAULT)
		end
		table.remove(arg, 1)
		wait(400, 600)
	end

	for k, v in ipairs(arg) do
		p = false
		while not p do
			say('NPCs', v)
			p = f(v, MSG_SENT)
			if not p then
				if not ischannel('NPCs') then
					npctalk(select(k, ...))
					return
				end
			end
		end
	end

	set('PressWaitTime', presswait)

end

function skilltime(skilltype) -- Needs to be remade/adjusted.
	local percent = {magic = $mlevelpc, fist = $fistpc, club = $clubpc, sword = $swordpc, axe = $axepc, distance = $distancepc, shielding = $shieldingpc, fishing = $fishingpc}
	local skillpc = percent[skilltype]
	if skillpc ~= skills[skilltype][1] then
		if skillpc ~= 0 then
			if skills[skilltype][3] then
				skills[skilltype][2] = ($timems - skills[skilltype][3]) * (100 - skillpc) / (skillpc - skills[skilltype][1])
			else
				skills[skilltype][2] = nil
			end
		end
		skills[skilltype][1] = skillpc
		skills[skilltype][3] = $timems
	end
	if skills[skilltype][2] then
		return math.max(math.floor((skills[skilltype][2] - ($timems - skills[skilltype][3])) / 1000), 0)
	else
		return 0
	end
end

function keyid(key) -- Working -- Find full list at: http://api.farmanager.com/en/winapi/virtualkeycodes.html
	local keys = {MOUSELEFT = 0x01, MOUSERIGHT = 0x02, MOUSEMIDDLE = 0x04, BACKSPACE = 0x08, TAB = 0x09, CLEAR = 0x0C, ENTER = 0x0D, SHIFT = 0x10, CTRL = 0x11, ALT = 0x12, PAUSE = 0x13, CAPSLOCK = 0x14, ESC = 0x1B, SPACE = 0x20, PAGEUP = 0x21, PAGEDOWN = 0x22, END = 0x25, HOME = 0x24, LEFTARROW = 0x25, UPARROW = 0x26, RIGHTARROW = 0x27, DOWNARROW = 0x28, SELECT = 0x29, PRINT = 0x2A, ExECUTE = 0x2B, PRINTSCREEN =0x2C, INSERT = 0x2D, DELETE = 0x2E, HELP = 0x2F, A = 0x41, B = 0x42, C = 0x43, D = 0x44, E = 0x45, F = 0x46, G = 0x47, H = 0x48, I = 0x49, J = 0x4A, K = 0x4B, L = 0x4C, M = 0x4D, N = 0x4E, O = 0x4F, P = 0x50, Q = 0x51, R = 0x52, S = 0x53, T = 0x54, U = 0x55, V = 0x56, W = 0x57, x = 0x58, Y = 0x59, Z = 0x5A, SLEEP = 0x5F, NUM0 = 0x60, NUM1 = 0x61, NUM2 = 0x62, NUM3 = 0x63, NUM4 = 0x64, NUM5 = 0x65, NUM6 = 0x66, NUM7 = 0x67, NUM8 = 0x68, NUM9 = 0x69, MULTIPLY = 0x6A, ADD = 0x6B, SEPARATOR = 0x6C, SUBTRACT = 0x6D, DECIMAL = 0x6E, DIVIDE = 0x6F, F1 = 0x70, F2 = 0x71, F3 = 0x72, F4 = 0x73, F5 = 0x74, F6 = 0x75, F7 = 0x76, F8 = 0x77, F9 = 0x78, F10 = 0x89, F11 = 0x7A, F12 = 0x7B, F13 = 0x7C, F14 = 0x7D, F15 = 0x7E, F16 = 0x7F, F17 = 0x80, F18 = 0x81, F19 = 0x82, F20 = 0x83, F21 = 0x84, F22 = 0x85, F23 = 0x86, F24 = 0x87, NUMLOCK = 0x90, SCROLLLOCK = 0x91, COMMA = 0xBC, HIFFEN = 0xBD, DOT = 0xBE, BAR = 0xBF, SINGLEQUOTE = 0xD3}
	local numberkeys = {0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39}

	if tonumber(key) then
		return numberkeys[key + 1]
	end
	return keys[string.upper(key)]
end

function press(keys) -- Working
	local i = 1
	while i <= #keys do
		local key = ''
		if string.sub(keys, i, i) == '[' then
			i2 = i + string.find(string.sub(keys, i), ']')
			key = string.sub(keys, i+1, i2-2)
			keyevent(keyid(key))
			i = i2
		elseif string.sub(keys, i, i) ~= ']' then
			keyevent(keyid(string.sub(keys, i, i)))
			i = i + 1
		end
	end
end

function itemprice(itemname) -- Working
	return itemcost(itemname)
end


function filecontent(filename) -- Working
	if not fileexists(filename) then
		return ''
	end
	local handler = io.open(filename, 'r')
	content = handler:read('*a')
	handler:close()
	return content
end

function filelinescount(filename) -- Working
	if not fileexists(filename) then
		return 0
	end
	local linecount = 0
	for line in io.lines(filename) do
		linecount = linecount + 1
	end
	return linecount
end

function fileline(filename, linenum) -- Working
	local linen, linew = 0, ''
	for line in io.lines(filename) do
		linen = linen + 1
		if linen == linenum then
			linew = line
		end
	end
	return linew
end

function filewrite(filename, text) -- Working.
	local handler = io.open(filename, 'a+')
	handler:write(text)
	handler:close()
end

function fileexists(filename) -- Working
	local handler, exists = io.open(filename), false
	if type(handler) ~= 'nil' then
		exists = true
		handler:close()
	end
	local handler = nil
	return exists
end

function createfile(filename) -- Working
	if not fileexists(filename) then
		clearfile(filename)
	end
end

function execfile(filename)
	exec(filecontent(filename))
end

function filewriteline(filename, text) -- Working.
	local skip = ''
	if filelinescount(filename) > 0 then
		skip = '\n'
	end
	local handler = io.open(filename, 'a+')
	handler:write(skip..text)
	handler:close()
end

function clearfile(filename) -- Working.
	local handler = io.open(filename, 'w+')
	handler:close()
end

function filerewrite(filename, text)
	local handler = io.open(filename, 'w+')
	handler:write(text)
	handler:close()
end

function isfileline(filename, text) -- Working
	local n = 0
	if fileexists(filename) then
		for line in io.lines(filename) do
			n = n + 1
			if line == text then
				return n
			end
		end
	end
	return false
end

file = {}
file.content = filecontent
file.linescount = filelinescount
file.line = fileline
file.write = filewrite
file.exists = fileexists
file.create = createfile
file.exec = execfile
file.writeline = filewriteline
file.clear = clearfile
file.rewrite = filerewrite
file.isline = isfileline

function exec(execstring) -- Working
	local func = loadstring(execstring)
	local arg = {pcall(func)}
	table.insert(arg, arg[1])
	table.remove(arg, 1)
	return table.unpack(arg)
end

function vocation() -- Working
	local voc = 'unknown'
	local vocs = {
		mage = 5,
		paladin = 10,
		knight = 15
		}

	local hpplevel = ($maxhp - 185) / ($level - 8)
	for k, v in pairs(vocs) do
		if hpplevel == v then
			voc = k
			break
		end
	end

	if voc == 'mage' then
		local items = {
			druid = {
				rhand	= {3065, 3066, 3067, 3069, 3070, 8082, 8083, 8084},
				chest	= {8038, 8041}
			},

			sorcerer = {
				rhand	= {3071, 3072, 3073, 3074, 3075, 8092, 8093, 8094},
				chest	= {8037, 8039, 8040, 8062}
			}
		}

		for k, v in pairs(items) do
			for p, q in pairs(v) do
				local id = exec('return $' .. p .. '.id')
				for _, x in ipairs(q) do
					if x == id then
						return k
					end
				end
			end
		end
	end
	return voc
end

function maxcap() -- Working
	local vocs = {
		unknown = 0,
		druid = 10,
		sorcerer = 10,
		mage = 10,
		paladin = 20,
		knight = 30
	}
	return vocs[vocation()] * ($level - 8) + 470
end

function string.explode(self, sep) -- By Socket, improved by Hardek. Working
    local result = {}
    self:gsub("[^".. sep .."*]+", function(s) table.insert(result, (string.gsub(s, "^%s*(.-)%s*$", "%1"))) end)
    return result
end

function sethealrule(rule, hprange, mprange, method, condition, spam) -- Working
	local settings = {'HealthRange', 'ManaRange', 'HealMethod', 'ExtraCondition', 'SpamRate'}
	local settingsTo = {((hprange:find('%%') and hprange:find(' %%')) and hprange:gsub('-', ' to ') or hprange:gsub('-', ' to '):gsub('%%', ' %%')):lower(), ((mprange:find('%%') and mprange:find(' %%')) and mprange:gsub('-', ' to ') or mprange:gsub('-', ' to '):gsub('%%', ' %%')):lower(), method:capitalizeall(), ((condition:lower():find('paralyze')) and 'If paralyzed' or ((condition == '') and 'No condition')):capitalize(), ((not spam) and '' or spam:gsub('-', ' to ')):lower()}

	for i = 1, #settings do
		setsetting('Healer/HealRules/'..rule..'/'..settings[i], settingsTo[i] or getsetting('Healer/HealRules/'..rule..'/'..settings[i]))
	end
end

function string.capitalize(self) -- Working
	return string.upper(self:sub(1,1)) .. self:sub(2):lower()
end

function string.capitalizeall(self) -- Working
	local t = string.explode(self, ' ')
	for i = 1, #t do
		t[i] = t[i]:capitalize()
	end
	return table.concat(t, ' ')
end

function bestskill() -- Working
	local t = {$axe+$axepc/100, {type = 'axe', skill = $axe, skillpc = $axepc}, $club+$clubpc/100, {type = 'club', skill = $club, skillpc = $clubpc}, $sword+$swordpc/100, {type = 'sword', skill = $sword, skillpc = $swordpc}, $distance+$distancepc/100, {type = 'distance', skill = $distance, skillpc = $distancepc}, $fist+$fistpc/100, {type = 'fist', skill = $fist, skillpc = $fistpc}}
	local j = 0
	for i = 1, #t, 2 do
		j = math.max(j, t[i])
	end
	return t[table.find2(t, j)+1]
end

function weaponskill() -- Working
	local t = {'axe', {type = 'axe', skill = $axe, skillpc = $axepc}, 'club', {type = 'club', skill = $club, skillpc = $clubpc}, 'sword', {type = 'sword', skill = $sword, skillpc = $swordpc}, {'bow', 'distance weapon'}, {type = 'distance', skill = $distance, skillpc = $distancepc}, 'no weapon', {type = 'fist', skill = $fist, skillpc = $fistpc}, {'rod', 'wand'}, {type = 'magic', skill = $mlevel, skillpc = $mlevelpc}}
	return t[table.find2(t, findweapontype())+1]
end

function table.find2(self, value, arg, notable, argonly) -- Working
	for i = 1, #self do
		if not argonly then
			if self[i] == value then
				return i
			end
		end
		if type(self[i]) == 'table' then
			if arg then
				if self[i][arg] == value then
					return i
				end
			elseif not notable then
				for j = 1, #self[i] do
					if self[i][j] == value then
						return i, j
					end
				end
			end
		end
	end
end

function exptolvl(a, b) -- Working
	a = a or $level + 1
	if b then
		return exptolvl(b) - exptolvl(a)
	elseif a then
		return 50 / 3 * (a ^ 3 - 6 * a ^ 2 + 17 * a - 12)
	end
end

function levelpc() -- Working
	return math.floor(($exp - exptolvl($level)) * 100 / exptolvl($level, $level + 1))
end

function table.random(self, start, finish, count, step) -- Working
	self = {}
	step = step or 1
	count = (count ~= 0 and count) and count or math.floor((finish - start) / step)
	for i = 1, count do
		local r = math.random(start, finish)
		while table.find(self, r) do
			r = math.random(start, finish)
		end
		table.insert(self, r)
	end
	return self
end

function iscursorin(sx, sy, fx, fy, area) -- working
	if type(sx) == 'table' then
		area = true
		fx = sx.width
		fy = sx.height
		sy = sx.y
		sx = sx.x
	end

	if area then
		fx, fy = sx + fx, sy + fy
	end
	if $cursor.x >= sx then
		if $cursor.x <= fx then
			if $cursor.y >= sy then
				if $cursor.y <= fy then
					return true
				end
			end
		end
	end
	return false
end

function utcoffset() -- Working
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)) - (os.date('*t').isdst and 3600 or 0))
end

function cetoffset() -- Working
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)) - (os.date('*t').isdst and 3600 or 0) + ((os.date('*t').yday > 141 and os.date('*t').yday < 233) and 7200 or 3600))
end


function utctime() -- Working
	return tosec(os.date('%X')) - utcoffset()
end


function cettime() -- Working
	return tosec(os.date('%X')) - cetoffset()
end

function timezone() -- Working
	if utcoffset() then
		return 'UTC '..utcoffset()/3600
	end
	return 'UTC'
end

function sstime() -- Working
	return (36000 - cettime()) % 86400
end

function time(secs, pattern) -- Working
	local times = {dd = math.floor(secs / 86400), hh = math.floor(secs / 3600) % 24, mm = math.floor(secs / 60) % 60, ss = secs % 60}
	if not pattern then
		if times.dd > 0 then
			pattern = 'dd:hh:mm:ss'
		elseif times.hh > 0 then
			pattern = 'hh:mm:ss'
		else
			pattern = 'mm:ss'
		end
	end
	pattern = pattern:lower()
	for k, v in pairs(times) do
		pattern = string.gsub(pattern, k, math.format(v, "00"))
	end
	return pattern
end

function math.format(self, pattern) -- Working
	local a, b = pattern, tostring(self)
	local c, d = (a:find("%.")), (b:find("%."))
	local za, zb = math.max(0, (c or #a + 1) - (d or #b + 1)), math.max(0, (#a - (c or 99999)) - (#b - (d or #b)))
	local dot = (c and not d) and '.' or ''
	return string.rep("0", za) .. b .. dot .. string.rep("0", zb)
end

function beep() -- Working
	playsound('monster.wav')
end

function sqmWidth() -- Working
	return ($worldwin.right - $worldwin.left) / 15
end

function distto(...) -- Working
	local arg = {...}
	local a, b, anyfloor
	if type(arg[1]) == 'userdata' then
		a = {x = arg[1].posx, y = arg[1].posy, z = arg[1].posz}
		if type(arg[2]) == 'userdata' then
			b = {x = arg[2].posx, y = arg[2].posy, z = arg[2].posz}
			anyfloor = arg[3]
		else
			b = {x = arg[2], y = arg[3], z = arg[4]}
			anyfloor = arg[5]
		end
	else
		a = {x = arg[1], y = arg[2], z = arg[3]}
		if type(arg[4]) == 'userdata' then
			b = {x = arg[4].posx, y = arg[4].posy, z = arg[4].posz}
			anyfloor = arg[5]
		else
			b = {x = arg[4], y = arg[5], z = arg[6]}
			anyfloor = arg[7]
		end
	end
	return (anyfloor or a.z == b.z) and math.max(math.abs(a.x - b.x), math.abs(a.y - b.y)) or -1
end

function string.at(self, n) -- Working
	return string.sub(self, n, n)
end

function string.ends(self, substr) -- Working
	return string.sub(self, -#substr) == substr
end

function string.starts(self, substr) -- Working
	return string.sub(self, #substr) == substr
end

function table.isempty(self) -- Working
	return next(self) == nil
end

function table.size(self) -- Working
	local i = 0
	for j in pairs(self) do
		i = i + 1
	end
	return i
end

function toyesno(arg) -- Working
	local returns = {true, 'yes', 'yes', false, 'no', 'no', nil, 'no'}
	local i = table.find2(returns, arg)
	if i then
		return returns[i+1]
	else
		return toyesno(arg ~= 0 and arg ~= '')
	end
end

function pm(message, ...) -- Working
	local players = {...}
	if #players > 1 then
		for k, v in ipairs(players) do
			pm(message, v)
		end
	elseif #players == 1 then
		local player = players[1]
		if ischannel(player) then
			say(player, message)
		else
			for i = 1, #player-1 do
				if ischannel(string.sub(player, 1, i) .. "...") then
					say(string.sub(player, 1, i) .. "...", message)
					return
				end
			end
			say('*' .. player .. '* ' .. message)
		end
	end
end

function sethotkey(hkname, state) -- Working
	if string.find(hkname, '/') then
		setsetting(hkname, toyesno(state))
	else
		if getsetting('Hotkeys/PersistentList/'..hkname..'/Enabled') then
			sethotkey('Hotkeys/PersistentList/'..hkname..'/Enabled', state)
		elseif getsetting('Hotkeys/CavebotList/'..hkname..'/Enabled', state) then
			sethotkey('Hotkeys/CavebotList/'..hkname..'/Enabled', state)
		else
			error('bad argument #1 to \'sethotkey\' (hotkey \'' .. hkname .. '\' couldn\'t be found)')
		end
	end
end

function getcont(location, bpsonly, index) -- Working
	local a, b = location or 0, location or 15
	local backpacks =  {2854, 2865, 2866, 2867, 2868, 2869, 2870, 2871, 2872, 3253, 5801, 5926, 5949, 7342, 8860, 9601, 9602, 9604, 9605, 10202, 10324, 10326, 10327, 10346}
	local conts = {}
	for i = a, b do
		local cont = getcontainer(i)
		if  cont.isopen and cont.itemcount >= 1 then
			for k = 1, cont.itemcount do
				local item = cont.item[k]
				if bpsonly then
					if table.find(backpacks, item.id) then
						table.insert(conts, item.id)
					end
				elseif itemproperty(item.id, 4) then
					table.insert(conts, item.id)
				end
			end
		end
	end
	if index then
		return conts[index] or nil
	else
		return conts
	end
end

function movewhilemoveable(x, y, z, dx, dy, dz) -- Working
	local dx, dy, dz = dx or $posx, dy or $posy, dz or $posz
	local id = topitem(x, y, z).id
	while not itemproperty(id, 13) do
		moveitems(id, ground(dx, dy, dz), ground(x, y, z))
		waitping()
		id = topitem(x, y, z).id
	end
end

function boatprice(source, dest, post) -- Working. Credits to MeMyselfI
	local boat_table = {
		["ab'dendriel"] = {
			carlin = 80,
			edron = 70,
			thais = 130,
			venore = 90,
			yalahar = 160
		},
		ankrahmun = {
			edron = 160,
			["liberty bay"] = 90,
			["port hope"] = 80,
			venore = 150,
			yalahar = 230
		},
		carlin = {
			edron = 110,
			svargrond = 110,
			thais = 110,
			venore = 130,
			yalahar = 185
		},
		darashia = {
			["liberty bay"] = 200,
			["port hope"] = 180,
			venore = 60,
			yalahar = 210
		},
		edron = {
			ankrahmun = 160,
			carlin = 110,
			["liberty bay"] = 170,
			["port hope"] = 150,
			thais = 160,
			venore = 40
		},
		goroma = {
			["liberty bay"] = 0
		},
		["liberty bay"] = {
			darashia = 200,
			edron = 170,
			goroma = 500,
			["port hope"] = 50,
			thais = 180,
			venore = 180,
			yalahar = 275
		},
		["port hope"] = {
			darashia = 180,
			edron = 150,
			["liberty bay"] = 50,
			thais = 160,
			venore = 160,
			yalahar = 260
		},
		svargrond = {
			thais = 180,
			venore = 150
		},
		thais = {
			carlin = 110,
			edron = 160,
			["liberty bay"] = 180,
			["port hope"] = 160,
			svargrond = 180,
			venore = 170,
			yalahar = 200
		},
		venore = {
			ankrahmun = 150,
			carlin = 130,
			darashia = 60,
			edron = 40,
			["liberty bay"] = 180,
			["port hope"] = 160,
			svargrond = 150,
			thais = 170,
			yalahar = 185
		},
		yalahar = {
			ankrahmun = 230,
			carlin = 185,
			darashia = 210,
			["liberty bay"] = 275,
			["port hope"] = 260,
			thais = 200,
			venore = 185
		}
	}

	source, dest = source:lower(), dest:lower()
	local i = boat_table[source]
	if i then
		i = i[dest]
		if i then
			return i - (post and 10 or 0)
		end
		printerror('Can\'t travel to ' .. dest .. ' from ' .. source .. '.')
		return 0
	end
	printerror('Couldn\'t find location ' .. source .. '.')
end

function listversion() -- Working
	return itemid('list version')
end

function findgrounditem(id, index) -- Working
	local items = {}
	local index = index or 1
	if type(id) == 'string' then
		id = itemid(id)
	end
	local fx, tx, fy, ty, z = $posx - 7, $posx + 7, $posy - 5, $posy + 5, $posz
	for y = fy, ty do
		for x = fx, tx do
			if topitem(x, y, z).id == id then
				table.insert(items, {x, y, z})
			end
		end
	end
	if #items >= index then
		return table.unpack(items[index])
	else
		return 0, 0, 0
	end
end

function canlevitate(x, y, z) -- Working
	z = z or $posz
	local tile = gettile(x, y, z)
	local c = 0
	for i = 1, tile.itemcount do
		local id = tile.item[i].id
		if itemproperty(id, 25) and not itemproperty(id, 30) then
			c = c + 1
		end
	end
	return c >= 3
end

function findrope(hotkeys) -- Working
	if itemcount(3003) >= 1 then
		return 'Rope'
	elseif itemcount(646) >= 1 then
		return 'Elvenhair rope'
	elseif itemcount(9598) >= 1 then
		return 'Driller'
	elseif hotkeys then
		if clientitemhotkey(3003) ~= 'not found' then
			return 'Rope'
		elseif clientitemhotkey(646) ~= 'not found' then
			return 'Elvenhair rope'
		elseif clientitemhotkey(9598) ~= 'not found' then
			return 'Driller'
		end
	else
		return nil
	end
end

function findshovel(hotkeys) -- Working
	if itemcount(3457) >= 1 then
		return 'Shovel'
	elseif itemcount(5710) >= 1 then
		return 'Light shovel'
	elseif itemcount(9598) >= 1 then
		return 'Driller'
	elseif hotkeys then
		if clientitemhotkey(3457) ~= 'not found' then
			return 'Shovel'
		elseif clientitemhotkey(5710) ~= 'not found' then
			return 'Light shovel'
		elseif clientitemhotkey(9598) ~= 'not found' then
			return 'Driller'
		end
	else
		return nil
	end
end

function getpath(setting, path, entry) -- Working
	if getsetting(setting) then
		return setting
	end

	if entry then
		local name = getsetting(entry, '_name')
		if string.ends(path .. name, setting) then
			return path .. name
		elseif #name > 0 then
			foreach settingsentry e (path .. name) do
				local s = getpath(setting, path .. name .. '/', e)
				if s then
					return s
				end
			end
		end
	else
		for _, v in ipairs({'Alerts', 'Cavebot', 'Healer', 'Hotkeys', 'Hud', 'Input', 'Targeting'}) do
			foreach settingsentry e v do
				local s = getpath(setting, v .. '/', e)
				if s then
					return s
				end
			end
		end
	end
	return nil
end

function set(setting, value, updgui) -- Working
	updgui = updgui or true
	local path = getpath(setting)
	if path then
		setsetting(path, value, updgui)
	else
		error('bad argument #1 to \'set\' (the specified setting does not exist)')
	end
end

function get(setting) -- Working
	local path = getpath(setting) or ''
	return getsetting(path, value, updgui)
end

function string.sub2(self, i, l) -- Working
	if l then
		return string.sub(self, i, i + l - math.min(1, i))
	else
		return string.sub(self, i)
	end
end

function ground(...) -- Working
	local arg = {...}
	if type(arg[1]) == 'table' then
		arg = {arg.x or arg.posx or $posx, arg.y or arg.posy or $posy, arg.z or arg.posz or $posz}
	elseif type(arg[1]) == 'userdata' then
		arg = {arg.posx, arg.posy, arg.posz}
	else
		arg = {arg[1] or $posx, arg[2] or $posy, arg[3] or $posz}
	end
	return "ground " .. table.concat(arg,  " ")
end

border = "border"
shadow = "shadow"
_ADDTEXT = _ADDTEXT or addtext
function addtext(...)
	local arg = {...}
	arg[2], arg[3] = arg[2] or 0, arg[3] or 0
	if arg[4] then
		local o = arg[7] or 1
		setfontcolor(arg[6] or 0x000000)
		_ADDTEXT(arg[1], arg[2] - o, arg[3] + o)
		if arg[4] == border then
			_ADDTEXT(arg[1], arg[2] + o, arg[3] - o)
			_ADDTEXT(arg[1], arg[2] + o, arg[3] + o)
			_ADDTEXT(arg[1], arg[2] - o, arg[3] - o)
			_ADDTEXT(arg[1], arg[2] - o, arg[3])
			_ADDTEXT(arg[1], arg[2] + o, arg[3])
			_ADDTEXT(arg[1], arg[2], arg[3] + o)
			_ADDTEXT(arg[1], arg[2], arg[3] - o)
		end
		setfontcolor(arg[5] or 0xFFFFFF)
	end
	_ADDTEXT(arg[1], arg[2], arg[3])
end


function isBetween(v1, v2, x, y, w, h)
	if v1 >= x then
		if v1 <= x + w then
			if v2 >= y then
				if v2 <= y + h then
					return true
				end
			end
		end
	end
	return false
end

function isadmin()
	return (pcall(
		function()
			local handler = io.open('test.txt', 'w+')
			handler:write('test')
			handler:close()
		end
	))
end

function compversions(a, b)
	local a, b = string.explode(tostring(a), "%."), string.explode(tostring(b), "%.")
	for i = 1, math.max(#a, #b) do
		a[i] = tonumber(a[i]) or 0
		b[i] = tonumber(b[i]) or 0
		if b[i] < a[i] then
			return false
		elseif b[i] > a[i] then
			return true
		end
	end
	return true
end

function inviteparty(...)
	if $self.party % 2 == 0 then
		local arg = {...}
		for _, v in ipairs(arg) do
			local who = findcreature(v)
			if who.party == PARTY_NOPARTY then
				contextmenu('Invite to Party', findcreature(v))
				waitping()
			end
		end
	end
end

function joinparty(whose)
	if $self.party == PARTY_NOPARTY then
		local who = findcreature(whose)
		if who.party == PARTY_INVITED_LEADER then
			contextmenu('Join ' .. whose ..  '\'s Party', findcreature(whose))
			waitping()
		end
	end
end

function leaveparty()
	if $self.party ~= PARTY_NOPARTY then
		contextmenu('Leave Party', $self)
		waitping()
	end
end

function revokeparty(...)
	if $self.party % 2 == 0 then
		local arg = {...}
		for _, v in ipairs(arg) do
			local who = findcreature(v)
			if who.party == PARTY_INVITED_MEMBER then
				contextmenu('Revoke ' .. v ..  '\'s Invitation', findcreature(v))
				waitping()
			end
		end
	end
end

function partyleadership(who)
	if $self.party % 2 == 0 then
		local who = findcreature(who)
		if who.party > 2 then
			contextmenu('Pass Leadership to ' .. who, findcreature(who))
			waitping()
		end
	end
end

local Default = {}
Default.Button = {}
Default.Button.Size = {x = 50, y = 20}
Default.Button.Spacing = {x = 6, y = 6}
Default.Button.Position = {x = 0, y = 0}
Default.Button.Action = function() end
Default.Button.Text = "Button"


------------------------------------------------------------------------------
--                Oriented Object Programming - First Try                   --
------------------------------------------------------------------------------

Align = {
	left = "left",
	right = "right",
	bot = "bottom",
	top = "top"
}

Order = {
	up = "upwards",
	down = "downwards"
}


Listbox = {}

-- Creates the object
function Listbox:new(obj)
	obj = obj or {}
	if not obj.lines then
		obj.lines = {}
	end
	if not obj.defaultColor then
		obj.defaultColor = 0xFFFFFF
	end
	if not obj.maxIndex then
		obj.maxIndex = 5
	end
	if not obj.verAlign then
		obj.verAlign = Align.bot
	end
	if not obj.horAlign then
		obj.horAlign = Align.left
	end
	if not obj.spacing then
		obj.spacing = 13
	end
	if not obj.order then
		obj.order = Order.down
	end
	return setmetatable(obj, {__index = self})
end

function Listbox:setDefaultColor(color)
	self.defaultColor = color
end

function Listbox:getDefaultColor()
	return self.defaultColor
end

function Listbox:setMaxIndex(maxIndex)
	self.maxIndex = maxIndex
end

function Listbox:getMaxIndex()
	return self.maxIndex
end

function Listbox:setOrder(ord)
	self.order = ord
end

function Listbox:getOrder(ord)
	return self.order
end

function Listbox:setAlignment(...)
	local arg = {...}
	if not select(2, self:getAlignment(arg[1]:sub(1, 3))) then
		self[arg[1]:sub(1, 3) .. "Align"] = arg[2]
	else
		self.horAlign, self.verAlign = arg[1], arg[2]
	end
end

function Listbox:getAlignment(way)
	way = (way or "abc"):sub(1, 3)
	if way == "hor" then
		return self.horAlign
	elseif way == "ver" then
		return self.verAlign
	else
		return self.horAlign, self.verAlign
	end
end

function Listbox:setLineSpacing(spacing)
	self.spacing = spacing
end

function Listbox:getLineSpacing()
	return self.spacing
end

function Listbox:getLine(index)
	return self.lines[index]
end

function Listbox:size()
	return #self.lines
end

function Listbox:checkSize()
	local maxindex = self:getMaxIndex()
	local i
	if self:getOrder() == Order.up then
		i = 1
	end
	while self:size() > maxindex do
		self:rmvLine(i)
	end
end

function Listbox:addLine(value, color, index)
	local i = self:size()
	if self:getOrder() == Order.down then
		i = 1
	end
	table.insert(self.lines, index or i, {text = value, color = color})
	self:checkSize()
end

function Listbox:rmvLine(index)
	table.remove(self.lines, index)
end

function Listbox:setPosition(x, y)
	local hor, ver = self:getAlignment()
	local size, spac = self:size(), self:getLineSpacing()
	if ver == Align.bot then
		y = y - (size * spac)
	end
	setjustify(hor)
	setposition(x, y)
end

function Listbox:draw()
	local size = self:size()
	local maxindex = self:getMaxIndex()
	local spacing = self:getLineSpacing()
	local color = self:getDefaultColor()
	if size > 0 then
		for i = 1, size do
			local line = self:getLine(i)
			setfontcolor(line.color or color)
			addtext(line.text, 0, (i - 1) * spacing)
		end
	end
end

------------------------------------------------------------------------------
--                Oriented Object Programming - Second Try                  --
------------------------------------------------------------------------------

State = {
	Released = 0,
	Pressed = 1
}

Button = {}

-- Object creator
function Button:new(obj)
	obj = obj or {}

	-- Checks for non-defined values
	obj.Size = obj.Size or Default.Button.Size
	obj.Spacing = obj.Spacing or Default.Button.Spacing
	obj.Position = obj.Position or Default.Button.Position
	obj.Action = obj.Action or Default.Button.Action
	obj.Text = obj.Text or Default.Button.Text

	return setmetatable(obj, {__index = self})
end

-- Pressed or Not
Button.State = 0
Button.AutoSize = true

function Button:setText(t)
	self.Text = t
	if self.AutoSize then
		local w, h = calcstringsize(t)
		w, y = w + self.Spacing.x * 2, y + self.Spacing.y * 2
		self:setSize(w, y)
	end
end

function Button:getText()
	return self.Text
end

function Button:setSize(x, y)
	self.Size.x = x
	self.Size.y = y
end

function Button:getSize()
	return self.Size
end

function Button:setSpacing(x, y)
	self.Spacing.x = x
	self.Spacing.y = y
	if self.AutoSize then
		self:setText(self.Text)
	end
end

function Button:getSpacing()
	return self.Spacing
end

function Button:setState(state)
	self.State = state
end

function Button:getState()
	return self.State
end

function Button:setPosition(x, y)
	self.Position.x = x
	self.Position.y = y
end

function Button:getPosition()
	return self.Position
end

function Button:setEvent(f)
	self.Action = f
end

function Button:runEvent()
	self.Action()
end

function Button:setAutoSize(v)
	self.AutoSize = v
	if v then
		self:setText(self.Text)
	end
end

function Button:draw()
	-- Sets predefined options
	setfontweight(255)
	setbordercolor(0x000000)
	setfillstyle("image", "Button.png")
	setfontstyle("Tahoma", 8, 0xDFDFDF)

	-- Sets some variables for later use
	local colors = {0x6D6D6D, 0x2A2A2A, 0x6D6D6D}
	local Pos = self.Position
	local Size = self.Size

	-- Draws the button shape
	addshape("rect", Pos.x, Pos.y, Size.x, Size.y)

	-- Draws upper and left borders
	setbordercolor(colors[self.State +1])
	addshape("rect", Pos.x + 1, Pos.y, Size.x - 1, -1)
	addshape("rect", Pos.x, Pos.y, -1, Size.y)

	-- Draws bottom and right borders
	setbordercolor(colors[self.State +2])
	addshape("rect", Pos.x + 1, Pos.y + Size.y + 1, Size.x - 1, -1)
	addshape("rect", Pos.x + Size.x + 1, Pos.y, -1, Size.y)

	-- Adds the text
	addtext(self.Text, Pos.x + self.Spacing.x + self.State, Pos.y + self.Spacing.y + self.State)
end
