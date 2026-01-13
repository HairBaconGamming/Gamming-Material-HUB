--[[
    CYBER-HACK UI LIBRARY - V2 ULTIMATE
    Style: Modern Cyberpunk / High Performance
    Author: Refactored by Gemini
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

--// THEME CONFIGURATION //--
local Theme = {
    Main = Color3.fromRGB(18, 18, 24),
    Secondary = Color3.fromRGB(25, 25, 35),
    Stroke = Color3.fromRGB(45, 45, 60),
    Accent = Color3.fromRGB(0, 255, 180), -- Neon Cyan/Green
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(140, 140, 140),
    FontMain = Enum.Font.GothamBold,
    FontSemi = Enum.Font.GothamSemibold,
}

--// UTILITY FUNCTIONS //--
local Utility = {}

function Utility:Create(class, props, children)
    local instance = Instance.new(class)
    for k, v in pairs(props or {}) do
        instance[k] = v
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = instance
        end
    end
    return instance
end

function Utility:Tween(instance, info, goals)
    local tween = TweenService:Create(instance, TweenInfo.new(unpack(info)), goals)
    tween:Play()
    return tween
end

function Utility:Ripple(obj)
    spawn(function()
        local Mouse = UserInputService:GetMouseLocation()
        local Ripple = Utility:Create("Frame", {
            Parent = obj,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            Position = UDim2.new(0, Mouse.X - obj.AbsolutePosition.X, 0, Mouse.Y - obj.AbsolutePosition.Y - 36),
            Size = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = obj.ZIndex + 1
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
        
        Utility:Tween(Ripple, {0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out}, {
            Size = UDim2.new(0, obj.AbsoluteSize.X * 1.5, 0, obj.AbsoluteSize.X * 1.5),
            Position = UDim2.new(0.5, -obj.AbsoluteSize.X * 0.75, 0.5, -obj.AbsoluteSize.X * 0.75),
            BackgroundTransparency = 1
        })
        game.Debris:AddItem(Ripple, 0.6)
    end)
end

function Utility:MakeDraggable(topbar, main)
    local dragging, dragInput, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Utility:Tween(main, {0.05, Enum.EasingStyle.Sine}, {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            })
        end
    end)
end

--// LIBRARY CORE //--
local Library = {}
local ScreenGui = nil

function Library:Load(config)
    local Title = config.Title or "CYBER HUB"
    local ToggleKey = config.Key or Enum.KeyCode.RightControl
    
    if CoreGui:FindFirstChild("CyberHub_V2") then
        CoreGui:FindFirstChild("CyberHub_V2"):Destroy()
    end
    
    ScreenGui = Utility:Create("ScreenGui", {
        Name = "CyberHub_V2",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    -- Notify Container
    local NotifyContainer = Utility:Create("Frame", {
        Name = "NotifyContainer",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -220, 1, -20),
        AnchorPoint = Vector2.new(1, 1),
        Size = UDim2.new(0, 200, 1, 0)
    }, {
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 5)
        })
    })

    -- Main Container
    local Main = Utility:Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        Size = UDim2.fromOffset(600, 450),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 2}),
    })
    
    -- Animation: Boot up
    Main.Size = UDim2.fromOffset(0, 0)
    Utility:Tween(Main, {0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.fromOffset(600, 450)})

    -- Sidebar
    local Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = Theme.Secondary,
        Size = UDim2.new(0, 160, 1, 0),
        ZIndex = 2
    }, {
        Utility:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Utility:Create("Frame", { -- Fix corner
            BackgroundColor3 = Theme.Secondary,
            Size = UDim2.new(0, 10, 1, 0),
            Position = UDim2.new(1, -10, 0, 0),
            BorderSizePixel = 0
        }),
        Utility:Create("TextLabel", { -- Logo
            Text = Title,
            Font = Theme.FontMain,
            TextColor3 = Theme.Accent,
            TextSize = 22,
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 15, 0, 10),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })

    local TabContainer = Utility:Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,0,0)
    }, {
        Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.VerticalAlignment.Center
        }),
        Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})
    })

    -- Content Area
    local Content = Utility:Create("Frame", {
        Name = "Content",
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -170, 1, -20),
        Position = UDim2.new(0, 170, 0, 10),
        ClipsDescendants = true
    })

    Utility:MakeDraggable(Sidebar, Main)

    -- Toggle Logic
    local toggled = true
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == ToggleKey then
            toggled = not toggled
            if toggled then
                ScreenGui.Enabled = true
                Main:TweenSize(UDim2.fromOffset(600, 450), "Out", "Back", 0.4, true)
            else
                Main:TweenSize(UDim2.fromOffset(0, 0), "In", "Back", 0.3, true, function()
                    ScreenGui.Enabled = false
                end)
            end
        end
    end)

    --// WINDOW FUNCTIONS //--
    local Window = {}
    
    function Window:Notify(config)
        local Title = config.Title or "Notification"
        local Text = config.Content or ""
        local Duration = config.Duration or 3

        local NotifFrame = Utility:Create("Frame", {
            Parent = NotifyContainer,
            BackgroundColor3 = Theme.Secondary,
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundTransparency = 1 -- Start hidden
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Utility:Create("UIStroke", {Color = Theme.Accent, Thickness = 1}),
            Utility:Create("TextLabel", {
                Text = Title,
                Font = Theme.FontMain,
                TextColor3 = Theme.Accent,
                TextSize = 14,
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility:Create("TextLabel", {
                Text = Text,
                Font = Theme.FontSemi,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Size = UDim2.new(1, -10, 0, 30),
                Position = UDim2.new(0, 10, 0, 25),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })
        })

        -- Animate In
        Utility:Tween(NotifFrame, {0.3}, {BackgroundTransparency = 0.1})
        
        -- Remove
        task.delay(Duration, function()
            Utility:Tween(NotifFrame, {0.3}, {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,0)})
            task.wait(0.3)
            NotifFrame:Destroy()
        end)
    end

    local FirstTab = true

    function Window:Tab(name)
        -- Tab Button
        local TabBtn = Utility:Create("TextButton", {
            Parent = TabContainer,
            Text = name,
            Font = Theme.FontSemi,
            TextColor3 = Theme.TextDim,
            TextSize = 14,
            BackgroundColor3 = Theme.Main,
            Size = UDim2.new(1, -10, 0, 35),
            AutoButtonColor = false,
            TextXAlignment = Enum.TextXAlignment.Left
        }, {
            Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Utility:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)})
        })

        -- Active Indicator
        local Indicator = Utility:Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 3, 0, 20),
            Position = UDim2.new(0, -10, 0.5, -10),
            BackgroundTransparency = 1
        }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})})

        -- Page Frame
        local Page = Utility:Create("ScrollingFrame", {
            Name = name.."_Page",
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = false,
            CanvasSize = UDim2.new(0,0,0,0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.VerticalAlignment.Center
            }),
            Utility:Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
        })

        -- Activate Function
        local function Activate()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:Tween(v, {0.2}, {TextColor3 = Theme.TextDim, BackgroundColor3 = Theme.Main})
                    Utility:Tween(v:FindFirstChild("Frame"), {0.2}, {BackgroundTransparency = 1})
                end
            end
            
            Page.Visible = true
            Utility:Tween(TabBtn, {0.2}, {TextColor3 = Theme.Text, BackgroundColor3 = Color3.fromRGB(35,35,45)})
            Utility:Tween(Indicator, {0.2}, {BackgroundTransparency = 0})
        end

        TabBtn.MouseButton1Click:Connect(Activate)

        if FirstTab then
            Activate()
            FirstTab = false
        end

        --// ELEMENTS //--
        local Elements = {}

        function Elements:Label(text)
            Utility:Create("TextLabel", {
                Parent = Page,
                Text = text,
                Font = Theme.FontMain,
                TextColor3 = Theme.Text,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function Elements:Paragraph(config)
            local Title = config.Title or "Paragraph"
            local ContentText = config.Content or ""
            
            local ParaFrame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 0), -- Auto size
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1}),
                Utility:Create("UIPadding", {PaddingTop = UDim.new(0,10), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
            })
            
            Utility:Create("TextLabel", {
                Parent = ParaFrame,
                Text = Title,
                Font = Theme.FontMain,
                TextColor3 = Theme.Accent,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            Utility:Create("TextLabel", {
                Parent = ParaFrame,
                Text = ContentText,
                Font = Theme.FontSemi,
                TextColor3 = Theme.TextDim,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0,0,0,25),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y
            })
        end

        function Elements:Button(config)
            local Title = config.Title or "Button"
            local Callback = config.Callback or function() end

            local Btn = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                AutoButtonColor = false
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1}),
                Utility:Create("TextLabel", {
                    Text = Title,
                    Font = Theme.FontSemi,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Utility:Create("ImageLabel", { -- Icon
                    Image = "rbxassetid://6031094670",
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -30, 0.5, -10),
                    ImageColor3 = Theme.TextDim
                })
            })

            Btn.MouseEnter:Connect(function()
                Utility:Tween(Btn.UIStroke, {0.2}, {Color = Theme.Accent})
                Utility:Tween(Btn.TextLabel, {0.2}, {TextColor3 = Theme.Accent})
            end)
            
            Btn.MouseLeave:Connect(function()
                Utility:Tween(Btn.UIStroke, {0.2}, {Color = Theme.Stroke})
                Utility:Tween(Btn.TextLabel, {0.2}, {TextColor3 = Theme.Text})
            end)

            Btn.MouseButton1Click:Connect(function()
                Utility:Ripple(Btn)
                Callback()
            end)
        end

        function Elements:Toggle(config)
            local Title = config.Title or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end

            local TglBtn = Utility:Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                AutoButtonColor = false
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1}),
                Utility:Create("TextLabel", {
                    Text = Title,
                    Font = Theme.FontSemi,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })

            local Switch = Utility:Create("Frame", {
                Parent = TglBtn,
                BackgroundColor3 = Color3.fromRGB(40, 40, 50),
                Size = UDim2.fromOffset(40, 20),
                Position = UDim2.new(1, -50, 0.5, -10)
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            local Circle = Utility:Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Theme.TextDim,
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(0, 2, 0.5, -8)
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})

            local Active = Default

            local function Update()
                if Active then
                    Utility:Tween(Switch, {0.2}, {BackgroundColor3 = Theme.Accent})
                    Utility:Tween(Circle, {0.2}, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255,255,255)})
                    Utility:Tween(TglBtn.UIStroke, {0.2}, {Color = Theme.Accent})
                else
                    Utility:Tween(Switch, {0.2}, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)})
                    Utility:Tween(Circle, {0.2}, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Theme.TextDim})
                    Utility:Tween(TglBtn.UIStroke, {0.2}, {Color = Theme.Stroke})
                end
                Callback(Active)
            end

            TglBtn.MouseButton1Click:Connect(function()
                Active = not Active
                Update()
            end)
            
            Update()
            
            return {Set = function(_, val) Active = val Update() end}
        end

        function Elements:Slider(config)
            local Title = config.Title or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Callback = config.Callback or function() end
            
            local Value = Default

            local SliderFrame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 55)
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1}),
                Utility:Create("TextLabel", {
                    Text = Title,
                    Font = Theme.FontSemi,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local ValueInput = Utility:Create("TextBox", {
                Parent = SliderFrame,
                Text = tostring(Default),
                Font = Theme.FontMain,
                TextColor3 = Theme.Accent,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = Utility:Create("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(40,40,50),
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 35)
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})

            local Fill = Utility:Create("Frame", {
                Parent = Bar,
                BackgroundColor3 = Theme.Accent,
                Size = UDim2.fromScale(0, 1)
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                Utility:Create("Frame", { -- Glow
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new(0, 10, 1, 6),
                    Position = UDim2.new(1, -5, 0.5, -3),
                    BackgroundTransparency = 0.5
                }, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})
            })

            local Trigger = Utility:Create("TextButton", {
                Parent = Bar,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ""
            })

            local function Update(val)
                Value = math.clamp(val, Min, Max)
                local percent = (Value - Min) / (Max - Min)
                Utility:Tween(Fill, {0.1}, {Size = UDim2.fromScale(percent, 1)})
                ValueInput.Text = math.floor(Value * 100)/100
                Callback(Value)
            end

            Trigger.MouseButton1Down:Connect(function()
                local move, kill
                move = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local sizeX = Bar.AbsoluteSize.X
                        local relativeX = math.clamp(input.Position.X - Bar.AbsolutePosition.X, 0, sizeX)
                        Update(Min + (Max - Min) * (relativeX / sizeX))
                    end
                end)
                kill = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        move:Disconnect()
                        kill:Disconnect()
                    end
                end)
                local sizeX = Bar.AbsoluteSize.X
                local relativeX = math.clamp(UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X, 0, sizeX)
                Update(Min + (Max - Min) * (relativeX / sizeX))
            end)
            
            ValueInput.FocusLost:Connect(function()
                local num = tonumber(ValueInput.Text)
                if num then Update(num) else Update(Value) end
            end)

            Update(Default)
            return {Set = function(_, v) Update(v) end}
        end

        function Elements:Dropdown(config)
            local Title = config.Title or "Dropdown"
            local Items = config.Items or {}
            local Callback = config.Callback or function() end
            
            local IsOpen = false
            
            local DropFrame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1})
            })
            
            local Header = Utility:Create("TextButton", {
                Parent = DropFrame,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            })
            
            Utility:Create("TextLabel", {
                Parent = Header,
                Text = Title,
                Font = Theme.FontSemi,
                TextColor3 = Theme.Text,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = Utility:Create("ImageLabel", {
                Parent = Header,
                Image = "rbxassetid://6031091004",
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                ImageColor3 = Theme.TextDim
            })
            
            local Container = Utility:Create("Frame", {
                Parent = DropFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 0)
            }, {
                Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})
            })
            
            local function Refresh()
                for _, v in pairs(Container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                
                for _, item in pairs(Items) do
                    local ItemBtn = Utility:Create("TextButton", {
                        Parent = Container,
                        Text = "  " .. tostring(item),
                        Font = Theme.FontSemi,
                        TextColor3 = Theme.TextDim,
                        BackgroundColor3 = Theme.Secondary,
                        Size = UDim2.new(1, 0, 0, 30),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false
                    })
                    
                    ItemBtn.MouseEnter:Connect(function() ItemBtn.TextColor3 = Theme.Accent ItemBtn.BackgroundColor3 = Color3.fromRGB(35,35,45) end)
                    ItemBtn.MouseLeave:Connect(function() ItemBtn.TextColor3 = Theme.TextDim ItemBtn.BackgroundColor3 = Theme.Secondary end)
                    
                    ItemBtn.MouseButton1Click:Connect(function()
                        IsOpen = false
                        Utility:Tween(DropFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 40)})
                        Utility:Tween(Arrow, {0.3}, {Rotation = 0})
                        Utility:Tween(DropFrame.UIStroke, {0.3}, {Color = Theme.Stroke})
                        Header.TextLabel.Text = Title .. ": " .. tostring(item)
                        Callback(item)
                    end)
                end
            end
            
            Header.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                local height = IsOpen and (40 + (#Items * 30)) or 40
                Utility:Tween(DropFrame, {0.3, Enum.EasingStyle.Quad}, {Size = UDim2.new(1, 0, 0, height)})
                Utility:Tween(Arrow, {0.3}, {Rotation = IsOpen and 180 or 0})
                Utility:Tween(DropFrame.UIStroke, {0.3}, {Color = IsOpen and Theme.Accent or Theme.Stroke})
            end)
            
            Refresh()
            return {Refresh = function(_, newItems) Items = newItems Refresh() end}
        end

        function Elements:Textbox(config)
            local Title = config.Title or "Textbox"
            local Place = config.Placeholder or "Type..."
            local Callback = config.Callback or function() end
            
            local BoxFrame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40)
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1}),
                Utility:Create("TextLabel", {
                    Text = Title,
                    Font = Theme.FontSemi,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local Input = Utility:Create("TextBox", {
                Parent = BoxFrame,
                BackgroundColor3 = Color3.fromRGB(30, 30, 40),
                Size = UDim2.new(0.55, 0, 0, 26),
                Position = UDim2.new(1, -10, 0.5, -13),
                AnchorPoint = Vector2.new(1, 0),
                Font = Theme.FontSemi,
                Text = "",
                PlaceholderText = Place,
                TextColor3 = Theme.Accent,
                PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                TextSize = 13
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
            })
            
            Input.FocusLost:Connect(function()
                Callback(Input.Text)
            end)
        end

        function Elements:Keybind(config)
            local Title = config.Title or "Keybind"
            local Key = config.Key or Enum.KeyCode.E
            local Callback = config.Callback or function() end
            
            local KeyFrame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40)
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1}),
                Utility:Create("TextLabel", {
                    Text = Title,
                    Font = Theme.FontSemi,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            })
            
            local BindBtn = Utility:Create("TextButton", {
                Parent = KeyFrame,
                BackgroundColor3 = Color3.fromRGB(30,30,40),
                Size = UDim2.new(0, 80, 0, 26),
                Position = UDim2.new(1, -10, 0.5, -13),
                AnchorPoint = Vector2.new(1, 0),
                Text = Key.Name,
                Font = Theme.FontMain,
                TextColor3 = Theme.TextDim,
                TextSize = 12
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
            
            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."
                BindBtn.TextColor3 = Theme.Accent
                local input = UserInputService.InputBegan:Wait()
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Key = input.KeyCode
                    BindBtn.Text = Key.Name
                    BindBtn.TextColor3 = Theme.TextDim
                    Callback(Key)
                end
            end)
        end

        function Elements:ColorPicker(config)
            local Title = config.Title or "Color Picker"
            local Default = config.Default or Color3.fromRGB(255, 255, 255)
            local Callback = config.Callback or function() end
            
            local H, S, V = Default:ToHSV()
            local IsOpen = false
            
            local PickerFrame = Utility:Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Utility:Create("UIStroke", {Color = Theme.Stroke, Thickness = 1})
            })
            
            local Header = Utility:Create("TextButton", {
                Parent = PickerFrame,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            })
            
            Utility:Create("TextLabel", {
                Parent = Header,
                Text = Title,
                Font = Theme.FontSemi,
                TextColor3 = Theme.Text,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Preview = Utility:Create("Frame", {
                Parent = Header,
                BackgroundColor3 = Default,
                Size = UDim2.fromOffset(25, 25),
                Position = UDim2.new(1, -35, 0.5, -12.5)
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Utility:Create("UIStroke", {Thickness = 1, Color = Color3.new(1,1,1), Transparency = 0.5})})
            
            -- Picker Logic
            local Container = Utility:Create("Frame", {
                Parent = PickerFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 130)
            })
            
            local SatVal = Utility:Create("ImageLabel", {
                Parent = Container,
                Size = UDim2.fromOffset(100, 100),
                Position = UDim2.new(0, 10, 0, 10),
                Image = "rbxassetid://4155801252",
                BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                BorderSizePixel = 0
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
            
            local Hue = Utility:Create("ImageLabel", {
                Parent = Container,
                Size = UDim2.new(0, 15, 0, 100),
                Position = UDim2.new(0, 120, 0, 10),
                Image = "rbxassetid://16786657529", -- Rainbow Gradient
                BackgroundColor3 = Color3.new(1,1,1)
            }, {
                Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
                Utility:Create("UIGradient", {Rotation = 90, Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,0,255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
                })})
            })
            
            local HexInput = Utility:Create("TextBox", {
                Parent = Container,
                Size = UDim2.new(0, 80, 0, 30),
                Position = UDim2.new(1, -90, 0, 10),
                BackgroundColor3 = Theme.Main,
                Text = "#"..Default:ToHex():upper(),
                TextColor3 = Theme.Accent,
                Font = Theme.FontMain,
                TextSize = 14
            }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})

            -- Logic
            local function UpdateColor()
                local c = Color3.fromHSV(H, S, V)
                Preview.BackgroundColor3 = c
                SatVal.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                HexInput.Text = "#"..c:ToHex():upper()
                Callback(c)
            end
            
            local function HandleInput(obj, isHue)
                local Mouse = UserInputService:GetMouseLocation()
                local Pos, Size = obj.AbsolutePosition, obj.AbsoluteSize
                local X = math.clamp((Mouse.X - Pos.X) / Size.X, 0, 1)
                local Y = math.clamp((Mouse.Y - Pos.Y - 36) / Size.Y, 0, 1)
                
                if isHue then H = 1 - Y else S = X V = 1 - Y end
                UpdateColor()
            end
            
            SatVal.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local m = UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then HandleInput(SatVal, false) end end)
                    local e; e = UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then m:Disconnect() e:Disconnect() end end)
                    HandleInput(SatVal, false)
                end
            end)

             Hue.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local m = UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then HandleInput(Hue, true) end end)
                    local e; e = UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then m:Disconnect() e:Disconnect() end end)
                    HandleInput(Hue, true)
                end
            end)
            
            Header.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                Utility:Tween(PickerFrame, {0.3}, {Size = UDim2.new(1, 0, 0, IsOpen and 180 or 40)})
            end)
        end

        return Elements
    end
    
    return Window
end

return Library