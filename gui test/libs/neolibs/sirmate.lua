SIRMATE_LIB = '1.3'
print('sirmate library loaded. version: ' .. SIRMATE_LIB .. '.')

-- [[ Vocation names ]] --
VOCATIONS = {'druid', 'elder druid', 'elite knight', 'knight', 'master sorcerer', 'paladin', 'royal paladin', 'sorcerer'}
BASIC_VOCATIONS = {'druid', 'knight', 'paladin', 'sorcerer'}
PROMOTED_VOCATIONS = {'elder druid', 'elite knight', 'master sorcerer', 'royal paladin'}

-- [[ Outfits IDs ]] --
FREE_OUTFITS = {128, 129, 130, 131, 136, 137, 138, 139}
PREMIUM_OUTFITS = {132, 133, 134, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 251, 252, 268, 269, 270, 273, 278, 279, 288, 289, 324, 325, 328, 329, 335, 336, 366, 367}
MALE_OUTFITS = {128, 129, 130, 131, 132, 133, 134, 143, 144, 145, 146, 151, 152, 153, 154, 251, 268, 273, 278, 289, 325, 328, 335, 367}
FEMALE_OUTFITS = {136, 137, 138, 139, 140, 141, 142, 147, 148, 149, 150, 155, 156, 157, 158, 252, 269, 270, 279, 288, 324, 329, 336, 366}

-- [[ Param and Haste spells ]] --
PARAM_SPELLS = {'utevo res ina', 'exiva', 'exura sio', 'exani hur', 'utevo res'}
HASTE_SPELLS = {'utani hur', 'utani gran hur', 'utani tempo hur', 'utamo tempo san'}

-- [[ List of supplies items ]] --
POTIONS_AND_RUNES = {'antidote potion', 'berserk potion', 'bullseye potion', 'great health potion', 'great mana potion', 'great spirit potion', 'health potion', 'mana potion', 'mastermind potion', 'small health potion', 'strong health potion', 'strong mana potion', 'ultimate health potion', 'animate dead rune', 'avalanche rune', 'chameleon rune', 'convince creature rune', 'cure poison rune', 'desintegrate rune', 'destroy field rune', 'energy bomb rune', 'energy field rune', 'energy wall rune', 'explosion rune', 'fire bomb rune', 'fire field rune', 'fire wall rune', 'fireball rune', 'great fireball rune', 'heavy magic missile rune', 'holy missile rune', 'icicle rune', 'intense healing rune', 'light magic missile rune', 'magic wall rune', 'paralyze rune', 'poison bomb rune', 'poison field rune', 'poison wall rune', 'soulfire rune', 'stalagmite rune', 'stone shower rune', 'sudden death rune', 'thunderstorm rune', 'ultimate healing rune', 'wild growth rune'}
AMMUNITION = {'arrow', 'burst arrow', 'earth arrow', 'flaming arrow', 'flash arrow', 'onyx arrow', 'poison arrow', 'shiver arrow', 'sniper arrow', 'bolt', 'infernal bolt', 'piercing bolt', 'power bolt'}
DISTANCE_WEAPONS = {'assassin star', 'enchanted spear', 'hunting spear', 'royal spear', 'small stone', 'snowball', 'spear', 'throwing Knife', 'throwing star', 'viper star'}

-- [[ Stats clear constants ]] --
SC_ALL_SECTIONS = 0
SC_MONSTERS_SEEN = 1
SC_PLAYERS_SEEN = 2
SC_MONSTERS_KILLED = 3
SC_ITEMS_LOOTED = 4
SC_SUPPLIES_USED = 5
SC_DAMAGE_DEALT = 6
SC_DAMAGE_RECEIVED = 7
SC_DAMAGE_STATS = 8
SC_HEAL_STATS = 9

local BINARY_INSERT_COMPARE_FUNCTION_NOKEY = function(first, second) return first < second end
local BINARY_INSERT_COMPARE_FUNCTION_WITHKEY = function(first, second, argument) return first[argument] < second[argument] end

function table.binaryinsert(self, value, argument) -- Working
	local compare_function
	if (type(argument) == 'function') then
		compare_function = argument
	elseif (type(argument) == 'string') then
		compare_function = BINARY_INSERT_COMPARE_FUNCTION_WITHKEY
	else
		compare_function = BINARY_INSERT_COMPARE_FUNCTION_NOKEY
	end

	local left, right, mid, state = 1, #self, 1, 0
	while (left <= right) do
		mid = math.floor((left + right) / 2)

		if (compare_function(value, self[mid], ((type(argument) == 'string' and argument) or nil))) then
			right, state = mid - 1, 0
		else
			left, state = mid + 1, 1
		end
	end

	table.insert(self, mid + state, value)
	return mid + state
end

function arguments(function_name, function_arguments) -- Working
	for i = 1, #function_arguments, 2 do
		if (type(function_arguments[i + 1]) ~= function_arguments[i]) then
			return false, error('bad argument #' .. math.ceil(i / 2)  .. ' to \'' .. function_name .. '\' (' .. function_arguments[i] .. ' expected, got ' .. type(function_arguments[i + 1]) .. ')', 3)
		end
	end
end

local UNIT_DATA_FILE = 'player.data'
local UNIT_DATA_RUN_LAST = $timems
local UNIT_DATA_RUN_DELAY = 100
local UNIT_DATA_SAVE_LAST = $timems
local UNIT_DATA_SAVE_DELAY = 60000

Unit = {
	data = {}
}

