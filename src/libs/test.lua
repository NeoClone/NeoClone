TESTVERSION = '0.1'
print('Test library v'..TESTVERSION)


function settargeting(onoff)
	if (onoff == nil) then
		return
	else
		onoff = onoff:lower()
		if (onoff == 'on') or (onoff == 'yes') then
			onoff = 'yes'
		elseif (onoff == 'off') or (onoff == 'no') then
			onoff = 'no'
		end
	end
	setsetting('Targeting/TargetingEnabled', onoff, t)
	-- if onoff == 'no' and stopattacking ~= false then
		-- stopattack()
	-- end
end
------------------------------------------------------------------------------ coded by Sketchy
function LoadSandboxed(filename)
	local code = loadfile(filename, "bt", sandboxEnv)
	code()
end

function CloneTable(orig)
	-- If variable isn't a table just return it as is
	if type(orig) ~= "table" then
		return orig
	end
	
	-- Create new table object and iterate over original adding its values to the new one.
	-- The key and value may be a table itself so pass them through this function too.
	local newTable = {}
	for key, value in pairs(orig) do
		newTable[CloneTable(key)] = CloneTable(value)
	end
	
	-- Copy metatable if there is one
	setmetatable(newTable, CloneTable(getmetatable(orig)))
	
	return newTable
end


function IsValidPath(path)
	-- Check whether path is allowed
	
	return false
end

function IOOpenHook(path, mode)
	if IsValidPath(path) == true then
		return io.open(path, mode)
	end
	
	return nil, "Invalid path", 0
end

function IOLinesHook(path)
	if IsValidPath(path) == true then
		io.lines(path)
	end
	
	return nil
end

sandboxEnv = {
	pairs = pairs,
	print = print,
	-- Whatever other functions
	
	-- Can define a table like so
	io = { open = IOOpenHook, close = io.close, },
	os = { exit = os.exit, }, --sandboxEnv.os.exit() in Debug Log, it will work
	
	-- Create a copy of libraries you want to give full access to. The Clone function returns a new table duplicated
	-- from the passed table, this prevents sandbox scripts hooking the original global tables. You could also do this
	-- with the io table and hook the functions after the environment table is created like the below example.
	string = CloneTable(string),
	math = CloneTable(math),
	
	-- Whatever else you want them to have access to, like your own classes for bot functions.
}

-- Can define stuff out here too
sandboxEnv.io.lines = IOLinesHook
------------------------------------------------------------------------------ coded by Sketchy
--this is how we use it inside delphi
[[lua_getglobal(luaState, 'LoadSandboxed');
lua_pushstring(luaState, 'user.lua');
ress:= lua_pcall(luaState, 1, 0, 0);
  case ress of
    LUA_ERRSYNTAX: AddLogError( 'console script', LuaScript.getErrorText() );
    LUA_ERRRUN: AddLogError( 'console script', LuaScript.getErrorText() );
    LUA_ERRMEM: AddLogError( 'console script', LuaScript.getErrorText() );
    LUA_ERRERR: AddLogError( 'console script', LuaScript.getErrorText() );
  end;]]