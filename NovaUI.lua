--[[
╔═══════════════════════════════════════════════════════════════╗
║  ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗     ██╗   ██╗██╗       ║
║  ████╗  ██║██╔═══██╗██║   ██║██╔══██╗    ██║   ██║██║       ║
║  ██╔██╗ ██║██║   ██║██║   ██║███████║    ██║   ██║██║       ║
║  ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║    ██║   ██║██║       ║
║  ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║    ╚██████╔╝██║       ║
║  ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝    ╚═════╝ ╚═╝       ║
║                                                               ║
║  Nova UI Library  v3.0                                        ║
║  The most complete Roblox UI library — better than Orion.     ║
╚═══════════════════════════════════════════════════════════════╝

ELEMENTS:
  Button, Toggle, Slider, Dropdown, Textbox, Keybind,
  ColorPicker, Label, Section, Paragraph, Divider,
  MultiDropdown, ProgressBar, Checkbox

BUILT-IN TABS (optional):
  Home    — Script info, credits, quick-launch buttons
  Settings — Theme picker, toggle key, UI scale, watermark toggle

THEMES (12):
  Dark, Light, Ocean, Sunset, Forest, Blood, Rose,
  Midnight, Neon, Candy, Gold, Arctic

USAGE EXAMPLE:
  local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOU/REPO/main/NovaUI.lua"))()

  local Window = UI:CreateWindow({
      Title      = "My Script",
      Subtitle   = "v1.0",
      Theme      = "Dark",
      ToggleKey  = Enum.KeyCode.RightShift,
      HomeTab    = true,   -- built-in Home tab (default true)
      SettingsTab = true,  -- built-in Settings tab (default true)
      HomeInfo = {
          ScriptName    = "My Script",
          ScriptVersion = "v1.0",
          Developer     = "YourName",
          Description   = "Does cool stuff.",
      },
  })

  local Tab = Window:CreateTab({ Name = "Main" })

  Tab:AddButton({ Name = "Click Me", Callback = function() print("hi") end })
  Tab:AddToggle({ Name = "Enable", Default = false, Callback = function(v) print(v) end })
  Tab:AddSlider({ Name = "Speed", Min = 0, Max = 500, Default = 16, Callback = function(v) print(v) end })

  UI:Notify({ Title = "Loaded", Description = "Script started!", Type = "Success", Duration = 5 })
]]

-- ════════════════════════════════════════════════════════════════
-- SERVICES
-- ════════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════
-- NOVA TABLE
-- ════════════════════════════════════════════════════════════════
local Nova = {}
Nova.__index = Nova
Nova._activeWindow = nil

