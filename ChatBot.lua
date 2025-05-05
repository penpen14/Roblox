--> Variables

-- Services
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character.Humanoid
local HumanoidRootPart = Character.HumanoidRootPart

-- Settings / Main
local HistoryTable = {}
local HistoryEmpty = {}
local Blacklist = {}

local ServerCooldown = 1000

getgenv().Enabled = false

local Cooldown = 1
local Debounce = false
local History = false
local Preset = "Maximum 150 Characters"
local Radius = 20
local Api = "https://cerulean-lively-blackcurrant.glitch.me/"

--> Functions

local function InRange(player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if (player.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= Radius then
            return true
        end
    end
    return false
end

local function SplitMessage(Message)
    print("Splittings messages")
    local Parts = {}
    for i = 1,#Message, 150 do
        table.insert(Parts, Message:sub(i, i + 149 - 1))
    end

    print("Parts:",#Parts)
    return Parts
end

local function SendMessage(Message)
    print(string.len(Message))
    if string.len(Message) > 150 then
        print("Message length is more than 150")
        local Messages = SplitMessage(Message)
        for _,message in ipairs(Messages) do
            TextChatService.TextChannels.RBXGeneral:SendAsync(message)
            task.wait(0.3)
        end
    else
        TextChatService.TextChannels.RBXGeneral:SendAsync(Message)
    end
end

local function ApiRequest(Prompt)
	local Success, Message = pcall(function()
		local body = {
            cooldown = ServerCooldown,
			prompt = Prompt,
			history = if History then HistoryTable else HistoryEmpty,
			preset = Preset
		}
		body = HttpService:JSONEncode(body)
		
		local Response = request({
			Url = Api;
			Method = "POST";
			Headers = {
				["Content-Type"] = "application/json";
			};
			Body = body
		})
		if Response.Success then
			return Response.Body
		end
	end)
	
	if Success then
		return Message
	else
		warn(Message)
		return nil
	end
end

-- Ui Lib
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Gemini 1.5 Flash",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Ultimate Kazakh Techonology",
    LoadingSubtitle = "suck ma balls",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
 
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
       RememberJoins = false -- Set this to false to make them join the discord every time they load it up
    },
 
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local Tab = Window:CreateTab("Main", 4483362458) 
 local Section = Tab:CreateSection("Main")

 local BotToggle = Tab:CreateToggle({
    Name = "Chat AI",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        Enabled = Value
    end,
 })

 local HistoryToggle = Tab:CreateToggle({
    Name = "AI Memory",
    CurrentValue = false,
    Flag = "Toggle2", 
    Callback = function(Value)
        History = Value
    end,
 })

 local ClearMemButton = Tab:CreateButton({
    Name = "Clear Memory",
    Callback = function()
        HistoryTable = {}
        Rayfield:Notify({
            Title = "Gemini",
            Content = "Memory has been cleared",
            Duration = 3,
            Image = "trash",
         })
    end,
 })

 local BlacklistDrop = Tab:CreateDropdown({
    Name = "Blacklist",
    Options = Blacklist,
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Options) end,
 })

 local PresetInput = Tab:CreateInput({
    Name = "Preset (Instructions)",
    CurrentValue = Preset,
    PlaceholderText = "",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        Preset = Text
    end,
 })

 local BlacklistInput = Tab:CreateInput({
    Name = "Add To Blacklist",
    CurrentValue = "",
    PlaceholderText = "Enter Player Name",
    RemoveTextAfterFocusLost = false,
    Flag = "Input2",
    Callback = function(Text)
        if Players:FindFirstChild(Text) then
            table.insert(Blacklist,Text)
            BlacklistDrop:Refresh(Blacklist)
            Rayfield:Notify({
                Title = "Blacklist",
                Content = "Added "..Text.." To Blacklist",
                Duration = 3,
                Image = "book-marked",
             })
        else
            Rayfield:Notify({
                Title = "Blacklist",
                Content = Text.." Is Not Valid Player Name",
                Duration = 3,
                Image = "circle-x",
             })
        end
    end,
 })

 local BlacklistInput = Tab:CreateInput({
    Name = "Del From Blacklist",
    CurrentValue = "",
    PlaceholderText = "Enter Player Name",
    RemoveTextAfterFocusLost = false,
    Flag = "Input3",
    Callback = function(Text)
        if table.find(Blacklist,Text) then
            table.remove(Blacklist,table.find(Blacklist,Text))
            BlacklistDrop:Refresh(Blacklist)
            Rayfield:Notify({
                Title = "Blacklist",
                Content = "Deleted "..Text.." From Blacklist",
                Duration = 3,
                Image = "book-marked",
             })
        else
            Rayfield:Notify({
                Title = "Blacklist",
                Content = Text.." Is Not Valid Player Name",
                Duration = 3,
                Image = "circle-x",
             })
        end
    end,
 })

 local ServerCooldownSlider = Tab:CreateSlider({
    Name = "Server Cooldown",
    Range = {1000, 15000},
    Increment = 0.1,
    Suffix = "MSeconds",
    CurrentValue = 1000,
    Flag = "Slider1",
    Callback = function(Value)
        ServerCooldown = Value
    end,
 })

 local CooldownSlider = Tab:CreateSlider({
    Name = "Client Cooldown",
    Range = {0, 30},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = 1,
    Flag = "Slider2",
    Callback = function(Value)
        Cooldown = Value
    end,
 })

 local RangeSlider = Tab:CreateSlider({
    Name = "Proximity Range",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Stud",
    CurrentValue = 20,
    Flag = "Slider2",
    Callback = function(Value)
        Radius = Value
    end,
 })

 local LastResponseParagraph = Tab:CreateParagraph({Title = "Last Response", Content = ""})

 -- Events
for i,player in pairs(Players:GetPlayers()) do
    if player == Player then continue end

    player.Chatted:Connect(function(Message)
        local IsInRange = InRange(player)

        if IsInRange and not Debounce and Enabled and not table.find(Blacklist, player.Name) then
            Humanoid:MoveTo((player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0, -2)).Position)

            local Response = ApiRequest(Message)

            if Response then
                LastResponseParagraph:Set({Title = "Last Response", Content = Response})
                SendMessage(Response)

                -- Memory
                if History then
                    table.insert(HistoryTable, {
                        role = "user",
                        parts = {{
                            text =  Message
                        }}
                    })
                    table.insert(HistoryTable, {
                        role = "model",
                        parts = {{
                            text = Response
                        }}
                    })
                end 
            end

            Debounce = true

            task.delay(Cooldown,function()
                Debounce = false
            end)
        end
    end)
end
