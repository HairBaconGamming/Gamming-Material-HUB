--[[
	CYBER-HACK UI LIBRARY - TITANIUM EDITION (v7.0)
	Features: Resizable Window, Blur Toggle, Advanced Config, Stack Notifications
	Author: Refactored by Gemini
]]

local UIS, TS, RS, Players, CoreGui, Http, Lighting = game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("RunService"), game:GetService("Players"), game:GetService("CoreGui"), game:GetService("HttpService"), game:GetService("Lighting")
local LP, Mouse = Players.LocalPlayer, Players.LocalPlayer:GetMouse()

--// File System & Utility //--
local writefile = writefile or function(...) end
local readfile = readfile or function(...) end
local isfile = isfile or function(...) return false end
local makefolder = makefolder or function(...) end
local isfolder = isfolder or function(...) return false end

local Theme = {
	Bg = Color3.fromRGB(15, 15, 20),
	Dark = Color3.fromRGB(10, 10, 12),
	Accent = Color3.fromRGB(0, 255, 170),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(150, 150, 150),
	Font = Enum.Font.Code
}

local Lib = {
	Flags = {},
	Config = "Default",
	Folder = "CyberHub_v7",
	Gui = nil,
	Tabs = {},
	Settings = {Blur = false, Resizable = true}, -- Blur mặc định tắt
	ThemeObjs = {}
}

local function Create(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do inst[k] = v end
	if children then for _, c in pairs(children) do c.Parent = inst end end
	return inst
end

local function Tween(inst, time, props)
	TS:Create(inst, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(drag, obj)
	local dragging, startPos, startInput
	drag.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; startPos = obj.Position; startInput = input.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	drag.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then startInput = input.Position end
	end)
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - startInput
			Tween(obj, 0.05, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)})
		end
	end)
end

local function MakeResizable(handle, frame)
	local resizing, startSize, startInput
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true; startSize = frame.AbsoluteSize; startInput = input.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
			local delta = input.Position - startInput
			local newX = math.max(500, startSize.X + delta.X)
			local newY = math.max(350, startSize.Y + delta.Y)
			Tween(frame, 0.05, {Size = UDim2.fromOffset(newX, newY)})
		end
	end)
end

--// Logic Functions //--
function Lib:UpdateTheme(color)
	Theme.Accent = color
	for _, v in pairs(Lib.ThemeObjs) do pcall(function() Tween(v.Obj, 0.3, {[v.Prop] = color}) end) end
end

function Lib:ToggleBlur(bool)
	Lib.Settings.Blur = bool
	local blur = Lighting:FindFirstChild("CyberBlur") or Create("BlurEffect", {Name="CyberBlur", Size=0, Parent=Lighting})
	Tween(blur, 0.5, {Size = (bool and Lib.Gui.Enabled) and 18 or 0})
end

