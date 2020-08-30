if not plugin then -- Prevent useless errors from appearing in the output whilst using Hotswap
	return
end

--local HttpService = game:GetService('HttpService')
local MarketplaceService = game:GetService('MarketplaceService')
local ChangeHistoryService = game:GetService('ChangeHistoryService')
local UserInputService = game:GetService("UserInputService")
local ServerStorage = game:GetService('ServerStorage')

--local pluginURL = ("https://inventory.rprxy.xyz/v1/users/%d/inventory/Plugin"):format( plugin:GetStudioUserId() )

local widget = plugin:CreateDockWidgetPluginGui("Locksmith", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float, false, false,
	200, 300, 150, 15
))
widget.Title = "Locksmith"

local root = script.Parent.Parent

local suspectBtn = root.SuspectBtn
local pluginFrame = root.PluginFrame
pluginFrame.Parent = widget

local pages = require(script.Parent.pages)
local pageList = {
	Buttons = pluginFrame.Buttons,
	ScanGame = pluginFrame.ScanGame,
	ScanPlugins = pluginFrame.ScanPlugins,
	TestLog = pluginFrame.TestResults
}
local menuButtons = {
	ScanGame = pageList.Buttons.ScanGameBtn,
	ScanPlugins = pageList.Buttons.ScanPluginsBtn,
	TestLog = pageList.Buttons.TestLogBtn
}

pages.Init(pageList, "Buttons")

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

local Scanner = require(script.Parent.isBackdoor)

function Scan(objects)
	for _, v in pairs(pageList.ScanGame.ScrollingFrame:GetChildren()) do
		if not v:IsA('UILayout') then
			v:Destroy()
		end
	end

	pageList.ScanGame.NothingFound.Visible = false

	local possibleBackdoors = Scanner(objects)
	if #possibleBackdoors == 0 then
		pageList.ScanGame.NothingFound.Visible = true
	else
		for i, v in next, possibleBackdoors do
			local button = suspectBtn:Clone()
			button.Text = string.format('%s(%s%%)', v.scr:GetFullName(), v.percentage)
			button.Parent = pageList.ScanGame.ScrollingFrame

			button.MouseButton1Down:Connect(function()
				game.Selection:Set({v.scr})
			end)

			button.DeleteBtn.MouseButton1Down:Connect(function()
				v.scr:Destroy()
				button:Destroy()
				ChangeHistoryService:SetWaypoint("Deleted Script")
			end)
		end
	end
end

pageList.ScanGame.ScanBtn.MouseButton1Down:Connect(function()
	Scan(game:GetDescendants())
end)

pageList.ScanPlugins.ScanBtn.MouseButton1Down:Connect(function()
	pageList.ScanPlugins.ScanBtn.Text = "This feature is currently indev."
	wait(3)
	pageList.ScanPlugins.ScanBtn.Text = "Scan Plugins"
end)

function Enable(Mouse)
	getfenv(0).Mouse = Mouse
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default

	widget.Enabled = true

	IsEnabled = true
end

function Disable()
	widget.Enabled = false
	IsEnabled = false
end

PluginButton = plugin:CreateToolbar("Locksmith 3.0"):CreateButton("Open Locksmith", "Open Locksmith", "rbxassetid://5546267613")

plugin.Deactivation:Connect(Disable);

PluginButton.Click:Connect(function ()
	PluginEnabled = not PluginEnabled
	PluginButton:SetActive(PluginEnabled)

	if PluginEnabled then
		plugin:Activate(true)
		Enable(plugin:GetMouse())
	else
		Disable()
	end
end)