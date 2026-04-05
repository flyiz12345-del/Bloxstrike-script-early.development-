-- // OMEGA V13 - BLINK-STEP (MOVEMENT RESOLVED)
local P = game:GetService("Players")
local R = game:GetService("RunService")
local C = workspace.CurrentCamera
local LP = P.LocalPlayer
local U = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local _G = { 
    A = true, SA = true, F = 180, 
    V = true, Ch = true, Tr = true, Sk = true,
    Sp = false, Ws = false, Fly = false, KA = false,
    DesyncActive = false, DesyncMode = "None", StoredPos = nil
}
local pE, jerkCounter = {}, 0

-- // CLEANUP
P.PlayerRemoving:Connect(function(player)
    if pE[player] then
        for _, v in pairs(pE[player]) do if v and v.Destroy then v:Destroy() end end
        pE[player] = nil
    end
end)

-- // DRAGGING
local function makeDraggable(main)
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

-- // UI SETUP
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "OmegaV13"; G.ResetOnSpawn = false

local MiniGhost = Instance.new("TextButton", G)
MiniGhost.Size, MiniGhost.Position = UDim2.new(0, 45, 0, 45), UDim2.new(0.5, 0, 0.1, 0)
MiniGhost.Text, MiniGhost.TextSize, MiniGhost.Visible = "👻", 25, false
MiniGhost.BackgroundColor3, MiniGhost.BackgroundTransparency = Color3.new(0,0,0), 0.3
MiniGhost.Modal, MiniGhost.Selectable = false, false
Instance.new("UICorner", MiniGhost).CornerRadius = UDim.new(1, 0)
makeDraggable(MiniGhost)

local DesyncWin = Instance.new("Frame", G)
DesyncWin.Size, DesyncWin.Position = UDim2.new(0, 180, 0, 200), UDim2.new(0.5, -90, 0.5, -100)
DesyncWin.BackgroundColor3, DesyncWin.BorderSizePixel, DesyncWin.Visible = Color3.fromRGB(15, 15, 15), 0, false
DesyncWin.Active, DesyncWin.Selectable = true, false
local WinStroke = Instance.new("UIStroke", DesyncWin)
WinStroke.Color, WinStroke.Thickness = Color3.fromRGB(0, 170, 255), 1.5
Instance.new("UICorner", DesyncWin)

local WinHeader = Instance.new("TextLabel", DesyncWin)
WinHeader.Size, WinHeader.Text = UDim2.new(1, 0, 0, 30), "  DESYNC.NL"
WinHeader.BackgroundColor3, WinHeader.TextColor3 = Color3.fromRGB(25, 25, 25), Color3.new(1, 1, 1)
WinHeader.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", WinHeader)
makeDraggable(DesyncWin)

local MinBtn = Instance.new("TextButton", WinHeader)
MinBtn.Size, MinBtn.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0, 0)
MinBtn.Text, MinBtn.TextColor3, MinBtn.BackgroundTransparency = "-", Color3.new(1,1,1), 1
MinBtn.Modal, MinBtn.Selectable = false, false

local Sidebar = Instance.new("Frame", G)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3 = UDim2.new(0, 50, 0, 260), UDim2.new(0, 20, 0.5, -130), Color3.new(0.05, 0.05, 0.05)
Sidebar.Active, Sidebar.Selectable = true, false
Instance.new("UICorner", Sidebar); Instance.new("UIStroke", Sidebar).Color = Color3.new(0, 0.7, 1)
makeDraggable(Sidebar)

local function CreatePanel(y)
    local p = Instance.new("Frame", Sidebar)
    p.Size, p.Position, p.Visible = UDim2.new(0, 140, 0, 200), UDim2.new(1, 10, 0, y), false
    p.BackgroundColor3, p.Active, p.Selectable = Color3.new(0, 0, 0), true, false
    Instance.new("UICorner", p); Instance.new("UIStroke", p).Color = Color3.new(0, 0.7, 1)
    Instance.new("UIListLayout", p).Padding, p.UIListLayout.HorizontalAlignment = UDim.new(0, 4), 1
    return p 
end
local AimP, VisP, RageP = CreatePanel(-80), CreatePanel(0), CreatePanel(40)

local function Ico(s, pn, y)
    local b = Instance.new("TextButton", Sidebar)
    b.Size, b.Position, b.Text = UDim2.new(0, 36, 0, 36), UDim2.new(0.5, -18, 0, y), s
    b.BackgroundColor3, b.TextColor3, b.Modal, b.Selectable = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1), false, false
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() AimP.Visible, VisP.Visible, RageP.Visible, DesyncWin.Visible = false, false, false, false; if pn then pn.Visible = not pn.Visible end end)
end

local function Opt(n, v, p, func)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text = UDim2.new(0.9, 0, 0, 30), n
    b.BackgroundColor3, b.TextColor3, b.Modal, b.Selectable = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1), false, false
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() if func then func() else _G[v] = not _G[v] end; b.TextColor3 = (_G[v] or (v == nil)) and Color3.new(0, 1, 0) or Color3.new(1, 1, 1) end)
end

Ico("🎯", AimP, 15) Ico("👁️", VisP, 65) Ico("😡", RageP, 115) Ico("👻", DesyncWin, 165)
MinBtn.MouseButton1Click:Connect(function() DesyncWin.Visible = false; MiniGhost.Visible = true end)
MiniGhost.MouseButton1Click:Connect(function() MiniGhost.Visible = false; DesyncWin.Visible = true end)

