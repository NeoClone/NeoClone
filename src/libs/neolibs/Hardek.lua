-- Hardek's neobot library 0.9.7
print('Hardek Library Version: 0.9.7')

function waitping(base)
    local base = base or 200
    if ping == 0 then ping = base end
    wait(2 * ping, 4 * ping)
end

function timeleft(t, ctime)
    local ctime = ctime or currenttime()
    return tosec(t) - tosec(ctime)
end

function depositall()
    npctalk('hi', 'deposit all', 'yes')
end

function withdraw(amount, npc, sayhi)
    if not amount or amount == 0 then
        return true
    end

    if sayhi == true then
        npctalk('hi', 'withdraw ' .. amount, 'yes')
    else
        npctalk('withdraw ' .. amount, 'yes')
    end

    waitping()
    foreach newmessage m do
        if m.content == 'There is not enough gold on your account.' then
            if (not npc) or (npc == '') or (m.sender == npc) then
                return false
            end
        end
    end

    return true
end

function tryexec(cmd, x, y, z, maxtries)
    local tries = 0
    maxtries = maxtries or 5

    while tries <= maxtries do
        if $posx ~= x or $posy ~= y or $posz ~= z then
            moveto(x, y, z)
            tries = tries + 1
            waitping()
        else
            exec(cmd)
            return true
        end
    end

    return false
end

function opendepot()
    local wtp = getsetting('Cavebot/Pathfinding/WalkThroughPlayers')
    if wtp == 'yes' then setsetting('Cavebot/Pathfinding/WalkThroughPlayers', 'no') end

    reachgrounditem('depot') waitping()
    openitem('depot') waitping()

    setsetting('Cavebot/Pathfinding/WalkThroughPlayers', wtp)
end

function movetoinsist(x, y, z, maxtries)
    local tries = 0
    maxtries = maxtries or 5

    while tries <= maxtries and $posx ~= x and $posy ~= y do
        tries = tries + 1
        if $posz ~= z then return false end
        moveto(x, y, z)
        waitping()
    end

    return true
end

function refillsofts()
    local quit = false
    npctalk('hi')
    while not quit and itemcount('worn soft boots') > 0 do
        npctalk('repair', 'yes')
        wait(2000, 3000)
        foreach newmessage m do
            if m.content == 'At last, someone poorer than me.' then
                if (not npc) or (m.sender == 'Aldo') then
                    if not (movetoinsist(33019, 32053, 6) and
                        withdraw(10000, 'Rokyn', true) and
                        movetoinsist(32953, 32108, 6)) then
                        quit = true
                    else
                        npcsay('hi')
                    end
                end
            end
        end
    end
end

function __loop_open(container, ignore, maxtries)
    if type(container) == 'string' then container = container:lower() end
    ignore = ignore:lower()
    maxtries = maxtries or 5
    if container == ignore then return (windowcount(container) ~= 0) end

    local countbefore = windowcount()
    local tries = 0
    while (countbefore == windowcount()) and windowcount(container) == 0 and tries <= maxtries do
        if tries == maxtries then return false end
        openitem(container, 'Locker', true)
        waitping()
        tries = tries + 1
    end

    return true
end

function __dp_item(item, from, container, container_id)
    local continue = true

    while continue and itemcount(item, from) > 0 do
        if emptycount(container_id) == 0 then
            continue = (itemcount(container) > 0)
            if continue then
                openitem(container, container_id)
                waitping()
            end
        else
            moveitems(item, container_id, from)
            waitping()
        end
    end
end

function deposititems(dest, stack, from, open, ...)
    local items = {...}
    if type(items[1]) == 'table' then items = items[1] end
    if open and windowcount('locker') == 0 then opendepot() waitping() end
    dest = dest or 'locker'
    stack = stack or 'locker'
    if type(from) ~= 'table' then from = {from} end
    if type(dest) == 'string' then dest = dest:lower() end
    if type(stack) == 'string' then stack = stack:lower() end

    if (not __loop_open(stack, 'locker')) or (not __loop_open(dest, 'locker')) then return false end

    destd = windowcount() - 1
    if stack == dest then stackd = destd else stackd = destd - 1 end

    for i = 1, #items do
        if itemproperty(items[i], ITEM_STACKABLE) then
            for j = 1, #from do
                __dp_item(items[i], from[j], stack, stackd)
            end
        end
    end

    for i = 1, #items do
        if not itemproperty(items[i], ITEM_STACKABLE) then
            for j = 1, #from do
                __dp_item(items[i], from[j], dest, destd)
            end
        end
    end
end

function dropitemsex(cap, ...)
    local cap = cap or 250
    local drop = {...}

    if $cap < cap then
        for i = 1, #drop do
            while $cap < cap and itemcount(drop[i]) > 0 do
                local count = math.ceil((cap - $cap) / itemweight(drop[i]))
                moveitems(itemid(drop[i]), 'ground', '', count)
            end
        end
    end
end

function dontlist()
    listas('dontlist')
end

function goback()
    gotolabel(0)
end

function creatureinfo(creaturename)
    if creaturename == '' then return nil end
    return creatures_table[table.binaryfind(creatures_table,creaturename:lower(),'name')]
end

function creaturemaxhp(creaturename)
    if creaturename == '' then return 0 end
    local cre = creatureinfo(creaturename)
    if cre then return cre.hp end
	printerror('Monster: '..creaturename..' not found')
    return 0
end

function creaturehp(creaturename)
    if creaturename == '' then return 0 end
    if type(creaturename) ~= 'userdata' then
        creaturename = findcreature(creaturename)
    end
    local cre = creaturename
    local creinfo = creatureinfo(cre.name)
    if not creinfo then
        printerror('Monster: '.. cre.name ..' not found')
        return 0
    end
    return creinfo.hp*100/cre.hppc
end

function creatureexp(creaturename)
    if creaturename == '' then return 0 end
    local cre = creatureinfo(creaturename)
    if cre then return cre.exp end
	printerror('Monster: '..creaturename..' not found')
    return 0
end

function expratio(creaturename)
    if creaturename == '' then return 0 end
    local cre = creatureinfo(creaturename)
    if cre then return cre.ratio end
	printerror('Monster: '..creaturename..' not found')
    return 0
end

function maxdamage(creaturename)
    if creaturename == '' then return 0 end
    if creaturename then
        local cre = creatureinfo(creaturename)
        if cre then return cre.maxdmg end
		printerror('Monster: '..creaturename..' not found')
        return 0
    else
        local total = 0
        foreach creature c "ms" do
            total = total + maxdamage(c.name)
        end
        return total
    end
end

function getelementword(element)
    local spells = {physical = 'moe ico', holy = 'san', death = 'mort', fire = 'flam', ice = 'frigo', energy = 'vis', earth = 'tera'}
    if spells[element] then return spells[element] end
    printerror('Element: '..element..' not found')
    return nil
end

function bestelement(creaturename, strongonly)
    if creaturename == '' then return nil end
    local cre = creatureinfo(creaturename)
    local voc = vocation()
    strongonly = strongonly or false
    if voc == 'knight' then
        return 'physical', cre.physicalmod
    elseif voc == 'paladin' then
        if cre.physicalmod > cre.holymod then
            return 'physical', cre.physicalmod
        else
            return 'holy', cre.holymod
        end
    elseif voc == 'sorcerer' then
        local best = ''
        local max = 0
        local elements = {}
        if strongonly then
            elements = {'energy', 'fire'}
        else
            elements = {'energy', 'fire', 'ice', 'earth', 'death'}
        end
        for i = 1, #elements do
            if cre[elements[i]..'mod'] > max then
                max = cre[elements[i]..'mod']
                best = elements[i]
            end
        end

        return best, max
    elseif voc == 'druid' then
        local best = ''
        local max = 0
        local elements = {}
        if strongonly then
            elements = {'ice', 'earth'}
        else
            elements = {'energy', 'fire', 'ice', 'earth', 'physical'}
        end
        for i = 1, #elements do
            if cre[elements[i]..'mod'] > max then
                max = cre[elements[i]..'mod']
                best = elements[i]
            end
        end

        return best, max
    elseif voc == 'mage' then
        local best = ''
        local max = 0
        local elements = {'ice', 'earth', 'energy', 'fire'}
        for i = 1, #elements do
            if cre[elements[i]..'mod'] > max then
                max = cre[elements[i]..'mod']
                best = elements[i]
            end
        end

        return best, max
    end

    if cre then return cre.bestspell end
	printerror('Monster: '..creaturename..' not found')
    return nil
end

function beststrike(creaturename)
    if creaturename == '' then return nil end
    return 'exori '..getelementword(bestelement(creaturename, false))
end

function beststrongstrike(creaturename)
    if creaturename == '' then return nil end
    return 'exori gran '..getelementword(bestelement(creaturename, true))
end

function bestspell(creaturename)
    return beststrike(creaturename)
end

function buyitemstocap(itemname, cap)
    local tries = 0
    local amount = math.floor(($cap - cap) / itemweight(itemname))
    local maxtries = maxtries or (2 * amount / 100)

    if not $tradeopen then opentrade() end
    while $cap > cap and tries <= maxtries do
        count = itemcount(itemname)
        amount = math.floor(($cap - cap) / itemweight(itemname)) % 100
        if amount == 0 then amount = 100 end
        buyitems(itemname, amount)
        waitping()
        tries = tries + 1
    end
end

function itemscosttocap(itemname, cap)
    local item = iteminfo(itemname)
    if item then
        return item.npcprice * math.floor((($cap - cap) / item.weight))
    end
    printerror('Item: '..itemname..' not found')
    return 0
end

function trapped()
        for i = -2, 2 do
            for j = -2, 2 do
                local cx = $posx + i
                local cy = $posy + j
                if tilereachable(cx, cy, $posz) then return false end
            end
        end

    return true
end

function euclideandist(sx, sy, dx, dy)
    return math.sqrt(math.pow(dx - sx, 2) + math.pow(dy - sy, 2))
end

function distto(sx, sy, dx, dy)
    local distx = math.abs(sx - dx)
    local disty = math.abs(sy - dy)
    if distx > disty then
        return distx
    else
        return disty
    end
end

function leavetrap(spell)
    spell = spell or 'none'
    local cr = nil
    local distmin = 100
    local sp = ''
    local cb = $cavebot

    if cb and trapped() then setcavebot('off') end
    while trapped() do
        wait(1000)
        foreach creature c "ms" do
            if c.dist == 1 then
                if cb then
                    if not cr then cr = c end
                    local dist = distto($wptx, $wpty, c.posx, c.posy)
                    if dist < distmin then
                        distmin = dist
                        cr = c
                    end
                else
                    cr = c
                    break
                end
            end
        end
        attack(cr)
        if spell ~= 'none' then
            if spell == 'strike' then sp = bestspell(cr.name) else sp = spell end
            cast(sp)
        end
    end
    if cb then setcavebot('on') end
end

function getplayerskill() -- credits for sirmate on this one
    local weaponType = findweapontype()
    local playerVocation = vocation()
    if (playerVocation == 'knight') then
        if (weaponType == 'club') then
            return {$club, $clubpc}
        elseif (weaponType == 'sword') then
            return {$sword, $swordpc}
        elseif (weaponType == 'axe') then
            return {$axe, $axepc}
        end
    elseif (playerVocation == 'paladin') then
        return {$distance, $distancepc}
    elseif (playerVocation == 'mage' or playerVocation == 'druid' or playerVocation == 'sorcerer') then
        if ($club >= $sword and $axe) then
            return {$club, $clubpc}
        elseif ($sword >= $club and $axe) then
            return {$sword, $swordpc}
        elseif ($axe >= $club and $sword) then
            return {$axe, $axepc}
        end
    end
end

function spelldamage(spell, level, mlevel, skill)
    level = level or $level
    mlevel = mlevel or $mlevel
    skill = skill or getplayerskill()[1]
    local sp = spell:gsub(' ', '_')
    if not spellformulas[sp] then
        printerror('Spell: '..spell..' not found.')
        return nil
    end
    return spellformulas[sp](level, mlevel, skill)
end


-- information tables

