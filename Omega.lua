local P,R,C,LP,U=game:GetService("Players"),game:GetService("RunService"),workspace.CurrentCamera,game:GetService("Players").LocalPlayer,game:GetService("UserInputService")
local _G,pE,tk={A=true,At=true,Ds=true,Sm=1,F=200,Wb=true,V=true,Ch=true,Sk=true,Tm=true,Sp=false,Yw=true,Up=false,Off=180,Circ=true},{},0

-- // UI BASE
local G=Instance.new("ScreenGui",LP.PlayerGui)G.Name="OmegaHub"G.IgnoreGuiInset=true
local Dock=Instance.new("Frame",G)Dock.Size,Dock.Position,Dock.BackgroundColor3=UDim2.new(0,50,0,250),UDim2.new(0,15,0.5,-125),Color3.fromRGB(5,5,8)
Instance.new("UICorner",Dock).CornerRadius=UDim.new(0,10)
local St=Instance.new("UIStroke",Dock)St.Color,St.Thickness=Color3.fromRGB(0,160,255),1.5

-- // FOV CIRCLE
local Cir=Instance.new("Frame",G)Cir.Size,Cir.Position=UDim2.new(0,_G.F*2,0,_G.F*2),UDim2.new(0.5,-_G.F,0.5,-_G.F)
Cir.BackgroundColor3,Cir.BackgroundTransparency,Cir.Visible=Color3.new(1,1,1),1,true
local CS=Instance.new("UIStroke",Cir)CS.Color,CS.Thickness,CS.Transparency=Color3.new(1,1,1),1,0.5
Instance.new("UICorner",Cir).CornerRadius=UDim.new(1,0)

-- // PANEL SYSTEM
local function CreatePanel(name,y)
    local p=Instance.new("Frame",G)p.Size,p.Position,p.Visible=UDim2.new(0,140,0,120),UDim2.new(0,75,0.5,y),false
    p.BackgroundColor3=Color3.fromRGB(8,8,12)Instance.new("UICorner",p)
    Instance.new("UIStroke",p).Color=Color3.fromRGB(0,160,255)
    local l=Instance.new("UIListLayout",p)l.Padding,l.HorizontalAlignment=UDim.new(0,5),1
    return p
end

local AimP=CreatePanel("Aim",-120)
local VisP=CreatePanel("Vis",-30)
local RageP=CreatePanel("Rage",60)

local function L()local l=Instance.new("Frame",G)l.BackgroundColor3,l.BorderSizePixel,l.Visible,l.ZIndex=Color3.new(1,1,1),0,false,99 return l end
local function draw(l,p1,p2)local d=(p1-p2).Magnitude l.Size,l.Position,l.Rotation,l.Visible=UDim2.new(0,d,0,1),UDim2.new(0,(p1.X+p2.X)/2-d/2,0,(p1.Y+p2.Y)/2),math.deg(math.atan2(p2.Y-p1.Y,p2.X-p1.X)),true end

-- // COMPACT BUTTONS
local function Ico(sym,panel,y)
    local b=Instance.new("TextButton",Dock)b.Size,b.Position=UDim2.new(0,34,0,34),UDim2.new(0.5,-17,0,y)
    b.Text,b.BackgroundColor3,b.TextColor3,b.Font=sym,Color3.fromRGB(20,20,25),Color3.new(1,1,1),3
    Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(function()
        local v=not panel.Visible AimP.Visible,VisP.Visible,RageP.Visible=false,false,false panel.Visible=v
    end)
end

local function Opt(n,v,p)
    local b=Instance.new("TextButton",p)b.Size,b.Text=UDim2.new(0.9,0,0,25),n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]"
    b.BackgroundColor3,b.TextColor3,b.Font=Color3.fromRGB(30,30,35),Color3.new(1,1,1),3
    Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(function() _G[v]=not _G[v] b.Text=n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]" if v=="Circ" then Cir.Visible=_G[v] end end)
end

