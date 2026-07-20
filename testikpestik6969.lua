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
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -110)
MainFrame.Size = UDim2.new(0, 220, 0, 220)
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
style(TeleportPlayer, "ТП к Игроку", 135, false)
style(StealBuilds, "Украсть Лодку", 180, false)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

local farmActive = false

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
        
        local targetFolder = nil
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "Blocks" and v.Parent:FindFirstChild("Owner") and v.Parent.Owner.Value == target then
                targetFolder = v
                break
            end
        end
        
        if not targetFolder then
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name:find("Zone") and v:FindFirstChild("Owner") and v.Owner.Value == target then
                    targetFolder = v:FindFirstChild("Blocks") or v
                    break
                end
            end
        end
        
        if targetFolder then
            for _, b in ipairs(targetFolder:GetChildren()) do
                if b:IsA("BasePart") and b.Name ~= "Ice" and b.Name ~= "Water" then
                    local itemPlaced = ReplicatedStorage:FindFirstChild("PlaceBlockEvent") or ReplicatedStorage:FindFirstChild("ItemPlaced")
                    if itemPlaced and itemPlaced:IsA("RemoteEvent") then
                        itemPlaced:FireServer(b.Name, b.Position, b.Rotation, b.Color)
                    else
                        local p = Instance.new("Part")
                        p.Size = b.Size
                        p.Color = b.Color
                        p.Material = b.Material
                        p.Transparency = b.Transparency
                        p.CanCollide = true
                        p.Anchored = true
                        
                        local mc = LocalPlayer.Character
                        if mc and mc:FindFirstChild("HumanoidRootPart") then
                            local myZone = nil
                            for _, z in ipairs(workspace:GetChildren()) do
                                if z.Name:find("Zone") and z:FindFirstChild("Owner") and z.Owner.Value == LocalPlayer then
                                    myZone = z
                                    break
                                end
                            end
                            local myBase = myZone and (myZone:FindFirstChild("Base") or myZone:FindFirstChild("Island"))
                            local targetBase = targetFolder.Parent:FindFirstChild("Base") or targetFolder.Parent:FindFirstChild("Island")
                            
                            if myBase and targetBase then
                                local offset = b.Position - targetBase.Position
                                p.CFrame = myBase.CFrame * CFrame.new(offset)
                                p.Parent = myZone:FindFirstChild("Blocks") or myZone
                            else
                                p.CFrame = mc.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)
                                p.Parent = workspace
                            end
                        end
                    end
                end
            end
        end
    end)
end)
