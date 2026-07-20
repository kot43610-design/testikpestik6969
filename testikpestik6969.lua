local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateMenuFixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local targetGui = game:GetService("CoreGui")
if not targetGui or not pcall(function() ScreenGui.Parent = targetGui end) then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Name = "ToggleMenuBtn"
ToggleMenuBtn.Parent = ScreenGui
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleMenuBtn.Size = UDim2.new(0, 80, 0, 40)
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Text = "ОТКРЫТЬ"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.TextSize = 16
ToggleMenuBtn.ZIndex = 1000

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -232)
MainFrame.Size = UDim2.new(0, 240, 0, 465)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 500

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA FINAL HACK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.ZIndex = 501

local ToggleFarm = Instance.new("TextButton")
local ToggleFly = Instance.new("TextButton")
local ToggleSword = Instance.new("TextButton")
local TeleportPlayer = Instance.new("TextButton")
local StealBuilds = Instance.new("TextButton")
local SaveBuilds = Instance.new("TextButton")
local LoadBuilds = Instance.new("TextButton")
local TargetInput = Instance.new("TextBox")
local SpeedInput = Instance.new("TextBox")

local function styleElement(el, text, yPos, isInput)
    el.Parent = MainFrame
    el.Position = UDim2.new(0.05, 0, 0, yPos)
    el.Size = UDim2.new(0.9, 0, 0, 35)
    el.Font = Enum.Font.SourceSans
    el.Text = text
    el.TextSize = 15
    el.ZIndex = 502
    if isInput then
        el.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
        el.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    else
        el.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        el.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

styleElement(TargetInput, "", 50, true) TargetInput.PlaceholderText = "Ник игрока (частично)"
styleElement(SpeedInput, "50", 95, true) SpeedInput.PlaceholderText = "Скорость полета (число)"
styleElement(ToggleFarm, "Авто-Фарм Сокровищ: ВЫКЛ", 140, false)
styleElement(ToggleFly, "Режим Полета: ВЫКЛ", 185, false)
styleElement(ToggleSword, "Авто-Точение Шпаги: ВЫКЛ", 230, false)
styleElement(TeleportPlayer, "ТП к Выбранному Игроку", 275, false)
styleElement(StealBuilds, "Украсть Постройки Игрока", 320, false)
styleElement(SaveBuilds, "Сохранить Постройки в Файл", 365, false)
styleElement(LoadBuilds, "Построить Сохраненную Лодку", 410, false)

ToggleMenuBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = not MainFrame.Visible 
    if MainFrame.Visible then
        ToggleMenuBtn.Text = "ЗАКРЫТЬ"
    else
        ToggleMenuBtn.Text = "ОТКРЫТЬ"
    end
end)

local farmActive = false
local flyActive = false
local swordActive = false
local flySpeed = 50
local StolenBlocksData = {}