function Lib:Notify(title, text, duration)
	local area = Lib.Gui:FindFirstChild("NotifArea") or Create("Frame", {Name="NotifArea", Parent=Lib.Gui, BackgroundTransparency=1, Size=UDim2.new(0,300,1,-20), Position=UDim2.new(1,-310,0,10)}, {Create("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, VerticalAlignment=Enum.VerticalAlignment.Bottom, Padding=UDim.new(0,10)})})
	local frame = Create("Frame", {Parent=area, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=0.1}, {
		Create("UICorner",{CornerRadius=UDim.new(0,6)}), Create("UIStroke",{Color=Theme.Accent, Thickness=1, Transparency=0.5}),
		Create("TextLabel",{Text=title, Font=Theme.Font, TextColor3=Theme.Accent, TextSize=14, Size=UDim2.new(1,-10,0,20), Position=UDim2.new(0,10,0,5), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}),
		Create("TextLabel",{Text=text, Font=Theme.Font, TextColor3=Theme.Text, TextSize=12, Size=UDim2.new(1,-10,0,0), AutomaticSize=Enum.AutomaticSize.Y, Position=UDim2.new(0,10,0,25), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true})
	})
	Create("Frame", {Parent=frame, BackgroundTransparency=1, Size=UDim2.new(1,0,0,5), Position=UDim2.new(0,0,1,0)}) -- Padding bottom
	Tween(frame, 0.3, {Position = UDim2.new(0,0,0,0)})
	task.delay(duration or 3, function() if frame then Tween(frame, 0.3, {Position = UDim2.new(1,50,0,0)}); task.wait(0.3); frame:Destroy() end end)
end

function Lib:Save(name)
	if not isfolder(Lib.Folder) then makefolder(Lib.Folder) end
	local data = {Flags = Lib.Flags, Settings = Lib.Settings, Size = {X=Lib.Gui.MainFrame.AbsoluteSize.X, Y=Lib.Gui.MainFrame.AbsoluteSize.Y}, Pos = {X=Lib.Gui.MainFrame.AbsolutePosition.X, Y=Lib.Gui.MainFrame.AbsolutePosition.Y}}
	writefile(Lib.Folder.."/"..(name or Lib.Config)..".json", Http:JSONEncode(data))
	Lib:Notify("Config", "Saved configuration: "..(name or Lib.Config))
end

function Lib:Load(name)
	if isfile(Lib.Folder.."/"..(name or Lib.Config)..".json") then
		local data = Http:JSONDecode(readfile(Lib.Folder.."/"..(name or Lib.Config)..".json"))
		for k,v in pairs(data.Flags) do if Lib.Flags[k] then Lib.Flags[k].Set(v) end end
		if data.Settings then Lib:ToggleBlur(data.Settings.Blur) end
		if data.Size then Lib.Gui.MainFrame.Size = UDim2.fromOffset(data.Size.X, data.Size.Y) end
		if data.Pos then Lib.Gui.MainFrame.Position = UDim2.fromOffset(data.Pos.X, data.Pos.Y) end
		Lib:Notify("Config", "Loaded configuration: "..(name or Lib.Config))
	end
end

--// Main Window //--
function Lib:Init(config)
	local Title = config.Title or "TITANIUM HUB"
	Lib.Config = config.Config or "Default"
	
	if CoreGui:FindFirstChild("TitaniumUI") then CoreGui.TitaniumUI:Destroy() end
	Lib.Gui = Create("ScreenGui", {Name="TitaniumUI", Parent=CoreGui, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
	
	local Main = Create("Frame", {Name="MainFrame", Parent=Lib.Gui, BackgroundColor3=Theme.Bg, Size=UDim2.fromOffset(600, 400), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), ClipsDescendants=true}, {
		Create("UICorner",{CornerRadius=UDim.new(0,6)}), Create("UIStroke",{Color=Theme.Accent, Thickness=1.5, Transparency=0.5})
	})
	table.insert(Lib.ThemeObjs, {Obj=Main.UIStroke, Prop="Color"})
	
	local TopBar = Create("Frame", {Parent=Main, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,0,0,40)}, {
		Create("UICorner",{CornerRadius=UDim.new(0,6)}), Create("Frame",{BackgroundColor3=Theme.Dark, Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,1,-10), BorderSizePixel=0}),
		Create("TextLabel",{Text=" // "..string.upper(Title), Font=Theme.Font, TextSize=18, TextColor3=Theme.Accent, Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,15,0,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
	})
	table.insert(Lib.ThemeObjs, {Obj=TopBar.TextLabel, Prop="TextColor3"})
	MakeDraggable(TopBar, Main)

	-- Resizer
	local ResizeBtn = Create("ImageButton", {Parent=Main, BackgroundTransparency=1, Image="rbxassetid://6031094678", ImageColor3=Theme.SubText, Size=UDim2.fromOffset(15,15), Position=UDim2.new(1,-15,1,-15), ZIndex=10})
	MakeResizable(ResizeBtn, Main)

	local Sidebar = Create("ScrollingFrame", {Parent=Main, BackgroundTransparency=1, Size=UDim2.new(0,160,1,-45), Position=UDim2.new(0,10,0,45), ScrollBarThickness=0, AutomaticCanvasSize=Enum.AutomaticSize.Y})
	Create("UIListLayout", {Parent=Sidebar, Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
	
	local Content = Create("Frame", {Parent=Main, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,-185,1,-55), Position=UDim2.new(0,175,0,45)}, {Create("UICorner",{CornerRadius=UDim.new(0,4)}), Create("UIStroke",{Color=Color3.fromRGB(40,40,40), Thickness=1})})

	-- Profile
	local Profile = Create("Frame", {Parent=Sidebar, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,0,0,50), LayoutOrder=-1}, {
		Create("UICorner",{CornerRadius=UDim.new(0,6)}), Create("UIStroke",{Color=Theme.Accent, Thickness=1, Transparency=0.6}),
		Create("ImageLabel",{BackgroundTransparency=1, Image=Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), Size=UDim2.fromOffset(34,34), Position=UDim2.new(0,8,0.5,-17)}, {Create("UICorner",{CornerRadius=UDim.new(1,0)})}),
		Create("TextLabel",{Text=LP.Name, Font=Theme.Font, TextSize=12, TextColor3=Theme.Accent, Size=UDim2.new(1,-50,0,15), Position=UDim2.new(0,50,0,10), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left}),
		Create("TextLabel",{Text="User", Font=Theme.Font, TextSize=10, TextColor3=Theme.SubText, Size=UDim2.new(1,-50,0,15), Position=UDim2.new(0,50,0,25), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})
	})
	table.insert(Lib.ThemeObjs, {Obj=Profile.UIStroke, Prop="Color"}); table.insert(Lib.ThemeObjs, {Obj=Profile.TextLabel, Prop="TextColor3"})

	-- Toggle Key
	local Toggled = true
	UIS.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == (config.Key or Enum.KeyCode.RightControl) then
			Toggled = not Toggled; Lib.Gui.Enabled = Toggled
			Lib:ToggleBlur(Lib.Settings.Blur) -- Update blur state
		end
	end)

	local Window = {}
	local first = true

	function Window:Tab(name)
		local TabBtn = Create("TextButton", {Parent=Sidebar, Text=name, Font=Theme.Font, TextColor3=Theme.SubText, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,0,0,32), AutoButtonColor=false, TextSize=14}, {Create("UICorner",{CornerRadius=UDim.new(0,4)})})
		local TabFrame = Create("ScrollingFrame", {Name=name, Parent=Content, BackgroundTransparency=1, Size=UDim2.new(1,-10,1,-10), Position=UDim2.new(0,5,0,5), ScrollBarThickness=2, Visible=false, AutomaticCanvasSize=Enum.AutomaticSize.Y})
		Create("UIListLayout", {Parent=TabFrame, Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder})
		
		local function Show()
			for _,v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible=false end end
			for _,v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then Tween(v,0.2,{TextColor3=Theme.SubText, BackgroundColor3=Theme.Dark}) end end
			TabFrame.Visible=true
			Tween(TabBtn,0.2,{TextColor3=Theme.Accent, BackgroundColor3=Color3.fromRGB(25,25,30)})
		end
		TabBtn.MouseButton1Click:Connect(Show)
		if first then Show() first=false end
		
		local Tab = {}
		
		function Tab:Section(text)
			Create("Frame", {Parent=TabFrame, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25)}, {Create("TextLabel",{Text="- "..string.upper(text).." -", Font=Theme.Font, TextColor3=Theme.SubText, TextSize=12, Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, TextXAlignment=Enum.TextXAlignment.Left})})
		end

		function Tab:Toggle(props) -- {Title, Enabled, Flag, Callback, Key}
			local Current = props.Enabled or false
			local Frame = Create("TextButton", {Parent=TabFrame, BackgroundColor3=Theme.Bg, Size=UDim2.new(1,0,0,35), Text="", AutoButtonColor=false}, {
				Create("UICorner",{CornerRadius=UDim.new(0,4)}), Create("TextLabel",{Text=props.Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
			})
			local Box = Create("Frame", {Parent=Frame, Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-30,0.5,-10), BackgroundColor3=Theme.Dark}, {Create("UICorner",{CornerRadius=UDim.new(0,4)}), Create("UIStroke",{Color=Color3.fromRGB(60,60,60), Thickness=1})})
			local Mark = Create("Frame", {Parent=Box, Size=UDim2.fromScale(0,0), Position=UDim2.fromScale(0.5,0.5), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Theme.Accent}, {Create("UICorner",{CornerRadius=UDim.new(0,2)})})
			table.insert(Lib.ThemeObjs, {Obj=Mark, Prop="BackgroundColor3"})
			
			local KeyLabel = Create("TextButton", {Parent=Frame, Text=(props.Key and "["..props.Key.Name.."]" or ""), Font=Theme.Font, TextSize=10, TextColor3=Theme.SubText, BackgroundTransparency=1, Size=UDim2.new(0,50,0,20), Position=UDim2.new(1,-85,0.5,-10)})
			local Bind = props.Key

			local function Update(v)
				Current = v
				if props.Flag then Lib.Flags[props.Flag] = {Value=Current, Set=Update} end
				Tween(Mark, 0.2, {Size = Current and UDim2.fromScale(0.7,0.7) or UDim2.fromScale(0,0)})
				Tween(Box.UIStroke, 0.2, {Color = Current and Theme.Accent or Color3.fromRGB(60,60,60)})
				if props.Callback then props.Callback(Current) end
			end
			
			Frame.MouseButton1Click:Connect(function() Update(not Current) end)
			Frame.MouseButton2Click:Connect(function() -- Bind key
				KeyLabel.Text = "[...]"
				local c; c=UIS.InputBegan:Connect(function(i) 
					if i.UserInputType==Enum.UserInputType.Keyboard then 
						Bind=i.KeyCode; KeyLabel.Text="["..Bind.Name.."]"; c:Disconnect()
					elseif i.UserInputType==Enum.UserInputType.MouseButton2 then
						Bind=nil; KeyLabel.Text=""; c:Disconnect()
					end
				end)
			end)
			UIS.InputBegan:Connect(function(i,gp) if not gp and Bind and i.KeyCode==Bind then Update(not Current) end end)
			
			Update(Current)
		end

		function Tab:Slider(props) -- {Title, Min, Max, Default, Flag, Callback}
			local Current = props.Default or props.Min
			local Frame = Create("Frame", {Parent=TabFrame, BackgroundColor3=Theme.Bg, Size=UDim2.new(1,0,0,50)}, {
				Create("UICorner",{CornerRadius=UDim.new(0,4)}),
				Create("TextLabel",{Text=props.Title, Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,0,0,25), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left}),
				Create("TextLabel",{Name="Val", Text=tostring(Current), Font=Theme.Font, TextColor3=Theme.Accent, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-20,0,25), TextXAlignment=Enum.TextXAlignment.Right})
			})
			table.insert(Lib.ThemeObjs, {Obj=Frame.Val, Prop="TextColor3"})
			
			local Bar = Create("Frame", {Parent=Frame, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,-20,0,6), Position=UDim2.new(0,10,0,32)}, {Create("UICorner",{CornerRadius=UDim.new(0,1)})})
			local Fill = Create("Frame", {Parent=Bar, BackgroundColor3=Theme.Accent, Size=UDim2.fromScale(0,1)}, {Create("UICorner",{CornerRadius=UDim.new(0,1)})})
			table.insert(Lib.ThemeObjs, {Obj=Fill, Prop="BackgroundColor3"})
			
			local function Update(v)
				Current = math.clamp(v, props.Min, props.Max)
				if props.Flag then Lib.Flags[props.Flag] = {Value=Current, Set=Update} end
				Tween(Fill, 0.1, {Size = UDim2.fromScale((Current-props.Min)/(props.Max-props.Min), 1)})
				Frame.Val.Text = string.format("%.1f", Current)
				if props.Callback then props.Callback(Current) end
			end
			
			local Drag = Create("TextButton", {Parent=Bar, BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Text=""})
			Drag.MouseButton1Down:Connect(function()
				local m; m=UIS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then
					local s = math.clamp((i.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
					Update(props.Min + (props.Max-props.Min)*s)
				end end)
				local e; e=UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then m:Disconnect(); e:Disconnect() end end)
				local s = math.clamp((Mouse.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
				Update(props.Min + (props.Max-props.Min)*s)
			end)
			Update(Current)
		end

		function Tab:Dropdown(props) -- {Title, Table, Multi, Flag, Callback}
			local Current = props.Multi and {} or props.Table[1]
			local Open = false
			local Frame = Create("Frame", {Parent=TabFrame, BackgroundColor3=Theme.Bg, Size=UDim2.new(1,0,0,35), ClipsDescendants=true}, {Create("UICorner",{CornerRadius=UDim.new(0,4)}), Create("UIStroke",{Color=Color3.fromRGB(40,40,40), Thickness=1})})
			local Header = Create("TextButton", {Parent=Frame, BackgroundTransparency=1, Size=UDim2.new(1,0,0,35), Text="", AutoButtonColor=false})
			local Label = Create("TextLabel", {Parent=Header, Text=props.Title.." : "..(props.Multi and "Select..." or tostring(Current)), Font=Theme.Font, TextColor3=Theme.Text, TextSize=14, BackgroundTransparency=1, Size=UDim2.new(1,-30,1,0), Position=UDim2.new(0,10,0,0), TextXAlignment=Enum.TextXAlignment.Left})
			local Arrow = Create("ImageLabel", {Parent=Header, Image="rbxassetid://6031091004", BackgroundTransparency=1, Size=UDim2.fromOffset(20,20), Position=UDim2.new(1,-25,0.5,-10), ImageColor3=Theme.SubText})
			local Container = Create("ScrollingFrame", {Parent=Frame, BackgroundTransparency=1, Position=UDim2.new(0,0,0,35), Size=UDim2.new(1,0,1,-35), CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=2})
			Create("UIListLayout", {Parent=Container, SortOrder=Enum.SortOrder.LayoutOrder})
			
			local function Refresh()
				for _,v in pairs(Container:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
				for _, item in pairs(props.Table) do
					local Btn = Create("TextButton", {Parent=Container, Text="  "..tostring(item), Font=Theme.Font, TextColor3=Theme.SubText, BackgroundColor3=Theme.Dark, Size=UDim2.new(1,0,0,25), TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false})
					if props.Multi and table.find(Current, item) then Btn.TextColor3 = Theme.Accent end
					Btn.MouseButton1Click:Connect(function()
						if props.Multi then
							if table.find(Current, item) then table.remove(Current, table.find(Current, item)); Btn.TextColor3=Theme.SubText
							else table.insert(Current, item); Btn.TextColor3=Theme.Accent end
							Label.Text = props.Title.." : ["..#Current.."]"
							if props.Callback then props.Callback(Current) end
						else
							Current = item; Label.Text = props.Title.." : "..tostring(Current)
							Open = false; Tween(Frame,0.3,{Size=UDim2.new(1,0,0,35)}); Tween(Arrow,0.3,{Rotation=0})
							if props.Callback then props.Callback(Current) end
						end
					end)
				end
				Container.CanvasSize = UDim2.new(0,0,0,#props.Table*25)
			end
			Header.MouseButton1Click:Connect(function() Open=not Open; Tween(Frame,0.3,{Size=UDim2.new(1,0,0,Open and math.min(#props.Table*25+35,200) or 35)}); Tween(Arrow,0.3,{Rotation=Open and 180 or 0}) end)
			Refresh()
		end

		return Tab
	end

	--// Built-in Settings //--
	local SetTab = Window:Tab("Settings")
	SetTab:Toggle({Title="Enable Blur Effect", Enabled=Lib.Settings.Blur, Callback=function(v) Lib:ToggleBlur(v) end})
	SetTab:Section("Theme")
	SetTab:Slider({Title="Accent R", Min=0, Max=255, Default=0, Callback=function(v) Lib:UpdateTheme(Color3.fromRGB(v, Theme.Accent.G*255, Theme.Accent.B*255)) end})
	SetTab:Slider({Title="Accent G", Min=0, Max=255, Default=255, Callback=function(v) Lib:UpdateTheme(Color3.fromRGB(Theme.Accent.R*255, v, Theme.Accent.B*255)) end})
	SetTab:Slider({Title="Accent B", Min=0, Max=255, Default=170, Callback=function(v) Lib:UpdateTheme(Color3.fromRGB(Theme.Accent.R*255, Theme.Accent.G*255, v)) end})
	
	SetTab:Section("Config Manager")
	SetTab:Dropdown({Title="Select Config", Table=listfiles(Lib.Folder) or {}, Multi=false, Callback=function(v) Lib.Config = v:gsub(".json",""):gsub(Lib.Folder.."/","") end})
	SetTab:Toggle({Title="Save Config", Callback=function(v) if v then Lib:Save() end end})
	SetTab:Toggle({Title="Load Config", Callback=function(v) if v then Lib:Load() end end})
	
	return Window
end

return Lib