local Players = game:GetService("Players")
local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end

local ANIMS = {
    idle = {
        Animation1 = "rbxassetid://122257458498464",
        Animation2 = "rbxassetid://98173568987992",
        Animation3 = "rbxassetid://89262795687364",
    },
    walk = { WalkAnim = "rbxassetid://122150855457006" },
    run = { RunAnim = "rbxassetid://82598234841035" },
    jump = { JumpAnim = "rbxassetid://75290611992385" },
    climb = { ClimbAnim = "rbxassetid://88763136693023" },
    fall = { FallAnim = "rbxassetid://18537367238" },
    swim = { Swim = "rbxassetid://133308483266208" },
    swimidle = { SwimIdle = "rbxassetid://109346520324160" },
}

local function setAnimation(folder, name, id)
    local anim = folder:FindFirstChild(name)
    if not anim then
        anim = Instance.new("Animation")
        anim.Name = name
        anim.Parent = folder
        local weight = Instance.new("NumberValue")
        weight.Name = "Weight"
        weight.Value = 1
        weight.Parent = anim
    end
    anim.AnimationId = id
end

local function applyAnimations(character)
    local humanoid = character:WaitForChild("Humanoid")
    local animate = character:WaitForChild("Animate")
    local animator = humanoid:WaitForChild("Animator")

    if humanoid.RigType ~= Enum.HumanoidRigType.R15 then
        warn("R6 detected - R15 only")
        return
    end

    animate.Disabled = true

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    for folderName, anims in pairs(ANIMS) do
        local folder = animate:WaitForChild(folderName, 5)
        if folder then
            for animName, id in pairs(anims) do
                setAnimation(folder, animName, id)
            end
        else
            warn("Missing folder: " .. folderName)
        end
    end

    task.wait()
    animate.Disabled = false
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    print("Animations applied successfully")
end

local function onCharacter(character)
    local ok, err = pcall(applyAnimations, character)
    if not ok then
        warn("Animation script error: " .. tostring(err))
    end
end

if player.Character then
    task.spawn(onCharacter, player.Character)
end

player.CharacterAdded:Connect(onCharacter)
