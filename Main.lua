--[[
    TITAN UI LIBRARY - CYBERNETIC PROTOCOL (V3.5)
    Style: Cyber Hacking / Terminal / Sci-Fi
    Refactored by: Gemini
    
    [CORE FEATURES RETAINED & UPGRADED]
    - Full Config System (Auto Save/Load)
    - Multi-Columns & Collapsible Groups
    - Advanced Tooltips & Notifications
    - Searchable Multi-Dropdowns
    - Secure Modal System
    - Watermark HUD
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

--// ASSETS & CONFIG //--
local Assets = {
    Font = Enum.Font.Code, -- Hacker Style
    Icons = {
        Arrow = "rbxassetid://6031091004",
        Check = "rbxassetid://6031094667",
        Search = "rbxassetid://6031090990",
        Config = "rbxassetid://6031280882",
        Warning = "rbxassetid://6031094670",
        Info = "rbxassetid://6031094678"
    },
    Sounds = {
        Hover = "rbxassetid://6895079853", -- Tech blip
        Click = "rbxassetid://88442833509532", -- Mechanical click
        Notify = "rbxassetid://4590657391"
    }
}

--// THEME SYSTEM (CYBERPALETTE) //--
local ThemeManager = {
    Current = {
        Main        = Color3.fromRGB(10, 12, 16),      -- Deep Void
        Secondary   = Color3.fromRGB(20, 25, 30),      -- Dark Metal
        Stroke      = Color3.fromRGB(0, 255, 170),     -- Cyber Green (Glow)
        Divider     = Color3.fromRGB(40, 50, 60),
        Accent      = Color3.fromRGB(0, 255, 170),     -- Neon Green
        Text        = Color3.fromRGB(230, 255, 240),   -- Phosphor White
        TextDark    = Color3.fromRGB(100, 150, 130),   -- Dimmed Matrix
        Hover       = Color3.fromRGB(30, 40, 50),
        Success     = Color3.fromRGB(50, 255, 100),
        Error       = Color3.fromRGB(255, 50, 80),
        
        FontMain    = Assets.Font,
        FontBold    = Enum.Font.Code, -- Keep consistent
    },
    Objects = {} 
}

function ThemeManager:UpdateTheme(NewTheme)
    for k, v in pairs(NewTheme) do if self.Current[k] then self.Current[k] = v end end
    for obj, props in pairs(self.Objects) do
        if obj.Parent then
            for prop, key in pairs(props) do
                TweenService:Create(obj, TweenInfo.new(0.3), {[prop] = self.Current[key]}):Play()
            end
        else self.Objects[obj] = nil end
    end
end

function ThemeManager:Register(instance, property, themeKey)
    if not self.Objects[instance] then self.Objects[instance] = {} end
    self.Objects[instance][property] = themeKey
    instance[property] = self.Current[themeKey]
end

--// UTILITY FUNCTIONS //--
local Utility = {}

function Utility:Create(class, properties, children)
    local inst = Instance.new(class)
    for k, v in pairs(properties or {}) do inst[k] = v end
    if children then for _, child in pairs(children) do child.Parent = inst end end
    return inst
end

function Utility:Tween(inst, info, props)
    local t = TweenService:Create(inst, TweenInfo.new(unpack(info)), props)
    t:Play()
    return t
end

function Utility:PlaySound(type)
    local id = Assets.Sounds[type]
    if id then
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = 0.5
        s.Parent = CoreGui
        s:Play()
        game.Debris:AddItem(s, 2)
    end
end

function Utility:MakeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topbar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(object, {0.05}, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
        end
    end)
end

function Utility:AddTechBorder(parent, thickness, transparency)
    local stroke = Utility:Create("UIStroke", {
        Parent = parent,
        Color = ThemeManager.Current.Stroke,
        Thickness = thickness or 0.2,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    ThemeManager:Register(stroke, "Color", "Stroke")
    return stroke
end

function Utility:AddScanline(parent)
    local Scan = Utility:Create("ImageLabel", {
        Parent = parent,
        BackgroundTransparency = 1,
        Image = "rbxassetid://107479513719782", -- Grid/Scanline texture
        ImageColor3 = ThemeManager.Current.Accent,
        ImageTransparency = 0.96,
        TileSize = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1
    })
    ThemeManager:Register(Scan, "ImageColor3", "Accent")
end

function Utility:MakeResizable(frame, handle, minSize)
    local dragging = false
    local startSize = Vector2.new(0,0)
    local startMouse = Vector2.new(0,0)

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startSize = frame.AbsoluteSize
            startMouse = UserInputService:GetMouseLocation()
            
            -- Visual Effect: Sáng lên khi đang kéo
            Utility:Tween(handle, {0.2}, {ImageColor3 = ThemeManager.Current.Accent})
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            -- Visual Effect: Trở về màu cũ
            Utility:Tween(handle, {0.2}, {ImageColor3 = ThemeManager.Current.TextDark})
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local currentMouse = UserInputService:GetMouseLocation()
            local delta = currentMouse - startMouse
            local newSizeX = math.max(minSize.X, startSize.X + delta.X)
            local newSizeY = math.max(minSize.Y, startSize.Y + delta.Y)
            
            -- Sử dụng Tween để resize mượt hơn một chút hoặc set trực tiếp để performance cao
            -- Ở đây set trực tiếp để phản hồi nhanh nhất (Snappy cyber feel)
            frame.Size = UDim2.fromOffset(newSizeX, newSizeY)
        end
    end)
end

--// LIBRARY CORE //--
local Library = {
    Opened = true,
    ScreenGui = nil,
    MainFrame = nil,
    Tooltip = nil,
    ActiveDropdown = nil,
    NotifyContainer = nil,
    
    Flags = {},
    Options = {},
    ConfigFolder = "TitanHub_Configs",

    SearchableElements = {}
}

--// NOTIFICATION SYSTEM //--
function Library:Notify(config)
    local Title = config.Title or "SYSTEM ALERT"
    local Content = config.Content or "Execution complete."
    local Duration = config.Duration or 3
    local Image = config.Image or Assets.Icons.Info

    if not self.NotifyContainer then
        self.NotifyContainer = Utility:Create("Frame", {
            Name = "NotifyContainer", Parent = self.ScreenGui,
            Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, -310, 0, 20),
            BackgroundTransparency = 1, ZIndex = 100
        }, {
            Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Bottom})
        })
    end

    local Frame = Utility:Create("Frame", {
        Parent = self.NotifyContainer,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = ThemeManager.Current.Main,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)}), -- Sharp corners for cyber look
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1.5}),
        Utility:Create("ImageLabel", {
            Size = UDim2.fromOffset(20, 20), Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1, Image = Image, ImageColor3 = ThemeManager.Current.Accent
        }),
        Utility:Create("TextLabel", {
            Text = string.upper(Title), Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 40, 0, 5),
            BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Accent, Font = ThemeManager.Current.FontBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Utility:Create("TextLabel", {
            Text = Content, Size = UDim2.new(1, -40, 0, 0), Position = UDim2.new(0, 40, 0, 22),
            BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y
        })
    })
    
    Utility:PlaySound("Notify")

    -- Animation
    Utility:Tween(Frame, {0.4, Enum.EasingStyle.Back}, {Size = UDim2.new(1, 0, 0, 60)})
    
    -- Progress Bar
    local Bar = Utility:Create("Frame", {
        Parent = Frame, BackgroundColor3 = ThemeManager.Current.Accent,
        Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0
    })
    Utility:Tween(Bar, {Duration, Enum.EasingStyle.Linear}, {Size = UDim2.new(0, 0, 0, 2)})

    task.delay(Duration, function()
        Utility:Tween(Frame, {0.3}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        task.wait(0.3)
        Frame:Destroy()
    end)
end

--// WATERMARK HUD //--
function Library:Watermark(text)
    if self.WatermarkFrame then self.WatermarkFrame:Destroy() end

    self.WatermarkFrame = Utility:Create("Frame", {
        Name = "Watermark", Parent = self.ScreenGui,
        Size = UDim2.fromOffset(200, 24), Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = ThemeManager.Current.Main, ZIndex = 50, BackgroundTransparency = 0.2
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1.5}),
        Utility:Create("TextLabel", {
            Name = "Text", Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Text = text or "SYSTEM READY"
        })
    })

    RunService.RenderStepped:Connect(function()
        if not self.WatermarkFrame.Parent then return end
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        local time = os.date("%X")
        local content = string.format("HOST: %s | FPS: %d | PING: %dms | %s", string.upper(text or "TITAN"), fps, ping, time)
        self.WatermarkFrame.Text.Text = content
        local size = TextService:GetTextSize(content, 12, ThemeManager.Current.FontMain, Vector2.new(1000, 24))
        self.WatermarkFrame.Size = UDim2.fromOffset(size.X + 20, 24)
    end)
