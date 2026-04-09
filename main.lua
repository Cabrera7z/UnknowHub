-- AUTO FARM COMPLETO (FUNCIONAL)

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- PLAYER
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- CONFIG
_G.AutoFarm = true
_G.SelectWeapon = "Melee"

-- REFERENCES
local Enemies = workspace:WaitForChild("Enemies")

-- EQUIP
function EquipWeapon(name)
    if plr.Backpack:FindFirstChild(name) then
        char.Humanoid:EquipTool(plr.Backpack[name])
    end
end

function GetWeapon()
    for _,v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == _G.SelectWeapon then
            return v.Name
        end
    end
end

-- TELEPORT
function TP(cf)
    root.CFrame = cf
end

-- ATTACK (ESSENCIAL PRA FUNCIONAR)
function Click()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
end

-- SKILLS
function Skill(key)
    VirtualInputManager:SendKeyEvent(true,key,false,game)
    VirtualInputManager:SendKeyEvent(false,key,false,game)
end

-- CHECK
function Alive(v)
    return v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0
end

-- BRING
function Bring(pos)
    for _,v in pairs(Enemies:GetChildren()) do
        if Alive(v) and v:FindFirstChild("HumanoidRootPart") then
            if (v.HumanoidRootPart.Position - pos).Magnitude < 300 then
                v.HumanoidRootPart.CFrame = CFrame.new(pos)
                v.Humanoid.WalkSpeed = 0
                v.Humanoid.JumpPower = 0
            end
        end
    end
end

-- QUEST (BÁSICO)
function StartQuest()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest","BanditQuest1",1)
    end)
end

-- FARM
task.spawn(function()
    while _G.AutoFarm do
        pcall(function()

            -- garantir arma equipada
            local wep = GetWeapon()
            if wep then
                EquipWeapon(wep)
            end

            -- iniciar quest (simples)
            StartQuest()

            -- loop inimigos
            for _,enemy in pairs(Enemies:GetChildren()) do
                if Alive(enemy) and enemy:FindFirstChild("HumanoidRootPart") then
                    
                    local hrp = enemy.HumanoidRootPart
                    
                    repeat task.wait()
                        Bring(hrp.Position)
                        TP(hrp.CFrame * CFrame.new(0,30,0))
                        
                        -- ataque real
                        Click()
                        Skill("Z")
                        Skill("X")
                        Skill("C")

                    until not Alive(enemy) or not _G.AutoFarm
                end
            end

        end)
    end
end)
