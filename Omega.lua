-- // OMEGA V5.1 - FULL SUITE
local P, R, C, LP = game:GetService("Players"), game:GetService("RunService"), workspace.CurrentCamera, game:GetService("Players").LocalPlayer
local U, VIM = game:GetService("UserInputService"), game:GetService("VirtualInputManager")

local _G = { 
    A = true, At = true, F = 180, 
    V = true, Ch = true, Tr = true, -- Visuals
    DesyncActive = false, DesyncMode = "None", 
    StoredPos = nil, Bv = 950 
}
local pE, jerkCounter = {}, 0

-- // UNIVERSAL DRAGGING
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

-- // RIG DETECTOR
local function GetCenter(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

-- // UI SETUP
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "OmegaFinal"; G.ResetOnSpawn = false
local Main = Instance.new("Frame", G); Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 185, 0, 320), UDim2.new(0.1, 0, 0.4, 0), Color3.new(0.03, 0.03, 0.03)
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.new(0, 0.6, 1)

local Header = Instance.new("TextLabel", Main); Header.Size, Header.Text = UDim2.new(1, 0, 0, 35), "OMEGA V5.1"; Header.BackgroundColor3, Header.TextColor3 = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1); makeDraggable(Header, Main)
local Status = Instance.new("TextLabel", Main); Status.Size, Status.Position = UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 1, 5); Status.Text, Status.TextColor3, Status.BackgroundColor3 = "Status: Synced", Color3.new(0, 1, 0), Color3.new(0,0,0)

local DSMenu = Instance.new("Frame", G); DSMenu.Size, DSMenu.Position, DSMenu.Visible = UDim2.new(0, 170, 0, 220), UDim2.new(0.5, -85, 0.5, -110), false; DSMenu.BackgroundColor3 = Color3.new(0, 0, 0); makeDraggable(DSMenu, DSMenu)

-- // GHOST VISUAL
local Ghost = Instance.new("Part", workspace); Ghost.Name = "Omega_Anchor"; Ghost.Size, Ghost.Anchored, Ghost.CanCollide = Vector3.new(4, 5, 2), true, false; Ghost.Material, Ghost.Color, Ghost.Transparency = Enum.Material.Neon, Color3.new(1, 0, 0), 1
local GhostHigh = Instance.new("Highlight", Ghost); GhostHigh.FillColor, GhostHigh.Enabled = Color3.new(1, 0, 0), false

local function ApplyDesync(mode)
    local root = GetCenter(LP.Character)
    if mode == "Delete" then
        _G.DesyncActive, _G.DesyncMode, Ghost.Transparency, GhostHigh.Enabled = false, "None", 1, false
        settings().Network.IncomingReplicationLag = 0
        Status.Text, Status.TextColor3 = "Status: SYNCED", Color3.new(0, 1, 0)
        return
    end
    _G.StoredPos, _G.DesyncActive, _G.DesyncMode = root.CFrame, true, mode
    Ghost.CFrame, Ghost.Transparency, GhostHigh.Enabled = _G.StoredPos, (mode == "Invisible" and 1 or 0.4), (mode ~= "Invisible")
    Status.Text, Status.TextColor3 = "Mode: "..mode:upper(), Color3.new(1, 0, 0)
end

-- // DRAWING FUNCTION FOR TRACERS
local function draw(l, p1, p2)
    local d = (p1 - p2).Magnitude
    l.Size, l.Position, l.Rotation, l.Visible = UDim2.new(0, d, 0, 1.5), UDim2.new(0, (p1.X + p2.X)/2 - d/2, 0, (p1.Y + p2.Y)/2), math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X)), true
end

-- // UI BUILDERS
local function Btn(txt, parent, func)
    local b = Instance.new("TextButton", parent); b.Size, b.Text = UDim2.new(0.92, 0, 0, 35), txt; b.BackgroundColor3, b.TextColor3 = Color3.new(0.12, 0.12, 0.12), Color3.new(1, 1, 1)
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(func); return b
end
local L1, L2 = Instance.new("UIListLayout", Main), Instance.new("UIListLayout", DSMenu)
L1.Padding, L1.HorizontalAlignment = UDim.new(0, 5), 1; L2.Padding, L2.HorizontalAlignment = UDim.new(0, 5), 1

-- Main Menu Controls
Btn("Toggle Aimbot", Main, function() _G.A = not _G.A end)
Btn("Toggle ESP", Main, function() _G.V = not _G.V end)
Btn("Toggle Chams", Main, function() _G.Ch = not _G.Ch end)
Btn("Toggle Tracers", Main, function() _G.Tr = not _G.Tr end)
local OpenDS = Btn("DESYNC DASHBOARD", Main, function() DSMenu.Visible = not DSMenu.Visible end); OpenDS.TextColor3 = Color3.new(1, 0, 0)

-- Dashboard Controls
Btn("Anchor (Static)", DSMenu, function() ApplyDesync("Anchor"); DSMenu.Visible = false end)
Btn("Rubber-Band (Jerk)", DSMenu, function() ApplyDesync("Rubber"); DSMenu.Visible = false end)
Btn("Invisible Desync", DSMenu, function() ApplyDesync("Invisible"); DSMenu.Visible = false end)
Btn("DELETE DESYNC", DSMenu, function() ApplyDesync("Delete"); DSMenu.Visible = false end)

-- // MAIN RUNTIME
R.RenderStepped:Connect(function()
    local char = LP.Character
    local root = char and GetCenter(char)
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    
    -- Desync Logic
    if _G.DesyncActive and root then
        if _G.DesyncMode == "Rubber" then
            jerkCounter = (jerkCounter + 1) % 45
            if jerkCounter < 40 then settings().Network.IncomingReplicationLag = 1000
            elseif jerkCounter < 44 then settings().Network.IncomingReplicationLag = 0
            else root.CFrame = _G.StoredPos; settings().Network.IncomingReplicationLag = 1000 end
        else settings().Network.IncomingReplicationLag = 1000 end
    end
    
    -- ESP & Target Logic
    local target, minD = nil, _G.F
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            if not pE[p] then 
                pE[p] = {h = Instance.new("Highlight", G), tr = (function() local f = Instance.new("Frame", G); f.BorderSizePixel, f.Visible = 0, false; f.BackgroundColor3 = Color3.new(0, 0.7, 1); return f end)()}
            end
            local e = pE[p]
            local tR = GetCenter(p.Character)
            
            if tR and _G.V then
                local pos, vis = C:WorldToViewportPoint(tR.Position)
                e.h.Enabled, e.h.Adornee = _G.Ch, p.Character
                if vis then
                    if _G.Tr then draw(e.tr, Vector2.new(center.X, C.ViewportSize.Y), Vector2.new(pos.X, pos.Y)) else e.tr.Visible = false end
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minD then target, minD = tR, dist end
                else e.tr.Visible = false end
            else e.h.Enabled, e.tr.Visible = false, false end
        end
    end

    -- Aimbot Execution
    if target and _G.A then
        local aimPos = target.Position
        C.CFrame = CFrame.new(C.CFrame.Position, aimPos) -- Camera Lock
        if _G.At then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.04)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)