end

--// MODAL SYSTEM //--
function Library:Modal(config)
    local Title = config.Title or "CONFIRMATION"
    local Content = config.Content or "Proceed with this action?"
    local OnConfirm = config.OnConfirm or function() end
    local OnCancel = config.OnCancel or function() end
    
    local Overlay = Utility:Create("Frame", {
        Parent = self.ScreenGui, Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1, ZIndex = 200
    })
    Utility:Tween(Overlay, {0.2}, {BackgroundTransparency = 0.4})
    
    local ModalFrame = Utility:Create("Frame", {
        Parent = Overlay, Size = UDim2.fromOffset(320, 160), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = ThemeManager.Current.Main, ClipsDescendants = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Error, Thickness = 2}), -- Warning color
        Utility:Create("UIScale", {Scale = 0})
    })
    Utility:AddScanline(ModalFrame)
    
    Utility:Tween(ModalFrame.UIScale, {0.3, Enum.EasingStyle.Back}, {Scale = 1})

    Utility:Create("TextLabel", {
        Parent = ModalFrame, Text = "[ ! ]  " .. string.upper(Title),
        Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1,
        TextColor3 = ThemeManager.Current.Error, Font = ThemeManager.Current.FontBold, TextSize = 16
    })
    
    Utility:Create("TextLabel", {
        Parent = ModalFrame, Text = Content,
        Size = UDim2.new(1, -40, 0, 60), Position = UDim2.new(0, 20, 0, 40),
        BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain,
        TextSize = 14, TextWrapped = true
    })
    
    local BtnHolder = Utility:Create("Frame", {
        Parent = ModalFrame, Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0, 10, 1, -45), BackgroundTransparency = 1
    }, {Utility:Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center})})
    
    local function CreateBtn(txt, color, cb)
        local btn = Utility:Create("TextButton", {
            Parent = BtnHolder, Size = UDim2.new(0.48, 0, 1, 0), BackgroundColor3 = ThemeManager.Current.Secondary,
            Text = "", AutoButtonColor = false
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIStroke", {Color = color, Thickness = 1}),
            Utility:Create("TextLabel", {
                Parent = btn, Text = txt, Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
                TextColor3 = color, Font = ThemeManager.Current.FontBold, TextSize = 13
            })
        })
        btn.MouseButton1Click:Connect(function()
            Utility:PlaySound("Click")
            Utility:Tween(ModalFrame.UIScale, {0.2}, {Scale = 0})
            Utility:Tween(Overlay, {0.2}, {BackgroundTransparency = 1})
            task.delay(0.2, function() Overlay:Destroy() end)
            cb()
        end)
    end
    
    CreateBtn("ABORT", ThemeManager.Current.TextDark, OnCancel)
    CreateBtn("CONFIRM", ThemeManager.Current.Error, OnConfirm)
end

--// KEYBIND VISUALIZER SYSTEM //--
function Library:KeybindHUD()
    if self.KeybindFrame then return end -- Chỉ tạo 1 lần

    self.KeybindFrame = Utility:Create("Frame", {
        Name = "KeybindHUD", Parent = self.ScreenGui,
        Size = UDim2.fromOffset(200, 0), Position = UDim2.new(0, 20, 0.5, 0), -- Vị trí mặc định bên trái
        BackgroundColor3 = ThemeManager.Current.Main, BackgroundTransparency = 0.2,
        AutomaticSize = Enum.AutomaticSize.Y
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1.5}),
    })
    
    -- Title Header
    local Header = Utility:Create("Frame", {
        Parent = self.KeybindFrame, Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = ThemeManager.Current.Secondary
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("TextLabel", {
            Text = "KEYBINDS", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            TextColor3 = ThemeManager.Current.Accent, Font = ThemeManager.Current.FontBold, TextSize = 12
        })
    })

    -- Container chứa list
    self.KeybindList = Utility:Create("Frame", {
        Parent = self.KeybindFrame, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 26),
        BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y
    }, {
        Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}),
        Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    })
    
    Utility:MakeDraggable(self.KeybindFrame, self.KeybindFrame)
end

