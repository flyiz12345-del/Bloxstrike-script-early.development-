-- // OMEGA V5.5 - FINAL STABLE
local P, R, C, LP = game:GetService("Players"), game:GetService("RunService"), workspace.CurrentCamera, game:GetService("Players").LocalPlayer
local U, VIM = game:GetService("UserInputService"), game:GetService("VirtualInputManager")

local _G = { A = true, SA = true, At = true, F = 180, V = true, Ch = true, Tr = true, Sk = true, Sp = false, SpSpeed = 50, Ws = false, WsSpeed = 100, Fly = false, FlySpeed = 50, KA = false, KARange = 50, DesyncActive = false, DesyncMode = "None", StoredPos = nil }
local pE, jerkCounter = {}, 0

local function makeDraggable(topbar, main)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    U.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function GetCenter(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "OmegaFinal"; G.ResetOnSpawn = false
local Main = Instance.new("Frame", G); Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 185, 0, 400), UDim2.new(0.1, 0, 0.4, 0), Color3.new(0.03, 0.03, 0.03)
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.new(1, 0, 0)

local Header = Instance.new("TextLabel", Main); Header.Size, Header.Text = UDim2.new(1, 0, 0, 35), "OMEGA V5.5 [RAGE]"; Header.BackgroundColor3, Header.TextColor3 = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1); makeDraggable(Header, Main)
local TabFrame = Instance.new("Frame", Main); TabFrame.Size, TabFrame.Position, TabFrame.BackgroundTransparency = UDim2.new(1, 0, 1, -40), UDim2.new(0, 0, 0, 40), 1
local L1 = Instance.new("UIListLayout", TabFrame); L1.Padding, L1.HorizontalAlignment = UDim.new(0, 4), 1

local DSMenu = Instance.new("Frame", G); DSMenu.Size, DSMenu.Position, DSMenu.Visible = UDim2.new(0, 170, 0, 220), UDim2.new(0.5, -85, 0.5, -110), false; DSMenu.BackgroundColor3 = Color3.new(0, 0, 0); makeDraggable(DSMenu, DSMenu)
local Ghost = Instance.new("Part", workspace); Ghost.Name = "Omega_Anchor"; Ghost.Size, Ghost.Anchored, Ghost.CanCollide = Vector3.new(4, 5, 2), true, false; Ghost.Material, Ghost.Color, Ghost.Transparency = Enum.Material.Neon, Color3.new(1, 0, 0), 1
local GhostHigh = Instance.new("Highlight", Ghost); GhostHigh.FillColor, GhostHigh.Enabled = Color3.new(1, 0, 0), false

local function ApplyDesync(mode)
    local root = GetCenter(LP.Character)
    if mode == "Delete" then _G.DesyncActive, _G.DesyncMode, Ghost.Transparency, GhostHigh.Enabled = false, "None", 1, false settings().Network.IncomingReplicationLag = 0 return end
    _G.StoredPos, _G.DesyncActive, _G.DesyncMode = root.CFrame, true, mode
    Ghost.CFrame, Ghost.Transparency, GhostHigh.Enabled = _G.StoredPos, (mode == "Invisible" and 1 or 0.4), (mode ~= "Invisible")
end

local function draw(l, p1, p2)
    local d = (p1 - p2).Magnitude
    l.Size, l.Position, l.Rotation, l.Visible = UDim2.new(0, d, 0, 1.5), UDim2.new(0, (p1.X + p2.X)/2 - d/2, 0, (p1.Y + p2.Y)/2), math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X)), true
end

local function Btn(txt, parent, func, toggleVar)
    local b = Instance.new("TextButton", parent); b.Size, b.Text = UDim2.new(0.92, 0, 0, 30), txt; b.BackgroundColor3, b.TextColor3 = Color3.new(0.12, 0.12, 0.12), Color3.new(1, 1, 1)
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() func(); if toggleVar then b.TextColor3 = _G[toggleVar] and Color3.new(1, 0, 0) or Color3.new(1, 1, 1) end end); return b
end

Btn("Spinbot", TabFrame, function() _G.Sp = not _G.Sp end, "Sp")
Btn("Speed Hack", TabFrame, function() _G.Ws = not _G.Ws end, "Ws")
Btn("Fly Hack", TabFrame, function() _G.Fly = not _G.Fly end, "Fly")
Btn("Kill Aura", TabFrame, function() _G.KA = not _G.KA end, "KA")
Btn("Aimbot", TabFrame, function() _G.A = not _G.A end, "A")
Btn("Silent Aim", TabFrame, function() _G.SA = not _G.SA end, "SA")
Btn("Visuals (ESP)", TabFrame, function() _G.V = not _G.V end, "V")
Btn("DESYNC PANEL", TabFrame, function() DSMenu.Visible = not DSMenu.Visible end)

local L2 = Instance.new("UIListLayout", DSMenu); L2.Padding, L2.HorizontalAlignment = UDim.new(0, 5), 1
Btn("Anchor", DSMenu, function() ApplyDesync("Anchor") end)
Btn("Rubber-Band", DSMenu, function() ApplyDesync("Rubber") end)
Btn("Invisible", DSMenu, function() ApplyDesync("Invisible") end)
Btn("DELETE", DSMenu, function() ApplyDesync("Delete") end)

R.RenderStepped:Connect(function()
    local char = LP.Character
    local root = char and GetCenter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    
    if root and hum then
        if _G.Sp then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(_G.SpSpeed), 0) end
        hum.WalkSpeed = _G.Ws and _G.WsSpeed or 16
        if _G.Fly then root.Velocity = Vector3.new(0, 1.5, 0) root.CFrame = root.CFrame + (hum.MoveDirection * (_G.FlySpeed * 0.05)) end
    end

    local target, minD = nil, _G.F
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local tR = GetCenter(p.Character)
            if tR and _G.V then
                local pos, vis = C:WorldToViewportPoint(tR.Position)
                if not pE[p] then pE[p] = {h = Instance.new("Highlight", G)} end
                pE[p].h.Enabled, pE[p].h.Adornee = _G.Ch, p.Character
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minD then target, minD = tR, dist end
                    if _G.KA and root and (tR.Position - root.Position).Magnitude < _G.KARange then
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0) task.wait(0.01) VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                end
            end
        end
    end

    if target and (_G.A or _G.SA) then
        if _G.A then C.CFrame = CFrame.new(C.CFrame.Position, target.Position) end
        if _G.At then VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0) task.wait(0.01) VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0) end
    end
end)

print("Omega V5.5 Fully Loaded!")
