--// Services
local Players = game:GetService('Players')
local UIS = game:GetService("UserInputService")

--// Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Hovered = false
local Holding = false
local MoveCon = nil

local InitialX, InitialY, UIInitialPos

local Count = Instance.new("ScreenGui")
local Count_2 = Instance.new("Frame")
local Icon = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local Label = Instance.new("TextLabel")

Count.Name = "Count"
Count.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Count.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Count_2.Name = "Count"
Count_2.Parent = Count
Count_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Count_2.BackgroundTransparency = 0.300
Count_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Count_2.BorderSizePixel = 0
Count_2.Position = UDim2.new(0.021014493, 0, 0.257537693, 0)
Count_2.Size = UDim2.new(0, 209, 0, 51)

Icon.Name = "Icon"
Icon.Parent = Count_2
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1.000
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.BorderSizePixel = 0
Icon.Position = UDim2.new(0.0430622026, 0, 0.254901975, 0)
Icon.Size = UDim2.new(0, 24, 0, 24)
Icon.Image = "rbxassetid://122786650131772"

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Count_2

Label.Name = "Label"
Label.Parent = Count_2
Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Label.BackgroundTransparency = 1.000
Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
Label.BorderSizePixel = 0
Label.Position = UDim2.new(0.205741629, 0, 0.235294119, 0)
Label.Size = UDim2.new(0, 145, 0, 25)
Label.Font = Enum.Font.GothamBold
Label.Text = "Коробки: 35 шт"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextSize = 22.000

--// Functions

local function Drag()
	if Holding == false then MoveCon:Disconnect(); return end
	local distanceMovedX = InitialX - Mouse.X
	local distanceMovedY = InitialY - Mouse.Y

	Count_2.Position = UIInitialPos - UDim2.new(0, distanceMovedX, 0, distanceMovedY)
end

--// Connections

Count_2.MouseEnter:Connect(function()
	Hovered = true
end)

Count_2.MouseLeave:Connect(function()
	Hovered = false
end)

UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Holding = Hovered
		if Holding then
			InitialX, InitialY = Mouse.X, Mouse.Y
			UIInitialPos = Count_2.Position

			MoveCon = Mouse.Move:Connect(Drag)
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Holding = false
	end
end)

local CountUI = {
	Visible = function(Value)
		Count.Enabled = Value
	end,
	Text = function(Value)
		Label.Text = Value
	end,
}

return CountUI