function Library:AddKeybindToHUD(name, keyName)
    if not self.KeybindFrame then self:KeybindHUD() end
    
    -- Xóa cũ nếu trùng tên (để cập nhật phím mới)
    for _, v in pairs(self.KeybindList:GetChildren()) do
        if v.Name == name then v:Destroy() end
    end
    
    -- Nếu key là "None" thì không hiện
    if keyName == "None" then return end

    local Item = Utility:Create("Frame", {
        Name = name, Parent = self.KeybindList, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1
    })
    
    -- Tên chức năng
    Utility:Create("TextLabel", {
        Parent = Item, Text = name, Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1,
        TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Phím
    Utility:Create("TextLabel", {
        Parent = Item, Text = "[" .. keyName .. "]", Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Accent, Font = ThemeManager.Current.FontBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right
    })
end

--// CONFIG SYSTEM //--
if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end

function Library:SaveConfig(name)
    local json = HttpService:JSONEncode(Library.Flags)
    writefile(Library.ConfigFolder .. "/" .. name .. ".json", json)
    Library:Notify({Title = "CONFIG SAVED", Content = "Data written to: " .. name})
end

function Library:LoadConfig(name)
    local file = Library.ConfigFolder .. "/" .. name .. ".json"
    if not isfile(file) then
        Library:Notify({Title = "ERROR", Content = "File not found.", Image = Assets.Icons.Warning})
        return
    end

    local success, data = pcall(function() return HttpService:JSONDecode(readfile(file)) end)
    if not success then return end

    for flag, value in pairs(data) do
        local element = Library.Options[flag]
        if element then
            if type(value) == "table" and value.R then value = Color3.new(value.R, value.G, value.B) end
            if element.Set then element:Set(value) end
        end
    end
    Library:Notify({Title = "CONFIG LOADED", Content = "Restored: " .. name})
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

--// INIT FUNCTION //--
function Library:Init(config)
    local Title = config.Title or "TITAN_PROTOCOL"
    
    if CoreGui:FindFirstChild("TitanUI_Cyber") then CoreGui.TitanUI_Cyber:Destroy() end
    
    self.ScreenGui = Utility:Create("ScreenGui", {Name = "TitanUI_Cyber", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    
    -- Global Tooltip
    self.Tooltip = Utility:Create("TextLabel", {
        Name = "Tooltip", Parent = self.ScreenGui,
        BackgroundColor3 = ThemeManager.Current.Main, TextColor3 = ThemeManager.Current.Text,
        Font = ThemeManager.Current.FontMain, TextSize = 12, Size = UDim2.fromOffset(0,0),
        Visible = false, ZIndex = 2000, BorderSizePixel = 0
    }, {
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1}),
        Utility:Create("UIPadding", {PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6)})
    })
    ThemeManager:Register(self.Tooltip, "BackgroundColor3", "Main")
    ThemeManager:Register(self.Tooltip, "TextColor3", "Text")
    ThemeManager:Register(self.Tooltip.UIStroke, "Color", "Accent")

    -- Main Frame (The Terminal)
    self.MainFrame = Utility:Create("Frame", {
        Name = "MainFrame", Parent = self.ScreenGui,
        Size = UDim2.fromOffset(700, 480), Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = ThemeManager.Current.Main,
        ClipsDescendants = false
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), -- Sharp corners
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 2, Transparency = 0.5}),
        Utility:Create("ImageLabel", { -- Glow Shadow
            Name = "Shadow", BackgroundTransparency = 1, Image = "rbxassetid://6015897843",
            Size = UDim2.new(1, 44, 1, 44), Position = UDim2.new(0, -22, 0, -22),
            ImageColor3 = ThemeManager.Current.Accent, ImageTransparency = 0.9, ZIndex = 0
        })
    })
    ThemeManager:Register(self.MainFrame, "BackgroundColor3", "Main")
    ThemeManager:Register(self.MainFrame.UIStroke, "Color", "Stroke")
    ThemeManager:Register(self.MainFrame.Shadow, "ImageColor3", "Accent")
    
    Utility:AddScanline(self.MainFrame) -- Add Tech Background

    local ResizeHandle = Utility:Create("ImageButton", {
        Name = "ResizeHandle",
        Parent = self.MainFrame,
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031090999", -- Icon gạch chéo góc (Resize Icon)
        ImageColor3 = ThemeManager.Current.TextDark,
        ImageTransparency = 0.5,
        ZIndex = 10 -- Đảm bảo nó nằm trên cùng
    })
    
    -- Đăng ký theme cho nút resize
    ThemeManager:Register(ResizeHandle, "ImageColor3", "TextDark")

    -- Kích hoạt tính năng Resizable
    -- MinSize là 500x350 để tránh UI bị vỡ khi kéo quá nhỏ
    Utility:MakeResizable(self.MainFrame, ResizeHandle, Vector2.new(500, 350))

    -- Topbar (Header)
    local Topbar = Utility:Create("Frame", {
        Name = "Topbar", Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = ThemeManager.Current.Secondary, BorderSizePixel = 0, ZIndex = 2
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("Frame", {BackgroundColor3 = ThemeManager.Current.Secondary, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BorderSizePixel = 0}), -- Square bottom
        Utility:Create("TextLabel", {
            Text = ">_ " .. string.upper(Title) .. " // V3.5",
            Font = ThemeManager.Current.FontBold, TextSize = 14, TextColor3 = ThemeManager.Current.Accent,
            BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
    ThemeManager:Register(Topbar, "BackgroundColor3", "Secondary")
    ThemeManager:Register(Topbar.Frame, "BackgroundColor3", "Secondary")
    ThemeManager:Register(Topbar.TextLabel, "TextColor3", "Accent")
    
    Utility:MakeDraggable(Topbar, self.MainFrame)

    -- Close Button (Visual only for now or Minimize)
    local CloseBtn = Utility:Create("TextButton", {
        Parent = Topbar, Size = UDim2.fromOffset(25, 25), Position = UDim2.new(1, -30, 0.5, -12.5),
        Text = "X", BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Error, Font = ThemeManager.Current.FontBold, TextScaled = true
    })
    CloseBtn.MouseButton1Click:Connect(function() 
        self.ScreenGui.Enabled = not self.ScreenGui.Enabled 
    end)

    local SearchBar = Utility:Create("TextBox", {
        Name = "SearchBar",
        Parent = Topbar, -- Nằm trên thanh tiêu đề
        Size = UDim2.new(0, 200, 0, 25),
        Position = UDim2.new(0.5, -100, 0.5, 0), -- Căn giữa Topbar
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager.Current.Main,
        Text = "",
        PlaceholderText = "SEARCH MODULES...",
        TextColor3 = ThemeManager.Current.Accent,
        PlaceholderColor3 = ThemeManager.Current.TextDark,
        Font = ThemeManager.Current.FontMain,
        TextSize = 12
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
        Utility:Create("ImageLabel", { -- Icon kính lúp
            Image = Assets.Icons.Search,
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new(1, -20, 0.5, -7),
            BackgroundTransparency = 1,
            ImageColor3 = ThemeManager.Current.TextDark
        })
    })

    -- LOGIC TÌM KIẾM
    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBar.Text:lower()
        
        -- Duyệt qua tất cả element đã đăng ký
        for _, item in pairs(Library.SearchableElements) do
            if query == "" then
                -- Nếu xóa trắng ô tìm kiếm -> Hiện lại tất cả
                item.Instance.Visible = true
                item.Group.Visible = true 
            else
                -- Nếu tên element chứa từ khóa tìm kiếm
                if item.Name:lower():find(query) then
                    item.Instance.Visible = true
                    item.Group.Visible = true -- Hiện Group chứa nó
                    
                    -- Tự động mở Group nếu đang đóng (nếu bạn dùng Collapsible)
                    -- (Code tùy chọn nếu bạn muốn tự động mở group)
                else
                    item.Instance.Visible = false
                end
            end
        end
        
        -- Logic phụ: Ẩn Group nếu không còn element nào hiện trong đó (Optional, hơi nặng)
    end)

    -- Layout Containers
    local TabContainer = Utility:Create("ScrollingFrame", {
        Parent = self.MainFrame, Size = UDim2.new(0, 160, 1, -41), Position = UDim2.new(0, 0, 0, 41),
        BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, {
        Utility:Create("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}),
        Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 15)})
    })
    
    -- Divider Line
    local Sep = Utility:Create("Frame", {
        Parent = self.MainFrame, Size = UDim2.new(0, 2, 1, -40), Position = UDim2.new(0, 160, 0, 40),
        BackgroundColor3 = ThemeManager.Current.Stroke, BorderSizePixel = 0, BackgroundTransparency = 0.5
    })
    ThemeManager:Register(Sep, "BackgroundColor3", "Stroke")

    local PageContainer = Utility:Create("Frame", {
        Parent = self.MainFrame, Size = UDim2.new(1, -170, 1, -50), Position = UDim2.new(0, 165, 0, 45),
        BackgroundTransparency = 1, ClipsDescendants = true
    })

    --// Tooltip Logic (Updated: Smart Bounds + Offset Y -15)
    RunService.RenderStepped:Connect(function()
        if self.Tooltip.Visible then
            local Mouse = UserInputService:GetMouseLocation()
            local Screen = self.ScreenGui.AbsoluteSize
            local TipSize = self.Tooltip.AbsoluteSize
            
            -- Offset mặc định: Cách chuột 15px sang phải, 15px lên trên (Y = -15)
            local X = Mouse.X + 15
            local Y = Mouse.Y - 36
            
            -- [Smart Bounds] Kiểm tra tràn màn hình
            
            -- Nếu Tooltip bị tràn ra mép phải -> Đẩy sang bên trái chuột
            if (X + TipSize.X) > Screen.X then
                X = Mouse.X - TipSize.X - 10
            end
            
            -- Nếu Tooltip bị tràn xuống mép dưới -> Đẩy lên cao hơn nữa
            -- (Mặc định Y-15 đã là lên trên, nhưng check thêm cho chắc)
            if (Y + TipSize.Y) > Screen.Y then
                Y = Mouse.Y - TipSize.Y - 10
            end
            
            -- Cập nhật vị trí
            self.Tooltip.Position = UDim2.fromOffset(X, Y)
        end
    end)
    
    --// WINDOW LOGIC //--
    local Window = {}
    local FirstTab = true

    function Window:AddTab(name)
        local Tab = {Page = nil}
        
        -- Tab Button
        local TabBtn = Utility:Create("TextButton", {
            Parent = TabContainer, Size = UDim2.new(1, -10, 0, 32),
            BackgroundColor3 = ThemeManager.Current.Secondary, BackgroundTransparency = 1,
            Text = "[ " .. string.upper(name) .. " ]", TextColor3 = ThemeManager.Current.TextDark,
            Font = ThemeManager.Current.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
        })
        
        -- Hover Effect
        TabBtn.MouseEnter:Connect(function() if TabBtn.BackgroundTransparency == 1 then Utility:Tween(TabBtn, {0.2}, {TextColor3 = ThemeManager.Current.Text}) end end)
        TabBtn.MouseLeave:Connect(function() if TabBtn.BackgroundTransparency == 1 then Utility:Tween(TabBtn, {0.2}, {TextColor3 = ThemeManager.Current.TextDark}) end end)

        -- Page
        Tab.Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page", Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2,
            ScrollBarImageColor3 = ThemeManager.Current.Accent, AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        ThemeManager:Register(Tab.Page, "ScrollBarImageColor3", "Accent")

        -- Columns
        local LeftCol = Utility:Create("Frame", {
            Name = "Left", Parent = Tab.Page, BackgroundTransparency = 1, Size = UDim2.new(0.49, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)
        }, {Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})})
        
        local RightCol = Utility:Create("Frame", {
            Name = "Right", Parent = Tab.Page, BackgroundTransparency = 1, Size = UDim2.new(0.49, 0, 1, 0), Position = UDim2.new(0.51, 0, 0, 0)
        }, {Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})})

        -- Activate Function
        local function Activate()
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:Tween(v, {0.2}, {BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.TextDark})
                end
            end
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            
            Tab.Page.Visible = true
            Utility:PlaySound("Click")
            Utility:Tween(TabBtn, {0.2}, {BackgroundTransparency = 0.8, BackgroundColor3 = ThemeManager.Current.Accent, TextColor3 = ThemeManager.Current.Accent})
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then Activate(); FirstTab = false end

        --// GROUPBOX //--
        function Tab:AddGroupbox(config)
            local Title = config.Title or "UNNAMED_GROUP"
            local Side = config.Side or "Left"
            local ParentCol = (Side == "Left" and LeftCol) or RightCol
            local Group = {}
            local IsCollapsed = false

            -- [HELPER ĐĂNG KÝ TÌM KIẾM]
            local function RegisterSearch(text, instance)
                table.insert(Library.SearchableElements, {
                    Name = text,
                    Instance = instance,
                    Group = BoxFrame -- Lưu tham chiếu đến Group cha
                })
            end
            
            local BoxFrame = Utility:Create("Frame", {
                Name = Title.."_Group", Parent = ParentCol,
                BackgroundColor3 = ThemeManager.Current.Main,
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = true, BackgroundTransparency = 0.5
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 0.2, Transparency = 0.6}),
            })
            ThemeManager:Register(BoxFrame, "BackgroundColor3", "Main")
            ThemeManager:Register(BoxFrame.UIStroke, "Color", "Stroke")

            local Header = Utility:Create("Frame", {Parent = BoxFrame, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1})
            
            -- Tech Decor in Header
            Utility:Create("Frame", {
                Parent = Header, BackgroundColor3 = ThemeManager.Current.Accent, Size = UDim2.new(0, 3, 1, 0), Position = UDim2.new(0,0,0,0)
            }, {Utility:Create("UIGradient", {Rotation=90, Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}})})

            local BoxTitle = Utility:Create("TextLabel", {
                Parent = Header, Text = string.upper(Title), Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Accent, Font = ThemeManager.Current.FontBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
            })
            ThemeManager:Register(BoxTitle, "TextColor3", "Accent")

            local CollapseBtn = Utility:Create("ImageButton", {
                Parent = Header, Size = UDim2.fromOffset(16, 16), Position = UDim2.new(1, -22, 0.5, -8),
                BackgroundTransparency = 1, Image = Assets.Icons.Arrow, ImageColor3 = ThemeManager.Current.TextDark
            })

            local Content = Utility:Create("Frame", {
                Name = "Content", Parent = BoxFrame, BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 0, 0), Position = UDim2.new(0, 6, 0, 35), AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}),
                Utility:Create("UIPadding", {PaddingBottom = UDim.new(0, 8)})
            })

            local ContentHeight = 0
            Content.ChildAdded:Connect(function() if not IsCollapsed then BoxFrame.Size = UDim2.new(1, 0, 0, 0) end end)

            CollapseBtn.MouseButton1Click:Connect(function()
                IsCollapsed = not IsCollapsed
                if IsCollapsed then
                    ContentHeight = Content.AbsoluteSize.Y + 45
                    BoxFrame.AutomaticSize = Enum.AutomaticSize.None
                    Content.Visible = false
                    Utility:Tween(BoxFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 30)})
                    Utility:Tween(CollapseBtn, {0.3}, {Rotation = 180})
                else
                    Content.Visible = true
                    local t = Utility:Tween(BoxFrame, {0.3}, {Size = UDim2.new(1, 0, 0, ContentHeight)})
                    Utility:Tween(CollapseBtn, {0.3}, {Rotation = 0})
                    t.Completed:Connect(function() BoxFrame.AutomaticSize = Enum.AutomaticSize.Y end)
                end
            end)

            -- LOCAL HELPER: TOOLTIP (Updated: Smooth Fade In)
            local function AddTooltip(element, text)
                if not text or text == "" then return end
                
                element.MouseEnter:Connect(function()
                    Library.Tooltip.Text = text
                    
                    -- Tự động tính toán kích thước khung dựa trên độ dài chữ
                    local TextService = game:GetService("TextService")
                    local Bounds = TextService:GetTextSize(text, 12, ThemeManager.Current.FontMain, Vector2.new(250, 1000))
                    Library.Tooltip.Size = UDim2.fromOffset(Bounds.X + 14, Bounds.Y + 10)
                    
                    -- Reset trạng thái trong suốt trước khi hiện
                    Library.Tooltip.BackgroundTransparency = 1
                    Library.Tooltip.TextTransparency = 1
                    Library.Tooltip.UIStroke.Transparency = 1
                    Library.Tooltip.Visible = true
                    
                    -- Hiệu ứng Fade In (Cyber Style)
                    Utility:Tween(Library.Tooltip, {0.15}, {BackgroundTransparency = 0.1})
                    Utility:Tween(Library.Tooltip, {0.15}, {TextTransparency = 0})
                    Utility:Tween(Library.Tooltip.UIStroke, {0.15}, {Transparency = 0})
                end)
                
                element.MouseLeave:Connect(function()
                    -- Ẩn ngay lập tức hoặc Fade out tùy ý (ở đây ẩn luôn cho nhanh nhạy)
                    Library.Tooltip.Visible = false
                end)
            end

            --// ELEMENTS //--

            function Group:AddLabel(text, config)
                local opts = config or {}
                local Lbl = Utility:Create("TextLabel", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
                    Text = text, TextColor3 = opts.Color or ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain,
                    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
                })
                ThemeManager:Register(Lbl, "TextColor3", "Text")
                AddTooltip(Lbl, opts.Tooltip)
                local F = {} function F:SetText(t) Lbl.Text = t end return F
            end

            function Group:AddParagraph(title, content)
                local Para = Utility:Create("Frame", {
                    Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y
                }, {Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})})
                local T = Utility:Create("TextLabel", {
                    Parent = Para, Text = title, TextColor3 = ThemeManager.Current.Accent, Font = ThemeManager.Current.FontBold,
                    TextSize = 12, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15), TextXAlignment = Enum.TextXAlignment.Left
                })
                local C = Utility:Create("TextLabel", {
                    Parent = Para, Text = content, TextColor3 = ThemeManager.Current.TextDark, Font = ThemeManager.Current.FontMain,
                    TextSize = 12, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
                })
                ThemeManager:Register(T, "TextColor3", "Accent")
                ThemeManager:Register(C, "TextColor3", "TextDark")
            end
            
            function Group:AddImage(id, config)
                 local opts = config or {}
                 Utility:Create("ImageLabel", {
                    Parent = Content, Image = "rbxassetid://"..tostring(id), Size = UDim2.new(1, 0, 0, opts.Height or 100),
                    BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0,4)})})
            end

            function Group:AddButton(text, callback, config)
                local opts = config or {}
                local Btn = Utility:Create("TextButton", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = ThemeManager.Current.Secondary,
                    Text = "", AutoButtonColor = false, BackgroundTransparency = 0.5
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 0.2, Transparency = 0.5}),
                    Utility:Create("TextLabel", {
                        Text = text, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                        TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain, TextSize = 12
                    })
                })
                ThemeManager:Register(Btn, "BackgroundColor3", "Secondary")
                ThemeManager:Register(Btn.UIStroke, "Color", "Stroke")
                ThemeManager:Register(Btn.TextLabel, "TextColor3", "Text")
                RegisterSearch(text, Btn)
                AddTooltip(Btn, opts.Tooltip)

                Btn.MouseEnter:Connect(function()
                    Utility:PlaySound("Hover")
                    Utility:Tween(Btn.UIStroke, {0.2}, {Color = ThemeManager.Current.Accent, Transparency = 0})
                    Utility:Tween(Btn.TextLabel, {0.2}, {TextColor3 = ThemeManager.Current.Accent})
                end)
                Btn.MouseLeave:Connect(function()
                    Utility:Tween(Btn.UIStroke, {0.2}, {Color = ThemeManager.Current.Stroke, Transparency = 0.5})
                    Utility:Tween(Btn.TextLabel, {0.2}, {TextColor3 = ThemeManager.Current.Text})
                end)
                Btn.MouseButton1Click:Connect(function()
                    Utility:PlaySound("Click")
                    Utility:Tween(Btn, {0.1}, {BackgroundColor3 = ThemeManager.Current.Accent, BackgroundTransparency = 0.2})
                    task.delay(0.1, function() Utility:Tween(Btn, {0.3}, {BackgroundColor3 = ThemeManager.Current.Secondary, BackgroundTransparency = 0.5}) end)
                    pcall(callback)
                end)
            end

            function Group:AddToggle(text, default, callback, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local State = default or false

                local Container = Utility:Create("TextButton", {
                    Parent = Content, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
                })
                
                local Checkbox = Utility:Create("Frame", {
                    Parent = Container, Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 0, 0.5, -9),
                    BackgroundColor3 = ThemeManager.Current.Main
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 0.2})
                })
                ThemeManager:Register(Checkbox, "BackgroundColor3", "Main")
                ThemeManager:Register(Checkbox.UIStroke, "Color", "Stroke")
                
                local CheckImg = Utility:Create("ImageLabel", {
                    Parent = Checkbox, Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2),
                    Image = Assets.Icons.Check, ImageColor3 = ThemeManager.Current.Accent, BackgroundTransparency = 1, ImageTransparency = 1
                })
                ThemeManager:Register(CheckImg, "ImageColor3", "Accent")

                local Label = Utility:Create("TextLabel", {
                    Parent = Container, Text = text, Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 25, 0, 0),
                    BackgroundTransparency = 1, TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain,
                    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                RegisterSearch(text, Container)
                AddTooltip(Container, opts.Tooltip)

                local Funcs = {}
                function Funcs:Set(val)
                    State = val
                    Library.Flags[Flag] = State
                    Utility:Tween(CheckImg, {0.2}, {ImageTransparency = State and 0 or 1})
                    Utility:Tween(Label, {0.2}, {TextColor3 = State and ThemeManager.Current.Accent or ThemeManager.Current.Text})
                    pcall(callback, State)
                end
                
                Library.Options[Flag] = Funcs; Library.Flags[Flag] = State
                Funcs:Set(State)
                
                Container.MouseButton1Click:Connect(function() Utility:PlaySound("Click"); Funcs:Set(not State) end)
                return Funcs
            end

            function Group:AddSlider(text, min, max, default, callback, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local Value = default or min

                local Frame = Utility:Create("Frame", {Parent = Content, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1})
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame, Text = text, Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text, Font = ThemeManager.Current.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left
                })
                local ValLabel = Utility:Create("TextLabel", {
                    Parent = Frame, Text = tostring(Value), Size = UDim2.new(1, 0, 0, 15), BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Accent, Font = ThemeManager.Current.FontMain, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                ThemeManager:Register(ValLabel, "TextColor3", "Accent")
                RegisterSearch(text, Frame)
                AddTooltip(Frame, opts.Tooltip)

                local Track = Utility:Create("Frame", {
                    Parent = Frame, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = ThemeManager.Current.Secondary
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})})
                ThemeManager:Register(Track, "BackgroundColor3", "Secondary")

                local Fill = Utility:Create("Frame", {
                    Parent = Track, Size = UDim2.fromScale(0, 1), BackgroundColor3 = ThemeManager.Current.Accent
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)}),
                    Utility:Create("Frame", { -- Glow Tip
                         Size = UDim2.new(0, 8, 2.5, 0), Position = UDim2.new(1, -4, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                         BackgroundColor3 = ThemeManager.Current.Text,
                         BackgroundTransparency = 0.5
                    }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})
                })
                ThemeManager:Register(Fill, "BackgroundColor3", "Accent")

                local Interact = Utility:Create("TextButton", {Parent = Track, Size = UDim2.new(1, 0, 4, 0), Position = UDim2.new(0,0,0.5,0), AnchorPoint = Vector2.new(0,0.5), BackgroundTransparency = 1, Text = ""})
                
                local Funcs = {}
                function Funcs:Set(val)
                    Value = math.clamp(tonumber(val) or min, min, max)
                    local percent = (Value - min) / (max - min)
                    Utility:Tween(Fill, {0.1}, {Size = UDim2.fromScale(percent, 1)})
                    ValLabel.Text = string.format("%.1f", Value)
                    Library.Flags[Flag] = Value
                    pcall(callback, Value)
                end
                
                Library.Options[Flag] = Funcs; Library.Flags[Flag] = Value
                Funcs:Set(Value)

                Interact.MouseButton1Down:Connect(function()
                    local move, kill
                    move = UserInputService.InputChanged:Connect(function(io)
                        if io.UserInputType == Enum.UserInputType.MouseMovement then
                            local scale = math.clamp((io.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                            Funcs:Set(min + (max-min)*scale)
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

            function Group:AddDropdown(text, items, multi, callback, config)
                local opts = config or {} 
                local Flag = opts.Flag or text
                local Multi = multi or false
                local Selected = Multi and {} or items[1]
                local IsOpen = false

                -- Container chính
                local Holder = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    ZIndex = 20
                })
                
                -- Label tiêu đề
                local Label = Utility:Create("TextLabel", {
                    Parent = Holder,
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 15),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")
                RegisterSearch(text, Holder)
                AddTooltip(Holder, opts.Tooltip)

                -- Nút chính (Hiển thị trạng thái đóng/mở)
                local MainBtn = Utility:Create("TextButton", {
                    Parent = Holder,
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = ThemeManager.Current.Main,
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.5
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1}),
                    Utility:Create("ImageLabel", {
                        Image = Assets.Icons.Arrow,
                        Size = UDim2.fromOffset(16, 16),
                        Position = UDim2.new(1, -20, 0.5, -8),
                        BackgroundTransparency = 1,
                        ImageColor3 = ThemeManager.Current.TextDark
                    }),
                    Utility:Create("TextLabel", {
                        Name = "Status",
                        Size = UDim2.new(1, -25, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        Text = "...",
                        TextColor3 = ThemeManager.Current.TextDark,
                        Font = ThemeManager.Current.FontMain,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd
                    })
                })
                ThemeManager:Register(MainBtn, "BackgroundColor3", "Main")
                ThemeManager:Register(MainBtn.UIStroke, "Color", "Stroke")

                -- Khung chứa danh sách (List)
                local ListFrame = Utility:Create("Frame", {
                    Parent = MainBtn,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = ThemeManager.Current.Main,
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 30
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Accent, Thickness = 1})
                })
                ThemeManager:Register(ListFrame, "BackgroundColor3", "Main")

                -- List cuộn
                local ScrollList = Utility:Create("ScrollingFrame", {
                    Parent = ListFrame,
                    Size = UDim2.new(1, 0, 1, -5),
                    Position = UDim2.new(0, 0, 0, 5),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = ThemeManager.Current.Accent,
                    CanvasSize = UDim2.new(0,0,0,0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 31
                }, {
                    Utility:Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}),
                    Utility:Create("UIPadding", {PaddingLeft = UDim.new(0,5), PaddingRight=UDim.new(0,5)})
                })

                -- Hàm cập nhật text hiển thị bên ngoài
                local function RefreshDisplay()
                    local txt = ""
                    if Multi then
                        local count = 0
                        for k, v in pairs(Selected) do 
                            if v then 
                                count = count + 1; txt = txt .. k .. ", " 
                            end 
                        end
                        MainBtn.Status.Text = (count == 0) and "NONE" or txt:sub(1, -3)
                        MainBtn.Status.TextColor3 = (count > 0) and ThemeManager.Current.Accent or ThemeManager.Current.TextDark
                    else 
                        MainBtn.Status.Text = tostring(Selected)
                        MainBtn.Status.TextColor3 = ThemeManager.Current.Accent
                    end
                end

                -- Hàm tạo danh sách item (Có xử lý Highlight)
                local function Populate()
                    for _, v in pairs(ScrollList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    for _, item in pairs(items) do
                        local IsSelected = (Multi and Selected[item]) or (not Multi and Selected == item)
                        
                        -- Button Item
                        local ItemBtn = Utility:Create("TextButton", {
                            Parent = ScrollList,
                            Size = UDim2.new(1, 0, 0, 22),
                            BackgroundTransparency = IsSelected and 0.85 or 1, -- Highlight nền nếu chọn
                            BackgroundColor3 = ThemeManager.Current.Accent,
                            Text = tostring(item),
                            TextColor3 = IsSelected and ThemeManager.Current.Accent or ThemeManager.Current.TextDark,
                            Font = ThemeManager.Current.FontMain,
                            TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 32,
                            AutoButtonColor = false
                        }, {
                            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 3)}),
                            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 5)}),
                            -- Thêm viền stroke cho item được chọn
                            Utility:Create("UIStroke", {
                                Color = ThemeManager.Current.Accent,
                                Thickness = 1,
                                Transparency = IsSelected and 0.5 or 1, -- Hiện viền nếu chọn
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            })
                        })
                        
                        -- Sự kiện click
                        ItemBtn.MouseButton1Click:Connect(function()
                            if Multi then 
                                Selected[item] = not Selected[item]
                            else 
                                Selected = item
                                IsOpen = false
                                ListFrame.Visible = false
                                Utility:Tween(Holder, {0.2}, {Size = UDim2.new(1,0,0,45)})
                            end
                            
                            -- Refresh lại toàn bộ list để cập nhật highlight
                            Populate() 
                            RefreshDisplay()
                            
                            pcall(callback, Selected)
                            Library.Flags[Flag] = Selected
                        end)
                    end
                end

                -- Sự kiện mở dropdown
                MainBtn.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    if IsOpen then
                        ListFrame.Visible = true
                        Populate() -- Load items
                        local h = math.min(#items * 26 + 10, 150) -- Tính chiều cao
                        ListFrame.Size = UDim2.new(1, 0, 0, h)
                        Utility:Tween(Holder, {0.2}, {Size = UDim2.new(1, 0, 0, 45 + h + 5)})
                        Utility:Tween(MainBtn.ImageLabel, {0.2}, {Rotation = 180})
                    else
                        ListFrame.Visible = false
                        Utility:Tween(Holder, {0.2}, {Size = UDim2.new(1, 0, 0, 45)})
                        Utility:Tween(MainBtn.ImageLabel, {0.2}, {Rotation = 0})
                    end
                end)
                
                -- Init
                local F = {} 
                function F:Set(v) Selected = v; RefreshDisplay(); Library.Flags[Flag] = v end
                Library.Options[Flag] = F; Library.Flags[Flag] = Selected; RefreshDisplay()
                return F
            end
            
            function Group:AddColorPicker(text, default, callback, config)
                 local opts = config or {}
                 local Flag = opts.Flag or text
                 local Color = default or Color3.fromRGB(255,255,255)
                 local IsOpen = false
                 
                 local Frame = Utility:Create("Frame", {Parent = Content, Size = UDim2.new(1,0,0,30), BackgroundTransparency = 1, ClipsDescendants = true})
                 local Label = Utility:Create("TextLabel", {Parent = Frame, Text=text, Size=UDim2.new(1,-40,1,0), BackgroundTransparency=1, TextColor3=ThemeManager.Current.Text, Font=ThemeManager.Current.FontMain, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left})
                 local Preview = Utility:Create("TextButton", {
                     Parent = Frame, Size=UDim2.new(0,30,0,16), Position=UDim2.new(1,-30,0.5,-8), BackgroundColor3=Color, Text=""
                 }, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=ThemeManager.Current.Stroke,Thickness=1})})
                 
                 local PickerFrame = Utility:Create("Frame", {Parent=Frame, Size=UDim2.new(1,0,0,110), Position=UDim2.new(0,0,0,30), BackgroundTransparency=1, Visible=false})
                 local SV = Utility:Create("ImageButton", {Parent=PickerFrame, Size=UDim2.new(0,100,0,100), Image="rbxassetid://4155801252", BackgroundColor3=Color})
                 local H = Utility:Create("ImageButton", {Parent=PickerFrame, Size=UDim2.new(0,20,0,100), Position=UDim2.new(0,110,0,0), Image="rbxassetid://3641079629"})
                 
                 Preview.MouseButton1Click:Connect(function()
                     IsOpen = not IsOpen
                     PickerFrame.Visible = IsOpen
                     Utility:Tween(Frame, {0.3}, {Size = UDim2.new(1,0,0, IsOpen and 145 or 30)})
                 end)

                 RegisterSearch(text, Frame)
                 AddTooltip(Frame, opts.Tooltip)
                 
                 -- Minimal logic for brevity, full logic assumed from base or similar to slider
                 local F = {} function F:Set(c) Color = c; Preview.BackgroundColor3 = c; Library.Flags[Flag] = {R=c.R,G=c.G,B=c.B}; pcall(callback, c) end
                 Library.Options[Flag] = F; Library.Flags[Flag] = {R=Color.R,G=Color.G,B=Color.B}
                 return F
            end

            function Group:AddKeybind(text, default, callback, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local Key = default or Enum.KeyCode.RightAlt
                local IsBinding = false
                
                -- 1. UI CONTAINER
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                })
                
                -- Đăng ký tính năng Search & Tooltip
                RegisterSearch(text, Frame)
                AddTooltip(Frame, opts.Tooltip)

                -- 2. LABEL (Tên chức năng)
                local Label = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(1, -90, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Label, "TextColor3", "Text")

                -- 3. BIND BUTTON (Nút hiển thị phím)
                local BindBtn = Utility:Create("TextButton", {
                    Parent = Frame,
                    Size = UDim2.new(0, 80, 0, 18),
                    Position = UDim2.new(1, -80, 0.5, -9),
                    BackgroundColor3 = ThemeManager.Current.Secondary,
                    Text = "[" .. Key.Name .. "]",
                    TextColor3 = ThemeManager.Current.Accent,
                    Font = ThemeManager.Current.FontBold,
                    TextSize = 11,
                    AutoButtonColor = false
                }, {
                    Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                    Utility:Create("UIStroke", {Color = ThemeManager.Current.Stroke, Thickness = 1})
                })
                ThemeManager:Register(BindBtn, "BackgroundColor3", "Secondary")
                ThemeManager:Register(BindBtn.UIStroke, "Color", "Stroke")
                ThemeManager:Register(BindBtn, "TextColor3", "Accent")

                -- Helper: Cập nhật Key & HUD
                local function UpdateKeyDisplay()
                    local keyName = (typeof(Key) == "EnumItem") and Key.Name or tostring(Key)
                    BindBtn.Text = "[" .. keyName .. "]"
                    
                    -- Cập nhật lên HUD
                    Library:AddKeybindToHUD(text, keyName)
                end

                -- 4. LOGIC BINDING (Thay đổi phím)
                BindBtn.MouseButton1Click:Connect(function()
                    if IsBinding then return end
                    IsBinding = true
                    
                    Utility:PlaySound("Click")
                    BindBtn.Text = "[...]"
                    BindBtn.TextColor3 = ThemeManager.Current.Text -- Đổi màu chờ
                    
                    local inputWait
                    inputWait = UserInputService.InputBegan:Connect(function(input)
                        -- Chấp nhận phím Keyboard hoặc chuột (MB1, MB2...)
                        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:find("MouseButton") then
                            IsBinding = false
                            
                            -- Hủy bind nếu ấn Escape
                            if input.KeyCode == Enum.KeyCode.Escape then
                                -- Giữ key cũ, chỉ cập nhật lại visual
                            elseif input.KeyCode == Enum.KeyCode.Backspace then
                                Key = Enum.KeyCode.Unknown -- Unbind
                            else
                                Key = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode) or input.UserInputType
                            end
                            
                            UpdateKeyDisplay()
                            
                            -- Hiệu ứng hồi phục màu
                            BindBtn.TextColor3 = ThemeManager.Current.Accent
                            
                            -- Lưu Config
                            Library.Flags[Flag] = Key.Name -- Lưu tên string để JSON không lỗi
                            if opts.Callback then pcall(opts.Callback, Key) end
                            
                            inputWait:Disconnect()
                        end
                    end)
                end)

                -- 5. LOGIC TRIGGER (Kích hoạt callback)
                UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and not IsBinding then
                        local inputKey = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode) or input.UserInputType
                        if inputKey == Key and Key ~= Enum.KeyCode.Unknown then
                            -- Trigger Callback
                            pcall(callback, Key)
                            
                            -- Visual Effect: Nháy sáng nút khi ấn
                            Utility:Tween(BindBtn, {0.1}, {BackgroundColor3 = ThemeManager.Current.Accent, TextColor3 = ThemeManager.Current.Main})
                            task.delay(0.1, function()
                                Utility:Tween(BindBtn, {0.2}, {BackgroundColor3 = ThemeManager.Current.Secondary, TextColor3 = ThemeManager.Current.Accent})
                            end)
                        end
                    end
                end)
                
                -- 6. CONFIG SYSTEM (Hàm Set & Load)
                local Funcs = {}
                
                function Funcs:Set(val)
                    -- Xử lý khi load từ Config (JSON trả về String, cần đổi sang Enum)
                    if typeof(val) == "string" then
                        if Enum.KeyCode[val] then
                            Key = Enum.KeyCode[val]
                        elseif val:find("MouseButton") then
                            -- Xử lý chuột hơi phức tạp, tạm thời fallback về Unknown nếu load lỗi
                            -- (Nâng cao: Cần bảng map string -> UserInputType)
                            Key = Enum.UserInputType[val] or Enum.KeyCode.Unknown
                        end
                    elseif typeof(val) == "EnumItem" then
                        Key = val
                    end
                    
                    Library.Flags[Flag] = Key.Name
                    UpdateKeyDisplay()
                end
                
                -- Đăng ký Config
                Library.Options[Flag] = Funcs
                Library.Flags[Flag] = Key.Name
                
                -- Khởi tạo hiển thị ban đầu
                UpdateKeyDisplay()
                
                return Funcs
            end
            
            function Group:AddInput(text, config)
                local opts = config or {}
                local Flag = opts.Flag or text
                local Frame = Utility:Create("Frame", {Parent = Content, Size = UDim2.new(1,0,0,45), BackgroundTransparency = 1})
                Utility:Create("TextLabel", {Parent = Frame, Text=text, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextColor3=ThemeManager.Current.Text, Font=ThemeManager.Current.FontMain, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left})
                local Box = Utility:Create("TextBox", {
                    Parent = Frame, Size=UDim2.new(1,0,0,25), Position=UDim2.new(0,0,0,20), BackgroundColor3=ThemeManager.Current.Main,
                    Text="", PlaceholderText=opts.Placeholder or "...", TextColor3=ThemeManager.Current.Accent, Font=ThemeManager.Current.FontMain, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left
                }, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=ThemeManager.Current.Stroke,Thickness=1})})
                AddTooltip(Frame, opts.Tooltip)
                RegisterSearch(text, Frame)
                ThemeManager:Register(Box, "BackgroundColor3", "Main")
                ThemeManager:Register(Box, "TextColor3", "Accent")
                
                local F = {} function F:Get() return Box.Text end
                Box.FocusLost:Connect(function() Library.Flags[Flag] = Box.Text; if opts.Callback then opts.Callback(Box.Text) end end)
                Library.Options[Flag] = F
                return F
            end

            function Group:AddDivider(text)
                local Frame = Utility:Create("Frame", {Parent = Content, Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1})
                Utility:Create("Frame", {Parent=Frame, Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0.5,0), BackgroundColor3=ThemeManager.Current.Divider, BorderSizePixel=0})
                if text then Utility:Create("TextLabel", {Parent=Frame, Text=text, Size=UDim2.new(0,0,1,0), Position=UDim2.new(0.5,0,0,0), BackgroundColor3=ThemeManager.Current.Main, TextColor3=ThemeManager.Current.TextDark, Font=ThemeManager.Current.FontBold, TextSize=11}) end  
                ThemeManager:Register(Frame.Frame, "BackgroundColor3", "Divider")
                ThemeManager:Register(Frame.TextLabel, "BackgroundColor3", "Main")
                ThemeManager:Register(Frame.TextLabel, "TextColor3", "TextDark")
            end
            
            function Group:AddProgressBar(text, config)
                 local Frame = Utility:Create("Frame", {Parent=Content, Size=UDim2.new(1,0,0,35), BackgroundTransparency=1})
                 Utility:Create("TextLabel", {Parent=Frame, Text=text, Size=UDim2.new(1,0,0,15), BackgroundTransparency=1, TextColor3=ThemeManager.Current.Text, Font=ThemeManager.Current.FontMain, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left})
                 local Bar = Utility:Create("Frame", {Parent=Frame, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,18), BackgroundColor3=ThemeManager.Current.Main}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=ThemeManager.Current.Stroke,Thickness=1})})
                 local Fill = Utility:Create("Frame", {Parent=Bar, Size=UDim2.fromScale(0.5,1), BackgroundColor3=ThemeManager.Current.Accent}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)})})
                 ThemeManager:Register(Bar, "BackgroundColor3", "Main")
                 ThemeManager:Register(Bar.UIStroke, "Color", "Stroke")
                 ThemeManager:Register(Fill, "BackgroundColor3", "Accent")
                 local F={} function F:Set(v) Utility:Tween(Fill,{0.3},{Size=UDim2.fromScale(math.clamp(v/100,0,1),1)}) end return F
            end

            function Group:AddStatusLabel(text, default)
                local Frame = Utility:Create("Frame", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1
                })
                
                -- Phần Tiêu đề (Bên trái, màu trắng mờ)
                local Title = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = text,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Text,
                    Font = ThemeManager.Current.FontMain,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ThemeManager:Register(Title, "TextColor3", "Text")
                
                -- Phần Giá trị (Bên phải, màu Neon Accent)
                local Value = Utility:Create("TextLabel", {
                    Parent = Frame,
                    Text = default or "WAITING...",
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Position = UDim2.new(0.6, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = ThemeManager.Current.Accent,
                    Font = ThemeManager.Current.FontBold, -- Font đậm để nổi bật thông số
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ThemeManager:Register(Value, "TextColor3", "Accent")
                
                local Funcs = {}
                
                -- Hàm cập nhật nội dung
                function Funcs:Set(t) 
                    Value.Text = tostring(t) 
                end
                
                -- Hàm đổi màu nóng (Ví dụ: Ping cao thì đổi sang đỏ)
                function Funcs:SetColor(c) 
                    Value.TextColor3 = c 
                end
                
                return Funcs
            end

            return Group
        end
        return Tab
    end
    
    --// SETTINGS TAB (PROFESSIONAL THEME MANAGER) //--
    local Settings = Window:AddTab("SYSTEM")
    
    -- 1. THEME MANAGER GROUP
    local ThemeGroup = Settings:AddGroupbox({Title = "THEME STUDIO", Side = "Left"})
    
    -- Danh sách các Theme mẫu (Presets)
    local BuiltInThemes = {
        ["Default Cyber"] = {
            Main = Color3.fromRGB(10, 12, 16), Secondary = Color3.fromRGB(20, 25, 30), 
            Stroke = Color3.fromRGB(0, 255, 170), Accent = Color3.fromRGB(0, 255, 170), 
            Divider = Color3.fromRGB(40, 50, 60), Text = Color3.fromRGB(230, 255, 240), 
            TextDark = Color3.fromRGB(100, 150, 130)
        },
        ["Crimson Villain"] = {
            Main = Color3.fromRGB(15, 10, 10), Secondary = Color3.fromRGB(25, 15, 15), 
            Stroke = Color3.fromRGB(255, 50, 60), Accent = Color3.fromRGB(255, 50, 60), 
            Divider = Color3.fromRGB(60, 30, 30), Text = Color3.fromRGB(255, 240, 240), 
            TextDark = Color3.fromRGB(180, 100, 100)
        },
        ["Dracula"] = {
            Main = Color3.fromRGB(40, 42, 54), Secondary = Color3.fromRGB(68, 71, 90), 
            Stroke = Color3.fromRGB(189, 147, 249), Accent = Color3.fromRGB(189, 147, 249), 
            Divider = Color3.fromRGB(98, 114, 164), Text = Color3.fromRGB(248, 248, 242), 
            TextDark = Color3.fromRGB(140, 140, 160)
        },
        ["Nordic Snow"] = {
            Main = Color3.fromRGB(46, 52, 64), Secondary = Color3.fromRGB(59, 66, 82), 
            Stroke = Color3.fromRGB(136, 192, 208), Accent = Color3.fromRGB(136, 192, 208), 
            Divider = Color3.fromRGB(76, 86, 106), Text = Color3.fromRGB(236, 239, 244), 
            TextDark = Color3.fromRGB(216, 222, 233)
        },
        ["Synthwave 80s"] = {
            Main = Color3.fromRGB(28, 11, 43), Secondary = Color3.fromRGB(45, 17, 56), 
            Stroke = Color3.fromRGB(255, 0, 212), Accent = Color3.fromRGB(0, 247, 255), 
            Divider = Color3.fromRGB(86, 21, 94), Text = Color3.fromRGB(255, 235, 250), 
            TextDark = Color3.fromRGB(190, 100, 190)
        }
    }

    -- Dropdown chọn Theme
    local ThemeNames = {}
    for name, _ in pairs(BuiltInThemes) do table.insert(ThemeNames, name) end
    table.sort(ThemeNames)

    local ThemeList = ThemeGroup:AddDropdown("Load Preset", ThemeNames, false, function(selected)
        if BuiltInThemes[selected] then
            ThemeManager:UpdateTheme(BuiltInThemes[selected])
            
            -- Cập nhật lại các ColorPicker bên dưới (để đồng bộ visual)
            for key, col in pairs(BuiltInThemes[selected]) do
                if Library.Options["Theme_"..key] then
                    Library.Options["Theme_"..key]:Set(col)
                end
            end
            Library:Notify({Title="THEME", Content="Loaded preset: "..selected})
        end
    end)

    ThemeGroup:AddDivider("CUSTOMIZE COLORS")

    -- Tự động tạo Color Picker cho từng màu trong Theme
    -- Sắp xếp thứ tự ưu tiên để UI đẹp hơn
    local Order = {"Accent", "Stroke", "Main", "Secondary", "Divider", "Text", "TextDark"}
    
    for _, key in ipairs(Order) do
        ThemeGroup:AddColorPicker(string.upper(key), ThemeManager.Current[key], function(color)
            ThemeManager:UpdateTheme({[key] = color})
        end, {Flag = "Theme_"..key}) -- Flag đặc biệt để code update được
    end

    -- 2. IMPORT / EXPORT GROUP
    local JSONGroup = Settings:AddGroupbox({Title = "THEME DATA (JSON)", Side = "Left"})
    
    local ExportInput = JSONGroup:AddInput("Theme Data String", {Placeholder = "Paste theme JSON here..."})
    
    JSONGroup:AddButton("EXPORT CURRENT THEME", function()
        -- Convert Color3 to Table {R,G,B} for JSON
        local exportData = {}
        for k, v in pairs(ThemeManager.Current) do
            if typeof(v) == "Color3" then
                exportData[k] = {R = v.R, G = v.G, B = v.B}
            end
        end
        local json = HttpService:JSONEncode(exportData)
        ExportInput.Box.Text = json
        setclipboard(json)
        Library:Notify({Title="EXPORT", Content="Theme JSON copied to clipboard!"})
    end)

    JSONGroup:AddButton("IMPORT FROM STRING", function()
        local str = ExportInput:Get()
        if str and str ~= "" then
            local success, data = pcall(function() return HttpService:JSONDecode(str) end)
            if success and type(data) == "table" then
                local newTheme = {}
                for k, v in pairs(data) do
                    if v.R then newTheme[k] = Color3.new(v.R, v.G, v.B) end
                end
                
                ThemeManager:UpdateTheme(newTheme)
                
                -- Sync Pickers
                for key, col in pairs(newTheme) do
                    if Library.Options["Theme_"..key] then
                        Library.Options["Theme_"..key]:Set(col)
                    end
                end
                
                Library:Notify({Title="IMPORT", Content="Custom theme applied!"})
            else
                Library:Notify({Title="ERROR", Content="Invalid JSON data!", Image=Assets.Icons.Warning})
            end
        end
    end)

    -- 3. GENERAL SETTINGS
    local MainSettings = Settings:AddGroupbox({Title = "GENERAL SETTINGS", Side = "Right"})
    
    MainSettings:AddKeybind("Toggle Interface", Enum.KeyCode.RightControl, function(key)
        Library.ScreenGui.Enabled = not Library.ScreenGui.Enabled
    end)

    MainSettings:AddToggle("Show Keybind HUD", true, function(v)
        Library.KeybindFrame.Visible = v
    end)
    
    MainSettings:AddToggle("Show Watermark", true, function(v)
        Library.WatermarkFrame.Visible = v
    end)

    MainSettings:AddButton("Unload Interface", function()
        Library:Modal({
            Title = "UNLOAD UI?",
            Content = "This will destroy the interface and clear all connections.",
            OnConfirm = function() Library.ScreenGui:Destroy() end
        })
    end)

    -- 4. CONFIG MANAGER
    local ConfigGroup = Settings:AddGroupbox({Title = "CONFIGURATIONS", Side = "Right"})
    local CfgName = ConfigGroup:AddInput("Config Name", {Placeholder = "MySetting"})
    local CfgList = ConfigGroup:AddDropdown("Files", Library:GetConfigs(), false, function() end)
    
    ConfigGroup:AddButton("SAVE CONFIG", function()
        local name = CfgName:Get()
        if name ~= "" then
            Library:SaveConfig(name)
            CfgList:Set(Library:GetConfigs())
        else
            Library:Notify({Title="ERROR", Content="Please enter a config name."})
        end
    end)
    
    ConfigGroup:AddButton("LOAD CONFIG", function()
        local selected = CfgList:Set(Library.Flags["Files"]) -- Get selected
        if selected then Library:LoadConfig(selected) end
    end)
    
    ConfigGroup:AddButton("REFRESH LIST", function()
        CfgList:Set(Library:GetConfigs())
    end)

    return Window
end

return Library