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
widget.Title = "Test Widget" 


local root = script.Parent.Parent
local pluginFrame = root.PluginFrame
local pages = {Buttons = pluginFrame.Buttons, GameScan = pluginFrame.Scan}

pluginFrame.Parent = widget