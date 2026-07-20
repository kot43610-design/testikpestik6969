local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- СОЗДАНИЕ НЕБЛОКИРУЕМОГО 3D МЕНЮ В WORKSPACE
local MenuPart = Instance.new("Part")
MenuPart.Name = "DeltaSafeMenuPart"
MenuPart.Size = Vector3.new(3, 4, 0.2)
MenuPart.Anchored = true
MenuPart.CanCollide = false
MenuPart.Transparency = 1
MenuPart.Parent = workspace

-- Привязка меню к камере игрока, чтобы оно всегда было на экране
RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    if camera then
        MenuPart.CFrame = camera.CFrame * CFrame.new(0, 0, -4) -- Меню висит прямо перед глазами
    end
end)

local SurfaceGui = Instance.new("SurfaceGui")
SurfaceGui.Parent = MenuPart
SurfaceGui.Adornee = MenuPart
SurfaceGui.AlwaysOnTop = true
SurfaceGui.Face = Enum.NormalId.Front
SurfaceGui.CanvasSize = Vector2.new(220, 310)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = SurfaceGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(1, 0, 1, 0)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA 3D MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local ToggleFarm = Instance.new("TextButton")
local TeleportPlayer = Instance.new("TextButton")
local StealBuilds = Instance.new("TextButton")
local LoadBuilds = Instance.new("TextButton")
local KeyInput = Instance.new("TextBox")

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

style(KeyInput, "", 45, true) KeyInput.PlaceholderText = "Введите проверочный текст"
style(ToggleFarm, "Фарм Сокровищ: ЗАБЛОКИРОВАНО", 90, false)
style(TeleportPlayer, "ТП к Игроку", 135, false)
style(StealBuilds, "Украсть Лодку: ЗАБЛОКИРОВАНО", 180, false)
style(LoadBuilds, "Загрузить Лодку: ЗАБЛОКИРОВАНО", 225, false)

-- ОТДЕЛЬНОЕ ОКНО СПИСКА ИГРОКОВ (ТОЖЕ 3D)
local ListPart = Instance.new("Part")
ListPart.Name = "DeltaListPart"
ListPart.Size = Vector3.new(2.5, 3.5, 0.2)
ListPart.Anchored = true
ListPart.CanCollide = false
ListPart.Transparency = 1
ListPart.Parent = workspace

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    if camera then
        ListPart.CFrame = camera.CFrame * CFrame.new(3, 0, -4) -- Список висит справа от основного меню
    end
end)

local ListGui = Instance.new("SurfaceGui")
ListGui.Parent = ListPart
ListGui.Adornee = ListPart
ListGui.AlwaysOnTop = true
ListGui.Face = Enum.NormalId.Front
ListGui.CanvasSize = Vector2.new(180, 240)

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Parent = ListGui
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PlayerListFrame.Size = UDim2.new(1, 0, 1, 0)
PlayerListFrame.Visible = false

local ListTitle = Instance.new("TextLabel")
ListTitle.Parent = PlayerListFrame
ListTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ListTitle.Size = UDim2.new(1, 0, 0, 30)
ListTitle.Font = Enum.Font.SourceSansBold
ListTitle.Text = "ВЫБЕРИТЕ ИГРОКА"
ListTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ListTitle.TextSize = 14

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Parent = PlayerListFrame
ScrollList.BackgroundTransparency = 1
ScrollList.Position = UDim2.new(0, 0, 0, 30)
ScrollList.Size = UDim2.new(1, 0, 1, -30)
ScrollList.ScrollBarThickness = 4

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

local menuUnlocked = false
local farmActive = false
local currentMode = ""
local selectedPlayer = nil

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

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
        if farmActive and menuUnlocked then
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

local function openPlayerList(mode)
    currentMode = mode
    for _, child in ipairs(ScrollList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local PBtn = Instance.new("TextButton")
            PBtn.Size = UDim2.new(0.9, 0, 0, 30)
            PBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            PBtn.Font = Enum.Font.SourceSans
            PBtn.Text = p.DisplayName
            PBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            PBtn.TextSize = 14
            PBtn.Parent = ScrollList
            
            PBtn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                PlayerListFrame.Visible = false
                
                if currentMode == "TP" then
                    pcall(function()
                        if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                myChar.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
                            end
                        end
                    end)
                elseif currentMode == "STEAL" then
                    pcall(function()
                        local targetFolder = nil
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v.Name == "Blocks" and v.Parent:FindFirstChild("Owner") and v.Parent.Owner.Value == selectedPlayer then
                                targetFolder = v
                                break
                            end
                        end
                        if not targetFolder then
                            for _, v in ipairs(workspace:GetChildren()) do
                                if v.Name:find("Zone") and v:FindFirstChild("Owner") and v.Owner.Value == selectedPlayer then
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
                                writefile("boat_" .. selectedPlayer.Name .. ".txt", HttpService:JSONEncode(StolenData))
                                StealBuilds.Text = "Сохранено!"
                                task.wait(1.5)
                                StealBuilds.Text = "Украсть и Сохранить"
                            end
                        end
                    end)
                elseif currentMode == "LOAD" then
                    pcall(function()
                        local filename = "boat_" .. selectedPlayer.Name .. ".txt"
                        if not isfile or not isfile(filename) then return end
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
                                    p.Parent = myZone:FindFirstChild("Blocks") or myZone
                                end)
                            end
                        end
                    end)
                end
            end)
        end
    end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, count * 34)
    PlayerListFrame.Visible = true
end

TeleportPlayer.MouseButton1Click:Connect(function()
    if KeyInput.Text == "Введите ник текст (170xe3)" then
        menuUnlocked = true
        Title.Text = "DELTA UNLOCKED"
        ToggleFarm.Text = "Фарм Сокровищ: ВЫКЛ"
        StealBuilds.Text = "Украсть и Сохранить"
        LoadBuilds.Text = "Загрузить Лодку"
        TeleportPlayer.Text = "Доступ Разрешен!"
        task.wait(1.5)
        TeleportPlayer.Text = "ТП к Игроку"
        return
    end

    if menuUnlocked then
        openPlayerList("TP")
    end
end)

ToggleFarm.MouseButton1Click:Connect(function()
    if not menuUnlocked then return end
    farmActive = not farmActive
    if farmActive then
        ToggleFarm.Text = "Фарм Сокровищ: ВКЛ"
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleFarm.Text = "Фарм Сокровищ: ВЫКЛ"
        ToggleFarm.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end
end)

StealBuilds.MouseButton1Click:Connect(function() if menuUnlocked then openPlayerList("STEAL") end end)
LoadBuilds.MouseButton1Click:Connect(function() if menuUnlocked then openPlayerList("LOAD") end end)
