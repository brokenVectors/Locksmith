if not plugin then -- Prevent useless errors from appearing in the output whilst using Hotswap
    return
end

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  
	true,   
	false,  
	200,   
	300,    
	150,    
	150    
)

local widget = plugin:CreateDockWidgetPluginGui("Locksmith", widgetInfo)
widget.Title = "Locksmith" 


local root = script.Parent.Parent
local pluginFrame = root.PluginFrame
local isBackdoor = require(script.Parent.isBackdoor)

local pages = require(script.Parent.pages)
local pageList = {Buttons = pluginFrame.Buttons, ScanGame = pluginFrame.ScanGame, ScanPlugins = pluginFrame.ScanPlugins}
local menuButtons = {ScanGame = pageList.Buttons.ScanGameBtn, ScanPlugins = pageList.Buttons.ScanPluginsBtn}

pages.Init(pageList, "Buttons")
pluginFrame.Parent = widget



for page, button in pairs(menuButtons) do
    button.MouseButton1Down:Connect(function()
        pages.Open(page)
    end)
end


for _,page in pairs(pageList) do
    local backBtn = page:FindFirstChild('BackBtn')

    if backBtn then
        backBtn.MouseButton1Down:Connect(function()
            pages.Open("Buttons")
        end)
    end
    
end

pageList.ScanGame.ScanBtn.MouseButton1Down:Connect(function()
    print('Scanning...')

    for _, scr in ipairs(game:GetDescendants()) do
        pcall(function()

            local percentage = isBackdoor(scr)

            if percentage > 0 then
                print(scr.Name, isBackdoor(scr))
            end
           
        end)
    end
end)