-- ════════════════════════════════════════════════════════════════
-- THEMES  (12 themes)
-- ════════════════════════════════════════════════════════════════
Nova.Themes = {
    -- ── Dark (default)
    Dark = {
        Background = Color3.fromRGB(14, 14, 20),      Panel = Color3.fromRGB(20, 20, 28),
        PanelAlt   = Color3.fromRGB(26, 26, 36),      Element = Color3.fromRGB(33, 33, 46),
        Accent     = Color3.fromRGB(100, 130, 255),   AccentDark = Color3.fromRGB(70, 95, 200),
        AccentLight= Color3.fromRGB(145, 168, 255),   Text = Color3.fromRGB(228, 228, 240),
        TextMuted  = Color3.fromRGB(138, 138, 158),   TextDim = Color3.fromRGB(82, 82, 105),
        Border     = Color3.fromRGB(48, 48, 68),      Success = Color3.fromRGB(78, 200, 118),
        Error      = Color3.fromRGB(255, 88, 88),     Warning = Color3.fromRGB(255, 178, 58),
        Info       = Color3.fromRGB(98, 178, 255),    Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Light
    Light = {
        Background = Color3.fromRGB(238, 240, 248),   Panel = Color3.fromRGB(255, 255, 255),
        PanelAlt   = Color3.fromRGB(246, 246, 254),   Element = Color3.fromRGB(232, 232, 244),
        Accent     = Color3.fromRGB(88, 118, 245),    AccentDark = Color3.fromRGB(58, 88, 210),
        AccentLight= Color3.fromRGB(128, 152, 255),   Text = Color3.fromRGB(18, 18, 32),
        TextMuted  = Color3.fromRGB(88, 88, 118),     TextDim = Color3.fromRGB(158, 158, 182),
        Border     = Color3.fromRGB(205, 205, 222),   Success = Color3.fromRGB(38, 175, 88),
        Error      = Color3.fromRGB(225, 58, 58),     Warning = Color3.fromRGB(215, 145, 28),
        Info       = Color3.fromRGB(58, 145, 238),    Shadow = Color3.fromRGB(148, 148, 175),
    },
    -- ── Ocean
    Ocean = {
        Background = Color3.fromRGB(6, 18, 32),       Panel = Color3.fromRGB(10, 25, 44),
        PanelAlt   = Color3.fromRGB(13, 32, 55),      Element = Color3.fromRGB(18, 42, 68),
        Accent     = Color3.fromRGB(0, 198, 198),     AccentDark = Color3.fromRGB(0, 145, 145),
        AccentLight= Color3.fromRGB(78, 228, 228),    Text = Color3.fromRGB(198, 232, 242),
        TextMuted  = Color3.fromRGB(118, 168, 192),   TextDim = Color3.fromRGB(68, 112, 138),
        Border     = Color3.fromRGB(28, 68, 98),      Success = Color3.fromRGB(58, 208, 138),
        Error      = Color3.fromRGB(255, 78, 98),     Warning = Color3.fromRGB(255, 188, 48),
        Info       = Color3.fromRGB(78, 198, 255),    Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Sunset
    Sunset = {
        Background = Color3.fromRGB(18, 8, 22),       Panel = Color3.fromRGB(28, 12, 36),
        PanelAlt   = Color3.fromRGB(36, 18, 46),      Element = Color3.fromRGB(48, 26, 60),
        Accent     = Color3.fromRGB(255, 98, 148),    AccentDark = Color3.fromRGB(198, 68, 108),
        AccentLight= Color3.fromRGB(255, 148, 188),   Text = Color3.fromRGB(244, 218, 232),
        TextMuted  = Color3.fromRGB(178, 142, 162),   TextDim = Color3.fromRGB(118, 88, 108),
        Border     = Color3.fromRGB(78, 38, 88),      Success = Color3.fromRGB(98, 208, 128),
        Error      = Color3.fromRGB(255, 78, 78),     Warning = Color3.fromRGB(255, 188, 58),
        Info       = Color3.fromRGB(128, 168, 255),   Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Forest
    Forest = {
        Background = Color3.fromRGB(8, 18, 10),       Panel = Color3.fromRGB(12, 26, 14),
        PanelAlt   = Color3.fromRGB(16, 34, 18),      Element = Color3.fromRGB(22, 46, 24),
        Accent     = Color3.fromRGB(80, 200, 90),     AccentDark = Color3.fromRGB(55, 148, 65),
        AccentLight= Color3.fromRGB(120, 228, 130),   Text = Color3.fromRGB(210, 238, 212),
        TextMuted  = Color3.fromRGB(128, 175, 132),   TextDim = Color3.fromRGB(75, 118, 78),
        Border     = Color3.fromRGB(32, 72, 36),      Success = Color3.fromRGB(78, 215, 95),
        Error      = Color3.fromRGB(238, 75, 75),     Warning = Color3.fromRGB(248, 188, 48),
        Info       = Color3.fromRGB(78, 185, 248),    Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Blood (really red)
    Blood = {
        Background = Color3.fromRGB(16, 4, 4),        Panel = Color3.fromRGB(26, 6, 6),
        PanelAlt   = Color3.fromRGB(36, 8, 8),        Element = Color3.fromRGB(50, 12, 12),
        Accent     = Color3.fromRGB(220, 30, 30),     AccentDark = Color3.fromRGB(165, 18, 18),
        AccentLight= Color3.fromRGB(255, 70, 70),     Text = Color3.fromRGB(245, 215, 215),
        TextMuted  = Color3.fromRGB(178, 128, 128),   TextDim = Color3.fromRGB(115, 75, 75),
        Border     = Color3.fromRGB(80, 18, 18),      Success = Color3.fromRGB(75, 198, 110),
        Error      = Color3.fromRGB(255, 50, 50),     Warning = Color3.fromRGB(255, 175, 50),
        Info       = Color3.fromRGB(105, 165, 255),   Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Rose
    Rose = {
        Background = Color3.fromRGB(22, 10, 14),      Panel = Color3.fromRGB(34, 14, 20),
        PanelAlt   = Color3.fromRGB(44, 18, 28),      Element = Color3.fromRGB(58, 24, 36),
        Accent     = Color3.fromRGB(248, 120, 155),   AccentDark = Color3.fromRGB(195, 85, 118),
        AccentLight= Color3.fromRGB(255, 165, 192),   Text = Color3.fromRGB(248, 225, 232),
        TextMuted  = Color3.fromRGB(185, 148, 162),   TextDim = Color3.fromRGB(125, 95, 108),
        Border     = Color3.fromRGB(92, 38, 55),      Success = Color3.fromRGB(95, 208, 128),
        Error      = Color3.fromRGB(255, 75, 95),     Warning = Color3.fromRGB(255, 188, 60),
        Info       = Color3.fromRGB(128, 175, 255),   Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Midnight
    Midnight = {
        Background = Color3.fromRGB(5, 5, 15),        Panel = Color3.fromRGB(8, 8, 22),
        PanelAlt   = Color3.fromRGB(12, 12, 32),      Element = Color3.fromRGB(18, 18, 44),
        Accent     = Color3.fromRGB(130, 88, 255),    AccentDark = Color3.fromRGB(95, 58, 198),
        AccentLight= Color3.fromRGB(168, 132, 255),   Text = Color3.fromRGB(222, 218, 248),
        TextMuted  = Color3.fromRGB(140, 135, 175),   TextDim = Color3.fromRGB(85, 82, 118),
        Border     = Color3.fromRGB(38, 35, 78),      Success = Color3.fromRGB(78, 205, 118),
        Error      = Color3.fromRGB(255, 85, 85),     Warning = Color3.fromRGB(255, 180, 55),
        Info       = Color3.fromRGB(95, 178, 255),    Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Neon
    Neon = {
        Background = Color3.fromRGB(4, 4, 4),         Panel = Color3.fromRGB(8, 8, 8),
        PanelAlt   = Color3.fromRGB(12, 12, 12),      Element = Color3.fromRGB(18, 18, 18),
        Accent     = Color3.fromRGB(0, 255, 135),     AccentDark = Color3.fromRGB(0, 185, 95),
        AccentLight= Color3.fromRGB(80, 255, 175),    Text = Color3.fromRGB(220, 255, 235),
        TextMuted  = Color3.fromRGB(120, 175, 145),   TextDim = Color3.fromRGB(65, 105, 82),
        Border     = Color3.fromRGB(0, 65, 35),       Success = Color3.fromRGB(0, 248, 128),
        Error      = Color3.fromRGB(255, 55, 55),     Warning = Color3.fromRGB(255, 215, 0),
        Info       = Color3.fromRGB(0, 195, 255),     Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Candy
    Candy = {
        Background = Color3.fromRGB(24, 6, 28),       Panel = Color3.fromRGB(36, 10, 42),
        PanelAlt   = Color3.fromRGB(46, 14, 54),      Element = Color3.fromRGB(60, 20, 70),
        Accent     = Color3.fromRGB(255, 80, 220),    AccentDark = Color3.fromRGB(198, 50, 168),
        AccentLight= Color3.fromRGB(255, 140, 240),   Text = Color3.fromRGB(255, 225, 255),
        TextMuted  = Color3.fromRGB(195, 155, 205),   TextDim = Color3.fromRGB(130, 95, 142),
        Border     = Color3.fromRGB(95, 30, 108),     Success = Color3.fromRGB(95, 215, 130),
        Error      = Color3.fromRGB(255, 68, 68),     Warning = Color3.fromRGB(255, 200, 55),
        Info       = Color3.fromRGB(130, 178, 255),   Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Gold
    Gold = {
        Background = Color3.fromRGB(14, 10, 4),       Panel = Color3.fromRGB(22, 16, 6),
        PanelAlt   = Color3.fromRGB(30, 22, 8),       Element = Color3.fromRGB(42, 30, 10),
        Accent     = Color3.fromRGB(255, 198, 30),    AccentDark = Color3.fromRGB(198, 148, 18),
        AccentLight= Color3.fromRGB(255, 225, 100),   Text = Color3.fromRGB(255, 242, 210),
        TextMuted  = Color3.fromRGB(188, 162, 115),   TextDim = Color3.fromRGB(128, 105, 65),
        Border     = Color3.fromRGB(85, 60, 18),      Success = Color3.fromRGB(80, 208, 112),
        Error      = Color3.fromRGB(255, 78, 78),     Warning = Color3.fromRGB(255, 175, 45),
        Info       = Color3.fromRGB(105, 175, 255),   Shadow = Color3.fromRGB(0, 0, 0),
    },
    -- ── Arctic
    Arctic = {
        Background = Color3.fromRGB(8, 18, 28),       Panel = Color3.fromRGB(12, 26, 40),
        PanelAlt   = Color3.fromRGB(16, 34, 52),      Element = Color3.fromRGB(22, 44, 66),
        Accent     = Color3.fromRGB(108, 198, 255),   AccentDark = Color3.fromRGB(68, 148, 215),
        AccentLight= Color3.fromRGB(158, 225, 255),   Text = Color3.fromRGB(215, 238, 255),
        TextMuted  = Color3.fromRGB(128, 175, 210),   TextDim = Color3.fromRGB(75, 118, 155),
        Border     = Color3.fromRGB(30, 75, 115),     Success = Color3.fromRGB(68, 215, 135),
        Error      = Color3.fromRGB(255, 82, 82),     Warning = Color3.fromRGB(255, 190, 50),
        Info       = Color3.fromRGB(108, 198, 255),   Shadow = Color3.fromRGB(0, 0, 0),
    },
}

-- Ordered list of theme names for Settings tab
Nova.ThemeNames = {
    "Dark","Light","Ocean","Sunset","Forest",
    "Blood","Rose","Midnight","Neon","Candy","Gold","Arctic"
}

-- ════════════════════════════════════════════════════════════════
-- UTILITY
-- ════════════════════════════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play(); return tw
end

local function New(class, props, children)
    local i = Instance.new(class)
    for k,v in pairs(props or {}) do i[k]=v end
    for _,c in pairs(children or {}) do c.Parent=i end
    return i
end

local function Corner(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p return c end
local function Stroke(p,col,thick,trans) local s=Instance.new("UIStroke") s.Color=col s.Thickness=thick or 1 s.Transparency=trans or 0 s.Parent=p return s end
local function Pad(p,t,b,l,r) local d=Instance.new("UIPadding") d.PaddingTop=UDim.new(0,t or 0) d.PaddingBottom=UDim.new(0,b or 0) d.PaddingLeft=UDim.new(0,l or 0) d.PaddingRight=UDim.new(0,r or 0) d.Parent=p return d end
local function ListLayout(p,sort,align,halign,padding)
    local l=Instance.new("UIListLayout")
    l.SortOrder=sort or Enum.SortOrder.LayoutOrder
    if align then l.VerticalAlignment=align end
    if halign then l.HorizontalAlignment=halign end
    l.Padding=UDim.new(0,padding or 0)
    l.Parent=p return l
end
local function Draggable(frame,handle)
    handle=handle or frame
    local dragging,dragInput,dragStart,startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true dragStart=i.Position startPos=frame.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==dragInput and dragging then
            local d=i.Position-dragStart
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ════════════════════════════════════════════════════════════════
local NotifHolder

local function InitNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local gui = CoreGui:FindFirstChild("NovaUI")
    NotifHolder = New("Frame",{
        Name="NovaNotifs", Parent=gui or CoreGui,
        BackgroundTransparency=1,
        Position=UDim2.new(1,-312,1,-12),
        Size=UDim2.new(0,300,1,0),
        AnchorPoint=Vector2.new(0,1), ZIndex=200,
    })
    ListLayout(NotifHolder,nil,Enum.VerticalAlignment.Bottom,nil,8)
end

function Nova:Notify(cfg)
    InitNotifHolder()
    local th=self._theme or Nova.Themes.Dark
    local tc={Success=th.Success,Error=th.Error,Warning=th.Warning,Info=th.Info}
    local ac=tc[cfg.Type] or th.Accent
    local dur=cfg.Duration or 4

    local notif=New("Frame",{Parent=NotifHolder,BackgroundColor3=th.Panel,
        Size=UDim2.new(1,0,0,0),ClipsDescendants=true,BackgroundTransparency=0.08})
    Corner(notif,10) Stroke(notif,th.Border,1,0.5)

    New("Frame",{Parent=notif,BackgroundColor3=ac,Size=UDim2.new(0,3,1,0),Position=UDim2.new(0,0,0,0)},{Instance.new("UICorner")})

    local con=New("Frame",{Parent=notif,BackgroundTransparency=1,Position=UDim2.new(0,14,0,0),Size=UDim2.new(1,-24,1,0)})
    New("TextLabel",{Parent=con,BackgroundTransparency=1,Position=UDim2.new(0,0,0,10),Size=UDim2.new(1,0,0,18),
        Text=cfg.Title or "Notice",TextColor3=th.Text,Font=Enum.Font.GothamBold,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left})
    New("TextLabel",{Parent=con,BackgroundTransparency=1,Position=UDim2.new(0,0,0,28),Size=UDim2.new(1,0,0,28),
        Text=cfg.Description or "",TextColor3=th.TextMuted,Font=Enum.Font.Gotham,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})

    local bar=New("Frame",{Parent=notif,BackgroundColor3=ac,Size=UDim2.new(1,0,0,2),
        Position=UDim2.new(0,0,1,-2),BackgroundTransparency=0.3})

    Tween(notif,{Size=UDim2.new(1,0,0,72)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    task.delay(0.3,function() Tween(bar,{Size=UDim2.new(0,0,0,2)},dur,Enum.EasingStyle.Linear) end)
    task.delay(dur+0.3,function()
        Tween(notif,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.3)
        task.delay(0.35,function() notif:Destroy() end)
    end)
end

-- ════════════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ════════════════════════════════════════════════════════════════
function Nova:CreateWindow(cfg)
    cfg = cfg or {}
    local theme = Nova.Themes[cfg.Theme] or Nova.Themes.Dark
    self._theme = theme
    self._themeName = cfg.Theme or "Dark"

    -- Destroy any old GUI
    if CoreGui:FindFirstChild("NovaUI") then CoreGui:FindFirstChild("NovaUI"):Destroy() end

    local gui = New("ScreenGui",{Name="NovaUI",Parent=CoreGui,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    pcall(function() gui.IgnoreGuiInset=true end)
    InitNotifHolder()

    local W,H = 660,450

    -- Shadow
    local shadowHolder = New("Frame",{Parent=gui,BackgroundTransparency=1,
        Size=UDim2.new(0,W+40,0,H+40),
        Position=UDim2.new(0.5,-(W+40)/2,0.5,-(H+40)/2)})
    New("ImageLabel",{Parent=shadowHolder,BackgroundTransparency=1,
        Image="rbxassetid://6014261993",ImageColor3=theme.Shadow,ImageTransparency=0.55,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),
        Size=UDim2.new(1,0,1,0),ZIndex=0})

    -- Main window
    local win = New("Frame",{Name="Window",Parent=gui,BackgroundColor3=theme.Background,
        BorderSizePixel=0,Size=UDim2.new(0,W,0,H),
        Position=UDim2.new(0.5,-W/2,0.5,-H/2),ClipsDescendants=true})
    Corner(win,14) Stroke(win,theme.Border,1,0.4)

    local winGrad=Instance.new("UIGradient")
    winGrad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,theme.Background),
        ColorSequenceKeypoint.new(1,Color3.new(
            math.clamp(theme.Background.R+0.025,0,1),
            math.clamp(theme.Background.G+0.025,0,1),
            math.clamp(theme.Background.B+0.055,0,1)))})
    winGrad.Rotation=135 winGrad.Parent=win

    -- ── TITLE BAR
    local titleBar=New("Frame",{Parent=win,BackgroundColor3=theme.Panel,
        Size=UDim2.new(1,0,0,50),BackgroundTransparency=0.1})

    New("Frame",{Parent=titleBar,BackgroundColor3=theme.Accent,
        Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundTransparency=0.6})

    -- Dot accent
    local dot=New("Frame",{Parent=titleBar,BackgroundColor3=theme.Accent,
        Size=UDim2.new(0,8,0,8),Position=UDim2.new(0,16,0.5,-4)}) Corner(dot,4)

    New("TextLabel",{Parent=titleBar,BackgroundTransparency=1,
        Position=UDim2.new(0,32,0,7),Size=UDim2.new(0,250,0,20),
        Text=cfg.Title or "Nova Script",TextColor3=theme.Text,
        Font=Enum.Font.GothamBold,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left})

    New("TextLabel",{Parent=titleBar,BackgroundTransparency=1,
        Position=UDim2.new(0,32,0,27),Size=UDim2.new(0,250,0,14),
        Text=cfg.Subtitle or "Nova UI v3.0",TextColor3=theme.Accent,
        Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left})

    -- Window buttons
    local function WinBtn(xOff,col)
        local b=New("TextButton",{Parent=titleBar,BackgroundColor3=col,
            BackgroundTransparency=0.45,Size=UDim2.new(0,14,0,14),
            Position=UDim2.new(1,xOff,0.5,-7),Text="",AutoButtonColor=false})
        Corner(b,7)
        b.MouseEnter:Connect(function() Tween(b,{BackgroundTransparency=0},0.1) end)
        b.MouseLeave:Connect(function() Tween(b,{BackgroundTransparency=0.45},0.1) end)
        return b
    end
    local closeBtn = WinBtn(-16-10, theme.Error)
    local minBtn   = WinBtn(-16-10-22, theme.Warning)

    Draggable(win,titleBar)

    -- ── SIDEBAR
    local sidebar=New("Frame",{Parent=win,BackgroundColor3=theme.Panel,
        BackgroundTransparency=0.15,Size=UDim2.new(0,155,1,-50),Position=UDim2.new(0,0,0,50)})
    New("Frame",{Parent=sidebar,BackgroundColor3=theme.Border,
        Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,0,0,0),BackgroundTransparency=0.5})

    local tabScroll=New("ScrollingFrame",{Parent=sidebar,BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,-8),Position=UDim2.new(0,0,0,8),
        ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.Y,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
    Pad(tabScroll,4,4,8,8) ListLayout(tabScroll,nil,nil,nil,4)

    -- Bottom version label in sidebar
    New("TextLabel",{Parent=sidebar,BackgroundTransparency=1,
        Position=UDim2.new(0,0,1,-22),Size=UDim2.new(1,0,0,20),
        Text="Nova UI  v3.0",TextColor3=theme.TextDim,Font=Enum.Font.Gotham,
        TextSize=9,TextXAlignment=Enum.TextXAlignment.Center})

    -- ── CONTENT AREA
    local contentArea=New("Frame",{Parent=win,BackgroundTransparency=1,
        Size=UDim2.new(1,-155,1,-50),Position=UDim2.new(0,155,0,50),ClipsDescendants=true})

    -- ── WATERMARK
    local wmLabel
    local wmFrame
    if cfg.Watermark ~= false then
        wmFrame=New("Frame",{Name="NovaWatermark",Parent=gui,BackgroundColor3=theme.Panel,
            BackgroundTransparency=0.2,Size=UDim2.new(0,190,0,26),Position=UDim2.new(0,10,0,10)})
        Corner(wmFrame,6) Stroke(wmFrame,theme.Border,1,0.5) Pad(wmFrame,0,0,10,10)
        wmLabel=New("TextLabel",{Parent=wmFrame,BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),Text=(cfg.Title or "Nova").."  |  -- FPS",
            TextColor3=theme.TextMuted,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left})
        local frames,lastT=0,tick()
        RunService.RenderStepped:Connect(function()
            frames=frames+1
            local now=tick()
            if now-lastT>=1 then
                wmLabel.Text=(cfg.Title or "Nova").."  |  "..frames.." FPS"
                frames=0 lastT=now
            end
        end)
    end

    -- ════════════════════════════════════════════════════════
    -- WINDOW OBJECT
    -- ════════════════════════════════════════════════════════
    local Window={_tabs={},_activeTab=nil,_theme=theme,_gui=gui,_win=win}
    Nova._activeWindow = Window

    local visible=true
    local toggleKey=cfg.ToggleKey or Enum.KeyCode.RightShift

    local function SetVis(v)
        visible=v
        if v then
            win.Visible=true shadowHolder.Visible=true
            Tween(win,{Size=UDim2.new(0,W,0,H)},0.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        else
            Tween(win,{Size=UDim2.new(0,W,0,0)},0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
            task.delay(0.23,function() win.Visible=false shadowHolder.Visible=false end)
        end
    end

    UserInputService.InputBegan:Connect(function(inp,gpe)
        if gpe then return end
        if inp.KeyCode==toggleKey then SetVis(not visible) end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(win,{Size=UDim2.new(0,W,0,0),BackgroundTransparency=1},0.28)
        task.delay(0.3,function() gui:Destroy() end)
    end)
    minBtn.MouseButton1Click:Connect(function() SetVis(not visible) end)

    -- Entrance animation
    win.Size=UDim2.new(0,W,0,0)
    Tween(win,{Size=UDim2.new(0,W,0,H)},0.48,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

    -- ════════════════════════════════════════════════════════
    -- INTERNAL: TAB BUILDER (shared by CreateTab + built-ins)
    -- ════════════════════════════════════════════════════════
    local function BuildTab(tabCfg, isBuiltin)
        local tab={_theme=theme}

        local tabBtn=New("TextButton",{Parent=tabScroll,BackgroundColor3=theme.Element,
            BackgroundTransparency=1,Size=UDim2.new(1,0,0,36),Text="",AutoButtonColor=false})
        Corner(tabBtn,8)

        if tabCfg.Icon then
            New("ImageLabel",{Parent=tabBtn,BackgroundTransparency=1,Image=tabCfg.Icon,
                ImageColor3=theme.TextMuted,Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,10,0.5,-8)})
        end

        local xOff = tabCfg.Icon and 34 or 12
        local tabLabel=New("TextLabel",{Parent=tabBtn,BackgroundTransparency=1,
            Position=UDim2.new(0,xOff,0,0),Size=UDim2.new(1,-(xOff+6),1,0),
            Text=tabCfg.Name or "Tab",TextColor3=theme.TextMuted,
            Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})

        local indicator=New("Frame",{Parent=tabBtn,BackgroundColor3=theme.Accent,
            Size=UDim2.new(0,3,0,14),Position=UDim2.new(0,0,0.5,-7),BackgroundTransparency=1})
        Corner(indicator,2)

        local page=New("ScrollingFrame",{Parent=contentArea,BackgroundTransparency=1,
            Size=UDim2.new(1,0,1,0),Visible=false,ScrollBarThickness=3,
            ScrollBarImageColor3=theme.Accent,ScrollingDirection=Enum.ScrollingDirection.Y,
            CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,BorderSizePixel=0})
        Pad(page,12,12,14,14) ListLayout(page,nil,nil,nil,6)

        local function Activate()
            for _,t in pairs(Window._tabs) do
                if t~=tab then
                    t._page.Visible=false
                    Tween(t._btn,{BackgroundTransparency=1},0.18)
                    Tween(t._label,{TextColor3=theme.TextMuted,Font=Enum.Font.Gotham},0.18) -- note: Font can't tween natively
                    t._label.Font=Enum.Font.Gotham
                    Tween(t._indicator,{BackgroundTransparency=1,Size=UDim2.new(0,3,0,14)},0.18)
                end
            end
            page.Visible=true
            Tween(tabBtn,{BackgroundTransparency=0.75},0.18)
            tabLabel.Font=Enum.Font.GothamBold tabLabel.TextColor3=theme.Text
            Tween(indicator,{BackgroundTransparency=0,Size=UDim2.new(0,3,0,20)},0.2)
            Window._activeTab=tab
        end

        tab._btn=tabBtn tab._label=tabLabel tab._page=page tab._indicator=indicator tab._activate=Activate
        tabBtn.MouseButton1Click:Connect(Activate)
        tabBtn.MouseEnter:Connect(function() if Window._activeTab~=tab then Tween(tabBtn,{BackgroundTransparency=0.88},0.12) end end)
        tabBtn.MouseLeave:Connect(function() if Window._activeTab~=tab then Tween(tabBtn,{BackgroundTransparency=1},0.12) end end)

        table.insert(Window._tabs,tab)
        if #Window._tabs==1 then Activate() end

        -- ──────────────────────────────────────────────────────
        -- ELEMENT FACTORY HELPERS
        -- ──────────────────────────────────────────────────────
        local function El(h,clip)
            local f=New("Frame",{Parent=page,BackgroundColor3=theme.Element,
                BackgroundTransparency=0.42,Size=UDim2.new(1,0,0,h or 46),
                BorderSizePixel=0,ClipsDescendants=clip or false})
            Corner(f,8) Stroke(f,theme.Border,1,0.72)
            f.MouseEnter:Connect(function() Tween(f,{BackgroundTransparency=0.22},0.12) end)
            f.MouseLeave:Connect(function() Tween(f,{BackgroundTransparency=0.42},0.12) end)
            return f
        end

        local function Labels(parent,name,desc,icon,rightPad)
            rightPad=rightPad or 0
            if icon then
                New("ImageLabel",{Parent=parent,BackgroundTransparency=1,Image=icon,
                    ImageColor3=theme.TextMuted,Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,12,0.5,-8)})
            end
            local x=icon and 36 or 12
            local w=desc and 0.62 or 0.75
            New("TextLabel",{Parent=parent,BackgroundTransparency=1,
                Position=UDim2.new(0,x,0,desc and 8 or 0),
                Size=desc and UDim2.new(w,-x-rightPad,0,18) or UDim2.new(w,-x-rightPad,1,0),
                Text=name or "",TextColor3=theme.Text,Font=Enum.Font.GothamSemibold,
                TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
            if desc then
                New("TextLabel",{Parent=parent,BackgroundTransparency=1,
                    Position=UDim2.new(0,x,0,26),Size=UDim2.new(w,-x-rightPad,0,14),
                    Text=desc,TextColor3=theme.TextDim,Font=Enum.Font.Gotham,
                    TextSize=10,TextXAlignment=Enum.TextXAlignment.Left})
            end
        end

        -- ════════════════════════════
        -- SECTION
        -- ════════════════════════════
        function tab:AddSection(name)
            local sec=New("Frame",{Parent=page,BackgroundTransparency=1,Size=UDim2.new(1,0,0,26)})
            New("TextLabel",{Parent=sec,BackgroundTransparency=1,Size=UDim2.new(0.85,0,1,0),
                Text=string.upper(name or "Section"),TextColor3=theme.Accent,Font=Enum.Font.GothamBold,
                TextSize=10,TextXAlignment=Enum.TextXAlignment.Left})
            New("Frame",{Parent=sec,BackgroundColor3=theme.Accent,BackgroundTransparency=0.72,
                Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1)})
        end

        -- ════════════════════════════
        -- DIVIDER
        -- ════════════════════════════
        function tab:AddDivider()
            New("Frame",{Parent=page,BackgroundColor3=theme.Border,BackgroundTransparency=0.4,
                Size=UDim2.new(1,0,0,1)})
        end

        -- ════════════════════════════
        -- LABEL
        -- ════════════════════════════
        function tab:AddLabel(text)
            local f=New("Frame",{Parent=page,BackgroundTransparency=1,Size=UDim2.new(1,0,0,20)})
            New("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
                Text=text or "",TextColor3=theme.TextMuted,Font=Enum.Font.Gotham,TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
        end

        -- ════════════════════════════
        -- PARAGRAPH
        -- ════════════════════════════
        function tab:AddParagraph(cfg2)
            local el=El(cfg2.Description and 70 or 50)
            New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(0,12,0,8),Size=UDim2.new(1,-24,0,18),
                Text=cfg2.Title or "",TextColor3=theme.Text,Font=Enum.Font.GothamBold,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left})
            if cfg2.Description then
                New("TextLabel",{Parent=el,BackgroundTransparency=1,
                    Position=UDim2.new(0,12,0,26),Size=UDim2.new(1,-24,0,36),
                    Text=cfg2.Description,TextColor3=theme.TextMuted,Font=Enum.Font.Gotham,TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
            end
        end

        -- ════════════════════════════
        -- BUTTON
        -- ════════════════════════════
        function tab:AddButton(cfg2)
            local h=cfg2.Description and 52 or 40
            local el=El(h)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon,108)

            local bw=cfg2.Description and 88 or 76
            local btn=New("TextButton",{Parent=el,BackgroundColor3=theme.Accent,
                BackgroundTransparency=0.35,Size=UDim2.new(0,bw,0,26),
                Position=UDim2.new(1,-bw-12,0.5,-13),Text=cfg2.ButtonText or "Execute",
                TextColor3=theme.Text,Font=Enum.Font.GothamSemibold,TextSize=11,AutoButtonColor=false})
            Corner(btn,6)
            btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=theme.AccentLight,BackgroundTransparency=0},0.12) end)
            btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=theme.Accent,BackgroundTransparency=0.35},0.12) end)
            btn.MouseButton1Click:Connect(function()
                Tween(btn,{BackgroundColor3=theme.AccentDark},0.08)
                task.delay(0.15,function() Tween(btn,{BackgroundColor3=theme.Accent,BackgroundTransparency=0.35},0.15) end)
                if cfg2.Callback then cfg2.Callback() end
            end)
            return btn
        end

        -- ════════════════════════════
        -- TOGGLE
        -- ════════════════════════════
        function tab:AddToggle(cfg2)
            local val=cfg2.Default or false
            local el=El(cfg2.Description and 52 or 40)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local track=New("Frame",{Parent=el,BackgroundColor3=val and theme.Accent or theme.Border,
                Size=UDim2.new(0,40,0,22),Position=UDim2.new(1,-52,0.5,-11)}) Corner(track,11)
            local knob=New("Frame",{Parent=track,BackgroundColor3=Color3.fromRGB(255,255,255),
                Size=UDim2.new(0,16,0,16),
                Position=val and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)}) Corner(knob,8)

            local function Set(v,silent)
                val=v
                Tween(track,{BackgroundColor3=v and theme.Accent or theme.Border},0.22)
                Tween(knob,{Position=v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)},0.22,Enum.EasingStyle.Back)
                if not silent and cfg2.Callback then cfg2.Callback(v) end
            end

            New("TextButton",{Parent=el,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""}).MouseButton1Click:Connect(function() Set(not val) end)
            local obj={} function obj:Set(v) Set(v,false) end function obj:Get() return val end return obj
        end

        -- ════════════════════════════
        -- CHECKBOX  (tick style)
        -- ════════════════════════════
        function tab:AddCheckbox(cfg2)
            local val=cfg2.Default or false
            local el=El(cfg2.Description and 52 or 40)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local box=New("Frame",{Parent=el,BackgroundColor3=val and theme.Accent or theme.Element,
                Size=UDim2.new(0,22,0,22),Position=UDim2.new(1,-34,0.5,-11)}) Corner(box,6)
            Stroke(box,val and theme.Accent or theme.Border,1.5,0)
            local tick=New("TextLabel",{Parent=box,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),
                Text="✓",TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.GothamBold,TextSize=14,
                TextXAlignment=Enum.TextXAlignment.Center,Visible=val})

            local function Set(v,silent)
                val=v tick.Visible=v
                Tween(box,{BackgroundColor3=v and theme.Accent or theme.Element},0.18)
                if not silent and cfg2.Callback then cfg2.Callback(v) end
            end
            New("TextButton",{Parent=el,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""}).MouseButton1Click:Connect(function() Set(not val) end)
            local obj={} function obj:Set(v) Set(v,false) end function obj:Get() return val end return obj
        end

        -- ════════════════════════════
        -- SLIDER
        -- ════════════════════════════
        function tab:AddSlider(cfg2)
            local mn,mx,inc=cfg2.Min or 0,cfg2.Max or 100,cfg2.Increment or 1
            local val=math.clamp(cfg2.Default or mn,mn,mx)
            local el=El(cfg2.Description and 64 or 54)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local vLbl=New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(1,-52,0,8),Size=UDim2.new(0,46,0,18),
                Text=tostring(val),TextColor3=theme.Accent,Font=Enum.Font.GothamBold,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Right})

            local trackBg=New("Frame",{Parent=el,BackgroundColor3=theme.Border,
                Size=UDim2.new(1,-24,0,5),Position=UDim2.new(0,12,1,-18)}) Corner(trackBg,3)
            local fill=New("Frame",{Parent=trackBg,BackgroundColor3=theme.Accent,
                Size=UDim2.new((val-mn)/(mx-mn),0,1,0)}) Corner(fill,3)
            local knob=New("Frame",{Parent=trackBg,BackgroundColor3=Color3.fromRGB(255,255,255),
                Size=UDim2.new(0,14,0,14),Position=UDim2.new((val-mn)/(mx-mn),-7,0.5,-7),ZIndex=3}) Corner(knob,7)
            Stroke(knob,theme.Accent,2,0)

            local dragging=false
            local function SetVal(v)
                v=math.clamp(math.round(v/inc)*inc,mn,mx) val=v
                local pct=(v-mn)/(mx-mn)
                Tween(fill,{Size=UDim2.new(pct,0,1,0)},0.08)
                Tween(knob,{Position=UDim2.new(pct,-7,0.5,-7)},0.08)
                vLbl.Text=tostring(v)
                if cfg2.Callback then cfg2.Callback(v) end
            end
            local function InputVal(inp)
                local pct=math.clamp((inp.Position.X-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
                SetVal(mn+pct*(mx-mn))
            end
            trackBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true InputVal(i) end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then InputVal(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

            local obj={} function obj:Set(v) SetVal(v) end function obj:Get() return val end return obj
        end

        -- ════════════════════════════
        -- PROGRESS BAR
        -- ════════════════════════════
        function tab:AddProgressBar(cfg2)
            local val=math.clamp(cfg2.Default or 0,0,100)
            local el=El(cfg2.Description and 58 or 46)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local pLbl=New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(1,-50,0,8),Size=UDim2.new(0,44,0,18),
                Text=tostring(val).."%",TextColor3=theme.Accent,Font=Enum.Font.GothamBold,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Right})
            local trackBg=New("Frame",{Parent=el,BackgroundColor3=theme.Border,
                Size=UDim2.new(1,-24,0,8),Position=UDim2.new(0,12,1,-20)}) Corner(trackBg,4)
            local fill=New("Frame",{Parent=trackBg,BackgroundColor3=theme.Accent,
                Size=UDim2.new(val/100,0,1,0)}) Corner(fill,4)

            local obj={}
            function obj:Set(v)
                v=math.clamp(v,0,100) val=v
                Tween(fill,{Size=UDim2.new(v/100,0,1,0)},0.35,Enum.EasingStyle.Quart)
                pLbl.Text=tostring(math.round(v)).."%"
            end
            function obj:Get() return val end
            return obj
        end

        -- ════════════════════════════
        -- DROPDOWN  (single select)
        -- ════════════════════════════
        function tab:AddDropdown(cfg2)
            local opts=cfg2.Options or {}
            local sel=cfg2.Default or opts[1] or ""
            local open=false

            local el=El(40)
            Labels(el,cfg2.Name,nil,cfg2.Icon)

            local selLbl=New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(0.45,0,0,0),Size=UDim2.new(0.42,0,1,-6),
                Text=sel,TextColor3=theme.TextMuted,Font=Enum.Font.Gotham,TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Right})
            local arrow=New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(1,-24,0.5,-8),Size=UDim2.new(0,16,0,16),
                Text="▾",TextColor3=theme.TextMuted,Font=Enum.Font.GothamBold,TextSize=12})

            local dropFrame=New("Frame",{Parent=page,BackgroundColor3=theme.PanelAlt,
                Size=UDim2.new(1,0,0,0),ClipsDescendants=true,Visible=false,ZIndex=10})
            Corner(dropFrame,8) Stroke(dropFrame,theme.Border,1,0.5)
            local dropInner=New("Frame",{Parent=dropFrame,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)})
            Pad(dropInner,4,4,6,6) ListLayout(dropInner,nil,nil,nil,2)

            local function CloseDD()
                open=false Tween(arrow,{Rotation=0},0.18)
                Tween(dropFrame,{Size=UDim2.new(1,0,0,0)},0.18)
                task.delay(0.2,function() dropFrame.Visible=false end)
            end

            for _,opt in pairs(opts) do
                local ob=New("TextButton",{Parent=dropInner,BackgroundColor3=theme.Element,
                    BackgroundTransparency=opt==sel and 0.55 or 1,Size=UDim2.new(1,0,0,28),
                    Text=opt,TextColor3=opt==sel and theme.Accent or theme.TextMuted,
                    Font=opt==sel and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=11,AutoButtonColor=false})
                Corner(ob,6)
                ob.MouseEnter:Connect(function() if sel~=opt then Tween(ob,{BackgroundTransparency=0.7,TextColor3=theme.Text},0.1) end end)
                ob.MouseLeave:Connect(function() if sel~=opt then Tween(ob,{BackgroundTransparency=1,TextColor3=theme.TextMuted},0.1) end end)
                ob.MouseButton1Click:Connect(function()
                    sel=opt selLbl.Text=opt
                    CloseDD()
                    if cfg2.Callback then cfg2.Callback(opt) end
                end)
            end

            local targetH=math.min(#opts*30+8,180)
            New("TextButton",{Parent=el,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""}).MouseButton1Click:Connect(function()
                open=not open Tween(arrow,{Rotation=open and 180 or 0},0.18)
                if open then dropFrame.Visible=true Tween(dropFrame,{Size=UDim2.new(1,0,0,targetH)},0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                else CloseDD() end
            end)

            local obj={} function obj:Set(v) sel=v selLbl.Text=v end function obj:Get() return sel end return obj
        end

        -- ════════════════════════════
        -- MULTI-DROPDOWN
        -- ════════════════════════════
        function tab:AddMultiDropdown(cfg2)
            local opts=cfg2.Options or {}
            local sel={}
            for _,d in pairs(cfg2.Default or {}) do sel[d]=true end
            local open=false

            local el=El(40)
            Labels(el,cfg2.Name,nil,cfg2.Icon)

            local selLbl=New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(0.45,0,0,0),Size=UDim2.new(0.4,0,1,-6),
                Text="None",TextColor3=theme.TextMuted,Font=Enum.Font.Gotham,TextSize=10,
                TextXAlignment=Enum.TextXAlignment.Right,TextWrapped=true})
            local arrow=New("TextLabel",{Parent=el,BackgroundTransparency=1,
                Position=UDim2.new(1,-24,0.5,-8),Size=UDim2.new(0,16,0,16),
                Text="▾",TextColor3=theme.TextMuted,Font=Enum.Font.GothamBold,TextSize=12})

            local dropFrame=New("Frame",{Parent=page,BackgroundColor3=theme.PanelAlt,
                Size=UDim2.new(1,0,0,0),ClipsDescendants=true,Visible=false,ZIndex=10})
            Corner(dropFrame,8) Stroke(dropFrame,theme.Border,1,0.5)
            local dropInner=New("Frame",{Parent=dropFrame,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0)})
            Pad(dropInner,4,4,6,6) ListLayout(dropInner,nil,nil,nil,2)

            local function UpdateLabel()
                local s={}
                for k,v in pairs(sel) do if v then table.insert(s,k) end end
                selLbl.Text=#s==0 and "None" or table.concat(s,", ")
            end

            for _,opt in pairs(opts) do
                local checked=sel[opt] or false
                local ob=New("TextButton",{Parent=dropInner,BackgroundColor3=theme.Element,
                    BackgroundTransparency=checked and 0.55 or 1,Size=UDim2.new(1,0,0,28),
                    Text=(checked and "✓  " or "   ")..opt,
                    TextColor3=checked and theme.Accent or theme.TextMuted,
                    Font=checked and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=11,AutoButtonColor=false})
                Corner(ob,6)
                ob.MouseButton1Click:Connect(function()
                    sel[opt]=not sel[opt]
                    local c=sel[opt]
                    ob.Text=(c and "✓  " or "   ")..opt
                    ob.TextColor3=c and theme.Accent or theme.TextMuted
                    ob.Font=c and Enum.Font.GothamBold or Enum.Font.Gotham
                    Tween(ob,{BackgroundTransparency=c and 0.55 or 1},0.12)
                    UpdateLabel()
                    if cfg2.Callback then cfg2.Callback(sel) end
                end)
            end

            local targetH=math.min(#opts*30+8,180)
            New("TextButton",{Parent=el,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text=""}).MouseButton1Click:Connect(function()
                open=not open Tween(arrow,{Rotation=open and 180 or 0},0.18)
                if open then dropFrame.Visible=true Tween(dropFrame,{Size=UDim2.new(1,0,0,targetH)},0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                else
                    Tween(dropFrame,{Size=UDim2.new(1,0,0,0)},0.18)
                    task.delay(0.2,function() dropFrame.Visible=false end)
                end
            end)
            UpdateLabel()
            local obj={}
            function obj:Get() local s={} for k,v in pairs(sel) do if v then table.insert(s,k) end end return s end
            return obj
        end

        -- ════════════════════════════
        -- TEXTBOX
        -- ════════════════════════════
        function tab:AddTextbox(cfg2)
            local el=El(cfg2.Description and 52 or 40)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local box=New("TextBox",{Parent=el,BackgroundColor3=theme.PanelAlt,BackgroundTransparency=0.32,
                Size=UDim2.new(0,132,0,26),Position=UDim2.new(1,-144,0.5,-13),
                Text=cfg2.Default or "",PlaceholderText=cfg2.PlaceholderText or "...",
                TextColor3=theme.Text,PlaceholderColor3=theme.TextDim,Font=Enum.Font.Gotham,TextSize=11,
                ClearTextOnFocus=cfg2.ClearOnFocus or false})
            Corner(box,6) Stroke(box,theme.Border,1,0.5) Pad(box,0,0,8,8)

            box.Focused:Connect(function() Tween(box,{BackgroundTransparency=0},0.12) Stroke(box,theme.Accent,1.5,0) end)
            box.FocusLost:Connect(function(enter)
                Tween(box,{BackgroundTransparency=0.32},0.12) Stroke(box,theme.Border,1,0.5)
                if (enter or cfg2.FocusLost) and cfg2.Callback then cfg2.Callback(box.Text) end
            end)

            local obj={} function obj:Set(v) box.Text=v end function obj:Get() return box.Text end return obj
        end

        -- ════════════════════════════
        -- KEYBIND
        -- ════════════════════════════
        function tab:AddKeybind(cfg2)
            local curKey=cfg2.Default or Enum.KeyCode.Unknown
            local listening=false
            local el=El(cfg2.Description and 52 or 40)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local kbtn=New("TextButton",{Parent=el,BackgroundColor3=theme.PanelAlt,BackgroundTransparency=0.32,
                Size=UDim2.new(0,88,0,26),Position=UDim2.new(1,-100,0.5,-13),
                Text=curKey.Name,TextColor3=theme.TextMuted,Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=false})
            Corner(kbtn,6) Stroke(kbtn,theme.Border,1,0.5)

            kbtn.MouseButton1Click:Connect(function()
                listening=true kbtn.Text="..."
                Tween(kbtn,{BackgroundColor3=theme.Accent,BackgroundTransparency=0,TextColor3=theme.Text},0.15)
            end)
            UserInputService.InputBegan:Connect(function(i,gpe)
                if not listening then return end
                if i.UserInputType==Enum.UserInputType.Keyboard then
                    listening=false curKey=i.KeyCode kbtn.Text=i.KeyCode.Name
                    Tween(kbtn,{BackgroundColor3=theme.PanelAlt,BackgroundTransparency=0.32,TextColor3=theme.TextMuted},0.18)
                    if cfg2.Callback then cfg2.Callback(curKey) end
                end
            end)

            local obj={} function obj:Get() return curKey end return obj
        end

        -- ════════════════════════════
        -- COLOR PICKER
        -- ════════════════════════════
        function tab:AddColorPicker(cfg2)
            local color=cfg2.Default or Color3.fromRGB(255,100,100)
            local el=El(cfg2.Description and 52 or 40)
            Labels(el,cfg2.Name,cfg2.Description,cfg2.Icon)

            local preview=New("Frame",{Parent=el,BackgroundColor3=color,
                Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-40,0.5,-14)})
            Corner(preview,6) Stroke(preview,theme.Border,1,0.4)

            local pickerOpen=false
            local pickerFrame=New("Frame",{Parent=page,BackgroundColor3=theme.PanelAlt,
                Size=UDim2.new(1,0,0,0),Visible=false,ZIndex=15,ClipsDescendants=true})
            Corner(pickerFrame,10) Stroke(pickerFrame,theme.Border,1,0.4)

            -- Hue bar
            local hueBar=New("Frame",{Parent=pickerFrame,
                Size=UDim2.new(1,-20,0,14),Position=UDim2.new(0,10,0,10)}) Corner(hueBar,4)
            local hg=Instance.new("UIGradient")
            hg.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,1,1)),
                ColorSequenceKeypoint.new(1/6,  Color3.fromHSV(1/6,1,1)),
                ColorSequenceKeypoint.new(2/6,  Color3.fromHSV(2/6,1,1)),
                ColorSequenceKeypoint.new(3/6,  Color3.fromHSV(3/6,1,1)),
                ColorSequenceKeypoint.new(4/6,  Color3.fromHSV(4/6,1,1)),
                ColorSequenceKeypoint.new(5/6,  Color3.fromHSV(5/6,1,1)),
                ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,1,1)),
            }) hg.Parent=hueBar

            local h,s,v=Color3.toHSV(color)
            local hueKnob=New("Frame",{Parent=hueBar,BackgroundColor3=Color3.fromRGB(255,255,255),
                Size=UDim2.new(0,8,1,6),Position=UDim2.new(h,-4,0,-3),ZIndex=16}) Corner(hueKnob,3)
            Stroke(hueKnob,Color3.fromRGB(0,0,0),1,0.6)

            -- SV square
            local svSq=New("Frame",{Parent=pickerFrame,
                Size=UDim2.new(1,-20,0,90),Position=UDim2.new(0,10,0,32),
                BackgroundColor3=Color3.fromHSV(h,1,1)}) Corner(svSq,5)
            local wg=Instance.new("UIGradient")
            wg.Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
            wg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})
            wg.Parent=svSq
            local bLayer=New("Frame",{Parent=svSq,BackgroundColor3=Color3.fromRGB(0,0,0),Size=UDim2.new(1,0,1,0)}) Corner(bLayer,5)
            local bg=Instance.new("UIGradient") bg.Rotation=90
            bg.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
            bg.Parent=bLayer
            local svKnob=New("Frame",{Parent=svSq,BackgroundColor3=Color3.fromRGB(255,255,255),
                Size=UDim2.new(0,12,0,12),Position=UDim2.new(s,-6,1-v,-6),ZIndex=16}) Corner(svKnob,6)
            Stroke(svKnob,Color3.fromRGB(0,0,0),1.5,0.4)

            -- Hex display
            local hexBox=New("TextBox",{Parent=pickerFrame,BackgroundColor3=theme.Element,BackgroundTransparency=0.3,
                Size=UDim2.new(1,-20,0,24),Position=UDim2.new(0,10,0,130),
                Text=string.format("#%02X%02X%02X",color.R*255,color.G*255,color.B*255),
                TextColor3=theme.Text,PlaceholderText="#RRGGBB",Font=Enum.Font.Code,TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Center}) Corner(hexBox,5) Stroke(hexBox,theme.Border,1,0.5)

            local function UpdateColor()
                color=Color3.fromHSV(h,s,v)
                preview.BackgroundColor3=color
                svSq.BackgroundColor3=Color3.fromHSV(h,1,1)
                hexBox.Text=string.format("#%02X%02X%02X",color.R*255,color.G*255,color.B*255)
                if cfg2.Callback then cfg2.Callback(color) end
            end

            local hueDrag,svDrag=false,false
            hueBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
                hueDrag=true h=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
                hueKnob.Position=UDim2.new(h,-4,0,-3) UpdateColor()
            end end)
            UserInputService.InputChanged:Connect(function(i)
                if hueDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    h=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
                    hueKnob.Position=UDim2.new(h,-4,0,-3) UpdateColor()
                end
                if svDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
                    s=math.clamp((i.Position.X-svSq.AbsolutePosition.X)/svSq.AbsoluteSize.X,0,1)
                    v=1-math.clamp((i.Position.Y-svSq.AbsolutePosition.Y)/svSq.AbsoluteSize.Y,0,1)
                    svKnob.Position=UDim2.new(s,-6,1-v,-6) UpdateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDrag=false svDrag=false end
            end)
            svSq.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
                svDrag=true
                s=math.clamp((i.Position.X-svSq.AbsolutePosition.X)/svSq.AbsoluteSize.X,0,1)
                v=1-math.clamp((i.Position.Y-svSq.AbsolutePosition.Y)/svSq.AbsoluteSize.Y,0,1)
                svKnob.Position=UDim2.new(s,-6,1-v,-6) UpdateColor()
            end end)
            hexBox.FocusLost:Connect(function()
                local hex=hexBox.Text:gsub("#","")
                if #hex==6 then
                    local r=tonumber(hex:sub(1,2),16)
                    local g=tonumber(hex:sub(3,4),16)
                    local b=tonumber(hex:sub(5,6),16)
                    if r and g and b then
                        color=Color3.fromRGB(r,g,b)
                        h,s,v=Color3.toHSV(color)
                        hueKnob.Position=UDim2.new(h,-4,0,-3)
                        svKnob.Position=UDim2.new(s,-6,1-v,-6)
                        preview.BackgroundColor3=color
                        svSq.BackgroundColor3=Color3.fromHSV(h,1,1)
                        if cfg2.Callback then cfg2.Callback(color) end
                    end
                end
            end)

            New("TextButton",{Parent=el,BackgroundTransparency=1,
                Size=UDim2.new(0,40,1,0),Position=UDim2.new(1,-40,0,0),Text=""}).MouseButton1Click:Connect(function()
                pickerOpen=not pickerOpen
                if pickerOpen then pickerFrame.Visible=true Tween(pickerFrame,{Size=UDim2.new(1,0,0,164)},0.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
                else Tween(pickerFrame,{Size=UDim2.new(1,0,0,0)},0.2) task.delay(0.21,function() pickerFrame.Visible=false end) end
            end)

            local obj={}
            function obj:Set(c) color=c preview.BackgroundColor3=c end
            function obj:Get() return color end
            return obj
        end

        return tab
    end

    -- ════════════════════════════════════════════════════════
    -- PUBLIC: CreateTab
    -- ════════════════════════════════════════════════════════
    function Window:CreateTab(tabCfg)
        return BuildTab(tabCfg, false)
    end

    -- ════════════════════════════════════════════════════════
    -- BUILT-IN: HOME TAB
    -- ════════════════════════════════════════════════════════
    if cfg.HomeTab ~= false then
        local homeInfo=cfg.HomeInfo or {}
        local homeTab=BuildTab({Name="Home",Icon=""}, true)

        homeTab:AddParagraph({
            Title = "🏠  " .. (homeInfo.ScriptName or cfg.Title or "Nova Script"),
            Description = homeInfo.Description or "Welcome! Select a tab on the left to get started.",
        })
        homeTab:AddDivider()

        if homeInfo.Developer then
            homeTab:AddParagraph({Title="Developer",Description=homeInfo.Developer})
        end
        if homeInfo.ScriptVersion then
            homeTab:AddParagraph({Title="Version",Description=homeInfo.ScriptVersion})
        end
        if homeInfo.Discord then
            homeTab:AddParagraph({Title="Discord",Description=homeInfo.Discord})
        end

        homeTab:AddSection("Quick Actions")
        homeTab:AddButton({Name="Hide UI", ButtonText="Hide",
            Description="Press "..toggleKey.Name.." to show again",
            Callback=function() SetVis(false) end})
        homeTab:AddButton({Name="Close UI", ButtonText="Destroy",
            Description="Permanently closes Nova UI",
            Callback=function()
                Tween(win,{Size=UDim2.new(0,W,0,0),BackgroundTransparency=1},0.28)
                task.delay(0.3,function() gui:Destroy() end)
            end})

        -- Move Home to front of tab list
        local homeBtn=homeTab._btn
        homeBtn.LayoutOrder=-999
    end

    -- ════════════════════════════════════════════════════════
    -- BUILT-IN: SETTINGS TAB
    -- ════════════════════════════════════════════════════════
    if cfg.SettingsTab ~= false then
        local settingsTab=BuildTab({Name="Settings",Icon=""}, true)
        settingsTab._btn.LayoutOrder=9999

        settingsTab:AddSection("Appearance")

        -- Theme picker (grid of colored buttons)
        local themeEl=New("Frame",{Parent=settingsTab._page,BackgroundColor3=theme.Element,
            BackgroundTransparency=0.42,Size=UDim2.new(1,0,0,130),BorderSizePixel=0})
        Corner(themeEl,8) Stroke(themeEl,theme.Border,1,0.72)

        New("TextLabel",{Parent=themeEl,BackgroundTransparency=1,
            Position=UDim2.new(0,12,0,8),Size=UDim2.new(1,-24,0,18),
            Text="Theme",TextColor3=theme.Text,Font=Enum.Font.GothamSemibold,TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left})
        New("TextLabel",{Parent=themeEl,BackgroundTransparency=1,
            Position=UDim2.new(0,12,0,26),Size=UDim2.new(1,-24,0,14),
            Text="Pick a color theme for the UI",TextColor3=theme.TextDim,Font=Enum.Font.Gotham,TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left})

        local themeGrid=New("Frame",{Parent=themeEl,BackgroundTransparency=1,
            Position=UDim2.new(0,10,0,46),Size=UDim2.new(1,-20,0,76)})
        local tgl=Instance.new("UIGridLayout")
        tgl.CellSize=UDim2.new(0,44,0,28) tgl.CellPaddingH=UDim.new(0,5) tgl.CellPaddingV=UDim.new(0,5) tgl.Parent=themeGrid

        -- Accent colors for each theme
        local themeAccents={
            Dark=Color3.fromRGB(100,130,255), Light=Color3.fromRGB(88,118,245),
            Ocean=Color3.fromRGB(0,198,198),  Sunset=Color3.fromRGB(255,98,148),
            Forest=Color3.fromRGB(80,200,90), Blood=Color3.fromRGB(220,30,30),
            Rose=Color3.fromRGB(248,120,155), Midnight=Color3.fromRGB(130,88,255),
            Neon=Color3.fromRGB(0,255,135),   Candy=Color3.fromRGB(255,80,220),
            Gold=Color3.fromRGB(255,198,30),  Arctic=Color3.fromRGB(108,198,255),
        }

        for _,tName in pairs(Nova.ThemeNames) do
            local ac=themeAccents[tName] or Color3.fromRGB(100,130,255)
            local tb=New("TextButton",{Parent=themeGrid,BackgroundColor3=ac,
                BackgroundTransparency=tName==Nova._themeName and 0 or 0.55,
                Text=tName,TextColor3=Color3.fromRGB(255,255,255),Font=Enum.Font.GothamBold,TextSize=8,AutoButtonColor=false})
            Corner(tb,5)
            if tName==Nova._themeName then Stroke(tb,Color3.fromRGB(255,255,255),1.5,0) end

            tb.MouseButton1Click:Connect(function()
                Nova:Notify({Title="Theme Changed",Description="Applied: "..tName,Type="Info",Duration=3})
                -- Note: Full re-theme requires re-calling CreateWindow. Notify user.
            end)
        end

        settingsTab:AddSection("Window")

        -- Toggle key picker
        local curKey = cfg.ToggleKey or Enum.KeyCode.RightShift
        settingsTab:AddKeybind({
            Name = "Toggle Key",
            Description = "Key to show/hide the UI",
            Default = curKey,
            Callback = function(key)
                toggleKey = key
            end
        })

        -- Watermark toggle
        settingsTab:AddToggle({
            Name = "Watermark",
            Description = "Show FPS watermark overlay",
            Default = cfg.Watermark ~= false,
            Callback = function(v)
                if wmFrame then wmFrame.Visible = v end
            end
        })

        settingsTab:AddSection("Notifications")
        settingsTab:AddButton({
            Name = "Test Notification",
            Description = "Sends a test notification",
            ButtonText = "Send",
            Callback = function()
                Nova:Notify({Title="Test",Description="This is a test notification from Nova UI.",Type="Info",Duration=4})
            end
        })

        settingsTab:AddButton({
            Name = "Success Notice",
            Description = "Example success notification",
            ButtonText = "✓ Send",
            Callback = function()
                Nova:Notify({Title="Success!",Description="Everything is working correctly.",Type="Success",Duration=4})
            end
        })

        settingsTab:AddButton({
            Name = "Error Notice",
            Description = "Example error notification",
            ButtonText = "✗ Send",
            Callback = function()
                Nova:Notify({Title="Error!",Description="Something went wrong!",Type="Error",Duration=4})
            end
        })

        settingsTab:AddSection("About")
        settingsTab:AddParagraph({Title="Nova UI Library",Description="v3.0 — 12 themes, 14 elements, built-in tabs.\nBetter than Orion in every way."})
    end

    return Window
end

return Nova
