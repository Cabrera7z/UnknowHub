-- [[ UNKNOW HUB V0.2 - FULL VERSION (SEA 1, 2, 3 + GUI + ANTI-STAFF) ]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Configurações Globais
_G.AutoFarm = false
_G.BringMobs = true
_G.FastAttack = true
_G.AntiStaff = true

-----------------------------------------------------------
-- 1. SISTEMA DE SEGURANÇA (HOP & ANTI-STAFF)
-----------------------------------------------------------
function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    if Site.data then
        for i,v in pairs(Site.data) do
            if v.id ~= game.JobId and v.playing < v.maxPlayers then
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, v.id, player)
                break
            end
        end
    end
end

spawn(function()
    while wait(2) do
        if _G.AntiStaff then
            for i,v in pairs(game.Players:GetPlayers()) do
                -- Lista completa de Admins extraída do seu TXT
                local admins = {"red_game43", "rip_indra", "Axiore", "Polkster", "wenlocktoad", "Daigrock", "Uzoth", "Azarth", "Death_King"}
                for _, admin in pairs(admins) do
                    if v.Name == admin then Hop() end
                end
            end
        end
    end
end)

-----------------------------------------------------------
-- 2. TABELA DE QUESTS (SEA 1, 2 E 3 - TODOS OS NÍVEIS)
-----------------------------------------------------------
function CheckQuest()
    local MyLevel = player.Data.Level.Value
    -- SEA 1
    if game.PlaceId == 2753915549 then
        if MyLevel >= 1 and MyLevel <= 9 then return "Bandit", 1, "BanditQuest1", CFrame.new(1059.37, 15.44, 1550.42)
        elseif MyLevel >= 10 and MyLevel <= 14 then return "Monkey", 1, "JungleQuest", CFrame.new(-1598.08, 36.85, 153.07)
        elseif MyLevel >= 15 and MyLevel <= 29 then return "Gorilla", 2, "JungleQuest", CFrame.new(-1598.08, 36.85, 153.07)
        elseif MyLevel >= 30 and MyLevel <= 34 then return "Pirate", 1, "PirateVillageQuest", CFrame.new(-1922.65, 5.54, 600.84)
        elseif MyLevel >= 35 and MyLevel <= 59 then return "Brute", 2, "PirateVillageQuest", CFrame.new(-1922.65, 5.54, 600.84)
        elseif MyLevel >= 60 and MyLevel <= 74 then return "Desert Bandit", 1, "DesertQuest", CFrame.new(894.48, 6.43, 4392.43)
        elseif MyLevel >= 75 and MyLevel <= 89 then return "Desert Officer", 2, "DesertQuest", CFrame.new(894.48, 6.43, 4392.43)
        elseif MyLevel >= 90 and MyLevel <= 99 then return "Snow Bandit", 1, "SnowQuest", CFrame.new(1389.74, 87.32, -1297.90)
        elseif MyLevel >= 100 and MyLevel <= 119 then return "Snowman", 2, "SnowQuest", CFrame.new(1389.74, 87.32, -1297.90)
        elseif MyLevel >= 120 and MyLevel <= 149 then return "Chief Petty Officer", 1, "MarineTreeQuest", CFrame.new(-2440.85, 73.01, 3999.03)
        elseif MyLevel >= 150 and MyLevel <= 174 then return "Sky Bandit", 1, "SkyQuest", CFrame.new(-1241.38, 357.51, -5962.33)
        elseif MyLevel >= 175 and MyLevel <= 194 then return "Dark Master", 2, "SkyQuest", CFrame.new(-1241.38, 357.51, -5962.33)
        elseif MyLevel >= 195 and MyLevel <= 224 then return "Toga Warrior", 1, "SkyQuest", CFrame.new(-1241.38, 357.51, -5962.33)
        elseif MyLevel >= 225 and MyLevel <= 249 then return "Prisoner", 1, "PrisonQuest", CFrame.new(5307.49, 1.25, 475.31)
        elseif MyLevel >= 250 and MyLevel <= 299 then return "Dangerous Prisoner", 2, "PrisonQuest", CFrame.new(5307.49, 1.25, 475.31)
        elseif MyLevel >= 300 and MyLevel <= 324 then return "Military Soldier", 1, "MagmaQuest", CFrame.new(-5310.28, 12.21, 8515.11)
        elseif MyLevel >= 325 and MyLevel <= 374 then return "Military Spy", 2, "MagmaQuest", CFrame.new(-5310.28, 12.21, 8515.11)
        elseif MyLevel >= 375 and MyLevel <= 399 then return "Fishman Warrior", 1, "FishmanQuest", CFrame.new(61122.65, 18.49, 1568.16)
        elseif MyLevel >= 400 and MyLevel <= 449 then return "Fishman Commando", 2, "FishmanQuest", CFrame.new(61122.65, 18.49, 1568.16)
        elseif MyLevel >= 450 and MyLevel <= 474 then return "God's Guard", 1, "SkyExp1Quest", CFrame.new(-4721.56, 845.27, -1953.94)
        elseif MyLevel >= 475 and MyLevel <= 524 then return "Shanda", 2, "SkyExp1Quest", CFrame.new(-4721.56, 845.27, -1953.94)
        elseif MyLevel >= 525 and MyLevel <= 549 then return "Royal Squad", 1, "SkyExp2Quest", CFrame.new(-7906.84, 1812.35, -2256.32)
        elseif MyLevel >= 550 and MyLevel <= 624 then return "Royal Soldier", 2, "SkyExp2Quest", CFrame.new(-7906.84, 1812.35, -2256.32)
        elseif MyLevel >= 625 and MyLevel <= 649 then return "Galley Pirate", 1, "FountainQuest", CFrame.new(5259.82, 38.50, 4050.02)
        elseif MyLevel >= 650 then return "Galley Captain", 2, "FountainQuest", CFrame.new(5259.82, 38.50, 4050.02)
        end
    -- SEA 2 (Muitos níveis a mais)
    elseif game.PlaceId == 4442272183 then
        if MyLevel >= 700 and MyLevel <= 724 then return "Raider", 1, "RaiderQuest1", CFrame.new(-424.11, 7.37, 1836.01)
        elseif MyLevel >= 725 and MyLevel <= 774 then return "Mercenary", 2, "RaiderQuest1", CFrame.new(-424.11, 7.37, 1836.01)
        elseif MyLevel >= 775 and MyLevel <= 799 then return "Swan Pirate", 1, "SwanQuest", CFrame.new(1038.11, 33.11, 1213.91)
        elseif MyLevel >= 800 and MyLevel <= 824 then return "Snow Soldier", 1, "FreezingQuest", CFrame.new(-1327.31, 15.02, -4580.05)
        elseif MyLevel >= 825 and MyLevel <= 899 then return "Winter Warrior", 2, "FreezingQuest", CFrame.new(-1327.31, 15.02, -4580.05)
        elseif MyLevel >= 900 and MyLevel <= 924 then return "Lab Subordinate", 1, "FireQuest", CFrame.new(-2633.91, 15.93, -5334.61)
        elseif MyLevel >= 925 and MyLevel <= 949 then return "Horned Riot", 2, "FireQuest", CFrame.new(-2633.91, 15.93, -5334.61)
        elseif MyLevel >= 950 and MyLevel <= 974 then return "Magma Ninja", 1, "LavaQuest", CFrame.new(-5428.85, 15.93, -5299.11)
        elseif MyLevel >= 975 and MyLevel <= 1000 then return "Lava Pirate", 2, "LavaQuest", CFrame.new(-5428.85, 15.93, -5299.11)
        elseif MyLevel >= 1100 and MyLevel <= 1124 then return "Scary Zombie", 1, "ZombieQuest", CFrame.new(-5428.85, 15.93, -5299.11)
        elseif MyLevel >= 1425 then return "Arctic Warrior", 1, "IcyQuest", CFrame.new(5663, 27, -6483)
        end
    -- SEA 3
    elseif game.PlaceId == 7449423635 then
        if MyLevel >= 1500 and MyLevel <= 1524 then return "Pirate Millionaire", 1, "PiratePortQuest1", CFrame.new(-290.07, 43.90, 5581.58)
        elseif MyLevel >= 1525 and MyLevel <= 1574 then return "Pistol Billionaire", 2, "PiratePortQuest1", CFrame.new(-290.07, 43.90, 5581.58)
        elseif MyLevel >= 2450 then return "Sun-Kissed Warrior", 1, "TikiQuest", CFrame.new(-15494, 15, 66)
        end
    end
