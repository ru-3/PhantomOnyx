local source = game:HttpGet("https://raw.githubusercontent.com/ru-3/PhantomOnyx/refs/heads/main/modules/lib/PhantomOnyx.lua")
local chunk, compileError = loadstring(source)
assert(chunk, "Compile Error: " .. tostring(compileError))

local loaded, Library = pcall(chunk)
assert(loaded, "Runtime Error: " .. tostring(Library))
assert(type(Library) == "table", "Library did not return a table")

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "Phantom Onyx",
    Subtitle = "Complete Library Example",
    Version = "v2.0.0",
    Theme = "Purple",
    SaveFile = "PhantomOnyxExample",

    Credits = {
        {
            Name = "Normal Guy",
            Role = "Developer"
        }
    }
})

local DashboardTab = Window:AddTab("Dashboard", "home-quantum")
local PlayerTab = Window:AddTab("Player", "user-quantum")
local VisualTab = Window:AddTab("Visuals", "visual-quantum")
local AutomationTab = Window:AddTab("Automation", "misc-quantum")
local TeleportTab = Window:AddTab("Teleport", "home-quantum")
local SettingsTab = Window:AddTab("Settings", "misc-quantum")

local state = {
	walkSpeed = 16,
	jumpPower = 50,
	fieldOfView = 70,
	walkSpeedEnabled = false,
	jumpPowerEnabled = false,
	noclipEnabled = false,
	infiniteJumpEnabled = false,
	autoCollectEnabled = false,
	autoFarmEnabled = false,
	selectedPlayer = nil,
	selectedLocation = "Spawn",
	farmMode = "Normal",
}

local connections = {}

local function notify(title, description, duration)
	Library.Notification:Notify({
		Title = title,
		Description = description,
	}, { Time = duration or 3 })
end

local function getCharacter()
	return LocalPlayer.Character
end

local function getHumanoid()
	local character = getCharacter()
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
	local character = getCharacter()
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function disconnect(name)
	local connection = connections[name]
	if connection then
		connection:Disconnect()
		connections[name] = nil
	end
end

local dashboardLeftSection = DashboardTab:AddSection("Left")
local dashboardRightSection = DashboardTab:AddSection("Right")

local welcomeMenu = dashboardLeftSection:AddMenu("Welcome")
welcomeMenu:AddLabel("Phantom Onyx", "A complete example demonstrating the library layout and controls.")
welcomeMenu:AddLabel("Status", "The interface loaded successfully and is ready to use.")
welcomeMenu:AddLabel("Layout", "Each tab uses separate Left and Right card sections.")

local quickActionsMenu = dashboardLeftSection:AddMenu("Quick Actions")
quickActionsMenu:AddButtonGrid("Character", {
	{
		Label = "Heal",
		Callback = function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.Health = humanoid.MaxHealth
				notify("Character", "Health restored.", 2)
			else
				notify("Character", "Character is not available.", 2)
			end
		end,
	},
	{
		Label = "Reset",
		Callback = function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.Health = 0
			end
		end,
	},
	{
		Label = "Sit",
		Callback = function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.Sit = true
			end
		end,
	},
})