spellformulas = {
    beserk              = function(a, b, c) return {((a + b) * 0.5 + (c / 5)), ((a + b) * 1.5 + (c / 5))} end,
    whirlwind_throw     = function(a, b, c) return {(a + b) / 3 + c / 5, a + b + c / 5} end,
    fierce_beserk       = function(a, b, c) return {((a + b * 2) * 1.1 + (c / 5)), ((a + b * 2) * 3 + (c / 5))} end,
    etheral_spear       = function(a, b) return {(a + 25) / 3 + b / 5, (a + 25 + b / 5)} end,
    strike              = function(l, m) return {0.2 * l + 1.403 * m + 08, 0.2 * l + 2.203 * m + 13} end,
    divine_missile      = function(l, m) return {0.2 * l + 1.790 * m + 11, 0.2 * l + 3.000 * m + 18} end,
    ice_wave            = function(l, m) return {0.2 * l + 0.810 * m + 04, 0.2 * l + 2.000 * m + 12} end,
    fire_wave           = function(l, m) return {0.2 * l + 1.250 * m + 04, 0.2 * l + 2.000 * m + 12} end,
    light_magic_missile = function(l, m) return {0.2 * l + 0.400 * m + 02, 0.2 * l + 0.810 * m + 04} end,
    heavy_magic_missile = function(l, m) return {0.2 * l + 0.810 * m + 04, 0.2 * l + 1.590 * m + 10} end,
    stalagmite          = function(l, m) return {0.2 * l + 0.810 * m + 04, 0.2 * l + 1.590 * m + 10} end,
    icicle              = function(l, m) return {0.2 * l + 1.810 * m + 10, 0.2 * l + 3.000 * m + 18} end,
    fireball            = function(l, m) return {0.2 * l + 1.810 * m + 10, 0.2 * l + 3.000 * m + 18} end,
    holy_missile        = function(l, m) return {0.2 * l + 1.790 * m + 11, 0.2 * l + 3.750 * m + 24} end,
    sudden_death        = function(l, m) return {0.2 * l + 4.605 * m + 28, 0.2 * l + 7.395 * m + 46} end,
    thunderstorm        = function(l, m) return {0.2 * l + 1.000 * m + 06, 0.2 * l + 2.600 * m + 16} end,
    stone_shower        = function(l, m) return {0.2 * l + 1.000 * m + 06, 0.2 * l + 2.600 * m + 16} end,
    avalanche           = function(l, m) return {0.2 * l + 1.200 * m + 07, 0.2 * l + 2.800 * m + 17} end,
    great_fireball      = function(l, m) return {0.2 * l + 1.200 * m + 07, 0.2 * l + 2.800 * m + 17} end,
    explosion           = function(l, m) return {0.2 * l + 0.0 * m, 0.2 * l + 4.8 * m} end,
    energy_beam         = function(l, m) return {0.2 * l + 2.5 * m, 0.2 * l + 4.0 * m} end,
    great_energy_beam   = function(l, m) return {0.2 * l + 4.0 * m, 0.2 * l + 7.0 * m} end,
    divine_caldera      = function(l, m) return {0.2 * l + 4.0 * m, 0.2 * l + 6.0 * m} end,
    terra_wave          = function(l, m) return {0.2 * l + 3.5 * m, 0.2 * l + 7.0 * m} end,
    energy_wave         = function(l, m) return {0.2 * l + 4.5 * m, 0.2 * l + 9.0 * m} end,
    heal_friend         = function(l, m) return {0.2 * l + 010 * m, 0.2 * l + 014 * m} end,
    rage_of_the_skies   = function(l, m) return {0.2 * l + 5.0 * m, 0.2 * l + 012 * m} end,
    hells_core          = function(l, m) return {0.2 * l + 7.0 * m, 0.2 * l + 014 * m} end,
    wrath_of_nature     = function(l, m) return {0.2 * l + 5.0 * m, 0.2 * l + 010 * m} end,
    eternal_winter      = function(l, m) return {0.2 * l + 6.0 * m, 0.2 * l + 012 * m} end,
    divine_healing      = function(l, m) return {0.2 * l + 18.5 * m, 0.2 * l + 025 * m} end,
    light_healing       = function(l, m) return {0.2 * l + 1.400 * m + 08, 0.2 * l + 1.795 * m + 11} end,
    intense_healing     = function(l, m) return {0.2 * l + 3.184 * m + 20, 0.2 * l + 5.590 * m + 35} end,
    ultimate_healing    = function(l, m) return {0.2 * l + 7.220 * m + 44, 0.2 * l + 12.79 * m + 79} end,
    wound_cleansing     = function(l, m) return {0.2 * l + 4.000 * m + 25, 0.2 * l + 7.750 * m + 50} end,
    mass_healing        = function(l, m) return {0.2 * l + 5.700 * m + 26, 0.2 * l + 10.43 * m + 62} end,
}

