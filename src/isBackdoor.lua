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
    [":aurora()"] = 100


}
local nameFlags = {
    ["credit"] = 50

}
local calcModule = require(2621701837)



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
		
		
       
            local success, num = pcall(function() return calcModule(req) end)
           
            if success then
                local id = "rbxassetid://" .. num
                print(scrpt.Name .. " is requiring " .. id)
                local mod = game:GetObjects(id)[1]
                local moduleIsVirus = isBackdoor(mod)
                
                percentage += moduleIsVirus
            end

    end

    return percentage
end

return isBackdoor