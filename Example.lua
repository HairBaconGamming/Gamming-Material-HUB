local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/HairBaconGamming/Gamming-Material-HUB/main/Main.lua"))()

local Main = Material.Load({
	Title = "Gamming Hub",
	SmothDrag = false,
	Key = "RightControl" or Enum.KeyCode.RightControl,
})

local Temp = Main.New({
	Title = "Home"
})

local Button = Temp.Button({
	Title = "Player Name",
	Callback = function()
		print(game.Players.LocalPlayer.Name)
	end,
})

local Toggle = Temp.Toggle({
	Title = "Bool",
	Callback = function(Value)
		print(Value)
	end,
	Enabled = false
})

local Slide = Temp.Slide({
	Title = "Value",
	Callback = function(Value)
		print(Value)
	end,
	Min = 1,
	Max = 100,
	Default = 1,
	Percent = 10, -- example: 23 >> 23.2
})

local Dropdown = Temp.Dropdown({
	Title = "Numbers",
	Callback = function(Value)
		print(Value)
	end,
	Table = {"1","2","3"},
	AutoTextChose = true, -- example: 'numbers:1' >> 'numbers'
})

local Textbox = Temp.Textbox({
	Title = "Textbox",
	TextboxTitle = "Text here",
	Callback = function(Value)
		print(Value)
	end,
	ClearTextOnFocus = false,
})

local ColorPicker = Temp.ColorPicker({
	Title = "Color Picker",
	Callback = function(Value)
		print(Value)
	end,
	Default = Color3.new(1, 1, 1),
})
