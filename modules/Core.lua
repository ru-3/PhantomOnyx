local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/Util/LibraryModule/Themes.lua"))()
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local TweenInfo = TweenInfo.new

local Core = {}

function Core.JsonEncode(t)
    return HttpService:JSONEncode(t)
end
function Core.JsonDecode(s)
    return HttpService:JSONDecode(s)
end
function Core.Tween(target, properties, duration, style, direction, complete)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local Info = TweenInfo(duration, style, direction)
    local Tween = TweenService:Create(target, Info, properties)
    if typeof(complete) == "function" then
        local conn
        conn = Tween.Completed:Connect(function()
            conn:Disconnect()
            complete()
        end)
    end
    Tween:Play()
    return Tween
end

function Core.Creator(class, properties, parent)
    local instance = Instance.new(class)
    for key, value in pairs(properties) do
        if key ~= "Children" and key ~= "Parent" then
            instance[key] = value
        end
    end
    local children = properties["Children"]
    if children then
        for _,v in ipairs(children) do
            v.Parent = instance
        end
    end
    instance.Parent = properties.Parent or parent
    return instance
end

function Core.GetWrappedTextHeight(text, font, size, width)
    local s = TextService:GetTextSize(text, size, font, Vector2.new(width, math.huge))
    return s.Y
end

function Core.WrapText(text, font, size, width)
    local lines = {}
    for paragraph in (text .. "\n\n"):gmatch("(.-)\n") do
        if paragraph == "" then
            table.insert(lines, "")
        else
            local words = {}
            for word in paragraph:gmatch("%S+") do
                table.insert(words, word)
            end
            local Line = ""
            for _,word in ipairs(words) do
                local extra = Line == "" and word or Line .. " " .. word
                local sz = TextService:GetTextSize(extra, size, font, Vector2.new(width, 1000))
                if sz.X > width then
                    table.insert(lines, Line)
                    Line = word
                else
                    Line = extra
                end
            end
            table.insert(lines, Line)
        end
    end
    return table.concat(lines, "\n")
end

function Core.Protect(GUI)
    if _ENV and _ENV.HIDEUI then
        GUI.Parent = _ENV.HIDEUI
    elseif gethui then
        GUI.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(GUI)
        GUI.Parent = game:GetService("CoreGui")
    else
        GUI.Parent = game:GetService("CoreGui")
    end
end

function Core.RandomString()
    local output = ""
    for _ = 2, 25 do
        output = output .. string.char(math.random(1, 250))
    end
    return output
end

function Core.CircleClick(Button, X, Y)
    task.spawn(function()
        Button.ClipsDescendants = true
        local NewX = X - Button.AbsolutePosition.X
        local NewY = Y - Button.AbsolutePosition.Y
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
        local Time = 0.5
        local Circle = Core.Creator("ImageLabel", {
            Name = "Circle",
            Image = "rbxassetid://266543268",
            ImageColor3 = Color3.fromRGB(80, 80, 80),
            ImageTransparency = 0.8,
            BackgroundTransparency = 1,
            ZIndex = 10,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, NewX, 0, NewY),
        }, Button)
        Core.Tween(Circle, {
            Size = UDim2.new(0, Size, 0, Size),
            Position = UDim2.new(0.5, -Size / 2, 0.5, -Size / 2)
        }, Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        Core.Tween(Circle, {
            ImageTransparency = 1
        }, Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, function()
            Circle:Destroy()
        end)
    end)
end

Core.ThemeManager = ThemeManager
function Core.ThemeColor(name)
    if ThemeManager.Current and ThemeManager.Current[name] then
        return ThemeManager.Current[name]
    end
    return Color3.fromRGB(255, 0, 255)
end


return Core