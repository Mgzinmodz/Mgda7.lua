-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "MG"
ScreenGui.ResetOnSpawn = false

-- BOTÃO
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0,70,0,70)
Button.Position = UDim2.new(0.02,0,0.45,0)
Button.Text = "MG"
Button.BackgroundColor3 = Color3.new(0,0,0)
Button.TextColor3 = Color3.new(1,0,0)
Button.Draggable = true

-- VARS
_G.ESP_Box = false
_G.ESP_Line = false

local ESP = {}

-- CRIAR ESP
local function CreateESP(plr)
    if plr == Player then return end

    local box = Instance.new("BoxHandleAdornment")
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4,6,2)
    box.Color3 = Color3.new(0,1,0)
    box.Transparency = 0.5
    box.Parent = Workspace

    local line = Instance.new("Beam")
    line.Color = ColorSequence.new(Color3.new(1,0,0))
    line.Width0 = 0.1
    line.Width1 = 0.1

    local att0 = Instance.new("Attachment", Workspace.Terrain)
    local att1 = Instance.new("Attachment", Workspace.Terrain)

    line.Attachment0 = att0
    line.Attachment1 = att1
    line.Parent = Workspace

    ESP[plr] = {
        Box = box,
        Line = line,
        A0 = att0,
        A1 = att1
    }
end

-- UPDATE
local function UpdateESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            if not ESP[plr] then
                CreateESP(plr)
            end

            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart

                -- BOX
                ESP[plr].Box.Adornee = hrp
                ESP[plr].Box.Visible = _G.ESP_Box

                -- LINE
                ESP[plr].A0.WorldPosition = Camera.CFrame.Position
                ESP[plr].A1.WorldPosition = hrp.Position
                ESP[plr].Line.Enabled = _G.ESP_Line
            else
                ESP[plr].Box.Visible = false
                ESP[plr].Line.Enabled = false
            end
        end
    end
end

RunService.Heartbeat:Connect(UpdateESP)

-- BOTÃO TOGGLE
Button.MouseButton1Click:Connect(function()
    _G.ESP_Box = not _G.ESP_Box
    _G.ESP_Line = not _G.ESP_Line
end)

print("✅ ESP FULL FUNCIONANDO")