local DL = Instance.new("UIListLayout", DesyncWin); DL.Padding, DL.HorizontalAlignment = UDim.new(0, 5), 1
Instance.new("Frame", DesyncWin).Size, DesyncWin.Frame.BackgroundTransparency = UDim2.new(1, 0, 0, 35), 1
Opt("Anchor Mode", nil, DesyncWin, function() ApplyDesync("Anchor") end)
Opt("Invisible Mode", nil, DesyncWin, function() ApplyDesync("Invisible") end)
Opt("Rubber-Band", nil, DesyncWin, function() ApplyDesync("Rubber") end)
Opt("SYNC / DELETE", nil, DesyncWin, function() ApplyDesync("Delete") end)

Opt("Aimbot", "A", AimP) Opt("Silent Aim", "SA", AimP)
Opt("Master ESP", "V", VisP) Opt("Green Chams", "Ch", VisP) Opt("White Skelly", "Sk", VisP) Opt("White Tracers", "Tr", VisP)
Opt("Spinbot", "Sp", RageP) Opt("Fly Hack", "Fly", RageP) Opt("Speed Hack", "Ws", RageP) Opt("Kill Aura", "KA", RageP)

-- // GHOST VISUAL
local Ghost = Instance.new("Part", workspace); Ghost.Name = "Omega_Anchor"; Ghost.Size, Ghost.Anchored, Ghost.CanCollide = Vector3.new(4, 5, 2), true, false; Ghost.Material, Ghost.Color, Ghost.Transparency = Enum.Material.Neon, Color3.new(1, 0, 0), 1
local GhostHigh = Instance.new("Highlight", Ghost); GhostHigh.FillColor, GhostHigh.Enabled = Color3.new(1, 0, 0), false

function ApplyDesync(mode)
    local root = GetCenter(LP.Character)
    if mode == "Delete" then
        _G.DesyncActive, _G.DesyncMode, Ghost.Transparency, GhostHigh.Enabled = false, "None", 1, false
        return
    end
    if root then _G.StoredPos = root.CFrame end
    _G.DesyncActive, _G.DesyncMode = true, mode
    Ghost.CFrame, Ghost.Transparency, GhostHigh.Enabled = _G.StoredPos or CFrame.new(), (mode == "Invisible" and 1 or 0.4), (mode ~= "Invisible")
end

-- // RENDER RUNTIME
R.RenderStepped:Connect(function()
    local char, center = LP.Character, Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    local root = GetCenter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    -- // THE BLINK-STEP LOGIC
    if _G.DesyncActive and root and _G.StoredPos then
        jerkCounter = (jerkCounter + 1) % 12 -- Pulse every 12 frames
        if jerkCounter == 0 then
            -- Store current walk pos, snap to ghost for ONE frame
            local original = root.CFrame
            root.CFrame = _G.StoredPos
            root.Velocity = Vector3.new(0, 0, 0)
            -- Snap back happens automatically next frame because we stop forcing CFrame
        end
    end

    -- Movement Rage
    if root and hum then
        if _G.Sp then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0) end
        hum.WalkSpeed = _G.Ws and 100 or 16
        if _G.Fly then root.Velocity = Vector3.new(0, 1.5, 0); root.CFrame = root.CFrame + (hum.MoveDirection * 2.5) end
    end

    -- Visuals (Green/White Classic)
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            if not pE[p] then 
                pE[p] = {h = Instance.new("Highlight", G), tr = (function() local f = Instance.new("Frame", G); f.BorderSizePixel, f.Visible, f.ZIndex = 0, false, 1; f.BackgroundColor3 = Color3.new(1, 1, 1); return f end)(), sk = (function() local f = Instance.new("Frame", G); f.BorderSizePixel, f.Visible, f.ZIndex = 0, false, 1; f.BackgroundColor3 = Color3.new(1, 1, 1); return f end)()}
            end
            local e, tR = pE[p], GetCenter(p.Character)
            local tH = p.Character:FindFirstChild("Head")
            if tR and _G.V then
                local pos, vis = C:WorldToViewportPoint(tR.Position)
                e.h.Enabled, e.h.Adornee, e.h.FillColor = _G.Ch, p.Character, Color3.new(0, 1, 0)
                if vis then
                    if _G.Tr then 
                        local d = (Vector2.new(center.X, C.ViewportSize.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                        e.tr.Size, e.tr.Position, e.tr.Rotation, e.tr.Visible = UDim2.new(0, d, 0, 1.5), UDim2.new(0, (center.X + pos.X)/2 - d/2, 0, (C.ViewportSize.Y + pos.Y)/2), math.deg(math.atan2(pos.Y - C.ViewportSize.Y, pos.X - center.X)), true
                    else e.tr.Visible = false end
                    if _G.Sk and tH then
                        local headPos = C:WorldToViewportPoint(tH.Position)
                        local d = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                        e.sk.Size, e.sk.Position, e.sk.Rotation, e.sk.Visible = UDim2.new(0, d, 0, 1.5), UDim2.new(0, (headPos.X + pos.X)/2 - d/2, 0, (headPos.Y + pos.Y)/2), math.deg(math.atan2(pos.Y - headPos.Y, pos.X - headPos.X)), true
                    else e.sk.Visible = false end
                else e.tr.Visible, e.sk.Visible = false, false end
            else e.h.Enabled, e.tr.Visible, e.sk.Visible = false, false, false end
        end
    end

    -- Target Aimbot
    local target, minD = nil, _G.F
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local tR = GetCenter(p.Character)
            if tR then
                local pos, vis = C:WorldToViewportPoint(tR.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minD then target, minD = tR, dist end
                end
            end
        end
    end
    if target and _G.A then C.CFrame = CFrame.new(C.CFrame.Position, target.Position) end
end)
