-- WedNesday & Zen Library v1.1
WEDZEN_LIB = 1.1
print('WedNesDay & Zen\'s Library v'..WEDZEN_LIB) -- Thanks to Raphael <3

function depositeronto(dest, ...) -- Ok
	local items = {...}
	local itemsLocker = {}
	local itemsFromBP = {}

	local walk = getsetting('Cavebot/Pathfinding/WalkThroughPlayers')
	if walk == 'yes' then
		setsetting('Cavebot/Pathfinding/WalkThroughPlayers', 'no')
	end


	for i = 1, #items do
		if itemproperty(items[i], ITEM_STACKABLE) then
                	table.insert(itemsLocker, items[i])
		elseif not itemproperty(items[i], ITEM_STACKABLE) then
			table.insert(itemsFromBP, items[i])
		end
	end

	clearlastonto()
	reachgrounditem('depot')
	wait($ping * 1, $ping * 3)
	openitem('depot')
	wait($ping * 1, $ping * 3)

	for i = 1, #itemsLocker do
		while itemcount(itemsLocker[i], 'Backpack') > 0 and windowcount('Locker') >= 1 do
			moveitems(itemsLocker[i], 'Locker')
			waitping()
		end
	end

	wait($ping * 1, $ping * 3)
	if itemcount(dest, 'Locker') >= 1 then
		openitem(dest, 'Locker')
		wait($ping * 1, $ping * 3)
		for i = 1, #itemsFromBP do
			while itemcount(itemsFromBP[i], 'Backpack') > 0 do
				moveitemsonto(itemsFromBP[i], dest, $lastonto)
				wait($ping * 1, $ping * 3)
			end
		end
	end

	setsetting('Cavebot/Pathfinding/WalkThroughPlayers', walk)
end

function tradetalk(text) -- Ok
	say('Advertising', '')
	waitping()
	cast(text)
	wait(120000,122000)
end

function yell(text) -- Working
	cast('#y ' .. text)
	wait(30000,32000)
end


function advertising(text) -- Ok

if not w then
	w = 4
end
	cast('#y ' .. text)
	waitping()
	w = w + 1
	if w >= 5 then
		if ischannel('Advertising') then
			say('Advertising', '')
			waitping()
			cast(text)
			wait($ping * 1, $ping * 3)
			w = 1
		else
			printerror('Advertising channel is not opened.')
		end

	end
	wait(30000,32000)
end

function usepick(x,y,z,holes) -- Ok
	local v = 1

	if pickid == nil then
		if itemcount('Pick') >= 1 then
			pickid = itemid('Pick')
		elseif itemcount('Whacking Driller of Fate') >= 1 then
			pickid = itemid('Whacking Driller of Fate')
		elseif itemcount('Sneaky Stabber of Eliteness') >= 1 then
			pickid = itemid('Sneaky Stabber of Eliteness')
		elseif itemcount('Squeezing Gear of Girlpower') >= 1 then
			pickid = itemid('Squeezing Gear of Girlpower')
		else
			pickid = 3456
		end

	end

	x,y,z = x or $wptx, y or $wpty, z or $wptz
	holes = holes or {{355, 394}}

		while v <= #holes and not isitemontile(holes[v][1],x,y,z) do
			v = v+1
		end
		if v <= #holes then
			local id = topitem(x,y,z).id
			while id ~= holes[v][2] do
				if id == holes[v][1] then
					if iscreatureontile(x,y,z) then
						local dir, dirx, diry = wheretomoveitem(x,y,z,99)
						moveitems(99,ground(x+dirx,y+diry,z),ground(x,y,z),100)
						waitping()
					elseif clientitemhotkey(pickid,'crosshair') == 'not found' and itemcount(pickid) == 0 then
						printerror('Pick not found.')
						return false
					end
					useitemon(pickid,0,ground(x,y,z))
					waitping()
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100)
					waitping()
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
end

function goprev() -- Ok
	gotolabel(math.max($wptid-1, 0))
end

function temple(town) -- Ok
	town = town:lower()
	local cities = {
		["ab'dendriel"] = {32732, 31634, 7},
		carlin = {32360, 31782, 7},
		kazordoon = {32649, 31925, 11},
		thais = {32369, 32241, 7},
		venore = {32957, 32076, 7},
		ankrahmun = {33194, 32853, 8},
		darashia = {33213, 32454, 1},
		edron = {33217, 31814, 8},
		farmine = {33004, 31490, 11},
		["liberty bay"] = {32317, 32826, 7},
		svargrond = {32213, 31133, 7},
		["port hope"] = {32595, 32744, 6},
		yalahar = {32787, 31276, 7}
			}
	return ground() == ground(table.unpack(cities[town]))
end

function mpcount() -- Ok
	return itemcount("mana potion") + itemcount("strong mana potion") + itemcount("great mana potion")
end

function hpcount() -- Ok
	return itemcount("small health potion") + itemcount("health potion") + itemcount("strong health potion") + itemcount("great health potion") + itemcount("ultimate health potion")
end

function math.pi() -- Ok
	return 3.1415
end
