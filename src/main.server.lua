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

pages.Init({Buttons = pluginFrame.Buttons, Scan = pluginFrame.Scan}, "Buttons")

print( pages.GetPageByName("Buttons") )
pluginFrame.Parent = widget
wait(1)
