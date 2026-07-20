local Library = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Window = Library.CreateLib("DELTA MULTI-HACK", "DarkTheme")

local MainTab = Window:NewTab("Основное")
local PlayersTab = Window:NewTab("Игроки")
local BuildTab = Window:NewTab("Постройки")

local MainSection = MainTab:NewSection("Авто-Фарм и Функции")
local PlayersSection = PlayersTab:NewSection("Телепортация")
local BuildSection = BuildTab:NewSection("Кража лодок")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local farmActive = false
local flyActive = false
local swordActive = false
local flySpeed = 50
local targetPlayerName = ""

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

MainSection:NewToggle("Авто-Фарм Сокровищ", "Автоматический сбор золота", function(state)
    farmActive = state
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

MainSection:NewToggle("Режим Полета", "Позволяет летать сквозь стены", function(state)
    flyActive = state
end)

MainSection:NewSlider("Скорость Полета", "Изменение скорости перемещения", 250, 10, function(s)
    flySpeed = s
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

MainSection:NewToggle("Авто-Точение Шпаги", "Автоматические клики и заточка", function(state)
    swordActive = state
end)

local function getTargetPlayer()
    if targetPlayerName == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(targetPlayerName:lower()) or p.DisplayName:lower():find(targetPlayerName:lower())) then
            return p
        end
    end
    return nil
end

PlayersSection:NewTextBox("Ник Игрока", "Введите часть имени или полный ник", function(text)
    targetPlayerName = text
end)

PlayersSection:NewButton("Телепортироваться", "ТП к указанному выше игроку", function()
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

BuildSection:NewButton("Украсть лодку игрока", "Скопирует постройку цели на вашу позицию", function()
    pcall(function()
        local target = getTargetPlayer()
        if not target or not target.Team then return end
        for _, zone in ipairs(workspace:GetChildren()) do
            if zone.Name:find("Zone") or zone:FindFirstChild("Blocks") then
                local ownerValue = zone:FindFirstChild("Owner") or zone:FindFirstChild("Player")
                if (ownerValue and ownerValue.Value == target) or zone.Name:lower():find(target.Team.Name:lower()) then
                    local blocks = zone:FindFirstChild("Blocks") or zone
                    for _, block in ipairs(blocks:GetChildren()) do
                        if block:IsA("BasePart") and block.Name ~= "Ice" and block.Name ~= "Water" then
                            local clone = block:Clone()
                            local localChar = LocalPlayer.Character
                            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                                clone.CFrame = localChar.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)
                                clone.Parent = workspace
                            end
                        end
                    end
                    break
                end
            end
        end
    end)
end)