-- // DOCK BUTTONS
local Min=Instance.new("TextButton",Dock)Min.Size,Min.Text,Min.Position=UDim2.new(0,34,0,20),"-",UDim2.new(0.5,-17,0,5)
Min.BackgroundColor3,Min.TextColor3=Color3.new(0.2,0,0),Color3.new(1,1,1)
Min.MouseButton1Click:Connect(function() Dock.Visible=not Dock.Visible end)

Ico("🎯",AimP,35)Ico("👁️",VisP,85)Ico("😡",RageP,135)

-- SETTINGS
Opt("Aimbot","A",AimP)Opt("FOV Circle","Circ",AimP)Opt("Autoshoot","At",AimP)
Opt("ESP Master","V",VisP)Opt("Chams","Ch",VisP)Opt("Skeletons","Sk",VisP)
Opt("Desync","Ds",RageP)Opt("Anti-Aim","Yw",RageP)Opt("UpsideDown","Up",RageP)

-- // DRAG
local d,ds,sp Dock.InputBegan:Connect(function(i)if(i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)then d,ds,sp=true,i.Position,Dock.Position end end)
U.InputChanged:Connect(function(i)if d and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local dl=i.Position-ds Dock.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dl.X,sp.Y.Scale,sp.Y.Offset+dl.Y)end end)U.InputEnded:Connect(function()d=false end)

-- // ENGINE
local function getB(c)for _,n in{"Head","Torso"}do local p=c:FindFirstChild(n)if p then local r=Ray.new(C.CFrame.Position,(p.Position-C.CFrame.Position).Unit*500)local h=workspace:FindPartOnRayWithIgnoreList(r,{LP.Character,c})if not h or(_G.Wb and(h.Transparency>0.5 or h.Material==Enum.Material.Wood))then return p end end end end
R.RenderStepped:Connect(function()
    local t,m,ct=nil,_G.F,Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)tk=(tk or 0+1)%2 Cir.Position=UDim2.new(0,ct.X-_G.F,0,ct.Y-_G.F)
    local ch=LP.Character if ch and ch:FindFirstChild("HumanoidRootPart")then local hr,rj=ch.HumanoidRootPart,ch.HumanoidRootPart:FindFirstChild("RootJoint")if _G.Ds and tk==0 then hr.CFrame=hr.CFrame*CFrame.new(0,0,0.06)end if rj then local x=_G.Up and 90 or-90 if _G.Yw then rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(x),0,math.rad(_G.Off+180))else rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(-90),3.14,0)end end end
    for _,p in pairs(P:GetPlayers())do if p~=LP and p.Character and p.Character:FindFirstChild("Torso")then if not pE[p] then pE[p]={h=Instance.new("Highlight",G),s={ht=L(),la=L(),ra=L(),ll=L(),rl=L()}}end local e,c=pE[p],p.Character e.h.Enabled,e.h.Adornee,e.h.FillColor=_G.V and _G.Ch,c,Color3.new(0,1,0.5)local ps,vis=C:WorldToViewportPoint(c.Torso.Position)for _,s in pairs(e.s)do s.Visible=false end if vis and _G.V then if _G.Sk then local function g(pt)local o=c:FindFirstChild(pt)if o then local oP,oV=C:WorldToViewportPoint(o.Position)if oV then return Vector2.new(oP.X,oP.Y)end end end local h,t0,la,ra,ll,rl=g("Head"),g("Torso"),g("Left Arm"),g("Right Arm"),g("Left Leg"),g("Right Leg")if h and t0 and la and ra and ll and rl then draw(e.s.ht,h,t0)draw(e.s.la,t0,la)draw(e.s.ra,t0,ra)draw(e.s.ll,t0,ll)draw(e.s.rl,t0,rl)end end if(Vector2.new(ps.X,ps.Y)-ct).Magnitude<m then local b=getB(c)if b then t,m=b,(Vector2.new(ps.X,ps.Y)-ct).Magnitude end end end end end
    if _G.A and t then C.CFrame
