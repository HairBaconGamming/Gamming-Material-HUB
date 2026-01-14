--[[
    TITAN UI LIBRARY - ULTIMATE EDITION
    Author: Gemini Refactored
    Version: 3.0.0 (Heavy Duty)
    
    Features:
    - Multi-Columns (Left/Right)
    - Multi-Select Dropdowns with Search
    - Tooltip System
    - Dynamic Theming
    - Rich Elements (Images, Paragraphs)
    - Smooth Animations (TweenService)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

--// SIGNALS (Custom Event Handling for Performance) //--
local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({_connections = {}}, Signal)
end

function Signal:Connect(callback)
    local connection = {
        _signal = self,
        _callback = callback,
        Connected = true
    }
    table.insert(self._connections, connection)
    
    function connection:Disconnect()
        self.Connected = false
        for i, v in pairs(self._signal._connections) do
            if v == self then
                table.remove(self._signal._connections, i)
                break
            end
        end
    end
    
    return connection
end

function Signal:Fire(...)
    for _, connection in ipairs(self._connections) do
        if connection.Connected then
            task.spawn(connection._callback, ...)
        end
    end
end

--// THEME SYSTEM //--
local ThemeManager = {
    Current = {
        Main        = Color3.fromRGB(20, 20, 25),
        Secondary   = Color3.fromRGB(30, 30, 35),
        Stroke      = Color3.fromRGB(50, 50, 60),
        Divider     = Color3.fromRGB(40, 40, 45),
        Accent      = Color3.fromRGB(0, 160, 255),
        Text        = Color3.fromRGB(240, 240, 240),
        TextDark    = Color3.fromRGB(150, 150, 150),
        Hover       = Color3.fromRGB(40, 40, 50),
        Success     = Color3.fromRGB(100, 255, 100),
        Warning     = Color3.fromRGB(255, 200, 50),
        Error       = Color3.fromRGB(255, 60, 60),
        FontMain    = Enum.Font.GothamMedium,
        FontBold    = Enum.Font.GothamBold,
    },
    Objects = {} -- Stores objects to update when theme changes
}

function ThemeManager:UpdateTheme(NewTheme)
    for k, v in pairs(NewTheme) do
        if self.Current[k] then self.Current[k] = v end
    end
    -- Trigger visual updates for all registered objects
    for obj, propertyData in pairs(self.Objects) do
        if obj.Parent then -- Check if object still exists
            for prop, themeKey in pairs(propertyData) do
                TweenService:Create(obj, TweenInfo.new(0.3), {[prop] = self.Current[themeKey]}):Play()
            end
        else
            self.Objects[obj] = nil
        end
    end
end

function ThemeManager:Register(instance, property, themeKey)
    if not self.Objects[instance] then self.Objects[instance] = {} end
    self.Objects[instance][property] = themeKey
    instance[property] = self.Current[themeKey]
end

--// UTILITY //--
local Utility = {}

function Utility:Create(class, properties, children)
    local inst = Instance.new(class)
    for k, v in pairs(properties or {}) do
        inst[k] = v
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

function Utility:Tween(inst, info, props)
    local t = TweenService:Create(inst, TweenInfo.new(unpack(info)), props)
    t:Play()
    return t
end

function Utility:GetTextSize(text, font, size, width)
    return TextService:GetTextSize(text, size, font, Vector2.new(width or 10000, 10000))
end

function Utility:MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(object, {0.05}, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
end

function Utility:Ripple(btn)
    task.spawn(function()
        local ripple = Utility:Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0,0,0,0),
            Parent = btn,
            ZIndex = 10
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})
        
        Utility:Tween(ripple, {0.5}, {Size = UDim2.fromScale(2.5, 2.5), BackgroundTransparency = 1})
        task.wait(0.5)
        ripple:Destroy()
    end)
end

--// LIBRARY CORE //--
local Library = {
    Opened = true,
    ScreenGui = nil,
    MainFrame = nil,
    Tooltip = nil,
    ActiveDropdown = nil,

    Flags = {},
    Options = {},
    ConfigFolder = "TitanConfig"
}

function Library:Notify(config)
    local Title = config.Title or "Notification"
    local Content = config.Content or "Message..."
    local Duration = config.Duration or 3
    local Image = config.Image or "rbxassetid://6031094678" -- Icon info

    -- Tạo container nếu chưa có
    if not self.NotifyContainer then
        self.NotifyContainer = Utility:Create("Frame", {
            Name = "NotifyContainer",
            Parent = self.ScreenGui,
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -310, 0, 20),
            BackgroundTransparency = 1,
            ZIndex = 100
        }, {
            Utility:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                VerticalAlignment = Enum.VerticalAlignment.Bottom
            })
        })
    end

    -- Tạo khung thông báo
    local Frame = Utility:Create("Frame", {
        Parent = self.NotifyContainer,
        Size = UDim2.new(1, 0, 0, 0), -- Bắt đầu size 0 để animation
        BackgroundColor3 = ThemeManager.Current.Secondary,
        ClipsDescendants = true,
        BackgroundTransparency = 0.1
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1}),
        Utility:Create("ImageLabel", { -- Icon
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(0, 10, 0, 13),
            BackgroundTransparency = 1,
            Image = Image,
            ImageColor3 = ThemeManager.Current.Accent
        }),
        Utility:Create("TextLabel", { -- Title
            Text = Title,
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 45, 0, 5),
            BackgroundTransparency = 1,
            TextColor3 = ThemeManager.Current.Text,
            Font = ThemeManager.Current.FontBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", { -- Content
            Text = Content,
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 45, 0, 25),
            BackgroundTransparency = 1,
            TextColor3 = ThemeManager.Current.TextDark,
            Font = ThemeManager.Current.FontMain,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
    })

    -- Animation In
    Utility:Tween(Frame, {0.3}, {Size = UDim2.new(1, 0, 0, 60)})
    
    -- Sound Effect (Optional)
    local Sound = Instance.new("Sound", workspace)
    Sound.SoundId = "rbxassetid://4590657391"
    Sound.Volume = 0.5
    Sound:Play()
    game.Debris:AddItem(Sound, 1)

    -- Auto Close
    task.delay(Duration, function()
        Utility:Tween(Frame, {0.3}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        task.wait(0.3)
        Frame:Destroy()
    end)
end

function Library:Watermark(text)
    if self.WatermarkFrame then self.WatermarkFrame:Destroy() end

    self.WatermarkFrame = Utility:Create("Frame", {
        Name = "Watermark",
        Parent = self.ScreenGui,
        Size = UDim2.fromOffset(200, 26), -- Chiều rộng sẽ tự động chỉnh
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = ThemeManager.Current.Main,
        ZIndex = 50
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1}),
        Utility:Create("TextLabel", {
            Name = "Text",
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = ThemeManager.Current.Text,
            Font = ThemeManager.Current.FontMain,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = text or "Titan UI | FPS: 60 | Ping: 50ms"
        })
    })

    -- Logic cập nhật FPS và Ping
    RunService.RenderStepped:Connect(function()
        if not self.WatermarkFrame.Parent then return end
        
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        local time = os.date("%H:%M:%S")
        
        local content = string.format("%s | FPS: %d | Ping: %dms | %s", text, fps, ping, time)
        self.WatermarkFrame.Text.Text = content
        
        -- Auto resize
        local size = TextService:GetTextSize(content, 13, ThemeManager.Current.FontMain, Vector2.new(1000, 26))
        self.WatermarkFrame.Size = UDim2.fromOffset(size.X + 24, 26)
    end)
