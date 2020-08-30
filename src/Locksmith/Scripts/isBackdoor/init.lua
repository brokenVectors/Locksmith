local flags = {
	["LPH!"] = 100;
	["Jerome#1018"] = 100;
	[". Do not delete."] = 50; -- user acct security
	["memcorrupt"] = 50; -- malicious
	["getfenv"] = 80;
	["luraph"] = 50;
	["IronBrew"] = 50;
	["i1I"] = 100;
	["_G.KAU"] = 100;
	["�"] = 100; -- fake spaces
	["local wat="] = 100;
	["string.reverse"] = 50; -- typically used to hide something
	[":aurora()"] = 100;
	["iIL"] = 100;
	--["\114\101\113\117\105\114\101"] = 1000;
	["loadstring"] = 100;
}

local nameFlags = {
	["credit"] = 50
}

function Scanner(objects)
	local possibleBackdoors = {}
	for _, scr in pairs(objects) do
		xpcall(function()
			if not scr:IsA('LuaSourceContainer') then
				return
			end

			local item = isBackdoor(scr)
			if type(item) == "table" then
				for i, v in next, item do
					table.insert(possibleBackdoors, v)
				end
			elseif item > 0 then
				table.insert(possibleBackdoors, {scr = scr, percentage = item} )
			end
		end, function(err) warn(err) end)
	end
	return possibleBackdoors
end

local calcModule = require(script.stringCalculator)
local Temp_Assets = Instance.new("Folder", game.ServerStorage)
Temp_Assets.Name = "Temp_Assets"

function isBackdoor(scrpt)
	if not scrpt:IsA('LuaSourceContainer') then
		return 0
	end
	local src = scrpt.Source
	local percentage = 0

	for word, percent in pairs(nameFlags) do
		if string.lower(scrpt.Name) == word then -- detection based on script name
			percentage += percent
		end
	end

	for word, percent in pairs(flags) do
		if string.find(src, word) then -- parses the script ; detection based on matched flags
			percentage += percent
		end
	end

	for req in string.gmatch(src, 'require%((.-)%)') do -- fetches the required module and parses the contents
		local success = true
		local num

		if not tonumber(req) then
			success, num = pcall(function() return calcModule(req) end)
		else
			num = tonumber(req)
		end

		if success then
			local collected, mod = pcall(function() return game:GetObjects("rbxassetid://" .. num) end)
			if collected then
				local model = {}
				for _, object in pairs(mod) do
					object.Parent = Temp_Assets -- for debugging, may be removed
					for i, v in next, object:GetDescendants() do
						table.insert(model, v)
					end
				end
				table.insert(model, mod)
				return Scanner(model)
			else
				print('Failed to download assets from ' .. num)
			end
		end
	end

	return percentage
end

return Scanner