end

-----------------------------------------------------------
-- 3. MOTOR DO SCRIPT (FISICA E COMBATE)
-----------------------------------------------------------
function TweenTo(target)
    local dist = (rootPart.Position - target.Position).Magnitude
    local tween = game:GetService("TweenService"):Create(rootPart, TweenInfo.new(dist/250, Enum.EasingStyle.Linear), {CFrame = target})
    tween:Play()
    return tween
end

spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local Mon, ID, NameQuest, CFrameQuest = CheckQuest()
                if player.PlayerGui.Main.Quest.Visible == false then
                    TweenTo(CFrameQuest)
                    if (rootPart.Position - CFrameQuest.Position).Magnitude < 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, ID)
                    end
                else
                    local target = nil
                    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == Mon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            target = v; break
                        end
                    end
                    if target then
                        for _, tool in pairs(player.Backpack:GetChildren()) do
                            if tool.ToolTip == "Melee" then player.Character.Humanoid:EquipTool(tool) end
                        end
                        -- Posição Anti-Bug
                        rootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        -- Bring Mobs
                        if _G.BringMobs then
                            for _, m in pairs(game.Workspace.Enemies:GetChildren()) do
                                if m.Name == Mon and m:FindFirstChild("HumanoidRootPart") then
                                    m.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
                                    m.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                        -- Ataque
                        player.Character:FindFirstChildOfClass("Tool"):Activate()
                        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                    else
                        TweenTo(CFrameQuest * CFrame.new(0, 40, 0))
                    end
                end
            end)
        end
    end
end)

-----------------------------------------------------------
-- 4. INTERFACE GRÁFICA (GUI COMPLETA)
-----------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 280)
Main.Position = UDim2.new(0.5, -225, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local SideBar = Instance.new("Frame", Main)
SideBar.Size = UDim2.new(0, 120, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", SideBar)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -120, 0, 40)
Title.Position = UDim2.new(0, 120, 0, 0)
Title.Text = "UNKNOW HUB V0.2"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.BackgroundTransparency = 1; Title.Font = "GothamBold"

-- Botão Auto Farm
local FarmBtn = Instance.new("TextButton", Main)
FarmBtn.Size = UDim2.new(0, 200, 0, 45)
FarmBtn.Position = UDim2.new(0, 185, 0, 100)
FarmBtn.Text = "AUTO FARM: OFF"
FarmBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FarmBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
FarmBtn.Font = "GothamBold"
Instance.new("UICorner", FarmBtn)

FarmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    FarmBtn.Text = _G.AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    FarmBtn.TextColor3 = _G.AutoFarm and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

-- Anti-AFK (Impedir desconexão)
player.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("Unknow Hub carregado com Sea 1, 2 e 3!")

