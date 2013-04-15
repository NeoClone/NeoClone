--    #########################################
--   #		Anonymickey's Library			 #
--  #	Last updated: 10/30 - 01:46 (v1.7)	#
-- #########################################

print('Anonymickey\'s Library loaded. Last updated: 10/30 - 01:46 (v1.7)')
print('Updates: http://forums.tibianeobot.com/showthread.php?2869')

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
	return itemcount('empty potion flask (small)') +  itemcount('empty potion flask (medium)') + itemcount('empty potion flask (large)')
end

function dropflasks() -- Working
	local flaskids = {'empty potion flask (small)', 'empty potion flask (medium)', 'empty potion flask (large)'}
	for i = 1, #flaskids do
		if itemcount(flaskids[i]) > 0 then
			dropitems('ground', flaskids[i])
			wait($ping * 1.4, $ping * 2.3)
		end
	end
end

function gold() -- Working
	return itemcount('gold coin') + itemcount('platinum coin') * 100 + itemcount('crystal coin') * 10000
end

function moveitemlist(locationto, locationfrom, ...) -- Working
	local t = {...}
	for i = 1, #t do
		if itemcount(t[i], locationfrom or '') > 0 then
			moveitems(t[i], locationto, locationfrom or '')
			wait($ping * 1.3, $ping * 2)
		end
	end
end

function npctalk(...) -- Working
	local s = 1
	local t = {...}
	if not ischannel('NPCs') then
		s = 2
		while not ischannel('NPCs') do
			say('Default', t[1])
			wait($ping * 4, $ping * 8)
		end
	end
	for i = s, #t do
		say('NPCs', t[i])
		wait($ping * 1.4, $ping * 2)
	end
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
	local numberkeys = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39}

	if type(key) == 'number' then
		if key == 0 then
			return 0x30
		end
		return numberkeys[key]
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

function exec(execstring) -- Working
	local func = loadstring(execstring)
	func()
end

function vocation() -- Working
	local weapontype = findweapontype()
	if weapontype == 'rod' then
		return 'druid'
	elseif wapontype == 'wand' then
		return 'sorcerer'
	else
		local vocs = {'unknown', 5, 'mage', 10, 'paladin', 15, 'knight'}
		return vocs[(table.find(vocs, ($maxhp-185)/($level-8)) or 0)+1]
	end
end

function maxcap() -- Working
	local vocs = {'unknown', 0, 'druid', 10, 'sorcerer', 10, 'mage', 10, 'paladin', 20, 'knight', 30}
	return vocs[table.find(vocs, vocation())+1] * ($level - 8) + 470
end

function drawline(dir, length, x, y) -- Working. Needs inprovement
	local tab = {horizontal = {'_', 10, 0}, vertical = {'|', 0, 10}}
	local x, y, char, xi, yi = x or 0, y or 0, tab.dir[1], tab.dir[2], tab.dir[3]
	if not char or not length then
		return
	end
	for i = 1, length/10 do
		addtext(char, x + xi * i, y + yi * i)
	end
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

function cetoffset() -- Probably working
	local now = os.time()
	return os.difftime(now, os.time(os.date("!*t", now)) + 3600)
end


function utctime() -- Working
	return tosec(os.date('%X')) - utcoffset()
end


function cettime() -- Probably working
	return tosec(os.date('%X')) - cetoffset()
end

function timezone() -- Working
	if utcoffset() then
		return 'UTC '..utcoffset()/3600
	end
	return 'UTC'
end

function sstime(world) -- Probably working
	world = world:lower()
	local ssworlds = {
		8, {'arcania', 'askara', 'aurea', 'berylia', 'celesta', 'furora', 'galana', 'guardia', 'iridia', 'kyra', 'morgana', 'nebula', 'obsidia', 'pandoria', 'refugia', 'saphira', 'selena', 'thoria', 'xerena'},
		9, {'aldora', 'antica', 'azuera', 'candia', 'danubia', 'elysia', 'eternia', 'harmonia', 'hiberna', 'inferna', 'isara', 'lunara', 'nerana', 'nova', 'premia', 'secura', 'titania', 'valoria'},
		11, {'astera', 'balera', 'danera', 'elera', 'empera', 'fortera', 'grimera', 'honera', 'jamera', 'keltera', 'lucera', 'luminera', 'malvera', 'menera', 'neptera', 'ocera', 'pythera', 'samera', 'shanera', 'shivera', 'silvera', 'tenebra', 'vinera', 'zanera'},
		12, {'amera', 'calmera', 'chimera', 'dolera', 'julera', 'libera', 'mythera', 'pacera', 'rubera', 'solera', 'trimera', 'unitera', 'xantera'}
						}
	for i = 2, 8, 2 do
		if table.binaryfind(ssworlds[i], world) then
			return (ssworlds[i-1] * 3600 - cettime()) % 86400
		end
	end
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
