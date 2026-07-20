local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GitHubDeltaMenuMobileV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local targetGui = game:GetService("CoreGui")
if not targetGui or not pcall(function() ScreenGui.Parent = targetGui end) then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -155)
MainFrame.Size = UDim2.new(0, 220, 0, 310)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 100

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "GITHUB DELTA MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.ZIndex = 101

local ToggleFarm = Instance.new("TextButton")
local ToggleFly = Instance.new("TextButton")
local ToggleSword = Instance.new("TextButton")
local TeleportPlayer = Instance.new("TextButton")
local StealBuilds = Instance.new("TextButton")
local TargetInput = Instance.new("TextBox")

local function style(el, text, y, isInput)
    el.Parent = MainFrame
    el.Position = UDim2.new(0.05, 0, 0, y)
    el.Size = UDim2.new(0.9, 0, 0, 35)
    el.Font = Enum.Font.SourceSans
    el.Text = text
    el.TextSize = 14
    el.ZIndex = 102
    if isInput then
        el.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
        el.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    else
        el.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

style(TargetInput, "", 45, true) TargetInput.PlaceholderText = "Ник (частично)"
style(ToggleFarm, "Фарм Сокровищ: ВЫКЛ", 90, false)
style(ToggleFly, "Полет: ВЫКЛ", 135, false)
style(ToggleSword, "Заточка Шпаги: ВЫКЛ", 180, false)
style(TeleportPlayer, "ТП к Игроку", 225, false)
style(StealBuilds, "Украсть Лодку", 270, false)

local farmActive = false
local flyActive = false
local swordActive = false
local flySpeed = 50

-- ANTI-AFK СКРИПТ
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

local function getTargetPlayer()
    local text = TargetInput.Text:lower()
    if text == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(text) or p.DisplayName:lower():find(text)) then
            return p
        end
    end
    return nil
end

RunService.Stepped:Connect(function()
    if farmActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end)

local function teleportTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not farmActive then return end
    local root = char.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    pcall(function() tween.Completed:Wait() end)
end

task.spawn(function()
    while true do
        if farmActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(-69, 108, 644)
                    task.wait(1)
                    if not farmActive then return end
                    teleportTo(CFrame.new(-41, 77, 8675), 250)
                    if not farmActive then return end
                    task.wait(0.5)
                    char.HumanoidRootPart.CFrame = CFrame.new(-55, -361, 9488)
                    task.wait(8)
                end
            end)
        end
        task.wait(1)
    end
end)

ToggleFarm.MouseButton1Click:Connect(function()
    farmActive = not farmActive
    if farmActive then
        ToggleFarm.Text = "Фарм Сокровищ: ВКЛ"
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleFarm.Text = "Фарм Сокровищ: ВЫКЛ"
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if flyActive and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local root = char.HumanoidRootPart
        BodyVelocity.Parent = root
        local camera = workspace.CurrentCamera
        local moveDirection = char.Humanoid.MoveDirection
        
        if moveDirection.Magnitude > 0 then
            BodyVelocity.Velocity = camera.CFrame:VectorToWorldSpace(moveDirection * flySpeed)
        else
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        root.Velocity = Vector3.new(0, 0, 0)
    else
        BodyVelocity.Parent = nil
    end
end)

ToggleFly.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    if flyActive then
        ToggleFly.Text = "Полет: ВКЛ"
        ToggleFly.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleFly.Text = "Полет: ВЫКЛ"
        ToggleFly.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

task.spawn(function()
    while true do
        if swordActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            char.Humanoid:EquipTool(item)
                            task.wait(0.01)
                            item:Activate()
                        end
                    end
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") then
                            item:Activate()
                        end
                    end
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            local rn = remote.Name:lower()
                            if rn:find("click") or rn:find("sharpen") or rn:find("upgrade") or rn:find("swing") or rn:find("sword") or rn:find("attack") then
                                remote:FireServer()
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.05)
    end
end)

ToggleSword.MouseButton1Click:Connect(function()
    swordActive = not swordActive
    if swordActive then
        ToggleSword.Text = "Заточка Шпаги: ВКЛ"
        ToggleSword.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleSword.Text = "Заточка Шпаги: ВЫКЛ"
        ToggleSword.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

TeleportPlayer.MouseButton1Click:Connect(function()
    pcall(function()
        local target = getTargetPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
            end
        end
    end)
end)

-- ИСПРАВЛЕННАЯ СИСТЕМА КРАЖИ ЛОДКИ ЧЕРЕЗ РЕГЕНЕРАЦИЮ ВНЕШНИХ ПАРТОВ
StealBuilds.MouseButton1Click:Connect(function()
    pcall(function()
        local target = getTargetPlayer()
        if not target then return end
        
        for _, folder in ipairs(workspace:GetDescendants()) do
            if (folder.Name == "Blocks" or folder.Name == "NormalModules") and folder.Parent:FindFirstChild("Owner") and folder.Parent.Owner.Value == target then
                for _, b in ipairs(folder:GetChildren()) do
                    if b:IsA("BasePart") then
                        local p = Instance.new("Part")
                        p.Size = b.Size
                        p.Color = b.Color
                        p.Material = b.Material
                        p.Transparency = b.Transparency
                        p.CanCollide = true
                        p.Anchored = true
                        
                        local mc = LocalPlayer.Character
                        if mc and mc:FindFirstChild("HumanoidRootPart") then
                            local offset = b.Position - folder.Parent.Base.Position
                            p.CFrame = mc.HumanoidRootPart.CFrame * CFrame.new(offset) + Vector3.new(0, 10, -20)
                            p.Parent = workspace
                        end
                    end
                end
                break
            end
        end
    end)
end)
p.CFrame = mc.HumanoidRootPart.CFrame * CFrame.new(offset) + Vector3.new(0, 10, -20)p.Parent = workspaceendendendendend)end)