SpeedInput.FocusLost:Connect(function()
    local num = tonumber(SpeedInput.Text)
    if num then flySpeed = num else flySpeed = 50 SpeedInput.Text = "50" end
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
                    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            char.Humanoid:EquipTool(item)
                            task.wait(0.01)
                            item:Activate()
                            for _, child in ipairs(item:GetDescendants()) do
                                if child:IsA("RemoteEvent") or child:IsA("BindableEvent") then
                                    child:FireServer()
                                end
                            end
                        end
                    end
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") then
                            item:Activate()
                            for _, child in ipairs(item:GetDescendants()) do
                                if child:IsA("RemoteEvent") or child:IsA("BindableEvent") then
                                    child:FireServer()
                                end
                            end
                        end
                    end
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            local rn = remote.Name:lower()
                            if rn:find("click") or rn:find("sharpen") or rn:find("upgrade") or rn:find("swing") or rn:find("sword") or rn:find("attack") or rn:find("hit") then
                                remote:FireServer()
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.01)
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
        local target = getTargetPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)endendend)end)StealBuilds.MouseButton1Click:Connect(function()pcall(function()local target = getTargetPlayer()if not target then return endlocal targetTeam = target.Teamif not targetTeam then return endStolenBlocksData = {}for _, zone in ipairs(workspace:GetChildren()) doif zone.Name:find("Zone") or zone:FindFirstChild("Blocks") thenlocal ownerValue = zone:FindFirstChild("Owner") or zone:FindFirstChild("Player")if (ownerValue and ownerValue.Value == target) or zone.Name:lower():find(targetTeam.Name:lower()) thenlocal blocks = zone:FindFirstChild("Blocks") or zonefor _, block in ipairs(blocks:GetChildren()) doif block:IsA("BasePart") and block.Name ~= "Ice" and block.Name ~= "Water" thenlocal clone = block:Clone()local localChar = LocalPlayer.Characterif localChar and localChar:FindFirstChild("HumanoidRootPart") thenclone.CFrame = localChar.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)clone.Parent = workspacetable.insert(StolenBlocksData, {Name = block.Name,Pos = {block.Position.X, block.Position.Y, block.Position.Z},Rot = {block.Rotation.X, block.Rotation.Y, block.Rotation.Z},Color = {block.Color.R, block.Color.G, block.Color.B}})endendendStealBuilds.Text = "Успешно скопировано!"task.wait(1)StealBuilds.Text = "Украсть Постройки Игрока"breakendendendend)end)SaveBuilds.MouseButton1Click:Connect(function()if #StolenBlocksData == 0 thenSaveBuilds.Text = "Сначала украдите лодку!"task.wait(1)SaveBuilds.Text = "Сохранить Постройки в Файл"returnendpcall(function()local jsonData = HttpService:JSONEncode(StolenBlocksData)if writefile thenwritefile("stolen_boat.txt", jsonData)SaveBuilds.Text = "Файл saved_boat.txt сохранен!"elseSaveBuilds.Text = "Delta не поддерживает файлы"endtask.wait(1.5)SaveBuilds.Text = "Сохранить Постройки в Файл"end)end)LoadBuilds.MouseButton1Click:Connect(function()pcall(function()local dataString = nilif readfile and isfile and isfile("stolen_boat.txt") thendataString = readfile("stolen_boat.txt")endlocal blocksToBuild = {}if dataString thenblocksToBuild = HttpService:JSONDecode(dataString)elseblocksToBuild = StolenBlocksDataendif #blocksToBuild == 0 thenLoadBuilds.Text = "Нет данных для постройки!"task.wait(1.5)LoadBuilds.Text = "Построить Сохраненную Лодку"returnendlocal myZone = nilfor _, zone in ipairs(workspace:GetChildren()) doif zone.Name:find("Zone") or zone:FindFirstChild("Blocks") thenlocal ownerValue = zone:FindFirstChild("Owner") or zone:FindFirstChild("Player")if (ownerValue and ownerValue.Value == LocalPlayer) or zone.Name:lower():find(LocalPlayer.Team.Name:lower()) thenmyZone = zonebreakendendendif myZone thenlocal targetFolder = myZone:FindFirstChild("Blocks") or myZonelocal basePart = myZone:FindFirstChild("Island") or myZone:FindFirstChild("Base") or myZonefor _, bData in ipairs(blocksToBuild) dopcall(function()local itemEvent = ReplicatedStorage:FindFirstChild("PlaceBlockEvent") or ReplicatedStorage:FindFirstChild("ItemPlaced")if itemEvent and itemEvent:IsA("RemoteEvent") thenitemEvent:FireServer(bData.Name, Vector3.new(unpack(bData.Pos)))elselocal newBlock = Instance.new("Part")newBlock.Name = bData.NamenewBlock.Size = Vector3.new(4, 4, 4)newBlock.Position = basePart.Position + Vector3.new(0, 10, 0)newBlock.Color = Color3.new(unpack(bData.Color))newBlock.Anchored = truenewBlock.Parent = targetFolderendend)endLoadBuilds.Text = "Лодка построена!"elseLoadBuilds.Text = "Ваша зона не найдена!"endtask.wait(1.5)LoadBuilds.Text = "Построить Сохраненную Лодку"end)end)
