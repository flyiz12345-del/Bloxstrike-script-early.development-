local P,R,C,LP,U=game:GetService("Players"),game:GetService("RunService"),workspace.CurrentCamera,game:GetService("Players").LocalPlayer,game:GetService("UserInputService")
local _G,pE,tk={A=true,At=true,SA=true,Wb=true,Sm=1,F=180,V=true,Ch=true,Sk=true,Tr=true,Sp=false,Yw=false,Up=false,Off=180,Circ=true,Spd=60,Ws=false,Jp=false,Fl=false,Pd=true,Bv=800},{},0

task.wait(0.5)

-- // UI SETUP
local G=Instance.new("ScreenGui",LP.PlayerGui)G.Name="OmegaV34"G.IgnoreGuiInset=true
local D=Instance.new("Frame",G)D.Size,D.Position,D.BackgroundColor3=UDim2.new(0,50,0,300),UDim2.new(0,10,0.5,-150),Color3.new(0,0,0)Instance.new("UICorner",D)local St=Instance.new("UIStroke",D)St.Color,St.Thickness=Color3.new(0,0.6,1),1.8
local Cir=Instance.new("Frame",G)Cir.Size,Cir.Position,Cir.BackgroundTransparency,Cir.Visible=UDim2.new(0,_G.F*2,0,_G.F*2),UDim2.new(0.5,-_G.F,0.5,-_G.F),1,_G.Circ Instance.new("UIStroke",Cir).Color,Instance.new("UICorner",Cir).CornerRadius=Color3.new(1,1,1),UDim.new(1,0)

-- // GHOST PILLAR
local Ghost = Instance.new("Part", workspace)
Ghost.Size,Ghost.Anchored,Ghost.CanCollide,Ghost.Transparency,Ghost.Material=Vector3.new(4,6,4),true,false,1,Enum.Material.ForceField
Ghost.Color = Color3.fromRGB(0, 160, 255)

local function CreateP(y)
    local p=Instance.new("Frame",G)p.Size,p.Position,p.Visible,p.BackgroundColor3=UDim2.new(0,140,0,230),UDim2.new(0,65,0.5,y),false,Color3.new(0,0,0)Instance.new("UICorner",p)
    Instance.new("UIListLayout",p).Padding,p.UIListLayout.HorizontalAlignment=UDim.new(0,4),1 return p 
end
local AimP,VisP,RageP=CreateP(-140),CreateP(-40),CreateP(50)

local function L(col)local l=Instance.new("Frame",G)l.BackgroundColor3,l.BorderSizePixel,l.Visible=col or Color3.new(1,1,1),0,false return l end
local function draw(l,p1,p2)local d=(p1-p2).Magnitude l.Size,l.Position,l.Rotation,l.Visible=UDim2.new(0,d,0,1),UDim2.new(0,(p1.X+p2.X)/2-d/2,0,(p1.Y+p2.Y)/2),math.deg(math.atan2(p2.Y-p1.Y,p2.X-p1.X)),true end
local function Ico(s,pn,y)local b=Instance.new("TextButton",D)b.Size,b.Position,b.Text,b.BackgroundColor3,b.TextColor3=UDim2.new(0,34,0,34),UDim2.new(0.5,-17,0,y),s,Color3.new(0.1,0.1,0.1),Color3.new(1,1,1)Instance.new("UICorner",b)b.MouseButton1Click:Connect(function()AimP.Visible,VisP.Visible,RageP.Visible=false,false,false pn.Visible=not pn.Visible end)end
local function Opt(n,v,p)local b=Instance.new("TextButton",p)b.Size,b.Text,b.BackgroundColor3,b.TextColor3=UDim2.new(0.9,0,0,25),n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]",Color3.new(0.1,0.1,0.1),Color3.new(1,1,1)Instance.new("UICorner",b)b.MouseButton1Click:Connect(function()_G[v]=not _G[v]b.Text=n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]" if v=="Circ" then Cir.Visible=_G[v] end end)end

Ico("🎯",AimP,10)Ico("👁️",VisP,70)Ico("😡",RageP,130)Ico("-",G,200)

Opt("Aimbot","A",AimP)Opt("Predict","Pd",AimP)Opt("Silent Aim","SA",AimP)Opt("Wallbang","Wb",AimP)Opt("Auto","At",AimP)Opt("Circle","Circ",AimP)
Opt("Master ESP","V",VisP)Opt("Chams","Ch",VisP)Opt("Bones","Sk",VisP)Opt("Line","Tr",VisP)
Opt("Fake Lag","Fl",RageP)Opt("Spinbot","Sp",RageP)Opt("Speed","Ws",RageP)Opt("Jump","Jp",RageP)Opt("Flip","Up",RageP)

local function Shoot()
    local v=game:GetService("VirtualInputManager")
    if v then 
        v:SendMouseButtonEvent(0,0,0,true,game,0)
        task.wait(0.01)
        v:SendMouseButtonEvent(0,0,0,false,game,0)
    end 
end

-- // UPDATED HITBOX ENGINE FOR RIVALS (R15 Support)
local function getB(c)for _,n in{"Head","UpperTorso","LowerTorso","Torso","HumanoidRootPart"}do local p=c:FindFirstChild(n)if p then if not _G.Wb then local r=Ray.new(C.CFrame.Position,(p.Position-C.CFrame.Position).Unit*500)local h=workspace:FindPartOnRayWithIgnoreList(r,{LP.Character,c})if h and h.Transparency<0.5 then continue end end return p end end end

local sA,fC=0,0
R.RenderStepped:Connect(function()
    local t,m,ct=nil,_G.F,Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)tk=(tk or 0+1)%2 Cir.Position=UDim2.new(0,ct.X-_G.F,0,ct.Y-_G.F)
    local ch=LP.Character if ch and ch:FindFirstChild("Humanoid
