local flags = {
	["LPH!"] = 100,
	["Jerome#1018"] = 100,
	[". Do not delete."] = 50,
	["memcorrupt"] = 50,
	["getfenv"] = 80,
	["luraph"] = 50,
	["IronBrew"] = 50,
	["i1I"] = 100,
	["_G.KAU"] = 100,
	["￼"] = 100,
	["local wat="] = 100,
	["string.reverse"] = 50,
	[":aurora()"] = 100,
	["iIL"] = 100
}

local nameFlags = {
	["credit"] = 50
}

local calcModule = require(script.Parent.stringCalculator)

function isBackdoor(scrpt)
	if not scrpt:IsA('LuaSourceContainer') then
		return 0
	end
	local src = scrpt.Source
	local percentage = 0

	for word, percent in pairs(nameFlags) do
		if string.lower(scrpt.Name) == word then
			percentage += percent
		end
	end

	for word, percent in pairs(flags) do
		if string.find(src, word) then
			percentage += percent
		end
	end

	for req in string.gmatch(src, 'require%((.-)%)') do
		local success
		local num

		if not tonumber(req) then
			local success, num = pcall(function() return calcModule(req) end)
		else
			success = true
			num = tonumber(req)
		end

		if success then
			local id = "rbxassetid://" .. num
			--print(scrpt.Name .. " is requiring " .. id)

			local mod
			pcall(function()
				local mod = game:GetObjects(id)[1]
			end)

			if not mod then
				continue
			end
			local moduleIsVirus = isBackdoor(mod)

			percentage += moduleIsVirus
		end
	end

	return percentage
end

return isBackdoor