-- AUTO FARM FINAL (CORRIGIDO + GUI)

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- PLAYER
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- VAR
local Enemies = workspace:WaitForChild("Enemies")
_G.AutoFarm = false
_G.SelectWeapon = "Melee"

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "AutoFarmGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1,0,1,0)
button.Text = "AUTO FARM: OFF"
button.TextColor3 = Color3.fromRGB(255,255,255)
button.BackgroundColor3 = Color3.fromRGB(40,40,40)

--------------------------------------------------
-- FUNÇÕES
--------------------------------------------------

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

-- ATAQUE REAL
function Attack()
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

-- SKILL
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

--------------------------------------------------
-- AUTO FARM LOOP
--------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()

                -- equip arma
                local wep = GetWeapon()
                if wep then
                    EquipWeapon(wep)
                end

                for _,enemy in pairs(Enemies:GetChildren()) do
                    if Alive(enemy) and enemy:FindFirstChild("HumanoidRootPart") then
                        
                        local hrp = enemy.HumanoidRootPart

                        repeat task.wait(0.15)
                            if not _G.AutoFarm then break end

                            -- posição fixa (IMPORTANTE)
                            root.CFrame = hrp.CFrame * CFrame.new(0,0,3)

                            -- bring mobs
                            Bring(hrp.Position)

                            -- ataque real
                            Attack()

                            -- skills com delay
                            Skill("Z")
                            task.wait(0.2)
                            Skill("X")

                        until not Alive(enemy)

                    end
                end

            end)
        end
    end
end)

--------------------------------------------------
-- BOTÃO
--------------------------------------------------
button.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    
    if _G.AutoFarm then
        button.Text = "AUTO FARM: ON"
        button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        button.Text = "AUTO FARM: OFF"
        button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    end
end)
