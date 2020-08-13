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

--[[
    This module is useful for evaluating expressions, example: "2+2" would return 4, and "5+5" would return 10.
    This is mainly used to find what module IDs are required by scripts, since they sometimes do stuff like 18737263*4 just to get around basic string matching I believe.
    I might copy it as my own model eventually, since who knows what the module owner will do with it.

    Someone told me that it would be better to include the module inside of the repo instead, so I did that.
]]
-- local calcModule = require(2621701837)
local calcModule = require(script.Parent.stringCalculator)


function isBackdoor(scrpt)
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
                local mod = game:GetObjects(id)[1]
                local moduleIsVirus = isBackdoor(mod)
                
                percentage += moduleIsVirus
            end

    end

    return percentage
end

return isBackdoor