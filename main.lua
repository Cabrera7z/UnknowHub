-- [[ UNKNOW HUB - FULL AUTO FARM FUNCTIONAL ]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local userId = player.UserId
local displayName = player.DisplayName

-----------------------------------------------------------
-- 1. IDENTIFICAÇÃO DE SEA
-----------------------------------------------------------
local seaName = "Desconhecido"
if game.PlaceId == 2753915549 then seaName = "Sea 1"
elseif game.PlaceId == 4442245229 then seaName = "Sea 2"
elseif game.PlaceId == 7449423635 then seaName = "Sea 3" end

-----------------------------------------------------------
-- 2. TABELA DE QUESTS (SEA 1)
-----------------------------------------------------------
local QuestsData = {
    {0, "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1547)},
    {10, "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153)},
    {15, "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 36, 153)},
    {30, "PirateVillageQuest", 1, "Pirate", CFrame.new(-1922, 3, 591)},
    {35, "PirateVillageQuest", 2, "Brute", CFrame.new(-1922, 3, 591)},
    {60, "DesertQuest", 1, "Desert Bandit", CFrame.new(896, 6, 4390)},
    {75, "DesertQuest", 2, "Desert Officer", CFrame.new(896, 6, 4390)},
    {90, "SnowQuest", 1, "Snow Bandit", CFrame.new(1384, 87, -1298)},
    {100, "SnowQuest", 2, "Snowman", CFrame.new(1384, 87, -1298)},
    {120, "MarineTreeQuest", 1, "Chief Petty Officer", CFrame.new(-2440, 73, 3999)},
    {150, "SkyQuest", 1, "Sky Bandit", CFrame.new(-1241, 357, -5962)},
    {175, "SkyQuest", 2, "Dark Master", CFrame.new(-1241, 357, -5962)},
    {225, "PrisonQuest", 1, "Prisoner", CFrame.new(5308, 1, 474)},
    {250, "PrisonQuest", 2, "Dangerous Prisoner", CFrame.new(5308, 1, 474)},
    {300, "MagmaQuest", 1, "Military Soldier", CFrame.new(-5315, 12, 8516)},
    {330, "MagmaQuest", 2, "Military Spy", CFrame.new(-5315, 12, 8516)},
    {375, "FishmanQuest", 1, "Fishman Warrior", CFrame.new(61122, 18, 1569)},
    {400, "FishmanQuest", 2, "Fishman Commando", CFrame.new(61122, 18, 1569)},
    {450, "SkyExp1Quest", 1, "God's Guard", CFrame.new(-4721, 845, -1953)},
    {475, "SkyExp1Quest", 2, "Shanda", CFrame.new(-4721, 845, -1953)},
    {525, "SkyExp2Quest", 1, "Royal Squad", CFrame.new(-7906, 1812, -2256)},
    {550, "SkyExp2Quest", 2, "Royal Soldier", CFrame.new(-7906, 1812, -2256)},
    {625, "FountainQuest", 1, "Galley Pirate", CFrame.new(5259, 38, 4050)},
    {650, "FountainQuest", 2, "Galley Captain", CFrame.new(5259, 38, 4050)},
}

function GetCurrentQuest()
    local myLevel = player.Data.Level.Value
    local best = QuestsData[1]
    for _, q in ipairs(QuestsData) do if myLevel >= q[1] then best = q end end
    return best
end

-----------------------------------------------------------
-- 3. FUNÇÕES TÉCNICAS (AUTO EQUIP E VOO)
-----------------------------------------------------------
_G.AutoFarm = false
local TweenService = game:GetService("TweenService")

function TweenTo(target)
    local dist = (rootPart.Position - target.Position).Magnitude
    local speed = 250
    local info = TweenInfo.new(dist/speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, info, {CFrame = target})
    tween:Play()
    return tween
end

function EquipMelee()
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.Name == "Combat") then
            player.Character.Humanoid:EquipTool(tool)
        end
    end
end

-- Estabilizador (Anti-Queda e Anti-Gravidade)
spawn(function()
    while wait() do
        if _G.AutoFarm then
            if not rootPart:FindFirstChild("UnknowVel") then
                local bv = Instance.new("BodyVelocity", rootPart)
                bv.Name = "UnknowVel"
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.new(0,0,0)
            end
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        elseif rootPart:FindFirstChild("UnknowVel") then
            rootPart.UnknowVel:Destroy()
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

-----------------------------------------------------------
-- 4. INTERFACE GRÁFICA (GUI)
-----------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local LeftCol = Instance.new("Frame", MainFrame)
LeftCol.Size = UDim2.new(0, 130, 1, 0)
LeftCol.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", LeftCol)

local RightCol = Instance.new("Frame", MainFrame)
RightCol.Size = UDim2.new(1, -130, 1, 0)
RightCol.Position = UDim2.new(0, 130, 0, 0)
RightCol.BackgroundTransparency = 1

local Abas = {}
function ShowTab(n) for i,v in pairs(Abas) do v.Visible = (i==n) end end

-- Aba Welcome
local Welcome = Instance.new("Frame", RightCol)
Welcome.Size = UDim2.new(1,0,1,0)
Welcome.BackgroundTransparency = 1
Abas["Home"] = Welcome

local Av = Instance.new("ImageLabel", Welcome)
Av.Size = UDim2.new(0,70,0,70)
Av.Position = UDim2.new(0.1,0,0.2,0)
Av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
Instance.new("UICorner", Av).CornerRadius = UDim.new(1,0)

local Txt = Instance.new("TextLabel", Welcome)
Txt.Position = UDim2.new(0.3,0,0.2,0)
Txt.Size = UDim2.new(0.6,0,0.3,0)
Txt.Text = "Olá, "..displayName.."\n"..seaName.."\nUnknow Hub v0.1"
Txt.TextColor3 = Color3.fromRGB(255,255,255)
Txt.BackgroundTransparency = 1
Txt.Font = "GothamMedium"
Txt.TextSize = 16

-- Aba Farm
local Farm = Instance.new("Frame", RightCol)
Farm.Size = UDim2.new(1,0,1,0)
Farm.BackgroundTransparency = 1
Farm.Visible = false
Abas["Farm"] = Farm

local Btn = Instance.new("TextButton", Farm)
Btn.Size = UDim2.new(0.8,0,0,40)
Btn.Position = UDim2.new(0.1,0,0.4,0)
Btn.Text = "AUTO FARM: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Btn.TextColor3 = Color3.fromRGB(255,50,50)
Btn.Font = "GothamBold"
Instance.new("UICorner", Btn)

Btn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    Btn.Text = _G.AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    Btn.TextColor3 = _G.AutoFarm and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

-----------------------------------------------------------
-- 5. LOOP DE AUTO FARM FUNCIONAL
-----------------------------------------------------------
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local q = GetCurrentQuest()
                
                -- Se não tiver quest ativa, vai buscar
                if player.PlayerGui.Main.Quest.Visible == false then
                    TweenTo(q[5])
                    if (rootPart.Position - q[5].Position).Magnitude < 20 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", q[2], q[3])
                    end
                else
                    -- Procura o bicho da quest
                    local enemy = nil
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == q[4] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            enemy = v
                            break
                        end
                    end
                    
                    if enemy then
                        EquipMelee()
                        -- Posiciona em cima do inimigo para evitar bugs de colisão
                        rootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                        
                        -- Bring Mobs
                        for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                            if v.Name == q[4] and v:FindFirstChild("HumanoidRootPart") then
                                if (v.HumanoidRootPart.Position - rootPart.Position).Magnitude < 150 then
                                    v.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, -10, 0)
                                    v.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                        
                        -- Ataque
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    else
                        -- Se os bichos sumirem, vai pro spawn deles
                        TweenTo(q[5] * CFrame.new(0, 30, 0))
                    end
                end
            end)
        end
    end
end)

-- Botões Laterais
local function Add(n, o)
    local b = Instance.new("TextButton", LeftCol)
    b.Size = UDim2.new(1,0,0,40)
    b.Position = UDim2.new(0,0,0,50+(o*40))
    b.Text = n; b.BackgroundTransparency = 1; b.TextColor3 = Color3.fromRGB(200,200,200)
    b.MouseButton1Click:Connect(function() ShowTab(n == "Home" and "Home" or "Farm") end)
end
Add("Home", 0); Add("Auto Farm", 1)
ShowTab("Home")
