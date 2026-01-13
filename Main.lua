--[[
    CYBER-HACK UI LIBRARY - REFACTORED EDITION
    Style: Cyberpunk / React-Structure
    Author: Refactored by Gemini
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--// Utility & React-like Helpers //--
local Utility = {}

function Utility:Create(className, properties, children)
	local instance = Instance.new(className)
	for k, v in pairs(properties or {}) do
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
	local tween = TweenService:Create(instance, TweenInfo.new(table.unpack(info)), goals)
	tween:Play()
	return tween
end

function Utility:MakeDraggable(topbar, object)
	local dragging, dragInput, dragStart, startPos

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
			
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
			Utility:Tween(object, {0.05, Enum.EasingStyle.Linear}, {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			})
		end
	end)
end

--// Theme Configuration //--
local Theme = {
	Background = Color3.fromRGB(15, 15, 20),
	Darker = Color3.fromRGB(10, 10, 12),
	Accent = Color3.fromRGB(0, 255, 170), -- Cyber Green
	Text = Color3.fromRGB(240, 240, 240),
	TextDim = Color3.fromRGB(150, 150, 150),
	Error = Color3.fromRGB(255, 50, 50),
	Font = Enum.Font.Code, -- Hacker style font
}

--// Main Library //--
local Library = {}
local UI_Screen = nil

function Library:Load(config)
	local Title = config.Title or "SYSTEM"
	local Key = config.Key
	
	-- Destroy old instance if exists
	if CoreGui:FindFirstChild("CyberHub_UI") then
		CoreGui:FindFirstChild("CyberHub_UI"):Destroy()
	end

	-- Create ScreenGui
	UI_Screen = Utility:Create("ScreenGui", {
		Name = "CyberHub_UI",
		Parent = CoreGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})

	-- Toggle Logic
	local toggled = true
	local function toggleUI()
		toggled = not toggled
		UI_Screen.Enabled = toggled
	end

	if Key then
		UserInputService.InputBegan:Connect(function(input, gp)
			if not gp and input.KeyCode == (typeof(Key) == "EnumItem" and Key or Enum.KeyCode[Key]) then
				toggleUI()
			end
		end)
	end

	-- Main Container (Window)
	local MainFrame = Utility:Create("Frame", {
		Name = "MainFrame",
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(550, 400),
		ClipsDescendants = true
	}, {
		Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
		Utility:Create("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.5}),
	})
	MainFrame.Parent = UI_Screen

	-- Top Bar
	local TopBar = Utility:Create("Frame", {
		Name = "TopBar",
		BackgroundColor3 = Theme.Darker,
		Size = UDim2.new(1, 0, 0, 35),
		Parent = MainFrame
	}, {
		Utility:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
		Utility:Create("Frame", { -- Cover bottom corner
			BackgroundColor3 = Theme.Darker,
			Size = UDim2.new(1, 0, 0, 5),
			Position = UDim2.new(0,0,1,-5),
			BorderSizePixel = 0
		}),
		Utility:Create("TextLabel", {
			Text = " // " .. string.upper(Title),
			Font = Theme.Font,
			TextSize = 16,
			TextColor3 = Theme.Accent,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
	
	Utility:MakeDraggable(TopBar, MainFrame)

	-- Navigation (Sidebar) & Content Area
	local Sidebar = Utility:Create("ScrollingFrame", {
		Name = "Sidebar",
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 140, 1, -45),
		Position = UDim2.new(0, 10, 0, 40),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0,0,0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	})
	
	local SidebarLayout = Utility:Create("UIListLayout", {
		Parent = Sidebar,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local ContentArea = Utility:Create("Frame", {
		Name = "ContentArea",
		Parent = MainFrame,
		BackgroundColor3 = Theme.Darker,
		Size = UDim2.new(1, -165, 1, -50),
		Position = UDim2.new(0, 155, 0, 40)
	}, {
		Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
		Utility:Create("UIStroke", {Color = Color3.fromRGB(40,40,40), Thickness = 1})
	})

	--// Window Object //--
	local Window = {}
	local firstTab = true

	function Window:New(config)
		local TabTitle = config.Title or "Tab"
		local TabIcon = config.ImageId -- Optional

		-- Tab Button (Sidebar)
		local TabBtn = Utility:Create("TextButton", {
			Parent = Sidebar,
			Text = TabTitle,
			Font = Theme.Font,
			TextColor3 = Theme.TextDim,
			BackgroundColor3 = Theme.Darker,
			Size = UDim2.new(1, 0, 0, 32),
			AutoButtonColor = false,
			TextSize = 14
		}, {
			Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
		})

		-- Tab Container
		local TabFrame = Utility:Create("ScrollingFrame", {
			Name = TabTitle.."_Frame",
			Parent = ContentArea,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.Accent,
			Visible = false,
			AutomaticCanvasSize = Enum.AutomaticSize.Y
		})

		local TabList = Utility:Create("UIListLayout", {
			Parent = TabFrame,
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		-- Activation Logic
		local function Activate()
			for _, v in pairs(ContentArea:GetChildren()) do
				if v:IsA("ScrollingFrame") then v.Visible = false end
			end
			for _, v in pairs(Sidebar:GetChildren()) do
				if v:IsA("TextButton") then 
					Utility:Tween(v, {0.2}, {TextColor3 = Theme.TextDim, BackgroundColor3 = Theme.Darker})
				end
			end
			TabFrame.Visible = true
			Utility:Tween(TabBtn, {0.2}, {TextColor3 = Theme.Accent, BackgroundColor3 = Color3.fromRGB(25, 25, 30)})
		end

		TabBtn.MouseButton1Click:Connect(Activate)

		if firstTab then
			Activate()
			firstTab = false
		end

		--// Component System //--
		local Elements = {}

		function Elements:Button(props)
			local Title = props.Title
			local Callback = props.Callback or function() end
			
			local ButtonFrame = Utility:Create("TextButton", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, 35),
				Text = "",
				AutoButtonColor = false
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(40,40,40), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}),
				Utility:Create("TextLabel", {
					Text = Title,
					Font = Theme.Font,
					TextColor3 = Theme.Text,
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -20, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Utility:Create("ImageLabel", { -- Icon for action
					Image = "rbxassetid://6031094670",
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(20,20),
					Position = UDim2.new(1, -30, 0.5, -10),
					ImageColor3 = Theme.TextDim
				})
			})

			ButtonFrame.MouseEnter:Connect(function()
				Utility:Tween(ButtonFrame.UIStroke, {0.2}, {Color = Theme.Accent})
				Utility:Tween(ButtonFrame.TextLabel, {0.2}, {TextColor3 = Theme.Accent})
			end)
			
			ButtonFrame.MouseLeave:Connect(function()
				Utility:Tween(ButtonFrame.UIStroke, {0.2}, {Color = Color3.fromRGB(40,40,40)})
				Utility:Tween(ButtonFrame.TextLabel, {0.2}, {TextColor3 = Theme.Text})
			end)

			ButtonFrame.MouseButton1Click:Connect(function()
				local ripple = Utility:Create("Frame", {
					BackgroundColor3 = Theme.Accent,
					BackgroundTransparency = 0.6,
					Position = UDim2.fromScale(0.5,0.5),
					AnchorPoint = Vector2.new(0.5,0.5),
					Size = UDim2.fromScale(0,0),
					Parent = ButtonFrame
				}, {Utility:Create("UICorner", {CornerRadius = UDim.new(1,0)})})
				
				Utility:Tween(ripple, {0.4}, {Size = UDim2.fromScale(1.5, 2.5), BackgroundTransparency = 1})
				game.Debris:AddItem(ripple, 0.45)
				Callback()
			end)
			
			local Funcs = {}
			function Funcs:SetTitle(t) ButtonFrame.TextLabel.Text = t end
			function Funcs:SetCallback(f) Callback = f end
			function Funcs:Fire() Callback() end
			return Funcs
		end

		function Elements:Toggle(props)
			local Title = props.Title
			local Enabled = props.Enabled or false
			local Callback = props.Callback or function() end

			local ToggleFrame = Utility:Create("TextButton", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, 35),
				Text = "",
				AutoButtonColor = false
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("TextLabel", {
					Text = Title,
					Font = Theme.Font,
					TextColor3 = Theme.Text,
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -50, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})

			local Checkbox = Utility:Create("Frame", {
				Parent = ToggleFrame,
				Size = UDim2.fromOffset(20, 20),
				Position = UDim2.new(1, -30, 0.5, -10),
				BackgroundColor3 = Theme.Darker
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(60,60,60), Thickness = 1})
			})

			local Checkmark = Utility:Create("Frame", {
				Parent = Checkbox,
				Size = UDim2.fromScale(0, 0), -- Animated size
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Theme.Accent
			}, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 2)})})

			local function UpdateState(state)
				Enabled = state
				if Enabled then
					Utility:Tween(Checkmark, {0.2, Enum.EasingStyle.Back}, {Size = UDim2.fromScale(0.7, 0.7)})
					Utility:Tween(Checkbox.UIStroke, {0.2}, {Color = Theme.Accent})
				else
					Utility:Tween(Checkmark, {0.2}, {Size = UDim2.fromScale(0, 0)})
					Utility:Tween(Checkbox.UIStroke, {0.2}, {Color = Color3.fromRGB(60,60,60)})
				end
				Callback(Enabled)
			end

			ToggleFrame.MouseButton1Click:Connect(function()
				UpdateState(not Enabled)
			end)
			
			-- Initialize
			UpdateState(Enabled)

			local Funcs = {}
			function Funcs:Set(v) UpdateState(v) end
			return Funcs
		end

		function Elements:Slide(props)
			local Title = props.Title
			local Min = props.Min or 0
			local Max = props.Max or 100
			local Default = props.Default or Min
			local Callback = props.Callback or function() end
			
			local Value = Default

			local SliderFrame = Utility:Create("Frame", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, 50)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("TextLabel", {
					Text = Title,
					Font = Theme.Font,
					TextColor3 = Theme.Text,
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 25),
					Position = UDim2.new(0, 10, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Utility:Create("TextLabel", {
					Name = "ValueLabel",
					Text = tostring(Value),
					Font = Theme.Font,
					TextColor3 = Theme.Accent,
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -20, 0, 25),
					Position = UDim2.new(0, 0, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Right
				})
			})

			local SliderBar = Utility:Create("Frame", {
				Parent = SliderFrame,
				BackgroundColor3 = Theme.Darker,
				Size = UDim2.new(1, -20, 0, 6),
				Position = UDim2.new(0, 10, 0, 32)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
			})

			local Fill = Utility:Create("Frame", {
				Parent = SliderBar,
				BackgroundColor3 = Theme.Accent,
				Size = UDim2.fromScale(0, 1)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
				Utility:Create("Frame", { -- Glow tip
					BackgroundColor3 = Theme.Text,
					Size = UDim2.new(0, 2, 1, 4),
					Position = UDim2.new(1, -1, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 0.5
				})
			})
			
			local Interact = Utility:Create("TextButton", {
				Parent = SliderBar,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = ""
			})

			local function Update(val)
				Value = math.clamp(val, Min, Max)
				local percent = (Value - Min) / (Max - Min)
				Fill:TweenSize(UDim2.new(percent, 0, 1, 0), "Out", "Quad", 0.1, true)
				SliderFrame.ValueLabel.Text = string.format("%.1f", Value) -- Supports float
				Callback(Value)
			end
			
			Interact.MouseButton1Down:Connect(function()
				local move, kill
				move = UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						local sizeX = SliderBar.AbsoluteSize.X
						local relativeX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, sizeX)
						local percent = relativeX / sizeX
						Update(Min + (Max - Min) * percent)
					end
				end)
				kill = UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						move:Disconnect()
						kill:Disconnect()
					end
				end)
				-- Trigger once on click
				local sizeX = SliderBar.AbsoluteSize.X
				local relativeX = math.clamp(UserInputService:GetMouseLocation().X - SliderBar.AbsolutePosition.X, 0, sizeX)
				Update(Min + (Max - Min) * (relativeX / sizeX))
			end)
			
			Update(Default)
			
			local Funcs = {}
			function Funcs:Set(v) Update(v) end
			return Funcs
		end

		function Elements:Dropdown(props)
			local Title = props.Title
			local Items = props.Table or {}
			local Callback = props.Callback or function() end
			local AutoText = props.AutoTextChose or false
			
			local DropHeight = 35
			local Open = false
			
			local DropFrame = Utility:Create("Frame", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, DropHeight),
				ClipsDescendants = true
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(40,40,40), Thickness = 1})
			})

			local Header = Utility:Create("TextButton", {
				Parent = DropFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 35),
				Text = "",
				AutoButtonColor = false
			})

			local Label = Utility:Create("TextLabel", {
				Parent = Header,
				Text = Title,
				Font = Theme.Font,
				TextColor3 = Theme.Text,
				TextSize = 14,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -30, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Arrow = Utility:Create("ImageLabel", {
				Parent = Header,
				Image = "rbxassetid://6031091004", -- Arrow icon
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(20, 20),
				Position = UDim2.new(1, -25, 0.5, -10),
				ImageColor3 = Theme.TextDim
			})

			local ItemContainer = Utility:Create("Frame", {
				Parent = DropFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 35),
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				Utility:Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})
			})

			local function Refresh(newItems)
				for _, v in pairs(ItemContainer:GetChildren()) do
					if v:IsA("TextButton") then v:Destroy() end
				end
				
				for _, item in pairs(newItems) do
					local ItemBtn = Utility:Create("TextButton", {
						Parent = ItemContainer,
						Text = "  > " .. tostring(item),
						Font = Theme.Font,
						TextColor3 = Theme.TextDim,
						BackgroundColor3 = Theme.Darker,
						Size = UDim2.new(1, 0, 0, 25),
						TextXAlignment = Enum.TextXAlignment.Left,
						AutoButtonColor = false
					})
					
					ItemBtn.MouseEnter:Connect(function() ItemBtn.TextColor3 = Theme.Accent end)
					ItemBtn.MouseLeave:Connect(function() ItemBtn.TextColor3 = Theme.TextDim end)
					
					ItemBtn.MouseButton1Click:Connect(function()
						Callback(item)
						if AutoText then Label.Text = Title .. ": " .. tostring(item) end
						-- Close
						Open = false
						Utility:Tween(DropFrame, {0.3}, {Size = UDim2.new(1, 0, 0, 35)})
						Utility:Tween(Arrow, {0.3}, {Rotation = 0})
					end)
				end
			end
			
			Header.MouseButton1Click:Connect(function()
				Open = not Open
				local count = #ItemContainer:GetChildren() - 1 -- minus Layout
				local totalHeight = 35 + (Open and (count * 25) or 0)
				
				Utility:Tween(DropFrame, {0.3}, {Size = UDim2.new(1, 0, 0, totalHeight)})
				Utility:Tween(Arrow, {0.3}, {Rotation = Open and 180 or 0})
			end)

			Refresh(Items)
			
			local Funcs = {}
			function Funcs:SetTable(t) Refresh(t) end
			return Funcs
		end

		function Elements:Textbox(props)
			local Title = props.Title
			local Callback = props.Callback or function() end
			local Placeholder = props.TextboxTitle or "Type here..."
			local ClearOnFocus = props.ClearTextOnFocus or false

			local BoxFrame = Utility:Create("Frame", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, 55)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("TextLabel", {
					Text = Title,
					Font = Theme.Font,
					TextColor3 = Theme.Text,
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 25),
					Position = UDim2.new(0, 10, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})

			local Input = Utility:Create("TextBox", {
				Parent = BoxFrame,
				BackgroundColor3 = Theme.Darker,
				Size = UDim2.new(1, -20, 0, 25),
				Position = UDim2.new(0, 10, 0, 25),
				Font = Theme.Font,
				Text = "",
				PlaceholderText = Placeholder,
				TextColor3 = Theme.Accent,
				PlaceholderColor3 = Color3.fromRGB(100,100,100),
				TextSize = 14,
				ClearTextOnFocus = ClearOnFocus
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(60,60,60), Thickness = 1})
			})

			Input.FocusLost:Connect(function(enter)
				Callback(Input.Text)
				Utility:Tween(Input.UIStroke, {0.2}, {Color = Color3.fromRGB(60,60,60)})
			end)

			Input.Focused:Connect(function()
				Utility:Tween(Input.UIStroke, {0.2}, {Color = Theme.Accent})
			end)
			
			local Funcs = {}
			function Funcs:Set(t) Input.Text = t end
			return Funcs
		end

		function Elements:KeyBox(props)
			local Title = props.Title
			local Callback = props.Callback or function() end
			local DefaultKey = props.Key or Enum.KeyCode.E

			local KeyFrame = Utility:Create("Frame", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, 35)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("TextLabel", {
					Text = Title,
					Font = Theme.Font,
					TextColor3 = Theme.Text,
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(0.7, 0, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left
				})
			})

			local BindBtn = Utility:Create("TextButton", {
				Parent = KeyFrame,
				BackgroundColor3 = Theme.Darker,
				Size = UDim2.new(0, 80, 0, 20),
				Position = UDim2.new(1, -90, 0.5, -10),
				Text = DefaultKey.Name,
				Font = Theme.Font,
				TextColor3 = Theme.TextDim,
				TextSize = 12
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(60,60,60), Thickness = 1})
			})

			local Listening = false

			BindBtn.MouseButton1Click:Connect(function()
				Listening = true
				BindBtn.Text = "..."
				BindBtn.TextColor3 = Theme.Accent
				BindBtn.UIStroke.Color = Theme.Accent
				
				local conn
				conn = UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						Listening = false
						BindBtn.Text = input.KeyCode.Name
						BindBtn.TextColor3 = Theme.TextDim
						BindBtn.UIStroke.Color = Color3.fromRGB(60,60,60)
						Callback(input.KeyCode)
						conn:Disconnect()
					end
				end)
			end)
			
			return {}
		end

		function Elements:ColorPicker(props)
			local Title = props.Title
			local Callback = props.Callback or function() end
			local Default = props.Default or Color3.fromRGB(255, 255, 255)
			
			local ColorH, ColorS, ColorV = Default:ToHSV()
			local IsOpen = false

			local PickerFrame = Utility:Create("Frame", {
				Parent = TabFrame,
				BackgroundColor3 = Theme.Background,
				Size = UDim2.new(1, 0, 0, 35),
				ClipsDescendants = true
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(40,40,40), Thickness = 1})
			})
			
			local Header = Utility:Create("TextButton", {
				Parent = PickerFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 35),
				Text = "",
				AutoButtonColor = false
			})

			Utility:Create("TextLabel", {
				Parent = Header,
				Text = Title,
				Font = Theme.Font,
				TextColor3 = Theme.Text,
				TextSize = 14,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -50, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local CurrentColorPreview = Utility:Create("Frame", {
				Parent = Header,
				BackgroundColor3 = Default,
				Size = UDim2.fromOffset(20, 20),
				Position = UDim2.new(1, -30, 0.5, -10)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIStroke", {Color = Color3.fromRGB(255,255,255), Thickness = 1, Transparency = 0.8})
			})

			-- Container for picker logic
			local Container = Utility:Create("Frame", {
				Parent = PickerFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 35),
				Size = UDim2.new(1, 0, 0, 150)
			})

			-- Saturation/Value Square
			local SVMap = Utility:Create("ImageLabel", {
				Parent = Container,
				Size = UDim2.fromOffset(120, 120),
				Position = UDim2.new(0, 10, 0, 10),
				Image = "rbxassetid://4155801252", -- Color wheel square
				BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1),
				BorderSizePixel = 0
			}, {Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
			
			local Cursor = Utility:Create("Frame", {
				Parent = SVMap,
				Size = UDim2.fromOffset(6, 6),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1,1,1),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(ColorS, 1 - ColorV)
			}, {Utility:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})

			-- Hue Bar
			local HueBar = Utility:Create("ImageLabel", {
				Parent = Container,
				Size = UDim2.new(0, 20, 0, 120),
				Position = UDim2.new(0, 140, 0, 10),
				Image = "rbxassetid://16786657529", -- Rainbow gradient asset or create via UIGradient
				ScaleType = Enum.ScaleType.Crop, -- Fix just in case
				BackgroundColor3 = Color3.new(1,1,1)
			}, {
				Utility:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Utility:Create("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
						ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,255,0)),
						ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
						ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,0,255)),
						ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
					})
				})
			})
			
			local HueCursor = Utility:Create("Frame", {
				Parent = HueBar,
				Size = UDim2.new(1, 0, 0, 2),
				Position = UDim2.fromScale(0, ColorH),
				BackgroundColor3 = Color3.new(1,1,1),
				BorderSizePixel = 0
			})

			-- RGB Inputs (Modern addition)
			local RGBBox = Utility:Create("Frame", {
				Parent = Container,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 120, 0, 120),
				Position = UDim2.new(0, 170, 0, 10)
			})
			
			local RInput = Utility:Create("TextBox", { Parent = RGBBox, Text = "255", PlaceholderText = "R", Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Theme.Darker, TextColor3 = Color3.fromRGB(255,100,100), Font = Theme.Font, TextSize = 14 }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0,4)})})
			local GInput = Utility:Create("TextBox", { Parent = RGBBox, Text = "255", PlaceholderText = "G", Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,30), BackgroundColor3 = Theme.Darker, TextColor3 = Color3.fromRGB(100,255,100), Font = Theme.Font, TextSize = 14 }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0,4)})})
			local BInput = Utility:Create("TextBox", { Parent = RGBBox, Text = "255", PlaceholderText = "B", Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,60), BackgroundColor3 = Theme.Darker, TextColor3 = Color3.fromRGB(100,100,255), Font = Theme.Font, TextSize = 14 }, {Utility:Create("UICorner", {CornerRadius = UDim.new(0,4)})})
			local HexLabel = Utility:Create("TextLabel", { Parent = RGBBox, Text = "#FFFFFF", Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,95), BackgroundTransparency = 1, TextColor3 = Theme.TextDim, Font = Theme.Font, TextSize = 14 })

			--// Logic Functions //--
			local function UpdateColor()
				local NewColor = Color3.fromHSV(ColorH, ColorS, ColorV)
				CurrentColorPreview.BackgroundColor3 = NewColor
				SVMap.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				
				RInput.Text = math.floor(NewColor.R * 255)
				GInput.Text = math.floor(NewColor.G * 255)
				BInput.Text = math.floor(NewColor.B * 255)
				HexLabel.Text = "#" .. NewColor:ToHex():upper()
				
				Callback(NewColor)
			end

			-- Input Logic
			local function HandleInput(inputObj, isHue)
				local Mouse = UserInputService:GetMouseLocation()
				local ObjPos = inputObj.AbsolutePosition
				local ObjSize = inputObj.AbsoluteSize
				
				local X = math.clamp((Mouse.X - ObjPos.X) / ObjSize.X, 0, 1)
				local Y = math.clamp((Mouse.Y - ObjPos.Y - 36) / ObjSize.Y, 0, 1) -- -36 for GuiInset
				
				if isHue then
					ColorH = Y
					HueCursor.Position = UDim2.fromScale(0, Y)
				else
					ColorS = X
					ColorV = 1 - Y
					Cursor.Position = UDim2.fromScale(X, Y)
				end
				UpdateColor()
			end

			-- Event Binding
			SVMap.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local move, kill
					move = UserInputService.InputChanged:Connect(function(m)
						if m.UserInputType == Enum.UserInputType.MouseMovement then HandleInput(SVMap, false) end
					end)
					kill = UserInputService.InputEnded:Connect(function(m)
						if m.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() kill:Disconnect() end
					end)
					HandleInput(SVMap, false)
				end
			end)
			
			HueBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local move, kill
					move = UserInputService.InputChanged:Connect(function(m)
						if m.UserInputType == Enum.UserInputType.MouseMovement then HandleInput(HueBar, true) end
					end)
					kill = UserInputService.InputEnded:Connect(function(m)
						if m.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() kill:Disconnect() end
					end)
					HandleInput(HueBar, true)
				end
			end)

			Header.MouseButton1Click:Connect(function()
				IsOpen = not IsOpen
				Utility:Tween(PickerFrame, {0.3}, {Size = UDim2.new(1, 0, 0, IsOpen and 190 or 35)})
			end)

			UpdateColor() -- Init
			return {}
		end

		return Elements
	end

	return Window
end

return Library