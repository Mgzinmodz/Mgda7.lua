-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

if not Drawing then
    warn("Executor não suporta Drawing API")
    return
end

-- VARIAVEIS
_G.ESP_Box = false
_G.ESP_Line = false
_G.ESP_Name = false
_G.RainbowESP = false
_G.Aimbot = false

local ESP = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "MG_DELTA"
ScreenGui.ResetOnSpawn = false

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0,70,0,70)
Button.Position = UDim2.new(0.02,0,0.45,0)
Button.Text = "MG"
Button.BackgroundColor3 = Color3.new(0,0,0)
Button.TextColor3 = Color3.new(1,0,0)
Button.Draggable = true

Instance.new("UICorner", Button).CornerRadius = UDim.new(1,0)

local Menu = Instance.new("Frame", ScreenGui)
Menu.Size = UDim2.new(0, 300, 0, 350)
Menu.Position = UDim2.new(0.05,0,0.1,0)
Menu.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true
Instance.new("UICorner", Menu)

Button.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

local function AddButton(text, var, y)
    local b = Instance.new("TextButton", Menu)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    b.TextColor3 = Color3.new(1,1,1)

    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.new(0,1,0) or Color3.new(0.2,0.2,0.2)
    end)
end

AddButton("🟩 ESP BOX", "ESP_Box", 40)
AddButton("🟢 ESP LINE", "ESP_Line", 90)
AddButton("📛 ESP NOME", "ESP_Name", 140)
AddButton("🌈 RAINBOW", "RainbowESP", 190)
AddButton("🎯 AIMBOT", "Aimbot", 240)

-- FUNÇÃO
local function WTS(pos)
    local v, vis = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), vis
end

local function CreateESP(plr)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false

    local line = Drawing.new("Line")
    line.Thickness = 2

    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true

    ESP[plr] = {
        Box = box,
        Line = line,
        Text = text
    }
end

-- LOOP
RunService.RenderStepped:Connect(function()
    
    -- COR ARCO IRIS
    local color = Color3.fromHSV(tick()%5/5,1,1)
    if not _G.RainbowESP then
        color = Color3.new(0,1,0)
    end

    -- AIMBOT SUAVE
    if _G.Aimbot then
        local closest, dist = nil, 9999
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local d = (Camera.CFrame.Position - v.Character.Head.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = v
                end
            end
        end

        if closest then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position),
                0.2
            )
        end
    end

    -- ESP
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            if not ESP[plr] then
                CreateESP(plr)
            end

            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
                
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health <= 0 then
                    ESP[plr].Box.Visible = false
                    ESP[plr].Line.Visible = false
                    ESP[plr].Text.Visible = false
                    continue
                end

                local root = char.HumanoidRootPart
                local head = char.Head

                local rootPos, v1 = WTS(root.Position)
                local headPos, v2 = WTS(head.Position + Vector3.new(0,0.5,0))

                if v1 and v2 then
                    local h = math.abs(headPos.Y - rootPos.Y)
                    local w = h/2

                    -- BOX
                    if _G.ESP_Box then
                        ESP[plr].Box.Size = Vector2.new(w, h)
                        ESP[plr].Box.Position = Vector2.new(rootPos.X - w/2, rootPos.Y - h)
                        ESP[plr].Box.Color = color
                        ESP[plr].Box.Visible = true
                    else
                        ESP[plr].Box.Visible = false
                    end

                    -- LINE
                    if _G.ESP_Line then
                        ESP[plr].Line.From = Vector2.new(Camera.ViewportSize.X/2, 10)
                        ESP[plr].Line.To = headPos
                        ESP[plr].Line.Color = color
                        ESP[plr].Line.Visible = true
                    else
                        ESP[plr].Line.Visible = false
                    end

                    -- NOME + VIDA
                    if _G.ESP_Name then
                        local hp = math.floor(hum.Health)
                        ESP[plr].Text.Text = plr.Name.." ["..hp.."]"
                        ESP[plr].Text.Position = Vector2.new(headPos.X, headPos.Y - 15)
                        ESP[plr].Text.Color = color
                        ESP[plr].Text.Visible = true
                    else
                        ESP[plr].Text.Visible = false
                    end

                else
                    ESP[plr].Box.Visible = false
                    ESP[plr].Line.Visible = false
                    ESP[plr].Text.Visible = false
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESP[plr] then
        ESP[plr].Box:Remove()
        ESP[plr].Line:Remove()
        ESP[plr].Text:Remove()
        ESP[plr] = nil
    end
end)

print("🔥 MG DELTA FULL LOADED")
