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