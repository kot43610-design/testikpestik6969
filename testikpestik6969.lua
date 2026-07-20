local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMobileFinalMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenBtn.Position = UDim2.new(0, 10, 0, 70)
OpenBtn.Size = UDim2.new(0, 70, 0, 35)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Text = "МЕНЮ"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 14
OpenBtn.Visible = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -175)
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA FIXED MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local ToggleFarm = Instance.new("TextButton")
local ToggleFly = Instance.new("TextButton")
local ToggleSword = Instance.new("TextButton")
local TeleportPlayer = Instance.new("TextButton")
local StealBuilds = Instance.new("TextButton")
local KillAllBtn = Instance.new("TextButton")
local TargetInput = Instance.new("TextBox")

local function style(el, text, y, isInput)
    el.Parent = MainFrame
    el.Position = UDim2.new(0.05, 0, 0, y)
    el.Size = UDim2.new(0.9, 0, 0, 35)
    el.Font = Enum.Font.SourceSans
    el.Text = text
    el.TextSize = 14
    if isInput then
        el.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
        el.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    else
        el.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

style(TargetInput, "", 45, true) TargetInput.PlaceholderText = "Ник (частично)"
style(ToggleFarm, "Фарм Сокровищ: ВЫКЛ", 90, false)
style(ToggleFly, "Полет (Камера): ВЫКЛ", 135, false)
style(ToggleSword, "Заточка Шпаги: ВЫКЛ", 180, false)
style(TeleportPlayer, "ТП к Игроку", 225, false)
style(StealBuilds, "Украсть Лодку", 270, false)
style(KillAllBtn, "Убить Всех", 315, false)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

local farmActive = false
local flyActive = false
local swordActive = false
local flySpeed = 55

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
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
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
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
            local lookVector = camera.CFrame.LookVector
            local sideVector = camera.CFrame.RightVector
            BodyVelocity.Velocity = lookVector * (char.Humanoid.MoveDirection.Z * -flySpeed) + sideVector * (char.Humanoid.MoveDirection.X * flySpeed)
            if char.Humanoid.MoveDirection.Z == 0 and char.Humanoid.MoveDirection.X == 0 then
                 BodyVelocity.Velocity = moveDirection * flySpeed
            end
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
        ToggleFly.Text = "Полет (Камера): ВКЛ"
        ToggleFly.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleFly.Text = "Полет (Камера): ВЫКЛ"
        ToggleFly.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
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
        ToggleSword.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
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

StealBuilds.MouseButton1Click:Connect(function()
    pcall(function()
        local target = getTargetPlayer()
        if not target then return end
        
        local targetModel = nil
        for _, v in ipairs(workspace:GetChildren()) do
            if v.Name:find("Zone") and v:FindFirstChild("Owner") and v.Owner.Value == target then
                targetModel = v
                break
            end
        end
        
        if not targetModel then
            for _, v in ipairs(workspace:GetDescendants()) do
                    if v.Name == "Blocks" and v.Parent:FindFirstChild("Owner") and v.Parent.Owner.Value == target then
                        targetModel = v.Parent
                        break
                    end
                end
            end
            
            if targetModel then
                local blocksFolder = targetModel:FindFirstChild("Blocks") or targetModel
                local basePart = targetModel:FindFirstChild("Base") or targetModel:FindFirstChild("Island") or targetModel.PrimaryPart
                
                for _, b in ipairs(blocksFolder:GetChildren()) do
                    if b:IsA("BasePart") and b.Name ~= "Ice" and b.Name ~= "Water" and basePart then
                        local p = Instance.new("Part")
                        p.Size = b.Size
                        p.Color = b.Color
                        p.Material = b.Material
                        p.Transparency = b.Transparency
                        p.CanCollide = true
                        p.Anchored = true
                        
                        local mc = LocalPlayer.Character
                        if mc and mc:FindFirstChild("HumanoidRootPart") then
                            local offset = b.Position - basePart.Position
                            p.CFrame = mc.HumanoidRootPart.CFrame * CFrame.new(offset) + Vector3.new(0, 10, -20)
                            p.Parent = workspace
                        end
                    end
                end
            end
        end)
    end)

    KillAllBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            
            local oldCFrame = myRoot.CFrame
            local tool = nil
            
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") then tool = item break end
            end
            if not tool then
                for _, item in ipairs(myChar:GetChildren()) do
                    if item:IsA("Tool") then tool = item break end
                end
            end
            
            if tool then
                if tool.Parent == LocalPlayer.Backpack then
                    myChar.Humanoid:EquipTool(tool)
                end
                
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and p.Character:FindFirstChild("HumanoidRootPart") then
                        myRoot.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        task.wait(0.06)
                        tool:Activate()
                        
                        local hitEvent = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChild("RemoteEvent")
                        if hitEvent then
                            hitEvent:FireServer(p.Character.HumanoidRootPart)
                        end
                    end
                end
                myRoot.CFrame = oldCFrame
            end
        end)
    end)
