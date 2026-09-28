local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumLibrary/refs/heads/main/Core.lua"))()

local Creator = Core.Creator
local Tween = Core.Tween
local WrapText = Core.WrapText
local GetWrappedTextHeight = Core.GetWrappedTextHeight
local Protect = Core.Protect
local RandomString = Core.RandomString
local ThemeColor = Core.ThemeColor

local Notification = {}
Notification.ActiveMessages = {}

function Notification:Init()
    if not self.GUI then
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = RandomString()
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		ScreenGui.ResetOnSpawn = false
		ScreenGui.IgnoreGuiInset = true
		Protect(ScreenGui)
		self.GUI = Creator("Frame", {
			Name = "STX_Notification",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -20, 1, -52),
			Position = UDim2.new(1, -10, 1, -10),
			AnchorPoint = Vector2.new(1, 1),
			ClipsDescendants = false,
			ZIndex = 999,
			Parent = ScreenGui,
			["Children"] = {
				Creator("UIListLayout", {
					Name = "STX_NotificationUIListLayout",
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					Padding = UDim.new(0, 6)
				})
			}
		})
	end
end
function Notification:Notify(Debug, middledebug)
    assert(self.GUI, "Notification GUI not initialized. Call :Init(parent) first.")
	local Title = Debug.Title or "Notification"
	local Description = Debug.Description or ""
	local DisplayTime = middledebug.Time or 3
	local fontSize = 12
	local font = Enum.Font.Gotham
	local maxWidth = 184
	local messageKey = Title .. "||" .. Description
	if Notification.ActiveMessages[messageKey] then return end
	Notification.ActiveMessages[messageKey] = true
	local wrappedText = WrapText(Description, font, fontSize, maxWidth)
	local textHeight = GetWrappedTextHeight(wrappedText, font, fontSize, maxWidth)
	local totalHeight = 28 + textHeight + 8
	local Shadow = Creator("ImageLabel", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 250, 1, -10),
		Size = UDim2.new(0, 0, 0, 0),
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.4,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		ZIndex = 1000
	}, self.GUI)
	local TitleLabel = Creator("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 8, 0, 2),
		Size = UDim2.new(1, -16, 0, 18),
		ZIndex = 1002,
		Font = Enum.Font.FredokaOne,
		Text = Title,
		TextColor3 = Color3.fromRGB(220, 220, 220),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	local CooldownLabel = Creator("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 2),
		Size = UDim2.new(0, 40, 0, 18),
		ZIndex = 1002,
		Font = Enum.Font.Gotham,
		Text = "(" .. DisplayTime .. "s)",
		TextColor3 = Color3.fromRGB(180, 180, 180),
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right
	})
	local NotificationFrame = Creator("Frame", {
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 0, 3),
		Size = UDim2.new(0, 200, 0, totalHeight),
		ZIndex = 1001,
		["Children"] = {
			Creator("UICorner", { CornerRadius = UDim.new(0, 7) }),
			Creator("UIStroke", {
				Color = Color3.fromRGB(180, 180, 180),
				Transparency = 0.8,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			}),
			TitleLabel,
			CooldownLabel,
			Creator("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 8, 0, 22),
				Size = UDim2.new(0, 184, 0, textHeight),
				ZIndex = 1002,
				Font = font,
				Text = wrappedText,
				TextColor3 = Color3.fromRGB(180, 180, 180),
				TextSize = fontSize,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			Creator("Frame", {
				Name = "ProgressBarBackground",
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 1, -8),
				Size = UDim2.new(1, 0, 0, 8),
				ZIndex = 1002,
				["Children"] = {
					Creator("UICorner", { CornerRadius = UDim.new(0, 5) }),
					Creator("Frame", {
						Name = "ProgressBarFill",
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 1003,
						["Children"] = {
							Creator("UICorner", { CornerRadius = UDim.new(0, 7) }),
							Creator("UIGradient", {
								Color = ThemeColor("Lit"),
								Rotation = 0
							})
						}
					})
				}
			})
		}
	}, Shadow)
	Tween(Shadow, { Position = UDim2.new(1, -10, 1, -10) }, 0.3, Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	Tween(Shadow, { Size = UDim2.new(0, 200, 0, totalHeight + 10) }, 0.3, Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local ProgressBarFill = NotificationFrame:FindFirstChild("ProgressBarBackground"):FindFirstChild("ProgressBarFill")
	if ProgressBarFill then
		Tween(ProgressBarFill, { Size = UDim2.new(0, 0, 1, 0) }, DisplayTime, Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	end
	task.spawn(function()
		for i = DisplayTime, 1, -1 do
			if CooldownLabel then CooldownLabel.Text = "(" .. i .. "s)" end
			task.wait(1)
		end
	end)
	coroutine.wrap(function()
		task.wait(DisplayTime)
		Tween(Shadow, { Position = UDim2.new(1, 250, 1, -10) }, 0.3, Enum.EasingStyle.Quart,
			Enum.EasingDirection.In)
		Tween(Shadow, { Size = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.wait(0.3)
		Shadow:Destroy()
		Notification.ActiveMessages[messageKey] = nil
	end)()
end

return Notification