quickActionsMenu:AddButtonGrid("Server", {
	{
		Label = "Rejoin",
		Callback = function()
			notify("Server", "Rejoining the current server.", 2)
			task.wait(1)
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		end,
	},
	{
		Label = "Copy Job ID",
		Callback = function()
			if setclipboard then
				setclipboard(game.JobId)
				notify("Server", "Job ID copied.", 2)
			else
				notify("Server", "Clipboard is not supported.", 2)
			end
		end,
	},
	{
		Label = "Server Info",
		Callback = function()
			notify("Server", tostring(#Players:GetPlayers()) .. " players are connected.", 3)
		end,
	},
})

local sessionMenu = dashboardRightSection:AddMenu("Session")
sessionMenu:AddLabel("Player", LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")")
sessionMenu:AddLabel("Place ID", tostring(game.PlaceId))
sessionMenu:AddLabel("Job ID", game.JobId ~= "" and game.JobId or "Studio Session")
sessionMenu:AddLabel("Players", tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers))

local notificationMenu = dashboardRightSection:AddMenu("Notifications")
notificationMenu:AddTextbox("Custom Notification", function(text)
	local message = tostring(text)
	if message == "" then
		message = "This is a custom notification."
	end
	notify("Custom Message", message, 4)
end, "Notify", "customNotification")

notificationMenu:AddButton("Show Success Message", function()
	notify("Success", "The requested action completed successfully.", 3)
end)

notificationMenu:AddButton("Show Warning Message", function()
	notify("Warning", "Review your selected options before continuing.", 4)
end)

local playerLeftSection = PlayerTab:AddSection("Left")
local playerRightSection = PlayerTab:AddSection("Right")

local movementMenu = playerLeftSection:AddMenu("Movement")
movementMenu:AddToggle("Walk Speed", false, function(enabled)
	state.walkSpeedEnabled = enabled
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.WalkSpeed = enabled and state.walkSpeed or 16
	end
end, nil, "Applies the selected walking speed", "walkSpeedEnabled")

movementMenu:AddSlider("Walk Speed Value", 16, 250, 50, function(value)
	state.walkSpeed = value
	local humanoid = getHumanoid()
	if humanoid and state.walkSpeedEnabled then
		humanoid.WalkSpeed = value
	end
end, nil, 1, "walkSpeedValue")

movementMenu:AddToggle("Jump Power", false, function(enabled)
	state.jumpPowerEnabled = enabled
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = enabled and state.jumpPower or 50
	end
end, nil, "Applies the selected jump power", "jumpPowerEnabled")

movementMenu:AddSlider("Jump Power Value", 50, 300, 100, function(value)
	state.jumpPower = value
	local humanoid = getHumanoid()
	if humanoid and state.jumpPowerEnabled then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = value
	end
end, nil, 1, "jumpPowerValue")

local abilitiesMenu = playerLeftSection:AddMenu("Abilities")
abilitiesMenu:AddToggle("Infinite Jump", false, function(enabled)
	state.infiniteJumpEnabled = enabled
	disconnect("infiniteJump")
	if enabled then
		connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end, nil, "Allows jumping while airborne", "infiniteJump")

abilitiesMenu:AddToggle("Noclip", false, function(enabled)
	state.noclipEnabled = enabled
	disconnect("noclip")
	if enabled then
		connections.noclip = RunService.Stepped:Connect(function()
			local character = getCharacter()
			if character then
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	end
end, nil, "Disables character collision", "noclip")

local characterMenu = playerRightSection:AddMenu("Character")
characterMenu:AddButton("Restore Defaults", function()
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 50
		humanoid.HipHeight = 0
		notify("Character", "Default values restored.", 2)
	end
end)

characterMenu:AddSlider("Hip Height", 0, 20, 0, function(value)
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.HipHeight = value
	end
end, nil, 1, "hipHeight")

characterMenu:AddButtonGrid("Actions", {
	{
		Label = "Jump",
		Callback = function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.Jump = true
			end
		end,
	},
	{
		Label = "Stand",
		Callback = function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.Sit = false
			end
		end,
	},
	{
		Label = "Respawn",
		Callback = function()
			LocalPlayer:LoadCharacter()
		end,
	},
})

local playerTargetMenu = playerRightSection:AddMenu("Player Target")
local playerNames = {}
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		table.insert(playerNames, player.Name)
	end
end
if #playerNames == 0 then
	table.insert(playerNames, "No players available")
end

playerTargetMenu:AddDropdown("Select Player", 1, playerNames, function(option)
	state.selectedPlayer = Players:FindFirstChild(tostring(option))
end, nil, false, "selectedPlayer")

playerTargetMenu:AddButton("Teleport to Player", function()
	local root = getRootPart()
	local targetCharacter = state.selectedPlayer and state.selectedPlayer.Character
	local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
	if root and targetRoot then
		root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
		notify("Player", "Teleported to " .. state.selectedPlayer.Name .. ".", 2)
	else
		notify("Player", "The selected player is unavailable.", 3)
	end
end)

local visualLeftSection = VisualTab:AddSection("Left")
local visualRightSection = VisualTab:AddSection("Right")

local lightingMenu = visualLeftSection:AddMenu("Lighting")
lightingMenu:AddToggle("Full Bright", false, function(enabled)
	if enabled then
		Lighting.Brightness = 3
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
	else
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1000
		Lighting.GlobalShadows = true
	end
end, nil, "Improves visibility in dark areas", "fullBright")

lightingMenu:AddToggle("Remove Fog", false, function(enabled)
	Lighting.FogEnd = enabled and 100000 or 1000
end, nil, "Changes the visible fog distance", "removeFog")

lightingMenu:AddSlider("Brightness", 0, 10, 2, function(value)
	Lighting.Brightness = value
end, nil, 1, "brightness")

lightingMenu:AddSlider("Clock Time", 0, 24, 14, function(value)
	Lighting.ClockTime = value
end, nil, 1, "clockTime")

local cameraMenu = visualLeftSection:AddMenu("Camera")
cameraMenu:AddSlider("Field of View", 40, 120, 70, function(value)
	state.fieldOfView = value
	local camera = workspace.CurrentCamera
	if camera then
		camera.FieldOfView = value
	end
end, nil, 1, "fieldOfView")

cameraMenu:AddButton("Reset Camera", function()
	local camera = workspace.CurrentCamera
	local humanoid = getHumanoid()
	if camera then
		camera.FieldOfView = 70
		if humanoid then
			camera.CameraSubject = humanoid
		end
	end
	notify("Camera", "Camera settings restored.", 2)
end)

local environmentMenu = visualRightSection:AddMenu("Environment")
environmentMenu:AddDropdown("Time Preset", 1, { "Day", "Sunset", "Night", "Midnight" }, function(option)
	local times = {
		Day = 14,
		Sunset = 18,
		Night = 21,
		Midnight = 0,
	}
	Lighting.ClockTime = times[tostring(option)] or 14
end, nil, false, "timePreset")

environmentMenu:AddDropdown("Atmosphere", 1, { "Default", "Clear", "Bright", "Dark" }, function(option)
	local selected = tostring(option)
	if selected == "Clear" then
		Lighting.FogEnd = 100000
		Lighting.Brightness = 2
	elseif selected == "Bright" then
		Lighting.FogEnd = 100000
		Lighting.Brightness = 4
	elseif selected == "Dark" then
		Lighting.FogEnd = 600
		Lighting.Brightness = 1
	else
		Lighting.FogEnd = 1000
		Lighting.Brightness = 2
	end
end, nil, false, "atmospherePreset")

local visualActionsMenu = visualRightSection:AddMenu("Visual Actions")
visualActionsMenu:AddButtonGrid("Presets", {
	{
		Label = "Performance",
		Callback = function()
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 100000
			notify("Visuals", "Performance preset applied.", 2)
		end,
	},
	{
		Label = "Quality",
		Callback = function()
			Lighting.GlobalShadows = true
			Lighting.Brightness = 2
			notify("Visuals", "Quality preset applied.", 2)
		end,
	},
	{
		Label = "Reset",
		Callback = function()
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 1000
			Lighting.GlobalShadows = true
			notify("Visuals", "Visual settings restored.", 2)
		end,
	},
})

local automationLeftSection = AutomationTab:AddSection("Left")
local automationRightSection = AutomationTab:AddSection("Right")

local farmingMenu = automationLeftSection:AddMenu("Farming")
farmingMenu:AddToggle("Auto Farm", false, function(enabled)
	state.autoFarmEnabled = enabled
	notify("Auto Farm", enabled and "Enabled." or "Disabled.", 2)
end, nil, "Runs the selected farming routine", "autoFarm")

farmingMenu:AddDropdown("Farm Mode", 1, { "Normal", "Fast", "Safe", "Aggressive" }, function(option)
	state.farmMode = tostring(option)
	notify("Farm Mode", state.farmMode .. " mode selected.", 2)
end, nil, false, "farmMode")

farmingMenu:AddSlider("Farm Delay", 1, 20, 5, function(value)
	notify("Farm Delay", tostring(value) .. " seconds.", 2)
end, nil, 1, "farmDelay")

local collectionMenu = automationLeftSection:AddMenu("Collection")
collectionMenu:AddToggle("Auto Collect", false, function(enabled)
	state.autoCollectEnabled = enabled
	notify("Auto Collect", enabled and "Enabled." or "Disabled.", 2)
end, nil, "Collects nearby items automatically", "autoCollect")

collectionMenu:AddDropdown("Item Priority", 1, { "Nearest", "Rarest", "Highest Value", "Newest" }, function(option)
	notify("Item Priority", tostring(option) .. " selected.", 2)
end, nil, false, "itemPriority")

local automationStatusMenu = automationRightSection:AddMenu("Status")
automationStatusMenu:AddLabel("Auto Farm", "Configure the routine from the Farming card.")
automationStatusMenu:AddLabel("Auto Collect", "Configure item collection from the Collection card.")
automationStatusMenu:AddLabel("Safety", "Stop all routines before changing servers.")

automationStatusMenu:AddButton("Stop All Automation", function()
	state.autoFarmEnabled = false
	state.autoCollectEnabled = false
	notify("Automation", "All active routines stopped.", 3)
end)

local taskMenu = automationRightSection:AddMenu("Task Controls")
taskMenu:AddTextbox("Custom Task Name", function(text)
	notify("Task", tostring(text) .. " was added to the queue.", 3)
end, "Add Task", "customTaskName")

taskMenu:AddButtonGrid("Queue", {
	{
		Label = "Start",
		Callback = function()
			notify("Queue", "Task queue started.", 2)
		end,
	},
	{
		Label = "Pause",
		Callback = function()
			notify("Queue", "Task queue paused.", 2)
		end,
	},
	{
		Label = "Clear",
		Callback = function()
			notify("Queue", "Task queue cleared.", 2)
		end,
	},
})

local teleportLeftSection = TeleportTab:AddSection("Left")
local teleportRightSection = TeleportTab:AddSection("Right")

local locationMenu = teleportLeftSection:AddMenu("Locations")
locationMenu:AddDropdown("Select Location", 1, { "Spawn", "Shop", "Arena", "Boss", "Safe Zone" }, function(option)
	state.selectedLocation = tostring(option)
end, nil, false, "selectedLocation")

locationMenu:AddButton("Teleport to Location", function()
	notify("Teleport", state.selectedLocation .. " selected. Add your game coordinates to this callback.", 4)
end)

local coordinateMenu = teleportLeftSection:AddMenu("Coordinates")
coordinateMenu:AddTextbox("Position: X, Y, Z", function(text)
	local x, y, z = tostring(text):match("^%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*$")
	local root = getRootPart()
	if root and x and y and z then
		root.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
		notify("Teleport", "Moved to the custom position.", 2)
	else
		notify("Teleport", "Enter coordinates as X, Y, Z.", 3)
	end
end, "Teleport", "customCoordinates")

local savedPlacesMenu = teleportRightSection:AddMenu("Saved Places")
local savedPosition = nil
savedPlacesMenu:AddButtonGrid("Position", {
	{
		Label = "Save",
		Callback = function()
			local root = getRootPart()
			if root then
				savedPosition = root.CFrame
				notify("Position", "Current position saved.", 2)
			end
		end,
	},
	{
		Label = "Load",
		Callback = function()
			local root = getRootPart()
			if root and savedPosition then
				root.CFrame = savedPosition
				notify("Position", "Saved position loaded.", 2)
			else
				notify("Position", "No position has been saved.", 2)
			end
		end,
	},
	{
		Label = "Clear",
		Callback = function()
			savedPosition = nil
			notify("Position", "Saved position cleared.", 2)
		end,
	},
})

local serverMenu = teleportRightSection:AddMenu("Server")
serverMenu:AddButton("Rejoin Current Server", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

serverMenu:AddButton("Join New Server", function()
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

local settingsLeftSection = SettingsTab:AddSection("Left")
local settingsRightSection = SettingsTab:AddSection("Right")

local interfaceMenu = settingsLeftSection:AddMenu("Interface")
interfaceMenu:AddDropdown("Theme", 1, { "Purple", "Dark", "Light", "Blue", "Red" }, function(option)
	notify("Theme", tostring(option) .. " selected. Theme support depends on the library build.", 3)
end, nil, false, "selectedTheme")

interfaceMenu:AddToggle("UI Notifications", true, function(enabled)
	if enabled then
		notify("Notifications", "Interface notifications enabled.", 2)
	end
end, nil, "Controls example notifications", "uiNotifications")

interfaceMenu:AddButton("Hide Interface", function()
	Window:ToggleUI()
end)

local configurationMenu = settingsLeftSection:AddMenu("Configuration")
configurationMenu:AddLabel("Save File", "PhantomOnyxExample")
configurationMenu:AddLabel("Version", "v2.0.0")
configurationMenu:AddButton("Confirm Configuration", function()
	notify("Configuration", "Your current control values are ready.", 3)
end)

local utilityMenu = settingsRightSection:AddMenu("Utilities")
utilityMenu:AddButton("Copy Place ID", function()
	if setclipboard then
		setclipboard(tostring(game.PlaceId))
		notify("Clipboard", "Place ID copied.", 2)
	else
		notify("Clipboard", "Clipboard is not supported.", 2)
	end
end)

utilityMenu:AddButton("Copy Job ID", function()
	if setclipboard then
		setclipboard(game.JobId)
		notify("Clipboard", "Job ID copied.", 2)
	else
		notify("Clipboard", "Clipboard is not supported.", 2)
	end
end)

local dangerMenu = settingsRightSection:AddMenu("Interface Control")
dangerMenu:AddButton("Destroy Interface", function()
	for name in pairs(connections) do
		disconnect(name)
	end
	Library:DestroyGui()
end)

dangerMenu:AddButton("Unload Example", function()
	for name in pairs(connections) do
		disconnect(name)
	end
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 50
	end
	notify("Phantom Onyx", "Example unloaded.", 2)
	task.wait(1)
	Library:DestroyGui()
end)

-- Hooks run after the interface is created so they can modify both existing UI objects and objects added later.
-- Change these values to customize the toggle image, hub title, and community name without editing the library source.
-- Each hook first scans existing descendants, then listens to DescendantAdded to apply the same change to future objects.
-- Property-change listeners keep replacement text locked when the library tries to update it again.

local CoreGui = gethui and gethui() or game:GetService("CoreGui")
local targetToggleImage = "rbxassetid://87383580130479"
local targetLogoImage = "rbxassetid://115746485854852"
local targetHubName = "Phantom Onyx Hub"
local targetCommunityName = "Phantom Onyx Community"

-- This hook replaces toggle-related ImageButton and ImageLabel assets.
local function applyToggleImageHook(object)
	if (object:IsA("ImageButton") or object:IsA("ImageLabel")) and object.Name:lower():find("toggle") then
		object.Image = targetToggleImage
	end
end

for _, object in ipairs(CoreGui:GetDescendants()) do
	applyToggleImageHook(object)
end

CoreGui.DescendantAdded:Connect(applyToggleImageHook)

-- This hook locks every TitleHub label to the custom hub name.
local function applyTitleHook(object)
	if object.Name ~= "TitleHub" or not object:IsA("TextLabel") then
		return
	end

	object.Text = targetHubName
	object:GetPropertyChangedSignal("Text"):Connect(function()
		if object.Text ~= targetHubName then
			object.Text = targetHubName
		end
	end)
end

for _, object in ipairs(CoreGui:GetDescendants()) do
	applyTitleHook(object)
end

CoreGui.DescendantAdded:Connect(applyTitleHook)

-- This hook replaces the library's default project names in all supported text objects.
local function replaceLibraryName(text)
	local output = text
	output = output:gsub("[Qq][Uu][Aa][Nn][Tt][Uu][Mm]%s+[Oo][Nn][Yy][Xx]%s+[Hh][Uu][Bb]", targetCommunityName)
	output = output:gsub("[Qq][Uu][Aa][Nn][Tt][Uu][Mm]%s+[Oo][Nn][Yy][Xx]%s+[Pp][Rr][Oo][Jj][Ee][Cc][Tt]", targetCommunityName)
	output = output:gsub("[Qq][Uu][Aa][Nn][Tt][Uu][Mm]%s+[Oo][Nn][Yy][Xx]", targetCommunityName)
	return output
end

local function applyTextHook(object)
	if not (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
		return
	end

	local function updateText()
		local replaced = replaceLibraryName(object.Text)
		if replaced ~= object.Text then
			object.Text = replaced
		end
	end

	updateText()
	object:GetPropertyChangedSignal("Text"):Connect(updateText)
end

for _, object in ipairs(CoreGui:GetDescendants()) do
	applyTextHook(object)
end

CoreGui.DescendantAdded:Connect(applyTextHook)

-- This final hook updates ToggleLogo immediately when the object exists and also handles delayed creation.
local function applyLogoHook(object)
	if object.Name == "ToggleLogo" and (object:IsA("ImageButton") or object:IsA("ImageLabel")) then
		object.Image = targetLogoImage
	end
end

for _, object in ipairs(CoreGui:GetDescendants()) do
	applyLogoHook(object)
end

CoreGui.DescendantAdded:Connect(applyLogoHook)

LocalPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if humanoid then
		humanoid.WalkSpeed = state.walkSpeedEnabled and state.walkSpeed or 16
		humanoid.UseJumpPower = true
		humanoid.JumpPower = state.jumpPowerEnabled and state.jumpPower or 50
	end
end)

notify("Phantom Onyx", "Complete library example loaded successfully.", 4)
