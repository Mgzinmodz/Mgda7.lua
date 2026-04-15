-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

-- // GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- BOTÃO MG
local ButtonMG = Instance.new("TextButton")
ButtonMG.Parent = ScreenGui
ButtonMG.Size = UDim2.new(0,70,0,70)
ButtonMG.Position = UDim2.new(0.02,0,0.45,0)
ButtonMG.Text = "MG"
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)

-- MENU
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0,350,0,300)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainMenu.Visible = false
MainMenu.Draggable = true

-- VARS
_G.Aimbot = false
_G.ShowFOV = false
_G.FOV = 150
_G.ESP = false

-- BOTÃO ABRIR
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

-- FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = false

-- ESP
local ESPCache = {}

local function CreateESP(plr)
    if plr == Player then return end

    ESPCache[plr] = {
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line")
    }

    local esp = ESPCache[plr]

    esp.Box.Color = Color3.fromRGB(0,255,0)
    esp.Box.Thickness = 2
    esp.Box.Filled = false

    esp.Line.Color = Color3.fromRGB(0,255,0)
    esp.Line.Thickness = 2
end

local function UpdateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then

            if not ESPCache[plr] then
                CreateESP(plr)
            end

            local esp = ESPCache[plr]
            local char = plr.Character

            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart

                local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

                if visible and _G.ESP then
                    local size = 1000 / pos.Z

                    esp.Box.Size = Vector2.new(size, size*1.5)
                    esp.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                    esp.Box.Visible = true

                    esp.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.Line.To = Vector2.new(pos.X, pos.Y)
                    esp.Line.Visible = true
                else
                    esp.Box.Visible = false
                    esp.Line.Visible = false
                end
            end
        end
    end
end

-- AIMBOT
RunService.RenderStepped:Connect(function()

    -- FOV
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local closest = nil
        local dist = math.huge

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, visible = Camera:WorldToViewportPoint(v.Character.Head.Position)

                if visible then
                    local mag = (Vector2.new(pos.X,pos.Y) - FOVCircle.Position).Magnitude
                    if mag < dist and mag < _G.FOV then
                        dist = mag
                        closest = v
                    end
                end
            end
        end

        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
        end
    end
end)

RunService.RenderStepped:Connect(UpdateESP)

-- 3 DEDOS
local touches = {}
UserInputService.TouchStarted:Connect(function(i,g)
    if g then return end
    touches[i] = true

    local count = 0
    for _ in pairs(touches) do count += 1 end

    if count >= 3 then
        ScreenGui.Enabled = not ScreenGui.Enabled
        touches = {}
    end
end)

UserInputService.TouchEnded:Connect(function(i)
    touches[i] = nil
end)

print("✅ SCRIPT FULL FUNCIONANDO")
