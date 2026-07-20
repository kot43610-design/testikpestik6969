local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

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
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -135)
MainFrame.Size = UDim2.new(0, 220, 0, 270)
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
local LoadBuilds = Instance.new("TextButton")
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
style(StealBuilds, "Украсть и Сохранить", 180, false)
style(LoadBuilds, "Загрузить Скопированное", 225, false)

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
            local StolenData = {}
            local targetBase = targetFolder.Parent:FindFirstChild("Base") or targetFolder.Parent:FindFirstChild("Island")
            
            for _, b in ipairs(targetFolder:GetChildren()) do
                if b:IsA("BasePart") and b.Name ~= "Ice" and b.Name ~= "Water" then
                    local offsetPos = targetBase and (b.Position - targetBase.Position) or Vector3.new(0,0,0)
                    table.insert(StolenData, {
                        Name = b.Name,
                        Offset = {offsetPos.X, offsetPos.Y, offsetPos.Z},
                        Size = {b.Size.X, b.Size.Y, b.Size.Z},
                        Color = {b.Color.R, b.Color.G, b.Color.B},
                        Material = b.Material.Name,
                        Transparency = b.Transparency
                    })
                end
            end
            
            if writefile and #StolenData > 0 then
                local filename = "boat_" .. target.Name .. ".txt"
                writefile(filename, HttpService:JSONEncode(StolenData))
                StealBuilds.Text = "Сохранено: " .. target.Name
                task.wait(1.5)
                StealBuilds.Text = "Украсть и Сохранить"
            else
                StealBuilds.Text = "Ошибка записи файла!"
                task.wait(1.5)
                StealBuilds.Text = "Украсть и Сохранить"
            end
        end
    end)
end)

LoadBuilds.MouseButton1Click:Connect(function()
    pcall(function()
        local target = getTargetPlayer()
        if not target then 
            LoadBuilds.Text = "Введите ник цели!"
            task.wait(1.5)
            LoadBuilds.Text = "Загрузить Скопированное"
            return 
        end
        
        local filename = "boat_" .. target.Name .. ".txt"
        if not isfile or not isfile(filename) then
            LoadBuilds.Text = "Файл лодки не найден!"
            task.wait(1.5)
            LoadBuilds.Text = "Загрузить Скопированное"
            return
        end
        
        local blocksToBuild = HttpService:JSONDecode(readfile(filename))
        local myZone = nil
        for _, z in ipairs(workspace:GetChildren()) do
            if z.Name:find("Zone") and z:FindFirstChild("Owner") and z.Owner.Value == LocalPlayer then
                myZone = z
                break
            end
        end
        
        local myBase = myZone and (myZone:FindFirstChild("Base") or myZone:FindFirstChild("Island"))
        if myBase and #blocksToBuild > 0 then
            for _, bData in ipairs(blocksToBuild) do
                pcall(function()
                    local p = Instance.new("Part")
                    p.Name = bData.Name
                    p.Size = Vector3.new(unpack(bData.Size))
                    p.Color = Color3.new(unpack(bData.Color))
                    p.Material = Enum.Material[bData.Material]
                    p.Transparency = bData.Transparency
                    p.CanCollide = true
                    p.Anchored = true
                    
                    local offset = Vector3.new(unpack(bData.Offset))
p.CFrame = myBase.CFrame * CFrame.new(offset)
                                p.Parent = myZone:FindFirstChild("Blocks") or myZoneend)
                            end
                            LoadBuilds.Text = "Успешно загружено!"
                        else
                        LoadBuilds.Text = "Ваша зона не найдена!"
                        end
                    task.wait(1.5)
                    LoadBuilds.Text = "Загрузить Скопированное"
                    end)
        end)