function Unit:getPlayersData(cache_players_data) -- Working
	if (type(cache_players_data) ~= 'boolean') then cache_players_data = false end

	if (UNIT_DATA_RUN_LAST + UNIT_DATA_RUN_DELAY >= $timems) then return end
	
	if (#self.data == 0 and cache_players_data) then
		if (#filecontent(UNIT_DATA_FILE) ~= 0) then
			self.data = dofile('neofiles/' .. UNIT_DATA_FILE .. '.txt')
			table.newsort(self.data, 'name', 'asc')
		end
	end

	foreach newmessage m do
		if (table.find({MSG_CHANNEL, MSG_DEFAULT, MSG_PVT, MSG_SENT, MSG_TUTOR, MSG_WHISPER, MSG_YELL}, m.type) and m.level ~= 0) then
			local message_sender = m.sender:lower()
			local player_found = table.binaryfind(self.data, message_sender, 'name')

			if (player_found) then
				self.data[player_found].level = tonumber(m.level)
			else
				table.binaryinsert(self.data, {name = message_sender, level = tonumber(m.level), sex = 'unknown', vocation = 'unknown', gname = '', grank = '', gtitle = '', spells = {}}, 'name')
				player_found = table.binaryfind(self.data, message_sender, 'name')
			end

			if (m.type == MSG_DEFAULT) then
				local message_content = m.content

				for _, param_spell in ipairs(PARAM_SPELLS) do
					if (message_content:match("^" .. param_spell .. " \".+")) then
						message_content = param_spell break
					end
				end

				local spell_info = Spell:getInfo(message_content, 'words')

				if (type(spell_info) == 'table' and tonumber(m.level) >= spell_info.level) then
					local spell_found = table.binaryfind(self.data[player_found].spells, spell_info.name, 'name')

					if (table.find(HASTE_SPELLS, spell_info.words)) then
						for _, haste_spell in ipairs(HASTE_SPELLS) do
							local haste_spell_info = Spell:getInfo(haste_spell)
							local haste_spell_found = table.find(self.data[player_found].spells, haste_spell_info.name, 'name')

							if (haste_spell_found) then
								self.data[player_found].spells[haste_spell_found].lastuse = $timems - 1000 - ((haste_spell_info.cooldown > haste_spell_info.duration and haste_spell_info.cooldown) or haste_spell_info.duration) * 1000
							end
						end
					end
					
					if (spell_found) then
						self.data[player_found].spells[spell_found].lastuse = $timems
					else
						table.binaryinsert(self.data[player_found].spells, {name = spell_info.name, lastuse = $timems}, 'name')
					end
					
					if (not table.binaryfind(PROMOTED_VOCATIONS, self.data[player_found].vocation) and #self.data[player_found].spells ~= 0) then Unit:getVocation(message_sender) end
				end
			end
		elseif (m.type == MSG_INFO and m.content:match('^You see')) then
			local player_name, player_level, player_sex, player_vocation, player_guildinfo = string.match(m.content, "You see (.+) %(.-(%d+).- ([S]?[hH]e) is an? (.-)%.(.*)")
			local player_guild_name, player_guild_rank, player_guild_title = '', '', ''

			if (#(player_guildinfo or '') > 0) then
				player_guild_rank, player_guild_name = string.match(player_guildinfo, ".-is (.+) of the (.+)%.")

				if (string.find(player_guild_name, "%(")) then
					player_guild_name, player_guild_title = string.match(player_guild_name, "(.+) %((.+)%)")
				end
			end

			if (player_name and player_level and player_sex and player_vocation and player_guild_name and player_guild_rank and player_guild_title) then
				player_name = player_name:lower()
				local player_found = table.binaryfind(self.data, player_name, 'name')

				if (player_found) then
					self.data[player_found] = {name = player_name, level = tonumber(player_level), sex = (player_sex == 'He' and 'male') or 'female', vocation = player_vocation, gname = player_guild_name:lower(), grank = player_guild_rank:lower(), gtitle = player_guild_title:lower(), spells = self.data[player_found].spells}
				else
					table.binaryinsert(self.data, {name = player_name, level = tonumber(player_level), sex = (player_sex == 'He' and 'male') or 'female', vocation = player_vocation, gname = player_guild_name:lower(), grank = player_guild_rank:lower(), gtitle = player_guild_title:lower(), spells = {}}, 'name')
				end
			end
		end
	end

	if (UNIT_DATA_SAVE_LAST + UNIT_DATA_SAVE_DELAY <= $timems and cache_players_data) then
		local PLAYER_DATA = ''
		for _, p in ipairs(self.data) do
			PLAYER_DATA = PLAYER_DATA .. '	{name = "'.. p.name .. '", level = '.. p.level .. ', sex = "'.. p.sex .. '", vocation = "'.. p.vocation .. '", gname = "'.. p.gname .. '", grank = "'.. p.grank .. '", gtitle = "'.. p.gtitle .. '", spells = {}},\n'
		end

		filerewrite(UNIT_DATA_FILE, 'return {\n' .. PLAYER_DATA .. '}')
		UNIT_DATA_SAVE_LAST = $timems
	end
	
	UNIT_DATA_RUN_LAST = $timems
end

function Unit:getName(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (self:isPlayer(unit_name) or self:isMonster(unit_name) or self:isNPC(unit_name)) then
			return ((unit_name.name ~= nil and unit_name.name) or unit_name):lower()
		end
	end

	return nil
end

function Unit:getLevel(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (((unit_name.name ~= nil and unit_name.name) or unit_name):lower() == $name:lower()) then
			return $level
		elseif (self:isPlayer(unit_name)) then
			if (type(unit_name) == 'userdata') then unit_name = unit_name.name end
			local unit_found = table.binaryfind(self.data, unit_name:lower(), 'name')

			if (unit_found) then
				return self.data[unit_found].level
			end
		end
	end

	return 0
end

function Unit:getSex(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if self:isPlayer(unit_name) then
			local unit_found = table.binaryfind(self.data, ((unit_name.name ~= nil and unit_name.name) or unit_name):lower(), 'name')

			if (unit_found) then
				if (type(unit_name) == 'userdata' and self.data[unit_found].sex == 'unknown') then
					if (table.binaryfind(MALE_OUTFITS, unit_name.outfit)) then
						self.data[unit_found].sex = 'male'
					elseif (table.binaryfind(FEMALE_OUTFITS, unit_name.outfit)) then
						self.data[unit_found].sex = 'female'
					end
				end

				return self.data[unit_found].sex
			end
		end
	end

	return 'unknown'
end

function Unit:getVocation(unit_name, basic) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then unit_name = findcreature(unit_name) end
		if (type(basic) ~= 'boolean') then basic = false end

		if (self:isPlayer(unit_name)) then
			if (type(unit_name) == 'userdata') then unit_name = unit_name.name end
			local unit_found, player_vocation = table.binaryfind(self.data, unit_name:lower(), 'name'), 'unknown'

			if (unit_found) then
				player_vocation = self.data[unit_found].vocation

				if (table.binaryfind(PROMOTED_VOCATIONS, self.data[unit_found].vocation)) then
					player_vocation = self.data[unit_found].vocation
				elseif (not table.binaryfind(PROMOTED_VOCATIONS, self.data[unit_found].vocation) and #self.data[unit_found].spells ~= 0) then
					for _, spell in ipairs(self.data[unit_found].spells) do
						local spell_info = Spell:getInfo(spell.name, 'name')

						if (type(spell_info) == 'table') then
							if (spell_info.vocation ~= false) then
								player_vocation, self.data[unit_found].vocation = spell_info.vocation, spell_info.vocation
								if (table.binaryfind(PROMOTED_VOCATIONS, spell_info.vocation)) then break end
							end
						end
					end
				end

				if (unit_name:lower() == $name:lower() and player_vocation == 'unknown') then
					local _vocation = vocation()

					if (_vocation ~= 'mage') then
						player_vocation, self.data[unit_found].vocation = _vocation, _vocation
					end
				end
			end

			if (basic) then
				return player_vocation:gsub('master ', ''):gsub('elite ', ''):gsub('elder ', ''):gsub('royal ', '')
			end

			return player_vocation
		end
	end

	return 'unknown'
end

function Unit:getGuildInfo(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then unit_name = findcreature(unit_name) end

		if (self:isPlayer(unit_name)) then
			local unit_found = table.binaryfind(self.data, ((unit_name.name ~= nil and unit_name.name) or unit_name):lower(), 'name')

			if (unit_found) then
				if (#self.data[unit_found].gname ~= 0) then
					return {name = self.data[unit_found].gname, rank = self.data[unit_found].grank, title = self.data[unit_found].gtitle}
				end
			end
		end
	end

	return {name = '', rank = '', title = ''}
end

function Unit:getHealth(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (((unit_name.name ~= nil and unit_name.name) or unit_name):lower() == $name:lower()) then
			return $hp
		else
			local unit_health_percent, unit_health_max = self:getHealthPercent(unit_name), self:getHealthMax(unit_name)

			if (unit_health_percent ~= 0 and unit_health_max ~= 0) then
				return math.floor((unit_health_percent / 100) * unit_health_max)
			end
		end
	end

	return 0
end

function Unit:getHealthPercent(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.hppc
		end
	end

	return 0
end

function Unit:getHealthMax(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (((unit_name.name ~= nil and unit_name.name) or unit_name):lower() == $name:lower()) then
			return $maxhp
		end

		if (type(unit_name) == 'userdata') then
			unit_name = unit_name.name
		end

		if (self:isMonster(unit_name)) then
			return creatureinfo(unit_name).hp
		else
			local unit_found = table.binaryfind(self.data, unit_name:lower(), 'name')

			if (unit_found) then
				if (table.binaryfind({'elite knight', 'knight'}, self.data[unit_found].vocation)) then
					return (self.data[unit_found].level * 15) + 65
				elseif (table.binaryfind({'paladin', 'royal paladin'}, self.data[unit_found].vocation)) then
					return (self.data[unit_found].level * 10) + 105
				else
					return (self.data[unit_found].level * 5) + 145
				end
			end
		end
	end

	return 0
end

function Unit:getMana(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (((unit_name.name ~= nil and unit_name.name) or unit_name):lower() == $name:lower()) then
			return $mp
		end
	end

	return 0
end

function Unit:getManaPercent(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (((unit_name.name ~= nil and unit_name.name) or unit_name):lower() == $name:lower()) then
			return $mppc
		end
	end

	return 0
end

function Unit:getManaMax(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (((unit_name.name ~= nil and unit_name.name) or unit_name):lower() == $name:lower()) then
			return $maxmp
		elseif (self:isPlayer(unit_name)) then
			local unit_found = table.binaryfind(self.data, ((unit_name.name ~= nil and unit_name.name) or unit_name):lower(), 'name')

			if (unit_found) then
				if (table.binaryfind({'druid', 'elder druid', 'master sorcerer', 'sorcerer'}, self.data[unit_found].vocation)) then
					return (self.data[unit_found].level * 30) - 205
				elseif (table.binaryfind({'paladin', 'royal paladin'}, self.data[unit_found].vocation)) then
					return (self.data[unit_found].level * 15) - 85
				else
					return (self.data[unit_found].level * 5) - 5
				end
			end
		end
	end

	return 0
end

function Unit:getBaseSpeed(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (self:getLevel(unit_name) ~= 0) then
			return 220 + (2 * (self:getLevel(unit_name) - 1))
		end
	end

	return 0
end

function Unit:getCastedSpells(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (self:isPlayer(unit_name)) then
			local unit_found = table.binaryfind(self.data, ((unit_name.name ~= nil and unit_name.name) or unit_name):lower(), 'name')

			if (unit_found) then
				return self.data[unit_found].spells
			end
		end
	end

	return {}
end

function Unit:getActiveSpells(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		local active_spells = {}
		
		for _, spell in ipairs(self:getCastedSpells(unit_name)) do
			local spell_info = Spell:getInfo(spell.name, 'name')
			local spell_time = ((spell_info.cooldown > spell_info.duration and spell_info.cooldown) or spell_info.duration) * 1000

			if (spell.lastuse + spell_time >= $timems) then
				table.binaryinsert(active_spells, {name = spell_info.name, time = spell.lastuse - $timems + spell_time, group = spell_info.group1}, 'name')
			end
		end
		
		return active_spells
	end

	return {}
end

function Unit:getCooldown(unit_name, spell_name, group_cooldown) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (self:isPlayer(unit_name)) then
			if (type(unit_name) == 'userdata') then unit_name = unit_name.name end
			local unit_found = table.binaryfind(self.data, unit_name:lower(), 'name')

			if (unit_found and type(spell_name) ~= 'nil') then
				spell_name = spell_name:lower()
				if (type(group_cooldown) ~= 'nil') then group_cooldown = true end
				local function getGroupCooldown(unit_name, group_name)
					local group_times = {attack = 2000, healing = 1000, special = 8000, support = 2000}

					if (unit_name:lower() == $name:lower()) then
						return cooldown(group_name), group_times[group_name]
					end

					for _, spell in ipairs(Spell.data) do
						if spell.group1 == group_name then
							local spell_found = table.binaryfind(self.data[unit_found].spells, spell.name, 'name')

							if (type(spell_found) ~= 'nil') then
								local spell_lastuse = self.data[unit_found].spells[spell_found].lastuse

								if (spell_lastuse + group_times[group_name] >= $timems) then
									return spell_lastuse - $timems + group_times[group_name], group_times[group_name]
								end
							end
						end
					end

					return 0, group_times[group_name]
				end

				if table.binaryfind({'attack', 'healing', 'special', 'support'}, spell_name) then
					return getGroupCooldown(unit_name, spell_name)
				else
					local spell_info = Spell:getInfo(spell_name)

					if (type(spell_info) ~= 'nil') then
						local spell_found = table.binaryfind(self.data[unit_found].spells, spell_info.name, 'name')
						local spell_time = ((spell_info.cooldown > spell_info.duration and spell_info.cooldown) or spell_info.duration) * 1000

						if (type(spell_found) ~= 'nil') then
							local spell_lastuse = self.data[unit_found].spells[spell_found].lastuse

							if (spell_lastuse + spell_time >= $timems) then
								return spell_lastuse - $timems + spell_time, spell_time
							end
						end

						if (group_cooldown) then
							return getGroupCooldown(unit_name, spell_info.group1)
						end
					end
				end
			end
		end
	end

	return 0, 0
end

function Unit:isPlayer(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (table.binaryfind(self.data, ((unit_name.name ~= nil and unit_name.name) or unit_name):lower(), 'name')) then
			return true
		end

		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.isplayer
		end
	end

	return false
end

function Unit:isMonster(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.ismonster and type(creatureinfo(unit_name.name)) == 'table'
		end
	end

	return false
end

function Unit:isNPC(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.ismonster and type(creatureinfo(unit_name.name)) ~= 'table'
		end
	end

	return false
end

function Unit:isPremium(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			if (self:isPlayer(unit_name)) then
				if (self:isPromoted(unit_name)) then
					return true
				end

				if (self:isMounted(unit_name)) then
					return true
				end

				if ((table.find(FREE_OUTFITS, unit_name.outfit) and unit_name.addons ~= 0) or table.find(PREMIUM_OUTFITS, unit_name.outfit)) then
					return true
				end
			end
		end
	end

	return false
end

function Unit:isPromoted(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (self:isPlayer(unit_name)) then
			if (table.binaryfind(PROMOTED_VOCATIONS, self:getVocation(unit_name))) then
				return true
			end
		end
	end

	return false
end

function Unit:isMounted(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.mount ~= 0
		end
	end

	return false
end

function Unit:isParalyzed(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.speed < self:getBaseSpeed(unit_name)
		end
	end

	return false
end

function Unit:isStealthed(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.outfit == 0
		end
	end

	return false
end

function Unit:isSwimming(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.outfit == 267
		end
	end

	return false
end

function Unit:isInMyGuild(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) == 'number') then
			unit_name = findcreature(unit_name)
		end

		if (self:isPlayer(unit_name)) then
			local self_guild = self:getGuildInfo($name)
			local unit_guild = self:getGuildInfo((unit_name.name ~= nil and unit_name.name) or unit_name)

			if (self_guild and unit_guild) then
				if (#self_guild.name ~= 0 and #unit_guild.name ~= 0) then
					return self_guild.name == unit_guild.name
				end
			end
		end
	end

	return false
end

function Unit:isInParty(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.party ~= PARTY_NOPARTY and unit_name.party ~= PARTY_INVITED_LEADER and unit_name.party ~= PARTY_INVITED_MEMBER
		end
	end

	return false
end

function Unit:isPartyLeader(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			return unit_name.party == PARTY_EXPSHARE_OK_LEADER or unit_name.party == PARTY_EXPSHARE_OFF_LEADER or unit_name.party == PARTY_EXPSHARE_WAIT_LEADER or unit_name.party == PARTY_ONPARTY_LEADER
		end
	end

	return false
end

function Unit:canMount(unit_name) -- Working
	if (table.find({'number', 'string', 'userdata'}, type(unit_name))) then
		if (type(unit_name) ~= 'userdata') then
			unit_name = findcreature(unit_name)
		end

		if (type(unit_name) == 'userdata') then
			if (self:isPlayer(unit_name)) then
				if (not self:isMounted(unit_name) and (table.binaryfind(FREE_OUTFITS, unit_name.outfit) or table.binaryfind(PREMIUM_OUTFITS, unit_name.outfit))) then
					return true
				end
			end
		end
	end

	return false
end

Spell = {
	data = {
		{words = "adana ani", name = "paralyze rune", group1 = "support", group2 = "", type = "rune", vocation = "elder druid", cooldown = 2, duration = 1, level = 54, mp = 1400, premium = true, soul = 3, mlevel = 18, condition = "7"},
		{words = "adana mort", name = "animate dead rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 27, mp = 600, premium = true, soul = 5, mlevel = 4, condition = "1"},
		{words = "adana pox", name = "cure poison rune", group1 = "support", group2 = "", type = "rune", vocation = "druid", cooldown = 2, duration = 1, level = 15, mp = 200, premium = false, soul = 1, mlevel = 0, condition = "7"},
		{words = "adeta sio", name = "convince creature rune", group1 = "support", group2 = "", type = "rune", vocation = "druid", cooldown = 2, duration = 1, level = 16, mp = 200, premium = false, soul = 3, mlevel = 5, condition = "7"},
		{words = "adevo grav flam", name = "fire field rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 15, mp = 240, premium = false, soul = 1, mlevel = 1, condition = "7"},
		{words = "adevo grav pox", name = "poison field rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 14, mp = 200, premium = false, soul = 1, mlevel = 0, condition = "7"},
		{words = "adevo grav tera", name = "magic wall rune", group1 = "support", group2 = "", type = "rune", vocation = "master sorcerer", cooldown = 2, duration = 1, level = 32, mp = 750, premium = true, soul = 5, mlevel = 9, condition = "7"},
		{words = "adevo grav vis", name = "energy field rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 18, mp = 320, premium = false, soul = 2, mlevel = 3, condition = "7"},
		{words = "adevo grav vita", name = "wild growth rune", group1 = "support", group2 = "", type = "rune", vocation = "elder druid", cooldown = 2, duration = 1, level = 27, mp = 600, premium = true, soul = 5, mlevel = 8, condition = "7"},
		{words = "adevo ina", name = "chameleon rune", group1 = "support", group2 = "", type = "rune", vocation = "druid", cooldown = 2, duration = 1, level = 27, mp = 600, premium = false, soul = 2, mlevel = 4, condition = "7"},
		{words = "adevo mas flam", name = "fire bomb rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 27, mp = 600, premium = false, soul = 4, mlevel = 5, condition = "1x1"},
		{words = "adevo mas grav flam", name = "fire wall rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 33, mp = 780, premium = false, soul = 4, mlevel = 6, condition = "7"},
		{words = "adevo mas grav pox", name = "poison wall rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 29, mp = 640, premium = false, soul = 3, mlevel = 5, condition = "7"},
		{words = "adevo mas grav vis", name = "energy wall rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 41, mp = 1000, premium = false, soul = 5, mlevel = 9, condition = "7"},
		{words = "adevo mas hur", name = "explosion rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 31, mp = 570, premium = false, soul = 4, mlevel = 6, condition = "explo"},
		{words = "adevo mas pox", name = "poison bomb rune", group1 = "support", group2 = "", type = "rune", vocation = "elder druid", cooldown = 2, duration = 1, level = 25, mp = 520, premium = true, soul = 2, mlevel = 4, condition = "7"},
		{words = "adevo mas vis", name = "energy bomb rune", group1 = "support", group2 = "", type = "rune", vocation = "master sorcerer", cooldown = 2, duration = 1, level = 37, mp = 880, premium = true, soul = 5, mlevel = 10, condition = "1x1"},
		{words = "adevo res flam", name = "soulfire rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 27, mp = 420, premium = true, soul = 3, mlevel = 7, condition = "7"},
		{words = "adito grav", name = "destroy field rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 17, mp = 120, premium = false, soul = 2, mlevel = 3, condition = "7"},
		{words = "adito tera", name = "desintegrate rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 21, mp = 200, premium = true, soul = 3, mlevel = 4, condition = "1"},
		{words = "adori flam", name = "fireball rune", group1 = "support", group2 = "", type = "rune", vocation = "master sorcerer", cooldown = 2, duration = 1, level = 27, mp = 460, premium = true, soul = 3, mlevel = 4, condition = "7"},
		{words = "adori frigo", name = "icicle rune", group1 = "support", group2 = "", type = "rune", vocation = "elder druid", cooldown = 2, duration = 1, level = 28, mp = 460, premium = true, soul = 3, mlevel = 4, condition = "7"},
		{words = "adori gran mort", name = "sudden death rune", group1 = "support", group2 = "", type = "rune", vocation = "sorcerer", cooldown = 2, duration = 1, level = 45, mp = 985, premium = false, soul = 5, mlevel = 15, condition = "7"},
		{words = "adori mas flam", name = "great fireball rune", group1 = "support", group2 = "", type = "rune", vocation = "sorcerer", cooldown = 2, duration = 1, level = 30, mp = 530, premium = false, soul = 3, mlevel = 4, condition = "3x3"},
		{words = "adori mas frigo", name = "avalanche rune", group1 = "support", group2 = "", type = "rune", vocation = "druid", cooldown = 2, duration = 1, level = 30, mp = 530, premium = false, soul = 3, mlevel = 4, condition = "3x3"},
		{words = "adori mas tera", name = "stone shower rune", group1 = "support", group2 = "", type = "rune", vocation = "elder druid", cooldown = 2, duration = 1, level = 28, mp = 430, premium = true, soul = 3, mlevel = 4, condition = "3x3"},
		{words = "adori mas vis", name = "thunderstorm rune", group1 = "support", group2 = "", type = "rune", vocation = "master sorcerer", cooldown = 2, duration = 1, level = 28, mp = 430, premium = true, soul = 3, mlevel = 4, condition = "3x3"},
		{words = "adori min vis", name = "light magic missile rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 15, mp = 120, premium = false, soul = 1, mlevel = 0, condition = "7"},
		{words = "adori san", name = "holy missile rune", group1 = "support", group2 = "", type = "rune", vocation = "royal paladin", cooldown = 2, duration = 1, level = 27, mp = 300, premium = true, soul = 3, mlevel = 4, condition = "7"},
		{words = "adori tera", name = "stalagmite rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 24, mp = 350, premium = false, soul = 2, mlevel = 3, condition = "7"},
		{words = "adori vis", name = "heavy magic missile rune", group1 = "support", group2 = "", type = "rune", vocation = false, cooldown = 2, duration = 1, level = 25, mp = 350, premium = false, soul = 2, mlevel = 3, condition = "7"},
		{words = "adura gran", name = "intense healing rune", group1 = "support", group2 = "", type = "rune", vocation = "druid", cooldown = 2, duration = 1, level = 15, mp = 120, premium = false, soul = 2, mlevel = 1, condition = "7"},
		{words = "adura vita", name = "ultimate healing rune", group1 = "support", group2 = "", type = "rune", vocation = "druid", cooldown = 2, duration = 1, level = 24, mp = 400, premium = false, soul = 3, mlevel = 4, condition = "7"},
		{words = "exana flam", name = "cure burning", group1 = "healing", group2 = "", type = "instant", vocation = "elder druid", cooldown = 6, duration = 1, level = 30, mp = 30, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exana ina", name = "cancel invisibility", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 26, mp = 200, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exana kor", name = "cure bleeding", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 6, duration = 1, level = 45, mp = 30, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exana mort", name = "cure curse", group1 = "healing", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 6, duration = 1, level = 80, mp = 40, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exana pox", name = "cure poison", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 1, duration = 1, level = 10, mp = 30, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exana vis", name = "cure electrification", group1 = "healing", group2 = "", type = "instant", vocation = "elder druid", cooldown = 6, duration = 1, level = 22, mp = 30, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exani hur", name = "levitate", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 12, mp = 50, premium = true, soul = 0, mlevel = 0, condition = "word"},
		{words = "exani tera", name = "magic rope", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 9, mp = 20, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exeta con", name = "enchant spear", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 45, mp = 350, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exeta res", name = "challenge", group1 = "support", group2 = "", type = "instant", vocation = "elite knight", cooldown = 2, duration = 1, level = 20, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "1x1"},
		{words = "exeta vis", name = "enchant staff", group1 = "support", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 2, duration = 1, level = 41, mp = 80, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con", name = "conjure arrow", group1 = "support", group2 = "", type = "instant", vocation = "paladin", cooldown = 2, duration = 1, level = 13, mp = 100, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con flam", name = "conjure explosive arrow", group1 = "support", group2 = "", type = "instant", vocation = "paladin", cooldown = 2, duration = 1, level = 25, mp = 290, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con grav", name = "conjure piercing bolt", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 33, mp = 180, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con hur", name = "conjure sniper arrow", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 24, mp = 160, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con mort", name = "conjure bolt", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 17, mp = 140, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con pox", name = "conjure poisoned arrow", group1 = "support", group2 = "", type = "instant", vocation = "paladin", cooldown = 2, duration = 1, level = 16, mp = 130, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo con vis", name = "conjure power bolt", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 59, mp = 700, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo flam hur", name = "fire wave", group1 = "attack", group2 = "", type = "instant", vocation = "sorcerer", cooldown = 4, duration = 1, level = 18, mp = 25, premium = false, soul = 0, mlevel = 0, condition = "smallwave"},
		{words = "exevo frigo hur", name = "ice wave", group1 = "attack", group2 = "", type = "instant", vocation = "druid", cooldown = 4, duration = 1, level = 18, mp = 25, premium = false, soul = 0, mlevel = 0, condition = "smallwave"},
		{words = "exevo gran frigo hur", name = "strong ice wave", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 8, duration = 1, level = 40, mp = 170, premium = true, soul = 0, mlevel = 0, condition = "smallwave"},
		{words = "exevo gran mas flam", name = "hells core", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 40, duration = 1, level = 60, mp = 1100, premium = true, soul = 0, mlevel = 0, condition = "5x5"},
		{words = "exevo gran mas frigo", name = "eternal winter", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 40, duration = 1, level = 60, mp = 1050, premium = true, soul = 0, mlevel = 0, condition = "5x5"},
		{words = "exevo gran mas tera", name = "wrath of nature", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 40, duration = 1, level = 55, mp = 700, premium = true, soul = 0, mlevel = 0, condition = "6x6"},
		{words = "exevo gran mas vis", name = "rage of the skies", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 40, duration = 1, level = 55, mp = 600, premium = true, soul = 0, mlevel = 0, condition = "6x6"},
		{words = "exevo gran vis lux", name = "great energy beam", group1 = "attack", group2 = "", type = "instant", vocation = "sorcerer", cooldown = 6, duration = 1, level = 29, mp = 110, premium = false, soul = 0, mlevel = 0, condition = "bigbeam"},
		{words = "exevo mas san", name = "divine caldera", group1 = "attack", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 4, duration = 1, level = 50, mp = 160, premium = true, soul = 0, mlevel = 0, condition = "3x3"},
		{words = "exevo pan", name = "food", group1 = "support", group2 = "", type = "instant", vocation = "druid", cooldown = 2, duration = 1, level = 14, mp = 120, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exevo tera hur", name = "terra wave", group1 = "attack", group2 = "", type = "instant", vocation = "druid", cooldown = 4, duration = 1, level = 38, mp = 210, premium = false, soul = 0, mlevel = 0, condition = "bigwave"},
		{words = "exevo vis hur", name = "energy wave", group1 = "attack", group2 = "", type = "instant", vocation = "sorcerer", cooldown = 8, duration = 1, level = 38, mp = 170, premium = false, soul = 0, mlevel = 0, condition = "bigwave"},
		{words = "exevo vis lux", name = "energy beam", group1 = "attack", group2 = "", type = "instant", vocation = "sorcerer", cooldown = 4, duration = 1, level = 23, mp = 40, premium = false, soul = 0, mlevel = 0, condition = "smallbeam"},
		{words = "exiva", name = "find person", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 8, mp = 20, premium = false, soul = 0, mlevel = 0, condition = "word"},
		{words = "exori", name = "berserk", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 4, duration = 1, level = 35, mp = 115, premium = true, soul = 0, mlevel = 0, condition = "1x1"},
		{words = "exori amp vis", name = "lightning", group1 = "attack", group2 = "special", type = "instant", vocation = "master sorcerer", cooldown = 8, duration = 1, level = 55, mp = 60, premium = true, soul = 0, mlevel = 0, condition = "5"},
		{words = "exori con", name = "ethereal spear", group1 = "attack", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 23, mp = 25, premium = true, soul = 0, mlevel = 0, condition = "7"},
		{words = "exori flam", name = "flame strike", group1 = "attack", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 14, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori frigo", name = "ice strike", group1 = "attack", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 15, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori gran", name = "fierce berserk", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 6, duration = 1, level = 90, mp = 340, premium = true, soul = 0, mlevel = 0, condition = "1x1"},
		{words = "exori gran con", name = "strong ethereal spear", group1 = "attack", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 8, duration = 1, level = 90, mp = 55, premium = true, soul = 0, mlevel = 0, condition = "7"},
		{words = "exori gran flam", name = "strong flame strike", group1 = "attack", group2 = "special", type = "instant", vocation = "master sorcerer", cooldown = 8, duration = 1, level = 70, mp = 60, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori gran frigo", name = "strong ice strike", group1 = "attack", group2 = "special", type = "instant", vocation = "elder druid", cooldown = 8, duration = 1, level = 80, mp = 60, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori gran ico", name = "annihilation", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 30, duration = 1, level = 110, mp = 300, premium = true, soul = 0, mlevel = 0, condition = "5"},
		{words = "exori gran tera", name = "strong terra strike", group1 = "attack", group2 = "special", type = "instant", vocation = "elder druid", cooldown = 8, duration = 1, level = 70, mp = 60, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori gran vis", name = "strong energy strike", group1 = "attack", group2 = "special", type = "instant", vocation = "master sorcerer", cooldown = 8, duration = 1, level = 80, mp = 60, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori hur", name = "whirlwind throw", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 6, duration = 1, level = 28, mp = 40, premium = true, soul = 0, mlevel = 0, condition = "5"},
		{words = "exori ico", name = "brutal strike", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 6, duration = 1, level = 16, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "1"},
		{words = "exori mas", name = "groundshaker", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 8, duration = 1, level = 33, mp = 160, premium = true, soul = 0, mlevel = 0, condition = "3x3"},
		{words = "exori max flam", name = "ultimate flame strike", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 30, duration = 1, level = 90, mp = 100, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori max frigo", name = "ultimate ice strike", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 30, duration = 1, level = 100, mp = 100, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori max tera", name = "ultimate terra strike", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 30, duration = 1, level = 90, mp = 100, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori max vis", name = "ultimate energy strike", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 30, duration = 1, level = 100, mp = 100, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori min", name = "front sweep", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 6, duration = 1, level = 70, mp = 200, premium = true, soul = 0, mlevel = 0, condition = "front"},
		{words = "exori moe ico", name = "physical strike", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 2, duration = 1, level = 16, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori mort", name = "death strike", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 2, duration = 1, level = 16, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori san", name = "divine missile", group1 = "attack", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 1, level = 40, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "4"},
		{words = "exori tera", name = "terra strike", group1 = "attack", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 13, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exori vis", name = "energy strike", group1 = "attack", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 12, mp = 20, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "exura", name = "light healing", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 1, duration = 1, level = 9, mp = 20, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exura gran", name = "intense healing", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 1, duration = 1, level = 11, mp = 70, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exura gran ico", name = "intense wound cleansing", group1 = "healing", group2 = "", type = "instant", vocation = "elite knight", cooldown = 600, duration = 1, level = 80, mp = 200, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exura gran mas res", name = "mass healing", group1 = "healing", group2 = "", type = "instant", vocation = "elder druid", cooldown = 2, duration = 1, level = 36, mp = 150, premium = true, soul = 0, mlevel = 0, condition = "3x3"},
		{words = "exura gran san", name = "salvation", group1 = "healing", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 1, duration = 1, level = 60, mp = 210, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "exura ico", name = "wound cleansing", group1 = "healing", group2 = "", type = "instant", vocation = "knight", cooldown = 1, duration = 1, level = 10, mp = 40, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exura san", name = "divine healing", group1 = "healing", group2 = "", type = "instant", vocation = "paladin", cooldown = 1, duration = 1, level = 35, mp = 160, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "exura sio", name = "heal friend", group1 = "healing", group2 = "", type = "instant", vocation = "elder druid", cooldown = 1, duration = 1, level = 18, mp = 140, premium = true, soul = 0, mlevel = 0, condition = "word"},
		{words = "exura vita", name = "ultimate healing", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 1, duration = 1, level = 20, mp = 160, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "utamo mas sio", name = "protect party", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 120, level = 32, mp = 0, premium = true, soul = 0, mlevel = 0, condition = "3x3"},
		{words = "utamo tempo", name = "protector", group1 = "support", group2 = "", type = "instant", vocation = "elite knight", cooldown = 2, duration = 10, level = 55, mp = 200, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utamo tempo san", name = "swift foot", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 10, level = 55, mp = 400, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utamo vita", name = "magic shield", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 200, level = 14, mp = 50, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "utana vid", name = "invisible", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 200, level = 35, mp = 440, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "utani gran hur", name = "strong haste", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 8, duration = 22, level = 20, mp = 100, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utani hur", name = "haste", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 30, level = 14, mp = 60, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utani tempo hur", name = "charge", group1 = "support", group2 = "", type = "instant", vocation = "elite knight", cooldown = 2, duration = 5, level = 25, mp = 100, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utevo gran lux", name = "great light", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 695, level = 13, mp = 60, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "utevo lux", name = "light", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 370, level = 8, mp = 20, premium = false, soul = 0, mlevel = 0, condition = ""},
		{words = "utevo res", name = "summon creature", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 25, mp = 0, premium = false, soul = 0, mlevel = 0, condition = "word"},
		{words = "utevo res ina", name = "creature illusion", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1, level = 23, mp = 100, premium = false, soul = 0, mlevel = 0, condition = "word"},
		{words = "utevo vis lux", name = "ultimate light", group1 = "support", group2 = "", type = "instant", vocation = false, cooldown = 2, duration = 1980, level = 26, mp = 140, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utito mas sio", name = "train party", group1 = "support", group2 = "", type = "instant", vocation = "elite knight", cooldown = 2, duration = 120, level = 32, mp = 0, premium = true, soul = 0, mlevel = 0, condition = "3x3"},
		{words = "utito tempo", name = "blood rage", group1 = "support", group2 = "", type = "instant", vocation = "elite knight", cooldown = 2, duration = 10, level = 60, mp = 290, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utito tempo san", name = "sharpshooter", group1 = "support", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 2, duration = 10, level = 60, mp = 450, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utori flam", name = "ignite", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 30, duration = 1, level = 26, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "utori kor", name = "inflict wound", group1 = "attack", group2 = "", type = "instant", vocation = "elite knight", cooldown = 30, duration = 1, level = 40, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "utori mas sio", name = "enchant party", group1 = "support", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 2, duration = 120, level = 32, mp = 0, premium = true, soul = 0, mlevel = 0, condition = "3x3"},
		{words = "utori mort", name = "curse", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 50, duration = 1, level = 75, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "utori pox", name = "envenom", group1 = "attack", group2 = "", type = "instant", vocation = "elder druid", cooldown = 30, duration = 1, level = 50, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "utori san", name = "holy flash", group1 = "attack", group2 = "", type = "instant", vocation = "royal paladin", cooldown = 40, duration = 1, level = 70, mp = 50, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "utori vis", name = "electrify", group1 = "attack", group2 = "", type = "instant", vocation = "master sorcerer", cooldown = 1, duration = 1, level = 34, mp = 30, premium = true, soul = 0, mlevel = 0, condition = "3"},
		{words = "utura", name = "recovery", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 60, duration = 60, level = 50, mp = 75, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utura gran", name = "intense recovery", group1 = "healing", group2 = "", type = "instant", vocation = false, cooldown = 60, duration = 60, level = 100, mp = 165, premium = true, soul = 0, mlevel = 0, condition = ""},
		{words = "utura mas sio", name = "heal party", group1 = "support", group2 = "", type = "instant", vocation = "elder druid", cooldown = 2, duration = 120, level = 32, mp = 0, premium = true, soul = 0, mlevel = 0, condition = "3x3"}
	}
}

function Spell:getInfo(spell_name, search_type) -- Working
	arguments('Spell:getInfo', {'string', spell_name})

	local spell_found
	if ((search_type or ''):lower() == 'words') then
		spell_found = table.binaryfind(self.data, spell_name:lower(), 'words')
	elseif ((search_type or ''):lower() == 'name') then
		spell_found = table.find(self.data, spell_name:lower(), 'name')
	else
		spell_found = table.binaryfind(self.data, spell_name:lower(), 'words') or table.find(self.data, spell_name:lower(), 'name')
	end

	if (spell_found) then
		return self.data[spell_found]
	end

	return nil
end

Untils = {
}

function Untils:parseLootMessage(message, with_amount) -- Working
	if (type(message) == 'userdata') then message = message.content end
	if (type(with_amount) ~= 'boolean') then with_amount = false end
	if (not string.find(message:lower(), 'loot of')) then return end

	arguments('Untils:getMonsterLoot', {'string', message, 'boolean', with_amount})

	local loot_info, exceptions = {name = '', items = {}}, {['small rubies'] = 'small ruby', ['small topazes'] = 'small topaz', ['giant shimmering pearl'] = 'giant shimmering pearl (blue)'}

	loot_info.name, loot_info.items_temp = message:match('Loot of[ an]* (.+): (.+)')
	if (loot_info.name) then
		for _, item in ipairs(loot_info.items_temp:token(nil, ', ')) do
			setwarning(WARNING_ITEM, false)

			local item_amount = tonumber(item:token(1)) or 1
			local _item_name = item:gsub('%d', ''):gsub('^a ', ''):gsub('^an ', ''):gsub('^[%s]*', ''):lower()
			
			if (exceptions[_item_name] ~= nil) then
				_item_name = exceptions[_item_name]
			end
			
			local item_name = itemname(itemid(_item_name))

			if (#item_name ~= 0) then
				if (with_amount) then
					local item_found = table.find(loot_info.items, item_name, 'name')

					if (item_found) then
						loot_info.items[item_found].amount = loot_info.items[item_found].amount + item_amount
					else
						table.insert(loot_info.items, {name = item_name, amount = item_amount})
					end
				elseif (not table.find(loot_info.items, item_name)) then
					table.insert(loot_info.items, item_name)
				end
			end
		end

		loot_info.items_temp = nil

		return loot_info
	end

	return {name = '', items = {}}
end

function Untils:parseAttackMessage(message) -- Working
	if (type(message) == 'userdata') then message = message.content end
	if (not string.find(message, 'lose')) then return end

	arguments('Untils:parseAttackMessage', {'string', message})

	local damage_info = {damage = 0, dealer = {name = '', type = ''}, target = {name = '', type = ''}}

	damage_info.damage, damage_info.dealer.name = message:match('You lose (%w+) .+ due to an attack by (.+)%.')
	if (damage_info.damage) then
		damage_info.damage = tonumber(damage_info.damage)
		damage_info.dealer.name = damage_info.dealer.name:gsub('^a ', ''):gsub('^an ', '')
		damage_info.dealer.type = (Unit:isPlayer(damage_info.dealer.name) and ('player')) or ('monster')
		damage_info.target = {name = $name, type = 'player'}

		return damage_info
	else
		damage_info.target.name, damage_info.damage = message:match('(.+) loses (%w+) .+ due to your attack%.')
		if (damage_info.damage) then
			damage_info.damage = tonumber(damage_info.damage)
			damage_info.dealer = {name = $name, type = 'player'}
			damage_info.target.name = damage_info.target.name:gsub('^A ', ''):gsub('^An ', '')
			damage_info.target.type = (Unit:isPlayer(damage_info.target.name) and ('player')) or ('monster')

			return damage_info
		else
			damage_info.target.name, damage_info.damage, damage_info.dealer.name = message:match('(.+) loses (%w+) .+ due to an attack by (.+)%.')
			if (damage_info.damage) then
				damage_info.damage = tonumber(damage_info.damage)
				damage_info.dealer.name = damage_info.dealer.name:gsub('^a ', ''):gsub('^an ', '')
				damage_info.dealer.type = (Unit:isPlayer(damage_info.dealer.name) and ('player')) or ('monster')
				damage_info.target.name = damage_info.target.name:gsub('^A ', ''):gsub('^An ', '')
				damage_info.target.type = (Unit:isPlayer(damage_info.target.name) and ('player')) or ('monster')

				return damage_info
			end
		end
	end

	return {damage = 0, dealer = {name = '', type = ''}, target = {name = '', type = ''}}
end

function Untils:parseHealMessage(message) -- Working
	if (type(message) == 'userdata') then message = message.content end
	if (not string.find(message, 'heal')) then return end

	arguments('Untils:parseHealMessage', {'string', message})

	local heal_info = {damage = 0, healer = '', target = ''}

	heal_info.damage = message:match('You healed yourself for (%w+) hitpoint[s]*%.')
	if (heal_info.damage) then
		heal_info.damage, heal_info.healer, heal_info.target = tonumber(heal_info.damage), $name, $name

		return heal_info
	else
		heal_info.healer, heal_info.damage = message:match('(.+) healed himself for (%w+) hitpoint[s]*%.')
		if (heal_info.damage) then
			heal_info.damage, heal_info.target = tonumber(heal_info.damage), heal_info.healer

			return heal_info
		else
			heal_info.target, heal_info.damage = message:match('You heal (.+) for (%w+) hitpoint[s]*%.')
			if (heal_info.damage) then
				heal_info.damage, heal_info.healer = tonumber(heal_info.damage), $name

				return heal_info
			else
				heal_info.healer, heal_info.damage= message:match('You were healed by (.+) for (%w+) hitpoint[s]*%.')
				if (heal_info.damage) then
					heal_info.damage, heal_info.target = tonumber(heal_info.damage), $name

					return heal_info
				else
					heal_info.target, heal_info.healer, heal_info.damage = message:match('(.+) was healed by (.+) for (%w+) hitpoint[s]*%.')
					if (heal_info.damage) then
						heal_info.damage = tonumber(heal_info.damage)

						return heal_info
					end
				end
			end
		end
	end

	return {damage = 0, healer = '', target = ''}
end

function Untils:string2Pixels(text) -- Working
	if (type(text) ~= 'string') then text = tostring(text) end

	local pixels = 0
	local characters = {[" "] = 3, ["!"] = 3, ['"'] = 6, ["#"] = 9, ["$"] = 7, ["%"] = 12, ["&"] = 9, ["'"] = 3, ["("] = 5, [")"] = 5, ["*"] = 6, [","] = 4, ["-"] = 5, ["."] = 3, ["/"] = 6, ["0"] = 7, ["1"] = 7, ["2"] = 7, ["3"] = 7, ["4"] = 7, ["5"] = 7, ["6"] = 7, ["7"] = 7, ["8"] = 7, ["9"] = 7, [":"] = 3, [";"] = 3, ["<"] = 9, ["="] = 9, [">"] = 9, ["?"] = 6, ["@"] = 10, ["A"] = 9, ["B"] = 7, ["C"] = 7, ["D"] = 8, ["E"] = 6, ["F"] = 6, ["G"] = 8, ["H"] = 8, ["I"] = 5, ["J"] = 6, ["K"] = 7, ["L"] = 6, ["M"] = 10, ["N"] = 7, ["O"] = 8, ["P"] = 7, ["Q"] = 8, ["R"] = 8, ["S"] = 7, ["T"] = 7, ["U"] = 8, ["V"] = 7, ["X"] = 7, ["W"] = 11, ["Y"] = 7, ["Z"] = 7, ["["] = 5, ["\\"] = 6, ["]"] = 5, ["^"] = 9, ["_"] = 7, ["`"] = 6, ["a"] = 7, ["b"] = 7, ["c"] = 6, ["d"] = 7, ["e"] = 7, ["f"] = 4, ["g"] = 7, ["h"] = 7, ["i"] = 3, ["j"] = 4, ["k"] = 7, ["l"] = 3, ["m"] = 11, ["n"] = 7, ["o"] = 7, ["p"] = 7, ["q"] = 7, ["r"] = 5, ["s"] = 6, ["t"] = 5, ["u"] = 7, ["v"] = 7, ["x"] = 7, ["w"] = 9, ["y"] = 7, ["z"] = 6, ["{"] = 7, ["|"] = 7, ["}"] = 7, ["~"] = 9}

	if (#text ~= 0) then
		for i = 1, #text do
			pixels = pixels + (characters[string.sub(text, i, i)] or 0)
		end
	end

	return pixels
end

local STATS_DATA_RUN_LAST = $timems
local STATS_DATA_RUN_DELAY = 100

Stats = {
	monsters_seen = {},
	players_seen = {},
	monsters_killed = {},
	items_looted = {},
	supplies_used = {},
	damage_dealt = 0,
	damage_received = 0,
	damage_stats = {},
	heal_stats = {}
}

function Stats:getGamePlayData() -- Working
	if (STATS_DATA_RUN_LAST + STATS_DATA_RUN_DELAY >= $timems) then return end
	
	if (#self.supplies_used == 0) then
		for _, section in ipairs({'POTIONS_AND_RUNES', 'AMMUNITION', 'DISTANCE_WEAPONS'}) do
			for _, section_item in ipairs(exec('return ' .. section)) do
				table.binaryinsert(self.supplies_used, {name = section_item, id = itemid(section_item), type = section, current_amount = (section == 'POTIONS_AND_RUNES' and servercount(section_item)) or (section == 'AMMUNITION' and itemcount(section_item, 'belt')) or (section == 'DISTANCE_WEAPONS' and itemcount(section_item, 'rhand')) or 0, amount = 0, price = math.positive(itemcost(section_item))}, 'name')
			end
		end
	end

	for _, supply in ipairs(self.supplies_used) do
		if (supply.type == 'POTIONS_AND_RUNES') then
			if (servercount(supply.name) ~= supply.current_amount) then
				supply.current_amount, supply.amount = servercount(supply.name), supply.amount + 1
			end
		elseif (supply.type == 'AMMUNITION') then
			if ($belt.id == supply.id) then
				local supply_count = $belt.count

				if (supply_count < supply.current_amount) then
					supply.current_amount, supply.amount = supply_count, supply.amount + 1
				elseif (supply.current_amount ~= supply_count) then
					supply.current_amount = supply_count
				end
			end
		elseif (supply.type == 'DISTANCE_WEAPONS') then
			if ($rhand.id == supply.id) then
				local supply_count = $rhand.count

				if (supply_count < supply.current_amount) then
					supply.current_amount, supply.amount = supply_count, supply.amount + 1
				elseif (supply.current_amount ~= supply_count) then
					supply.current_amount = supply_count
				end
			end
		end
	end

	foreach newmessage m do
		if (m.type == MSG_INFO and m.content:match('^Loot of')) then
			local loot_info = Untils:parseLootMessage(m.content, true)

			if (#loot_info.name ~= 0) then
				local monster_found = table.binaryfind(self.monsters_killed, loot_info.name:lower(), 'name')

				if (monster_found) then
					self.monsters_killed[monster_found].amount = self.monsters_killed[monster_found].amount + 1
				else
					table.binaryinsert(self.monsters_killed, {name = loot_info.name:lower(), amount = 1}, 'name')
				end

				if (#loot_info.items ~= 0) then
					for _, item in ipairs(loot_info.items) do
						local item_found = table.binaryfind(self.items_looted, item.name, 'name')

						if (item_found) then
							self.items_looted[item_found].amount = self.items_looted[item_found].amount + item.amount
						else
							table.binaryinsert(self.items_looted, {name = item.name:lower(), amount = item.amount, price = math.positive(itemvalue(item.name))}, 'name')
						end
					end
				end
			end
		elseif (m.type == MSG_STATUSLOG) then
			if (string.find(m.content, 'lose')) then
				local damage_info = Untils:parseAttackMessage(m.content)

				if (#damage_info.dealer.name ~= 0 and #damage_info.target.name ~= 0) then
					if (damage_info.dealer.name:lower() == $name:lower()) then
						self.damage_dealt = damage_info.damage
					end

					if (damage_info.target.name:lower() == $name:lower()) then
						self.damage_received = damage_info.damage
					end

					local dealer_found = table.binaryfind(self.damage_stats, damage_info.dealer.name:lower(), 'name')

					if (dealer_found) then
						self.damage_stats[dealer_found].dealt = self.damage_stats[dealer_found].dealt + damage_info.damage
					else
						table.binaryinsert(self.damage_stats, {name = damage_info.dealer.name:lower(), dealt = damage_info.damage, received = 0}, 'name')
					end

					local target_found = table.binaryfind(self.damage_stats, damage_info.target.name:lower(), 'name')

					if (target_found) then
						self.damage_stats[target_found].received = self.damage_stats[target_found].received + damage_info.damage
					else
						table.binaryinsert(self.damage_stats, {name = damage_info.target.name:lower(), dealt = 0, received = damage_info.damage}, 'name')
					end
				end
			elseif (string.find(m.content, 'heal')) then
				local heal_info = Untils:parseHealMessage(m.content)

				if (#heal_info.healer ~= 0 and #heal_info.target ~= 0) then
					local healer_found = table.binaryfind(self.heal_stats, heal_info.healer:lower(), 'name')

					if (healer_found) then
						self.heal_stats[healer_found].given = self.heal_stats[healer_found].given + heal_info.damage
					else
						table.binaryinsert(self.heal_stats, {name = heal_info.healer:lower(), given = heal_info.damage, received = 0}, 'name')
					end

					local target_found = table.binaryfind(self.heal_stats, heal_info.target:lower(), 'name')

					if (target_found) then
						self.heal_stats[target_found].received = self.heal_stats[target_found].received + heal_info.damage
					else
						table.binaryinsert(self.heal_stats, {name = heal_info.target:lower(), given = 0, received = heal_info.damage}, 'name')
					end
				end
			end
		end
	end

	foreach creature c 's' do
		if (Unit:isPlayer(c) and not table.binaryfind(self.players_seen, c.name) and c ~= $self) then
			table.binaryinsert(self.players_seen, c.name)
		elseif (not Unit:isNPC(c) and not table.binaryfind(self.monsters_seen, c.id)) then
			table.binaryinsert(self.monsters_seen, c.id)
		end
	end
	
	STATS_DATA_RUN_LAST = $timems
end

function Stats:clearStatsData(section_name) -- Working
	if (table.find({SC_ALL_SECTIONS, SC_MONSTERS_SEEN, SC_PLAYERS_SEEN, SC_MONSTERS_KILLED, SC_ITEMS_LOOTED, SC_SUPPLIES_USED, SC_DAMAGE_DEALT, SC_DAMAGE_RECEIVED, SC_DAMAGE_STATS, SC_HEAL_STATS}, section_name)) then
		for _, section in ipairs({'monsters_seen', 'players_seen', 'monsters_killed', 'items_looted', 'supplies_used', 'damage_dealt', 'damage_received', 'damage_stats', 'heal_stats'}) do
			if (section_name == SC_ALL_SECTIONS or section_name == exec('return SC_' .. section:upper())) then
				if (section == 'damage_dealt' or section == 'damage_received') then
					exec('Stats.' .. section .. ' = 0')
				else
					exec('Stats.' .. section .. ' = {}')
				end
			end
		end

		return true
	end

	return false
end

function Stats:getMonstersSeen() -- Working
	return #self.monsters_seen
end

function Stats:getPlayersSeen(return_names) -- Working
	if (type(return_names) == 'boolean' and return_names) then
		return self.players_seen
	end

	return #self.players_seen
end

function Stats:getMonstersKilled(monster_name) -- Working
	if (type(monster_name) == 'string') then
		local monster_found = table.binaryfind(self.monsters_killed, monster_name:lower(), 'name')

		if (monster_found) then
			return self.monsters_killed[monster_found].amount
		end

		return 0
	end

	return self.monsters_killed
end

function Stats:addItemsLooted(item_name, item_amount, item_price) -- Working
	arguments('Stats:addItemsLooted', {'string', item_name, 'number', item_amount})

	if (#itemname(itemid(item_name)) == 0) then return end

	local item_found = table.binaryfind(self.items_looted, item_name:lower(), 'name')

	if (item_found) then
		self.items_looted[item_found].amount = self.items_looted[item_found].amount + math.positive(item_amount)
		if (type(item_price) == 'number') then self.items_looted[item_found].price = math.positive(item_price) end
	else
		if (type(item_price) ~= 'number') then item_price = itemvalue(item_name) end
		table.binaryinsert(self.items_looted, {name = item_name:lower(), amount = math.positive(item_amount), price = math.positive(item_price)}, 'name')
	end

	return true
end

function Stats:getItemsLooted(item_name) -- Working
	if (type(item_name) == 'string') then
		local item_found = table.binaryfind(self.items_looted, item_name:lower(), 'name')

		if (item_found) then
			return self.items_looted[item_found].amount
		end

		return 0
	end

	return self.items_looted
end

function Stats:addSuppliesUsed(supply_name, supply_amount, supply_price) -- Working
	arguments('Stats:addSuppliesUsed', {'string', supply_name, 'number', supply_amount})

	if (#itemname(itemid(supply_name)) == 0) then return end

	local supply_found = table.binaryfind(self.supplies_used, supply_name:lower(), 'name')

	if (supply_found) then
		self.supplies_used[supply_found].amount = self.supplies_used[supply_found].amount + math.positive(supply_amount)
		if (type(supply_price) == 'number') then self.supplies_used[supply_found].price = math.positive(supply_price) end
	else
		if (type(supply_price) ~= 'number') then supply_price = itemcost(supply_name) end
		table.binaryinsert(self.supplies_used, {name = supply_name:lower(), id = itemid(supply_name), type = 'OTHER', current_amount = 0, amount = math.positive(supply_amount), price = math.positive(supply_price)}, 'name')
	end

	return true
end

function Stats:getSuppliesUsed(supply_name) -- Working
	if (type(supply_name) == 'string') then
		local supply_found = table.binaryfind(self.supplies_used, supply_name:lower(), 'name')

		if (supply_found) then
			return self.supplies_used[supply_found].amount
		end

		return 0
	end

	return self.supplies_used
end

function Stats:lastDamageDealt() -- Working
	return self.damage_dealt
end

function Stats:lastDamageReceived() -- Working
	return self.damage_received
end

function Stats:getDamageDealt(creature_name) -- Working
	arguments('Stats:getDamageDealt', {'string', creature_name})

	local creature_found = table.binaryfind(self.damage_stats, creature_name:lower(), 'name')

	if (creature_found) then
		return self.damage_stats[creature_found].dealt
	end

	return 0
end

function Stats:getDamageReceived(creature_name) -- Working
	arguments('Stats:getDamageReceived', {'string', creature_name})

	local creature_found = table.binaryfind(self.damage_stats, creature_name:lower(), 'name')

	if (creature_found) then
		return self.damage_stats[creature_found].received
	end

	return 0
end

function Stats:getHealGiven(creature_name) -- Working
	arguments('Stats:getHealGiven', {'string', creature_name})

	local creature_found = table.binaryfind(self.heal_stats, creature_name:lower(), 'name')

	if (creature_found) then
		return self.heal_stats[creature_found].given
	end

	return 0
end

function Stats:getHealReceived(creature_name) -- Working
	arguments('Stats:getHealReceived', {'string', creature_name})

	local creature_found = table.binaryfind(self.heal_stats, creature_name:lower(), 'name')

	if (creature_found) then
		return self.heal_stats[creature_found].received
	end

	return 0
end

local skin_temp = _G['skin']
_G['skin'] = function(...) -- Working
	local skin_items, skin_items_before, skin_items_after = {'minotaur leather', 'lizard leather', 'green dragon leather', 'red dragon leather', 'hardened bone', 'perfect behemoth fang'}, {['minotaur leather'] = 0, ['lizard leather'] = 0, ['green dragon leather'] = 0, ['red dragon leather'] = 0, ['hardened bone'] = 0, ['perfect behemoth fang'] = 0}, {['minotaur leather'] = 0, ['lizard leather'] = 0, ['green dragon leather'] = 0, ['red dragon leather'] = 0, ['hardened bone'] = 0, ['perfect behemoth fang'] = 0}
	
	for item_name, _ in pairs(skin_items_before) do
		skin_items_before[item_name] = itemcount(item_name, 'backpack')
	end

	wait(200) skin_temp(...) wait(200)
	
	for item_name, _ in pairs(skin_items_after) do
		skin_items_after[item_name] = itemcount(item_name, 'backpack')
	end

	for _, item_name in ipairs(skin_items) do
		if (skin_items_before[item_name] ~= skin_items_after[item_name]) then
			Stats:addItemsLooted(item_name, 1)
		end
	end
end

local stake_temp = _G['stake']
_G['stake'] = function(...) -- Working
	local stake_items, stake_items_before, stake_items_after = {'vampire dust', 'demon dust'}, {['vampire dust'] = 0, ['demon dust'] = 0}, {['vampire dust'] = 0, ['demon dust'] = 0}
	
	for item_name, _ in pairs(stake_items_before) do
		stake_items_before[item_name] = itemcount(item_name, 'backpack')
	end

	wait(200) stake_temp(...) wait(200)
	
	for item_name, _ in pairs(stake_items_after) do
		stake_items_after[item_name] = itemcount(item_name, 'backpack')
	end

	for _, item_name in ipairs(stake_items) do
		if (stake_items_before[item_name] ~= stake_items_after[item_name]) then
			Stats:addItemsLooted(item_name, 1)
		end
	end
end

local fish_temp = _G['fish']
_G['fish'] = function(...) -- Working
	local fish_items, fish_items_before, fish_items_after = {'giant shimmering pearl (gold)', 'giant shimmering pearl (blue)', 'white pearl', 'small sapphire', "leviathan's amulet"}, {['giant shimmering pearl (gold)'] = 0, ['giant shimmering pearl (blue)'] = 0, ['white pearl'] = 0, ['small sapphire'] = 0, ["leviathan's amulet"] = 0}, {['giant shimmering pearl (gold)'] = 0, ['giant shimmering pearl (blue)'] = 0, ['white pearl'] = 0, ['small sapphire'] = 0, ["leviathan's amulet"] = 0}
	
	for item_name, _ in pairs(fish_items_before) do
		fish_items_before[item_name] = itemcount(item_name, 'backpack')
	end
	
	wait(200) fish_temp(...) wait(200)
	
	for item_name, _ in pairs(fish_items_after) do
		fish_items_after[item_name] = itemcount(item_name, 'backpack')
	end

	for _, item_name in ipairs(fish_items) do
		if (fish_items_before[item_name] ~= fish_items_after[item_name]) then
			Stats:addItemsLooted(item_name, 1)
		end
	end
end

function unrust(ignore_common, drop_items) -- Working
	local rusty_items, unrusted_items, unrusted_items_before, unrusted_items_after = (not ignore_common and {8894, 8895, 8896, 8897, 8898, 8899}) or {8895, 8896, 8898, 8899}, {'brass armor', 'chain armor', 'crown armor', 'golden armor', 'knight armor', 'paladin armor', 'plate armor', 'scale armor', 'brass legs', 'chain legs', 'crown legs', 'golden legs', 'knight legs', 'plate legs', 'studded legs'}, {['brass armor'] = 0, ['chain armor'] = 0, ['crown armor'] = 0, ['golden armor'] = 0, ['knight armor'] = 0, ['paladin armor'] = 0, ['plate armor'] = 0, ['scale armor'] = 0, ['brass legs'] = 0, ['chain legs'] = 0, ['crown legs'] = 0, ['golden legs'] = 0, ['knight legs'] = 0, ['plate legs'] = 0, ['studded legs'] = 0}, {['brass armor'] = 0, ['chain armor'] = 0, ['crown armor'] = 0, ['golden armor'] = 0, ['knight armor'] = 0, ['paladin armor'] = 0, ['plate armor'] = 0, ['scale armor'] = 0, ['brass legs'] = 0, ['chain legs'] = 0, ['crown legs'] = 0, ['golden legs'] = 0, ['knight legs'] = 0, ['plate legs'] = 0, ['studded legs'] = 0}
	
	for item_name, _ in pairs(unrusted_items_before) do
		unrusted_items_before[item_name] = itemcount(item_name, 'backpack')
	end
	
	wait(200)

	for _, rusty_item in ipairs(rusty_items) do
		if (itemcount(rusty_item, 'backpack') ~= 0 and itemcount(9016, 'backpack') ~= 0) then
			useitemon(9016, rusty_item, 'backpack')
			Stats:addSuppliesUsed('rust remover', 1, 50)
			
			break
		end
	end
	
	wait(200)
	
	for item_name, _ in pairs(unrusted_items_after) do
		unrusted_items_after[item_name] = itemcount(item_name, 'backpack')
	end

	if (drop_items) then
		for _, item_name in ipairs({'brass armor', 'chain armor', 'plate armor', 'scale armor', 'brass legs', 'chain legs', 'plate legs', 'studded legs'}) do
			if (itemcount(item_name, 'backpack') ~= 0) then
				moveitems(item_name, 'ground', 'backpack') waitping()
			end
		end
	end

	for _, item_name in ipairs(unrusted_items) do
		if (unrusted_items_before[item_name] ~= unrusted_items_after[item_name]) then
			Stats:addItemsLooted(item_name, 1)
		end
	end
end

Targeting = {
	monster_counts = {['Any'] = '0', ['1'] = '1', ['2+'] = '2', ['2'] = '3', ['3+'] = '4', ['3'] = '5', ['4+'] = '6', ['4'] = '7', ['5+'] = '8', ['5'] = '9', ['6+'] = '10', ['6'] = '11', ['7+'] = '12', ['7'] = '13', ['8+'] = '14', ['8'] = '15', ['9+'] = '16', ['9'] = '17'},
	monster_attacks = {['no avoidance'] = 'No Avoidance', ['avoid wave'] = 'Avoid Wave', ['avoid beam'] = 'Avoid Beam'},
	desired_stances = {['no movement'] = 'No Movement', ['strike'] = 'Strike', ['parry'] = 'Parry', ['approach'] = 'Approach', ['circle'] = 'Circle', ['reach'] = 'Reach', ['reach & strike'] = 'Reach & Strike', ['reach & parry'] = 'Reach & Parry', ['reach & circle'] = 'Reach & Circle', ['lure & stand'] = 'Lure & Stand', ['lure & circle'] = 'Lure & Circle', ['keep away'] = 'Keep Away', ['wait & keep away'] = 'Wait & Keep Away', ['away in line'] = 'Away in Line', ['wait & away in line'] = 'Wait & Away in Line', ['lure & keep away'] = 'Lure & Keep Away', ['wait & lure & keep away'] = 'Wait & Lure & Keep Away', ['lose target'] = 'Lose Target'},
	custom_distances = {['default'] = 'Default', ['2'] = '2', ['3'] = '3', ['4'] = '4', ['5'] = '5', ['6'] = '6', ['7'] = '7', ['8'] = '8', ['9'] = '9'},
	desired_attacks = {['no action'] = 'No Action', ['attack'] = 'Attack', ['follow'] = 'Follow'},
	attack_modes = {['no change'] = 'No Change', ['stand/offensive'] = 'Stand/Offensive', ['stand/balanced'] = 'Stand/Balanced', ['stand/defensive'] = 'Stand/Defensive', ['chase/offensive'] = 'Chase/Offensive', ['chase/balanced'] = 'Chase/Balanced', ['chase/defensive'] = 'Chase/Defensive'},
	event_types = {['normal event'] = 'Normal Event', ['urgent event'] = 'Urgent Event'}
}

Targeting.settings = {
	['Monsters'] = {['Name'] = function(value) return value end, ['Categories'] = function(value) return value end, ['Count'] = function(value) return (Targeting.monster_counts[tostring(value)] and value) or ('Any') end, ['Setting1'] = {['HpRange'] = function(value) return value or ('0 to 100') end, ['Danger'] = function(value) return math.max(tonumber(value), 0) end, ['MonsterAttacks'] = function(value) return Targeting.monster_attacks[tostring(value):lower()] or ('No Avoidance') end, ['DesiredStance'] = function(value) return Targeting.desired_stances[tostring(value):lower()] or ('No Movement') end, ['CustomDistance'] = function(value) return Targeting.custom_distances[tostring(value):lower()] or ('Default') end, ['DesiredAttack'] = function(value) return Targeting.desired_attacks[tostring(value):lower()] or ('No Action') end, ['FirstSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SecondSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['ThirdSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['FourthSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SpellRate'] = function(value) return value or ('2000 to 3000') end, ['SyncSpell'] = function(value) return toyesno(value) end, ['AttackMode'] = function(value) return Targeting.attack_modes[tostring(value):lower()] or ('No Change') end}, ['Setting2'] = {['HpRange'] = function(value) return value or ('0 to 100') end, ['Danger'] = function(value) return math.max(tonumber(value), 0) end, ['MonsterAttacks'] = function(value) return Targeting.monster_attacks[tostring(value):lower()] or ('No Avoidance') end, ['DesiredStance'] = function(value) return Targeting.desired_stances[tostring(value):lower()] or ('No Movement') end, ['CustomDistance'] = function(value) return Targeting.custom_distances[tostring(value):lower()] or ('Default') end, ['DesiredAttack'] = function(value) return Targeting.desired_attacks[tostring(value):lower()] or ('No Action') end, ['FirstSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SecondSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['ThirdSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['FourthSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SpellRate'] = function(value) return value or ('2000 to 3000') end, ['SyncSpell'] = function(value) return toyesno(value) end, ['AttackMode'] = function(value) return Targeting.attack_modes[tostring(value):lower()] or ('No Change') end}, ['Setting3'] = {['HpRange'] = function(value) return value or ('0 to 100') end, ['Danger'] = function(value) return math.max(tonumber(value), 0) end, ['MonsterAttacks'] = function(value) return Targeting.monster_attacks[tostring(value):lower()] or ('No Avoidance') end, ['DesiredStance'] = function(value) return Targeting.desired_stances[tostring(value):lower()] or ('No Movement') end, ['CustomDistance'] = function(value) return Targeting.custom_distances[tostring(value):lower()] or ('Default') end, ['DesiredAttack'] = function(value) return Targeting.desired_attacks[tostring(value):lower()] or ('No Action') end, ['FirstSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SecondSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['ThirdSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['FourthSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SpellRate'] = function(value) return value or ('2000 to 3000') end, ['SyncSpell'] = function(value) return toyesno(value) end, ['AttackMode'] = function(value) return Targeting.attack_modes[tostring(value):lower()] or ('No Change') end}, ['Setting4'] = {['HpRange'] = function(value) return value or ('0 to 100') end, ['Danger'] = function(value) return math.max(tonumber(value), 0) end, ['MonsterAttacks'] = function(value) return Targeting.monster_attacks[tostring(value):lower()] or ('No Avoidance') end, ['DesiredStance'] = function(value) return Targeting.desired_stances[tostring(value):lower()] or ('No Movement') end, ['CustomDistance'] = function(value) return Targeting.custom_distances[tostring(value):lower()] or ('Default') end, ['DesiredAttack'] = function(value) return Targeting.desired_attacks[tostring(value):lower()] or ('No Action') end, ['FirstSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SecondSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['ThirdSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['FourthSpell'] = function(value) return string.capitalizeall((Spell:getInfo(tostring(value)) ~= nil and Spell:getInfo(tostring(value)).name) or ('No Action')) end, ['SpellRate'] = function(value) return value or ('2000 to 3000') end, ['SyncSpell'] = function(value) return toyesno(value) end, ['AttackMode'] = function(value) return Targeting.attack_modes[tostring(value):lower()] or ('No Change') end}, ['LootMonster'] = function(value) return toyesno(value) end, ['MustAttackMe'] = function(value) return toyesno(value) end, ['OnlyIfTrapped'] = function(value) return toyesno(value) end, ['PlayAlarm'] = function(value) return toyesno(value) end},
	['StanceOptions'] = {['DiagonalMovement'] = function(value) return toyesno(value) or ('no') end, ['RangeDistance'] = function(value) return ((tonumber(value) >= 2 and tonumber(value) <= 9) and value) or ('2') end, ['LureIntensity'] = function(value) return ((tonumber(value) >= 0 and tonumber(value) <= 100) and value) or ('30') end},
	['TargetSelection'] = {['ListOrder'] = function(value) return (tonumber(value) > 0 and value) or ('0') end, ['Health'] = function(value) return (tonumber(value) > 0 and value) or ('30') end, ['Proximity'] = function(value) return (tonumber(value) > 0 and value) or ('30') end, ['Danger'] = function(value) return (tonumber(value) > 0 and value) or ('10') end, ['Random'] = function(value) return (tonumber(value) > 0 and value) or ('0') end, ['Stick'] = function(value) return (tonumber(value) > 0 and value) or ('2') end, ['MustBeReachable'] = function(value) return toyesno(value) or ('yes') end, ['MustBeShootable'] = function(value) return toyesno(value) or ('no') end},
	['TargetingPriority'] = {['Priority'] = function(value) return (tonumber(value) > 0 and value) or ('60') end, ['OverridePriority'] = function(value) return (tonumber(value) > 0 and value) or ('0') end, ['ExpireTime'] = function(value) return (tonumber(value) > 0 and value) or ('2000') end, ['LifeTime'] = function(value) return (tonumber(value) > 0 and value) or ('5000') end, ['EventType'] = function(value) return Targeting.event_types[tostring(value):lower()] or ('Normal Event') end},
	['TargetingEnabled'] = function(value) return toyesno(value) end
}

function Targeting:monsters(monster_name, monster_count)
	local monster = {
		name = monster_name,
		count = monster_count
	}

	function monster:set(setting_path, value, update_gui)
		arguments('Targeting:monsters():set', {'string', setting_path})
		
		if (type(update_gui) ~= 'boolean') then update_gui = true end
		local setting_path = Targeting:getPath(self.name .. '_' .. Targeting.monster_counts[self.count] .. '/' .. setting_path)
		
		if (setting_path) then
			local setting_path_parts = setting_path:token(nil, '/')
			
			if (setting_path_parts[2] == 'Monsters') then
				if (not string.find(setting_path_parts[4], 'Setting')) then
					setsetting(setting_path, tostring(Targeting.settings[setting_path_parts[2]][setting_path_parts[4]](value)), update_gui)
					if (setting_path_parts[4] == 'Name') then self.name = value elseif (setting_path_parts[4] == 'Count') then self.count = value end
				else
					setsetting(setting_path, tostring(Targeting.settings[setting_path_parts[2]][setting_path_parts[4]][setting_path_parts[5]](value)), update_gui)
				end
			end
		end

		return self
	end

	function monster:get(setting_path)
		arguments('Targeting:monsters():get', {'string', setting_path})

		return getsetting(Targeting:getPath(self.name .. '_' .. Targeting.monster_counts[self.count] .. '/' .. setting_path))
	end

	return monster
end

function Targeting:set(setting_path, value, update_gui) -- Working
	arguments('Targeting:set', {'string', setting_path})

	if (type(update_gui) ~= 'boolean') then update_gui = true end
	local setting_path = Targeting:getPath(setting_path)
	
	if (setting_path) then
		local setting_path_parts = setting_path:token(nil, '/')
		
		if (setting_path_parts[2] == 'TargetingEnabled') then
			setsetting(setting_path, tostring(Targeting.settings[setting_path_parts[2]](value)), update_gui)
		elseif (setting_path_parts[2] ~= 'Monsters') then
			setsetting(setting_path, tostring(Targeting.settings[setting_path_parts[2]][setting_path_parts[3]](value)), update_gui)
		else
			if (not string.find(setting_path_parts[4], 'Setting')) then
				setsetting(setting_path, tostring(Targeting.settings[setting_path_parts[2]][setting_path_parts[4]](value)), update_gui)
			else
				setsetting(setting_path, tostring(Targeting.settings[setting_path_parts[2]][setting_path_parts[4]][setting_path_parts[5]](value)), update_gui)
			end
		end
	end

	return self
end

function Targeting:getPath(setting_path) -- Working
	arguments('Targeting:getPatch', {'string', setting_path})
	
	local setting_path = setting_path:gsub('^Targeting/', '')
	local setting_path_extended = 'Targeting/' .. setting_path
	
	if (getsetting(setting_path_extended) ~= nil) then
		return setting_path_extended
	else
		for _, section in ipairs({'Monsters', 'StanceOptions', 'TargetSelection', 'TargetingPriority', 'TargetingEnabled'}) do
			setting_path_extended = 'Targeting/' .. section .. '/' .. setting_path
			
			if (getsetting(setting_path_extended) ~= nil) then
				return setting_path_extended
			end
		end
	end

	return nil
end

function Targeting:get(setting_path) -- Working
	arguments('Targeting:get', {'string', setting_path})

	return getsetting(Targeting:getPath(setting_path))
end

function Targeting:setState(value, stop_attack, update_gui) -- Working
	if (type(stop_attack) ~= 'boolean') then stop_attack = false end
	if (type(update_gui) ~= 'boolean') then update_gui = true end

	setsetting('Targeting/TargetingEnabled', toyesno(value), update_gui)
	if (toyesno(value) and stop_attack) then stopattack() end

	return self
end

function Targeting:getState() -- Working
	return getsetting('Targeting/TargetingEnabled')
end