end

function Library:Modal(config)
    local Title = config.Title or "Alert"
    local Content = config.Content or "Are you sure?"
    local OnConfirm = config.OnConfirm or function() end
    local OnCancel = config.OnCancel or function() end
    
    -- Tạo màng đen che mờ UI
    local Overlay = Utility:Create("Frame", {
        Parent = self.ScreenGui,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1,
        ZIndex = 200
    })
    Utility:Tween(Overlay, {0.2}, {BackgroundTransparency = 0.6})
    
    -- Khung Modal
    local ModalFrame = Utility:Create("Frame", {
        Parent = Overlay,
        Size = UDim2.fromOffset(300, 150),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager.Current.Main,
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1}),
        Utility:Create("UIScale", {Scale = 0}) -- Dùng Scale để animation popup
    })
    
    Utility:Tween(ModalFrame.UIScale, {0.3, Enum.EasingStyle.Back}, {Scale = 1})

    -- Text
    Utility:Create("TextLabel", {
        Parent = ModalFrame,
        Text = Title,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        TextColor3 = ThemeManager.Current.Accent,
        Font = ThemeManager.Current.FontBold,
        TextSize = 18
    })
    
    Utility:Create("TextLabel", {
        Parent = ModalFrame,
        Text = Content,
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1,
        TextColor3 = ThemeManager.Current.Text,
        Font = ThemeManager.Current.FontMain,
        TextSize = 14,
        TextWrapped = true
    })
    
    -- Buttons Container
    local BtnHolder = Utility:Create("Frame", {
        Parent = ModalFrame,
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 1, -45),
        BackgroundTransparency = 1
    }, {
        Utility:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal, 
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
    })
    
    local function CreateBtn(txt, color, callback)
        local btn = Utility:Create("TextButton", {
            Parent = BtnHolder,
            Size = UDim2.new(0.48, 0, 1, 0),
            BackgroundColor3 = color,
            Text = txt,
            TextColor3 = ThemeManager.Current.Text,
            Font = ThemeManager.Current.FontBold,
            TextSize = 13
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
        
        btn.MouseButton1Click:Connect(function()
            Utility:Tween(ModalFrame.UIScale, {0.2}, {Scale = 0})
            Utility:Tween(Overlay, {0.2}, {BackgroundTransparency = 1})
            task.delay(0.2, function() Overlay:Destroy() end)
            callback()
        end)
    end
    
    CreateBtn("Confirm", ThemeManager.Current.Accent, OnConfirm)
    CreateBtn("Cancel", ThemeManager.Current.Secondary, OnCancel)
end

-- Tạo Folder nếu chưa có
if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end

function Library:SaveConfig(name)
    if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end
    
    local json = HttpService:JSONEncode(Library.Flags)
    writefile(Library.ConfigFolder .. "/" .. name .. ".json", json)
    Library:Notify({Title = "Config", Content = "Successfully saved: " .. name})
end

function Library:LoadConfig(name)
    local file = Library.ConfigFolder .. "/" .. name .. ".json"
    if not isfile(file) then
        Library:Notify({Title = "Error", Content = "Config file not found!", Image = "rbxassetid://6031094670"})
        return
    end

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(file))
    end)

    if not success then
        Library:Notify({Title = "Error", Content = "Corrupted JSON file!"})
        return
    end

    -- Bắt đầu load từng giá trị
    for flag, value in pairs(data) do
        local element = Library.Options[flag]
        
        if element then
            -- Xử lý đặc biệt cho Color3 (Vì JSON lưu màu dưới dạng table {R, G, B})
            if type(value) == "table" and value.R and value.G and value.B then
                value = Color3.new(value.R, value.G, value.B)
            end
            
            -- Xử lý đặc biệt cho Keybind (JSON lưu dưới dạng string tên phím)
            if type(value) == "string" and element.Type == "Keybind" then
                -- Logic convert String -> Enum.KeyCode nằm ở element Keybind
                -- Ở đây ta cứ truyền string, element tự lo
            end

            -- Gọi hàm Set của element để cập nhật UI + Trigger Callback
            if element.Set then
                element:Set(value)
            end
        end
    end
    
    Library:Notify({Title = "Config", Content = "Loaded configuration: " .. name})
end

