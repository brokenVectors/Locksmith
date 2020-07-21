local flags = {
    ["LPH!"] = 100,
    ["Jerome#1018"] = 100,
    [". Do not delete."] = 50,
    ["memcorrupt"] = 50


}

function isBackdoor(scrpt)
    local src = scrpt.Source
    local percentage = 0

    for word, percent in pairs(flags) do 
        if string.find(src, word) then
            percentage += percent
        end
    end

    return percentage
end

return isBackdoor