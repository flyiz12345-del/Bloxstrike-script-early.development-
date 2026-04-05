-- // OMEGA V5 - FINAL REVISION
-- // Features: R6/R15 Auto-Detect, Draggable UI, Desync Dashboard, Rubber-Banding

local P = game:GetService("Players")
local R = game:GetService("RunService")
local C = workspace.CurrentCamera
local LP = P.LocalPlayer
local U = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- // CONFIG
local _G = {
    A = true, At = true, F = 180, 
    DesyncActive = false,
    DesyncMode = "None", -- "Anchor", "Invisible", "Rubber"
    StoredPos = nil,
    Bv = 950
}
local jerkCounter = 0

-- // UNIVERSAL DRAGGING (Mobile + PC)
local function makeDraggable(topbar, main)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	U.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

-- // RIG DETECTOR
local function GetCenter(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

-- // UI CONSTRUCTION
local G = Instance.new("ScreenGui", LP.PlayerGui)
G.Name = "Omega_Final"
G.ResetOnSpawn = false

-- Main Menu
local Main = Instance.new("Frame", G)
Main.Size, Main.Position, Main.BackgroundColor3 = UDim2.new(0, 185, 0, 280), UDim2.new(0.1, 0, 0.4, 0), Color3.new(0.03, 0.03, 0.03)
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color, MainStroke.Thickness = Color3.new(0, 0.6, 1), 2

local Header = Instance.new("TextLabel", Main)
Header.Size, Header.Text = UDim2.new(1, 0, 0, 35), "OMEGA V5 [FINAL]"
Header.BackgroundColor3, Header.TextColor3 = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
Header.Active = true
Instance.new("UICorner", Header)
makeDraggable(Header, Main)

-- Status Bar
local Status = Instance.new("TextLabel", Main)
Status.Size, Status.Position = UDim2.new(1, 0, 0, 22), UDim2.new(0, 0, 1, 5)
Status.Text, Status.BackgroundColor3, Status.TextColor3 = "Status: Synced", Color3.new(0,0,0), Color3.new(0,1,0)
Instance.new("UICorner", Status)

-- Desync Dashboard Sub-Menu
local DSMenu = Instance.new("Frame", G)
DSMenu.Size, DSMenu.Position, DSMenu.Visible = UDim2.new(0, 170, 0, 220), UDim2.new(0.5, -85, 0.5, -110), false
DSMenu.BackgroundColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", DSMenu)
local DSStroke = Instance.new("UIStroke", DSMenu)
DSStroke.Color = Color3.new(1, 0, 0)
makeDraggable(DSMenu, DSMenu)

-- // GHOST VISUAL
local Ghost = Instance.new("Part", workspace)
Ghost.Name = "Omega_Anchor"
Ghost.Size, Ghost.Anchored, Ghost.CanCollide = Vector3.new(4, 5, 2), true, false
Ghost.Material, Ghost.Color, Ghost.Transparency = Enum.Material.Neon, Color3.new(1, 0, 0), 1
local GhostHigh = Instance.new("Highlight", Ghost)
GhostHigh.FillColor, GhostHigh.Enabled = Color3.new(1, 0, 0), false

-- // DESYNC DASHBOARD LOGIC
local function ApplyDesync(mode)
    local root = GetCenter(LP.Character)
    if not root then return end

    if mode == "Delete" then
        _G.DesyncActive = false
        _G.DesyncMode = "None"
        _G.StoredPos = nil
        Ghost.Transparency = 1
        GhostHigh.Enabled = false
        settings().Network.IncomingReplicationLag = 0
        Status.Text = "Status: SYNCED"
        Status.TextColor3 = Color3.new(0, 1, 0)
        return
    end

    _G.StoredPos = root.CFrame
    _G.DesyncActive = true
    _G.DesyncMode = mode
    
    if mode == "Anchor" or mode == "Rubber" then
        Ghost.CFrame = _G.StoredPos
        Ghost.Transparency = 0.4
        GhostHigh.Enabled = true
        Status.Text = "Mode: " .. mode:upper()
        Status.TextColor3 = Color3.new(1, 0, 0)
    elseif mode == "Invisible" then
        Ghost.Transparency = 1
        GhostHigh.Enabled = false
        Status.Text = "Mode: INVISIBLE"
        Status.TextColor3 = Color3.new(0.5, 0, 1)
    end
end

-- // UI LIST LAYOUTS
local function AddList(p)
    local l = Instance.new("UIListLayout", p)
    l.Padding, l.HorizontalAlignment, l.VerticalAlignment = UDim.new(0, 6), 1, 1
    return l
end
AddList(Main).VerticalAlignment = Enum.VerticalAlignment.Top
AddList(DSMenu)

local function Btn(txt, parent, func)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Text = UDim2.new(0.92, 0, 0, 38), txt
    b.BackgroundColor3, b.TextColor3 = Color3.new(0.12, 0.12, 0.12), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
    return b
end

-- // POPULATE MENUS
Btn("Toggle Aimbot", Main, function() _G.A = not _G.A end)
Btn("Toggle AutoShoot", Main, function() _G.At = not _G.At end)
local OpenDS = Btn("DESYNC DASHBOARD", Main, function() DSMenu.Visible = not DSMenu.Visible end)
OpenDS.TextColor3 = Color3.new(1, 0, 0)

Btn("Anchor (Static)", DSMenu, function() ApplyDesync("Anchor") DSMenu.Visible = false end)
Btn("Rubber-Band (Jerk)", DSMenu, function() ApplyDesync("Rubber") DSMenu.Visible = false end)
Btn("Invisible Desync", DSMenu, function() ApplyDesync("Invisible") DSMenu.Visible = false end)
Btn("DELETE DESYNC", DSMenu, function() ApplyDesync("Delete") DSMenu.Visible = false end)
Btn("CLOSE", DSMenu, function() DSMenu.Visible = false end)

-- // MAIN RUNTIME
R.RenderStepped:Connect(function()
    local char = LP.Character
    local root = char and GetCenter(char)
    
    if _G.DesyncActive and root then
        if _G.DesyncMode == "Rubber" then
            jerkCounter = jerkCounter + 1
            if jerkCounter < 40 then
                settings().Network.IncomingReplicationLag = 1000
            elseif jerkCounter >= 40 and jerkCounter < 45 then
                settings().Network.IncomingReplicationLag = 0 -- Flicker Forward
            else
                root.CFrame = _G.StoredPos -- Snap Back
                settings().Network.IncomingReplicationLag = 1000
                jerkCounter = 0
            end
        else
            -- Standard Anchor / Invisible
            settings().Network.IncomingReplicationLag = 1000
        end
    end
    
    -- Combat Logic (Universal Check)
    if _G.At and _G.A then
        local target = nil
        local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
        for _, p in pairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local tRoot = GetCenter(p.Character)
                if tRoot then
                    local pos, vis = C:WorldToViewportPoint(tRoot.Position)
                    if vis and (Vector2.new(pos.X, pos.Y) - center).Magnitude < _G.F then
                        target = tRoot
                        break
                    end
                end
            end
        end
        if target then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.04)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)

print("Omega V5 Universal Loaded - Draggable Enabled")