function Library:GetConfigs()
    local cfgs = {}
    if isfolder(Library.ConfigFolder) then
        for _, file in ipairs(listfiles(Library.ConfigFolder)) do
            if file:sub(-5) == ".json" then
                local pos = file:find(Library.ConfigFolder)
                table.insert(cfgs, file:sub(pos + #Library.ConfigFolder + 1, -6))
            end
        end
    end
    return cfgs
end

function Library:Init(config)
    local Title = config.Title or "Titan UI"
    
    if CoreGui:FindFirstChild("TitanUI_Lib") then CoreGui.TitanUI_Lib:Destroy() end
    
    self.ScreenGui = Utility:Create("ScreenGui", {Name = "TitanUI_Lib", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- Tooltip Container
    self.Tooltip = Utility:Create("TextLabel", {
        Name = "Tooltip",
        Parent = self.ScreenGui,
        BackgroundColor3 = ThemeManager.Current.Secondary,
        TextColor3 = ThemeManager.Current.Text,
        Font = ThemeManager.Current.FontMain,
        TextSize = 12,
        Size = UDim2.fromOffset(0,0),
        Visible = false,
        ZIndex = 1000,
        AutoLocalize = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
        Utility:Create("UIPadding", {PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6)})
    })
    
    -- Register Tooltip Styling
    ThemeManager:Register(self.Tooltip, "BackgroundColor3", "Secondary")
    ThemeManager:Register(self.Tooltip, "TextColor3", "Text")
    ThemeManager:Register(self.Tooltip.UIStroke, "Color", "Stroke")

    -- Main Window
    self.MainFrame = Utility:Create("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        Size = UDim2.fromOffset(750, 500),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager.Current.Main,
        ClipsDescendants = false -- Important for shadows
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
        Utility:Create("ImageLabel", { -- Shadow
            Name = "Shadow",
            BackgroundTransparency = 1,
            Image = "rbxassetid://6015897843",
            Size = UDim2.new(1, 44, 1, 44),
            Position = UDim2.new(0, -22, 0, -22),
            ImageColor3 = Color3.fromRGB(0,0,0),
            ImageTransparency = 0.4,
            ZIndex = 0
        })
    })
    
    ThemeManager:Register(self.MainFrame, "BackgroundColor3", "Main")
    ThemeManager:Register(self.MainFrame.UIStroke, "Color", "Stroke")

    -- Topbar
    local Topbar = Utility:Create("Frame", {
        Name = "Topbar",
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.Current.Secondary,
        BorderSizePixel = 0
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Utility:Create("Frame", { -- Square off bottom
            BackgroundColor3 = ThemeManager.Current.Secondary,
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 1, -10),
            BorderSizePixel = 0
        }),
        Utility:Create("TextLabel", {
            Text = Title,
            Font = ThemeManager.Current.FontBold,
            TextSize = 16,
            TextColor3 = ThemeManager.Current.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    
    ThemeManager:Register(Topbar, "BackgroundColor3", "Secondary")
    ThemeManager:Register(Topbar.Frame, "BackgroundColor3", "Secondary")
    ThemeManager:Register(Topbar.TextLabel, "TextColor3", "Text")
    
    Utility:MakeDraggable(Topbar, self.MainFrame)

    -- Containers
    local TabContainer = Utility:Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = self.MainFrame,
        Size = UDim2.new(0, 160, 1, -41),
        Position = UDim2.new(0, 0, 0, 41),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, {
        Utility:Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}),
        Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})
    })

    local PageContainer = Utility:Create("Frame", {
        Name = "PageContainer",
        Parent = self.MainFrame,
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 165, 0, 45),
        BackgroundTransparency = 1
    })

    -- Divider
    local Sep = Utility:Create("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(0, 1, 1, -40),
        Position = UDim2.new(0, 160, 0, 40),
        BackgroundColor3 = ThemeManager.Current.Divider,
        BorderSizePixel = 0
    })
    ThemeManager:Register(Sep, "BackgroundColor3", "Divider")

    --// Tooltip Logic
    RunService.RenderStepped:Connect(function()
        if self.Tooltip.Visible then
            local mouse = UserInputService:GetMouseLocation()
            self.Tooltip.Position = UDim2.fromOffset(mouse.X + 15, mouse.Y + 15)
        end
    end)

    local Window = {}
    local FirstTab = true

    function Window:AddTab(name)
        local Tab = {Page = nil}
        
        -- Tab Button
        local TabBtn = Utility:Create("TextButton", {
            Parent = TabContainer,
            Size = UDim2.new(1, -10, 0, 32),
            BackgroundColor3 = ThemeManager.Current.Main,
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = ThemeManager.Current.TextDark,
            Font = ThemeManager.Current.FontMain,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
        })

        -- Tab Page
        Tab.Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page",
            Parent = PageContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ThemeManager.Current.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        ThemeManager:Register(Tab.Page, "ScrollBarImageColor3", "Accent")

        -- Column Setup
        local LeftCol = Utility:Create("Frame", {
            Name = "Left", Parent = Tab.Page, BackgroundTransparency = 1, 
            Size = UDim2.new(0.49, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)
        }, {
            Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        })
        
        local RightCol = Utility:Create("Frame", {
            Name = "Right", Parent = Tab.Page, BackgroundTransparency = 1, 
            Size = UDim2.new(0.49, 0, 1, 0), Position = UDim2.new(0.51, 0, 0, 0)
        }, {
            Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        })

        -- Activation
        local function Activate()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:Tween(v, {0.2}, {BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.TextDark})
                end
            end
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            
            Tab.Page.Visible = true
            Utility:Tween(TabBtn, {0.2}, {BackgroundTransparency = 0, BackgroundColor3 = ThemeManager.Current.Secondary, TextColor3 = ThemeManager.Current.Accent})
        end
        
        TabBtn.MouseButton1Click:Connect(Activate)
        
        if FirstTab then Activate(); FirstTab = false end

        --// GROUPBOX SYSTEM (For Columns) //--
        function Tab:AddGroupbox(config)
            local Title = config.Title or "Group"
            local Side = config.Side or "Left"
            local ParentCol = (Side == "Left" and LeftCol) or RightCol
            
            local Group = {}
            local IsCollapsed = false
            
            -- Frame chính
            local BoxFrame = Utility:Create("Frame", {
                Name = Title.."_Group",
                Parent = ParentCol,
                BackgroundColor3 = ThemeManager.Current.Secondary,
                Size = UDim2.new(1, 0, 0, 0), -- Auto
                AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = true -- Quan trọng để giấu nội dung khi thu nhỏ
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
            })
            ThemeManager:Register(BoxFrame, "BackgroundColor3", "Secondary")
            ThemeManager:Register(BoxFrame.UIStroke, "Color", "Stroke")

            -- Header (Tiêu đề + Nút đóng mở)
            local Header = Utility:Create("Frame", {
                Parent = BoxFrame,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1
            })

            local BoxTitle = Utility:Create("TextLabel", {
                Parent = Header,
                Text = Title,
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = ThemeManager.Current.Accent,
                Font = ThemeManager.Current.FontBold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            ThemeManager:Register(BoxTitle, "TextColor3", "Accent")

            -- Nút Mũi tên (Toggle Collapse)
            local CollapseBtn = Utility:Create("ImageButton", {
                Parent = Header,
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                BackgroundTransparency = 1,
                Image = "rbxassetid://6031090990", -- Arrow Up
                ImageColor3 = ThemeManager.Current.TextDark
            })

            -- Container chứa Elements
            local Content = Utility:Create("Frame", {
                Name = "Content",
                Parent = BoxFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 35), -- Dịch xuống dưới Header
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}),
                Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 8)})
            })

            -- Logic đóng mở
            local ContentHeight = 0
            
            -- Cập nhật chiều cao thực tế khi element thay đổi
            Content.ChildAdded:Connect(function() 
                if not IsCollapsed then BoxFrame.Size = UDim2.new(1, 0, 0, 0) end -- Reset để AutomaticSize tính lại
            end)

            CollapseBtn.MouseButton1Click:Connect(function()
                IsCollapsed = not IsCollapsed
                
                if IsCollapsed then
                    -- Lưu chiều cao hiện tại trước khi đóng
                    ContentHeight = Content.AbsoluteSize.Y + 45
                    -- Tắt AutomaticSize để tween được
                    BoxFrame.AutomaticSize = Enum.AutomaticSize.None
                    Content.Visible = false
                    Utility:Tween(BoxFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 30)}) -- Chiều cao chỉ bằng Header
                    Utility:Tween(CollapseBtn, {0.3}, {Rotation = 180})
                else
                    Content.Visible = true
                    local t = Utility:Tween(BoxFrame, {0.3}, {Size = UDim2.new(1, 0, 0, ContentHeight)})
                    Utility:Tween(CollapseBtn, {0.3}, {Rotation = 0})
                    
                    -- Bật lại AutoSize sau khi tween xong
                    t.Completed:Connect(function()
                        BoxFrame.AutomaticSize = Enum.AutomaticSize.Y
                    end)
                end
            end)

            local function AddTooltip(element, text)
                if not text or text == "" then return end
                
                -- Sự kiện khi di chuột vào
                element.MouseEnter:Connect(function()
                    local ScreenSize = Library.ScreenGui.AbsoluteSize
                    local MousePos = UserInputService:GetMouseLocation()
                    
                    Library.Tooltip.Text = text
                    
                    -- Tính toán kích thước text để resize khung Tooltip
                    local TextService = game:GetService("TextService")
                    local Fonts = ThemeManager.Current.FontMain
                    local Bounds = TextService:GetTextSize(text, 12, Fonts, Vector2.new(200, 1000)) -- Max width 200px
                    
                    Library.Tooltip.Size = UDim2.fromOffset(Bounds.X + 12, Bounds.Y + 8)
                    Library.Tooltip.Visible = true
                end)
                
                -- Sự kiện khi di chuột ra
                element.MouseLeave:Connect(function()
                    Library.Tooltip.Visible = false
                end)
            end

            --// ELEMENTS //--
            
            function Group:AddLabel(text, config)
                local opts = config or {}
                local LabelFuncs = {}
                
                local Lbl = Utility:Create("TextLabel", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = opts.Color or ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
                ThemeManager:Register(Lbl, "TextColor3", "Text")
                AddTooltip(Lbl, opts.Tooltip)
                
                function LabelFuncs:SetText(t) Lbl.Text = t end
                return LabelFuncs
            end

            function Group:AddParagraph(title, content)
                local Para = Utility:Create("Frame", {
                    Parent = Content,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
                })
                
                local T = Utility:Create("TextLabel", {
                    Parent = Para,
                    Text = title,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontBold,
                    TextSize = 13,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local C = Utility:Create("TextLabel", {
                    Parent = Para,
                    Text = content,
                    TextColor3 = ThemeManager.Current.TextDark,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
                ThemeManager:Register(T, "TextColor3", "Text")
                ThemeManager:Register(C, "TextColor3", "TextDark")
            end

            function Group:AddImage(id, config)
                local opts = config or {}
                local height = opts.Height or 100
                
                local ImgFrame = Utility:Create("ImageLabel", {
                    Parent = Content,
                    Image = "rbxassetid://"..tostring(id),
                    Size = UDim2.new(1, 0, 0, height),
                    BackgroundTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
                })
            end

            function Group:AddButton(text, callback, config)
                local opts = config or {}
                
                local Btn = Utility:Create("TextButton", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = ThemeManager.Current.Main,
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
                    Utility:Create("TextLabel", {
                        Text = text,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = ThemeManager.Current.Text,
                        Font = ThemeManager.Current.FontMain,
                        TextSize = 13
                    })
                })
                ThemeManager:Register(Btn, "BackgroundColor3", "Main")
                ThemeManager:Register(Btn.UIStroke, "Color", "Stroke")
                ThemeManager:Register(Btn.TextLabel, "TextColor3", "Text")
                AddTooltip(Btn, opts.Tooltip)

                Btn.MouseEnter:Connect(function()
                    Utility:Tween(Btn.UIStroke, {0.2}, {Color = ThemeManager.Current.Accent})
                    Utility:Tween(Btn.TextLabel, {0.2}, {TextColor3 = ThemeManager.Current.Accent})
                end)
                Btn.MouseLeave:Connect(function()
                    Utility:Tween(Btn.UIStroke, {0.2}, {Color = ThemeManager.Current.Stroke})
                    Utility:Tween(Btn.TextLabel, {0.2}, {TextColor3 = ThemeManager.Current.Text})
                end)
                
                Btn.MouseButton1Click:Connect(function()
                    Utility:Ripple(Btn)
                    pcall(callback)
                end)
            end

            function Group:AddToggle(text, default, callback, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local State = default or false
                
                local Container = Utility:Create("TextButton", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false
                })
                
                local Label = Utility:Create("TextLabel", {
                    Parent = Container,
                    Text = text,
                    Size = UDim2.new(1, -45, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")

                local Checkbox = Utility:Create("Frame", {
                    Parent = Container,
                    Size = UDim2.fromOffset(40, 20),
                    Position = UDim2.new(1, -40, 0.5, -10),
                    BackgroundColor3 = ThemeManager.Current.Main
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(Checkbox, "BackgroundColor3", "Main")
                ThemeManager:Register(Checkbox.UIStroke, "Color", "Stroke")

                local Indicator = Utility:Create("Frame", {
                    Parent = Checkbox,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = ThemeManager.Current.TextDark
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                ThemeManager:Register(Indicator, "BackgroundColor3", "TextDark")
                
                AddTooltip(Container, opts.Tooltip)
                
                local Funcs = {}
                
                -- Hàm Set cập nhật giá trị
                function Funcs:Set(val)
                    State = val
                    if State then
                        Utility:Tween(Checkbox, {0.2}, {BackgroundColor3 = ThemeManager.Current.Accent})
                        Utility:Tween(Indicator, {0.2}, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = ThemeManager.Current.Text})
                    else
                        Utility:Tween(Checkbox, {0.2}, {BackgroundColor3 = ThemeManager.Current.Main})
                        Utility:Tween(Indicator, {0.2}, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = ThemeManager.Current.TextDark})
                    end
                    -- QUAN TRỌNG: Lưu vào Flags
                    Library.Flags[Flag] = State
                    pcall(callback, State)
                end
                
                -- Đăng ký vào hệ thống
                Library.Options[Flag] = Funcs
                Library.Flags[Flag] = State -- Lưu giá trị mặc định ban đầu
                
                -- Khởi chạy trạng thái ban đầu
                Funcs:Set(State)
                -- Event Click (Sửa lại để dùng hàm Set)
                Container.MouseButton1Click:Connect(function()
                    Funcs:Set(not State)
                end)
            
                return Funcs
            end

            function Group:AddSlider(text, min, max, default, callback, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local Value = default or min
                
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1
                })
                
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                AddTooltip(Frame, opts.Tooltip)
                
                local ValLabel = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = tostring(Value),
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.TextDark,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ThemeManager:Register(ValLabel, "TextColor3", "TextDark")
                
                local Track = Utility:Create("Frame", {
                    Parent = Frame,
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = ThemeManager.Current.Main
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(Track, "BackgroundColor3", "Main")
                ThemeManager:Register(Track.UIStroke, "Color", "Stroke")
                
                local Fill = Utility:Create("Frame", {
                    Parent = Track,
                    Size = UDim2.fromScale(0, 1),
                    BackgroundColor3 = ThemeManager.Current.Accent
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                ThemeManager:Register(Fill, "BackgroundColor3", "Accent")
                
                local Interact = Utility:Create("TextButton", {Parent = Track, Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = ""})

                local Funcs = {}
                
                function Funcs:Set(val)
                    Value = math.clamp(tonumber(val) or min, min, max)
                    
                    -- Update UI
                    local percent = (Value - min) / (max - min)
                    Fill:TweenSize(UDim2.new(percent, 0, 1, 0), "Out", "Quad", 0.1, true)
                    ValLabel.Text = string.format("%.1f", Value)
                    
                    -- Lưu data
                    Library.Flags[Flag] = Value
                    pcall(callback, Value)
                end
            
                Library.Options[Flag] = Funcs
                Library.Flags[Flag] = Value
                
                Funcs:Set(Value) -- Init

                Interact.MouseButton1Down:Connect(function()
                    local move, kill
                    move = UserInputService.InputChanged:Connect(function(io)
                        if io.UserInputType == Enum.UserInputType.MouseMovement then
                            local scale = math.clamp((io.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                            Update(min + (max-min)*scale)
                        end
                    end)
                    kill = UserInputService.InputEnded:Connect(function(io)
                        if io.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect(); kill:Disconnect() end
                    end)
                    local scale = math.clamp((UserInputService:GetMouseLocation().X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    Funcs:Set(min + (max-min)*scale)
                end)
                return Funcs
            end

            --// COMPLEX DROPDOWN (Multi-Select + Search) //--
            function Group:AddDropdown(text, items, multi, callback, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local Multi = multi or false
                local Selected = Multi and {} or items[1]
                local IsOpen = false
                
                local Holder = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    ZIndex = 20 -- Higher ZIndex for dropdowns
                })
                
                local Label = Utility:Create("TextLabel", {
                    Parent = Holder,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                AddTooltip(Holder, opts.Tooltip)

                local MainBtn = Utility:Create("TextButton", {
                    Parent = Holder,
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = ThemeManager.Current.Main,
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
                    Utility:Create("ImageLabel", { -- Arrow
                        Image = "rbxassetid://6031091004",
                        Size = UDim2.fromOffset(20, 20),
                        Position = UDim2.new(1, -25, 0.5, -10),
                        BackgroundTransparency = 1,
                        ImageColor3 = ThemeManager.Current.TextDark
                    }),
                    Utility:Create("TextLabel", { -- Status Text
                        Name = "Status",
                        Size = UDim2.new(1, -30, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text = "...",
                        TextColor3 = ThemeManager.Current.TextDark,
                        Font = ThemeManager.Current.FontMain,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    })
                })
                ThemeManager:Register(MainBtn, "BackgroundColor3", "Main")
                ThemeManager:Register(MainBtn.UIStroke, "Color", "Stroke")

                -- Dropdown List Container
                local ListFrame = Utility:Create("Frame", {
                    Parent = MainBtn,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = ThemeManager.Current.Secondary,
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 30
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(ListFrame, "BackgroundColor3", "Secondary")

                -- Search Bar
                local SearchBar = Utility:Create("TextBox", {
                    Parent = ListFrame,
                    Size = UDim2.new(1, -10, 0, 20),
                    Position = UDim2.new(0, 5, 0, 5),
                    BackgroundColor3 = ThemeManager.Current.Main,
                    Text = "",
                    PlaceholderText = "Search...",
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    ZIndex = 31
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                ThemeManager:Register(SearchBar, "BackgroundColor3", "Main")
                ThemeManager:Register(SearchBar, "TextColor3", "Text")

                local ScrollList = Utility:Create("ScrollingFrame", {
                    Parent = ListFrame,
                    Size = UDim2.new(1, 0, 1, -30),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = ThemeManager.Current.Accent,
                    CanvasSize = UDim2.new(0,0,0,0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 31
                }, {
                    Utility:Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
                    Utility:Create("UIPadding", {PaddingLeft = UDim.new(0,5), PaddingRight=UDim.new(0,5)})
                })
                ThemeManager:Register(ScrollList, "ScrollBarImageColor3", "Accent")

                local function RefreshDisplay()
                    if Multi then
                        local count = 0
                        local txt = ""
                        for k, v in pairs(Selected) do 
                            if v then 
                                count = count + 1 
                                txt = txt .. k .. ", "
                            end 
                        end
                        MainBtn.Status.Text = (count == 0) and "None" or txt:sub(1, -3)
                    else
                        MainBtn.Status.Text = tostring(Selected)
                    end
                end

                local function Populate(search)
                    for _, v in pairs(ScrollList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    for _, item in pairs(items) do
                        if not search or string.find(string.lower(tostring(item)), string.lower(search)) then
                            local ItemBtn = Utility:Create("TextButton", {
                                Parent = ScrollList,
                                Size = UDim2.new(1, 0, 0, 22),
                                BackgroundTransparency = 1,
                                Text = tostring(item),
                                TextColor3 = ThemeManager.Current.TextDark,
                                Font = ThemeManager.Current.FontMain,
                                TextSize = 12,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                ZIndex = 32
                            })
                            
                            -- Highlight if selected
                            if (Multi and Selected[item]) or (not Multi and Selected == item) then
                                ItemBtn.TextColor3 = ThemeManager.Current.Accent
                            end
                            
                            ItemBtn.MouseButton1Click:Connect(function()
                                if Multi then
                                    Selected[item] = not Selected[item]
                                    ItemBtn.TextColor3 = Selected[item] and ThemeManager.Current.Accent or ThemeManager.Current.TextDark
                                else
                                    Selected = item
                                    IsOpen = false
                                    ListFrame.Visible = false
                                    MainBtn.ImageLabel.Rotation = 0
                                    Holder.Size = UDim2.new(1,0,0,45)
                                    Utility:Tween(Holder, {0.2}, {Size = UDim2.new(1,0,0,45)})
                                end
                                RefreshDisplay()
                                pcall(callback, Selected)
                            end)
                        end
                    end
                end

                SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
                    Populate(SearchBar.Text)
                end)

                MainBtn.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    
                    if IsOpen then
                        if Library.ActiveDropdown and Library.ActiveDropdown ~= Holder then
                            -- Close others logic here if needed
                        end
                        Library.ActiveDropdown = Holder
                        ListFrame.Visible = true
                        Populate()
                        local openHeight = math.min(#items * 24 + 35, 150)
                        ListFrame.Size = UDim2.new(1, 0, 0, openHeight)
                        -- Animate expansion
                        MainBtn.ImageLabel.Rotation = 180
                        -- Hack to make it overlay: We don't resize holder, we assume ZIndex handles it, 
                        -- BUT standard frames clip. 
                        -- For this "Heavy" lib, we usually resize the holder to push elements down.
                        Utility:Tween(Holder, {0.2}, {Size = UDim2.new(1, 0, 0, 45 + openHeight + 5)})
                    else
                        ListFrame.Visible = false
                        MainBtn.ImageLabel.Rotation = 0
                        Utility:Tween(Holder, {0.2}, {Size = UDim2.new(1, 0, 0, 45)})
                    end
                end)

                RefreshDisplay()

                local Funcs = {}
                    
                function Funcs:Set(val)
                    Selected = val
                    RefreshDisplay() 
                    
                    Library.Flags[Flag] = Selected
                    pcall(callback, Selected)
                end
                
                Library.Options[Flag] = Funcs
                Library.Flags[Flag] = Selected

                Funcs:Set(Selected) 
                return Funcs
            end
            
            function Group:AddColorPicker(text, default, callback)
                local Color = default or Color3.fromRGB(255,255,255)
                local opts = config or {}
                local Flag = opts.Flag or text
                local H, S, V = Color:ToHSV()
                local IsOpen = false
                
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true
                })
                
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(1, -50, 0, 30),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")

                local Preview = Utility:Create("TextButton", {
                    Parent = Frame,
                    Size = UDim2.fromOffset(40, 20),
                    Position = UDim2.new(1, -40, 0.5, -10),
                    BackgroundColor3 = Color,
                    Text = ""
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })

                -- Picker Container
                local PickerFrame = Utility:Create("Frame", {
                    Parent = Frame,
                    Size = UDim2.new(1, 0, 0, 120),
                    Position = UDim2.new(0, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Visible = false
                })
                
                local SVImg = Utility:Create("ImageLabel", {
                    Parent = PickerFrame,
                    Image = "rbxassetid://4155801252",
                    Size = UDim2.fromOffset(100, 100),
                    Position = UDim2.new(0, 0, 0, 10),
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                
                local SVCursor = Utility:Create("Frame", {
                    Parent = SVImg, Size = UDim2.fromOffset(4,4), AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundColor3 = Color3.new(1,1,1), Position = UDim2.fromScale(S, 1-V),
                    BorderSizePixel = 0
                })

                local HueImg = Utility:Create("ImageLabel", {
                    Parent = PickerFrame,
                    Image = "rbxassetid://3641079629", -- Hue gradient
                    Size = UDim2.fromOffset(20, 100),
                    Position = UDim2.new(0, 110, 0, 10),
                    BackgroundColor3 = Color3.new(1,1,1)
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                
                local HueCursor = Utility:Create("Frame", {
                    Parent = HueImg, Size = UDim2.new(1,0,0,2), BackgroundColor3 = Color3.new(0,0,0),
                    Position = UDim2.fromScale(0, 1-H), BorderSizePixel = 0
                })

                local Funcs = {}         
                
                local function Update()
                    Color = Color3.fromHSV(H, S, V)
                    Preview.BackgroundColor3 = Color
                    SVImg.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    Library.Flags[Flag] = {R = Color.R, G = Color.G, B = Color.B}
                    pcall(callback, Color)
                end

                function Funcs:Set(val)
                    H,S,V = val:ToHSV()
                    Update()
                end
                
                local function HandleInput(input, type)
                    if type == "SV" then
                        local rX = math.clamp(input.Position.X - SVImg.AbsolutePosition.X, 0, 100) / 100
                        local rY = math.clamp(input.Position.Y - SVImg.AbsolutePosition.Y, 0, 100) / 100
                        S = rX
                        V = 1 - rY
                        SVCursor.Position = UDim2.fromScale(S, rY)
                    elseif type == "Hue" then
                        local rY = math.clamp(input.Position.Y - HueImg.AbsolutePosition.Y, 0, 100) / 100
                        H = 1 - rY
                        HueCursor.Position = UDim2.fromScale(0, rY)
                    end
                    Update()
                end

                SVImg.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        local m = UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then HandleInput(i, "SV") end end)
                        local e; e = UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end)
                        HandleInput(inp, "SV")
                    end
                end)

                HueImg.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        local m = UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then HandleInput(i, "Hue") end end)
                        local e; e = UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end)
                        HandleInput(inp, "Hue")
                    end
                end)

                Preview.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    PickerFrame.Visible = IsOpen
                    Utility:Tween(Frame, {0.3}, {Size = UDim2.new(1, 0, 0, IsOpen and 160 or 30)})
                end)
            
                Library.Options[Flag] = Funcs
                Library.Flags[Flag] = {R = Color.R, G = Color.G, B = Color.B}
                Funcs:Set(Color) -- Init
                return Funcs
            end

            function Group:AddKeybind(text, default, callback, config)
                local opts = config or {}
                local Key = default or Enum.KeyCode.RightAlt
                local IsBinding = false
                
                -- Container
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                })
                AddTooltip(Frame, opts.Tooltip)

                -- Label
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(1, -90, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")

                -- Key Button
                local BindBtn = Utility:Create("TextButton", {
                    Parent = Frame,
                    Size = UDim2.new(0, 80, 0, 20),
                    Position = UDim2.new(1, -80, 0.5, -10),
                    BackgroundColor3 = ThemeManager.Current.Main,
                    Text = "[" .. Key.Name .. "]",
                    TextColor3 = ThemeManager.Current.TextDark,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(BindBtn, "BackgroundColor3", "Main")
                ThemeManager:Register(BindBtn.UIStroke, "Color", "Stroke")
                ThemeManager:Register(BindBtn, "TextColor3", "TextDark")

                -- Logic Binding
                BindBtn.MouseButton1Click:Connect(function()
                    if IsBinding then return end
                    IsBinding = true
                    BindBtn.Text = "[...]"
                    BindBtn.TextColor3 = ThemeManager.Current.Accent
                    
                    local inputWait
                    inputWait = UserInputService.InputBegan:Connect(function(input)
                        -- Chấp nhận Keyboard hoặc MouseButton
                        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:find("MouseButton") then
                            IsBinding = false
                            
                            -- Nếu ấn Escape thì hủy bind (giữ phím cũ) hoặc clear (tùy chọn)
                            if input.KeyCode == Enum.KeyCode.Escape then
                                -- Giữ nguyên hoặc đặt thành None
                            else
                                Key = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode) or input.UserInputType
                            end
                            
                            -- Cập nhật Text
                            local keyName = (typeof(Key) == "EnumItem") and Key.Name or Key
                            BindBtn.Text = "[" .. tostring(keyName) .. "]"
                            BindBtn.TextColor3 = ThemeManager.Current.TextDark
                            
                            -- Gọi callback báo key mới đã được set (Optional)
                            -- pcall(callback, Key) 
                            
                            inputWait:Disconnect()
                        end
                    end)
                end)

                -- Logic Trigger (Kích hoạt callback khi ấn phím)
                UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and not IsBinding then
                        local inputKey = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode) or input.UserInputType
                        if inputKey == Key then
                            pcall(callback, Key) -- Trigger hành động
                            
                            -- Visual Effect nhỏ khi ấn
                            Utility:Tween(BindBtn, {0.1}, {TextColor3 = ThemeManager.Current.Accent})
                            task.delay(0.1, function()
                                Utility:Tween(BindBtn, {0.2}, {TextColor3 = ThemeManager.Current.TextDark})
                            end)
                        end
                    end
                end)
                
                -- Trả về helper để script ngoài có thể đổi key
                local Funcs = {}
                function Funcs:Set(newKey)
                    Key = newKey
                    BindBtn.Text = "[" .. tostring(Key.Name) .. "]"
                end
                return Funcs
            end

            function Group:AddInput(text, config)
                local opts = config or {}
                local Default = opts.Default or ""
                local Callback = opts.Callback or function() end
                local Numeric = opts.Numeric or false
                local Finished = opts.Finished or true -- True: Chỉ gọi callback khi Enter/Mất focus
                
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                })
                AddTooltip(Frame, opts.Tooltip)
                
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                
                local InputFrame = Utility:Create("Frame", {
                    Parent = Frame,
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = ThemeManager.Current.Main,
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(InputFrame, "BackgroundColor3", "Main")
                ThemeManager:Register(InputFrame.UIStroke, "Color", "Stroke")
                
                local Box = Utility:Create("TextBox", {
                    Parent = InputFrame,
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = Default,
                    PlaceholderText = opts.Placeholder or "Type here...",
                    TextColor3 = ThemeManager.Current.Text,
                    PlaceholderColor3 = ThemeManager.Current.TextDark,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false
                })
                ThemeManager:Register(Box, "TextColor3", "Text")
                ThemeManager:Register(Box, "PlaceholderColor3", "TextDark")
                
                -- Focus Animation
                Box.Focused:Connect(function()
                    Utility:Tween(InputFrame.UIStroke, {0.2}, {Color = ThemeManager.Current.Accent})
                end)
                
                Box.FocusLost:Connect(function(enter)
                    Utility:Tween(InputFrame.UIStroke, {0.2}, {Color = ThemeManager.Current.Stroke})
                    if Numeric then
                        local num = tonumber(Box.Text)
                        if not num then Box.Text = Default else Box.Text = tostring(num) end
                    end
                    if Finished then Callback(Box.Text) end
                end)
                
                if not Finished then
                    Box:GetPropertyChangedSignal("Text"):Connect(function()
                        if Numeric and not tonumber(Box.Text) and Box.Text ~= "" then 
                            Box.Text = Box.Text:sub(1, -2) 
                        else
                            Callback(Box.Text)
                        end
                    end)
                end
                
                local Funcs = {}
                function Funcs:Set(t) Box.Text = t; Callback(t) end
                function Funcs:Get() return Box.Text end
                return Funcs
            end

            --// 2. PROGRESS BAR (Thanh tiến trình) //--
            function Group:AddProgressBar(text, config)
                local opts = config or {}
                local Default = opts.Default or 0
                local Max = opts.Max or 100
                
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1
                })
                AddTooltip(Frame, opts.Tooltip)
                
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                
                local ValueLabel = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = math.floor((Default/Max)*100).."%",
                    Size = UDim2.new(1, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.TextDark,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ThemeManager:Register(ValueLabel, "TextColor3", "TextDark")
                
                local BarBG = Utility:Create("Frame", {
                    Parent = Frame,
                    Size = UDim2.new(1, 0, 0, 14),
                    Position = UDim2.new(0, 0, 0, 18),
                    BackgroundColor3 = ThemeManager.Current.Main
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(BarBG, "BackgroundColor3", "Main")
                ThemeManager:Register(BarBG.UIStroke, "Color", "Stroke")
                
                local BarFill = Utility:Create("Frame", {
                    Parent = BarBG,
                    Size = UDim2.fromScale(math.clamp(Default/Max, 0, 1), 1),
                    BackgroundColor3 = ThemeManager.Current.Accent
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                ThemeManager:Register(BarFill, "BackgroundColor3", "Accent")
                
                local Funcs = {}
                function Funcs:Set(val)
                    local percent = math.clamp(val/Max, 0, 1)
                    ValueLabel.Text = math.floor(percent*100).."%"
                    Utility:Tween(BarFill, {0.3}, {Size = UDim2.fromScale(percent, 1)})
                end
                return Funcs
            end

            --// 3. DIVIDER (Đường kẻ phân cách) //--
            function Group:AddDivider(text)
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1
                })
                
                local Line1 = Utility:Create("Frame", {
                    Parent = Frame,
                    BackgroundColor3 = ThemeManager.Current.Divider,
                    Size = UDim2.new(text and 0.35 or 1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0
                })
                ThemeManager:Register(Line1, "BackgroundColor3", "Divider")
                
                if text then
                    local Label = Utility:Create("TextLabel", {
                        Parent = Frame,
                        Text = text,
                        Size = UDim2.new(0.3, 0, 1, 0),
                        Position = UDim2.new(0.35, 0, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = ThemeManager.Current.TextDark,
                        Font = ThemeManager.Current.FontBold,
                        TextSize = 11
                    })
                    ThemeManager:Register(Label, "TextColor3", "TextDark")
                    
                    local Line2 = Utility:Create("Frame", {
                        Parent = Frame,
                        BackgroundColor3 = ThemeManager.Current.Divider,
                        Size = UDim2.new(0.35, 0, 0, 1),
                        Position = UDim2.new(0.65, 0, 0.5, 0),
                        BorderSizePixel = 0
                    })
                    ThemeManager:Register(Line2, "BackgroundColor3", "Divider")
                end
            end
            
            --// 4. DYNAMIC LABEL (Label hiển thị Status) //--
            function Group:AddStatusLabel(text, default)
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1
                })
                
                local Title = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Title, "TextColor3", "Text")
                
                local Value = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = default or "...",
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Accent,
                    Font = ThemeManager.Current.FontBold,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ThemeManager:Register(Value, "TextColor3", "Accent")
                
                local Funcs = {}
                function Funcs:Set(t) Value.Text = t end
                function Funcs:SetColor(c) Value.TextColor3 = c end
                return Funcs
            end

            return Group
        end

        return Tab
    end

    --// SETTINGS TAB (Built-in) //--
    local Settings = Window:AddTab("UI Settings")
    local ThemeGroup = Settings:AddGroupbox({Title = "Theme Manager", Side = "Left"})
    
    ThemeGroup:AddButton("Dark Theme", function()
        ThemeManager:UpdateTheme({
            Main = Color3.fromRGB(20, 20, 25),
            Secondary = Color3.fromRGB(30, 30, 35),
            Text = Color3.fromRGB(240,240,240),
            Accent = Color3.fromRGB(0, 160, 255)
        })
    end, {Tooltip = "Switch to a dark color theme"})
    
    ThemeGroup:AddButton("Light Theme", function()
        ThemeManager:UpdateTheme({
            Main = Color3.fromRGB(240, 240, 245),
            Secondary = Color3.fromRGB(255, 255, 255),
            Stroke = Color3.fromRGB(200, 200, 200),
            Text = Color3.fromRGB(30, 30, 30),
            TextDark = Color3.fromRGB(100, 100, 100),
            Accent = Color3.fromRGB(0, 120, 215)
        })
    end, {Tooltip = "Switch to a light color theme"})
    
    local KeybindGroup = Settings:AddGroupbox({Title = "Menu Key", Side = "Right"})

    KeybindGroup:AddKeybind("Toggle Menu", Enum.KeyCode.RightControl, function(key)
        Library:Toggle(key)
    end, {Tooltip = "Press to show/hide the menu"})

    local ConfigGroup = Settings:AddGroupbox({Title = "Config Manager", Side = "Right"})
        
    local ConfigName = ConfigGroup:AddInput("Config Name", {Placeholder = "MySetting"})
    local ConfigList = ConfigGroup:AddDropdown("Available Configs", Library:GetConfigs(), false, function() end)
    
    ConfigGroup:AddButton("Save Config", function()
        local name = ConfigName:Get()
        if name and name ~= "" then
            Library:SaveConfig(name)
            ConfigList:Refresh(Library:GetConfigs()) -- Cần thêm hàm Refresh cho Dropdown (xem bên dưới)
        else
                Library:Notify({Title="Error", Content="Please enter a config name"})
        end
    end)
    
    ConfigGroup:AddButton("Load Config", function()
        local selected = ConfigList:Get() -- Cần hàm Get cho Dropdown
        if selected then
                Library:LoadConfig(selected)
        end
    end)
    
    ConfigGroup:AddButton("Refresh List", function()
        ConfigList:Refresh(Library:GetConfigs())
    end)
    return Window
end

return Library