creatures_table = {
    {name = "achad", exp = 70, hp = 185, ratio = 0.378, maxdmg = 80, deathmod = 100, firemod = 90, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "acid blob", exp = 250, hp = 250, ratio = 1.000, maxdmg = 160, deathmod = 0, firemod = 110, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "acolyte of darkness", exp = 200, hp = 325, ratio = 0.615, maxdmg = 120, deathmod = 0, firemod = 0, energymod = 80, earthmod = 0, icemod = 90, holymod = 105, physicalmod = 105},
    {name = "acolyte of the cult", exp = 300, hp = 390, ratio = 0.769, maxdmg = 220, deathmod = 105, firemod = 100, energymod = 110, earthmod = 80, icemod = 80, holymod = 80, physicalmod = 110},
    {name = "adept of the cult", exp = 400, hp = 430, ratio = 0.930, maxdmg = 242, deathmod = 105, firemod = 100, energymod = 105, earthmod = 60, icemod = 80, holymod = 70, physicalmod = 100},
    {name = "amazon", exp = 60, hp = 110, ratio = 0.545, maxdmg = 60, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 105},
    {name = "ancient scarab", exp = 720, hp = 1000, ratio = 0.720, maxdmg = 380, deathmod = 100, firemod = 120, energymod = 80, earthmod = 0, icemod = 105, holymod = 100, physicalmod = 90},
    {name = "anmothra", exp = 10000, hp = 2100, ratio = 4.762, maxdmg = 350, deathmod = 110, firemod = 0, energymod = 75, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "annihilon", exp = 15000, hp = 40000, ratio = 0.375, maxdmg = 2650, deathmod = 5, firemod = 100, energymod = 5, earthmod = 100, icemod = 80, holymod = 105, physicalmod = 100},
    {name = "apocalypse", exp = 80000, hp = 160000, ratio = 0.500, maxdmg = 9800, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "apprentice sheng", exp = 150, hp = 95, ratio = 1.579, maxdmg = 80, deathmod = 100, firemod = 100, energymod = 0, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "arachir the ancient one", exp = 1800, hp = 1600, ratio = 1.125, maxdmg = 480, deathmod = 0, firemod = 101, energymod = 80, earthmod = 100, icemod = 95, holymod = 105, physicalmod = 99},
    {name = "arkhothep", exp = 0, hp = 1, ratio = 0.000, maxdmg = 5000, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "armenius", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "arthei", exp = 4000, hp = 4200, ratio = 0.952, maxdmg = 1000, deathmod = 0, firemod = 101, energymod = 100, earthmod = 0, icemod = 100, holymod = 105, physicalmod = 100},
    {name = "ashmunrah", exp = 3100, hp = 5000, ratio = 0.620, maxdmg = 2412, deathmod = 0, firemod = 105, energymod = 80, earthmod = 75, icemod = 80, holymod = 110, physicalmod = 90},
    {name = "assassin", exp = 105, hp = 175, ratio = 0.600, maxdmg = 160, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 105},
    {name = "avalanche", exp = 305, hp = 550, ratio = 0.555, maxdmg = 250, deathmod = 100, firemod = 70, energymod = 110, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "axeitus headbanger", exp = 140, hp = 365, ratio = 0.384, maxdmg = 130, deathmod = 100, firemod = 105, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "azerus", exp = 6000, hp = 7500, ratio = 0.800, maxdmg = 1000, deathmod = 85, firemod = 85, energymod = 85, earthmod = 85, icemod = 85, holymod = 85, physicalmod = 100},
    {name = "azure frog", exp = 20, hp = 60, ratio = 0.333, maxdmg = 24, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "badger", exp = 5, hp = 23, ratio = 0.217, maxdmg = 12, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "bandit", exp = 65, hp = 245, ratio = 0.265, maxdmg = 43, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 110},
    {name = "bane of light", exp = 450, hp = 925, ratio = 0.486, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 95, earthmod = 0, icemod = 0, holymod = 125, physicalmod = 65},
    {name = "banshee", exp = 900, hp = 1000, ratio = 0.900, maxdmg = 652, deathmod = 0, firemod = 0, energymod = 100, earthmod = 0, icemod = 100, holymod = 125, physicalmod = 100},
    {name = "barbaria", exp = 355, hp = 345, ratio = 1.029, maxdmg = 170, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "barbarian bloodwalker", exp = 195, hp = 305, ratio = 0.639, maxdmg = 200, deathmod = 101, firemod = 100, energymod = 90, earthmod = 105, icemod = 50, holymod = 80, physicalmod = 95},
    {name = "barbarian brutetamer", exp = 90, hp = 145, ratio = 0.621, maxdmg = 54, deathmod = 101, firemod = 100, energymod = 80, earthmod = 100, icemod = 50, holymod = 90, physicalmod = 120},
    {name = "barbarian headsplitter", exp = 85, hp = 100, ratio = 0.850, maxdmg = 110, deathmod = 101, firemod = 100, energymod = 80, earthmod = 110, icemod = 50, holymod = 90, physicalmod = 100},
    {name = "barbarian skullhunter", exp = 85, hp = 135, ratio = 0.630, maxdmg = 65, deathmod = 101, firemod = 100, energymod = 80, earthmod = 110, icemod = 50, holymod = 90, physicalmod = 95},
    {name = "baron brute", exp = 3000, hp = 5025, ratio = 0.597, maxdmg = 474, deathmod = 100, firemod = 20, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "bat", exp = 10, hp = 30, ratio = 0.333, maxdmg = 8, deathmod = 100, firemod = 100, energymod = 100, earthmod = 120, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "battlemaster zunzu", exp = 2500, hp = 5000, ratio = 0.500, maxdmg = 650, deathmod = 90, firemod = 75, energymod = 80, earthmod = 0, icemod = 85, holymod = 100, physicalmod = 85},
    {name = "bazir", exp = 0, hp = 1, ratio = 0.000, maxdmg = 4000, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "bear", exp = 23, hp = 80, ratio = 0.287, maxdmg = 25, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "behemoth", exp = 2500, hp = 4000, ratio = 0.625, maxdmg = 635, deathmod = 105, firemod = 70, energymod = 90, earthmod = 20, icemod = 110, holymod = 70, physicalmod = 90},
    {name = "berserker chicken", exp = 220, hp = 465, ratio = 0.473, maxdmg = 270, deathmod = 90, firemod = 90, energymod = 90, earthmod = 90, icemod = 90, holymod = 90, physicalmod = 120},
    {name = "betrayed wraith", exp = 3500, hp = 4200, ratio = 0.833, maxdmg = 455, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 50, holymod = 120, physicalmod = 100},
    {name = "big boss trolliver", exp = 105, hp = 150, ratio = 0.700, maxdmg = 40, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "black knight", exp = 1600, hp = 1800, ratio = 0.889, maxdmg = 500, deathmod = 80, firemod = 5, energymod = 20, earthmod = 0, icemod = 0, holymod = 108, physicalmod = 80},
    {name = "black sheep", exp = 0, hp = 20, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "blazing fire elemental", exp = 450, hp = 650, ratio = 0.692, maxdmg = 450, deathmod = 70, firemod = 0, energymod = 80, earthmod = 100, icemod = 125, holymod = 100, physicalmod = 100},
    {name = "blightwalker", exp = 5850, hp = 8900, ratio = 0.657, maxdmg = 900, deathmod = 0, firemod = 50, energymod = 80, earthmod = 0, icemod = 50, holymod = 130, physicalmod = 110},
    {name = "blistering fire elemental", exp = 1300, hp = 1500, ratio = 0.867, maxdmg = 975, deathmod = 60, firemod = 0, energymod = 80, earthmod = 50, icemod = 115, holymod = 0, physicalmod = 75},
    {name = "blood crab", exp = 160, hp = 290, ratio = 0.552, maxdmg = 110, deathmod = 100, firemod = 110, energymod = 105, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 80},
    {name = "blood crab", exp = 180, hp = 320, ratio = 0.562, maxdmg = 111, deathmod = 100, firemod = 0, energymod = 105, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 99},
    {name = "bloodpaw", exp = 50, hp = 100, ratio = 0.500, maxdmg = 40, deathmod = 100, firemod = 80, energymod = 110, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "bloom of doom", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "blue djinn", exp = 215, hp = 330, ratio = 0.652, maxdmg = 325, deathmod = 112, firemod = 20, energymod = 50, earthmod = 100, icemod = 110, holymod = 99, physicalmod = 100},
    {name = "bog raider", exp = 800, hp = 1300, ratio = 0.615, maxdmg = 600, deathmod = 95, firemod = 15, energymod = 110, earthmod = 70, icemod = 105, holymod = 105, physicalmod = 120},
    {name = "bonebeast", exp = 580, hp = 515, ratio = 1.126, maxdmg = 340, deathmod = 0, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 120, physicalmod = 100},
    {name = "bonelord", exp = 170, hp = 260, ratio = 0.654, maxdmg = 235, deathmod = 100, firemod = 110, energymod = 100, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "bones", exp = 3750, hp = 9500, ratio = 0.395, maxdmg = 1200, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "boogey", exp = 475, hp = 930, ratio = 0.511, maxdmg = 200, deathmod = 0, firemod = 110, energymod = 110, earthmod = 60, icemod = 75, holymod = 110, physicalmod = 100},
    {name = "boreth", exp = 1800, hp = 1400, ratio = 1.286, maxdmg = 800, deathmod = 0, firemod = 101, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "bovinus", exp = 60, hp = 150, ratio = 0.400, maxdmg = 50, deathmod = 100, firemod = 80, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "braindeath", exp = 985, hp = 1225, ratio = 0.804, maxdmg = 700, deathmod = 0, firemod = 115, energymod = 90, earthmod = 0, icemod = 80, holymod = 120, physicalmod = 90},
    {name = "bride of night", exp = 450, hp = 275, ratio = 1.636, maxdmg = 100, deathmod = 80, firemod = 100, energymod = 100, earthmod = 100, icemod = 120, holymod = 100, physicalmod = 100},
    {name = "brimstone bug", exp = 900, hp = 1300, ratio = 0.692, maxdmg = 420, deathmod = 0, firemod = 110, energymod = 110, earthmod = 0, icemod = 110, holymod = 110, physicalmod = 105},
    {name = "brutus bloodbeard", exp = 795, hp = 1200, ratio = 0.662, maxdmg = 350, deathmod = 100, firemod = 100, energymod = 101, earthmod = 100, icemod = 101, holymod = 99, physicalmod = 100},
    {name = "bug", exp = 18, hp = 29, ratio = 0.621, maxdmg = 23, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "butterfly", exp = 0, hp = 2, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "cake golem", exp = 0, hp = 1, ratio = 0.000, maxdmg = 120, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "captain jones", exp = 825, hp = 800, ratio = 1.031, maxdmg = 400, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 0},
    {name = "carniphila", exp = 150, hp = 255, ratio = 0.588, maxdmg = 330, deathmod = 100, firemod = 120, energymod = 90, earthmod = 0, icemod = 65, holymod = 100, physicalmod = 100},
    {name = "carrion worm", exp = 70, hp = 145, ratio = 0.483, maxdmg = 45, deathmod = 100, firemod = 105, energymod = 99, earthmod = 80, icemod = 105, holymod = 100, physicalmod = 100},
    {name = "cat", exp = 0, hp = 20, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "cave rat", exp = 10, hp = 30, ratio = 0.333, maxdmg = 10, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "centipede", exp = 34, hp = 70, ratio = 0.486, maxdmg = 46, deathmod = 100, firemod = 115, energymod = 90, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "chakoya toolshaper", exp = 40, hp = 80, ratio = 0.500, maxdmg = 80, deathmod = 105, firemod = 60, energymod = 115, earthmod = 100, icemod = 0, holymod = 90, physicalmod = 100},
    {name = "chakoya tribewarden", exp = 40, hp = 68, ratio = 0.588, maxdmg = 30, deathmod = 105, firemod = 75, energymod = 115, earthmod = 100, icemod = 0, holymod = 90, physicalmod = 100},
    {name = "chakoya windcaller", exp = 48, hp = 84, ratio = 0.571, maxdmg = 82, deathmod = 110, firemod = 50, energymod = 115, earthmod = 100, icemod = 0, holymod = 80, physicalmod = 100},
    {name = "charged energy elemental", exp = 450, hp = 500, ratio = 0.900, maxdmg = 375, deathmod = 100, firemod = 0, energymod = 0, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 105},
    {name = "chicken", exp = 0, hp = 15, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "chikhaton", exp = 35000, hp = 1, ratio = 35000.000, maxdmg = 1130, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "chizzoron the distorter", exp = 0, hp = 8000, ratio = 0.000, maxdmg = 2300, deathmod = 70, firemod = 100, energymod = 80, earthmod = 0, icemod = 80, holymod = 90, physicalmod = 100},
    {name = "cobra", exp = 30, hp = 65, ratio = 0.462, maxdmg = 5, deathmod = 100, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "cockroach", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "cocoon", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "coldheart", exp = 3500, hp = 7000, ratio = 0.500, maxdmg = 675, deathmod = 100, firemod = 0, energymod = 100, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "colerian the barbarian", exp = 90, hp = 265, ratio = 0.340, maxdmg = 100, deathmod = 100, firemod = 100, energymod = 80, earthmod = 120, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "coral frog", exp = 20, hp = 60, ratio = 0.333, maxdmg = 24, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "countess sorrow", exp = 13000, hp = 6500, ratio = 2.000, maxdmg = 2905, deathmod = 0, firemod = 110, energymod = 90, earthmod = 0, icemod = 50, holymod = 100, physicalmod = 0},
    {name = "crab", exp = 30, hp = 55, ratio = 0.545, maxdmg = 20, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 99, holymod = 100, physicalmod = 100},
    {name = "crazed beggar", exp = 35, hp = 100, ratio = 0.350, maxdmg = 25, deathmod = 110, firemod = 100, energymod = 80, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 95},
    {name = "crimson frog", exp = 20, hp = 60, ratio = 0.333, maxdmg = 24, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "crocodile", exp = 40, hp = 105, ratio = 0.381, maxdmg = 40, deathmod = 100, firemod = 110, energymod = 105, earthmod = 80, icemod = 90, holymod = 100, physicalmod = 105},
    {name = "crypt shambler", exp = 195, hp = 330, ratio = 0.591, maxdmg = 195, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 125, physicalmod = 100},
    {name = "crystal spider", exp = 900, hp = 1250, ratio = 0.720, maxdmg = 358, deathmod = 100, firemod = 0, energymod = 120, earthmod = 80, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "cublarc the plunderer", exp = 400, hp = 400, ratio = 1.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "cursed gladiator", exp = 215, hp = 435, ratio = 0.494, maxdmg = 200, deathmod = 100, firemod = 105, energymod = 100, earthmod = 80, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "cyclops", exp = 150, hp = 260, ratio = 0.577, maxdmg = 105, deathmod = 110, firemod = 100, energymod = 75, earthmod = 110, icemod = 100, holymod = 80, physicalmod = 100},
    {name = "cyclops drone", exp = 200, hp = 325, ratio = 0.615, maxdmg = 180, deathmod = 105, firemod = 100, energymod = 90, earthmod = 110, icemod = 80, holymod = 99, physicalmod = 100},
    {name = "cyclops smith", exp = 255, hp = 435, ratio = 0.586, maxdmg = 220, deathmod = 105, firemod = 90, energymod = 80, earthmod = 110, icemod = 100, holymod = 99, physicalmod = 100},
    {name = "damaged worker golem", exp = 95, hp = 260, ratio = 0.365, maxdmg = 90, deathmod = 90, firemod = 100, energymod = 105, earthmod = 50, icemod = 90, holymod = 50, physicalmod = 75},
    {name = "darakan the executioner", exp = 1600, hp = 3500, ratio = 0.457, maxdmg = 390, deathmod = 100, firemod = 101, energymod = 100, earthmod = 100, icemod = 99, holymod = 100, physicalmod = 100},
    {name = "dark apprentice", exp = 100, hp = 225, ratio = 0.444, maxdmg = 100, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dark magician", exp = 185, hp = 325, ratio = 0.569, maxdmg = 100, deathmod = 101, firemod = 90, energymod = 80, earthmod = 80, icemod = 90, holymod = 80, physicalmod = 100},
    {name = "dark monk", exp = 145, hp = 190, ratio = 0.763, maxdmg = 150, deathmod = 60, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 110, physicalmod = 120},
    {name = "dark torturer", exp = 4650, hp = 7350, ratio = 0.633, maxdmg = 1300, deathmod = 90, firemod = 0, energymod = 70, earthmod = 10, icemod = 110, holymod = 110, physicalmod = 100},
    {name = "deadeye devious", exp = 500, hp = 1450, ratio = 0.345, maxdmg = 250, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "death blob", exp = 300, hp = 320, ratio = 0.938, maxdmg = 212, deathmod = 0, firemod = 110, energymod = 110, earthmod = 0, icemod = 90, holymod = 110, physicalmod = 70},
    {name = "deathbringer", exp = 5100, hp = 10000, ratio = 0.510, maxdmg = 1265, deathmod = 0, firemod = 0, energymod = 120, earthmod = 0, icemod = 0, holymod = 110, physicalmod = 100},
    {name = "deathslicer", exp = 0, hp = 1, ratio = 0.000, maxdmg = 1000, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "deathspawn", exp = 0, hp = 225, ratio = 0.000, maxdmg = 1000, deathmod = 0, firemod = 85, energymod = 85, earthmod = 0, icemod = 85, holymod = 110, physicalmod = 100},
    {name = "deer", exp = 0, hp = 25, ratio = 0.000, maxdmg = 1, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "defiler", exp = 3700, hp = 3650, ratio = 1.014, maxdmg = 712, deathmod = 100, firemod = 125, energymod = 90, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "demodras", exp = 6000, hp = 4500, ratio = 1.333, maxdmg = 1150, deathmod = 100, firemod = 0, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "demon", exp = 6000, hp = 8200, ratio = 0.732, maxdmg = 1530, deathmod = 70, firemod = 0, energymod = 50, earthmod = 60, icemod = 112, holymod = 112, physicalmod = 70},
    {name = "demon parrot", exp = 225, hp = 360, ratio = 0.625, maxdmg = 190, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "demon skeleton", exp = 240, hp = 400, ratio = 0.600, maxdmg = 235, deathmod = 0, firemod = 0, energymod = 100, earthmod = 0, icemod = 100, holymod = 125, physicalmod = 100},
    {name = "demon (goblin)", exp = 25, hp = 50, ratio = 0.500, maxdmg = 30, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "destroyer", exp = 2500, hp = 3700, ratio = 0.676, maxdmg = 700, deathmod = 80, firemod = 70, energymod = 0, earthmod = 80, icemod = 115, holymod = 103, physicalmod = 99},
    {name = "devovorga", exp = 0, hp = 1, ratio = 0.000, maxdmg = 9400, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dharalion", exp = 380, hp = 380, ratio = 1.000, maxdmg = 120, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "diabolic imp", exp = 2900, hp = 1950, ratio = 1.487, maxdmg = 870, deathmod = 90, firemod = 0, energymod = 100, earthmod = 50, icemod = 110, holymod = 110, physicalmod = 100},
    {name = "diblis the fair", exp = 1800, hp = 1500, ratio = 1.200, maxdmg = 1500, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 105, physicalmod = 60},
    {name = "dipthrah", exp = 2900, hp = 4200, ratio = 0.690, maxdmg = 1400, deathmod = 0, firemod = 100, energymod = 80, earthmod = 80, icemod = 100, holymod = 110, physicalmod = 0},
    {name = "dire penguin", exp = 119, hp = 173, ratio = 0.688, maxdmg = 115, deathmod = 100, firemod = 50, energymod = 105, earthmod = 50, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dirtbeard", exp = 375, hp = 630, ratio = 0.595, maxdmg = 225, deathmod = 100, firemod = 110, energymod = 100, earthmod = 80, icemod = 105, holymod = 90, physicalmod = 100},
    {name = "diseased bill", exp = 300, hp = 2000, ratio = 0.150, maxdmg = 769, deathmod = 25, firemod = 75, energymod = 75, earthmod = 0, icemod = 75, holymod = 75, physicalmod = 90},
    {name = "diseased dan", exp = 300, hp = 2000, ratio = 0.150, maxdmg = 381, deathmod = 95, firemod = 15, energymod = 110, earthmod = 80, icemod = 105, holymod = 105, physicalmod = 105},
    {name = "diseased fred", exp = 300, hp = 2000, ratio = 0.150, maxdmg = 450, deathmod = 45, firemod = 85, energymod = 85, earthmod = 0, icemod = 85, holymod = 85, physicalmod = 85},
    {name = "doctor perhaps", exp = 325, hp = 475, ratio = 0.684, maxdmg = 100, deathmod = 100, firemod = 90, energymod = 80, earthmod = 80, icemod = 80, holymod = 80, physicalmod = 105},
    {name = "dog", exp = 0, hp = 20, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "doom deer", exp = 200, hp = 405, ratio = 0.494, maxdmg = 155, deathmod = 100, firemod = 100, energymod = 0, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "doomhowl", exp = 3750, hp = 8500, ratio = 0.441, maxdmg = 644, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 85},
    {name = "doomsday cultist", exp = 100, hp = 125, ratio = 0.800, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dracola", exp = 11000, hp = 16200, ratio = 0.679, maxdmg = 4245, deathmod = 0, firemod = 0, energymod = 100, earthmod = 0, icemod = 0, holymod = 110, physicalmod = 100},
    {name = "dragon", exp = 700, hp = 1000, ratio = 0.700, maxdmg = 400, deathmod = 100, firemod = 0, energymod = 80, earthmod = 20, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "dragon hatchling", exp = 185, hp = 380, ratio = 0.487, maxdmg = 200, deathmod = 100, firemod = 0, energymod = 105, earthmod = 25, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "dragon lord", exp = 2100, hp = 1900, ratio = 1.105, maxdmg = 720, deathmod = 100, firemod = 0, energymod = 80, earthmod = 20, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "dragon lord hatchling", exp = 645, hp = 750, ratio = 0.860, maxdmg = 335, deathmod = 100, firemod = 0, energymod = 110, earthmod = 90, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "draken abomination", exp = 3800, hp = 6250, ratio = 0.608, maxdmg = 1000, deathmod = 0, firemod = 0, energymod = 105, earthmod = 0, icemod = 95, holymod = 105, physicalmod = 80},
    {name = "draken elite", exp = 4200, hp = 5550, ratio = 0.757, maxdmg = 1500, deathmod = 70, firemod = 0, energymod = 60, earthmod = 0, icemod = 100, holymod = 70, physicalmod = 85},
    {name = "draken spellweaver", exp = 2600, hp = 5000, ratio = 0.520, maxdmg = 1000, deathmod = 10, firemod = 0, energymod = 110, earthmod = 0, icemod = 110, holymod = 105, physicalmod = 110},
    {name = "draken warmaster", exp = 2400, hp = 4150, ratio = 0.578, maxdmg = 600, deathmod = 50, firemod = 0, energymod = 95, earthmod = 0, icemod = 105, holymod = 95, physicalmod = 95},
    {name = "drasilla", exp = 700, hp = 1320, ratio = 0.530, maxdmg = 390, deathmod = 100, firemod = 0, energymod = 80, earthmod = 100, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "dreadbeast", exp = 250, hp = 800, ratio = 0.312, maxdmg = 140, deathmod = 0, firemod = 45, energymod = 85, earthmod = 0, icemod = 60, holymod = 150, physicalmod = 70},
    {name = "dreadmaw", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dreadwing", exp = 3750, hp = 8500, ratio = 0.441, maxdmg = 100, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dryad", exp = 190, hp = 310, ratio = 0.613, maxdmg = 120, deathmod = 100, firemod = 120, energymod = 70, earthmod = 0, icemod = 99, holymod = 100, physicalmod = 110},
    {name = "duskbringer", exp = 2600, hp = 3000, ratio = 0.867, maxdmg = 700, deathmod = 10, firemod = 110, energymod = 110, earthmod = 50, icemod = 115, holymod = 105, physicalmod = 99},
    {name = "dwarf", exp = 45, hp = 90, ratio = 0.500, maxdmg = 30, deathmod = 105, firemod = 105, energymod = 100, earthmod = 90, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dwarf dispenser", exp = 0, hp = 1, ratio = 0.000, maxdmg = 100, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "dwarf geomancer", exp = 265, hp = 380, ratio = 0.697, maxdmg = 210, deathmod = 101, firemod = 40, energymod = 90, earthmod = 80, icemod = 105, holymod = 90, physicalmod = 100},
    {name = "dwarf guard", exp = 165, hp = 245, ratio = 0.673, maxdmg = 140, deathmod = 105, firemod = 105, energymod = 100, earthmod = 80, icemod = 100, holymod = 100, physicalmod = 90},
    {name = "dwarf henchman", exp = 15, hp = 350, ratio = 0.043, maxdmg = 93, deathmod = 85, firemod = 110, energymod = 100, earthmod = 100, icemod = 85, holymod = 100, physicalmod = 80},
    {name = "dwarf miner", exp = 60, hp = 120, ratio = 0.500, maxdmg = 30, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dwarf soldier", exp = 70, hp = 135, ratio = 0.519, maxdmg = 130, deathmod = 105, firemod = 105, energymod = 100, earthmod = 90, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "dworc fleshhunter", exp = 40, hp = 85, ratio = 0.471, maxdmg = 41, deathmod = 115, firemod = 110, energymod = 100, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "dworc venomsniper", exp = 35, hp = 80, ratio = 0.438, maxdmg = 17, deathmod = 110, firemod = 115, energymod = 100, earthmod = 0, icemod = 113, holymod = 80, physicalmod = 100},
    {name = "dworc voodoomaster", exp = 55, hp = 80, ratio = 0.688, maxdmg = 90, deathmod = 110, firemod = 115, energymod = 100, earthmod = 0, icemod = 110, holymod = 70, physicalmod = 100},
    {name = "earth elemental", exp = 450, hp = 650, ratio = 0.692, maxdmg = 328, deathmod = 50, firemod = 125, energymod = 0, earthmod = 0, icemod = 15, holymod = 50, physicalmod = 50},
    {name = "earth overlord", exp = 2800, hp = 4000, ratio = 0.700, maxdmg = 1500, deathmod = 80, firemod = 125, energymod = 100, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "eclipse knight", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "efreet", exp = 410, hp = 550, ratio = 0.745, maxdmg = 340, deathmod = 99, firemod = 10, energymod = 40, earthmod = 90, icemod = 105, holymod = 108, physicalmod = 100},
    {name = "elder bonelord", exp = 280, hp = 500, ratio = 0.560, maxdmg = 405, deathmod = 70, firemod = 110, energymod = 80, earthmod = 0, icemod = 70, holymod = 100, physicalmod = 100},
    {name = "elephant", exp = 160, hp = 320, ratio = 0.500, maxdmg = 100, deathmod = 100, firemod = 100, energymod = 110, earthmod = 100, icemod = 80, holymod = 100, physicalmod = 75},
    {name = "elf", exp = 42, hp = 100, ratio = 0.420, maxdmg = 40, deathmod = 101, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 80, physicalmod = 100},
    {name = "elf arcanist", exp = 175, hp = 220, ratio = 0.795, maxdmg = 220, deathmod = 80, firemod = 50, energymod = 80, earthmod = 100, icemod = 100, holymod = 110, physicalmod = 100},
    {name = "elf scout", exp = 75, hp = 160, ratio = 0.469, maxdmg = 110, deathmod = 101, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 80, physicalmod = 100},
    {name = "energy elemental", exp = 550, hp = 500, ratio = 1.100, maxdmg = 582, deathmod = 95, firemod = 0, energymod = 0, earthmod = 115, icemod = 0, holymod = 90, physicalmod = 70},
    {name = "energy overlord", exp = 2800, hp = 4000, ratio = 0.700, maxdmg = 1400, deathmod = 100, firemod = 101, energymod = 0, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 50},
    {name = "enlightened of the cult", exp = 500, hp = 700, ratio = 0.714, maxdmg = 285, deathmod = 101, firemod = 100, energymod = 101, earthmod = 100, icemod = 99, holymod = 80, physicalmod = 90},
    {name = "enraged bookworm", exp = 55, hp = 145, ratio = 0.379, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "enraged squirrel", exp = 0, hp = 35, ratio = 0.000, maxdmg = 6, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "esmeralda", exp = 600, hp = 800, ratio = 0.750, maxdmg = 384, deathmod = 0, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "essence of darkness", exp = 30, hp = 1000, ratio = 0.030, maxdmg = 25, deathmod = 0, firemod = 2, energymod = 0, earthmod = 0, icemod = 0, holymod = 20, physicalmod = 0},
    {name = "eternal guardian", exp = 1800, hp = 2500, ratio = 0.720, maxdmg = 300, deathmod = 80, firemod = 30, energymod = 90, earthmod = 0, icemod = 90, holymod = 80, physicalmod = 100},
    {name = "evil mastermind", exp = 675, hp = 1295, ratio = 0.521, maxdmg = 357, deathmod = 0, firemod = 100, energymod = 10, earthmod = 0, icemod = 80, holymod = 105, physicalmod = 95},
    {name = "evil sheep", exp = 240, hp = 350, ratio = 0.686, maxdmg = 140, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 80, holymod = 100, physicalmod = 80},
    {name = "evil sheep lord", exp = 340, hp = 400, ratio = 0.850, maxdmg = 118, deathmod = 100, firemod = 105, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 120},
    {name = "eye of the seven", exp = 0, hp = 1, ratio = 0.000, maxdmg = 500, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "fahim the wise", exp = 1500, hp = 2000, ratio = 0.750, maxdmg = 800, deathmod = 110, firemod = 99, energymod = 100, earthmod = 100, icemod = 115, holymod = 99, physicalmod = 100},
    {name = "fallen mooh'tah master ghar", exp = 4400, hp = 8000, ratio = 0.550, maxdmg = 1600, deathmod = 100, firemod = 40, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "fatality", exp = 4285, hp = 5945, ratio = 0.721, maxdmg = 205, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "fernfang", exp = 600, hp = 400, ratio = 1.500, maxdmg = 230, deathmod = 100, firemod = 100, energymod = 100, earthmod = 50, icemod = 30, holymod = 100, physicalmod = 100},
    {name = "ferumbras", exp = 12000, hp = 35000, ratio = 0.343, maxdmg = 2400, deathmod = 100, firemod = 10, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "fire devil", exp = 145, hp = 200, ratio = 0.725, maxdmg = 160, deathmod = 95, firemod = 0, energymod = 70, earthmod = 80, icemod = 120, holymod = 110, physicalmod = 105},
    {name = "fire elemental", exp = 220, hp = 280, ratio = 0.786, maxdmg = 280, deathmod = 0, firemod = 0, energymod = 100, earthmod = 100, icemod = 125, holymod = 100, physicalmod = 100},
    {name = "fire overlord", exp = 2800, hp = 4000, ratio = 0.700, maxdmg = 1200, deathmod = 80, firemod = 0, energymod = 80, earthmod = 20, icemod = 125, holymod = 100, physicalmod = 99},
    {name = "flamecaller zazrak", exp = 2000, hp = 3000, ratio = 0.667, maxdmg = 560, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "flamethrower", exp = 0, hp = 1, ratio = 0.000, maxdmg = 100, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "flamingo", exp = 0, hp = 25, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "fleabringer", exp = 0, hp = 265, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "fluffy", exp = 3550, hp = 4500, ratio = 0.789, maxdmg = 750, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "foreman kneebiter", exp = 445, hp = 570, ratio = 0.781, maxdmg = 317, deathmod = 101, firemod = 101, energymod = 100, earthmod = 99, icemod = 100, holymod = 100, physicalmod = 99},
    {name = "freegoiz", exp = 0, hp = 1, ratio = 0.000, maxdmg = 1665, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "frost dragon", exp = 2100, hp = 1800, ratio = 1.167, maxdmg = 700, deathmod = 90, firemod = 0, energymod = 100, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 90},
    {name = "frost dragon hatchling", exp = 745, hp = 800, ratio = 0.931, maxdmg = 380, deathmod = 100, firemod = 0, energymod = 105, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "frost giant", exp = 150, hp = 270, ratio = 0.556, maxdmg = 200, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "frost giantess", exp = 150, hp = 275, ratio = 0.545, maxdmg = 150, deathmod = 103, firemod = 80, energymod = 110, earthmod = 100, icemod = 0, holymod = 90, physicalmod = 100},
    {name = "frost troll", exp = 23, hp = 55, ratio = 0.418, maxdmg = 20, deathmod = 115, firemod = 50, energymod = 110, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "frostfur", exp = 35, hp = 65, ratio = 0.538, maxdmg = 30, deathmod = 100, firemod = 80, energymod = 110, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "furious troll", exp = 185, hp = 245, ratio = 0.755, maxdmg = 100, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "fury", exp = 4500, hp = 4100, ratio = 1.098, maxdmg = 800, deathmod = 110, firemod = 0, energymod = 110, earthmod = 110, icemod = 70, holymod = 70, physicalmod = 110},
    {name = "fury of the emperor", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 90, energymod = 110, earthmod = 0, icemod = 50, holymod = 115, physicalmod = 110},
    {name = "gamemaster", exp = 0, hp = 1, ratio = 0.000, maxdmg = 100, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "gang member", exp = 70, hp = 295, ratio = 0.237, maxdmg = 95, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "gargoyle", exp = 150, hp = 250, ratio = 0.600, maxdmg = 65, deathmod = 99, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 60},
    {name = "gazer", exp = 90, hp = 120, ratio = 0.750, maxdmg = 50, deathmod = 100, firemod = 110, energymod = 89, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "general murius", exp = 450, hp = 550, ratio = 0.818, maxdmg = 250, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "ghastly dragon", exp = 4600, hp = 7800, ratio = 0.590, maxdmg = 1780, deathmod = 0, firemod = 90, energymod = 110, earthmod = 0, icemod = 50, holymod = 115, physicalmod = 110},
    {name = "ghazbaran", exp = 15000, hp = 60000, ratio = 0.250, maxdmg = 5775, deathmod = 99, firemod = 0, energymod = 100, earthmod = 0, icemod = 0, holymod = 101, physicalmod = 99},
    {name = "ghost", exp = 120, hp = 150, ratio = 0.800, maxdmg = 125, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 0},
    {name = "ghost rat", exp = 0, hp = 1, ratio = 0.000, maxdmg = 120, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "ghostly apparition", exp = 0, hp = 1, ratio = 0.000, maxdmg = 6, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "ghoul", exp = 85, hp = 100, ratio = 0.850, maxdmg = 97, deathmod = 0, firemod = 100, energymod = 70, earthmod = 80, icemod = 90, holymod = 125, physicalmod = 100},
    {name = "giant spider", exp = 900, hp = 1300, ratio = 0.692, maxdmg = 378, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "gladiator", exp = 90, hp = 185, ratio = 0.486, maxdmg = 90, deathmod = 101, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 90, physicalmod = 85},
    {name = "glitterscale", exp = 700, hp = 1000, ratio = 0.700, maxdmg = 0, deathmod = 100, firemod = 0, energymod = 100, earthmod = 20, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "gloombringer", exp = 0, hp = 1, ratio = 0.000, maxdmg = 3000, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "gnarlhound", exp = 60, hp = 198, ratio = 0.303, maxdmg = 70, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "gnorre chyllson", exp = 4000, hp = 7100, ratio = 0.563, maxdmg = 1100, deathmod = 100, firemod = 0, energymod = 110, earthmod = 0, icemod = 0, holymod = 99, physicalmod = 101},
    {name = "goblin", exp = 25, hp = 50, ratio = 0.500, maxdmg = 35, deathmod = 110, firemod = 100, energymod = 80, earthmod = 112, icemod = 100, holymod = 99, physicalmod = 100},
    {name = "goblin assassin", exp = 52, hp = 75, ratio = 0.693, maxdmg = 50, deathmod = 101, firemod = 100, energymod = 80, earthmod = 110, icemod = 100, holymod = 99, physicalmod = 100},
    {name = "goblin leader", exp = 75, hp = 50, ratio = 1.500, maxdmg = 95, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "goblin scavenger", exp = 37, hp = 60, ratio = 0.617, maxdmg = 75, deathmod = 110, firemod = 100, energymod = 80, earthmod = 110, icemod = 100, holymod = 99, physicalmod = 100},
    {name = "golgordan", exp = 10000, hp = 40000, ratio = 0.250, maxdmg = 3127, deathmod = 0, firemod = 101, energymod = 100, earthmod = 100, icemod = 101, holymod = 99, physicalmod = 99},
    {name = "gozzler", exp = 180, hp = 240, ratio = 0.750, maxdmg = 245, deathmod = 50, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 50, physicalmod = 105},
    {name = "grand mother foulscale", exp = 1400, hp = 1850, ratio = 0.757, maxdmg = 300, deathmod = 100, firemod = 0, energymod = 100, earthmod = 100, icemod = 105, holymod = 100, physicalmod = 100},
    {name = "grandfather tridian", exp = 1400, hp = 1800, ratio = 0.778, maxdmg = 540, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 65},
    {name = "gravelord oshuran", exp = 2400, hp = 3100, ratio = 0.774, maxdmg = 750, deathmod = 0, firemod = 100, energymod = 20, earthmod = 0, icemod = 50, holymod = 101, physicalmod = 100},
    {name = "green djinn", exp = 215, hp = 330, ratio = 0.652, maxdmg = 320, deathmod = 80, firemod = 20, energymod = 50, earthmod = 100, icemod = 110, holymod = 113, physicalmod = 80},
    {name = "green frog", exp = 0, hp = 25, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "grim reaper", exp = 5500, hp = 3900, ratio = 1.410, maxdmg = 1720, deathmod = 20, firemod = 110, energymod = 110, earthmod = 60, icemod = 35, holymod = 110, physicalmod = 80},
    {name = "grimgor guteater", exp = 670, hp = 1155, ratio = 0.580, maxdmg = 330, deathmod = 101, firemod = 0, energymod = 80, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "grorlam", exp = 2400, hp = 3000, ratio = 0.800, maxdmg = 530, deathmod = 101, firemod = 110, energymod = 80, earthmod = 0, icemod = 100, holymod = 80, physicalmod = 70},
    {name = "grynch clan goblin", exp = 4, hp = 80, ratio = 0.050, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "hacker", exp = 45, hp = 430, ratio = 0.105, maxdmg = 35, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "hairman the huge", exp = 335, hp = 600, ratio = 0.558, maxdmg = 110, deathmod = 101, firemod = 99, energymod = 99, earthmod = 99, icemod = 101, holymod = 100, physicalmod = 99},
    {name = "hand of cursed fate", exp = 5000, hp = 7500, ratio = 0.667, maxdmg = 920, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 110, holymod = 125, physicalmod = 100},
    {name = "harbinger of darkness", exp = 0, hp = 1, ratio = 0.000, maxdmg = 4066, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "hatebreeder", exp = 11000, hp = 1, ratio = 11000.000, maxdmg = 1800, deathmod = 0, firemod = 90, energymod = 110, earthmod = 0, icemod = 50, holymod = 115, physicalmod = 110},
    {name = "haunted treeling", exp = 310, hp = 450, ratio = 0.689, maxdmg = 320, deathmod = 99, firemod = 105, energymod = 100, earthmod = 0, icemod = 85, holymod = 80, physicalmod = 100},
    {name = "haunter", exp = 4000, hp = 8500, ratio = 0.471, maxdmg = 210, deathmod = 90, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "hell hole", exp = 0, hp = 1, ratio = 0.000, maxdmg = 1000, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "hellfire fighter", exp = 3900, hp = 3800, ratio = 1.026, maxdmg = 2749, deathmod = 80, firemod = 0, energymod = 75, earthmod = 100, icemod = 125, holymod = 100, physicalmod = 50},
    {name = "hellgorak", exp = 10000, hp = 30000, ratio = 0.333, maxdmg = 1800, deathmod = 2, firemod = 2, energymod = 2, earthmod = 2, icemod = 2, holymod = 2, physicalmod = 2},
    {name = "hellhound", exp = 6800, hp = 7500, ratio = 0.907, maxdmg = 3342, deathmod = 100, firemod = 0, energymod = 90, earthmod = 80, icemod = 105, holymod = 125, physicalmod = 100},
    {name = "hellspawn", exp = 2550, hp = 3500, ratio = 0.729, maxdmg = 515, deathmod = 105, firemod = 60, energymod = 90, earthmod = 20, icemod = 110, holymod = 70, physicalmod = 80},
    {name = "heoni", exp = 515, hp = 900, ratio = 0.572, maxdmg = 100, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "herald of gloom", exp = 450, hp = 450, ratio = 1.000, maxdmg = 0, deathmod = 105, firemod = 100, energymod = 105, earthmod = 100, icemod = 80, holymod = 80, physicalmod = 105},
    {name = "hero", exp = 1200, hp = 1400, ratio = 0.857, maxdmg = 360, deathmod = 120, firemod = 70, energymod = 60, earthmod = 50, icemod = 90, holymod = 50, physicalmod = 70},
    {name = "hide", exp = 240, hp = 500, ratio = 0.480, maxdmg = 144, deathmod = 100, firemod = 115, energymod = 90, earthmod = 0, icemod = 115, holymod = 100, physicalmod = 60},
    {name = "high templar cobrass", exp = 515, hp = 410, ratio = 1.256, maxdmg = 80, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 99, holymod = 100, physicalmod = 100},
    {name = "hot dog", exp = 190, hp = 505, ratio = 0.376, maxdmg = 125, deathmod = 100, firemod = 0, energymod = 100, earthmod = 100, icemod = 100, holymod = 105, physicalmod = 120},
    {name = "hunter", exp = 150, hp = 150, ratio = 1.000, maxdmg = 120, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 80, physicalmod = 110},
    {name = "husky", exp = 0, hp = 140, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "hyaena", exp = 20, hp = 60, ratio = 0.333, maxdmg = 20, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "hydra", exp = 2100, hp = 2350, ratio = 0.894, maxdmg = 750, deathmod = 100, firemod = 100, energymod = 110, earthmod = 0, icemod = 50, holymod = 70, physicalmod = 105},
    {name = "ice golem", exp = 295, hp = 385, ratio = 0.766, maxdmg = 305, deathmod = 0, firemod = 0, energymod = 120, earthmod = 100, icemod = 0, holymod = 0, physicalmod = 75},
    {name = "ice overlord", exp = 2800, hp = 4000, ratio = 0.700, maxdmg = 1408, deathmod = 100, firemod = 0, energymod = 125, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 50},
    {name = "ice witch", exp = 580, hp = 650, ratio = 0.892, maxdmg = 394, deathmod = 110, firemod = 50, energymod = 110, earthmod = 60, icemod = 0, holymod = 70, physicalmod = 100},
    {name = "incineron", exp = 3500, hp = 7000, ratio = 0.500, maxdmg = 1400, deathmod = 100, firemod = 0, energymod = 80, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "infernal frog", exp = 190, hp = 655, ratio = 0.290, maxdmg = 42, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "infernalist", exp = 4000, hp = 3650, ratio = 1.096, maxdmg = 120, deathmod = 99, firemod = 0, energymod = 0, earthmod = 5, icemod = 105, holymod = 80, physicalmod = 101},
    {name = "infernatil", exp = 85000, hp = 160000, ratio = 0.531, maxdmg = 6000, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "inky", exp = 250, hp = 600, ratio = 0.417, maxdmg = 367, deathmod = 100, firemod = 0, energymod = 105, earthmod = 10, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "insect swarm", exp = 40, hp = 50, ratio = 0.800, maxdmg = 25, deathmod = 100, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "irahsae", exp = 0, hp = 1, ratio = 0.000, maxdmg = 900, deathmod = 200, firemod = 100, energymod = 0, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "island troll", exp = 20, hp = 50, ratio = 0.400, maxdmg = 10, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "jagged earth elemental", exp = 1300, hp = 1500, ratio = 0.867, maxdmg = 750, deathmod = 55, firemod = 115, energymod = 15, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "juggernaut", exp = 8700, hp = 20000, ratio = 0.435, maxdmg = 2260, deathmod = 100, firemod = 70, energymod = 110, earthmod = 80, icemod = 90, holymod = 105, physicalmod = 50},
    {name = "killer caiman", exp = 800, hp = 1500, ratio = 0.533, maxdmg = 300, deathmod = 100, firemod = 100, energymod = 105, earthmod = 80, icemod = 90, holymod = 100, physicalmod = 95},
    {name = "killer rabbit", exp = 160, hp = 205, ratio = 0.780, maxdmg = 140, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "kitty", exp = 0, hp = 1, ratio = 0.000, maxdmg = 117, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "kongra", exp = 115, hp = 340, ratio = 0.338, maxdmg = 60, deathmod = 105, firemod = 80, energymod = 95, earthmod = 90, icemod = 115, holymod = 100, physicalmod = 100},
    {name = "kongra", exp = 0, hp = 20000, ratio = 0.000, maxdmg = 90, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "koshei the deathless", exp = 0, hp = 1, ratio = 0.000, maxdmg = 531, deathmod = 0, firemod = 110, energymod = 10, earthmod = 0, icemod = 80, holymod = 115, physicalmod = 80},
    {name = "kreebosh the exile", exp = 350, hp = 805, ratio = 0.435, maxdmg = 545, deathmod = 101, firemod = 100, energymod = 45, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "lancer beetle", exp = 275, hp = 400, ratio = 0.688, maxdmg = 246, deathmod = 50, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "larva", exp = 44, hp = 70, ratio = 0.629, maxdmg = 36, deathmod = 100, firemod = 110, energymod = 90, earthmod = 0, icemod = 105, holymod = 100, physicalmod = 100},
    {name = "latrivan", exp = 10000, hp = 25000, ratio = 0.400, maxdmg = 1800, deathmod = 0, firemod = 0, energymod = 99, earthmod = 100, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "lavahole", exp = 0, hp = 1, ratio = 0.000, maxdmg = 111, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "lersatio", exp = 2500, hp = 1600, ratio = 1.562, maxdmg = 650, deathmod = 100, firemod = 101, energymod = 100, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "lethal lissy", exp = 500, hp = 1450, ratio = 0.345, maxdmg = 160, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "leviathan", exp = 5000, hp = 6000, ratio = 0.833, maxdmg = 1471, deathmod = 99, firemod = 70, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 115},
    {name = "lich", exp = 900, hp = 880, ratio = 1.023, maxdmg = 500, deathmod = 0, firemod = 100, energymod = 20, earthmod = 0, icemod = 100, holymod = 110, physicalmod = 100},
    {name = "lion", exp = 30, hp = 80, ratio = 0.375, maxdmg = 40, deathmod = 108, firemod = 100, energymod = 100, earthmod = 80, icemod = 115, holymod = 80, physicalmod = 100},
    {name = "lizard abomination", exp = 1350, hp = 20000, ratio = 0.068, maxdmg = 1500, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 85},
    {name = "lizard chosen", exp = 2200, hp = 3050, ratio = 0.721, maxdmg = 880, deathmod = 100, firemod = 90, energymod = 80, earthmod = 0, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "lizard dragon priest", exp = 1320, hp = 1450, ratio = 0.910, maxdmg = 240, deathmod = 100, firemod = 55, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "lizard gate guardian", exp = 2000, hp = 3000, ratio = 0.667, maxdmg = 500, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "lizard high guard", exp = 1450, hp = 1800, ratio = 0.806, maxdmg = 370, deathmod = 100, firemod = 55, energymod = 100, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 95},
    {name = "lizard legionnaire", exp = 1100, hp = 1400, ratio = 0.786, maxdmg = 460, deathmod = 100, firemod = 55, energymod = 100, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "lizard magistratus", exp = 200, hp = 1, ratio = 200.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "lizard noble", exp = 250, hp = 1, ratio = 250.000, maxdmg = 330, deathmod = 100, firemod = 10, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "lizard sentinel", exp = 110, hp = 265, ratio = 0.415, maxdmg = 115, deathmod = 100, firemod = 110, energymod = 90, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "lizard snakecharmer", exp = 210, hp = 325, ratio = 0.646, maxdmg = 150, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 120},
    {name = "lizard templar", exp = 155, hp = 410, ratio = 0.378, maxdmg = 70, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "lizard zaogun", exp = 1700, hp = 2955, ratio = 0.575, maxdmg = 721, deathmod = 90, firemod = 55, energymod = 80, earthmod = 0, icemod = 85, holymod = 100, physicalmod = 95},
    {name = "lord of the elements", exp = 8000, hp = 8000, ratio = 1.000, maxdmg = 715, deathmod = 0, firemod = 70, energymod = 70, earthmod = 55, icemod = 70, holymod = 0, physicalmod = 99},
    {name = "lost soul", exp = 4000, hp = 5800, ratio = 0.690, maxdmg = 630, deathmod = 0, firemod = 0, energymod = 90, earthmod = 0, icemod = 50, holymod = 120, physicalmod = 100},
    {name = "mad scientist", exp = 205, hp = 325, ratio = 0.631, maxdmg = 127, deathmod = 105, firemod = 90, energymod = 80, earthmod = 80, icemod = 90, holymod = 80, physicalmod = 100},
    {name = "mad sheep", exp = 0, hp = 22, ratio = 0.000, maxdmg = 1, deathmod = 100, firemod = 101, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "mad technomancer", exp = 55, hp = 1800, ratio = 0.031, maxdmg = 350, deathmod = 100, firemod = 0, energymod = 105, earthmod = 0, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "madareth", exp = 10000, hp = 75000, ratio = 0.133, maxdmg = 3359, deathmod = 5, firemod = 101, energymod = 1, earthmod = 100, icemod = 99, holymod = 100, physicalmod = 100},
    {name = "magic pillar", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "magicthrower", exp = 0, hp = 1, ratio = 0.000, maxdmg = 100, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "mahrdis", exp = 3050, hp = 3900, ratio = 0.782, maxdmg = 2400, deathmod = 0, firemod = 0, energymod = 80, earthmod = 80, icemod = 110, holymod = 120, physicalmod = 100},
    {name = "mammoth", exp = 160, hp = 320, ratio = 0.500, maxdmg = 110, deathmod = 100, firemod = 110, energymod = 100, earthmod = 80, icemod = 80, holymod = 100, physicalmod = 85},
    {name = "man in the cave", exp = 770, hp = 485, ratio = 1.588, maxdmg = 157, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "marid", exp = 410, hp = 550, ratio = 0.745, maxdmg = 600, deathmod = 101, firemod = 10, energymod = 40, earthmod = 99, icemod = 101, holymod = 99, physicalmod = 100},
    {name = "marziel", exp = 3000, hp = 1900, ratio = 1.579, maxdmg = 800, deathmod = 0, firemod = 90, energymod = 80, earthmod = 0, icemod = 105, holymod = 105, physicalmod = 57},
    {name = "massacre", exp = 20000, hp = 32000, ratio = 0.625, maxdmg = 2800, deathmod = 110, firemod = 0, energymod = 100, earthmod = 100, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "massive earth elemental", exp = 950, hp = 1330, ratio = 0.714, maxdmg = 438, deathmod = 55, firemod = 115, energymod = 10, earthmod = 0, icemod = 0, holymod = 50, physicalmod = 70},
    {name = "massive energy elemental", exp = 950, hp = 1100, ratio = 0.864, maxdmg = 1050, deathmod = 99, firemod = 0, energymod = 0, earthmod = 105, icemod = 0, holymod = 75, physicalmod = 30},
    {name = "massive fire elemental", exp = 1400, hp = 1200, ratio = 1.167, maxdmg = 0, deathmod = 80, firemod = 0, energymod = 70, earthmod = 100, icemod = 115, holymod = 100, physicalmod = 60},
    {name = "massive water elemental", exp = 1100, hp = 1250, ratio = 0.880, maxdmg = 431, deathmod = 50, firemod = 0, energymod = 125, earthmod = 0, icemod = 0, holymod = 70, physicalmod = 70},
    {name = "mechanical fighter", exp = 255, hp = 420, ratio = 0.607, maxdmg = 200, deathmod = 100, firemod = 100, energymod = 50, earthmod = 0, icemod = 100, holymod = 0, physicalmod = 100},
    {name = "medusa", exp = 4050, hp = 4500, ratio = 0.900, maxdmg = 1000, deathmod = 100, firemod = 105, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "menace", exp = 4112, hp = 5960, ratio = 0.690, maxdmg = 215, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "mephiles", exp = 415, hp = 415, ratio = 1.000, maxdmg = 80, deathmod = 100, firemod = 0, energymod = 100, earthmod = 50, icemod = 110, holymod = 105, physicalmod = 110},
    {name = "mercury blob", exp = 180, hp = 150, ratio = 1.200, maxdmg = 105, deathmod = 0, firemod = 90, energymod = 100, earthmod = 35, icemod = 85, holymod = 35, physicalmod = 95},
    {name = "merikh the slaughterer", exp = 1500, hp = 2000, ratio = 0.750, maxdmg = 700, deathmod = 99, firemod = 99, energymod = 100, earthmod = 100, icemod = 101, holymod = 101, physicalmod = 100},
    {name = "merlkin", exp = 145, hp = 235, ratio = 0.617, maxdmg = 170, deathmod = 105, firemod = 80, energymod = 90, earthmod = 100, icemod = 115, holymod = 90, physicalmod = 100},
    {name = "merlkin", exp = 900, hp = 20000, ratio = 0.045, maxdmg = 10, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "midnight spawn", exp = 900, hp = 1, ratio = 900.000, maxdmg = 0, deathmod = 1, firemod = 70, energymod = 100, earthmod = 1, icemod = 110, holymod = 110, physicalmod = 70},
    {name = "midnight warrior", exp = 750, hp = 1000, ratio = 0.750, maxdmg = 250, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 85},
    {name = "mimic", exp = 0, hp = 30, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "minishabaal", exp = 4000, hp = 6000, ratio = 0.667, maxdmg = 800, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "minotaur", exp = 50, hp = 100, ratio = 0.500, maxdmg = 45, deathmod = 105, firemod = 80, energymod = 100, earthmod = 100, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "minotaur archer", exp = 65, hp = 100, ratio = 0.650, maxdmg = 100, deathmod = 101, firemod = 80, energymod = 100, earthmod = 100, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "minotaur guard", exp = 160, hp = 185, ratio = 0.865, maxdmg = 100, deathmod = 110, firemod = 80, energymod = 100, earthmod = 100, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "minotaur mage", exp = 150, hp = 155, ratio = 0.968, maxdmg = 205, deathmod = 110, firemod = 100, energymod = 80, earthmod = 80, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "monk", exp = 200, hp = 240, ratio = 0.833, maxdmg = 140, deathmod = 50, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 50, physicalmod = 110},
    {name = "monstor", exp = 575, hp = 960, ratio = 0.599, maxdmg = 248, deathmod = 100, firemod = 50, energymod = 107, earthmod = 70, icemod = 90, holymod = 103, physicalmod = 80},
    {name = "mooh'tah master", exp = 0, hp = 1, ratio = 0.000, maxdmg = 700, deathmod = 80, firemod = 70, energymod = 70, earthmod = 0, icemod = 100, holymod = 60, physicalmod = 99},
    {name = "morgaroth", exp = 15000, hp = 55000, ratio = 0.273, maxdmg = 3500, deathmod = 20, firemod = 0, energymod = 99, earthmod = 0, icemod = 105, holymod = 100, physicalmod = 99},
    {name = "morguthis", exp = 3000, hp = 4800, ratio = 0.625, maxdmg = 1900, deathmod = 0, firemod = 80, energymod = 80, earthmod = 110, icemod = 80, holymod = 120, physicalmod = 80},
    {name = "morik the gladiator", exp = 160, hp = 1235, ratio = 0.130, maxdmg = 310, deathmod = 101, firemod = 90, energymod = 90, earthmod = 90, icemod = 90, holymod = 90, physicalmod = 100},
    {name = "mr. punish", exp = 9000, hp = 22000, ratio = 0.409, maxdmg = 1807, deathmod = 110, firemod = 0, energymod = 0, earthmod = 105, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "muddy earth elemental", exp = 450, hp = 650, ratio = 0.692, maxdmg = 450, deathmod = 60, firemod = 115, energymod = 15, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "mummy", exp = 150, hp = 240, ratio = 0.625, maxdmg = 129, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 80, holymod = 125, physicalmod = 100},
    {name = "munster", exp = 35, hp = 58, ratio = 0.603, maxdmg = 15, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "mutated bat", exp = 615, hp = 900, ratio = 0.683, maxdmg = 462, deathmod = 0, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "mutated human", exp = 150, hp = 240, ratio = 0.625, maxdmg = 164, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 80, holymod = 125, physicalmod = 100},
    {name = "mutated rat", exp = 450, hp = 550, ratio = 0.818, maxdmg = 305, deathmod = 0, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "mutated tiger", exp = 750, hp = 1100, ratio = 0.682, maxdmg = 275, deathmod = 105, firemod = 80, energymod = 80, earthmod = 20, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "mutated zalamon", exp = 0, hp = 25000, ratio = 0.000, maxdmg = 1200, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 90, holymod = 100, physicalmod = 95},
    {name = "necromancer", exp = 580, hp = 580, ratio = 1.000, maxdmg = 260, deathmod = 50, firemod = 105, energymod = 80, earthmod = 0, icemod = 100, holymod = 105, physicalmod = 105},
    {name = "necropharus", exp = 1050, hp = 750, ratio = 1.400, maxdmg = 300, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "nightmare", exp = 2150, hp = 2700, ratio = 0.796, maxdmg = 750, deathmod = 0, firemod = 80, energymod = 80, earthmod = 0, icemod = 90, holymod = 125, physicalmod = 100},
    {name = "nightmare scion", exp = 1350, hp = 1400, ratio = 0.964, maxdmg = 420, deathmod = 0, firemod = 80, energymod = 80, earthmod = 0, icemod = 90, holymod = 125, physicalmod = 100},
    {name = "nightslayer", exp = 250, hp = 400, ratio = 0.625, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 100, earthmod = 100, icemod = 110, holymod = 100, physicalmod = 105},
    {name = "nightstalker", exp = 500, hp = 700, ratio = 0.714, maxdmg = 260, deathmod = 105, firemod = 100, energymod = 105, earthmod = 100, icemod = 80, holymod = 80, physicalmod = 105},
    {name = "nomad", exp = 60, hp = 160, ratio = 0.375, maxdmg = 80, deathmod = 120, firemod = 80, energymod = 100, earthmod = 100, icemod = 110, holymod = 80, physicalmod = 110},
    {name = "norgle glacierbeard", exp = 2100, hp = 4300, ratio = 0.488, maxdmg = 400, deathmod = 101, firemod = 100, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "novice of the cult", exp = 100, hp = 285, ratio = 0.351, maxdmg = 270, deathmod = 108, firemod = 105, energymod = 108, earthmod = 90, icemod = 90, holymod = 90, physicalmod = 120},
    {name = "omruc", exp = 2950, hp = 4300, ratio = 0.686, maxdmg = 1619, deathmod = 0, firemod = 80, energymod = 105, earthmod = 80, icemod = 105, holymod = 110, physicalmod = 100},
    {name = "orc", exp = 25, hp = 70, ratio = 0.357, maxdmg = 35, deathmod = 101, firemod = 100, energymod = 80, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "orc berserker", exp = 195, hp = 210, ratio = 0.929, maxdmg = 200, deathmod = 110, firemod = 100, energymod = 85, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "orc leader", exp = 270, hp = 450, ratio = 0.600, maxdmg = 255, deathmod = 101, firemod = 0, energymod = 80, earthmod = 110, icemod = 100, holymod = 80, physicalmod = 100},
    {name = "orc marauder", exp = 205, hp = 235, ratio = 0.872, maxdmg = 80, deathmod = 100, firemod = 100, energymod = 100, earthmod = 101, icemod = 100, holymod = 99, physicalmod = 100},
    {name = "orc rider", exp = 110, hp = 180, ratio = 0.611, maxdmg = 120, deathmod = 101, firemod = 100, energymod = 80, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "orc shaman", exp = 110, hp = 115, ratio = 0.957, maxdmg = 81, deathmod = 105, firemod = 100, energymod = 50, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "orc spearman", exp = 38, hp = 105, ratio = 0.362, maxdmg = 55, deathmod = 110, firemod = 100, energymod = 80, earthmod = 110, icemod = 100, holymod = 80, physicalmod = 100},
    {name = "orc warlord", exp = 670, hp = 950, ratio = 0.705, maxdmg = 450, deathmod = 105, firemod = 20, energymod = 80, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "orc warrior", exp = 50, hp = 125, ratio = 0.400, maxdmg = 60, deathmod = 110, firemod = 100, energymod = 70, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "orchid frog", exp = 20, hp = 60, ratio = 0.333, maxdmg = 24, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "orcus the cruel", exp = 280, hp = 480, ratio = 0.583, maxdmg = 250, deathmod = 100, firemod = 0, energymod = 80, earthmod = 120, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "orshabaal", exp = 10000, hp = 20500, ratio = 0.488, maxdmg = 5000, deathmod = 50, firemod = 0, energymod = 100, earthmod = 0, icemod = 101, holymod = 101, physicalmod = 100},
    {name = "overcharged energy element", exp = 1300, hp = 1750, ratio = 0.743, maxdmg = 895, deathmod = 100, firemod = 0, energymod = 0, earthmod = 120, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "panda", exp = 23, hp = 80, ratio = 0.287, maxdmg = 16, deathmod = 100, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "parrot", exp = 0, hp = 25, ratio = 0.000, maxdmg = 5, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "penguin", exp = 1, hp = 33, ratio = 0.030, maxdmg = 3, deathmod = 100, firemod = 100, energymod = 101, earthmod = 100, icemod = 99, holymod = 100, physicalmod = 100},
    {name = "phantasm", exp = 4400, hp = 3950, ratio = 1.114, maxdmg = 800, deathmod = 0, firemod = 110, energymod = 110, earthmod = 80, icemod = 80, holymod = 110, physicalmod = 0},
    {name = "phrodomo", exp = 44000, hp = 80000, ratio = 0.550, maxdmg = 2000, deathmod = 70, firemod = 100, energymod = 0, earthmod = 0, icemod = 50, holymod = 100, physicalmod = 80},
    {name = "pig", exp = 0, hp = 25, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "pillar", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "pirate buccaneer", exp = 250, hp = 425, ratio = 0.588, maxdmg = 260, deathmod = 101, firemod = 105, energymod = 105, earthmod = 90, icemod = 105, holymod = 90, physicalmod = 110},
    {name = "pirate corsair", exp = 350, hp = 675, ratio = 0.519, maxdmg = 320, deathmod = 101, firemod = 110, energymod = 100, earthmod = 80, icemod = 105, holymod = 90, physicalmod = 100},
    {name = "pirate cutthroat", exp = 175, hp = 325, ratio = 0.538, maxdmg = 271, deathmod = 101, firemod = 110, energymod = 100, earthmod = 90, icemod = 105, holymod = 80, physicalmod = 100},
    {name = "pirate ghost", exp = 250, hp = 275, ratio = 0.909, maxdmg = 240, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 125, physicalmod = 0},
    {name = "pirate marauder", exp = 125, hp = 210, ratio = 0.595, maxdmg = 180, deathmod = 105, firemod = 110, energymod = 103, earthmod = 90, icemod = 100, holymod = 80, physicalmod = 100},
    {name = "pirate skeleton", exp = 85, hp = 190, ratio = 0.447, maxdmg = 50, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 125, physicalmod = 100},
    {name = "plaguesmith", exp = 4500, hp = 8250, ratio = 0.545, maxdmg = 890, deathmod = 99, firemod = 70, energymod = 110, earthmod = 0, icemod = 80, holymod = 110, physicalmod = 100},
    {name = "plaguethrower", exp = 0, hp = 1, ratio = 0.000, maxdmg = 100, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "poacher", exp = 70, hp = 90, ratio = 0.778, maxdmg = 70, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "poison spider", exp = 22, hp = 26, ratio = 0.846, maxdmg = 22, deathmod = 100, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "polar bear", exp = 28, hp = 85, ratio = 0.329, maxdmg = 30, deathmod = 110, firemod = 99, energymod = 101, earthmod = 100, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "priestess", exp = 420, hp = 390, ratio = 1.077, maxdmg = 195, deathmod = 99, firemod = 60, energymod = 100, earthmod = 30, icemod = 100, holymod = 110, physicalmod = 105},
    {name = "primitive", exp = 45, hp = 200, ratio = 0.225, maxdmg = 90, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "pythius the rotten", exp = 7000, hp = 9000, ratio = 0.778, maxdmg = 1250, deathmod = 0, firemod = 100, energymod = 0, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "quara constrictor", exp = 250, hp = 450, ratio = 0.556, maxdmg = 256, deathmod = 100, firemod = 0, energymod = 125, earthmod = 110, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "quara constrictor scout", exp = 200, hp = 450, ratio = 0.444, maxdmg = 205, deathmod = 100, firemod = 0, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 105},
    {name = "quara hydromancer", exp = 800, hp = 1100, ratio = 0.727, maxdmg = 825, deathmod = 100, firemod = 0, energymod = 125, earthmod = 110, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "quara hydromancer scout", exp = 800, hp = 1100, ratio = 0.727, maxdmg = 670, deathmod = 100, firemod = 0, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "quara mantassin", exp = 400, hp = 800, ratio = 0.500, maxdmg = 140, deathmod = 100, firemod = 0, energymod = 125, earthmod = 110, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "quara mantassin scout", exp = 100, hp = 220, ratio = 0.455, maxdmg = 110, deathmod = 100, firemod = 0, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "quara pincher", exp = 1200, hp = 1800, ratio = 0.667, maxdmg = 340, deathmod = 100, firemod = 0, energymod = 125, earthmod = 110, icemod = 0, holymod = 100, physicalmod = 90},
    {name = "quara pincher scout", exp = 600, hp = 775, ratio = 0.774, maxdmg = 240, deathmod = 100, firemod = 0, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 90},
    {name = "quara predator", exp = 1600, hp = 2200, ratio = 0.727, maxdmg = 470, deathmod = 100, firemod = 0, energymod = 125, earthmod = 110, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "quara predator scout", exp = 400, hp = 890, ratio = 0.449, maxdmg = 190, deathmod = 100, firemod = 0, energymod = 110, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "rabbit", exp = 0, hp = 15, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rahemos", exp = 3100, hp = 3700, ratio = 0.838, maxdmg = 1850, deathmod = 0, firemod = 5, energymod = 5, earthmod = 0, icemod = 0, holymod = 101, physicalmod = 140},
    {name = "rat", exp = 5, hp = 20, ratio = 0.250, maxdmg = 8, deathmod = 110, firemod = 100, energymod = 100, earthmod = 75, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "renegade orc", exp = 270, hp = 450, ratio = 0.600, maxdmg = 180, deathmod = 100, firemod = 0, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rift brood", exp = 1600, hp = 3000, ratio = 0.533, maxdmg = 270, deathmod = 120, firemod = 0, energymod = 100, earthmod = 100, icemod = 0, holymod = 85, physicalmod = 99},
    {name = "rift lord", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rift phantom", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rift scythe", exp = 2000, hp = 3600, ratio = 0.556, maxdmg = 1000, deathmod = 99, firemod = 110, energymod = 110, earthmod = 60, icemod = 35, holymod = 110, physicalmod = 99},
    {name = "rift worm", exp = 1195, hp = 2800, ratio = 0.427, maxdmg = 0, deathmod = 100, firemod = 105, energymod = 100, earthmod = 125, icemod = 105, holymod = 105, physicalmod = 100},
    {name = "roaring water elemental", exp = 1300, hp = 1750, ratio = 0.743, maxdmg = 762, deathmod = 99, firemod = 0, energymod = 100, earthmod = 0, icemod = 0, holymod = 60, physicalmod = 55},
    {name = "rocko", exp = 3400, hp = 10000, ratio = 0.340, maxdmg = 600, deathmod = 0, firemod = 70, energymod = 75, earthmod = 0, icemod = 80, holymod = 90, physicalmod = 85},
    {name = "rocky", exp = 190, hp = 390, ratio = 0.487, maxdmg = 80, deathmod = 100, firemod = 101, energymod = 0, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "ron the ripper", exp = 500, hp = 1500, ratio = 0.333, maxdmg = 410, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rottie the rotworm", exp = 40, hp = 65, ratio = 0.615, maxdmg = 25, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rotworm", exp = 40, hp = 65, ratio = 0.615, maxdmg = 40, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rotworm queen", exp = 75, hp = 105, ratio = 0.714, maxdmg = 80, deathmod = 100, firemod = 120, energymod = 100, earthmod = 60, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "rukor zad", exp = 380, hp = 380, ratio = 1.000, maxdmg = 370, deathmod = 95, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 99},
    {name = "sandcrawler", exp = 20, hp = 30, ratio = 0.667, maxdmg = 3, deathmod = 100, firemod = 101, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "scarab", exp = 120, hp = 320, ratio = 0.375, maxdmg = 115, deathmod = 100, firemod = 118, energymod = 90, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 85},
    {name = "scorn of the emperor", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 90, energymod = 110, earthmod = 0, icemod = 50, holymod = 115, physicalmod = 110},
    {name = "scorpion", exp = 45, hp = 45, ratio = 1.000, maxdmg = 67, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "sea serpent", exp = 2300, hp = 1950, ratio = 1.179, maxdmg = 800, deathmod = 90, firemod = 70, energymod = 105, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 115},
    {name = "seagull", exp = 0, hp = 25, ratio = 0.000, maxdmg = 3, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "serpent spawn", exp = 3050, hp = 3000, ratio = 1.017, maxdmg = 1400, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "servant golem", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "shadow hound", exp = 600, hp = 555, ratio = 1.081, maxdmg = 155, deathmod = 0, firemod = 110, energymod = 90, earthmod = 0, icemod = 110, holymod = 70, physicalmod = 120},
    {name = "shadow of boreth", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "shadow of lersatio", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "shadow of marziel", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "shard of corruption", exp = 5, hp = 600, ratio = 0.008, maxdmg = 200, deathmod = 0, firemod = 70, energymod = 75, earthmod = 0, icemod = 85, holymod = 100, physicalmod = 40},
    {name = "shardhead", exp = 650, hp = 800, ratio = 0.812, maxdmg = 300, deathmod = 0, firemod = 100, energymod = 120, earthmod = 100, icemod = 100, holymod = 0, physicalmod = 100},
    {name = "sharptooth", exp = 1600, hp = 2500, ratio = 0.640, maxdmg = 500, deathmod = 100, firemod = 0, energymod = 105, earthmod = 20, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "sheep", exp = 0, hp = 20, ratio = 0.000, maxdmg = 1, deathmod = 100, firemod = 101, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "shredderthrower", exp = 0, hp = 1, ratio = 0.000, maxdmg = 110, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "sibang", exp = 105, hp = 225, ratio = 0.467, maxdmg = 95, deathmod = 105, firemod = 75, energymod = 100, earthmod = 100, icemod = 115, holymod = 90, physicalmod = 100},
    {name = "silver rabbit", exp = 0, hp = 15, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "sir valorcrest", exp = 1800, hp = 1600, ratio = 1.125, maxdmg = 670, deathmod = 0, firemod = 101, energymod = 100, earthmod = 100, icemod = 100, holymod = 105, physicalmod = 45},
    {name = "skeleton", exp = 35, hp = 50, ratio = 0.700, maxdmg = 30, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "skeleton warrior", exp = 45, hp = 65, ratio = 0.692, maxdmg = 43, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "skunk", exp = 3, hp = 20, ratio = 0.150, maxdmg = 8, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "slick water elemental", exp = 450, hp = 550, ratio = 0.818, maxdmg = 542, deathmod = 99, firemod = 0, energymod = 100, earthmod = 0, icemod = 0, holymod = 60, physicalmod = 55},
    {name = "slim", exp = 580, hp = 1025, ratio = 0.566, maxdmg = 250, deathmod = 0, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "slime", exp = 160, hp = 150, ratio = 1.067, maxdmg = 107, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "slime puddle", exp = 0, hp = 1, ratio = 0.000, maxdmg = 120, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "smuggler", exp = 48, hp = 130, ratio = 0.369, maxdmg = 60, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 105},
    {name = "smuggler baron silvertoe", exp = 170, hp = 280, ratio = 0.607, maxdmg = 41, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "snake", exp = 10, hp = 15, ratio = 0.667, maxdmg = 9, deathmod = 100, firemod = 110, energymod = 80, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "snake god essence", exp = 1350, hp = 20000, ratio = 0.068, maxdmg = 1000, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 90},
    {name = "snake thing", exp = 4600, hp = 20000, ratio = 0.230, maxdmg = 1000, deathmod = 100, firemod = 110, energymod = 110, earthmod = 0, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "son of verminor", exp = 5900, hp = 8500, ratio = 0.694, maxdmg = 1000, deathmod = 100, firemod = 90, energymod = 80, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "souleater", exp = 1300, hp = 1100, ratio = 1.182, maxdmg = 480, deathmod = 0, firemod = 110, energymod = 110, earthmod = 100, icemod = 50, holymod = 110, physicalmod = 30},
    {name = "spawn of despair", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 60, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "spawn of devovorga", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "spectral scum", exp = 0, hp = 1, ratio = 0.000, maxdmg = 120, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "spectre", exp = 2100, hp = 1350, ratio = 1.556, maxdmg = 820, deathmod = 0, firemod = 108, energymod = 108, earthmod = 0, icemod = 99, holymod = 100, physicalmod = 10},
    {name = "spider", exp = 12, hp = 20, ratio = 0.600, maxdmg = 25, deathmod = 100, firemod = 101, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "spirit of earth", exp = 800, hp = 1294, ratio = 0.618, maxdmg = 640, deathmod = 100, firemod = 110, energymod = 50, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "spirit of fire", exp = 950, hp = 2210, ratio = 0.430, maxdmg = 640, deathmod = 100, firemod = 0, energymod = 80, earthmod = 100, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "spirit of light", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "spirit of water", exp = 850, hp = 1517, ratio = 0.560, maxdmg = 995, deathmod = 100, firemod = 0, energymod = 110, earthmod = 100, icemod = 0, holymod = 50, physicalmod = 70},
    {name = "spit nettle", exp = 20, hp = 150, ratio = 0.133, maxdmg = 45, deathmod = 100, firemod = 110, energymod = 0, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "spite of the emperor", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 90, energymod = 110, earthmod = 0, icemod = 50, holymod = 115, physicalmod = 110},
    {name = "splasher", exp = 500, hp = 1000, ratio = 0.500, maxdmg = 808, deathmod = 100, firemod = 0, energymod = 125, earthmod = 115, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "squirrel", exp = 0, hp = 20, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "stalker", exp = 90, hp = 120, ratio = 0.750, maxdmg = 100, deathmod = 99, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 105, physicalmod = 120},
    {name = "stampor", exp = 780, hp = 1200, ratio = 0.650, maxdmg = 350, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "stone golem", exp = 160, hp = 270, ratio = 0.593, maxdmg = 110, deathmod = 80, firemod = 80, energymod = 85, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 80},
    {name = "stonecracker", exp = 3500, hp = 5500, ratio = 0.636, maxdmg = 840, deathmod = 100, firemod = 100, energymod = 70, earthmod = 25, icemod = 100, holymod = 99, physicalmod = 99},
    {name = "svoren the mad", exp = 3000, hp = 6300, ratio = 0.476, maxdmg = 550, deathmod = 100, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "swamp troll", exp = 25, hp = 55, ratio = 0.455, maxdmg = 14, deathmod = 100, firemod = 101, energymod = 100, earthmod = 99, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "tarantula", exp = 120, hp = 225, ratio = 0.533, maxdmg = 90, deathmod = 100, firemod = 115, energymod = 90, earthmod = 0, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "target dummy", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 5, firemod = 5, energymod = 5, earthmod = 5, icemod = 5, holymod = 5, physicalmod = 30},
    {name = "teleskor", exp = 70, hp = 80, ratio = 0.875, maxdmg = 30, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "teneshpar", exp = 0, hp = 1, ratio = 0.000, maxdmg = 800, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 0},
    {name = "terramite", exp = 160, hp = 365, ratio = 0.438, maxdmg = 116, deathmod = 100, firemod = 110, energymod = 105, earthmod = 80, icemod = 100, holymod = 100, physicalmod = 95},
    {name = "terror bird", exp = 150, hp = 300, ratio = 0.500, maxdmg = 90, deathmod = 105, firemod = 110, energymod = 80, earthmod = 110, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "thalas", exp = 2950, hp = 4100, ratio = 0.720, maxdmg = 1400, deathmod = 0, firemod = 110, energymod = 80, earthmod = 0, icemod = 110, holymod = 120, physicalmod = 100},
    {name = "the abomination", exp = 0, hp = 1, ratio = 0.000, maxdmg = 1300, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the axeorcist", exp = 4005, hp = 5100, ratio = 0.785, maxdmg = 706, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the big bad one", exp = 170, hp = 300, ratio = 0.567, maxdmg = 100, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the blightfather", exp = 600, hp = 400, ratio = 1.500, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the bloodtusk", exp = 300, hp = 600, ratio = 0.500, maxdmg = 120, deathmod = 100, firemod = 110, energymod = 100, earthmod = 85, icemod = 110, holymod = 100, physicalmod = 100},
    {name = "the collector", exp = 100, hp = 340, ratio = 0.294, maxdmg = 46, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "the count", exp = 450, hp = 1250, ratio = 0.360, maxdmg = 500, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 40},
    {name = "the dark dancer", exp = 435, hp = 855, ratio = 0.509, maxdmg = 90, deathmod = 99, firemod = 60, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the dreadorian", exp = 4000, hp = 1, ratio = 4000.000, maxdmg = 388, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the evil eye", exp = 750, hp = 1200, ratio = 0.625, maxdmg = 1169, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "the frog prince", exp = 1, hp = 55, ratio = 0.018, maxdmg = 1, deathmod = 100, firemod = 90, energymod = 15, earthmod = 100, icemod = 10, holymod = 100, physicalmod = 100},
    {name = "the hag", exp = 510, hp = 935, ratio = 0.545, maxdmg = 100, deathmod = 100, firemod = 70, energymod = 90, earthmod = 100, icemod = 99, holymod = 100, physicalmod = 100},
    {name = "the hairy one", exp = 115, hp = 325, ratio = 0.354, maxdmg = 70, deathmod = 100, firemod = 120, energymod = 95, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the halloween hare", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "the handmaiden", exp = 7500, hp = 1, ratio = 7500.000, maxdmg = 2020, deathmod = 100, firemod = 0, energymod = 85, earthmod = 0, icemod = 85, holymod = 110, physicalmod = 100},
    {name = "the horned fox", exp = 300, hp = 265, ratio = 1.132, maxdmg = 120, deathmod = 101, firemod = 100, energymod = 100, earthmod = 100, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "the imperor", exp = 8000, hp = 15000, ratio = 0.533, maxdmg = 2000, deathmod = 100, firemod = 0, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the keeper", exp = 3205, hp = 25000, ratio = 0.128, maxdmg = 1400, deathmod = 50, firemod = 110, energymod = 110, earthmod = 0, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "the many", exp = 4000, hp = 1, ratio = 4000.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the masked marauder", exp = 3500, hp = 6800, ratio = 0.515, maxdmg = 930, deathmod = 100, firemod = 0, energymod = 70, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "the mutated pumpkin", exp = 35000, hp = 550000, ratio = 0.064, maxdmg = 300, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the noxious spawn", exp = 6000, hp = 9500, ratio = 0.632, maxdmg = 1350, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the obliverator", exp = 6000, hp = 9500, ratio = 0.632, maxdmg = 1000, deathmod = 99, firemod = 0, energymod = 50, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "the old whopper", exp = 750, hp = 785, ratio = 0.955, maxdmg = 175, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the old widow", exp = 4200, hp = 3200, ratio = 1.312, maxdmg = 1050, deathmod = 100, firemod = 80, energymod = 90, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 80},
    {name = "the pit lord", exp = 2500, hp = 4500, ratio = 0.556, maxdmg = 568, deathmod = 100, firemod = 100, energymod = 100, earthmod = 99, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "the plasmother", exp = 8300, hp = 1, ratio = 8300.000, maxdmg = 1000, deathmod = 110, firemod = 100, energymod = 90, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the ruthless herald", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 0, energymod = 0, earthmod = 0, icemod = 0, holymod = 0, physicalmod = 0},
    {name = "the snapper", exp = 150, hp = 300, ratio = 0.500, maxdmg = 60, deathmod = 100, firemod = 110, energymod = 105, earthmod = 85, icemod = 90, holymod = 100, physicalmod = 105},
    {name = "the voice of ruin", exp = 3900, hp = 5500, ratio = 0.709, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "the weakened count", exp = 450, hp = 740, ratio = 0.608, maxdmg = 283, deathmod = 0, firemod = 101, energymod = 100, earthmod = 0, icemod = 100, holymod = 101, physicalmod = 99},
    {name = "thief", exp = 5, hp = 60, ratio = 0.083, maxdmg = 32, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "thieving squirrel", exp = 0, hp = 55, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "thornback tortoise", exp = 150, hp = 300, ratio = 0.500, maxdmg = 112, deathmod = 100, firemod = 110, energymod = 100, earthmod = 80, icemod = 80, holymod = 100, physicalmod = 55},
    {name = "thul", exp = 2700, hp = 2950, ratio = 0.915, maxdmg = 302, deathmod = 100, firemod = 100, energymod = 101, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "tibia bug", exp = 50, hp = 270, ratio = 0.185, maxdmg = 70, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "tiger", exp = 40, hp = 75, ratio = 0.533, maxdmg = 40, deathmod = 110, firemod = 100, energymod = 100, earthmod = 100, icemod = 101, holymod = 100, physicalmod = 100},
    {name = "tiquandas revenge", exp = 2635, hp = 1800, ratio = 1.464, maxdmg = 910, deathmod = 99, firemod = 101, energymod = 100, earthmod = 0, icemod = 99, holymod = 100, physicalmod = 99},
    {name = "tirecz", exp = 6000, hp = 25000, ratio = 0.240, maxdmg = 1200, deathmod = 70, firemod = 50, energymod = 70, earthmod = 70, icemod = 70, holymod = 70, physicalmod = 90},
    {name = "toad", exp = 60, hp = 135, ratio = 0.444, maxdmg = 48, deathmod = 100, firemod = 110, energymod = 100, earthmod = 80, icemod = 80, holymod = 100, physicalmod = 100},
    {name = "tormented ghost", exp = 5, hp = 210, ratio = 0.024, maxdmg = 170, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 0},
    {name = "tortoise", exp = 90, hp = 185, ratio = 0.486, maxdmg = 50, deathmod = 100, firemod = 110, energymod = 100, earthmod = 80, icemod = 80, holymod = 100, physicalmod = 65},
    {name = "tortoise", exp = 0, hp = 1, ratio = 0.000, maxdmg = 100, deathmod = 100, firemod = 110, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "tremorak", exp = 1300, hp = 10000, ratio = 0.130, maxdmg = 660, deathmod = 65, firemod = 115, energymod = 15, earthmod = 0, icemod = 80, holymod = 50, physicalmod = 50},
    {name = "troll", exp = 20, hp = 50, ratio = 0.400, maxdmg = 24, deathmod = 110, firemod = 100, energymod = 75, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "troll champion", exp = 40, hp = 75, ratio = 0.533, maxdmg = 35, deathmod = 110, firemod = 100, energymod = 85, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "troll legionnaire", exp = 140, hp = 210, ratio = 0.667, maxdmg = 170, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "undead dragon", exp = 7200, hp = 8350, ratio = 0.862, maxdmg = 1975, deathmod = 0, firemod = 0, energymod = 100, earthmod = 0, icemod = 50, holymod = 125, physicalmod = 95},
    {name = "undead gladiator", exp = 800, hp = 1000, ratio = 0.800, maxdmg = 385, deathmod = 101, firemod = 20, energymod = 80, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "undead jester", exp = 5, hp = 355, ratio = 0.014, maxdmg = 3, deathmod = 0, firemod = 80, energymod = 90, earthmod = 0, icemod = 70, holymod = 120, physicalmod = 100},
    {name = "undead mine worker", exp = 45, hp = 65, ratio = 0.692, maxdmg = 33, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
    {name = "undead minion", exp = 550, hp = 850, ratio = 0.647, maxdmg = 560, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "undead prospector", exp = 85, hp = 100, ratio = 0.850, maxdmg = 50, deathmod = 0, firemod = 100, energymod = 70, earthmod = 80, icemod = 90, holymod = 125, physicalmod = 100},
    {name = "ungreez", exp = 500, hp = 8200, ratio = 0.061, maxdmg = 1500, deathmod = 80, firemod = 0, energymod = 45, earthmod = 40, icemod = 105, holymod = 105, physicalmod = 70},
    {name = "ushuriel", exp = 10000, hp = 40000, ratio = 0.250, maxdmg = 2600, deathmod = 0, firemod = 70, energymod = 70, earthmod = 70, icemod = 70, holymod = 75, physicalmod = 50},
    {name = "valkyrie", exp = 85, hp = 190, ratio = 0.447, maxdmg = 120, deathmod = 101, firemod = 90, energymod = 100, earthmod = 100, icemod = 90, holymod = 99, physicalmod = 101},
    {name = "vampire", exp = 305, hp = 475, ratio = 0.642, maxdmg = 350, deathmod = 0, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 125, physicalmod = 65},
    {name = "vampire bride", exp = 1050, hp = 1200, ratio = 0.875, maxdmg = 570, deathmod = 0, firemod = 110, energymod = 90, earthmod = 80, icemod = 80, holymod = 110, physicalmod = 100},
    {name = "vampire pig", exp = 165, hp = 305, ratio = 0.541, maxdmg = 190, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 90},
    {name = "vashresamun", exp = 2950, hp = 4000, ratio = 0.738, maxdmg = 1300, deathmod = 0, firemod = 80, energymod = 80, earthmod = 80, icemod = 80, holymod = 110, physicalmod = 100},
    {name = "verminor", exp = 80000, hp = 160000, ratio = 0.500, maxdmg = 601000, deathmod = 100, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "vulnerable cocoon", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "wailing widow", exp = 450, hp = 850, ratio = 0.529, maxdmg = 260, deathmod = 0, firemod = 101, energymod = 100, earthmod = 0, icemod = 100, holymod = 99, physicalmod = 100},
    {name = "war golem", exp = 2750, hp = 4300, ratio = 0.640, maxdmg = 800, deathmod = 75, firemod = 85, energymod = 95, earthmod = 50, icemod = 70, holymod = 50, physicalmod = 75},
    {name = "war wolf", exp = 55, hp = 140, ratio = 0.393, maxdmg = 50, deathmod = 101, firemod = 100, energymod = 100, earthmod = 80, icemod = 110, holymod = 90, physicalmod = 100},
    {name = "warlock", exp = 4000, hp = 3500, ratio = 1.143, maxdmg = 810, deathmod = 100, firemod = 0, energymod = 0, earthmod = 5, icemod = 0, holymod = 101, physicalmod = 101},
    {name = "warlord ruzad", exp = 1700, hp = 2500, ratio = 0.680, maxdmg = 0, deathmod = 110, firemod = 20, energymod = 99, earthmod = 110, icemod = 100, holymod = 90, physicalmod = 100},
    {name = "wasp", exp = 24, hp = 35, ratio = 0.686, maxdmg = 20, deathmod = 100, firemod = 110, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "water elemental", exp = 650, hp = 550, ratio = 1.182, maxdmg = 560, deathmod = 50, firemod = 0, energymod = 125, earthmod = 0, icemod = 0, holymod = 50, physicalmod = 50},
    {name = "weak eclipse knight", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "weak gloombringer", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "weak harbinger of darkness", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "weak spawn of despair", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 100, firemod = 60, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "webster", exp = 1200, hp = 1750, ratio = 0.686, maxdmg = 270, deathmod = 100, firemod = 100, energymod = 101, earthmod = 100, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "werewolf", exp = 1900, hp = 1955, ratio = 0.972, maxdmg = 515, deathmod = 99, firemod = 105, energymod = 95, earthmod = 35, icemod = 105, holymod = 105, physicalmod = 90},
    {name = "wild warrior", exp = 60, hp = 135, ratio = 0.444, maxdmg = 70, deathmod = 105, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 90, physicalmod = 105},
    {name = "winter wolf", exp = 20, hp = 30, ratio = 0.667, maxdmg = 20, deathmod = 101, firemod = 90, energymod = 101, earthmod = 100, icemod = 80, holymod = 99, physicalmod = 100},
    {name = "wisp", exp = 0, hp = 115, ratio = 0.000, maxdmg = 7, deathmod = 0, firemod = 100, energymod = 70, earthmod = 10, icemod = 100, holymod = 100, physicalmod = 35},
    {name = "witch", exp = 120, hp = 300, ratio = 0.400, maxdmg = 115, deathmod = 105, firemod = 100, energymod = 0, earthmod = 80, icemod = 100, holymod = 100, physicalmod = 110},
    {name = "wolf", exp = 18, hp = 25, ratio = 0.720, maxdmg = 19, deathmod = 101, firemod = 100, energymod = 100, earthmod = 99, icemod = 101, holymod = 99, physicalmod = 100},
    {name = "worker golem", exp = 1250, hp = 1470, ratio = 0.850, maxdmg = 361, deathmod = 90, firemod = 100, energymod = 105, earthmod = 50, icemod = 90, holymod = 50, physicalmod = 90},
    {name = "wrath of the emperor", exp = 0, hp = 1, ratio = 0.000, maxdmg = 0, deathmod = 0, firemod = 90, energymod = 110, earthmod = 0, icemod = 50, holymod = 115, physicalmod = 105},
    {name = "wyrm", exp = 1550, hp = 1825, ratio = 0.849, maxdmg = 500, deathmod = 105, firemod = 80, energymod = 0, earthmod = 25, icemod = 105, holymod = 100, physicalmod = 100},
    {name = "wyvern", exp = 515, hp = 795, ratio = 0.648, maxdmg = 140, deathmod = 100, firemod = 100, energymod = 80, earthmod = 0, icemod = 90, holymod = 100, physicalmod = 100},
    {name = "xenia", exp = 255, hp = 200, ratio = 1.275, maxdmg = 50, deathmod = 100, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "yaga the crone", exp = 375, hp = 620, ratio = 0.605, maxdmg = 60, deathmod = 105, firemod = 100, energymod = 0, earthmod = 99, icemod = 100, holymod = 100, physicalmod = 101},
    {name = "yakchal", exp = 4400, hp = 5000, ratio = 0.880, maxdmg = 1000, deathmod = 100, firemod = 100, energymod = 105, earthmod = 100, icemod = 100, holymod = 50, physicalmod = 100},
    {name = "yalahari", exp = 5, hp = 150, ratio = 0.033, maxdmg = 0, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 0},
    {name = "yeti", exp = 460, hp = 950, ratio = 0.484, maxdmg = 555, deathmod = 100, firemod = 100, energymod = 100, earthmod = 101, icemod = 100, holymod = 100, physicalmod = 100},
    {name = "young sea serpent", exp = 1000, hp = 1050, ratio = 0.952, maxdmg = 700, deathmod = 115, firemod = 70, energymod = 110, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 115},
    {name = "zarabustor", exp = 8000, hp = 5100, ratio = 1.569, maxdmg = 1800, deathmod = 100, firemod = 0, energymod = 0, earthmod = 10, icemod = 0, holymod = 101, physicalmod = 101},
    {name = "zevelon duskbringer", exp = 1800, hp = 1400, ratio = 1.286, maxdmg = 1000, deathmod = 0, firemod = 100, energymod = 100, earthmod = 0, icemod = 100, holymod = 100, physicalmod = 50},
    {name = "zombie", exp = 280, hp = 500, ratio = 0.560, maxdmg = 203, deathmod = 0, firemod = 50, energymod = 0, earthmod = 0, icemod = 0, holymod = 100, physicalmod = 100},
    {name = "zoralurk", exp = 0, hp = 1, ratio = 0.000, maxdmg = 2587, deathmod = 10, firemod = 0, energymod = 40, earthmod = 20, icemod = 50, holymod = 60, physicalmod = 40},
    {name = "zugurosh", exp = 10000, hp = 95000, ratio = 0.105, maxdmg = 1866, deathmod = 0, firemod = 70, energymod = 80, earthmod = 60, icemod = 75, holymod = 70, physicalmod = 100},
    {name = "zulazza the corruptor", exp = 9800, hp = 28000, ratio = 0.350, maxdmg = 3700, deathmod = 70, firemod = 100, energymod = 0, earthmod = 30, icemod = 80, holymod = 80, physicalmod = 100},
    {name = "skeleton", exp = 35, hp = 50, ratio = 0.700, maxdmg = 30, deathmod = 0, firemod = 100, energymod = 100, earthmod = 100, icemod = 100, holymod = 101, physicalmod = 100},
}

