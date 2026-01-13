--[[
	CYBER-HACK UI LIBRARY - APEX EDITION (v6.0)
	Features: Global Search, Tooltips, Dynamic Theme Manager, Acrylic Blur
	Author: Refactored by Gemini
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

--// Utility & Compatibility //--
local Utility = {}
local writefile = writefile or function(...) end
local readfile = readfile or function(...) end
local isfile = isfile or function(...) return false end
local makefolder = makefolder or function(...) end
local isfolder = isfolder or function(...) return false end

--// Theme System //--
local Theme = {
	Background = Color3.fromRGB(15, 15, 20),
	Darker = Color3.fromRGB(10, 10, 12),
	Section = Color3.fromRGB(20, 20, 25),
	Accent = Color3.fromRGB(0, 255, 170), -- Default Cyber Green
	Text = Color3.fromRGB(240, 240, 240),
	TextDim = Color3.fromRGB(150, 150, 150),
	Font = Enum.Font.Code,
}

local Library = {
	Flags = {},
	ConfigFolder = "CyberHub_Configs",
	Gui = nil,
	ThemeObjects = {}, -- Store objects for dynamic theme update
	Tabs = {}, -- Store tabs for search
	CurrentConfig = "default"
}

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

function Utility:RegisterTheme(obj, property)
	table.insert(Library.ThemeObjects, {Object = obj, Property = property})
	obj[property] = Theme.Accent -- Apply current
end

function Library:UpdateTheme(newColor)
	Theme.Accent = newColor
	for _, data in pairs(Library.ThemeObjects) do
		if data.Object and data.Object.Parent then -- Check exists
			Utility:Tween(data.Object, {0.3}, {[data.Property] = newColor})
		end
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
			Utility:Tween(object, {0.05, Enum.EasingStyle.Linear}, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
		end
	end)
end

--// Tooltip System //--
local TooltipFrame = nil
function Library:AddTooltip(element, text)
	if not text then return end
	element.MouseEnter:Connect(function()
		if not TooltipFrame then
			TooltipFrame = Utility:Create("Frame", {
				Parent = Library.Gui, Name = "Tooltip", BackgroundColor3 = Theme.Darker, Size = UDim2.fromOffset(0,0), AutomaticSize=Enum.AutomaticSize.XY, ZIndex = 100
			}, {
				Utility:Create("UICorner", {CornerRadius=UDim.new(0,4)}),
				Utility:Create("UIStroke", {Color=Theme.Accent, Thickness=1}),
				Utility:Create("TextLabel", {Text=text, Font=Theme.Font, TextSize=12, TextColor3=Theme.Text, BackgroundTransparency=1, Size=UDim2.fromOffset(0,0), AutomaticSize=Enum.AutomaticSize.XY, Position=UDim2.fromOffset(5,5)})
			})
			-- Dynamic Color Register
			Utility:RegisterTheme(TooltipFrame.UIStroke, "Color")
		end
		TooltipFrame.Visible = true
		TooltipFrame.TextLabel.Text = text
		local mouse = UserInputService:GetMouseLocation()
		TooltipFrame.Position = UDim2.fromOffset(mouse.X + 15, mouse.Y + 15)
		
		-- Follow mouse
		local conn; conn = UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement and TooltipFrame.Visible then
				local m = UserInputService:GetMouseLocation()
				TooltipFrame.Position = UDim2.fromOffset(m.X + 15, m.Y + 15)
			else
				if conn then conn:Disconnect() end
			end
		end)
	end)
	element.MouseLeave:Connect(function()
		if TooltipFrame then TooltipFrame.Visible = false end
	end)
end

--// Main Logic //--
function Library:Load(config)
	local Title = config.Title or "SYSTEM"
	local Key = config.Key
	Library.ConfigFolder = config.Folder or "CyberHub_Configs"
	
	if CoreGui:FindFirstChild("CyberHub_UI") then CoreGui:FindFirstChild("CyberHub_UI"):Destroy() end
	Library.Gui = Utility:Create("ScreenGui", {Name="CyberHub_UI", Parent=CoreGui, ResetOnSpawn=false})
	
	-- Blur Effect (Optional)
	pcall(function()
		local blur = Instance.new("BlurEffect", game.Lighting)
		blur.Size = 0
		blur.Name = "CyberBlur"
		Utility:Tween(blur, {0.5}, {Size = 15})
	end)

	local MainFrame = Utility:Create("Frame", {Name="MainFrame", Parent=Library.Gui, BackgroundColor3=Theme.Background, Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), Size=UDim2.fromOffset(650, 450), ClipsDescendants=true}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,6)}), Utility:Create("UIStroke",{Color=Theme.Accent, Thickness=1.5, Transparency=0.5})})
	Utility:RegisterTheme(MainFrame.UIStroke, "Color")

	local TopBar = Utility:Create("Frame", {Parent=MainFrame, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,0,0,40)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,6)}), Utility:Create("TextLabel",{Text=" // "..string.upper(Title), Font=Theme.Font, TextColor3=Theme.Accent, TextSize=18, Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,15,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})})
	Utility:RegisterTheme(TopBar.TextLabel, "TextColor3")
	Utility:MakeDraggable(TopBar, MainFrame)
	
	-- Sidebar Container
	local Sidebar = Utility:Create("ScrollingFrame", {Parent=MainFrame, BackgroundTransparency=1, Size=UDim2.new(0,170,1,-50), Position=UDim2.new(0,10,0,45), ScrollBarThickness=0, CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y})
	Utility:Create("UIListLayout", {Parent=Sidebar, Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
	
	-- SEARCH BAR
	local SearchBox = Utility:Create("TextBox", {
		Parent = Sidebar, BackgroundColor3 = Theme.Darker, Size = UDim2.new(1, 0, 0, 30), Text = "", PlaceholderText = "Search Tab...", Font = Theme.Font, TextColor3 = Theme.Accent, TextSize = 14, LayoutOrder = -2
	}, {Utility:Create("UICorner", {CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke", {Color=Color3.fromRGB(60,60,60), Thickness=1})})
	Utility:RegisterTheme(SearchBox, "TextColor3")

	-- PROFILE CARD
	local Profile = Utility:Create("Frame", {Parent=Sidebar, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,0,0,50), LayoutOrder=-1}, {
		Utility:Create("UICorner",{CornerRadius=UDim.new(0,6)}), Utility:Create("UIStroke",{Color=Theme.Accent, Thickness=1, Transparency=0.7}),
		Utility:Create("ImageLabel",{BackgroundTransparency=1, Image=Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), Size=UDim2.fromOffset(36,36), Position=UDim2.new(0,7,0.5,-18)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(1,0)})}),
		Utility:Create("TextLabel",{Text=Players.LocalPlayer.Name, Font=Theme.Font, TextSize=12, TextColor3=Theme.Accent, Size=UDim2.new(1,-50,0,15), Position=UDim2.new(0,50,0,10), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}),
		Utility:Create("TextLabel",{Text="Admin", Font=Theme.Font, TextSize=10, TextColor3=Theme.TextDim, Size=UDim2.new(1,-50,0,15), Position=UDim2.new(0,50,0,25), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
	})
	Utility:RegisterTheme(Profile.UIStroke, "Color")
	Utility:RegisterTheme(Profile.TextLabel, "TextColor3")
	
	local ContentArea = Utility:Create("Frame", {Parent=MainFrame, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,-195,1,-55), Position=UDim2.new(0,185,0,45)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=Color3.fromRGB(40,40,40), Thickness=1})})

	-- Search Logic
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local text = SearchBox.Text:lower()
		for _, tabData in pairs(Library.Tabs) do
			if text == "" or string.find(tabData.Name:lower(), text) then
				tabData.Button.Visible = true
			else
				tabData.Button.Visible = false
			end
		end
	end)

	-- Toggle Key
	local toggled = true
	UserInputService.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == (typeof(Key)=="EnumItem" and Key or Enum.KeyCode[Key]) then
			toggled = not toggled; Library.Gui.Enabled = toggled
			if game.Lighting:FindFirstChild("CyberBlur") then game.Lighting.CyberBlur.Enabled = toggled end
		end
	end)

	local Window = {}
	local firstTab = true

	function Window:New(config)
		local TabTitle = config.Title or "Tab"
		local TabBtn = Utility:Create("TextButton", {Parent=Sidebar, Text=TabTitle, Font=Theme.Font, TextColor3=Theme.TextDim, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,0,0,32), AutoButtonColor=false, TextSize=14}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)})})
		local TabFrame = Utility:Create("ScrollingFrame", {Name=TabTitle, Parent=ContentArea, BackgroundTransparency=1, Size=UDim2.new(1,-10,1,-10), Position=UDim2.new(0,5,0,5), ScrollBarThickness=2, Visible=false, AutomaticCanvasSize=Enum.AutomaticSize.Y})
		Utility:Create("UIListLayout", {Parent=TabFrame, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder})
		
		table.insert(Library.Tabs, {Name = TabTitle, Button = TabBtn, Frame = TabFrame})

		local function Activate()
			for _,v in pairs(ContentArea:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
			for _,v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then Utility:Tween(v,{0.2},{TextColor3=Theme.TextDim, BackgroundColor3=Theme.Darker}) end end
			TabFrame.Visible=true
			Utility:Tween(TabBtn,{0.2},{TextColor3=Theme.Accent, BackgroundColor3=Color3.fromRGB(25,25,30)})
		end
		TabBtn.MouseButton1Click:Connect(Activate)
		if firstTab then Activate() firstTab = false end

		local Elements = {}
		
		function Elements:Section(Title)
			Utility:Create("Frame", {Parent=TabFrame, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25)}, {Utility:Create("TextLabel",{Text="- "..string.upper(Title).." -", Font=Theme.Font, TextColor3=Theme.TextDim, TextSize=12, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})})
		end
		
		function Elements:Label(props)
			Utility:Create("Frame", {Parent=TabFrame, Size=UDim2.new(1,0,0,20), BackgroundTransparency=1}, {Utility:Create("TextLabel",{Text=props.Text or "Info", Font=Theme.Font, TextColor3=props.Color or Theme.Text, TextSize=14, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true})})
		end

		function Elements:Toggle(props)
			local Title, Default, Callback, Flag, Desc = props.Title, props.Enabled or false, props.Callback or function() end, props.Flag, props.Description
			local Current, BindKey = Default, props.Key
			
			local Frame = Utility:Create("TextButton", {Parent=TabFrame, BackgroundColor3=Theme.Background, Size=UDim2.new(1,0,0,35), Text="", AutoButtonColor=false}, {
				Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("TextLabel",{Text=Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
			})
			Library:AddTooltip(Frame, Desc)

			local Checkbox = Utility:Create("Frame", {Parent=Frame, Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-30,0.5,-10), BackgroundColor3=Theme.Darker}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=Color3.fromRGB(60,60,60), Thickness=1})})
			local Checkmark = Utility:Create("Frame", {Parent=Checkbox, Size=UDim2.fromScale(0,0), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Theme.Accent}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,2)})})
			Utility:RegisterTheme(Checkmark, "BackgroundColor3")

			local KeyLabel = Utility:Create("TextButton", {Parent=Frame, Text=(BindKey and "["..BindKey.Name.."]" or "[NONE]"), Font=Theme.Font, TextSize=10, TextColor3=Theme.TextDim, BackgroundTransparency=1, Size=UDim2.new(0,50,0,20), Position=UDim2.new(1,-85,0.5,-10)})

			local function Update(val)
				Current = val; if Flag then Library.Flags[Flag] = {Value=Current, Set=Update} end
				Utility:Tween(Checkmark, {0.2}, {Size=Current and UDim2.fromScale(0.7,0.7) or UDim2.fromScale(0,0)})
				Utility:Tween(Checkbox.UIStroke, {0.2}, {Color=Current and Theme.Accent or Color3.fromRGB(60,60,60)})
				Callback(Current)
			end
			local function SetKey(key) BindKey = key; KeyLabel.Text = (BindKey and "["..BindKey.Name.."]" or "[NONE]"); KeyLabel.TextColor3 = Theme.TextDim end

			Frame.MouseButton1Click:Connect(function() Update(not Current) end)
			Frame.MouseButton2Click:Connect(function() KeyLabel.Text = "[...]"; KeyLabel.TextColor3 = Theme.Accent; local c; c=UserInputService.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Keyboard then SetKey(i.KeyCode); c:Disconnect() elseif i.UserInputType==Enum.UserInputType.MouseButton2 then SetKey(nil); c:Disconnect() end end) end)
			UserInputService.InputBegan:Connect(function(i,gp) if not gp and BindKey and i.KeyCode==BindKey then Update(not Current) end end)
			Update(Default)
			return {Set=Update}
		end
		
		function Elements:Slider(props)
			local Title, Min, Max, Default, Callback, Flag, Desc = props.Title, props.Min or 0, props.Max or 100, props.Default or 0, props.Callback or function() end, props.Flag, props.Description
			local Current = Default
			local Frame = Utility:Create("Frame", {Parent=TabFrame, BackgroundColor3=Theme.Background, Size=UDim2.new(1,0,0,50)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("TextLabel",{Text=Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left}), Utility:Create("TextLabel",{Name="Val", Text=tostring(Current), Font=Theme.Font, TextColor3=Theme.Accent, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-20,0,25), TextXAlignment=Enum.TextXAlignment.Right})})
			Utility:RegisterTheme(Frame.Val, "TextColor3")
			Library:AddTooltip(Frame, Desc)
			local Bar = Utility:Create("Frame", {Parent=Frame, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,-20,0,6), Position=UDim2.new(0,10,0,32)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,1)})})
			local Fill = Utility:Create("Frame", {Parent=Bar, BackgroundColor3=Theme.Accent, Size=UDim2.fromScale((Current-Min)/(Max-Min), 1)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,1)})})
			Utility:RegisterTheme(Fill, "BackgroundColor3")
			local Interact = Utility:Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Text=""})
			local function Update(val) Current=math.clamp(val,Min,Max); if Flag then Library.Flags[Flag]={Value=Current,Set=Update} end; Fill:TweenSize(UDim2.new((Current-Min)/(Max-Min),0,1,0),"Out","Quad",0.1,true); Frame.Val.Text=string.format("%.1f",Current); Callback(Current) end
			Interact.MouseButton1Down:Connect(function() local m; m=UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then Update(Min+(Max-Min)*(math.clamp(i.Position.X-Bar.AbsolutePosition.X,0,Bar.AbsoluteSize.X)/Bar.AbsoluteSize.X)) end end); local e; e=UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end); Update(Min+(Max-Min)*(math.clamp(UserInputService:GetMouseLocation().X-Bar.AbsolutePosition.X,0,Bar.AbsoluteSize.X)/Bar.AbsoluteSize.X)) end)
			return {Set=Update}
		end

		function Elements:Dropdown(props)
			local Title, Items, Callback, Flag, Multi, Desc = props.Title, props.Table or {}, props.Callback or function() end, props.Flag, props.Multi, props.Description
			local Current, Open = Multi and {} or Items[1], false
			local Frame = Utility:Create("Frame", {Parent=TabFrame, BackgroundColor3=Theme.Background, Size=UDim2.new(1,0,0,35), ClipsDescendants=true}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=Color3.fromRGB(40,40,40), Thickness=1})})
			Library:AddTooltip(Frame, Desc)
			local Header = Utility:Create("TextButton", {Parent=Frame, BackgroundTransparency=1, Size=UDim2.new(1,0,0,35), Text="", AutoButtonColor=false})
			local Label = Utility:Create("TextLabel", {Parent=Header, Text=Title.." : "..(Multi and "Select..." or tostring(Current)), Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-30,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
			local Arrow = Utility:Create("ImageLabel", {Parent=Header, Image="rbxassetid://6031091004", BackgroundTransparency=1, Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-25,0.5,-10), ImageColor3=Theme.TextDim})
			local Container = Utility:Create("ScrollingFrame", {Parent=Frame, BackgroundTransparency=1, Position=UDim2.new(0,0,0,35), Size=UDim2.new(1,0,1,-35), CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=2}); Utility:Create("UIListLayout", {Parent=Container, SortOrder=Enum.SortOrder.LayoutOrder})
			local function Refresh(newItems)
				Items = newItems; for _,v in pairs(Container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
				for _,item in pairs(Items) do
					local ItemBtn = Utility:Create("TextButton", {Parent=Container, Text="  "..tostring(item), Font=Theme.Font, TextColor3=Theme.TextDim, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,0,0,25), TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false})
					if Multi and table.find(Current, item) then ItemBtn.TextColor3 = Theme.Accent end
					ItemBtn.MouseButton1Click:Connect(function()
						if Multi then if table.find(Current,item) then table.remove(Current,table.find(Current,item)); ItemBtn.TextColor3=Theme.TextDim else table.insert(Current,item); ItemBtn.TextColor3=Theme.Accent end; Label.Text=Title.." : ["..#Current.."]"; Callback(Current) else Current=item; Label.Text=Title.." : "..tostring(Current); Open=false; Utility:Tween(Frame,{0.3},{Size=UDim2.new(1,0,0,35)}); Utility:Tween(Arrow,{0.3},{Rotation=0}); Callback(Current) end
					end)
				end
				Container.CanvasSize = UDim2.new(0,0,0,#Items*25)
			end
			Header.MouseButton1Click:Connect(function() Open=not Open; Utility:Tween(Frame,{0.3},{Size=UDim2.new(1,0,0,Open and math.min(#Items*25+35,200) or 35)}); Utility:Tween(Arrow,{0.3},{Rotation=Open and 180 or 0}) end)
			Refresh(Items); return {SetTable=Refresh}
		end
		
		function Elements:Button(props)
			local Title, Callback, Desc = props.Title, props.Callback or function() end, props.Description
			local Btn = Utility:Create("TextButton", {Parent=TabFrame, BackgroundColor3=Theme.Background, Size=UDim2.new(1,0,0,32), Text="", AutoButtonColor=false}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=Color3.fromRGB(40,40,40), Thickness=1}), Utility:Create("TextLabel",{Text=Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})})
			Library:AddTooltip(Btn, Desc)
			Btn.MouseButton1Click:Connect(function() Utility:Tween(Btn, {0.1}, {BackgroundColor3=Theme.Accent}); task.wait(0.1); Utility:Tween(Btn, {0.1}, {BackgroundColor3=Theme.Background}); Callback() end)
		end
		
		function Elements:Textbox(props)
			local Title, Callback, Desc = props.Title, props.Callback or function() end, props.Description
			local Frame = Utility:Create("Frame", {Parent=TabFrame, BackgroundColor3=Theme.Background, Size=UDim2.new(1,0,0,60)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("TextLabel",{Text=Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})})
			Library:AddTooltip(Frame, Desc)
			local Input = Utility:Create("TextBox", {Parent=Frame, BackgroundColor3=Theme.Darker, Size=UDim2.new(1,-20,0,25), Position=UDim2.new(0,10,0,28), Font=Theme.Font, Text="", PlaceholderText="Type here...", TextColor3=Theme.Accent, TextSize=14, ClearTextOnFocus=false}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=Color3.fromRGB(60,60,60), Thickness=1})})
			Utility:RegisterTheme(Input, "TextColor3")
			Input.FocusLost:Connect(function() Callback(Input.Text) end)
		end
		
		function Elements:ColorPicker(props)
			local Title, Default, Callback, Flag, Desc = props.Title, props.Default or Color3.new(1,1,1), props.Callback or function() end, props.Flag, props.Description
			local ColorH, ColorS, ColorV = Default:ToHSV(); local IsOpen, Current = false, Default
			local Frame = Utility:Create("Frame", {Parent=TabFrame, BackgroundColor3=Theme.Background, Size=UDim2.new(1,0,0,35), ClipsDescendants=true}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIStroke",{Color=Color3.fromRGB(40,40,40), Thickness=1})})
			Library:AddTooltip(Frame, Desc)
			local Header = Utility:Create("TextButton", {Parent=Frame, BackgroundTransparency=1, Size=UDim2.new(1,0,0,35), Text="", AutoButtonColor=false})
			Utility:Create("TextLabel", {Parent=Header, Text=Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-50,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
			local Preview = Utility:Create("Frame", {Parent=Header, BackgroundColor3=Current, Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-30,0.5,-10)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)})})
			local Container = Utility:Create("Frame", {Parent=Frame, BackgroundTransparency=1, Position=UDim2.new(0,0,0,35), Size=UDim2.new(1,0,0,130)})
			local SV = Utility:Create("ImageLabel", {Parent=Container, Size=UDim2.fromOffset(100,100), Position=UDim2.new(0,10,0,10), Image="rbxassetid://4155801252", BackgroundColor3=Color3.fromHSV(ColorH,1,1)}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)})})
			local Hue = Utility:Create("ImageLabel", {Parent=Container, Size=UDim2.new(0,20,0,100), Position=UDim2.new(0,120,0,10), Image="rbxassetid://16786657529", ScaleType=Enum.ScaleType.Crop}, {Utility:Create("UICorner",{CornerRadius=UDim.new(0,4)}), Utility:Create("UIGradient",{Rotation=90, Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)), ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)), ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}})})
			local function Update() Current=Color3.fromHSV(ColorH,ColorS,ColorV); Preview.BackgroundColor3=Current; SV.BackgroundColor3=Color3.fromHSV(ColorH,1,1); Callback(Current) end
			local function HandleInput(obj,isHue) local m=UserInputService:GetMouseLocation(); local p,s=obj.AbsolutePosition,obj.AbsoluteSize; local x,y=math.clamp((m.X-p.X)/s.X,0,1),math.clamp((m.Y-p.Y-36)/s.Y,0,1); if isHue then ColorH=y else ColorS=x; ColorV=1-y end; Update() end
			SV.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then local m=UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then HandleInput(SV,false) end end); local e=UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end); HandleInput(SV,false) end end)
			Hue.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then local m=UserInputService.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then HandleInput(Hue,true) end end); local e=UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end); HandleInput(Hue,true) end end)
			Header.MouseButton1Click:Connect(function() IsOpen=not IsOpen; Utility:Tween(Frame,{0.3},{Size=UDim2.new(1,0,0,IsOpen and 145 or 35)}) end)
			Update()
			return {}
		end

		return Elements
	end

	--// Settings Built-In //--
	local Settings = Window:New({Title = "Settings"})
	Settings:Section("Theme Manager")
	Settings:ColorPicker({
		Title = "Accent Color",
		Default = Theme.Accent,
		Callback = function(color)
			Library:UpdateTheme(color)
		end
	})
	
	Settings:Section("Config")
	Settings:Textbox({Title = "Config Name", Callback = function(t) Library.CurrentConfig = t end})
	Settings:Button({Title = "Save Config", Callback = function() if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end; writefile(Library.ConfigFolder.."/"..Library.CurrentConfig..".json", HttpService:JSONEncode(Library.Flags)) end})
	Settings:Button({Title = "Load Config", Callback = function() if isfile(Library.ConfigFolder.."/"..Library.CurrentConfig..".json") then local d=HttpService:JSONDecode(readfile(Library.ConfigFolder.."/"..Library.CurrentConfig..".json")); for k,v in pairs(d) do if Library.Flags[k] then Library.Flags[k].Set(v) end end end end})
	
	Settings:Section("UI")
	Settings:Keybind({Title = "Toggle Key", Key = Key, Callback = function(k) Key = k end})
	Settings:Button({Title = "Unload", Callback = function() Library.Gui:Destroy() end})

	return Window
end

return Library