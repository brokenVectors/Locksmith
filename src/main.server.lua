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
local toolbar = plugin:CreateToolbar("Locksmith 3.0")
local openWidgetButton = toolbar:CreateButton("Open Locksmith", "Open Locksmith", "rbxassetid://5546267613")
local marketplaceService = game:GetService('MarketplaceService')
local serverStorage = game:GetService('ServerStorage')
local changeHistoryService = game:GetService('ChangeHistoryService')

local widget = plugin:CreateDockWidgetPluginGui("Locksmith", widgetInfo)
widget.Title = "Locksmith" 

local temp = serverStorage:FindFirstChild('Temp') or Instance.new("Folder")

temp.Name = "Temp"
temp.Parent = serverStorage
local root = script.Parent.Parent
local suspectBtn = root.SuspectBtn
local pluginFrame = root.PluginFrame
local httpService = game:GetService('HttpService')
local isBackdoor = require(script.Parent.isBackdoor)
local pluginURL = ("https://inventory.rprxy.xyz/v1/users/%d/inventory/Plugin"):format( plugin:GetStudioUserId() )

local pages = require(script.Parent.pages)
local pageList = {Buttons = pluginFrame.Buttons, ScanGame = pluginFrame.ScanGame, ScanPlugins = pluginFrame.ScanPlugins, TestLog = pluginFrame.TestResults}
local menuButtons = {ScanGame = pageList.Buttons.ScanGameBtn, ScanPlugins = pageList.Buttons.ScanPluginsBtn, TestLog = pageList.Buttons.TestLogBtn}

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


function Scan(objects)

    for _,v in ipairs(pageList.ScanGame.ScrollingFrame:GetChildren()) do
        if not v:IsA('UILayout') then
            v:Destroy()
        end
    end

    pageList.ScanGame.NothingFound.Visible = false

    local possibleBackdoors = 0
    for _, scr in ipairs(objects) do
        
        pcall(function()
            
            if not scr:IsA('LuaSourceContainer') then
                return
            end
            local percentage = isBackdoor(scr)

            if percentage > 0 then
                possibleBackdoors += 1
                local button = suspectBtn:Clone()

                button.Text = string.format('%s(%s%%)', scr:GetFullName(), percentage)
                button.Parent = pageList.ScanGame.ScrollingFrame

                button.MouseButton1Down:Connect(function()
                    game.Selection:Set({scr})
                end)

                button.DeleteBtn.MouseButton1Down:Connect(function()
                    scr.Parent = nil
                    button.Parent = nil
                    changeHistoryService:SetWaypoint("Deleted Script")
                end)
            end
           
        end)
    end

    if possibleBackdoors == 0 then
        pageList.ScanGame.NothingFound.Visible = true
    end
end

function Test()

    local passedTests = 0
    local failedTests = 0
    local totalTests = #root.TestScripts:GetChildren()
    for i,v in ipairs(root.TestScripts:GetChildren()) do
        if v and v:IsA('LuaSourceContainer') then
            local isVirus = v.IsVirus.Value
            local percentage = isBackdoor(v)
            local button = suspectBtn:Clone()
            button.DeleteBtn:Destroy()
            button.Parent = pageList.TestLog.ScrollingFrame
            if (percentage > 0) == isVirus then
                passedTests += 1
                button.Text = "Test " .. tostring(i) .. " passed"
            else
                failedTests += 1
                button.Text = "Test " .. tostring(i) .. " failed, script name is " .. v.Name .. ", IsVirus: " .. tostring(isVirus)   
            end
        end
    end
    print("Passed " .. tostring(passedTests) .. " tests out of " .. tostring(totalTests))
end
pageList.ScanGame.ScanBtn.MouseButton1Down:Connect(function()
    --print('Scanning...')
    Scan(game:GetDescendants())
end)

pageList.ScanPlugins.ScanBtn.MouseButton1Down:Connect(function()
    pageList.ScanPlugins.ScanBtn.Text = "This feature is currently indev."
    wait(3)
    pageList.ScanPlugins.ScanBtn.Text = "Scan Plugins"
    --[[print(pluginURL)
    local pluginIds = httpService:JSONDecode( httpService:GetAsync(pluginURL) ).data
    local objects = {}
    

    for _,id in ipairs(pluginIds) do
        print( marketplaceService:GetProductInfo(id).Name )
        local obj = game:GetObjects("rbxassetid://" .. id)[1]
        
        table.insert(objects, obj)
    end

    Scan(objects)
    ]]--
    
end)

openWidgetButton.Click:Connect(function()
    widget.Enabled = true
end)

Test()