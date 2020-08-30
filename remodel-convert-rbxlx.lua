-- Credit to Travington for this. https://gist.github.com/travddm/972dbc66d2707eeeb37e234b91454ef4
-- Reads and Extracts RBXMX (game) files using remodel
local game = remodel.readPlaceFile("locksmith.rbxlx")

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local function CopyScript(obj, path)
	local src = remodel.getRawProperty(obj, "Source")
	local ext

	if obj.ClassName == "Script" then
		ext = ".server.lua"
	elseif obj.ClassName == "ModuleScript" then
		ext = ".lua"
	elseif obj.ClassName == "LocalScript" then
		ext = ".client.lua"
	end

	if #obj:GetChildren() > 0 then
		remodel.createDirAll(path)
		remodel.writeFile(path .. "/init" .. ext, src)

		return true
	else
		remodel.writeFile(path .. ext, src)

		return false
	end
end

local function RecursiveCopyAsset(obj, path)
	remodel.createDirAll(path)

	local isService = game:FindFirstChild(obj.Name) == obj

	if isService then
		for _, child in pairs(obj:GetChildren()) do
			RecursiveCopyAsset(child, path .. "/")
		end
	elseif obj.ClassName == "Folder" or obj.ClassName == "Configuration" or obj.ClassName == "StarterCharacterScripts" or obj.ClassName == "StarterPlayerScripts" then
		for _, child in pairs(obj:GetChildren()) do
			RecursiveCopyAsset(child, path .. "/" .. obj.Name)
		end
	elseif obj.ClassName == "ModuleScript" or obj.ClassName == "Script" or obj.ClassName == "LocalScript" then
		local hasChildren = CopyScript(obj, path .. "/" .. obj.Name)

		if hasChildren then
			for _, child in pairs(obj:GetChildren()) do
				RecursiveCopyAsset(child, path .. "/" .. obj.Name)
			end
		end
	elseif obj.ClassName == "RemoteEvent" or obj.ClassName == "RemoteFunction" or obj.ClassName == "BindableEvent" or obj.ClassName == "BindableFunction" then
		local json_obj =
			[[{
				"Name" : "]] .. obj.Name .. [[",
				"ClassName" : "]] .. obj.ClassName .. [[",
				"Children" : []
			}]]
		remodel.writeFile(path .. "/" .. obj.Name .. ".model.json", json_obj)
	else
		remodel.writeModelFile(obj, path .. "/" .. obj.Name .. ".rbxmx")
	end
end

RecursiveCopyAsset(ServerScriptService, "src")