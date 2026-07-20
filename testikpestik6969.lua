local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleFarm = Instance.new("TextButton")
local ToggleFly = Instance.new("TextButton")
local ToggleSword = Instance.new("TextButton")
local TeleportPlayer = Instance.new("TextButton")
local ToggleMenuBtn = Instance.new("TextButton")

ScreenGui.Name = "DeltaCheatMenu"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleMenuBtn.Name = "ToggleMenuBtn"
ToggleMenuBtn.Parent = ScreenGui
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.05, 0)
ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 30)
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Text = "HUD"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.TextSize = 14

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA MULTI-HACK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local function styleButton(btn, text, yPos)
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
end

styleButton(ToggleFarm, "Авто-Фарм Сокровищ: ВЫКЛ", 55)
styleButton(ToggleFly, "Режим Полета: ВЫКЛ", 110)
styleButton(ToggleSword, "Авто-Точение Шпаги: ВЫКЛ", 165)
styleButton(TeleportPlayer, "ТП к Игроку", 220)

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local farmActive = false
local flyActive = false
local swordActive = false
local flySpeed = 50
local swordName = "Sword"

local SteeringConnection
SteeringConnection = RunService.Stepped:Connect(function()
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
        ToggleFarm.Text = "Авто-Фарм Сокровищ: ВКЛ"
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleFarm.Text = "Авто-Фарм Сокровищ: ВЫКЛ"
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
        ToggleFly.Text = "Режим Полета: ВКЛ"
        ToggleFly.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleFly.Text = "Режим Полета: ВЫКЛ"
        ToggleFly.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

task.spawn(function()
    while true do
        if swordActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    local tool = LocalPlayer.Backpack:FindFirstChild(swordName)
                    if tool then char.Humanoid:EquipTool(tool) end
                    
                    local activeTool = char:FindFirstChild(swordName)
                    if activeTool then activeTool:Activate() end
                    
                    local rem = ReplicatedStorage:FindFirstChild("Upgrade") or ReplicatedStorage:FindFirstChild("Sharpen")
                    if rem and rem:IsA("RemoteEvent") then rem:FireServer() end
                end
            end)
        end
        task.wait(0.1)
    end
end)

ToggleSword.MouseButton1Click:Connect(function()
    swordActive = not swordActive
    if swordActive then
        ToggleSword.Text = "Авто-Точение Шпаги: ВКЛ"
        ToggleSword.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleSword.Text = "Авто-Точение Шпаги: ВЫКЛ"
        ToggleSword.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

TeleportPlayer.MouseButton1Click:Connect(function()
    pcall(function()
        local allPlayers = Players:GetPlayers()
        local targets = {}
        for _, p in ipairs(allPlayers) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(targets, p)
            end
        end
        if #targets > 0 then
            local randomPlayer = targets[math.random(1, #targets)]
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                myChar.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
            end
        end
    end)
end)
