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

local pages = require(script.Parent.pages)
local pageList = {Buttons = pluginFrame.Buttons, ScanGame = pluginFrame.ScanGame, ScanPlugins = pluginFrame.ScanPlugins}
local buttons = {ScanGame = pageList.Buttons.ScanGameBtn, ScanPlugins = pageList.Buttons.ScanPluginsBtn}

pages.Init(pageList, "Buttons")
pluginFrame.Parent = widget



buttons.ScanGame.MouseButton1Down:Connect(function()
    pages.Open("ScanGame")
end)

buttons.ScanPlugins.MouseButton1Down:Connect(function()
    pages.Open("ScanPlugins")
end)

pageList.ScanGame.BackBtn.MouseButton1Down:Connect(function()
    pages.Open("Buttons")
end)

pageList.ScanPlugins.BackBtn.MouseButton1Down:Connect(function()
    pages.Open("Buttons")
end)