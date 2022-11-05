local Material = require("https://raw.githubusercontent.com/HairBaconGamming/Gamming-Material-HUB/main/Main.lua") -- get material

local Main = Material:Load({
	Title = <string>,
	SmothDrag = <bool>,
	Key = <string> or <keycode>,
        X = <number>,
        Y = <number>,
})

local Temp = Main:New({
	Title = "Home",
	ImageId = <int>,
	Image = <asseturl>, -- example Image = "http://www.roblox.com/asset/?id=4034483344"
})

local Button = Temp:Button({
	Title = <string>,
	Callback = <function>, -- return nil
})

local Toggle = Temp:Toggle({
	Title = "Bool",
	Callback = <function>, -- return <bool>
	Enabled = false
})

local Slide = Temp:Slide({
	Title = <string>,
	Callback = <function>, -- return <int>
	Min = <number>,
	Max = <number>,
	Default = <number>,
	Percent = <int>,
})

local Dropdown = Temp:Dropdown({
	Title = <string>,
	Callback = <function>, -- return <string>
	Table = <stringtable>,
	AutoTextChose = <bool>,
})

local Textbox = Temp:Textbox({
	Title = <string>,
	TextboxTitle = <string>,
	Callback = <function>, -- return <string>
	ClearTextOnFocus = false,
})

local ColorPicker = Temp:ColorPicker({
	Title = <string>,
	Callback = <function>, -- return <color>
	Default = <color>,
})

local KeyBox = Temp:KeyBox({
	Title = <string>,
	Callback = <function>, -- return <keycode>
	Key = <keycode>,
})

-- Button --
Button:SetTitle(<string>)
Button:GetTitle(<nil>)
Button:SetCallback(<function>)

-- Toggle --
Toggle:SetTitle(<string>)
Toggle:GetTitle(<nil>)
Toggle:SetToggle(<bool>)
Toggle:GetToggle(<nil>)
Toggle:SetCallback(<string>)

-- Slide --
Slide:SetTitle(<string>)
Slide:GetTitle(<nil>)
Slide:SetCallback(<function>)
Slide:SetMin(<number>)
Slide:SetMax(<number>)
Slide:SetDefault(<number>)
Slide:SetPercent(<int>)
Slide:GetMin(<nil>)
Slide:GetMax(<nil>)
Slide:GetDefault(<nil>)
Slide:GetPercent(<nil>)

-- Dropdown --
Dropdown:SetTitle(<string>)
Dropdown:GetTitle(<nil>)
Dropdown:SetCallback(<function>)
Dropdown:SetTable(<stringtable>)
Dropdown:GetTable(<nil>)
Dropdown:AutoTextChose(<bool>)

-- Textbox --
Textbox:SetTitle(<string>)
Textbox:GetTitle(<nil>)
Textbox:SetCallback(<function>)
Textbox:SetText(<string>)
Textbox:GetText(<nil>)
Textbox:SetPlaceholderText(<string>)
Textbox:GetPlaceholderText(<nil>)
Textbox:ClearTextOnFocus(<bool>)

-- ColorPicker --
ColorPicker:SetTitle(<string>)
ColorPicker:GetTitle(<nil>)
ColorPicker:SetCallback(<function>)
ColorPicker:SetColor(<color>)
ColorPicker:GetColor(<nil>)

-- KeyBox --
KeyBox:SetTitle(<string>)
KeyBox:GetTitle(<nil>)
KeyBox:SetCallback(<function>)
KeyBox:SetKey(<keycode>)
KeyBox:GetKey(<nil>)
