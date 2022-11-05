local amogus = {}

function amogus:Load(Table)
	print([[
	
   _____                           _               __  __       _            _       _ 
  / ____|                         (_)             |  \/  |     | |          (_)     | |
 | |  __  __ _ _ __ ___  _ __ ___  _ _ __   __ _  | \  / | __ _| |_ ___ _ __ _  __ _| |
 | | |_ |/ _` | '_ ` _ \| '_ ` _ \| | '_ \ / _` | | |\/| |/ _` | __/ _ \ '__| |/ _` | |
 | |__| | (_| | | | | | | | | | | | | | | | (_| | | |  | | (_| | ||  __/ |  | | (_| | |
  \_____|\__,_|_|_|_|_|_|_| |_| |_|_|_| |_|\__, | |_|  |_|\__,_|\__\___|_|  |_|\__,_|_|
            |__   __| |           / _|      __/ |          (_)                         
               | |  | |__ __  __ | |_ ___  |___/  _   _ ___ _ _ __   __ _              
               | |  | '_ \\ \/ / |  _/ _ \| '__| | | | / __| | '_ \ / _` |             
               | |  | | | |>  <  | || (_) | |    | |_| \__ \ | | | | (_| |             
               |_|  |_| |_/_/\_\ |_| \___/|_|     \__,_|___/_|_| |_|\__, |             
                                                                     __/ |             
                                                                    |___/              
	]])
	local Titlem,Xsize,Ysize,SmothDrag,Close_Open_Key = Table.Title,Table.X,Table.Y,Table.SmothDrag,Table.Key
	local GUI_SERVICE
	if game:GetService("RunService"):IsStudio() then
		GUI_SERVICE = game.Players.LocalPlayer.PlayerGui
	else
		GUI_SERVICE = game.CoreGui
	end
	if GUI_SERVICE:FindFirstChild("Gamming_GUI_MATERIAL") then
		GUI_SERVICE:FindFirstChild("Gamming_GUI_MATERIAL"):Destroy()
	end
	local ScreenGui = Instance.new("ScreenGui")
	local SecondFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIGradient = Instance.new("UIGradient")
	local Frame = Instance.new("Frame")
	local Main = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UICorner_3 = Instance.new("UICorner")
	local TextLabel = Instance.new("TextLabel")
	local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
	local Frame3 = Instance.new("Frame")
	local Frame4 = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local ImageButton = Instance.new("ImageButton")
	local ImageButton2 = Instance.new("ImageButton")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local UIListLayout = Instance.new("UIListLayout")
	local TextService = game:GetService("TextService")
	
	ScreenGui.Parent = GUI_SERVICE
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Name = "Gamming_GUI_MATERIAL"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ResetOnSpawn = false

	if not Xsize then
		Xsize = 421
	end

	if not Ysize then
		Ysize = 330
	end

	SecondFrame.Name = "SecondFrame"
	SecondFrame.Parent = ScreenGui
	SecondFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SecondFrame.Position = UDim2.new(0.345534384, 0, 0.221848756, 0)
	SecondFrame.Size = UDim2.new(0, Xsize, 0, Ysize)
	SecondFrame.ClipsDescendants = true
	SecondFrame.BackgroundTransparency = 1

	UICorner.CornerRadius = UDim.new(0.0199999996, 0)
	UICorner.Parent = SecondFrame

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.22, Color3.fromRGB(221, 255, 0)), ColorSequenceKeypoint.new(0.41, Color3.fromRGB(25, 255, 0)), ColorSequenceKeypoint.new(0.62, Color3.fromRGB(2, 200, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(143, 30, 255))}
	UIGradient.Parent = SecondFrame

	local rs = game:GetService("RunService")
	local tween = game:GetService("TweenService")
	rs.Stepped:Connect(function()
		UIGradient.Rotation += 1.5
	end)

	UICorner_2.CornerRadius = UDim.new(0.0199999996, 0)
	UICorner_2.Parent = Main

	Main.Name = "Main"
	Main.Parent = SecondFrame
	Main.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	Main.Position = UDim2.new(0.002, 0,0.079, 0)
	Main.Size = UDim2.new(0.998, 0,0.918, 0)
	Main.ClipsDescendants = true

	Frame3.Name = ""
	Frame3.Parent = SecondFrame
	Frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame3.BackgroundTransparency = 1
	Frame3.Size = UDim2.new(0.998, 0,0.997, 0)
	Frame3.Position = UDim2.new(0.002, 0,0, 0)

	Frame.Name = ""
	Frame.Parent = SecondFrame
	Frame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	Frame.Position = UDim2.new(0.002, 0,0, 0)
	Frame.Size = UDim2.new(0.998, 0,0.101, 0)

	UICorner_3.CornerRadius = UDim.new(0.200000003, 0)
	UICorner_3.Parent = Frame

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.Position = UDim2.new(0.0120505234, 0, 0, 0)
	TextLabel.Size = UDim2.new(0.98554045, 0, 1, 0)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = Titlem
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextStrokeColor3 = Color3.fromRGB(65, 65, 65)
	TextLabel.TextWrapped = true

	UITextSizeConstraint.Parent = TextLabel
	UITextSizeConstraint.MaxTextSize = 14

	Frame4.Name = ""
	Frame4.Parent = SecondFrame
	Frame4.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
	Frame4.Position = UDim2.new(-0.515, 0,0.121, 0)
	Frame4.Size = UDim2.new(0.32, 0,0.864, 0)

	UICorner.Parent = Frame4

	UIListLayout.Parent = Frame4
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 8)

	ImageButton.Parent = Frame
	ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageButton.BackgroundTransparency = 1.000
	ImageButton.Size = UDim2.new(0.0855886862, 0, 1, 0)
	ImageButton.Position = UDim2.new(0,0,0,0)
	ImageButton.Image = "http://www.roblox.com/asset/?id=3340612851"

	ImageButton2.Parent = Frame
	ImageButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ImageButton2.BackgroundTransparency = 1.000
	ImageButton2.Size = UDim2.new(0.0855886862, 0, 1, 0)
	ImageButton2.Position = UDim2.new(0.907,0,0,0)
	ImageButton2.Image = "http://www.roblox.com/asset/?id=5450880072"

	UIAspectRatioConstraint.Parent = ImageButton

	if SmothDrag then
		spawn(function()
			local script = Instance.new("LocalScript",SecondFrame)
			local UserInputService = game:GetService("UserInputService")
			local runService = (game:GetService("RunService"));

			local gui = script.Parent

			local dragging
			local dragInput
			local dragStart
			local startPos

			local function Lerp(a, b, m)
				return a + (b - a) * m
			end;

			local lastMousePos
			local lastGoalPos
			local DRAG_SPEED = (8); -- // The speed of the UI darg.
			local function Update(dt)
				if not (startPos) then return end;
				if not (dragging) and (lastGoalPos) then
					gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
					return 
				end;

				local delta = (lastMousePos - UserInputService:GetMouseLocation())
				local xGoal = (startPos.X.Offset - delta.X);
				local yGoal = (startPos.Y.Offset - delta.Y);
				lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
				gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
			end;

			gui.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPos = gui.Position
					lastMousePos = UserInputService:GetMouseLocation()

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)

			gui.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					dragInput = input
				end
			end)

			runService.Heartbeat:Connect(Update)
		end)
	else
		spawn(function()
			local script = Instance.new("LocalScript",SecondFrame)
			local UserInputService = game:GetService("UserInputService")

			local gui = script.Parent

			local dragging
			local dragInput
			local dragStart
			local startPos

			local function update(input)
				local delta = input.Position - dragStart
				gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end

			gui.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					dragStart = input.Position
					startPos = gui.Position

					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end)

			gui.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					dragInput = input
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input == dragInput and dragging then
					update(input)
				end
			end)
		end)
	end

	local closed = false
	local closed2 = false
	ImageButton.MouseButton1Click:Connect(function()
		if not closed2 then
			closed = not closed
			if closed then
				tween:Create(Frame4,TweenInfo.new(0.5),{Position = UDim2.new(0.01, 0, 0.121, 0)}):Play()
				tween:Create(Frame3,TweenInfo.new(0.5),{BackgroundTransparency = 0.5}):Play()
			else
				tween:Create(Frame4,TweenInfo.new(0.5),{Position = UDim2.new(-0.515, 0, 0.121, 0)}):Play()
				tween:Create(Frame3,TweenInfo.new(0.5),{BackgroundTransparency = 1}):Play()
			end
		end
	end)

	local db = true
	ImageButton2.MouseButton1Click:Connect(function()
		if db then
			db = false
			closed2 = not closed2
			if closed2 then
				tween:Create(Main,TweenInfo.new(0.5),{Position = UDim2.new(0.012, 0,-1, 0)}):Play()
				tween:Create(ImageButton2,TweenInfo.new(0.5),{Rotation = 180}):Play()
				tween:Create(Frame4,TweenInfo.new(0.5),{Position = UDim2.new(-0.515, 0, 0.121, 0)}):Play()
				tween:Create(Frame3,TweenInfo.new(0.5),{BackgroundTransparency = 1}):Play()
			else
				tween:Create(Main,TweenInfo.new(0.5),{Position = UDim2.new(0.012, 0,0.1, 0)}):Play()
				tween:Create(ImageButton2,TweenInfo.new(0.5),{Rotation = 360}):Play()
				if closed then
					tween:Create(Frame4,TweenInfo.new(0.5),{Position = UDim2.new(0.01, 0, 0.121, 0)}):Play()
					tween:Create(Frame3,TweenInfo.new(0.5),{BackgroundTransparency = 0.5}):Play()
				end
				wait(0.5)
				ImageButton2.Rotation = 0
			end
			db = true
		end
	end)

	spawn(function()
		local UserInputService = game:GetService("UserInputService")
		UserInputService.InputBegan:Connect(function(Input)
			if type(Close_Open_Key) == "string" then
				if Input.KeyCode == Enum.KeyCode[Close_Open_Key] then
					ScreenGui.Enabled = not ScreenGui.Enabled
				end
			else
				if Input.KeyCode == Close_Open_Key then
					ScreenGui.Enabled = not ScreenGui.Enabled
				end
			end
		end)
	end)

	local module = {}

	local first = false

	function module:New(Table)
		local Titlea,Imagea,ImageIdea = Table.Title,Table.Image,Table.ImageId
		
		local Frame2 = Instance.new("ScrollingFrame")
		local UICorners = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local UIListLayout_2 = Instance.new("UIListLayout")

		local Frame_1 = Instance.new("Frame")
		local TextButtonae = Instance.new("TextButton")
		local ImageLabel = Instance.new("ImageLabel")
		local TextLabel = Instance.new("TextLabel")
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		
		Frame_1.BackgroundColor3 = Color3.new(1, 1, 1)
		Frame_1.BackgroundTransparency = 1
		Frame_1.Parent = Frame4
		Frame_1.Size = UDim2.new(1, 0, 0, 30)

		TextButtonae.BackgroundColor3 = Color3.new(1, 1, 1)
		TextButtonae.BackgroundTransparency = 1
		TextButtonae.Font = Enum.Font.GothamBold
		TextButtonae.Parent = Frame_1
		TextButtonae.Size = UDim2.new(1, 0, 1, 0)
		TextButtonae.Text = [[]]
		TextButtonae.TextColor3 = Color3.new(1, 1, 1)
		TextButtonae.TextScaled = true
		TextButtonae.TextSize = 14
		TextButtonae.TextWrapped = true
		
		if ImageIdea then
			ImageIdea = "http://www.roblox.com/asset/?id=".. ImageIdea
		end
		ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = (Imagea or ImageIdea)
		ImageLabel.Parent = Frame_1
		ImageLabel.Size = UDim2.new(0.21850659, 0, 1, 0)

		TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Parent = Frame_1
		TextLabel.Position = UDim2.new(0.218506545, 0, 0, 0)
		TextLabel.Size = UDim2.new(0.781493545, 0, 1, 0)
		TextLabel.Text = Titlea
		TextLabel.TextColor3 = Color3.new(1, 1, 1)
		TextLabel.TextScaled = true
		TextLabel.TextSize = 14
		TextLabel.TextWrapped = true

		UITextSizeConstraint.MaxTextSize = 14
		UITextSizeConstraint.Parent = TextLabel

		Frame2.Name = Titlea
		Frame2.Parent = Main
		Frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		Frame2.BackgroundTransparency = 0.200
		Frame2.ClipsDescendants = true
		Frame2.Position = UDim2.new(0.0170690101, 0, 0.022, 0)
		Frame2.Size = UDim2.new(0.968080759, 0, 0.955, 0)
		Frame2.BorderSizePixel = 0
		Frame2.CanvasSize = UDim2.new(0,0,0,0)
		Frame2.ScrollBarThickness = 2
		Frame2.Visible = false
		if not first then
			Frame2.Visible = true
			first = true
		end

		UICorners.CornerRadius = UDim.new(0.0199999996, 0)
		UICorners.Parent = Frame2

		UIListLayout.Parent = Frame2
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 8)

		UIListLayout_2.Parent = Frame2
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0.0299999993, 0)

		TextButtonae.MouseButton1Click:Connect(function()
			for i,v in pairs(Main:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			Frame2.Visible = true
		end)

		spawn(function()
			rs.Stepped:Connect(function()
				local all = 0
				for i,v in pairs(Frame2:GetChildren()) do
					if v:IsA("Frame") then
						all += v.Size.Y.Offset + 8
					end
				end
				Frame2.CanvasSize = UDim2.new(0,0,0,all-8)
			end)
		end)


		local module2 = {}
		function module2:Button(Table)
			local Title,Callback = Table.Title,Table.Callback

			local Button = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
			local TextButton = Instance.new("TextButton")

			Button.Name = "Button"
			Button.Parent = Frame2
			Button.BackgroundColor3 = Color3.fromRGB(85, 170, 127)
			Button.Size = UDim2.new(1.00000012, 0, 0, 40)
			Button.ClipsDescendants = true

			UICorner.CornerRadius = UDim.new(0.150000006, 0)
			UICorner.Parent = Button

			TextLabel.Parent = Button
			TextLabel.BackgroundColor3 = Color3.fromRGB(127, 255, 189)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.Position = UDim2.new(0.0176318008, 0, 0.20420073, 0)
			TextLabel.Size = UDim2.new(0.982368112, 0, 0.562427044, 0)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Text = Title
			TextLabel.TextColor3 = Color3.fromRGB(127, 255, 189)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint.Parent = TextLabel
			UITextSizeConstraint.MaxTextSize = 14

			TextButton.Parent = Button
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 1.000
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Font = Enum.Font.SourceSans
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.TextSize = 14.000

			local function tweenInRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						1,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							Size = UDim2.new(0, 2000, 0, 2000);
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
				end)
			end

			local function fadeOutRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						0.5,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							ImageTransparency = 1;
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
					wait(0.5 + 0.1)
					ripple:Destroy()
				end)
			end

			TextButton.MouseButton1Down:Connect(function()
				Callback()
				local Circle = Instance.new("ImageLabel")

				Circle.Name = "Circle"
				Circle.Parent = TextButton
				Circle.AnchorPoint = Vector2.new(0.5, 0.5)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.BackgroundTransparency = 1.000
				Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
				Circle.ZIndex = 10
				Circle.Image = "rbxassetid://266543268"
				Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
				Circle.ImageTransparency = 0.500

				tweenInRipple(Circle)
				TextButton.MouseButton1Up:Connect(function()
					fadeOutRipple(Circle)
				end)
				TextButton.MouseLeave:Connect(function()
					fadeOutRipple(Circle)
				end)
			end)

			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:GetTitle(Text)
				return TextLabel.Text
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end

			return module3
		end

		function module2:Toggle(Table)
			local Title,Callback,Enable = Table.Title,Table.Callback,Table.Enabled

			local Toggle = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
			local Frame = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Frame_2 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
			local TextButton = Instance.new("TextButton")

			Toggle.Name = "Toggle"
			Toggle.Parent = Frame2
			Toggle.BackgroundColor3 = Color3.fromRGB(0, 85, 127)
			Toggle.Size = UDim2.new(1.00000012, 0, 0, 40)
			Toggle.ClipsDescendants = true

			UICorner.CornerRadius = UDim.new(0.150000006, 0)
			UICorner.Parent = Toggle

			TextLabel.Parent = Toggle
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.Position = UDim2.new(0.0176318008, 0, 0.20420073, 0)
			TextLabel.Size = UDim2.new(0.86395818, 0, 0.562427044, 0)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Text = Title
			TextLabel.TextColor3 = Color3.fromRGB(0, 174, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint.Parent = TextLabel
			UITextSizeConstraint.MaxTextSize = 14

			Frame.Parent = Toggle
			Frame.BackgroundColor3 = Color3.fromRGB(0, 174, 255)
			Frame.BackgroundTransparency = 0.500
			Frame.Position = UDim2.new(0.858920634, 0, 0.350058407, 0)
			Frame.Size = UDim2.new(0.100000001, 0, 0.27071175, 0)

			UICorner_2.CornerRadius = UDim.new(1, 0)
			UICorner_2.Parent = Frame

			Frame_2.Parent = Frame
			Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame_2.Position = UDim2.new(0, 0, -0.446444064, 0)
			Frame_2.Size = UDim2.new(0.485630035, 0, 2.18534517, 0)

			UICorner_3.CornerRadius = UDim.new(1, 0)
			UICorner_3.Parent = Frame_2

			UIAspectRatioConstraint.Parent = Frame_2

			TextButton.Parent = Toggle
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 1.000
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Font = Enum.Font.SourceSans
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.TextSize = 14.000

			local function tweenInRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						1,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							Size = UDim2.new(0, 2000, 0, 2000);
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
				end)
			end

			local function fadeOutRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						0.5,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							ImageTransparency = 1;
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
					wait(0.5 + 0.1)
					ripple:Destroy()
				end)
			end

			local Enablesussy = Enable

			if Enablesussy == nil then
				Enablesussy = false
			end

			Callback(Enablesussy)

			if Enablesussy then
				tween:Create(
					Frame_2,
					TweenInfo.new(0.2),
					{Position = UDim2.new(0.5,0,-0.446444064,0)}
				):Play()
			else
				tween:Create(
					Frame_2,
					TweenInfo.new(0.2),
					{Position = UDim2.new(0,0,-0.446444064,0)}
				):Play()
			end

			TextButton.MouseButton1Down:Connect(function()
				Enablesussy = not Enablesussy
				Callback(Enablesussy)
				if Enablesussy then
					tween:Create(
						Frame_2,
						TweenInfo.new(0.2),
						{Position = UDim2.new(0.5,0,-0.446444064,0)}
					):Play()
				else
					tween:Create(
						Frame_2,
						TweenInfo.new(0.2),
						{Position = UDim2.new(0,0,-0.446444064,0)}
					):Play()
				end

				local Circle = Instance.new("ImageLabel")

				Circle.Name = "Circle"
				Circle.Parent = TextButton
				Circle.AnchorPoint = Vector2.new(0.5, 0.5)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.BackgroundTransparency = 1.000
				Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
				Circle.ZIndex = 10
				Circle.Image = "rbxassetid://266543268"
				Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
				Circle.ImageTransparency = 0.500

				tweenInRipple(Circle)
				TextButton.MouseButton1Up:Connect(function()
					fadeOutRipple(Circle)
				end)
				TextButton.MouseLeave:Connect(function()
					fadeOutRipple(Circle)
				end)
			end)

			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:GetTitle(Text)
				return TextLabel.Text
			end

			function module3:SetToggle(Bool)
				Enablesussy = Bool
				if Enablesussy then
					tween:Create(
						Frame_2,
						TweenInfo.new(0.2),
						{Position = UDim2.new(0.5,0,-0.446444064,0)}
					):Play()
				else
					tween:Create(
						Frame_2,
						TweenInfo.new(0.2),
						{Position = UDim2.new(0,0,-0.446444064,0)}
					):Play()
				end
			end

			function module3:GetToggle()
				return Enablesussy
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end

			return module3
		end

		function module2:Slide(Table)
			local Title = Table.Title
			local Callback,Min,Max,Default,Percent = Table.Callback,Table.Min,Table.Max,Table.Default,Table.Percent

			local Slide = Instance.new("Frame")
			local UICorner1 = Instance.new("UICorner")
			local TextLabel1 = Instance.new("TextLabel")
			local UITextSizeConstraint1 = Instance.new("UITextSizeConstraint")
			local Frame1 = Instance.new("TextButton")
			local UICorner1_2 = Instance.new("UICorner")
			local Frame_2 = Instance.new("Frame")
			local UICorner1_3 = Instance.new("UICorner")
			local Frame_3 = Instance.new("TextButton")
			local Frame_4 = Instance.new("Frame")
			local UICorner1_4 = Instance.new("UICorner")
			local UICorner1_5 = Instance.new("UICorner")
			local UIAspectRatioConstraint1 = Instance.new("UIAspectRatioConstraint")
			local UIAspectRatioConstraint1_2 = Instance.new("UIAspectRatioConstraint")
			local TextBox = Instance.new("TextBox")
			local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
			local UICorner1_6 = Instance.new("UICorner")

			Slide.Name = "Slide"
			Slide.Parent = Frame2
			Slide.BackgroundColor3 = Color3.fromRGB(85, 85, 127)
			Slide.ClipsDescendants = true
			Slide.Size = UDim2.new(1, 0, 0, 40)

			UICorner1.CornerRadius = UDim.new(0.150000006, 0)
			UICorner1.Parent = Slide

			TextLabel1.Parent = Slide
			TextLabel1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel1.BackgroundTransparency = 1.000
			TextLabel1.Position = UDim2.new(0.018, 0,0.1, 0)
			TextLabel1.Size = UDim2.new(0.861439526, 0, 0.554259062, 0)
			TextLabel1.Font = Enum.Font.GothamBold
			TextLabel1.Text = Title
			TextLabel1.TextColor3 = Color3.fromRGB(171, 171, 255)
			TextLabel1.TextScaled = true
			TextLabel1.TextSize = 14.000
			TextLabel1.TextWrapped = true
			TextLabel1.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint1.Parent = TextLabel1
			UITextSizeConstraint1.MaxTextSize = 14

			Frame1.Parent = Slide
			Frame1.BackgroundColor3 = Color3.fromRGB(171, 171, 255)
			Frame1.BackgroundTransparency = 0.500
			Frame1.Position = UDim2.new(0.0179999992, 0, 0.699999988, 0)
			Frame1.Size = UDim2.new(0.961000025, 0, 0.150000006, 0)
			Frame1.Text = ""
			Frame1.AutoButtonColor = false

			UICorner1_2.CornerRadius = UDim.new(1, 0)
			UICorner1_2.Parent = Frame1

			Frame_2.Parent = Frame1
			Frame_2.BackgroundColor3 = Color3.fromRGB(171, 171, 255)
			Frame_2.Size = UDim2.new(0, 0, 1, 0)
			Frame_2.BorderSizePixel = 0

			UICorner1_3.CornerRadius = UDim.new(1, 0)
			UICorner1_3.Parent = Frame_2

			Frame_4.Parent = Frame_2
			Frame_4.BackgroundColor3 = Color3.fromRGB(172, 144, 255)
			Frame_4.Position = UDim2.new(0.980000019, 0, -0.333, 0)
			Frame_4.Size = UDim2.new(0, 10, 0, 10)
			Frame_4.BackgroundTransparency = 0.5

			Frame_3.Parent = Frame_2
			Frame_3.BackgroundColor3 = Color3.fromRGB(171, 171, 255)
			Frame_3.Position = UDim2.new(0.980000019, 0, -0.333, 0)
			Frame_3.Size = UDim2.new(0, 10, 0, 10)
			Frame_3.Text = ""
			Frame_3.AutoButtonColor = false

			UICorner1_4.CornerRadius = UDim.new(1, 0)
			UICorner1_4.Parent = Frame_3

			UICorner1_5.CornerRadius = UDim.new(1, 0)
			UICorner1_5.Parent = Frame_4

			UIAspectRatioConstraint1.Parent = Frame_3
			UIAspectRatioConstraint1_2.Parent = Frame_4

			TextBox.BackgroundColor3 = Color3.new(0.670588, 0.670588, 1)
			TextBox.BackgroundTransparency = 0
			TextBox.Font = Enum.Font.GothamBold
			TextBox.Parent = Slide
			TextBox.PlaceholderColor3 = Color3.new(1, 1, 1)
			TextBox.PlaceholderText = [[Number]]
			TextBox.Position = UDim2.new(0.85, 0,0.175, 0)
			TextBox.Size = UDim2.new(0, 195, 0.379000008, 0)
			TextBox.Text = [[100]]
			TextBox.TextColor3 = Color3.fromRGB(85, 85, 127)
			TextBox.TextScaled = false
			TextBox.TextSize = 14
			TextBox.TextWrapped = true
			TextBox.ClearTextOnFocus = false

			UITextSizeConstraint_2.Parent = TextBox
			UITextSizeConstraint_2.MaxTextSize = 14
			UICorner1_6.CornerRadius = UDim.new(1, 0)
			UICorner1_6.Parent = TextBox

			Callback(Default)

			local UserInputService = game:GetService("UserInputService")
			local Dragging = false

			local function ayo()
				local Precenta = Default/Max
				Frame_2:TweenSize(UDim2.new(Precenta,0,1,0),nil,nil,0.05)
				return Precenta
			end

			local function yes()
				local MousePos = UserInputService:GetMouseLocation()+Vector2.new(0,36)
				local RelPos = MousePos-Frame1.AbsolutePosition
				local Precenta = math.clamp(RelPos.X/Frame1.AbsoluteSize.X,0,1)
				Frame_2:TweenSize(UDim2.new(Precenta,0,1,0),nil,nil,0.05)
				return Precenta
			end

			spawn(function()
				local Precenta = ayo()
				TextBox.Text = math.floor((Max*Precenta)*Percent)/Percent
			end)

			Frame1.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not Dragging then
					local Precenta = yes()
					TextBox.Text = math.floor(((Max-Min)*Precenta+Min)*Percent)/Percent
					Callback(math.floor(((Max-Min)*Precenta+Min)*Percent)/Percent)
					tween:Create(Frame_3,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(172, 144, 255)}):Play()
					tween:Create(Frame_2,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(172, 144, 255)}):Play()
					tween:Create(Frame_4,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{Size = UDim2.new(0,25,0,25),Position = UDim2.new(0.98,-7,-1.666,0)}):Play()
					Dragging = true
				end
			end)

			Frame_3.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and not Dragging then
					local Precenta = yes()
					TextBox.Text = math.floor(((Max-Min)*Precenta+Min)*Percent)/Percent
					Callback(math.floor(((Max-Min)*Precenta+Min)*Percent)/Percent)
					tween:Create(Frame_3,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(172, 144, 255)}):Play()
					tween:Create(Frame_2,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(172, 144, 255)}):Play()
					tween:Create(Frame_4,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{Size = UDim2.new(0,25,0,25),Position = UDim2.new(0.98,-7,-1.666,0)}):Play()
					Dragging = true
				end
			end)

			UserInputService.InputChanged:Connect(function()
				if Dragging then
					local Precenta = yes()
					TextBox.Text = math.floor(((Max-Min)*Precenta+Min)*Percent)/Percent
					Callback(math.floor(((Max-Min)*Precenta+Min)*Percent)/Percent)
					tween:Create(Frame_3,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(172, 144, 255)}):Play()
					tween:Create(Frame_2,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(172, 144, 255)}):Play()
					tween:Create(Frame_4,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{Size = UDim2.new(0,25,0,25),Position = UDim2.new(0.98,-7,-1.666,0)}):Play()
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
					tween:Create(Frame_3,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(170, 170, 255)}):Play()
					tween:Create(Frame_2,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{BackgroundColor3 = Color3.fromRGB(170, 170, 255)}):Play()
					tween:Create(Frame_4,TweenInfo.new(0.3,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{Size = UDim2.new(0,10,0,10),Position = UDim2.new(0.980000019, 0, -0.333, 0)}):Play()
				end
			end)
			
			TextBox.Focused:Connect(function()
				local TextSize = TextService:GetTextSize(TextBox.ContentText,TextBox.TextSize,TextBox.Font,TextBox.AbsoluteSize)
				tween:Create(TextBox,TweenInfo.new(0.05,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{Size = UDim2.new(0,math.max(TextSize.X+10,49),0.379,0)}):Play()
			end)
			
			TextBox.Changed:Connect(function(type)
				if type == "Text" then
					local TextSize = TextService:GetTextSize(TextBox.ContentText,TextBox.TextSize,TextBox.Font,TextBox.AbsoluteSize)
					tween:Create(TextBox,TweenInfo.new(0.05,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut,0,false,0),{Size = UDim2.new(0,math.max(TextSize.X+10,49),0.379,0)}):Play()
				end
			end)
			
			TextBox.FocusLost:Connect(function(Enter)
				if Enter and tonumber(TextBox.Text) then
					local a = false
					if tonumber(TextBox.Text) > Max then
						Default = Max
						TextBox.Text = Max
						ayo()
						a = true
					end
					if tonumber(TextBox.Text) < Min then
						Default = Min
						TextBox.Text = Min
						ayo()
						a = true
					end
					if a == false then
						Default = tonumber(TextBox.Text)
						local Precenta = ayo()
						TextBox.Text = math.floor((Max*Precenta)*Percent)/Percent
					end
				else
					local Precenta = ayo()
					TextBox.Text = math.floor((Max*Precenta)*Percent)/Percent
				end
			end)
			
			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:GetTitle(Text)
				return TextLabel.Text
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end

			function module3:SetMin(Value)
				Min = Value
			end

			function module3:SetMax(Value)
				Max = Value
			end

			function module3:SetDefault(Value)
				Default = Value
				ayo()
			end

			function module3:SetPercent(Value)
				Percent = Value
			end

			function module3:GetMin(Value)
				return Min
			end

			function module3:GetMax(Value)
				return Max
			end

			function module3:GetDefault(Value)
				return Default
			end

			return module3
		end

		function module2:Dropdown(Tables)
			local Title,Callback,Tablea,AutoTextChose = Tables.Title,Tables.Callback,Tables.Table,Tables.AutoTextChose

			local Dropdown = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Dropdown_2 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local TextButton = Instance.new("TextButton")
			local TextLabel = Instance.new("TextLabel")
			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
			local Frame = Instance.new("Frame")
			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
			local ImageButton = Instance.new("ImageLabel")
			local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
			local Frame_2 = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")

			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Frame2
			Dropdown.BackgroundColor3 = Color3.fromRGB(170, 170, 127)
			Dropdown.BackgroundTransparency = 1.000
			Dropdown.ClipsDescendants = true
			Dropdown.Size = UDim2.new(1, 0, 0, 40)

			UICorner.CornerRadius = UDim.new(0.150000006, 0)
			UICorner.Parent = Dropdown

			Dropdown_2.Name = "Dropdown"
			Dropdown_2.Parent = Dropdown
			Dropdown_2.BackgroundColor3 = Color3.fromRGB(255, 255, 191)
			Dropdown_2.ClipsDescendants = true
			Dropdown_2.Size = UDim2.new(1, 0, 0, 40)

			UICorner_2.CornerRadius = UDim.new(0.150000006, 0)
			UICorner_2.Parent = Dropdown_2

			TextButton.Parent = Dropdown_2
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 1.000
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Font = Enum.Font.SourceSans
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.TextSize = 14.000

			TextLabel.Parent = Dropdown_2
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 191)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.Position = UDim2.new(0.0176318008, 0, 0.20420073, 0)
			TextLabel.Size = UDim2.new(0.86395818, 0, 0.562427044, 0)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Text = Title
			TextLabel.TextColor3 = Color3.fromRGB(170, 170, 127)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint.Parent = TextLabel
			UITextSizeConstraint.MaxTextSize = 14

			Frame.Parent = Dropdown_2
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
			Frame.Position = UDim2.new(0.899999976, 0, 0, 0)
			Frame.Size = UDim2.new(1, 0, 1, 0)

			UIAspectRatioConstraint.Parent = Frame

			ImageButton.Parent = Frame
			ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageButton.BackgroundTransparency = 1.000
			ImageButton.Position = UDim2.new(0.25, 0, 0.25, 0)
			ImageButton.Rotation = 180.000
			ImageButton.Size = UDim2.new(0.5, 0, 0.5, 0)
			ImageButton.Image = "http://www.roblox.com/asset/?id=302248702"
			ImageButton.ImageColor3 = Color3.fromRGB(170, 170, 127)

			UIAspectRatioConstraint_2.Parent = ImageButton

			Frame_2.Parent = Dropdown
			Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame_2.BackgroundTransparency = 1.000
			Frame_2.Position = UDim2.new(0, 0, 0, 40)
			Frame_2.Size = UDim2.new(1, 0, 1, 0)

			UIListLayout.Parent = Frame_2
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 3)

			for i,v in pairs(Tablea) do
				local Frame_3 = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local TextLabel_2 = Instance.new("TextLabel")
				local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
				local TextButton_2 = Instance.new("TextButton")

				Frame_3.Parent = Frame_2
				Frame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 191)
				Frame_3.Position = UDim2.new(0, 0, 0, 40)
				Frame_3.Size = UDim2.new(1, 0, 0, 20)
				Frame_3.ClipsDescendants = true
				Frame_3.Name = i

				UICorner_3.CornerRadius = UDim.new(0, 4)
				UICorner_3.Parent = Frame_3

				TextLabel_2.Parent = Frame_3
				TextLabel_2.BackgroundColor3 = Color3.fromRGB(170, 170, 127)
				TextLabel_2.BackgroundTransparency = 1.000
				TextLabel_2.Position = UDim2.new(0.0176318008, 0, 0.20420073, 0)
				TextLabel_2.Size = UDim2.new(0.86395818, 0, 0.562427044, 0)
				TextLabel_2.Font = Enum.Font.GothamBold
				TextLabel_2.Text = v
				TextLabel_2.TextColor3 = Color3.fromRGB(170, 170, 127)
				TextLabel_2.TextScaled = true
				TextLabel_2.TextSize = 14.000
				TextLabel_2.TextWrapped = true
				TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

				UITextSizeConstraint_2.Parent = TextLabel_2
				UITextSizeConstraint_2.MaxTextSize = 14

				TextButton_2.Parent = Frame_3
				TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextButton_2.BackgroundTransparency = 1.000
				TextButton_2.Size = UDim2.new(1, 0, 1, 0)
				TextButton_2.Font = Enum.Font.SourceSans
				TextButton_2.Text = ""
				TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
				TextButton_2.TextSize = 14.000

				local function tweenInRipple(ripple)
					spawn(function()
						local TweenService = game:GetService("TweenService")
						local Part = ripple
						local Info = TweenInfo.new(
							1,
							Enum.EasingStyle.Linear,
							Enum.EasingDirection.InOut,
							0,
							false,
							0
						)
						local Goals = 
							{
								Size = UDim2.new(0, 2000, 0, 2000);
							}
						local Tween = TweenService:Create(Part, Info, Goals)
						Tween:Play()
					end)
				end

				local function fadeOutRipple(ripple)
					spawn(function()
						local TweenService = game:GetService("TweenService")
						local Part = ripple
						local Info = TweenInfo.new(
							0.5,
							Enum.EasingStyle.Linear,
							Enum.EasingDirection.InOut,
							0,
							false,
							0
						)
						local Goals = 
							{
								ImageTransparency = 1;
							}
						local Tween = TweenService:Create(Part, Info, Goals)
						Tween:Play()
						wait(0.5 + 0.1)
						ripple:Destroy()
					end)
				end

				TextButton_2.MouseButton1Click:Connect(function()
					Callback(v)
					if AutoTextChose then
						TextLabel.Text = Title..": ".. v
					end

					local Circle = Instance.new("ImageLabel")

					Circle.Name = "Circle"
					Circle.Parent = TextButton_2
					Circle.AnchorPoint = Vector2.new(0.5, 0.5)
					Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Circle.BackgroundTransparency = 1.000
					Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
					Circle.ZIndex = 10
					Circle.Image = "rbxassetid://266543268"
					Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
					Circle.ImageTransparency = 0.500

					tweenInRipple(Circle)
					TextButton_2.MouseButton1Up:Connect(function()
						fadeOutRipple(Circle)
					end)
					TextButton_2.MouseLeave:Connect(function()
						fadeOutRipple(Circle)
					end)
				end)
			end

			local function tweenInRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						1,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							Size = UDim2.new(0, 2000, 0, 2000);
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
				end)
			end

			local function fadeOutRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						0.5,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							ImageTransparency = 1;
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
					wait(0.5 + 0.1)
					ripple:Destroy()
				end)
			end

			local sisssisisi = (23*#Tablea)+40

			local opened = false
			local dbdd = true
			local Rotationaeaeaea = ImageButton.Rotation
			TextButton.MouseButton1Click:Connect(function()
				if dbdd then
					dbdd = false
					opened = not opened
					Rotationaeaeaea += 180
					if opened then
						tween:Create(ImageButton,TweenInfo.new(0.1),{Rotation = Rotationaeaeaea}):Play()
						tween:Create(Dropdown,TweenInfo.new(0.1),{Size = UDim2.new(1,0,0,sisssisisi)}):Play()
					else
						tween:Create(ImageButton,TweenInfo.new(0.1),{Rotation = Rotationaeaeaea}):Play()
						tween:Create(Dropdown,TweenInfo.new(0.1),{Size = UDim2.new(1,0,0,40)}):Play()
					end
					dbdd = true
				end
				local Circle = Instance.new("ImageLabel")

				Circle.Name = "Circle"
				Circle.Parent = TextButton
				Circle.AnchorPoint = Vector2.new(0.5, 0.5)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.BackgroundTransparency = 1.000
				Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
				Circle.ZIndex = 10
				Circle.Image = "rbxassetid://266543268"
				Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
				Circle.ImageTransparency = 0.500

				tweenInRipple(Circle)
				TextButton.MouseButton1Up:Connect(function()
					fadeOutRipple(Circle)
				end)
				TextButton.MouseLeave:Connect(function()
					fadeOutRipple(Circle)
				end)
			end)


			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:GetTitle(Text)
				return TextLabel.Text
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end

			function module3:SetTable(Tableass)
				TextLabel.Text = Title
				if opened then
					opened = false
					Rotationaeaeaea += 180
					tween:Create(ImageButton,TweenInfo.new(0.1),{Rotation = Rotationaeaeaea}):Play()
					tween:Create(Dropdown,TweenInfo.new(0.1),{Size = UDim2.new(1,0,0,40)}):Play()
				end
				for i,v in pairs(Frame_2:GetChildren()) do
					if v:IsA("Frame") then
						v:Destroy()
					end
				end
				for i,v in pairs(Tableass) do
					local Frame_3 = Instance.new("Frame")
					local UICorner_3 = Instance.new("UICorner")
					local TextLabel_2 = Instance.new("TextLabel")
					local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
					local TextButton_2 = Instance.new("TextButton")

					Frame_3.Parent = Frame_2
					Frame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 191)
					Frame_3.Position = UDim2.new(0, 0, 0, 40)
					Frame_3.Size = UDim2.new(1, 0, 0, 20)
					Frame_3.ClipsDescendants = true
					Frame_3.Name = i

					UICorner_3.CornerRadius = UDim.new(0, 4)
					UICorner_3.Parent = Frame_3

					TextLabel_2.Parent = Frame_3
					TextLabel_2.BackgroundColor3 = Color3.fromRGB(170, 170, 127)
					TextLabel_2.BackgroundTransparency = 1.000
					TextLabel_2.Position = UDim2.new(0.0176318008, 0, 0.20420073, 0)
					TextLabel_2.Size = UDim2.new(0.86395818, 0, 0.562427044, 0)
					TextLabel_2.Font = Enum.Font.GothamBold
					TextLabel_2.Text = v
					TextLabel_2.TextColor3 = Color3.fromRGB(170, 170, 127)
					TextLabel_2.TextScaled = true
					TextLabel_2.TextSize = 14.000
					TextLabel_2.TextWrapped = true
					TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

					UITextSizeConstraint_2.Parent = TextLabel_2
					UITextSizeConstraint_2.MaxTextSize = 14

					TextButton_2.Parent = Frame_3
					TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					TextButton_2.BackgroundTransparency = 1.000
					TextButton_2.Size = UDim2.new(1, 0, 1, 0)
					TextButton_2.Font = Enum.Font.SourceSans
					TextButton_2.Text = ""
					TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
					TextButton_2.TextSize = 14.000

					local function tweenInRipple(ripple)
						spawn(function()
							local TweenService = game:GetService("TweenService")
							local Part = ripple
							local Info = TweenInfo.new(
								1,
								Enum.EasingStyle.Linear,
								Enum.EasingDirection.InOut,
								0,
								false,
								0
							)
							local Goals = 
								{
									Size = UDim2.new(0, 2000, 0, 2000);
								}
							local Tween = TweenService:Create(Part, Info, Goals)
							Tween:Play()
						end)
					end

					local function fadeOutRipple(ripple)
						spawn(function()
							local TweenService = game:GetService("TweenService")
							local Part = ripple
							local Info = TweenInfo.new(
								0.5,
								Enum.EasingStyle.Linear,
								Enum.EasingDirection.InOut,
								0,
								false,
								0
							)
							local Goals = 
								{
									ImageTransparency = 1;
								}
							local Tween = TweenService:Create(Part, Info, Goals)
							Tween:Play()
							wait(0.5 + 0.1)
							ripple:Destroy()
						end)
					end

					TextButton_2.MouseButton1Click:Connect(function()
						Callback(v)
						if AutoTextChose then
							TextLabel.Text = Title..": ".. v
						end

						local Circle = Instance.new("ImageLabel")

						Circle.Name = "Circle"
						Circle.Parent = TextButton_2
						Circle.AnchorPoint = Vector2.new(0.5, 0.5)
						Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Circle.BackgroundTransparency = 1.000
						Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
						Circle.ZIndex = 10
						Circle.Image = "rbxassetid://266543268"
						Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
						Circle.ImageTransparency = 0.500

						tweenInRipple(Circle)
						TextButton_2.MouseButton1Up:Connect(function()
							fadeOutRipple(Circle)
						end)
						TextButton_2.MouseLeave:Connect(function()
							fadeOutRipple(Circle)
						end)
					end)
				end
				sisssisisi = (23*#Tableass)+40
				Tablea = Tableass
			end

			function module3:GetTable()
				return Tablea
			end

			function module3:AutoTextChose(Bool)
				AutoTextChose = Bool
				if not AutoTextChose then
					TextLabel.Text = Title
				end
			end

			return module3
		end

		function module2:Textbox(Tables)
			local Title,TextboxTitle,ClearTextOnFocus,Callback = Tables.Title,Tables.TextboxTitle,Tables.ClearTextOnFocus,Tables.Callback

			local Textbox = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
			local TextBox = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")
			local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")

			Textbox.Name = "Textbox"
			Textbox.Parent = Frame2
			Textbox.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
			Textbox.ClipsDescendants = false
			Textbox.Size = UDim2.new(1, 0, 0, 40)

			UICorner.CornerRadius = UDim.new(0.150000006, 0)
			UICorner.Parent = Textbox

			TextLabel.Parent = Textbox
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.Position = UDim2.new(0.0176318008, 0, 0, 0)
			TextLabel.Size = UDim2.new(0.861439526, 0, 0.554259062, 0)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Text = Title
			TextLabel.TextColor3 = Color3.fromRGB(170, 0, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint.Parent = TextLabel
			UITextSizeConstraint.MaxTextSize = 14

			TextBox.Parent = Textbox
			TextBox.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
			TextBox.Position = UDim2.new(0.0176318008, 0, 0.554258704, 0)
			TextBox.Size = UDim2.new(0.962217569, 0, 0, 13)
			TextBox.ClearTextOnFocus = ClearTextOnFocus
			TextBox.Font = Enum.Font.GothamBold
			TextBox.PlaceholderColor3 = Color3.fromRGB(120, 0, 194)
			TextBox.PlaceholderText = TextboxTitle
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(88, 0, 139)
			TextBox.TextSize = 14.000
			TextBox.TextXAlignment = Enum.TextXAlignment.Center
			TextBox.TextYAlignment = Enum.TextYAlignment.Top

			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = TextBox

			UITextSizeConstraint_2.Parent = TextBox
			UITextSizeConstraint_2.MaxTextSize = 12

			TextBox.FocusLost:Connect(function()
				Callback(TextBox.Text)
			end)

			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:GetTitle(Text)
				return TextLabel.Text
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end

			function module3:SetText(Text)
				TextBox.Text = Text
			end

			function module3:GetText()
				return TextBox.Text
			end

			function module3:SetPlaceholderText(Text)
				TextBox.PlaceholderText = Text
			end

			function module3:GetPlaceholderText(Text)
				return TextBox.PlaceholderText
			end

			function module3:ClearTextOnFocus(Bool)
				ClearTextOnFocus = Bool
				TextBox.ClearTextOnFocus = ClearTextOnFocus
			end

			return module3
		end

		function module2:ColorPicker(Tables)
			local Title,Callback,Default = Tables.Title,Tables.Callback,Tables.Default

			local ColorPicker = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Dropdown = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local TextButton = Instance.new("TextButton")
			local TextLabel = Instance.new("TextLabel")
			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
			local Frame = Instance.new("Frame")
			local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
			local ImageButton = Instance.new("ImageLabel")
			local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
			local Frame_2 = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")
			local Frame_3 = Instance.new("Frame")
			local Palette = Instance.new("ImageButton")
			local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
			local Crosshair = Instance.new("ImageButton")
			local Value = Instance.new("TextButton")
			local UIGradient = Instance.new("UIGradient")
			local bar = Instance.new("Frame")
			local Display = Instance.new("Frame")
			local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
			local UICorner_3 = Instance.new("UICorner")
			local R = Instance.new("TextBox")
			local TextLabel_2 = Instance.new("TextLabel")
			local UICorner_4 = Instance.new("UICorner")
			local Deco = Instance.new("Frame")
			local G = Instance.new("TextBox")
			local TextLabel_3 = Instance.new("TextLabel")
			local UICorner_5 = Instance.new("UICorner")
			local B = Instance.new("TextBox")
			local TextLabel_4 = Instance.new("TextLabel")
			local UICorner_6 = Instance.new("UICorner")
			local UICorner_7 = Instance.new("UICorner")

			ColorPicker.Name = "ColorPicker"
			ColorPicker.Parent = Frame2
			ColorPicker.BackgroundColor3 = Color3.fromRGB(85, 0, 0)
			ColorPicker.BackgroundTransparency = 1.000
			ColorPicker.ClipsDescendants = true
			ColorPicker.Size = UDim2.new(1, 0, 0, 40)

			UICorner.CornerRadius = UDim.new(0.150000006, 0)
			UICorner.Parent = ColorPicker

			Dropdown.Name = "Dropdown"
			Dropdown.Parent = ColorPicker
			Dropdown.BackgroundColor3 = Color3.fromRGB(85, 0, 0)
			Dropdown.ClipsDescendants = true
			Dropdown.Size = UDim2.new(1, 0, 0, 40)

			UICorner_2.CornerRadius = UDim.new(0.150000006, 0)
			UICorner_2.Parent = Dropdown

			TextButton.Parent = Dropdown
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 1.000
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.Font = Enum.Font.SourceSans
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.TextSize = 14.000

			TextLabel.Parent = Dropdown
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 191)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.Position = UDim2.new(0.0176318008, 0, 0.20420073, 0)
			TextLabel.Size = UDim2.new(0.86395818, 0, 0.562427044, 0)
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Text = Title
			TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint.Parent = TextLabel
			UITextSizeConstraint.MaxTextSize = 14

			Frame.Parent = Dropdown
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
			Frame.Position = UDim2.new(0.899999976, 0, 0, 0)
			Frame.Size = UDim2.new(1, 0, 1, 0)

			UIAspectRatioConstraint.Parent = Frame

			ImageButton.Parent = Frame
			ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ImageButton.BackgroundTransparency = 1.000
			ImageButton.Position = UDim2.new(0.25, 0, 0.25, 0)
			ImageButton.Rotation = 180.000
			ImageButton.Size = UDim2.new(0.5, 0, 0.5, 0)
			ImageButton.Image = "http://www.roblox.com/asset/?id=302248702"
			ImageButton.ImageColor3 = Color3.fromRGB(255, 0, 0)

			UIAspectRatioConstraint_2.Parent = ImageButton

			Frame_2.Parent = ColorPicker
			Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame_2.BackgroundTransparency = 1.000
			Frame_2.Position = UDim2.new(0, 0, 0, 40)
			Frame_2.Size = UDim2.new(1, 0, 1, 0)

			UIListLayout.Parent = Frame_2
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 3)

			Frame_3.Parent = Frame_2
			Frame_3.BackgroundColor3 = Color3.fromRGB(85, 0, 0)
			Frame_3.BorderSizePixel = 0
			Frame_3.Size = UDim2.new(1, 0, 0, 150)

			Palette.Name = "Palette"
			Palette.Parent = Frame_3
			Palette.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Palette.BackgroundTransparency = 1.000
			Palette.Position = UDim2.new(0.550000012, 0, 0, 0)
			Palette.Size = UDim2.new(0.5, 0, 1, 0)
			Palette.Image = "rbxassetid://2849458409"

			UIAspectRatioConstraint_3.Parent = Palette

			Crosshair.Name = "Crosshair"
			Crosshair.Parent = Palette
			Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
			Crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Crosshair.BackgroundTransparency = 1.000
			Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
			Crosshair.Size = UDim2.new(0, 16, 0, 16)
			Crosshair.Image = "http://www.roblox.com/asset/?id=9068520229"
			Crosshair.AutoButtonColor = false

			Value.Name = "Value"
			Value.Parent = Frame_3
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0.367273927, 0, 0.0375972986, 0)
			Value.Size = UDim2.new(0.100000001, 0, 0.899999976, 0)
			Value.Text = ""
			Value.AutoButtonColor = false

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(11, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
			UIGradient.Rotation = 84
			UIGradient.Parent = Value

			bar.Name = "bar"
			bar.Parent = Value
			bar.AnchorPoint = Vector2.new(0.5, 0)
			bar.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
			bar.BorderSizePixel = 0
			bar.Position = UDim2.new(0.5, 0, 0, 0)
			bar.Size = UDim2.new(1.10000002, 0, 0.0250000004, 0)

			Display.Name = "Display"
			Display.Parent = Frame_3
			Display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Display.BorderColor3 = Color3.fromRGB(85, 0, 0)
			Display.BorderSizePixel = 0
			Display.Position = UDim2.new(0.104627073, 0, 0.0320293419, 0)
			Display.Size = UDim2.new(0.270222217, 0, 0.430674702, 0)

			UIAspectRatioConstraint_4.Parent = Display

			UICorner_3.CornerRadius = UDim.new(1, 0)
			UICorner_3.Parent = Display

			R.Name = "R"
			R.Parent = Frame_3
			R.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			R.BorderSizePixel = 0
			R.Position = UDim2.new(0.0984988883, 0, 0.520637035, 0)
			R.Size = UDim2.new(0.176386878, 0, 0.107035622, 0)
			R.Font = Enum.Font.SourceSans
			R.Text = ""
			R.TextColor3 = Color3.fromRGB(85, 0, 0)
			R.TextScaled = true
			R.TextSize = 14.000
			R.TextWrapped = true

			TextLabel_2.Parent = R
			TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_2.BackgroundTransparency = 1.000
			TextLabel_2.Position = UDim2.new(-0.558425307, 0, 0, 0)
			TextLabel_2.Size = UDim2.new(0.558425188, 0, 1, 0)
			TextLabel_2.Font = Enum.Font.GothamBold
			TextLabel_2.Text = "R:"
			TextLabel_2.TextColor3 = Color3.fromRGB(255, 0, 0)
			TextLabel_2.TextScaled = true
			TextLabel_2.TextSize = 14.000
			TextLabel_2.TextWrapped = true

			UICorner_4.Parent = R

			Deco.Name = "Deco"
			Deco.Parent = Frame_3
			Deco.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Deco.BackgroundTransparency = 1.000
			Deco.Size = UDim2.new(1, 0, 1, 0)

			G.Name = "G"
			G.Parent = Frame_3
			G.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			G.BorderSizePixel = 0
			G.Position = UDim2.new(0.0984988883, 0, 0.657831907, 0)
			G.Size = UDim2.new(0.176386878, 0, 0.107035622, 0)
			G.Font = Enum.Font.SourceSans
			G.Text = ""
			G.TextColor3 = Color3.fromRGB(85, 0, 0)
			G.TextScaled = true
			G.TextSize = 14.000
			G.TextWrapped = true

			TextLabel_3.Parent = G
			TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_3.BackgroundTransparency = 1.000
			TextLabel_3.Position = UDim2.new(-0.558425307, 0, 0, 0)
			TextLabel_3.Size = UDim2.new(0.558425188, 0, 1, 0)
			TextLabel_3.Font = Enum.Font.GothamBold
			TextLabel_3.Text = "G:"
			TextLabel_3.TextColor3 = Color3.fromRGB(255, 0, 0)
			TextLabel_3.TextScaled = true
			TextLabel_3.TextSize = 14.000
			TextLabel_3.TextWrapped = true

			UICorner_5.Parent = G

			B.Name = "B"
			B.Parent = Frame_3
			B.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			B.BorderSizePixel = 0
			B.Position = UDim2.new(0.0984988883, 0, 0.802062392, 0)
			B.Size = UDim2.new(0.176386878, 0, 0.107035622, 0)
			B.Font = Enum.Font.SourceSans
			B.Text = ""
			B.TextColor3 = Color3.fromRGB(85, 0, 0)
			B.TextScaled = true
			B.TextSize = 14.000
			B.TextWrapped = true

			TextLabel_4.Parent = B
			TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_4.BackgroundTransparency = 1.000
			TextLabel_4.Position = UDim2.new(-0.558425307, 0, 0, 0)
			TextLabel_4.Size = UDim2.new(0.558425188, 0, 1, 0)
			TextLabel_4.Font = Enum.Font.GothamBold
			TextLabel_4.Text = "B:"
			TextLabel_4.TextColor3 = Color3.fromRGB(255, 0, 0)
			TextLabel_4.TextScaled = true
			TextLabel_4.TextSize = 14.000
			TextLabel_4.TextWrapped = true

			UICorner_6.Parent = B

			UICorner_7.Parent = Frame_3

			local function tweenInRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						1,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							Size = UDim2.new(0, 2000, 0, 2000);
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
				end)
			end

			local function fadeOutRipple(ripple)
				spawn(function()
					local TweenService = game:GetService("TweenService")
					local Part = ripple
					local Info = TweenInfo.new(
						0.5,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.InOut,
						0,
						false,
						0
					)
					local Goals = 
						{
							ImageTransparency = 1;
						}
					local Tween = TweenService:Create(Part, Info, Goals)
					Tween:Play()
					wait(0.5 + 0.1)
					ripple:Destroy()
				end)
			end
			
			local opened = false
			local dbdd = true
			local Rotationaeaeaea = ImageButton.Rotation
			TextButton.MouseButton1Click:Connect(function()
				if dbdd then
					dbdd = false
					opened = not opened
					Rotationaeaeaea += 180
					if opened then
						tween:Create(ImageButton,TweenInfo.new(0.1),{Rotation = Rotationaeaeaea}):Play()
						tween:Create(ColorPicker,TweenInfo.new(0.1),{Size = UDim2.new(1,0,0,40+Frame_3.Size.Y.Offset)}):Play()
					else
						tween:Create(ImageButton,TweenInfo.new(0.1),{Rotation = Rotationaeaeaea}):Play()
						tween:Create(ColorPicker,TweenInfo.new(0.1),{Size = UDim2.new(1,0,0,40)}):Play()
					end
					dbdd = true
				end
				local Circle = Instance.new("ImageLabel")

				Circle.Name = "Circle"
				Circle.Parent = TextButton
				Circle.AnchorPoint = Vector2.new(0.5, 0.5)
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.BackgroundTransparency = 1.000
				Circle.Position = UDim2.new(0.5, 0, 0.5, 0)
				Circle.ZIndex = 10
				Circle.Image = "rbxassetid://266543268"
				Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
				Circle.ImageTransparency = 0.500

				tweenInRipple(Circle)
				TextButton.MouseButton1Up:Connect(function()
					fadeOutRipple(Circle)
				end)
				TextButton.MouseLeave:Connect(function()
					fadeOutRipple(Circle)
				end)
			end)

			local currentcolor = Default
			local mouse = game.Players.LocalPlayer:GetMouse()
			local palette = Palette
			local display = Display
			local crosshair = palette.Crosshair
			local UIS = game:GetService("UserInputService")
			local Value = UIGradient

			local bar = Value.Parent.bar
			local eeee = Value.Parent
			local barval = 1

			local labels = {}
			labels.R = R
			labels.G = G
			labels.B = B

			local function converttofull(ang)
				local ang = math.deg(ang)
				local min = -180
				local dist = math.abs(ang-min)
				return 360-dist
			end

			local function isonpalette()
				local p = Vector2.new(mouse.X,mouse.Y)
				local onp = p-palette.AbsolutePosition
				local monp = onp-(palette.AbsoluteSize/2)

				local mid = palette.AbsolutePosition+(palette.AbsoluteSize/2)
				local distFromMid = (mid-p).Magnitude

				if distFromMid>palette.AbsoluteSize.X/2 then 
					return false
				else
					return true
				end
			end
			local function isonbar()
				local p = Vector2.new(mouse.X,mouse.Y)
				if p.X>bar.AbsolutePosition.X and p.X<bar.AbsolutePosition.X+bar.AbsoluteSize.X and p.Y>bar.AbsolutePosition.Y and p.Y<bar.AbsolutePosition.Y+bar.AbsoluteSize.Y then
					return true
				else
					return false
				end
			end
			local function isoneee()
				local p = Vector2.new(mouse.X,mouse.Y)
				if p.X>eeee.AbsolutePosition.X and p.X<eeee.AbsolutePosition.X+eeee.AbsoluteSize.X and p.Y>eeee.AbsolutePosition.Y and p.Y<eeee.AbsolutePosition.Y+eeee.AbsoluteSize.Y then
					return true
				else
					return false
				end
			end
			local function updatel()
				for i,v in pairs(labels)do
					v.Text = tostring(math.floor(currentcolor[i]*255))
				end
			end
			local function updateCrosshair()
				local hue,s,v = Color3.toHSV(currentcolor)
				local plane = CFrame.new(Vector3.new(0,0,0))*CFrame.Angles(0,math.rad((180+(hue*360))%360),0)*CFrame.new(0,0,-s/2)
				local p = Vector2.new(plane.X,plane.Z)
				crosshair.Position = UDim2.new(0.5-p.Y,0,0.5+p.X,0)

			end
			local function update()
				local p = Vector2.new(mouse.X,mouse.Y)
				local onp = p-palette.AbsolutePosition
				local monp = onp-(palette.AbsoluteSize/2)

				local mid = palette.AbsolutePosition+(palette.AbsoluteSize/2)
				local distFromMid = (mid-p).Magnitude

				if distFromMid>palette.AbsoluteSize.X/2 then return end -- Mouse outside the palette reach

				local value = barval
				local saturation = distFromMid/(palette.AbsoluteSize.X/2)
				local hue = converttofull(math.atan2(monp.Y,monp.X))/360

				display.BackgroundColor3 = Color3.fromHSV(hue,saturation,value)
				currentcolor = Color3.fromHSV(hue,saturation,value)
				Value.Color = ColorSequence.new(Color3.fromHSV(hue,saturation,1),Color3.new(0,0,0))
				updateCrosshair()
			end
			spawn(function()

				for i,v in pairs(labels)do
					local otherlabels = {unpack(labels)}
					otherlabels[i] = nil
					v.FocusLost:Connect(function(enter)
						if enter then else updatel() return end
						local c = tonumber(v.Text)
						c = math.clamp(c,0,255)
						v.Text = tostring(c)
						currentcolor = Color3.fromRGB(tonumber(labels.R.Text),tonumber(labels.G.Text),tonumber(labels.B.Text))
						local h,s,v = Color3.toHSV(currentcolor)
						barval = v
						bar.Position = UDim2.new(0.5,0,1-math.clamp(barval,0,1),0)
						Value.Color = ColorSequence.new(Color3.fromHSV(h,s,1),Color3.new(0,0,0))
						display.BackgroundColor3 = currentcolor
						updateCrosshair()
					end)
				end

				UIS.InputBegan:Connect(function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and opened then
						if isonpalette() then
							local v = Instance.new("BindableEvent")

							local b = mouse.Move:Connect(function()
								Callback(currentcolor)
								v:Fire()
							end)
							local b2 = UIS.InputEnded:Connect(function(i)
								if i.UserInputType == Enum.UserInputType.MouseButton1 then
									Callback(currentcolor)
									v:Fire()
								end
							end)
							repeat update() updatel() v.Event:Wait() until not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
							b:Disconnect()
							b2:Disconnect()
						elseif isoneee() then
							while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
								if isoneee() then
									local mpos = mouse.Y-Value.Parent.AbsolutePosition.Y
									local y = mpos/Value.Parent.AbsoluteSize.Y
									y = math.clamp(y,0,1)
									bar.Position = UDim2.new(0.5,0,y,0)
									barval = 1-y
									local h,s,v = Color3.toHSV(currentcolor)
									currentcolor = Color3.fromHSV(h,s,barval)
									display.BackgroundColor3 = currentcolor
									Callback(currentcolor)
									updatel()
								end
								game:GetService("RunService").RenderStepped:Wait()
							end
						end
					end
				end)

				updateCrosshair(currentcolor)
				updatel()
			end)

			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end

			function module3:GetColor()
				return currentcolor
			end

			function module3:GetTitle()
				return TextLabel.Text
			end

			function module3:SetColor(Color)
				currentcolor = Color
				local h,s,v = Color3.toHSV(currentcolor)
				barval = v
				bar.Position = UDim2.new(0.5,0,1-math.clamp(barval,0,1),0)
				Value.Color = ColorSequence.new(Color3.fromHSV(h,s,1),Color3.new(0,0,0))
				display.BackgroundColor3 = currentcolor
				updateCrosshair()
				updatel()
				Callback(currentcolor)
			end

			return module3
		end
		
		function module2:KeyBox(Tables)
			local Title,Callback,Key = Tables.Title,Tables.Callback,Tables.Key
			
			local KeyBox = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
			local Frame = Instance.new("Frame")
			local TextButton = Instance.new("TextButton")
			local UICorner_1 = Instance.new("UICorner")
			local UITextSizeConstraint_1 = Instance.new("UITextSizeConstraint")
			local UICorner_2 = Instance.new("UICorner")

			KeyBox.BackgroundColor3 = Color3.new(0.760784, 0.760784, 0.760784)
			KeyBox.ClipsDescendants = true
			KeyBox.Name = [[KeyBox]]
			KeyBox.Parent = Frame2
			KeyBox.Size = UDim2.new(1, 0, 0, 40)

			UICorner.CornerRadius = UDim.new(0.150000006, 0)
			UICorner.Parent = KeyBox
			
			TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.Parent = KeyBox
			TextLabel.Position = UDim2.new(0.0176317804, 0, 0, 0)
			TextLabel.Size = UDim2.new(0.861439526, 0, 0.999999881, 0)
			TextLabel.Text = Title
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			UITextSizeConstraint.MaxTextSize = 14
			UITextSizeConstraint.Parent = TextLabel

			Frame.BackgroundColor3 = Color3.new(1, 1, 1)
			Frame.Parent = KeyBox
			Frame.Position = UDim2.new(0.894914389, 0, 0.100000001, 0)
			Frame.Size = UDim2.new(0.0887071863, 0, 0.800000012, 0)
			Frame.BackgroundTransparency = 1

			TextButton.BackgroundColor3 = Color3.new(0.603922, 0.603922, 0.603922)
			TextButton.Font = Enum.Font.GothamBlack
			TextButton.Parent = Frame
			TextButton.Position = UDim2.new(0.05, 0, 0.05, 0)
			TextButton.Size = UDim2.new(0.9, 0, 0.9, 0)
			TextButton.TextColor3 = Color3.new(0, 0, 0)
			TextButton.TextScaled = true
			TextButton.TextSize = 14
			TextButton.TextWrapped = true
			TextButton.Text = Key.Name
			TextButton.TextColor3 = Color3.new(1, 1, 1)

			UICorner_1.CornerRadius = UDim.new(1, 0)
			UICorner_1.Parent = TextButton

			UITextSizeConstraint_1.MaxTextSize = 24
			UITextSizeConstraint_1.Parent = TextButton

			UICorner_2.CornerRadius = UDim.new(1, 0)
			UICorner_2.Parent = Frame
			
			local connect 
			local click = false
			TextButton.MouseButton1Click:Connect(function()
				if click == false then
					Frame.BackgroundTransparency = 0
					connect = game:GetService("UserInputService").InputBegan:Connect(function(Input)
						if Input.KeyCode ~= Enum.KeyCode.Unknown then
							Key = Input.KeyCode
							Frame.BackgroundTransparency = 1
							TextButton.BorderSizePixel = 0
							TextButton.Text = Key.Name
							click = false
							connect:Disconnect()
							Callback(Key)
						end
					end)
					click = true
				else
					if connect then
						connect:Disconnect()
					end
					Frame.BackgroundTransparency = 1
					click = false
				end
			end)
			
			local module3 = {}

			function module3:SetTitle(Text)
				TextLabel.Text = Text
			end

			function module3:GetTitle(Text)
				return TextLabel.Text
			end

			function module3:SetCallback(functionae)
				Callback = functionae
			end
			
			function module3:SetKey(Keyae)
				Key = Keyae
			end
			
			function module3:GetKey(Keyae)
				return Key
			end
		end
		return module2
	end
	return module
end

return amogus
