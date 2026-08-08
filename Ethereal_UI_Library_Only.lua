-- Ethereal UI Library — extracted/cleaned from the supplied source.
-- Game-specific combat/ESP/game-framework setup has been removed.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()

local IsStudio = game:GetService("RunService"):IsStudio()
local IsElectron = false
local GameName = "Universal"
local LRM_LinkedDiscordID = "Local"

gethui = gethui or function()
    return game:GetService("CoreGui")
end

LPH_JIT_MAX = LPH_JIT_MAX or function(f) return f end
LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(f) return f end

local Library             = {
	Windows = {};
	Flags = {};
    CurrentDropdown = nil;
    CurrentColorpicker = nil;
    Theme = { --// Default Library.Theme
        --// Orange Colors
        --Accent = Color3.fromRGB(255, 122, 0),
        --GradiantContrast2 = Color3.fromRGB(200, 80, 0),
        --GradiantContrast = Color3.fromRGB(200, 80, 0),

        GradiantContrast2 = Color3.fromRGB(70, 69, 195),
        GradiantContrast = Color3.fromRGB(13, 34, 71),
        
        DefGradiantContrast2 = Color3.fromRGB(70, 69, 195),
        DefGradiantContrast = Color3.fromRGB(13, 34, 71),

        Border = Color3.fromRGB(0, 0, 0),
        VeryDarkContrast = Color3.fromRGB(14, 14, 14),

        Accent = Color3.fromRGB(120, 119, 255),
        DefaultAccent = Color3.fromRGB(120, 119, 255),
        
        DarkContrast = Color3.fromRGB(16, 16, 16),
        MedianContrast = Color3.fromRGB(18, 18, 18),
        LightContrast = Color3.fromRGB(37, 37, 37),
        ElementOff = Color3.fromRGB(120, 120, 120),
        ElementOn = Color3.fromRGB(255, 255, 255),

        RiskyOff = Color3.fromRGB(175, 0, 0),
        RiskyOn = Color3.fromRGB(255, 0, 0),
    };

    MenuFont = Font.new("rbxassetid://11702779409", Enum.FontWeight.Medium);
    SmallFont = Font.new("rbxassetid://11702779409", Enum.FontWeight.Medium);
    TextSize = not IsStudio and 10.00 or 13;
    SmallSize = not IsStudio and 9.00 or 13;
    Config = "None";
};
local EasingStyle         = {
	["Linear"] = {
		["In"] = function(Delta)
			return Delta
		end,

		["Out"] = function(Delta)
			return Delta
		end,

		["InOut"] = function(Delta)
			return Delta
		end
	},

	["Cubic"] = {
		["In"] = function(Delta)
			return Delta^3
		end,

		["Out"] = function(Delta)
			return (Delta - 1)^3 + 1
		end,

		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return (4 * Delta)^3
			else
				return (4 * (Delta - 1))^3 + 1
			end
 		end
	},
	["Quad"] = {
		["In"] = function(Delta)
			return Delta^2
		end,

		["Out"] = function(Delta)
			return -(Delta - 1)^2 + 1
		end,

		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return (2 * Delta)^2
			else
				return (-2 * (Delta - 1))^2 + 1
			end
		end
	},
	["Quart"] = {
		["In"] = function(Delta)
			return Delta^4
		end,

		["Out"] = function(Delta)
			return -(Delta - 1)^4 + 1
		end,

		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return (8 * Delta)^4
			else
				return (-8 * (Delta - 1))^4 + 1
			end
		end
	},
	["Quint"] = {
		["In"] = function(Delta)
			return Delta^5
		end,
		["Out"] = function(Delta)
			return (Delta - 1)^5 + 1
		end,
		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return (16 * Delta)^5
			else
				return (16 * (Delta - 1))^5 + 1
			end
		end
	},
	["Sine"] = {
		["In"] = function(Delta)
			return math.sin(math.pi / 2 * Delta - math.pi / 2)
		end,

		["Out"] = function(Delta)
			return math.sin(math.pi / 2 * Delta)
		end,

		["InOut"] = function(Delta)
			return 0.5 * math.sin(math.pi * Delta - math.pi / 2) + 0.5
		end
	},
	["Exponential"] = {
		["In"] = function(Delta)
			return 2^(10 * Delta - 10) - 0.001
		end,
		["Out"] = function(Delta)
			return 1.001 * -2^(-10 * Delta) + 1
		end,
		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return 0.5 * 2^(20 * Delta - 10) - 0.0005
			else
				return 0.50025 * -2^(-20 * Delta + 10) + 1
			end
		end
	},
	["Back"] = {
		["In"] = function(Delta)
			return Delta^2 * (Delta * (1.70158 + 1) - 1.70158)
		end,
		["Out"] = function(Delta)
			return (Delta - 1)^2 * ((Delta - 1) * (1.70158 + 1) + 1.70158) + 1
		end,
		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return (2 * Delta * Delta) * ((2 * Delta) * (2.5949095 + 1) - 2.5949095)
			else
				return 0.5 * ((Delta * 2) - 2)^2 * ((Delta * 2 - 2) * (2.5949095 + 1) + 2.5949095) + 1
			end
		end
	},
	["Bounce"] = {
		["In"] = function(Delta)
			if Delta <= 0.25 / 2.75 then
				return -7.5625 * (1 - Delta - 2.625 / 2.75)^2 + 0.015625
			elseif Delta <= 0.75 / 2.75 then
				return -7.5625 * (1 - Delta - 2.25 / 2.75)^2 + 0.0625
			elseif Delta <= 1.75 / 2.75 then
				return -7.5625 * (1 - Delta - 1.5 / 2.75)^2 + 0.25
			else
				return 1 - 7.5625 * (1 - Delta)^2
			end
		end,
		["Out"] = function(Delta)
			if Delta <= 1 / 2.75 then
				return 7.5625 * (Delta * Delta)
			elseif Delta <= 2 / 2.75 then
				return 7.5625 * (Delta - 1.5 / 2.75)^2 + 0.75
			elseif Delta <= 2.5 / 2.75 then
				return 7.5625 * (Delta - 2.25 / 2.75)^2 + 0.9375
			else
				return 7.5625 * (Delta - 2.625 / 2.75)^2 + 0.984375
			end
		end,
		["InOut"] = function(Delta)
			if Delta <= 0.125 / 2.75 then
				return 0.5 * (-7.5625 * (1 - Delta * 2 - 2.625 / 2.75)^2 + 0.015625)
			elseif Delta <= 0.375 / 2.75 then
				return 0.5 * (-7.5625 * (1 - Delta * 2 - 2.25 / 2.75)^2 + 0.0625)
			elseif Delta <= 0.875 / 2.75 then
				return 0.5 * (-7.5625 * (1 - Delta * 2 - 1.5 / 2.75)^2 + 0.25)
			elseif Delta <= 0.5 then
				return 0.5 * (1 - 7.5625 * (1 - Delta * 2)^2)
			elseif Delta <= 1.875 / 2.75 then
				return 0.5 + 3.78125 * (2 * Delta - 1)^2
			elseif Delta <= 2.375 / 2.75 then
				return 3.78125 * (2 * Delta - 4.25 / 2.75)^2 + 0.875
			elseif Delta <= 2.625 / 2.75 then
				return 3.78125 * (2 * Delta - 5 / 2.75)^2 + 0.96875
			else
				return 3.78125 * (2 * Delta - 5.375 / 2.75)^2 + 0.9921875
			end
		end
	},
	["Elastic"] = {
		["In"] = function(Delta)
			return -2^(10 * (Delta - 1)) * math.sin(math.pi * 2 * (Delta - 1 - 0.3 / 4) / 0.3)
		end,

		["Out"] = function(Delta)
			return 2^(-10 * Delta) * math.sin(math.pi * 2 * (Delta - 0.3 / 4) / 0.3) + 1
		end,

		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return -0.5 * 2^(20 * Delta - 10) * math.sin(math.pi * 2 * (Delta * 2 - 1.1125) / 0.45)
			else
				return 0.5 * 2^(-20 * Delta + 10) * math.sin(math.pi * 2 * (Delta * 2 - 1.1125) / 0.45) + 1
			end
		end
	},
	["Circular"] = {
		["In"] = function(Delta)
			return -math.sqrt(1 - Delta^2) + 1
		end,

		["Out"] = function(Delta)
			return math.sqrt(-(Delta - 1)^2 + 1)
		end,

		["InOut"] = function(Delta)
			if Delta <= 0.5 then
				return -math.sqrt(-Delta^2 + 0.25) + 0.5
			else
				return math.sqrt(-(Delta - 1)^2 + 0.25) + 0.5
			end
		end
	};
};
do --// Library functions
    LPH_JIT_MAX(function()
        --// Notifications 
        local Notifications = {};

        --// For UI Dragging and Resizing
        local IsDragging;
        local DragInput;
        local DragStart 
        local StartPos; 

        local MinimumSize = Vector2.new(200, 200);
        local ResizeInput = nil;
        local IsResizing = false;
        local LastPosition, StartSize 
        
        do  --// Keybind UI 
            local KeybindsUI;
            
            KeybindsUI = Instance.new("ScreenGui");
            KeybindsUI.Parent = gethui()
            local KeybindsOutline = Instance.new("Frame")
            local KeybindsInner = Instance.new("Frame")
            local KeybindsTitle = Instance.new("TextLabel")
            local KeybindsAccent = Instance.new("Frame")
            local KeybindsContainer = Instance.new("Frame")
            local KeybindsContainerOutline = Instance.new("Frame");

            do --// Properties
                KeybindsUI.Name = "9391203j312i3kashd9q312093ajsdokake219183213h";
                KeybindsUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                
                KeybindsOutline.Visible = false;
                KeybindsOutline.Parent = KeybindsUI
                KeybindsOutline.BackgroundColor3 = Library.Theme.LightContrast
                KeybindsOutline.BorderColor3 = Library.Theme.Border
                KeybindsOutline.Position = UDim2.new(0.161736935, 0, 0.351219505, 0)
                KeybindsOutline.Size = UDim2.new(0, 130, 0, 20)
                
                KeybindsInner.Parent = KeybindsOutline
                KeybindsInner.BackgroundColor3 = Library.Theme.MedianContrast
                KeybindsInner.BorderColor3 = Library.Theme.Border
                KeybindsInner.Position = UDim2.new(0, 2, 0, 2)
                KeybindsInner.Size = UDim2.new(1, -4, 1, -4)
                
                KeybindsTitle.Parent = KeybindsInner
                KeybindsTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeybindsTitle.BackgroundTransparency = 1.000
                KeybindsTitle.BorderColor3 = Library.Theme.Border
                KeybindsTitle.BorderSizePixel = 0
                KeybindsTitle.Position = UDim2.new(0, 0, 0, 2)
                KeybindsTitle.Size = UDim2.new(0, 126, 1, 0)
                KeybindsTitle.FontFace = Library.MenuFont
                KeybindsTitle.Text = "Keybinds"
                KeybindsTitle.TextColor3 = Library.Theme.ElementOn
                KeybindsTitle.TextSize = Library.TextSize
                
                KeybindsAccent.Parent = KeybindsInner
                KeybindsAccent.BackgroundColor3 = Library.Theme.Accent
                KeybindsAccent.BorderColor3 = Library.Theme.Border
                KeybindsAccent.Size = UDim2.new(1, 0, 0, 1)
                
                KeybindsContainerOutline.Visible = true;
                KeybindsContainerOutline.Parent = KeybindsOutline
                KeybindsContainerOutline.BackgroundColor3 = Library.Theme.LightContrast
                KeybindsContainerOutline.BorderColor3 = Library.Theme.Border
                KeybindsContainerOutline.Position = UDim2.new(0, 0, 0, 21)
                KeybindsContainerOutline.Size = UDim2.new(1, 0, 0, 0)
                KeybindsContainerOutline.ClipsDescendants = true;

                KeybindsContainer.Parent = KeybindsContainerOutline
                KeybindsContainer.BackgroundColor3 = Library.Theme.MedianContrast
                KeybindsContainer.BorderColor3 = Library.Theme.Border
                KeybindsContainer.Position = UDim2.new(0, 2, 0, 2)
                KeybindsContainer.Size = UDim2.new(1, -4, 1, -4)
                
                local KeybindLayout = Instance.new("UIListLayout")
                local UIPadding = Instance.new("UIPadding")
                
                KeybindLayout.Parent = KeybindsContainer
                KeybindLayout.SortOrder = Enum.SortOrder.LayoutOrder
                KeybindLayout.Padding = UDim.new(0, 2);
                UIPadding.Parent = KeybindsContainer
                UIPadding.PaddingTop = UDim.new(0, 1)

                Library.KeybindsContainer = KeybindsContainer
                Library.KeybindIndex = 0;
                Library.KeybindsGUI = KeybindsOutline;
                Library.KeybindsAccent = KeybindsAccent;
            end;

            do --// Functions
                KeybindsContainer.ChildAdded:Connect(function()
                    Library.KeybindIndex = Library.KeybindIndex + 1;
                    local Size;-- = UDim2.new(1, 0, 0, 5 + (Library.KeybindIndex * 11));

                    if Library.KeybindIndex ~= 1 then 
                        Size = UDim2.new(1, 0, 0, (11 * Library.KeybindIndex) + 3);
                    else 
                        Size = UDim2.new(1, 0, 0, 14);
                    end;

                    Library:Tween(KeybindsContainerOutline, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Size});
                end);

                KeybindsContainer.ChildRemoved:Connect(function()
                    Library.KeybindIndex = Library.KeybindIndex - 1;
                    local Size;-- = UDim2.new(1, 0, 0, 5 + (Library.KeybindIndex * 11));

                    if Library.KeybindIndex ~= 1 then 
                        Size = UDim2.new(1, 0, 0, (11* Library.KeybindIndex) + 3);
                    else 
                        Size = UDim2.new(1, 0, 0, 14);
                    end;

                    if Library.KeybindIndex == 0 then 
                        Size = UDim2.new(1, 0, 0, 0);
                    end;

                    Library:Tween(KeybindsContainerOutline, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = Size});
                end);
            end;
        end;

        do --// Watermark UI 
            local WatermarkUI;
            
            WatermarkUI = Instance.new("ScreenGui")
            WatermarkUI.Parent = gethui();
            local WatermarkOutline = Instance.new("Frame")
            local WatermarkInner = Instance.new("Frame")
            local WatermarkAccent = Instance.new("Frame")
            local WatermarkText = Instance.new("TextLabel")
            local FakeText = Instance.new("TextLabel");

            do --// Properties
                WatermarkUI.Name = "9391203j312i3kashd9q312093ajsdokake219183213h";
                WatermarkUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                
                WatermarkOutline.Name = "WatermarkOutline"
                WatermarkOutline.Visible = false;
                WatermarkOutline.Parent = WatermarkUI
                WatermarkOutline.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
                WatermarkOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                WatermarkOutline.Position = UDim2.new(0.001, 97, 0.202453986, -224);
                WatermarkOutline.Size = UDim2.new(0, 200, 0, 20)
                
                WatermarkInner.Parent = WatermarkOutline
                WatermarkInner.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
                WatermarkInner.BorderColor3 = Color3.fromRGB(0, 0, 0)
                WatermarkInner.Position = UDim2.new(0, 2, 0, 2)
                WatermarkInner.Size = UDim2.new(1, -4, 1, -4)
                
                WatermarkAccent.Parent = WatermarkInner
                WatermarkAccent.BackgroundColor3 = Library.Theme.Accent;
                WatermarkAccent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                WatermarkAccent.Size = UDim2.new(1, 0, 0, 1)

                WatermarkText.Parent = WatermarkInner
                WatermarkText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                WatermarkText.BackgroundTransparency = 1.000
                WatermarkText.BorderColor3 = Color3.fromRGB(0, 0, 0)
                WatermarkText.BorderSizePixel = 0
                WatermarkText.Position = UDim2.new(0, 1, 0, 2)
                WatermarkText.Size = UDim2.new(1, 0, 1, 0)
                WatermarkText.FontFace = Library.MenuFont
                WatermarkText.TextColor3 = Color3.fromRGB(255, 255, 255)
                WatermarkText.TextSize = Library.TextSize
                WatermarkText.TextXAlignment = Enum.TextXAlignment.Center;
            end;

            WatermarkText:GetPropertyChangedSignal("Text"):Connect(function()
                WatermarkOutline.Size = UDim2.new(0, (string.len(WatermarkText.Text) * 5) + 10, 0, 20);
            end);

            WatermarkText.Text = ("Ethereal | %s | %s | Config - %s"):format(GameName, LRM_LinkedDiscordID, Library.Config);

            WatermarkOutline.Size = UDim2.new(0, 400, 0, 20);

            Library.WatermarkAccent = WatermarkAccent;
            Library.WatermarkText = WatermarkText; 
            Library.WatermarkOutline = WatermarkOutline;
        end;

        do --// Functions

            do --// Standard
                function Library:Round(Number, Divider)
                    if typeof(Number) == "Vector2" then
                        return Vector2.new(Library:Round(Number.X), Library:Round(Number.Y))
                    elseif typeof(Number) == "Vector3" then
                        return Vector3.new(Library:Round(Number.X), Library:Round(Number.Y), Library:Round(Number.Z))
                    elseif typeof(Number) == "Color3" then
                        return Library:Round(Number.r * 255), Library:Round(Number.g * 255), Library:Round(Number.b * 255)
                    else
                        return Number - Number % (Divider or 1);
                    end
                end;

                function Library:Tween(...)
                    local NewTween = TweenService:Create(...)
                    NewTween:Play();
                    return NewTween;
                end;

                function Library:MakeDraggable(Input, UI, Other)
                    UI.BackgroundColor3 = Library.Theme.Accent;
                    Other.BackgroundColor3 = Library.Theme.Accent;
                    local Delta = Input.Position - DragStart; 
                    UI.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y);
                end;
            end;
            
            do --// Keybinds
                function Library:ToggleBind(Name, Key)
                    if Name ~= "Open/Close" then 
                        if Library.KeybindsContainer:FindFirstChild(Name) then 
                            --Library.KeybindIndex = Library.KeybindIndex - 1;
                            Library.KeybindsContainer:FindFirstChild(Name):Destroy();
                        else 
                            local NewBind = Instance.new("TextLabel")
                            NewBind.Name = Name
                            NewBind.Parent = Library.KeybindsContainer;
                            --NewBind.Position = UDim2.new(0, 0, 0, 2 + (Library.KeybindIndex*10));
                            NewBind.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
                            NewBind.BackgroundTransparency = 1.000
                            NewBind.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            NewBind.Size = UDim2.new(1, 0, 0, 9)
                            NewBind.FontFace = Library.MenuFont
                            NewBind.Text = Name .. (" [%s]"):format(Key);
                            NewBind.TextColor3 = Library.Theme.ElementOn;
                            NewBind.TextSize = Library.TextSize
                            NewBind.TextStrokeTransparency = 0.000
                            NewBind.TextWrapped = true
                            NewBind.TextXAlignment = Enum.TextXAlignment.Left;
                            --Library.KeybindIndex = Library.KeybindIndex+1;
                        end;
                    end;
                end;
            end;

            do --// Configs
                function Library:GetConfig()
                    local Config = {}

                    for Index, Value in pairs(Library.Flags) do 
                        if type(Value) == "table" then
                            if rawget(Value, "Value") or Value.Value then 
                                Config[Index] = Value.Value; 
                            elseif rawget(Value, "Color") then 
                                Config[Index] = {Color = {R = Value.Color.R, G = Value.Color.G, B = Value.Color.B}, Transparency = Value.Transparency};
                            elseif rawget(Value, "Key") and rawget(Value, "Name") then
                                Config[Index] = {Name = Value.Key.Name};
                            else
                                if not Config[Index] then 
                                    Config[Index] = Value.Value;
                                end;
                            end;
                        end;
                    end;
                    return Config, HttpService:JSONEncode(Config)
                end;

                function Library:SaveConfig(ConfigName)
                    local _, Encoded = Library:GetConfig();

                    if ConfigName and type(ConfigName) == "string" then 
                        writefile("Ethereal/Configs/"..ConfigName..".txt", Encoded);
                    end;
                end;

                function Library:DeleteConfig(ConfigName)
                    if isfile("Ethereal/Configs/"..ConfigName..".txt") then 
                        delfile("Ethereal/Configs/"..ConfigName..".txt");
                    end;
                end;

                function Library:LoadConfig(Config)
                    if not Config or Config == nil then
                        Library:Notify("Config not found, did you possibly delete it and not reselect a new one?");
                        return 
                    end;

                    local DecodedConfig = HttpService:JSONDecode(Config);

                    for Index, Value in pairs(DecodedConfig) do
                        task.spawn(function()
                            local Succ, Err = pcall(function()
                                local ToLib = Library.Flags[Index];

                                if ToLib then 
                                    if rawget(ToLib, "Key") and type(Value) ~= "boolean" then 
                                        if table.find({"MouseButton1","MouseWheel","MouseButton2","MouseButton3"}, tostring(Value.Name)) then
                                            ToLib:Set(Value, true)
                                        else 
                                            ToLib:Set(Value);
                                        end 
                                    elseif rawget(ToLib, "Color") then 
                                        ToLib:Set({
                                            Color = Color3.new(Value.Color.R, Value.Color.G, Value.Color.B),
                                            Transparency = Value.Transparency
                                        });
                                    elseif rawget(ToLib, "Value") and not rawget(ToLib, "Color") and not rawget(ToLib, "Key") then 
                                        if rawget(ToLib, "Multi") and type(Value) ~= "table" then 
                                            ToLib:Set({Value})
                                        else
                                            if ToLib.Min then 
                                                if Value > ToLib.Max then 
                                                    ToLib:Set(ToLib.Max);
                                                else 
                                                    ToLib:Set(Value);
                                                end;
                                            else
                                                ToLib:Set(Value);
                                            end;
                                        end
                                    else 
                                        ToLib:Set(Value)
                                    end;
                                end;
                            end);
                            if not Succ and Err then warn("[Ethereal ERROR]: "..tostring(Err)) end;
                        end);
                    end;
                end;
            end;

            function Library:NewWindow(Data)
                local Window = {
                    TabAmount = 0;
                    Name = Data.Name;
                    Tabs = {};
                    DefaultSize = Data.Size or UDim2.new(0, 583, 0, 753);
                    ImportantIndex = 9999999;
                    CurrentTab = nil;
                };

                LibraryScreenGui = Instance.new("ScreenGui");
                LibraryScreenGui.Parent = gethui();
                LibraryScreenGui.Enabled = false; 
                
                LibraryMouseGui = Instance.new("ScreenGui");
                LibraryMouseGui.Parent = gethui();
                LibraryMouseGui.Enabled = false;
                LibraryMouseGui.Name = "9391203j312i3kashd9q312093ajsdokake219183213h";
                LibraryMouseGui.IgnoreGuiInset = true;

                local MouseCursor = Instance.new("ImageLabel", LibraryMouseGui); do 
                    MouseCursor.Image = "http://www.roblox.com/asset/?id=5545698398";
                    MouseCursor.BackgroundTransparency = 1;
                    MouseCursor.Size = UDim2.new(0, 36, 0, 36);
                    MouseCursor.Parent = LibraryMouseGui;
                    Library.MouseCursor = MouseCursor;
                end;

                LibraryMouseGui.Enabled = true;

                Mouse.Move:Connect(function()
                    if LibraryScreenGui.Enabled then 
                        LibraryMouseGui.Enabled = true;
                        MouseLocation = UserInputService:GetMouseLocation();
                        MouseCursor.Position = UDim2.new(0, MouseLocation.X - 18, 0, MouseLocation.Y - 18);
                    else 
                        LibraryMouseGui.Enabled = false;
                    end;
                end);

                local TabSize = 545 / Window.TabAmount;
                local Title = Instance.new("TextLabel")
                local WindowBorder = Instance.new("TextButton");
                local BorderInner = Instance.new("Frame")
                local WorkspaceOutter = Instance.new("Frame");
                local WorkspaceInner = Instance.new("Frame");
                local Tabs = Instance.new("Frame");
                local TabsLayout = Instance.new("UIListLayout");
                local Resizer = Instance.new("ImageButton"); 

                local PageArea = Instance.new("Frame");
                local PageAreaInner = Instance.new("Frame");
                local TabTransitioner = Instance.new("Frame");
                local TabTransitioner2 = Instance.new("Frame");

                local UIShadow = Instance.new("ImageLabel");

                local VisibleBorder = Instance.new("Frame");

                Window.MainFrame = WindowBorder;
                
                do --// Element Properties
                    LibraryScreenGui.Parent = gethui();
                    LibraryScreenGui.Name = "9391203j312i3kashd9q312093ajsdokake219183213h";
                    LibraryScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

                    WindowBorder.AutoButtonColor = false;
                    WindowBorder.Text = ""
                    WindowBorder.Parent = LibraryScreenGui
                    WindowBorder.BackgroundColor3 = Library.Theme.LightContrast
                    WindowBorder.BorderColor3 = Library.Theme.Border
                    WindowBorder.Position = UDim2.new(0.104468189, 0, 0.202439025, 0)
                    WindowBorder.Size = Window.DefaultSize;

                    UIShadow.Parent = WindowBorder;
                    UIShadow.Image = "rbxassetid://6015897843";

                    UIShadow.ScaleType = Enum.ScaleType.Slice;
                    UIShadow.SliceCenter = Rect.new(49, 49, 450, 450);
                    UIShadow.ImageColor3 = Library.Theme.Accent;
                    UIShadow.ImageTransparency = 0.5;
                    UIShadow.BackgroundTransparency = 1;
                    UIShadow.Size = UDim2.new(1, 47, 1, 47);
                    UIShadow.Position = UDim2.new(0.5, 0, 0.5, 0);
                    UIShadow.AnchorPoint = Vector2.new(0.5, 0.5);

                    VisibleBorder.Parent = WindowBorder;
                    VisibleBorder.Size = UDim2.new(1, 0, 1, 0);
                    VisibleBorder.BackgroundColor3 = Library.Theme.LightContrast;
                    VisibleBorder.BorderColor3 = Library.Theme.Border;

                    BorderInner.Parent = WindowBorder
                    BorderInner.BackgroundColor3 = Library.Theme.VeryDarkContrast
                    BorderInner.BorderColor3 = Library.Theme.Border
                    BorderInner.Position = UDim2.new(0, 2, 0, 2)
                    BorderInner.Size = UDim2.new(1, -4, 1, -4)

                    Resizer.Parent = BorderInner
                    Resizer.BackgroundColor3 = Library.Theme.Accent
                    Resizer.BackgroundTransparency = 1.000
                    Resizer.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    Resizer.BorderSizePixel = 0
                    Resizer.Position = UDim2.new(1, -12, 1, -12)
                    Resizer.Size = UDim2.new(0, 12, 0, 12)
                    Resizer.Image = "rbxassetid://7368471234"
                    Resizer.ImageColor3 = Library.Theme.Accent;
                    Resizer.AutoButtonColor = false;
                    if not IsElectron then 
                        Resizer.Modal = true;
                    end
                    WorkspaceOutter.Parent = BorderInner
                    WorkspaceOutter.BackgroundColor3 = Library.Theme.LightContrast
                    WorkspaceOutter.BorderColor3 = Library.Theme.Border
                    WorkspaceOutter.Position = UDim2.new(0, 5, 0, 20)
                    WorkspaceOutter.Size = UDim2.new(1, -15, 1, -32)

                    WorkspaceInner.Parent = WorkspaceOutter
                    WorkspaceInner.BackgroundColor3 = Library.Theme.VeryDarkContrast
                    WorkspaceInner.BorderColor3 = Library.Theme.Border
                    WorkspaceInner.NextSelectionUp = WorkspaceOutter
                    WorkspaceInner.Position = UDim2.new(0, 2, 0, 2)
                    WorkspaceInner.Size = UDim2.new(1, -4, 1, -4)

                    Tabs.Parent = WorkspaceInner
                    Tabs.BackgroundColor3 = Library.Theme.ElementOn
                    Tabs.BackgroundTransparency = 1.000
                    Tabs.BorderColor3 = Library.Theme.Border
                    Tabs.BorderSizePixel = 0
                    Tabs.Position = UDim2.new(0.0136363637, 0, 0, 0)
                    Tabs.Size = UDim2.new(1, -15, 0, 24)

                    TabsLayout.Parent = Tabs
                    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
                    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

                    PageArea.Parent = WorkspaceInner
                    PageArea.BackgroundColor3 = Library.Theme.LightContrast
                    PageArea.BorderColor3 = Library.Theme.Border
                    
                    PageArea.Position = UDim2.new(0, 7, 0, 25)
                    PageArea.Size = UDim2.new(1, -13, 1, -30)

                    PageAreaInner.Parent = PageArea
                    PageAreaInner.BackgroundColor3 = Library.Theme.DarkContrast
                    PageAreaInner.BorderColor3 = Library.Theme.Border
                    PageAreaInner.Position = UDim2.new(0, 2, 0, 2)
                    PageAreaInner.Size = UDim2.new(1, -4, 1, -4)

                    TabTransitioner.Parent = PageAreaInner;
                    TabTransitioner.BackgroundColor3 = Library.Theme.DarkContrast;
                    TabTransitioner.BorderSizePixel = 0;
                    TabTransitioner.Size = UDim2.new(1, -4, 1, -4);
                    TabTransitioner.Position = UDim2.new(0, 2, 0, 2);
                    TabTransitioner.ZIndex = 1000;
                    TabTransitioner.Name = "TabTransitioner";

                    TabTransitioner2.Parent = PageAreaInner;
                    TabTransitioner2.BackgroundColor3 = Library.Theme.DarkContrast;
                    TabTransitioner2.BorderSizePixel = 0;
                    TabTransitioner2.Size = UDim2.new(1, -4, 1, -24);
                    TabTransitioner2.Position = UDim2.new(0, 2, 0, 26);
                    TabTransitioner2.ZIndex = 1000;
                    TabTransitioner2.Name = "TabTransitioner2";

                    Title.Parent = WindowBorder
                    Title.BackgroundColor3 = Library.Theme.ElementOn
                    Title.BackgroundTransparency = 1.000
                    Title.BorderColor3 = Library.Theme.Border
                    Title.BorderSizePixel = 0
                    Title.Position = UDim2.new(0, 0, 0, 5);
                    Title.Size = UDim2.new(1, 0, 0, 15)
                    Title.FontFace = Library.MenuFont
                    Title.RichText = true;
                    Title.Text = ("Ethereal | <font color =\"rgb(%d, %d, %d)\"> %s</font>"):format(Library.Theme.Accent.R * 255, Library.Theme.Accent.G * 255, Library.Theme.Accent.B * 255, GameName);
                    Window.TitleLabel = Title;
                    Title.TextColor3 = Library.Theme.ElementOn
                    Title.TextSize = Library.TextSize
                end;

                do --// Setting some stuff in the window table (ignore)
                    Window.ResizeButton = Resizer;
                    Window.Border = WindowBorder;
                   -- Window.Image = PageAreaInner;
                end;

                do --// Window functions
                    do  --// Window connections
                        do  --// Dragging
                            WindowBorder.InputBegan:Connect(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
                                    Dragging = true;
                                    DragStart = Input.Position;
                                    StartPos = WindowBorder.Position;
                
                                    Input.Changed:Connect(function()
                                        if Input.UserInputState == Enum.UserInputState.End then 
                                            Dragging = false;
                                            VisibleBorder.BackgroundColor3 = Library.Theme.LightContrast
                                            WindowBorder.BackgroundColor3 = Library.Theme.LightContrast
                                        end;
                                    end);
                                end;
                            end);
                
                            WindowBorder.InputChanged:Connect(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then 
                                    DragInput = Input;
                                end;
                            end);
                        end;

                        do --// Resizer
                            Resizer.InputBegan:Connect(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                                    IsResizing = true;
                                    if not LastPosition then 
                                        StartSize = WindowBorder.AbsoluteSize;
                                        LastPosition = Vector2.new(Mouse.X, Mouse.Y);
                                    end;
                                    Input.Changed:Connect(function()
                                        if Input.UserInputState == Enum.UserInputState.End then 
                                            IsResizing = false;
                                            StartSize = WindowBorder.AbsoluteSize;
                                            LastPosition = nil;
                                        end;
                                    end);
                                end;
                            end);
        
                            Resizer.InputChanged:Connect(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then 
                                    ResizeInput = Input;
                                end;
                            end);
                        end;

                        do --// UserinputService
                            UserInputService.InputChanged:Connect(function(Input)
                                if Input == DragInput and Dragging then 
                                    Library:MakeDraggable(Input, WindowBorder, VisibleBorder);
                                end;

                                if Input == ResizeInput and IsResizing then 
                                    if LastPosition then 
                                        local MousePos = Vector2.new(Mouse.X, Mouse.Y);
                                        local Displacement = Vector2.new(MousePos.X - LastPosition.X, MousePos.Y - LastPosition.Y);
            
                                        local Scale = StartSize + Displacement;
                                        
                                        local ScaleX = Scale.X;
                                        local ScaleY = Scale.Y;

                                        if ScaleX > Window.DefaultSize.X.Offset then 
                                            WindowBorder.Size = UDim2.fromOffset(ScaleX, WindowBorder.Size.Y.Offset);
                                        end;
                                        
                                        if ScaleY > Window.DefaultSize.Y.Offset then 
                                            WindowBorder.Size = UDim2.fromOffset(WindowBorder.Size.X.Offset, ScaleY);
                                        end;
                                    end;
                                end;
                            end);

                        end;
                    end;

                    function Window:TransitionTab(IsNested, IsPrevious)
                        if not IsNested then
                            if not IsPrevious then 
                                Library:Tween(TabTransitioner, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0});
                                Library:Tween(TabTransitioner2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0});
                                task.wait(0.1);
                                Library:Tween(TabTransitioner, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                                Library:Tween(TabTransitioner2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                            else 
                                Library:Tween(TabTransitioner, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0});
                                task.wait(0.1);
                                Library:Tween(TabTransitioner, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                            end;
                        else
                            if not IsPrevious then 
                                Library:Tween(TabTransitioner2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0});
                                task.wait(0.1);
                                Library:Tween(TabTransitioner2, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                            end;
                        end;
                    end;    

                    function Window:CreateColorpicker(Parent, Name)
                        local ColorFrame = Instance.new("Frame")
                        local Innercolor = Instance.new("Frame")
                        local HueOutline = Instance.new("Frame")
                        local HuePicker = Instance.new("TextButton")
                        local UIGradient = Instance.new("UIGradient")
                        local HuePick = Instance.new("Frame")
                        local PickerOutline_3 = Instance.new("Frame")
                        local ColorPicker = Instance.new("ImageButton")
                        local ColorPick = Instance.new("Frame")
                        local TOutline = Instance.new("Frame")
                        local TransparencyPicker = Instance.new("ImageButton")
                        local TransparencyColor = Instance.new("ImageLabel")
                        local TransparencyPick = Instance.new("Frame")
                        local TitleFrame = Instance.new("Frame")
                        local ColorpickerTitle_2 = Instance.new("TextLabel")
                        
                        local CopyButtonOutter = Instance.new("Frame");
                        local CopyButton = Instance.new("TextButton");
                        local PasteButtonOutter = Instance.new("Frame");
                        local PasteButton = Instance.new("TextButton")

                        local SetBoxOutter = Instance.new("Frame");
                        local SetBox = Instance.new("TextBox");

                        --// Properties (its long)
                        do	
                            ColorFrame.Name = "ColorFrame"
                            ColorFrame.Parent = Parent 
                        
                            ColorFrame.BackgroundColor3 = Library.Theme.LightContrast
                            ColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            ColorFrame.BorderSizePixel = 0
                            --{-10, 0},{3, 0}
                            ColorFrame.Position = UDim2.new(-10, 20, 3, 0)
                            ColorFrame.Size = UDim2.new(0, 200, 0, 240);

                            ColorFrame.Visible = false
                            ColorFrame.ZIndex = 11;

                            Innercolor.Name = "Innercolor"
                            Innercolor.Parent = ColorFrame
                            Innercolor.BackgroundColor3 = Library.Theme.DarkContrast
                            Innercolor.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            Innercolor.BorderSizePixel = 1
                            Innercolor.Position = UDim2.new(0, 2, 0, 2)
                            Innercolor.Size = UDim2.new(1, -4, 1, -4)

                            HueOutline.Name = "HueOutline"
                            HueOutline.Parent = Innercolor
                            HueOutline.BackgroundColor3 = Library.Theme.LightContrast
                            HueOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            HueOutline.BorderSizePixel = 1
                            HueOutline.Position = UDim2.new(0.899999976, -5, 0.00600000005, 0)
                            HueOutline.Size = UDim2.new(0, 23, 0, 162)

                            HuePicker.Name = "HuePicker"
                            HuePicker.Parent = HueOutline
                            HuePicker.BackgroundColor3 = Color3.fromRGB(255,255,255)
                            HuePicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            HuePicker.BorderSizePixel = 1
                            HuePicker.Position = UDim2.new(0, 2, 0, 2)
                            HuePicker.Size = UDim2.new(1, -4, 1, -4)
                            HuePicker.AutoButtonColor = false
                            HuePicker.FontFace  = Library.MenuFont
                            HuePicker.Text = ""
                            HuePicker.TextColor3 = Color3.fromRGB(0, 0, 0)
                            HuePicker.TextSize = Library.TextSize

                            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
                            UIGradient.Rotation = 90
                            UIGradient.Parent = HuePicker

                            HuePick.Name = "HuePick"
                            HuePick.Parent = HuePicker
                            HuePick.BackgroundColor3 = Library.Theme.ElementOn
                            HuePick.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            HuePick.Size = UDim2.new(1, 0, 0, 1)

                            PickerOutline_3.Name = "PickerOutline"
                            PickerOutline_3.Parent = Innercolor
                            PickerOutline_3.BackgroundColor3 = Library.Theme.LightContrast
                            PickerOutline_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            PickerOutline_3.BorderSizePixel = 1
                            PickerOutline_3.Position = UDim2.new(0, 2, 0, 2) 
                            PickerOutline_3.Size = UDim2.new(0, 162, 0, 162)

                            ColorPicker.Name = "ColorPicker"
                            ColorPicker.Parent = PickerOutline_3
                            ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            ColorPicker.BorderSizePixel = 1
                            ColorPicker.Position = UDim2.new(0, 2, 0, 2)
                            ColorPicker.Size = UDim2.new(1, -4, 1, -4)
                            ColorPicker.Image = "rbxassetid://4155801252"
                            ColorPicker.ImageColor3 = Color3.fromRGB(255, 0, 2)
                            ColorPicker.AutoButtonColor = false;
                            
                            ColorPick.Name = "ColorPick"
                            ColorPick.Parent = ColorPicker
                            ColorPick.BackgroundColor3 = Library.Theme.ElementOn
                            ColorPick.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            ColorPick.Size = UDim2.new(0, 1, 0, 1)

                            TOutline.Name = "TOutline"
                            TOutline.Parent = Innercolor
                            TOutline.BackgroundColor3 = Library.Theme.LightContrast
                            TOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            TOutline.BorderSizePixel = 1
                            TOutline.Position = UDim2.new(0, 2, 0, 169)
                            TOutline.Size = UDim2.new(1, -4, 0, 20)

                            TransparencyPicker.Name = "TransparencyPicker"
                            TransparencyPicker.Parent = TOutline
                            TransparencyPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            TransparencyPicker.BackgroundTransparency = 0
                            TransparencyPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            TransparencyPicker.BorderSizePixel = 0;
                            TransparencyPicker.Position = UDim2.new(0, 2, 0, 2)
                            TransparencyPicker.Size = UDim2.new(1, -4, 1, -4)
                            TransparencyPicker.ScaleType = Enum.ScaleType.Tile
                            TransparencyPicker.TileSize = UDim2.new(0, 10, 0, 10)
                            TransparencyPicker.AutoButtonColor = false;

                            TransparencyColor.Name = "TransparencyColor"
                            TransparencyColor.Parent = TransparencyPicker
                            TransparencyColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            TransparencyColor.BackgroundTransparency = 0;
                            TransparencyColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            TransparencyColor.BorderSizePixel = 1;
                            TransparencyColor.Size = UDim2.new(1, 0, 1, 0)
                            TransparencyColor.Position = UDim2.new(0, 0, 0, 0)
                            TransparencyColor.Image = "rbxassetid://3887017050"
                            TransparencyColor.ImageColor3 = Color3.fromRGB(255, 0, 0)

                            TransparencyPick.Name = "TransparencyPick"
                            TransparencyPick.Parent = TransparencyPicker
                            TransparencyPick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            TransparencyPick.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            TransparencyPick.Size = UDim2.new(0, 1, 1, 0)

                            TitleFrame.Name = "TitleFrame"
                            TitleFrame.Parent = ColorFrame
                            TitleFrame.BackgroundColor3 = Library.Theme.LightContrast
                            TitleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            TitleFrame.BorderSizePixel = 0
                            TitleFrame.Position = UDim2.new(0, 0, 0, -14)
                            TitleFrame.Size = UDim2.new(1, 0, 0, 15)

                            ColorpickerTitle_2.Name = "ColorpickerTitle"
                            ColorpickerTitle_2.Parent = TitleFrame
                            ColorpickerTitle_2.BackgroundColor3 = Library.Theme.MedianContrast
                            ColorpickerTitle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            ColorpickerTitle_2.BorderSizePixel = 1
                            ColorpickerTitle_2.Position = UDim2.new(0, 2, 0, 2)
                            ColorpickerTitle_2.Size = UDim2.new(1, -4, 1, -4)
                            ColorpickerTitle_2.FontFace  = Library.MenuFont
                            ColorpickerTitle_2.Text = Name
                            ColorpickerTitle_2.TextColor3 = Library.Theme.ElementOn
                            ColorpickerTitle_2.TextSize = Library.TextSize
                            ColorpickerTitle_2.TextWrapped = true;

                            CopyButtonOutter.Name = "Copy"
                            CopyButtonOutter.Parent = Innercolor
                            CopyButtonOutter.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
                            CopyButtonOutter.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            CopyButtonOutter.Position = UDim2.new(0, 2, 0, 193)
                            CopyButtonOutter.Size = UDim2.new(0, 93, 0, 18)
    
                            CopyButton.Name = "CopyButton"
                            CopyButton.Parent = CopyButtonOutter
                            CopyButton.BackgroundColor3 = Library.Theme.MedianContrast
                            CopyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            CopyButton.Position = UDim2.new(0, 2, 0, 2)
                            CopyButton.Size = UDim2.new(1, -4, 1, -4)
                            CopyButton.FontFace = Library.MenuFont;
                            CopyButton.Text = "Copy"
                            CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            CopyButton.TextSize = Library.TextSize
                            CopyButton.AutoButtonColor = false;
    
                            PasteButtonOutter.Name = "Paster"
                            PasteButtonOutter.Parent = Innercolor
                            PasteButtonOutter.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
                            PasteButtonOutter.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            PasteButtonOutter.Position = UDim2.new(0, 101, 0, 193)
                            PasteButtonOutter.Size = UDim2.new(0, 93, 0, 18)
    
                            PasteButton.Name = "PasteButton"
                            PasteButton.Parent = PasteButtonOutter
                            PasteButton.BackgroundColor3 = Library.Theme.MedianContrast
                            PasteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            PasteButton.Position = UDim2.new(0, 2, 0, 2)
                            PasteButton.Size = UDim2.new(1, -4, 1, -4)
                            PasteButton.FontFace = Library.MenuFont;
                            PasteButton.AutoButtonColor = false;
                            PasteButton.Text = "Paste"
                            PasteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            PasteButton.TextSize = Library.TextSize

                            SetBoxOutter.Name = "Setbox"
                            SetBoxOutter.Parent = Innercolor
                            SetBoxOutter.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
                            SetBoxOutter.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            SetBoxOutter.Position = UDim2.new(0, 2, 0, 216)
                            SetBoxOutter.Size = UDim2.new(0, 192, 0, 18)
    
                            SetBox.Name = "SetBox"
                            SetBox.Parent = SetBoxOutter
                            SetBox.BackgroundColor3 = Library.Theme.MedianContrast
                            SetBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            SetBox.Position = UDim2.new(0, 2, 0, 2)
                            SetBox.Size = UDim2.new(1, -4, 1, -4)
                            SetBox.FontFace = Library.MenuFont;
                            SetBox.Text = "";
                            SetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                            SetBox.TextSize = Library.TextSize
                        end;

                        return ColorFrame, InnerColor, HueOutline, HuePicker, UIGradient, HuePick, PickerOutline_3, HuePick, ColorPicker, ColorPick, TOutline, TransparencyPicker, TransparencyColor, TransparencyPick, TitleFrame, ColorpickerTitle_2, PasteButton, CopyButton, SetBox

                    end;

                    function Window:SetTab(Name)
                        Window.CurrentTab = Name;
                        Window:TransitionTab(false, false);
                        for Index, Value in next, Window.Tabs do
                            if not Value.Name:find("Nested") then
                                local TabName = Value.Name;
                                local TabButton = Value.Button;
                                --local Underline = Value.Underline;
                                if Name ~= TabName then
                                    Library:Tween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                    --Library:Tween(Underline, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                                    Value.Page.Visible = false;
                                    Value.IsOpen = false;
                                    if Value.IncludeNested then
                                        for Index2, Value2 in next, Value.NestedTabs do 
                                            Value2.Page.Visible = false;
                                            Value2.IsOpen = false;

                                            if Value2.Button then 
                                                Library:Tween(Value2.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                --Library:Tween(Value2.Underline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0});
                                            end;
                                        end;
                                    end;
                                else 
                                    Library:Tween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                    --Library:Tween(Underline, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0});
                                    Value.Page.Visible = true;
                                    Value.IsOpen = true;
                                    if Value.LastOpenedTab then 
                                        Value:SetTab(Value.LastOpenedTab, true)
                                    end;
                                end;
                            end;
                        end;
                    end;

                    function Window:UpdateTabs()
                        local TabSize = Tabs.AbsoluteSize.X / Window.TabAmount;
                        for Index, Value in next, Window.Tabs do 
                            Value.Button.Size = UDim2.new(0, TabSize, 0, 26);
                        end;
                    end;

                    function Window:NewTab(Data)
                        local Tab = {
                            Name = Data.Name;
                            Sections = {};
                            NestedTabs = {};
                            Page = nil;
                            IsOpen = false;
                            SectionZIndex = 1000;
                            IncludeNested = Data.IncludeNested;
                            Left = nil;
                            Right = nil;
                            TabAmount = 0;
                            LastOpenedTab = nil;
                            IsPlayerlist = Data.IsPlayerlist;
                            Playerlist = {};
                            SelectedPlayer = nil;
                        };
                        Window.TabAmount = Window.TabAmount + 1;

                        Tab.__index = Tab;

                        local Left, Right
                        local CurrentPage = Instance.new("ImageLabel");
                        local NestedTabsOutline, NestedTabs = nil, nil

                        do --// Elements
                            local TabButton = Instance.new("TextButton");
                            --local TabUnderline = Instance.new("Frame");
                            local TabGradient = Instance.new("UIGradient");

                            Left = Instance.new("Frame");
                            local LeftPadding = Instance.new("UIPadding");
                            local LeftListLayout = Instance.new("UIListLayout");

                            Tab.Left = Left;

                            Right = Instance.new("Frame");
                            local RightListLayout = Instance.new("UIListLayout");
                            local RightPadding = Instance.new("UIPadding");

                            Tab.Right = Right;

                            do --// Tab element properties
                                CurrentPage.Name = "Page"..Data.Name;
                                CurrentPage.Parent = PageAreaInner
                                CurrentPage.BackgroundColor3 = Library.Theme.ElementOn
                                CurrentPage.BackgroundTransparency = 1.000;
                                CurrentPage.ImageTransparency = 1;
                                CurrentPage.BorderColor3 = Library.Theme.Border
                                CurrentPage.BorderSizePixel = 0
                                CurrentPage.Position = UDim2.new(0, 0, 0, 0)
                                CurrentPage.Size = UDim2.new(1, 0, 1, -5);
        
                                CurrentPage.Visible = false;

                                Left.Name = "Left"
                                Left.Parent = CurrentPage
                                Left.BackgroundColor3 = Library.Theme.ElementOn
                                Left.BackgroundTransparency = 1.000
                                Left.BorderColor3 = Library.Theme.Border
                                Left.BorderSizePixel = 0
                                Left.Size = UDim2.new(0.5, -3, 1, 0)

                                LeftPadding.Name = "LeftPadding"
                                LeftPadding.Parent = Tab.Left
                                LeftPadding.PaddingTop = UDim.new(0, 9)
                                LeftPadding.PaddingLeft = UDim.new(0, 2);

                                LeftListLayout.Name = "LeftListLayout"
                                LeftListLayout.Parent = Tab.Left
                                LeftListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                LeftListLayout.Padding = UDim.new(0, 8);

                                Right.Name = "Right"
                                Right.Parent = CurrentPage
                                Right.BackgroundColor3 = Library.Theme.ElementOn
                                Right.BackgroundTransparency = 1.000
                                Right.BorderColor3 = Library.Theme.Border
                                Right.BorderSizePixel = 0
                                Right.Position = UDim2.new(0.5, 3, 0, 0)
                                Right.Size = UDim2.new(0.5, -3, 1, 0)

                                RightListLayout.Name = "RightListLayout"
                                RightListLayout.Parent = Tab.Right
                                RightListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                RightListLayout.Padding = UDim.new(0, 8);

                                RightPadding.Name = "RightPadding";
                                RightPadding.Parent = Tab.Right;
                                RightPadding.PaddingTop = UDim.new(0, 9);
                                RightPadding.PaddingRight = UDim.new(0, 2);

                                TabButton.Name = "TabButton"
                                TabButton.Parent = Tabs
                                TabButton.BackgroundColor3 = Library.Theme.ElementOn
                                TabButton.BackgroundTransparency = 1.000
                                TabButton.BorderColor3 = Library.Theme.Border
                                TabButton.BorderSizePixel = 0
                                TabButton.Size = UDim2.new(0, TabSize, 0, 26)
                                TabButton.FontFace = Library.MenuFont
                                TabButton.Text = Tab.Name;
                                Tab.Button = TabButton;

                                TabButton.TextColor3 = Library.Theme.ElementOff
                                TabButton.TextSize = Library.TextSize

                                --[[TabUnderline.Name = "TabUnderline"
                                TabUnderline.Parent = TabButton
                                TabUnderline.BackgroundColor3 = Library.Theme.ElementOn
                                TabUnderline.BorderColor3 = Library.Theme.Border
                                TabUnderline.BorderSizePixel = 0
                                TabUnderline.Position = UDim2.new(0, 0, 1, -5)
                                TabUnderline.Size = UDim2.new(1, 0, 0, 1)
                                TabUnderline.BackgroundTransparency = 1;
                                TabUnderline.Visible = true;]]

                                --Tab.Underline = TabUnderline;
                                --TabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Library.Theme.DarkContrast), ColorSequenceKeypoint.new(0.50, Library.Theme.Accent), ColorSequenceKeypoint.new(1.00, Library.Theme.DarkContrast)}
                                --TabGradient.Name = "TabGradient"
                                --TabGradient.Parent = TabUnderline

                                TabButton.MouseButton1Down:Connect(function()
                                    Window:SetTab(Tab.Name);
                                end);
                                TabButton.MouseEnter:Connect(function()
                                    Library:Tween(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                end);
                                TabButton.MouseLeave:Connect(function()
                                    if Tab.IsOpen == false or not Tab.IsOpen then 
                                        Library:Tween(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                    end;
                                end);
                            end;

                            do --// If is nested
                                if Data.IncludeNested then 
                                    NestedTabsOutline = Instance.new("Frame");
                                    NestedTabs = Instance.new("Frame");

                                    local NestedLayout = Instance.new("UIListLayout");

                                    do --// Properties
                                        
                                        NestedTabsOutline.Parent = CurrentPage;
                                        NestedTabsOutline.BorderColor3 = Library.Theme.Border;
                                        NestedTabsOutline.Size = UDim2.new(1, 0, 0, 24);
                                        NestedTabsOutline.BackgroundColor3 = Library.Theme.LightContrast;

                                        NestedTabs.Parent = NestedTabsOutline;
                                        NestedTabs.Size = UDim2.new(1, -4, 1, -4);
                                        NestedTabs.Position = UDim2.new(0, 2, 0, 2);
                                        NestedTabs.BackgroundColor3 = Library.Theme.DarkContrast;
                                        NestedTabs.BorderColor3 = Library.Theme.Border;

                                        NestedLayout.Parent = NestedTabs
                                        NestedLayout.FillDirection = Enum.FillDirection.Horizontal
                                        NestedLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                    end;
                                end;
                            end;

                            Tab.Page = CurrentPage;

                        function Tab:Update()
                            Tab.TabAmount = Tab.TabAmount + 1;

                            for Index, Value in next, Tab.NestedTabs do
                                Value.Button.Size = UDim2.new(0, NestedTabs.AbsoluteSize.X / Tab.TabAmount, 0, Value.Button.Size.Y.Offset);
                            end;
                        end;

                        function Tab:Add(Data)
                            local NewTab = {
                                Name = Data.Name;
                                Page = nil;
                                SectionZIndex = 1000;
                                Sections = {};
                                Parent = Tab;
                                IsOpen = false;
                                Left = nil;
                                Right = nil;
                                CurrentTab = nil;
                            };

                            do --// Elements
                                local NewPage = Instance.new("ImageLabel");

                                local TabButton = Instance.new("TextButton");
                               -- local TabUnderline = Instance.new("Frame");
                                local TabGradient = Instance.new("UIGradient");
    
                                Left = Instance.new("Frame");
                                local LeftPadding = Instance.new("UIPadding");
                                local LeftListLayout = Instance.new("UIListLayout");
    
                                NewTab.Left = Left;
    
                                Right = Instance.new("Frame");
                                local RightListLayout = Instance.new("UIListLayout");
                                local RightPadding = Instance.new("UIPadding");
    
                                NewTab.Right = Right;
                                
                                NewTab.Page = NewPage;

                                do --// Tab element properties
                                    NewPage.Name = "NestedPage"..Data.Name;
                                    NewPage.Parent = PageAreaInner
                                    NewPage.BackgroundColor3 = Library.Theme.ElementOn
                                    NewPage.BackgroundTransparency = 1.000;
                                    NewPage.ImageTransparency = 1;
                                    NewPage.BorderColor3 = Library.Theme.Border
                                    NewPage.BorderSizePixel = 0
                                    NewPage.Position = UDim2.new(0, 0, 0, 0)
                                    NewPage.Size = UDim2.new(1, 0, 1, -20);
            
                                    NewPage.Visible = false;
    
                                    Left.Name = "Left"
                                    Left.Parent = NewPage;
                                    Left.BackgroundColor3 = Library.Theme.ElementOn
                                    Left.BackgroundTransparency = 1.000
                                    Left.BorderColor3 = Library.Theme.Border
                                    Left.BorderSizePixel = 0
                                    Left.Size = UDim2.new(0.5, -3, 1, 0)
                                    Left.Position = UDim2.new(0, 0, 0, 24);
    
                                    LeftPadding.Name = "LeftPadding"
                                    LeftPadding.Parent = NewTab.Left
                                    LeftPadding.PaddingTop = UDim.new(0, 9)
    
                                    LeftListLayout.Name = "LeftListLayout"
                                    LeftListLayout.Parent = NewTab.Left
                                    LeftListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                    LeftListLayout.Padding = UDim.new(0, 8);
    
                                    Right.Name = "Right"
                                    Right.Parent = NewPage
                                    Right.BackgroundColor3 = Library.Theme.ElementOn
                                    Right.BackgroundTransparency = 1.000
                                    Right.BorderColor3 = Library.Theme.Border
                                    Right.BorderSizePixel = 0
                                    Right.Position = UDim2.new(0.5, 3, 0, 24)
                                    Right.Size = UDim2.new(0.5, -3, 1, 0)
    
                                    RightListLayout.Name = "RightListLayout"
                                    RightListLayout.Parent = NewTab.Right
                                    RightListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                    RightListLayout.Padding = UDim.new(0, 8);
    
                                    RightPadding.Name = "RightPadding"
                                    RightPadding.Parent = NewTab.Right
                                    RightPadding.PaddingTop = UDim.new(0, 9)
    
                                    TabButton.Name = "TabButton"
                                    TabButton.Parent = NestedTabs
                                    TabButton.BackgroundColor3 = Library.Theme.ElementOn
                                    TabButton.BackgroundTransparency = 1.000
                                    TabButton.BorderColor3 = Library.Theme.Border
                                    TabButton.BorderSizePixel = 0
                                    TabButton.Size = UDim2.new(0, NestedTabs.AbsoluteSize.X / Tab.TabAmount, 0, 24)
                                    TabButton.FontFace = Library.MenuFont
                                    TabButton.Text = NewTab.Name;
                                    NewTab.Button = TabButton;
    
                                    TabButton.TextColor3 = Library.Theme.ElementOff
                                    TabButton.TextSize = Library.TextSize
    
                                    --[[TabUnderline.Name = "TabUnderline"
                                    TabUnderline.Parent = TabButton
                                    TabUnderline.BackgroundColor3 = Library.Theme.ElementOn
                                    TabUnderline.BorderColor3 = Library.Theme.Border
                                    TabUnderline.BorderSizePixel = 0
                                    TabUnderline.Position = UDim2.new(0, 0, 1, -5)
                                    TabUnderline.Size = UDim2.new(1, 0, 0, 1)
                                    TabUnderline.BackgroundTransparency = 1;
                                    TabUnderline.Visible = false;]]
    
                                    --NewTab.Underline = TabUnderline;
                                   -- TabGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Library.Theme.DarkContrast), ColorSequenceKeypoint.new(0.50, Library.Theme.Accent), ColorSequenceKeypoint.new(1.00, Library.Theme.DarkContrast)}
                                    --TabGradient.Name = "TabGradient"
                                    --TabGradient.Parent = TabUnderline
    
                                    TabButton.MouseButton1Down:Connect(function()
                                        Tab:SetTab(NewTab.Name);
                                    end);
                                    TabButton.MouseEnter:Connect(function()
                                        if Tab.CurrentTab == NewTab.Name then 
                                            Library:Tween(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Accent});
                                        else 
                                            Library:Tween(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                        end;
                                    end);
                                    TabButton.MouseLeave:Connect(function()
                                        if NewTab.IsOpen == false or not NewTab.IsOpen then 
                                            Library:Tween(TabButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                        end;
                                    end);
                                end;
                            end;

                            Tab.NestedTabs[Data.Name] = NewTab;
                            Tab:Update()
                            return setmetatable(NewTab, Tab);
                        end;

                        function Tab:SetTab(Name, ShouldTransition)
                            Tab.CurrentTab = Name;
                            if not ShouldTransition then 
                                Window:TransitionTab(true, false);
                            end;
                            for Index, Value in next, Tab.NestedTabs do 
                                local TabName = Value.Name;
                                local TabButton = Value.Button;
                                --local Underline = Value.Underline;
                                if Name ~= TabName then
                                    Library:Tween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                    --Library:Tween(Underline, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                                    Value.Page.Visible = false;
                                    Value.IsOpen = false;
                                else
                                    Library:Tween(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Accent});
                                    Value.Page.Visible = true;
                                    Value.IsOpen = true;
                                    Tab.LastOpenedTab = Name;
                                end;    
                            end;
                        end;

                        function Tab:NewSection(Data)
                            local Section = {
                                Name = Data.Name;
                                Side = Data.Side;
                                DropdownZIndex = 10000;
                                Bounds = 14;
                            };  

                            local SectionTitle = Instance.new("TextLabel");
                            local SectionBorder = Instance.new("Frame");
                            local SectionInner = Instance.new("Frame");
                            local SectionAccent = Instance.new("Frame");
                            local SectionGradient = Instance.new("UIGradient");

                            do --// Section Element Properties
                                SectionBorder.Name = "SectionBorder"
                                SectionBorder.BackgroundColor3 = Library.Theme.LightContrast
                                SectionBorder.BorderColor3 = Library.Theme.Border
                                SectionBorder.Size = UDim2.new(1, 0, 0, 34)
                                SectionBorder.ZIndex = self.SectionZIndex;


                                self.SectionZIndex = self.SectionZIndex - 1;
                                if Section.Side == "Left" then 
                                    SectionBorder.Parent = self.Left; 
                                elseif Section.Side == "Right" then 
                                    SectionBorder.Parent = self.Right;
                                else 
                                    SectionBorder.Parent = self.Left;
                                end;

                                SectionInner.Name = "SectionInner"
                                SectionInner.Parent = SectionBorder
                                SectionInner.BackgroundColor3 = Library.Theme.DarkContrast
                                SectionInner.BorderColor3 = Library.Theme.Border
                                SectionInner.Position = UDim2.new(0, 2, 0, 2)
                                SectionInner.Size = UDim2.new(1, -4, 1, -4)

                                SectionAccent.Name = "SectionAccent"
                                SectionAccent.Parent = SectionInner
                                SectionAccent.BackgroundColor3 = Library.Theme.ElementOn
                                SectionAccent.BorderColor3 = Library.Theme.Border
                                SectionAccent.BorderSizePixel = 0
                                SectionAccent.Size = UDim2.new(1, 0, 0, 1)

                                SectionGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Library.Theme.GradiantContrast), ColorSequenceKeypoint.new(0.50, Library.Theme.Accent), ColorSequenceKeypoint.new(1.00, Library.Theme.GradiantContrast)}
                                SectionGradient.Name = "SectionGradient"
                                SectionGradient.Parent = SectionAccent;

                                SectionTitle.Name = "SectionTitle"
                                SectionTitle.Parent = SectionBorder
                                SectionTitle.BackgroundColor3 = Library.Theme.DarkContrast
                                SectionTitle.BorderColor3 = Library.Theme.Border
                                SectionTitle.BorderSizePixel = 0
                                SectionTitle.Position = UDim2.new(0, 10, 0, -3)
                                SectionTitle.Size = UDim2.new(0, 68, 0, 12)
                                SectionTitle.FontFace = Library.MenuFont
                                SectionTitle.Text = Section.Name
                                SectionTitle.TextColor3 = Library.Theme.ElementOn
                                SectionTitle.TextSize = Library.TextSize
                                SectionTitle.TextYAlignment = Enum.TextYAlignment.Top;

                                SectionTitle:GetPropertyChangedSignal("TextBounds"):Connect(function()
                                    SectionTitle.Size = UDim2.new(0, 5 + SectionTitle.TextBounds.X, 0, 14)
                                end);
                            end;

                            do --// Section Functions

                                --// Button
                                function Section:Button(Data)
                                    local Button = {
                                        Callback = Data.Callback,
                                        ParentSection = Section,
                                        Name = Data.Name,
                                        Frame = nil;
                                    };

                                    local NewButton = Instance.new("Frame")
                                    local ActualButton = Instance.new("TextButton")

                                    Button.Frame = NewButton;
                                    do --// Button element properties
                                        NewButton.Name = "NewButton"
                                        NewButton.Parent = SectionInner
                                        NewButton.BackgroundColor3 = Library.Theme.LightContrast
                                        NewButton.BorderColor3 = Library.Theme.Border
                                        NewButton.Position = UDim2.new(0, 2, 0, Section.Bounds)
                                        NewButton.Size = UDim2.new(1, -4, 0, 18)

                                        ActualButton.Name = "ActualButton"
                                        ActualButton.Parent = NewButton
                                        ActualButton.BackgroundColor3 = Library.Theme.MedianContrast
                                        ActualButton.BorderColor3 = Library.Theme.Border
                                        ActualButton.Position = UDim2.new(0, 2, 0, 2)
                                        ActualButton.Size = UDim2.new(1, -4, 1, -4)
                                        ActualButton.AutoButtonColor = false
                                        ActualButton.FontFace = Library.MenuFont
                                        ActualButton.TextColor3 = Library.Theme.ElementOn
                                        ActualButton.TextSize = Library.TextSize
                                        ActualButton.Text = Button.Name
                                        ActualButton.TextYAlignment = Enum.TextYAlignment.Center
                                    end;

                                    --// Button functions 
                                    do 
                                        ActualButton.MouseButton1Down:Connect(function()
                                            if Button.Callback then pcall(Button.Callback) end;
                                            Library:Tween(ActualButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                            task.wait(0.1)
                                            Library:Tween(ActualButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                        end);
                                        
                                        ActualButton.MouseEnter:Connect(function()
                                            Library:Tween(NewButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                        end);

                                        ActualButton.MouseLeave:Connect(function()
                                            Library:Tween(NewButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                        end);
                                    end;
                                    Section.Bounds = Section.Bounds + 23
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);
                                end;

                                --// Textbox
                                function Section:Textbox(Data)
                                    local TextBox = {
                                        Value = "";
                                        Frame = nil;
                                    };
            
                                    TextBox.Value = Data.Default or "";
                                    TextBox.Name = Data.Name;
            
                                    local NewTextbox = Instance.new("Frame")
                                    local TextboxInp = Instance.new("TextBox")

                                    TextBox.Frame = NewTextbox;

                                    do --// Properties
                                        Library.Flags[Data.Flag] = TextBox.Value;
                
                                        NewTextbox.Name = "NewTextbox"
                                        NewTextbox.Parent = SectionInner
                                        NewTextbox.BackgroundColor3 = Library.Theme.LightContrast
                                        NewTextbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        NewTextbox.BorderSizePixel = 1
                                        NewTextbox.Position = UDim2.new(0, 1, 0, Section.Bounds)
                                        NewTextbox.Size = UDim2.new(1, -4, 0, 18);
                
                                        TextboxInp.Name = "TextboxInp"
                                        TextboxInp.Parent = NewTextbox
                                        TextboxInp.BackgroundColor3 = Library.Theme.MedianContrast
                                        TextboxInp.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        TextboxInp.BorderSizePixel = 1
                                        TextboxInp.Position = UDim2.new(0, 2, 0, 2)
                                        TextboxInp.Size = UDim2.new(1, -4, 1, -4)
                                        TextboxInp.FontFace = Library.MenuFont
                                        TextboxInp.PlaceholderColor3 = Library.Theme.ElementOff
                                        TextboxInp.Text = Data.Name;
                                        TextboxInp.TextColor3 = Library.Theme.ElementOff
                                        TextboxInp.TextSize = Library.TextSize

                                        TextboxInp.ClipsDescendants = true
                                    end;

                                    do --// Functions
                                        function TextBox:Set(Value)
                                            TextBox.Value = Value;
                                        end;

                                        TextboxInp.MouseEnter:Connect(function()
                                            Library:Tween(NewTextbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                            Library:Tween(TextboxInp, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                        end);
                
                                        TextboxInp.MouseLeave:Connect(function()
                                            Library:Tween(NewTextbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                            Library:Tween(TextboxInp, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                        end);
                
                                        TextboxInp.Focused:Connect(function()
                                            Library:Tween(TextboxInp, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                            task.wait(0.1);
                                            Library:Tween(TextboxInp, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                        end);
                
                                        TextboxInp.FocusLost:Connect(function(IsEnter, Inpt)
                                            Library:Tween(TextboxInp, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                            task.wait(0.1);
                                            Library:Tween(TextboxInp, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});

                                            TextBox:Set(TextboxInp.Text)
                                        end);

                                        TextboxInp:GetPropertyChangedSignal("Text"):Connect(function()
                                            TextBox:Set(TextboxInp.Text);
                                        end);
                                    end;

                                    Section.Bounds = Section.Bounds + 20;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);
                                    Library.Flags[Data.Flag] = TextBox;
                                    return TextBox;
                                end;

                                --// Toggle
                                function Section:Toggle(Data)
                                    local Toggle = {
                                        Flag = Data.Flag;
                                        Name = Data.Name;
                                        Value = false;
                                        Callback = Data.Callback or function() end;
                                        Risky = Data.Risky;
                                        Default = Data.Default;
                                        Frame = nil;
                                    };

                                    local NewToggle = Instance.new("TextButton")
                                    local ButtonOutline = Instance.new("Frame")
                                    local ButtonInner = Instance.new("Frame")
                                    local ToggleGradient = Instance.new("UIGradient")
                                    local ToggleTitle = Instance.new("TextLabel");
                                    local Items = Instance.new("Frame");

                                    Toggle.Frame = NewToggle;

                                    do --// Toggle properties                                  
                                        NewToggle.Name = "NewToggle"
                                        NewToggle.Parent = SectionInner
                                        NewToggle.BackgroundColor3 = Library.Theme.ElementOn
                                        NewToggle.BackgroundTransparency = 1.000
                                        NewToggle.BorderColor3 = Library.Theme.Border
                                        NewToggle.BorderSizePixel = 0
                                        NewToggle.Position = UDim2.new(0, 2, 0, Section.Bounds)
                                        NewToggle.Size = UDim2.new(1, -4, 0, 18)
                                        NewToggle.FontFace = Library.MenuFont
                                        NewToggle.Text = ""
                                        NewToggle.TextColor3 = Library.Theme.Border
                                        NewToggle.TextSize = Library.TextSize
                                        NewToggle.ZIndex = Window.ImportantIndex;

                                        Window.ImportantIndex = Window.ImportantIndex-1

                                        ButtonOutline.Name = "ButtonOutline"
                                        ButtonOutline.Parent = NewToggle
                                        ButtonOutline.BackgroundColor3 = Library.Theme.LightContrast
                                        ButtonOutline.BorderColor3 = Library.Theme.Border
                                        ButtonOutline.Size = UDim2.new(0, 18, 0, 18)

                                        ButtonInner.Name = "ButtonInner"
                                        ButtonInner.Parent = ButtonOutline
                                        ButtonInner.BackgroundColor3 = Library.Theme.MedianContrast;
                                        ButtonInner.BorderColor3 = Library.Theme.Border
                                        ButtonInner.Position = UDim2.new(0, 2, 0, 2)
                                        ButtonInner.Size = UDim2.new(1, -4, 1, -4)

                                        ToggleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Library.Theme.Accent), ColorSequenceKeypoint.new(1.00, Library.Theme.GradiantContrast2)}
                                        ToggleGradient.Rotation = 90
                                        ToggleGradient.Name = "ToggleGradient"
                                        ToggleGradient.Parent = ButtonInner
                                        ToggleGradient.Enabled = false;

                                        ToggleTitle.Name = "ToggleTitle"
                                        ToggleTitle.Parent = NewToggle
                                        ToggleTitle.BackgroundColor3 = Library.Theme.ElementOn
                                        ToggleTitle.BackgroundTransparency = 1.000
                                        ToggleTitle.BorderColor3 = Library.Theme.Border
                                        ToggleTitle.BorderSizePixel = 0
                                        ToggleTitle.Position = UDim2.new(0, 23, 0, 2)
                                        ToggleTitle.Size = UDim2.new(0, 176, 0, 16)
                                        ToggleTitle.FontFace = Library.MenuFont
                                        ToggleTitle.Text = Toggle.Name;

                                        if not Toggle.Risky then 
                                            ToggleTitle.TextColor3 = Library.Theme.ElementOff
                                        else 
                                            ToggleTitle.TextColor3 = Library.Theme.RiskyOff;
                                        end;
                                        ToggleTitle.TextSize = Library.TextSize
                                        ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                                        --// Toggle items (keybinds, colorpickers, etc)
                                        do
                                            Items.Parent = NewToggle;
                                            Items.Size = UDim2.new(0, 40, 0, 14);
                                            Items.Position = UDim2.new(1, -42, 0, 0);
                                            Items.BackgroundTransparency = 1;


                                            local ItemsLayout = Instance.new("UIListLayout", Items);
                                            ItemsLayout.FillDirection = Enum.FillDirection.Horizontal;
                                            ItemsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
                                            ItemsLayout.Padding = UDim.new(0, 3)
                                            local ItemsPadding = Instance.new("UIPadding", Items);
                                            ItemsPadding.PaddingRight = UDim.new(0, -1);
                                        end;
                                    end;

                                    do --// Toggle functions 

                                        function Toggle:Set(Value)

                                            Toggle.Value = Value; 

                                            if Toggle.Value then
                                                ToggleGradient.Enabled = true;
                                                Library:Tween(ButtonInner, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)});
                                                if not Toggle.Risky then 
                                                    Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                                else 
                                                    Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.RiskyOn});
                                                end;
                                            else
                                                task.spawn(function()
                                                    local NewTween = Library:Tween(ButtonInner, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                                    NewTween.Completed:Wait();
                                                    ToggleGradient.Enabled = false;
                                                end);
                                                if not Toggle.Risky then 
                                                    Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                else 
                                                    Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.RiskyOff});
                                                end;
                                            end;
                                            if Toggle.Callback then pcall(Toggle.Callback) end;
                                        end;

                                        NewToggle.MouseButton1Down:Connect(function()
                                            Toggle:Set(not Toggle.Value);
                                        end);
                                        
                                        NewToggle.MouseEnter:Connect(function()
                                            if not Toggle.Risky then 
                                                Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                            else 
                                                Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.RiskyOn});
                                            end;

                                            Library:Tween(ButtonOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                        end);

                                        NewToggle.MouseLeave:Connect(function()
                                            Library:Tween(ButtonOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                            if not Toggle.Value then 
                                                if not Toggle.Risky then 
                                                    Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                else 
                                                    Library:Tween(ToggleTitle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.RiskyOff});
                                                end;
                                            end
                                        end);

                                        function Toggle:Colorpicker(Data)
                                            local ColorPickerTab = {Color = Color3.fromRGB(255,255,255), Transparency = 0.1};
                
                                            local Name = Data.Name;
                                            local Flag = Data.Flag;
                                            local DefaultTransparency = Data.DefaultTrans or 0.5
                                            if Data.Default == nil then Data.Default = Color3.fromRGB(255,0,0) end;
                
                                            --Library.Flags[Data.Flag] = {Set = nil, Color = Data.Default, Transparency = DefaultTransparency};
                
                                            ColorPickerTab.IsOpen = false;
                
                                            local PickerOutline = Instance.new("Frame")
                                            local PickerButton = Instance.new("TextButton")

                                            PickerOutline.Name = "PickerOutline"
                                            PickerOutline.Parent = Items
                                            PickerOutline.BackgroundColor3 = Library.Theme.LightContrast
                                            PickerOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            PickerOutline.BorderSizePixel = 1
                                            PickerOutline.Size = UDim2.new(0, 20, 0, 15)
            
                                            PickerButton.Name = "PickerButton"
                                            PickerButton.Parent = PickerOutline
                                            PickerButton.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
                                            PickerButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            PickerButton.BorderSizePixel = 1
                                            PickerButton.Position = UDim2.new(0, 2, 0, 2)
                                            PickerButton.Size = UDim2.new(1, -4, 1, -4)
                                            PickerButton.FontFace  = Library.MenuFont
                                            PickerButton.Text = ""
                                            PickerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                                            PickerButton.TextSize = Library.TextSize
                                            PickerButton.AutoButtonColor = false;
                
                                            local IsInColor2 = false;
                                            local IsInColor1 = false;
                                            local IsInTransparency = false;
                                            local ColorFrame, InnerColor, HueOutline, HuePicker, UIGradient, HuePick, PickerOutline_3, HuePick, ColorPicker, ColorPick, TOutline, TransparencyPicker, TransparencyColor, TransparencyPick, TitleFrame, ColorpickerTitle_2, PasteButton, CopyButton, SetBox = Window:CreateColorpicker(PickerOutline, Data.Name)
                                            local Colors = {}; do 
                                                Colors.h = (math.clamp(HuePick.AbsolutePosition.Y-HuePicker.AbsolutePosition.Y, 0, HuePicker.AbsoluteSize.Y)/HuePicker.AbsoluteSize.Y)
                                                Colors.s = 1-(math.clamp(ColorPick.AbsolutePosition.X-ColorPick.AbsolutePosition.X, 0, ColorPick.AbsoluteSize.X)/ColorPick.AbsoluteSize.X)
                                                Colors.v = 1-(math.clamp(ColorPick.AbsolutePosition.Y-ColorPick.AbsolutePosition.Y, 0, ColorPick.AbsoluteSize.Y)/ColorPick.AbsoluteSize.Y)
                                            end;

                                            do --// functions
                                                do --// Buttons 
                                                    CopyButton.MouseButton1Down:Connect(function()
                                                        Library.CopiedColor = {Color = ColorPickerTab.Color};
 
                                                        Library:Tween(CopyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                                        task.wait(0.1)
                                                        Library:Tween(CopyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                                    end);
                
                                                    CopyButton.MouseEnter:Connect(function()
                                                        Library:Tween(CopyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Library.Theme.Accent});
                                                    end);
                
                                                    CopyButton.MouseLeave:Connect(function()
                                                        Library:Tween(CopyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Library.Theme.Border});
                                                    end);

                                                    PasteButton.MouseButton1Down:Connect(function()
                                                        if Library.CopiedColor then 
                                                            ColorPickerTab:Set({Color = Library.CopiedColor.Color, Transparency = ColorPickerTab.Transparency}, true);
                                                        end;
                                                        Library:Tween(PasteButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                                        task.wait(0.1)
                                                        Library:Tween(PasteButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                                    end);
                
                                                    PasteButton.MouseEnter:Connect(function()
                                                        Library:Tween(PasteButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Library.Theme.Accent});
                                                    end);
                
                                                    PasteButton.MouseLeave:Connect(function()
                                                        Library:Tween(PasteButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Library.Theme.Border});
                                                    end);

                                                    SetBox.MouseEnter:Connect(function()
                                                        Library:Tween(SetBox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Library.Theme.Accent});
                                                    end);
                                                    
                                                    SetBox.MouseLeave:Connect(function()
                                                        Library:Tween(SetBox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = Library.Theme.Border});
                                                    end);

                                                    SetBox.FocusLost:Connect(function()
                                                        local Text = SetBox.Text;
                                                        local Split = Text:split(", ");
                                                        ColorPickerTab:Set({Color = Color3.fromRGB(Split[1], Split[2], Split[3]), Transparency = ColorPickerTab.Transparency});

                                                        Library:Tween(SetBox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(Split[1], Split[2], Split[3])});
                                                        task.wait(0.1);
                                                        Library:Tween(SetBox, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                                    end);
                                                end;

                                                function ColorPickerTab:ToHex(RGB)
                                                    local Hexadecimal = "#"
                    
                                                    for Key, Value in pairs(RGB) do
                                                        local Hex = ""
                    
                                                        while(Value > 0)do
                                                            local index = math.fmod(Value, 16) + 1
                                                            Value = math.floor(Value / 16)
                                                            Hex = string.sub("0123456789ABCDEF", index, index) .. Hex			
                                                        end
                    
                                                        if(string.len(Hex) == 0)then
                                                            Hex = "00"
                    
                                                        elseif(string.len(Hex) == 1)then
                                                            Hex = "0" .. Hex
                                                        end
                    
                                                        Hexadecimal = Hexadecimal .. Hex
                                                    end
                    
                                                    return Hexadecimal
                                                end;

                                                function ColorPickerTab:UpdateColor()
                                                    local ColorX = (math.clamp(Mouse.X - ColorPicker.AbsolutePosition.X, 0, ColorPicker.AbsoluteSize.X)/ColorPicker.AbsoluteSize.X)
                                                    local ColorY = (math.clamp(Mouse.Y - ColorPicker.AbsolutePosition.Y, 0, ColorPicker.AbsoluteSize.Y)/ColorPicker.AbsoluteSize.Y)
                                                    ColorPick.Position = UDim2.new(ColorX, 0, ColorY, 0)
                                
                                                    Colors.s = 1 - ColorX
                                                    Colors.v = 1 - ColorY
                                
                                                    PickerButton.BackgroundColor3 = Color3.fromHSV(Colors.h, Colors.s, Colors.v)
                                                    ColorPickerTab.Color = Color3.fromHSV(Colors.h, Colors.s, Colors.v);

                                                    local R = math.floor((ColorPickerTab.Color.R * 255) * 255);
                                                    local G = math.floor((ColorPickerTab.Color.G * 255) * 255);
                                                    local B = math.floor((ColorPickerTab.Color.B * 255) * 255);
                                                    

                                                    local ToRGB = Color3.fromRGB(math.ceil(R), math.ceil(G), math.ceil(B));
                                                    SetBox.Text = tostring(ToRGB);

                                                    if Data.Callback then pcall(Data.Callback) end
                                                end;

                                                function ColorPickerTab:Set(new_Value, cb)
                                                    local NColor, NTransparency = new_Value.Color, new_Value.Transparency;
                                
                                                    ColorPickerTab.Color = NColor; ColorPickerTab.Transparency = NTransparency;
                    
                                                    local duplicate = Color3.new(new_Value.Color.R, new_Value.Color.G, new_Value.Color.B);
                                                    Colors.h, Colors.s, Colors.v = duplicate:ToHSV()
                                                    Colors.h = math.clamp(Colors.h, 0, 1)
                                                    Colors.s = math.clamp(Colors.s, 0, 1)
                                                    Colors.v = math.clamp(Colors.v, 0, 1)

                                                    local R = math.floor((ColorPickerTab.Color.R * 255) * 255);
                                                    local G = math.floor((ColorPickerTab.Color.G * 255) * 255);
                                                    local B = math.floor((ColorPickerTab.Color.B * 255) * 255);
                                
                                                    local ToRGB = Color3.fromRGB(math.ceil(R), math.ceil(G), math.ceil(B));
                                                    SetBox.Text = tostring(ToRGB);

                                                    ColorPick.Position = UDim2.new(1 - Colors.s, 0, 1 - Colors.v, 0)
                                                    ColorPicker.ImageColor3 = Color3.fromHSV(Colors.h, 1, 1)
                                                    PickerButton.BackgroundColor3 = Color3.fromHSV(Colors.h, Colors.s, Colors.v)
                                                    HuePick.Position = UDim2.new(0, 0, 1 - Colors.h, -1)
                                                    if TransparencyColor then
                                                        TransparencyColor.ImageColor3 = Color3.fromHSV(Colors.h, 1, 1)
                                
                                                        TransparencyPick.Position = UDim2.new(ColorPickerTab.Transparency, -1, 0, 0)
                                                    end
                                                    
                                                    if Data.Callback then pcall(Data.Callback) end;
                    
                                                    if cb == nil or not cb then
                                
                                                    end
                                                end;

                                                function ColorPickerTab:UpdateHue()
                                                    local y = math.clamp(Mouse.Y - HuePicker.AbsolutePosition.Y, 0, 157)
                                                    HuePick.Position = UDim2.new(0, 0, 0, y)
                                                    local hue = y/157
                                                    Colors.h = 1-hue
                                                    ColorPicker.ImageColor3 = Color3.fromHSV(Colors.h, 1, 1)
                                                    PickerButton.BackgroundColor3 = Color3.fromHSV(Colors.h, Colors.s, Colors.v)
                                                    if TransparencyColor then
                                                        TransparencyColor.ImageColor3 = Color3.fromHSV(Colors.h, 1, 1)
                                                    end
                                                    ColorPickerTab.Color = Color3.fromHSV(Colors.h, Colors.s, Colors.v)
                                                    local R = math.floor((ColorPickerTab.Color.R * 255) * 255);
                                                    local G = math.floor((ColorPickerTab.Color.G * 255) * 255);
                                                    local B = math.floor((ColorPickerTab.Color.B * 255) * 255);
                                
                                                    local ToRGB = Color3.fromRGB(math.ceil(R), math.ceil(G), math.ceil(B));
                                                    SetBox.Text = tostring(ToRGB);
                                                end;

                                                PickerButton.MouseEnter:Connect(function()
                                                    Library:Tween(PickerOutline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                                end);
                    
                                                PickerButton.MouseLeave:Connect(function()
                                                    Library:Tween(PickerOutline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                                end);

                                                ColorFrame.MouseEnter:Connect(function()
                                                    IsInColor1 = true;
                                                end);
                    
                                                ColorFrame.MouseLeave:Connect(function()
                                                    IsInColor1 = false;
                                                end);
                    
                                                TransparencyPicker.MouseEnter:Connect(function()
                                                    IsInTransparency = true;
                                                end);
                    
                                                TransparencyPicker.MouseLeave:Connect(function()
                                                    IsInTransparency = false;
                                                end);
                    
                                                HuePicker.MouseEnter:Connect(function()
                                                    IsInColor2 = true;
                                                end);
                    
                                                HuePicker.MouseLeave:Connect(function()
                                                    IsInColor2 = false;
                                                end);

                                                ColorPickerTab.ColorFrame = ColorFrame

                                                PickerButton.MouseButton1Down:Connect(function()
                                                    ColorPickerTab.IsOpen = not ColorPickerTab.IsOpen;
                                                    ColorFrame.Visible = ColorPickerTab.IsOpen;
                                                    if ColorPickerTab.IsOpen then
                                                        if Library.CurrentColorpicker then 
                                                            Library.CurrentColorpicker.ColorFrame.Visible = false;
                                                            Library.CurrentColorpicker.IsOpen = false;
                                                        end;
                        
                                                        Library.CurrentColorpicker = ColorPickerTab;
                                                        Library.CurrentColorpicker.ColorFrame.Visible = true; 
                                                    else
                                                        Library.CurrentColorpicker.ColorFrame.Visible = false;
                                                        Library.CurrentColorpicker = nil;
                                                    end;
                        
                                                end);
                        
                                                UserInputService.InputBegan:Connect(function(Input)
                                                    if Input.UserInputType == Enum.UserInputType.MouseButton2 then 
                                                        if not IsInColor1 and not IsInColor2 and not IsInTransparency then 
                                                            ColorFrame.Visible = false;
                                                            ColorPickerTab.IsOpen = false;
                                                        end;
                                                    end;
                                                end);
                    
                                                function ColorPickerTab:UpdateTransparency()
                                                    local X = math.clamp(Mouse.X - TransparencyPicker.AbsolutePosition.X, 0, TransparencyPicker.AbsoluteSize.X)
                                                    TransparencyPick.Position = UDim2.new(0, X, 0, 0)
                                                    local NewTransparency = X/TransparencyPicker.AbsoluteSize.X;
                    
                                                    ColorPickerTab.Transparency = NewTransparency;
                                                    if Data.Callback then pcall(Data.Callback); end;
                                                end;
                    
                                                TransparencyPicker.MouseButton1Down:Connect(function()
                                                    ColorPickerTab:UpdateTransparency()
                                                    local MoveConn = Mouse.Move:Connect(function()
                                                        ColorPickerTab:UpdateTransparency()
                                                    end)
                                                    ReleaseConn = UserInputService.InputEnded:Connect(function(Input)
                                                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                                            ColorPickerTab:UpdateTransparency()
                                                            MoveConn:Disconnect()
                                                            ReleaseConn:Disconnect()
                                                        end
                                                    end)
                    
                                                end);
                    
                                                ColorPickerTab.Color = Color3.fromHSV(Colors.h, Colors.s, Colors.v)

                                                ColorPicker.MouseButton1Down:Connect(function()
                                                    ColorPickerTab:UpdateColor()
                                                    local MoveConnection = Mouse.Move:Connect(function()
                                                        ColorPickerTab:UpdateColor()
                                                    end)
                                                    ReleaseConnection = UserInputService.InputEnded:Connect(function(Mouse)
                                                        if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                                                            ColorPickerTab:UpdateColor()
                                                            MoveConnection:Disconnect()
                                                            ReleaseConnection:Disconnect()
                                                        end
                                                    end)
                                                end);

                                                HuePicker.MouseButton1Down:Connect(function()
                                                    ColorPickerTab:UpdateHue()
                                                    local MoveConnection = Mouse.Move:Connect(function()
                                                        ColorPickerTab:UpdateHue()
                                                    end)
                                                    ReleaseConnection = UserInputService.InputEnded:Connect(function(Mouse)
                                                        if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                                                            ColorPickerTab:UpdateHue()
                                                            MoveConnection:Disconnect()
                                                            ReleaseConnection:Disconnect()
                                                        end
                                                    end)
                                                end);
                                            end;

                                            ColorPickerTab:Set({Color = Data.Default or Color3.fromRGB(255, 255, 255), Transparency = DefaultTransparency}, true)
                
                                            Library.Flags[Flag] = ColorPickerTab

                                            if Data.Callback then pcall(Data.Callback) end;
                                            return ColorPicker
                                        end;

                                        function Toggle:Keybind(Data)
                                            local BindOutline_2 = Instance.new("Frame")
                
                                            local Keybind = {
                                                Name = Data.Name;
                                                Key = "";
                                                Flag = Data.Flag;
                                                Mode = Data.Mode or "Toggle",
                                                Value = false;
                                                Callback = Data.Callback or function() end;
                                                IsBeingSelected = false;
                                                Components = BindOutline_2;
                                                Default = Data.Default;
                                                AbKey = "";
                                            };
                
                                            local KeybindPicker_2 = Instance.new("TextButton")
                
                                            BindOutline_2.Name = "BindOutline"
                                            BindOutline_2.Parent = Items
                                            BindOutline_2.BackgroundColor3 = Library.Theme.LightContrast
                                            BindOutline_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            BindOutline_2.BorderSizePixel = 1
                                            BindOutline_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            BindOutline_2.Position = UDim2.new(1, -23, 0, 0)
                                            BindOutline_2.Size = UDim2.new(0, 20, 0, 15)
                                            BindOutline_2.BackgroundTransparency = 1;

                                            KeybindPicker_2.Name = "KeybindPicker"
                                            KeybindPicker_2.Parent = BindOutline_2
                                            KeybindPicker_2.BackgroundColor3 = Library.Theme.MedianContrast
                                            KeybindPicker_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            KeybindPicker_2.BorderSizePixel = 1
                                            KeybindPicker_2.Position = UDim2.new(0, 2, 0, 2)
                                            KeybindPicker_2.Size = UDim2.new(1, -4, 1, -4)
                                            KeybindPicker_2.FontFace = Library.MenuFont
                                            KeybindPicker_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            KeybindPicker_2.Text = "[NONE]"
                                            KeybindPicker_2.TextColor3 = Library.Theme.ElementOff
                                            KeybindPicker_2.TextSize = Library.TextSize
                                            KeybindPicker_2.AutoButtonColor = false;
                                            KeybindPicker_2.BackgroundTransparency = 1;
                                            KeybindPicker_2.TextXAlignment = Enum.TextXAlignment.Right;

                                            function Keybind:Set(Key, IsMouse)
                                                if not IsMouse then 
                                                    if Key and (type(Key) == "table" or typeof(Key) == "EnumItem") and Key.Name then
                                                        Keybind.IsBeingSelected = true;
    
                                                        if Keys[Key.Name] then 
                                                            KeybindPicker_2.Text = "["..Keys[Key.Name].."]";
                                                            Keybind.AbKey = Keys[Key.Name]
                                                        else 
                                                            KeybindPicker_2.Text = "["..Key.Name:sub(1, 2).."]";
    
                                                            Keybind.AbKey = Key.Name:sub(1, 2)
                                                        end;
    
                                                        if type(Key) == "table" and Key.Name ~= "" then
    
                                                        
                                                            Keybind.Key = Enum.KeyCode[Key.Name];
                                                        else 
                                                            Keybind.Key = Key;
                                                        end;
                                                        Keybind.IsBeingSelected = false;
                                                    end;
                                                else
                                                    if type(Key) == "table" then 
                                                        Key = Enum.UserInputType[Key.Name];
                                                    end
                                                    Keybind.IsBeingSelected = true; 
                                                    local Shortened = "";
                                                    if Key == Enum.UserInputType.MouseButton1 then 
                                                        Shortened = "M1";
                                                    elseif Key == Enum.UserInputType.MouseButton2 then 
                                                        Shortened = "M2";
                                                    elseif Key == Enum.UserInputType.MouseButton3 then 
                                                        Shortened = "M3";
                                                    elseif Key == Enum.UserInputType.MouseWheel then 
                                                        Shortened = "M4";
                                                    end;
    
                                                    Keybind.Key = Key;
                                                    Keybind.AbKey = Shortened;
    
                                                    KeybindPicker_2.Text = "["..Shortened.."]";
                                                    Keybind.IsBeingSelected = false
                                                end;
                                            end;
    
                                            KeybindPicker_2.MouseEnter:Connect(function()
                                                Library:Tween(BindOutline_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                            end);
    
                                            KeybindPicker_2.MouseLeave:Connect(function()
                                                Library:Tween(BindOutline_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                            end);
    
                                            KeybindPicker_2.MouseButton1Down:Connect(function()
                                                task.spawn(function()
                                                    Library:Tween(KeybindPicker_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                                    task.wait(0.1)
                                                    Library:Tween(KeybindPicker_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                                end);
    
                                                task.wait(0.1)
                                                KeybindPicker_2.Text = " ..."
                                                Keybind.IsBeingSelected = true;
    
                                                UserInputService.InputBegan:Connect(function(Input)
                                                    if Input.UserInputType == Enum.UserInputType.Keyboard and Keybind.IsBeingSelected then
                                                        Keybind:Set(Input.KeyCode);
                                                        Keybind.IsBeingSelected = false;
                                                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.IsBeingSelected then 
                                                        Keybind:Set(Enum.UserInputType.MouseButton1, true)
                                                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.IsBeingSelected then 
                                                        Keybind:Set(Enum.UserInputType.MouseButton2, true)
                                                    elseif Input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.IsBeingSelected then 
                                                        Keybind:Set(Enum.UserInputType.MouseButton3, true)
                                                    elseif Input.UserInputType == Enum.UserInputType.MouseWheel and Keybind.IsBeingSelected then 
                                                        Keybind:Set(Enum.UserInputType.MouseWheel, true)
                                                    else 
                                                        Keybind.IsBeingSelected = false;
                                                    end;
                                                end);
                                            end);
                                            
                                            UserInputService.InputBegan:Connect(function(Input)
                                                if Input.KeyCode == Keybind["Key"] and not Keybind.IsBeingSelected then 
                                                    if Keybind["Mode"] == "Toggle" then 
                                                        Keybind.Value = not Keybind.Value;
                                                        if Keybind.Name ~= "Open/Close" and Keybind.Name ~= "Open / Close" then 
                                                            Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                        end;
                                                        pcall(Keybind.Callback)
                                                    elseif Keybind["Mode"] == "Hold" then 
                                                        Keybind.Value = true;
                                                        if not Library.KeybindsContainer:FindFirstChild(Keybind.Name) then 
                                                            Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                        end;
                                                        pcall(Keybind.Callback)
                                                    elseif Keybind["Mode"] == "Press" then 
                                                        pcall(Keybind.Callback)
                                                    end
                                                end
                                            end);
                
                                            UserInputService.InputEnded:Connect(function(Input)
                                                if Input.KeyCode == Keybind["Key"] and not Keybind.IsBeingSelected then 
                                                    if Keybind["Mode"] == "Hold" then
                                                        Keybind.Value = false;
                                                        Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                        if Data.Callback then pcall(Data.Callback) end;
                                                    end
                                                end
                                            end);

                                            if Keybind.Default then 
                                                Keybind:Set(Keybind.Default);
                                            end;
                                            Library.Flags[Data.Flag] = Keybind;
                                            return Keybind;
                                        end;

                                        function Toggle:MultiSettings(Data)
                                            local Settings = {

                                            };

                                            local Button = Instance.new("ImageButton");

                                            local ContainerOutline = Instance.new("Frame");
                                            local Container = Instance.new("Frame");

                                            
                                            do --// properties 

                                            end; 

                                            do --// functions

                                            end;


                                            return Settings;
                                        end;
                                    end;

                                    Section.Bounds = Section.Bounds + 24;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);

                                    if Toggle.Default then 
                                        Toggle:Set(Toggle.Default);
                                    end;

                                    Library.Flags[Data.Flag] = Toggle;
                                    return Toggle;
                                end;

                                --// Dropdown
                                function Section:Dropdown(Data)
                                    local Dropdown = {
                                        Name = Data.Name,
                                        Flag = Data.Flag,
                                        Value = nil,
                                        Options = {};
                                        Max = Data.Max or #Data.Options;
                                        IsOpen = false;
                                        Callback = Data.Callback or function() end;
                                        Default = Data.Default;
                                        Frame = nil;
                                    };
                                    local NewDropdown = Instance.new("Frame")
                                    local DropdownOutline = Instance.new("Frame")
                                    local DropdownInner = Instance.new("TextButton")
                                    local DropdownFlag = Instance.new("TextLabel")
                                    local DropdownStatus = Instance.new("TextLabel")
                                    local ContainerOutline = Instance.new("Frame")
                                    local Container = Instance.new("Frame")
                                    local ContainerLayout = Instance.new("UIListLayout")
                                    local DropdownTitle = Instance.new("TextLabel")

                                    Dropdown.Frame = NewDropdown;

                                    do --// Dropdown properties 
                                        NewDropdown.Name = "NewDropdown";
                                        NewDropdown.Parent = SectionInner;
                                        NewDropdown.BackgroundColor3 = Color3.fromRGB(255, 0, 0);
                                        NewDropdown.BackgroundTransparency = 1.000;
                                        NewDropdown.BorderColor3 = Library.Theme.Border;
                                        NewDropdown.BorderSizePixel = 0;
                                        NewDropdown.Position = UDim2.new(0, 2, 0, Section.Bounds);
                                        NewDropdown.Size = UDim2.new(1, -4, 0, 32);
                                        NewDropdown.ZIndex = Window.ImportantIndex;

                                        Window.ImportantIndex = Window.ImportantIndex - 1;

                                        DropdownOutline.Name = "DropdownOutline";
                                        DropdownOutline.Parent = NewDropdown;
                                        DropdownOutline.BackgroundColor3 = Library.Theme.LightContrast;
                                        DropdownOutline.BorderColor3 = Library.Theme.Border;
                                        DropdownOutline.Position = UDim2.new(0, 0, 0, 15);
                                        DropdownOutline.Size = UDim2.new(1, 0, 0, 16);
                                        
                                        DropdownInner.Name = "DropdownInner";
                                        DropdownInner.Parent = DropdownOutline;
                                        DropdownInner.BackgroundColor3 = Library.Theme.MedianContrast;
                                        DropdownInner.BorderColor3 = Library.Theme.Border;
                                        DropdownInner.Position = UDim2.new(0, 2, 0, 2);
                                        DropdownInner.Size = UDim2.new(1, -4, 1, -4);
                                        DropdownInner.Text = "";

                                        DropdownInner.AutoButtonColor = false;

                                        DropdownFlag.Name = "DropdownFlag";
                                        DropdownFlag.Parent = DropdownInner;
                                        DropdownFlag.BackgroundColor3 = Library.Theme.ElementOn;
                                        DropdownFlag.BackgroundTransparency = 1.000;
                                        DropdownFlag.BorderColor3 = Library.Theme.Border;
                                        DropdownFlag.BorderSizePixel = 0;
                                        DropdownFlag.Size = UDim2.new(1, 0, 1, 0);
                                        DropdownFlag.FontFace = Library.MenuFont;
                                        DropdownFlag.Text = "";
                                        DropdownFlag.TextColor3 = Library.Theme.ElementOn;
                                        DropdownFlag.TextSize = Library.TextSize;
                                        
                                        DropdownStatus.Name = "DropdownStatus";
                                        DropdownStatus.Parent = DropdownInner;
                                        DropdownStatus.BackgroundColor3 = Library.Theme.ElementOn;
                                        DropdownStatus.BackgroundTransparency = 1.000;
                                        DropdownStatus.BorderColor3 = Library.Theme.Border;
                                        DropdownStatus.BorderSizePixel = 0;
                                        DropdownStatus.Position = UDim2.new(0.929292917, 0, 0, 1);
                                        DropdownStatus.Size = UDim2.new(0, 14, 1, 0);
                                        DropdownStatus.FontFace = Library.MenuFont;
                                        DropdownStatus.Text = "+";
                                        DropdownStatus.TextColor3 = Library.Theme.ElementOn;
                                        DropdownStatus.TextSize = Library.TextSize;
                                        
                                        ContainerOutline.Name = "ContainerOutline"
                                        ContainerOutline.Parent = DropdownInner
                                        ContainerOutline.BackgroundColor3 = Library.Theme.LightContrast
                                        ContainerOutline.BorderColor3 = Library.Theme.Border
                                        ContainerOutline.Position = UDim2.new(0, -2, 1, 4);
                                        ContainerOutline.ClipsDescendants = true;
                                        ContainerOutline.Size = UDim2.new(1, 4, 0, 0)
                                        ContainerOutline.Visible = false
                                        Dropdown.Container = ContainerOutline;

                                        Container.Name = "Container"
                                        Container.Parent = ContainerOutline
                                        Container.BackgroundColor3 = Library.Theme.MedianContrast
                                        Container.BorderColor3 = Library.Theme.Border
                                        Container.Position = UDim2.new(0, 2, 0, 2)
                                        Container.Size = UDim2.new(1, -4, 1, -4)
                                        Container.Visible = true;

                                        ContainerLayout.Parent = Container
                                        ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                        
                                        DropdownTitle.Name = "DropdownTitle"
                                        DropdownTitle.Parent = NewDropdown
                                        DropdownTitle.BackgroundColor3 = Library.Theme.ElementOn
                                        DropdownTitle.BackgroundTransparency = 1.000
                                        DropdownTitle.BorderColor3 = Library.Theme.Border
                                        DropdownTitle.BorderSizePixel = 0
                                        DropdownTitle.Position = UDim2.new(0.00990098994, 0, 0, 0)
                                        DropdownTitle.Size = UDim2.new(0.990099013, 0, 0, 14)
                                        DropdownTitle.FontFace = Library.MenuFont
                                        DropdownTitle.Text = Data.Name;
                                        DropdownTitle.TextColor3 = Library.Theme.ElementOn
                                        DropdownTitle.TextSize = Library.TextSize
                                        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                                        DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
                                    end;

                                    do --// Dropdown functions 

                                        function Dropdown:Toggle()
                                            Dropdown.IsOpen = not Dropdown.IsOpen; 
                                            local SizeToTween;


                                            if Dropdown.IsOpen then 
                                                Dropdown.Container.Visible = true;
                                            end;

                                            if Dropdown.Max ~= 1 then 
                                                SizeToTween = UDim2.new(1, 4, 0, (14 * Dropdown.Max) + 4);
                                            else 
                                                SizeToTween = UDim2.new(1, 4, 0, 14);
                                            end;

                                            if Dropdown.IsOpen then 
                                                if Library.CurrentDropdown then 
                                                    Library.CurrentDropdown.Container.Visible = false;
                                                    Library.CurrentDropdown.Container.Size = UDim2.new(1, 4, 0, 0)
                                                    Library.CurrentDropdown.IsOpen = false;
                                                end;
                                                Library.CurrentDropdown = Dropdown;

                                                Library:Tween(Dropdown.Container, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = SizeToTween});
                                            else
                                                Library.CurrentDropdown = nil;
                                                Library:Tween(Dropdown.Container, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 4, 0, 0)});
                                                task.wait(0.2);
                                                Dropdown.Container.Visible = false;
                                            end;
                                        end;

                                        function Dropdown:Update()
                                            --if Dropdown.Max ~= 1 then 
                                            --    ContainerOutline.Size = UDim2.new(1, 4, 0, (14 * Dropdown.Max) + 4);
                                            --else 
                                            --    ContainerOutline.Size = UDim2.new(1, 4, 0, 14);
                                            --end;
                                        end;

                                        DropdownInner.MouseEnter:Connect(function()
                                            Library:Tween(DropdownOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                        end);
                                        
                                        DropdownInner.MouseLeave:Connect(function()
                                            Library:Tween(DropdownOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                        end);

                                        DropdownInner.MouseButton1Down:Connect(function()
                                            Dropdown:Toggle();
                                        end);
                                        
                                        function Dropdown:Set(Value)
                                            if Dropdown.Options[Value] then
                                                Dropdown.Value = Value;
                                                DropdownFlag.Text = tostring(Value); 
                                                Dropdown.Options[Value].IsSelected = true;
                                                Dropdown.Options[Value].Selector.Visible = true;
                                                Library:Tween(Dropdown.Options[Value].Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                            end;

                                            for Index, Val in pairs(Dropdown.Options) do 
                                                if Val ~= Dropdown.Options[Value] then 
                                                    Val.IsSelected = false; 
                                                    Val.Selector.Visible = false;
                                                    Library:Tween(Val.Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                end;    
                                            end;

                                            if Dropdown.Callback then pcall(Dropdown.Callback); end;
                                        end;

                                        function Dropdown:AddOption(Name)
                                            local NewOption = Instance.new("TextButton")
                                            local Frame = Instance.new("Frame")

                                            local Option = {
                                                Name = Name;
                                                IsSelected = false;
                                                Selector = Frame;
                                                Button = NewOption;
                                            };

                                            NewOption.Name = "NewOption"
                                            NewOption.Parent = Container
                                            NewOption.BackgroundColor3 = Library.Theme.ElementOff
                                            NewOption.BackgroundTransparency = 1.000
                                            NewOption.BorderColor3 = Library.Theme.Border
                                            NewOption.BorderSizePixel = 0
                                            NewOption.Size = UDim2.new(1, 0, 0, 14)
                                            NewOption.FontFace = Library.MenuFont
                                            NewOption.Text = Name;
                                            NewOption.TextColor3 = Library.Theme.ElementOff;
                                            NewOption.TextSize = Library.TextSize
                                            
                                            Frame.Parent = NewOption
                                            Frame.BackgroundColor3 = Library.Theme.Accent
                                            Frame.BorderColor3 = Library.Theme.Border
                                            Frame.BorderSizePixel = 0
                                            Frame.Size = UDim2.new(0, 2, 1, 0);
                                            Frame.Visible = false;

                                            NewOption.MouseButton1Down:Connect(function()
                                                Option.IsSelected = not Option.IsSelected

                                                for Index, Value in next, Dropdown.Options do 
                                                    if Value ~= Option then 
                                                        Value.IsSelected = false;
                                                        Library:Tween(Value.Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                        Value.Selector.Visible = false;
                                                    end;
                                                end;
                                                if Option.IsSelected then 
                                                    Dropdown:Set(Option.Name);
                                                else
                                                    Frame.Visible = false;
                                                    Library:Tween(NewOption, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                end;
                                            end);
                                            Dropdown.Options[Option.Name] = Option;

                                            return Option;
                                        end;

                                        function Dropdown:RemoveOption(Name)
                                            if Dropdown.Options[Name] then
                                                Dropdown.Options[Name].Button:Destroy();
                                                Dropdown.Options[Name] = nil;
                                            end;
                                        end;
                                    end;

                                    for Index, Value in next, Data.Options do 
                                        Dropdown:AddOption(Value);
                                    end;

                                    Section.Bounds = Section.Bounds + 37;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);

                                    if Dropdown.Default then
                                        Dropdown:Set(Dropdown.Default);
                                    else 
                                        Dropdown:Set(Data.Options[1])
                                    end;

                                    Library.Flags[Data.Flag] = Dropdown;
                                    return Dropdown;
                                end;

                                --// Keybind
                                function Section:Keybind(Data)
                                    local Keybind = {
                                        Name = Data.Name;
                                        Key = "";
                                        Flag = Data.Flag;
                                        Mode = Data.Mode or "Toggle",
                                        IsEnabled = false;
                                        Callback = Data.Callback or function() end;
                                        IsBeingSelected = false;
                                        Default = Data.Default;
                                        Components = nil;
                                        Frame = nil;
                                        AbKey = "";
                                    };

                                    local NewKeybind = Instance.new("Frame")
                                    local KeybindTitle = Instance.new("TextLabel");
                                    local BindOutline_2 = Instance.new("Frame")
                                    local KeybindPicker_2 = Instance.new("TextButton")

                                    Keybind.Components = BindOutline_2;
                                    Keybind.Frame = NewKeybind;

                                    do --// Properties
                                        NewKeybind.Name = "NewKeybind"
                                        NewKeybind.Parent = SectionInner
                                        NewKeybind.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
                                        NewKeybind.BackgroundTransparency = 1.000
                                        NewKeybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        NewKeybind.BorderSizePixel = 0
                                        NewKeybind.Size = UDim2.new(1, 0, 0, 15)
                                        NewKeybind.Position = UDim2.new(0, 2, 0, Section.Bounds);

                                        KeybindTitle.Name = "KeybindTitle"
                                        KeybindTitle.Parent = NewKeybind
                                        KeybindTitle.BackgroundColor3 = Library.Theme.ElementOn
                                        KeybindTitle.BackgroundTransparency = 1.000
                                        KeybindTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        KeybindTitle.BorderSizePixel = 0
                                        KeybindTitle.Position = UDim2.new(0, 1, 0, 0)
                                        KeybindTitle.Size = UDim2.new(0.875706196, 0, 1, 0)
                                        KeybindTitle.FontFace = Library.MenuFont
                                        KeybindTitle.Text = Data.Name
                                        KeybindTitle.TextColor3 = Library.Theme.ElementOn
                                        KeybindTitle.TextSize = Library.TextSize
                                        KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

                                        BindOutline_2.Name = "BindOutline"
                                        BindOutline_2.Parent = NewKeybind
                                        BindOutline_2.BackgroundColor3 = Library.Theme.LightContrast
                                        BindOutline_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        BindOutline_2.BorderSizePixel = 1
                                        BindOutline_2.Position = UDim2.new(1, -23, 0, 0)
                                        BindOutline_2.Size = UDim2.new(0, 20, 0, 15)
                                        BindOutline_2.BackgroundTransparency = 1;

                                        KeybindPicker_2.Name = "KeybindPicker"
                                        KeybindPicker_2.Parent = BindOutline_2
                                        KeybindPicker_2.BackgroundColor3 = Library.Theme.MedianContrast
                                        KeybindPicker_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        KeybindPicker_2.BorderSizePixel = 1
                                        KeybindPicker_2.Position = UDim2.new(0, 2, 0, 2)
                                        KeybindPicker_2.Size = UDim2.new(1, -4, 1, -4)
                                        KeybindPicker_2.FontFace = Library.MenuFont
                                        KeybindPicker_2.Text = "[NONE]"
                                        KeybindPicker_2.TextColor3 = Library.Theme.ElementOn
                                        KeybindPicker_2.TextSize = Library.TextSize
                                        KeybindPicker_2.AutoButtonColor = false;
                                        KeybindPicker_2.BackgroundTransparency = 1;

                                        KeybindPicker_2.TextXAlignment = Enum.TextXAlignment.Right;
                                    end;

                                    do --// Functions
                                        function Keybind:Set(Key, IsMouse)
                                            if not IsMouse then 
                                                if Key and (type(Key) == "table" or typeof(Key) == "EnumItem") and Key.Name then
                                                    Keybind.IsBeingSelected = true;

                                                    if Keys[Key.Name] then 
                                                        KeybindPicker_2.Text = "["..Keys[Key.Name].."]";
                                                        Keybind.AbKey = Keys[Key.Name]
                                                    else 
                                                        KeybindPicker_2.Text = "["..Key.Name:sub(1, 2).."]";

                                                        Keybind.AbKey = Key.Name:sub(1, 2)
                                                    end;

                                                    if type(Key) == "table" and Key.Name ~= "" then

                                                    
                                                        Keybind.Key = Enum.KeyCode[Key.Name];
                                                    else 
                                                        Keybind.Key = Key;
                                                    end;
                                                    Keybind.IsBeingSelected = false;
                                                end;
                                            else
                                                if type(Key) == "table" then 
                                                    Key = Enum.UserInputType[Key.Name];
                                                end
                                                Keybind.IsBeingSelected = true; 
                                                local Shortened = "";
                                                if Key == Enum.UserInputType.MouseButton1 then 
                                                    Shortened = "M1";
                                                elseif Key == Enum.UserInputType.MouseButton2 then 
                                                    Shortened = "M2";
                                                elseif Key == Enum.UserInputType.MouseButton3 then 
                                                    Shortened = "M3";
                                                elseif Key == Enum.UserInputType.MouseWheel then 
                                                    Shortened = "M4";
                                                end;

                                                Keybind.Key = Key;
                                                Keybind.AbKey = Shortened;

                                                KeybindPicker_2.Text = "["..Shortened.."]";
                                                Keybind.IsBeingSelected = false
                                            end;
                                        end;

                                        KeybindPicker_2.MouseEnter:Connect(function()
                                            Library:Tween(BindOutline_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                        end);

                                        KeybindPicker_2.MouseLeave:Connect(function()
                                            Library:Tween(BindOutline_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                        end);

                                        KeybindPicker_2.MouseButton1Down:Connect(function()
                                            task.spawn(function()
                                                Library:Tween(KeybindPicker_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                                task.wait(0.1)
                                                Library:Tween(KeybindPicker_2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.MedianContrast});
                                            end);

                                            task.wait(0.1)
                                            KeybindPicker_2.Text = " ..."
                                            Keybind.IsBeingSelected = true;

                                            UserInputService.InputBegan:Connect(function(Input)
                                                if Input.UserInputType == Enum.UserInputType.Keyboard and Keybind.IsBeingSelected then
                                                    Keybind:Set(Input.KeyCode);
                                                    Keybind.IsBeingSelected = false;
                                                elseif Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.IsBeingSelected then 
                                                    Keybind:Set(Enum.UserInputType.MouseButton1, true)
                                                elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.IsBeingSelected then 
                                                    Keybind:Set(Enum.UserInputType.MouseButton2, true)
                                                elseif Input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.IsBeingSelected then 
                                                    Keybind:Set(Enum.UserInputType.MouseButton3, true)
                                                elseif Input.UserInputType == Enum.UserInputType.MouseWheel and Keybind.IsBeingSelected then 
                                                    Keybind:Set(Enum.UserInputType.MouseWheel, true)
                                                else 
                                                    Keybind.IsBeingSelected = false;
                                                end;
                                            end);
                                        end);

                                        UserInputService.InputBegan:Connect(function(Input)
                                            if Input.KeyCode == Keybind["Key"] and not Keybind.IsBeingSelected then 
                                                if Keybind["Mode"] == "Toggle" then 
                                                    Keybind.Value = not Keybind.Value;
                                                    if Keybind.Name ~= "Open/Close" and Keybind.Name ~= "Open / Close" then 
                                                        Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                    end;
                                                    pcall(Keybind.Callback)
                                                elseif Keybind["Mode"] == "Hold" then 
                                                    Keybind.Value = true;
                                                    if not Library.KeybindsContainer:FindFirstChild(Keybind.Name) then 
                                                        Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                    end;
                                                    pcall(Keybind.Callback)
                                                elseif Keybind["Mode"] == "Press" then 
                                                    pcall(Keybind.Callback)
                                                end
                                            end

                                            if Input.UserInputType == Keybind["Key"] and not Keybind.IsBeingSelected then 
                                                if Keybind["Mode"] == "Toggle" then 
                                                    Keybind.Value = not Keybind.Value;
                                                    if Keybind.Name ~= "Open/Close" and Keybind.Name ~= "Open / Close" then 
                                                        Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                    end;
                                                    pcall(Keybind.Callback)
                                                elseif Keybind["Mode"] == "Hold" then 
                                                    Keybind.Value = true;
                                                    if not Library.KeybindsContainer:FindFirstChild(Keybind.Name) then 
                                                        Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                    end;
                                                    pcall(Keybind.Callback)
                                                elseif Keybind["Mode"] == "Press" then 
                                                    pcall(Keybind.Callback)
                                                end
                                            end
                                        end);
            
                                        UserInputService.InputEnded:Connect(function(Input)
                                            if Input.KeyCode == Keybind["Key"] and not Keybind.IsBeingSelected then 
                                                if Keybind["Mode"] == "Hold" then
                                                    Keybind.Value = false;
                                                    Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                    if Data.Callback then pcall(Data.Callback) end;
                                                end
                                            end

                                            if Input.UserInputType == Keybind["Key"] and not Keybind.IsBeingSelected then 
                                                if Keybind["Mode"] == "Hold" then 
                                                    Keybind.Value = false;
                                                    Library:ToggleBind(Keybind.Name, Keybind.AbKey);
                                                    pcall(Keybind.Callback)
                                                end
                                            end
                                        end);
                                    end;

                                    if Keybind.Default then 
                                        Keybind:Set(Keybind.Default);
                                    end;

                                    Library.Flags[Data.Flag] = Keybind;
                                    Section.Bounds = Section.Bounds + 20;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);
                                    return Keybind;
                                end

                                --// Slider
                                function Section:Slider(Data)
                                    local Slider = {
                                        Min = Data.Min, 
                                        Max = Data.Max, 
                                        Default = Data.Default or Data.Max / 2, 
                                        Flag = Data.Flag, 
                                        Suffix = Data.Suffix or "", 
                                        Value = 0,
                                        Name = Data.Name,
                                        AllowDecimals = Data.AllowDecimals,
                                        Callback = Data.Callback or function() end;
                                        Frame = nil;

                                    };
                                    local NewSlider = Instance.new("Frame")
                                    local SliderTitle = Instance.new("TextLabel")
                                    local SliderOutline = Instance.new("Frame")
                                    local SliderInner = Instance.new("ImageButton")
                                    local SliderButton = Instance.new("ImageLabel")
                                    local SliderGradient = Instance.new("UIGradient")
                                    local TextLabel = Instance.new("TextLabel");

                                    local SliderPlus = Instance.new("TextButton");
                                    local SliderMinus = Instance.new("TextButton");
                                    
                                    Slider.Frame = NewSlider;
                                    do --// Slider properties 
                                        NewSlider.Name = "NewSlider"
                                        NewSlider.Parent = SectionInner
                                        NewSlider.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
                                        NewSlider.BackgroundTransparency = 1.000
                                        NewSlider.BorderColor3 = Library.Theme.Border
                                        NewSlider.Position = UDim2.new(0, 2, 0, Section.Bounds)
                                        NewSlider.Size = UDim2.new(1, -4, 0, 30)

                                        SliderMinus.Parent = NewSlider;
                                        SliderMinus.Text = "-";
                                        SliderMinus.Size = UDim2.new(0, 5, 0, 9);
                                        SliderMinus.Position = UDim2.new(1, -7, 0, 0);
                                        SliderMinus.BackgroundTransparency = 1;
                                        SliderMinus.FontFace = Library.MenuFont;
                                        SliderMinus.TextSize = Library.TextSize;
                                        SliderMinus.TextColor3 = Color3.fromRGB(150, 150, 150);

                                        SliderPlus.BackgroundTransparency = 1;
                                        SliderPlus.Text = "+";
                                        SliderPlus.Parent = NewSlider;
                                        SliderPlus.FontFace = Library.MenuFont;
                                        SliderPlus.TextSize = Library.TextSize
                                        SliderPlus.TextColor3 = Color3.fromRGB(150, 150, 150);
                                        SliderPlus.Position = UDim2.new(1, -20, 0, 0);
                                        SliderPlus.Size = UDim2.new(0, 5, 0, 9);

                                        SliderTitle.Name = "SliderTitle"
                                        SliderTitle.Parent = NewSlider
                                        SliderTitle.BackgroundColor3 = Library.Theme.ElementOn
                                        SliderTitle.BackgroundTransparency = 1.000
                                        SliderTitle.BorderColor3 = Library.Theme.Border
                                        SliderTitle.BorderSizePixel = 0
                                        SliderTitle.Position = UDim2.new(0.00990098994, 0, 0, 0)
                                        SliderTitle.Size = UDim2.new(0, 118, 0, 12)
                                        SliderTitle.FontFace = Library.MenuFont
                                        SliderTitle.Text = Slider.Name;
                                        SliderTitle.TextColor3 = Library.Theme.ElementOn
                                        SliderTitle.TextSize = Library.TextSize
                                        SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                                        SliderOutline.Name = "SliderOutline"
                                        SliderOutline.Parent = NewSlider
                                        SliderOutline.BackgroundColor3 = Library.Theme.LightContrast
                                        SliderOutline.BorderColor3 = Library.Theme.Border
                                        SliderOutline.Position = UDim2.new(0, 0, 0, 15)
                                        SliderOutline.Size = UDim2.new(1, 0, 0, 14)

                                        SliderInner.Name = "SliderInner"
                                        SliderInner.Parent = SliderOutline
                                        SliderInner.BackgroundColor3 = Library.Theme.MedianContrast
                                        SliderInner.BorderColor3 = Library.Theme.Border
                                        SliderInner.Position = UDim2.new(0, 2, 0, 2)
                                        SliderInner.Size = UDim2.new(1, -4, 1, -4)
                                        SliderInner.AutoButtonColor = false

                                        SliderButton.Name = "SliderButton"
                                        SliderButton.Parent = SliderInner
                                        SliderButton.BackgroundColor3 = Library.Theme.ElementOn
                                        SliderButton.BorderColor3 = Library.Theme.Border
                                        SliderButton.BorderSizePixel = 0
                                        SliderButton.Size = UDim2.new(1, 0, 1, 0)

                                        SliderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Library.Theme.Accent), ColorSequenceKeypoint.new(1.00, Library.Theme.GradiantContrast2)}
                                        SliderGradient.Rotation = 90
                                        SliderGradient.Name = "SliderGradient"
                                        SliderGradient.Parent = SliderButton

                                        TextLabel.Parent = SliderInner
                                        TextLabel.BackgroundColor3 = Library.Theme.ElementOn
                                        TextLabel.BackgroundTransparency = 1.000
                                        TextLabel.BorderColor3 = Library.Theme.Border
                                        TextLabel.BorderSizePixel = 0
                                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                                        TextLabel.FontFace = Library.MenuFont
                                        TextLabel.Visible = false;
                                        TextLabel.Text = tostring(Data.Default);
                                        TextLabel.TextColor3 = Library.Theme.ElementOff
                                        TextLabel.TextSize = Library.TextSize
                                        TextLabel.TextYAlignment = Enum.TextYAlignment.Top
                                        TextLabel.TextStrokeTransparency = 0;
                                    end;

                                    do --// Slider functions
                                        local isMouseIn = false;
                                        local isSliding = false;
                                        --local Value = {Slider = Default}

                                        SliderPlus.MouseButton1Down:Connect(function()
                                            local NewValue = Slider.Value;
                                            if Slider.AllowDecimals then 
                                                NewValue = Slider.Value + (1 / Slider.AllowDecimals);
                                                if NewValue <= Slider.Max then
                                                    Slider:Set(NewValue);

                                                end;
                                            else 
                                                if (NewValue + 1) <= Slider.Max then 
                                                    Slider:Set(NewValue + 1);
                                                end;
                                            end;
                                        end);

                                        SliderMinus.MouseButton1Down:Connect(function()
                                            local NewValue = Slider.Value
                                            if Slider.AllowDecimals then 
                                                NewValue = Slider.Value - (1 / Slider.AllowDecimals);
                                                if NewValue >= Slider.Min then 
                                                    Slider:Set(NewValue);
                                                end;
                                            else 
                                                if (NewValue - 1) >= Slider.Min then 
                                                    Slider:Set(NewValue - 1);
                                                end;
                                            end;
                                        end);

                                        SliderInner.MouseEnter:Connect(function()
                                            Library:Tween(SliderOutline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                            Library:Tween(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                        end);

                                        SliderInner.MouseLeave:Connect(function()
                                            Library:Tween(SliderOutline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                            Library:Tween(TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                        end);

                                        function Slider:Set(NewValue)
                                            if Slider.AllowDecimals then
                                                --// This is stupid, i know, but, it works really well especially since you would get random decimals like .0000000000003
                                                local Value = (1 / Slider.AllowDecimals) * math.floor(NewValue / (1 / Slider.AllowDecimals));
                                                local Total = string.len(Slider.Suffix) + Slider.AllowDecimals + string.len(tostring(Slider.Max));

                                                Value = string.sub(tostring(Value), 1, Total);
                                                NewValue = tonumber(Value);
                                            else 
                                                NewValue = math.floor(NewValue);
                                            end;

                                            Slider.Value = NewValue;

                                            local Size = (NewValue - Data.Min) / (Data.Max-Data.Min);
                                            SliderButton.Size = UDim2.new(Size, 0, 1, 0);
                                            SliderTitle.Text = Slider.Name..": "..tostring(NewValue)..Slider.Suffix;
                                            TextLabel.Text = tostring(NewValue)..Slider.Suffix;
                                            if Slider.Callback then pcall(Slider.Callback) end;
                                        end;

                                        SliderInner.MouseButton1Down:Connect(function()
                                            SliderButton.Size = UDim2.new(0, math.clamp(Mouse.X - SliderInner.AbsolutePosition.X, 0, math.floor(SliderInner.AbsoluteSize.X)), 1, 0);
                                            local Val = ((((Data.Max - Data.Min) / math.floor(SliderInner.AbsoluteSize.X)) * math.floor(SliderButton.AbsoluteSize.X)) + Data.Min);

                                            if Val then 
                                                Slider:Set(Val);
                                                
                                                if Data.Callback then pcall(Data.Callback) end;
                                            end

                                            isSliding = true;

                                            MoveConn = Mouse.Move:Connect(function()
                                                SliderButton.Size = UDim2.new(0, math.clamp(Mouse.X - SliderInner.AbsolutePosition.X, 0, math.floor(SliderInner.AbsoluteSize.X)), 1, 0);
                                                local Val = ((((Data.Max - Data.Min) / math.floor(SliderInner.AbsoluteSize.X)) * math.floor(SliderButton.AbsoluteSize.X)) + Data.Min);
                                                if Val then 
                                                    Slider:Set(Val);
                                                    if Data.Callback then pcall(Data.Callback) end;
                                                end
                                            end);

                                            ReleaseConn = UserInputService.InputEnded:Connect(function(Inp)
                                                if Inp.UserInputType == Enum.UserInputType.MouseButton1 then 
                                                    SliderButton.Size = UDim2.new(0, math.clamp(Mouse.X - SliderInner.AbsolutePosition.X, 0,math.floor(SliderInner.AbsoluteSize.X)), 1, 0);
                                                    local Val = ((((Data.Max - Data.Min) / math.floor(SliderInner.AbsoluteSize.X)) * math.floor(SliderButton.AbsoluteSize.X)) + Data.Min);
                                                    if Val then 
                                                        Slider:Set(Val);
                                                        if Data.Callback then pcall(Data.Callback) end;
                                                    end

                                                    isSliding = false;
                                                    ReleaseConn:Disconnect();
                                                    MoveConn:Disconnect();
                                                end
                                            end);
                                        end)
                                    end;
                                    
                                    Section.Bounds = Section.Bounds + 35;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);

                                    Slider:Set(Slider.Default) 
                                    Library.Flags[Data.Flag] = Slider;

                                    if Slider.Callback then  pcall(Slider.Callback) end;
                                    return Slider
                                end;

                                --// Multi list
                                function Section:Multidropdown(Data)
                                    local Dropdown = {
                                        Name = Data.Name,
                                        Flag = Data.Flag,
                                        Value = {},
                                        Options = {};
                                        Max = Data.Max or #Data.Options;
                                        IsOpen = false;
                                        Multi = true;
                                        Default = Data.Default;
                                        Frame = nil;
                                    };
                                    local NewDropdown = Instance.new("Frame")
                                    local DropdownOutline = Instance.new("Frame")
                                    local DropdownInner = Instance.new("TextButton")
                                    local DropdownFlag = Instance.new("TextLabel")
                                    local DropdownStatus = Instance.new("TextLabel")
                                    local ContainerOutline = Instance.new("Frame")
                                    local Container = Instance.new("Frame")
                                    local ContainerLayout = Instance.new("UIListLayout")
                                    local DropdownTitle = Instance.new("TextLabel")

                                    Dropdown.Frame = NewDropdown;

                                    do --// Dropdown properties 
                                        NewDropdown.Name = "NewDropdown"
                                        NewDropdown.Parent = SectionInner
                                        NewDropdown.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                                        NewDropdown.BackgroundTransparency = 1.000
                                        NewDropdown.BorderColor3 = Library.Theme.Border
                                        NewDropdown.BorderSizePixel = 0
                                        NewDropdown.Position = UDim2.new(0, 2, 0, Section.Bounds)
                                        NewDropdown.Size = UDim2.new(1, -4, 0, 32)
                                        NewDropdown.ZIndex = Window.ImportantIndex;

                                        Window.ImportantIndex = Window.ImportantIndex - 1;

                                        DropdownOutline.Name = "DropdownOutline"
                                        DropdownOutline.Parent = NewDropdown
                                        DropdownOutline.BackgroundColor3 = Library.Theme.LightContrast
                                        DropdownOutline.BorderColor3 = Library.Theme.Border
                                        DropdownOutline.Position = UDim2.new(0, 0, 0, 15)
                                        DropdownOutline.Size = UDim2.new(1, 0, 0, 16)
                                        
                                        DropdownInner.Name = "DropdownInner"
                                        DropdownInner.Parent = DropdownOutline
                                        DropdownInner.BackgroundColor3 = Library.Theme.MedianContrast
                                        DropdownInner.BorderColor3 = Library.Theme.Border
                                        DropdownInner.Position = UDim2.new(0, 2, 0, 2)
                                        DropdownInner.Size = UDim2.new(1, -4, 1, -4)
                                        DropdownInner.Text = "";

                                        DropdownInner.AutoButtonColor = false;

                                        DropdownFlag.Name = "DropdownFlag"
                                        DropdownFlag.Parent = DropdownInner
                                        DropdownFlag.BackgroundColor3 = Library.Theme.ElementOn
                                        DropdownFlag.BackgroundTransparency = 1.000
                                        DropdownFlag.BorderColor3 = Library.Theme.Border
                                        DropdownFlag.BorderSizePixel = 0
                                        DropdownFlag.Size = UDim2.new(1, 0, 1, 0)
                                        DropdownFlag.FontFace = Library.MenuFont
                                        DropdownFlag.Text = "";
                                        DropdownFlag.TextColor3 = Library.Theme.ElementOn
                                        DropdownFlag.TextSize = Library.TextSize
                                        
                                        DropdownStatus.Name = "DropdownStatus"
                                        DropdownStatus.Parent = DropdownInner
                                        DropdownStatus.BackgroundColor3 = Library.Theme.ElementOn
                                        DropdownStatus.BackgroundTransparency = 1.000
                                        DropdownStatus.BorderColor3 = Library.Theme.Border
                                        DropdownStatus.BorderSizePixel = 0
                                        DropdownStatus.Position = UDim2.new(0.929292917, 0, -0.166666672, 0)
                                        DropdownStatus.Size = UDim2.new(0, 14, 0, 14)
                                        DropdownStatus.FontFace = Library.MenuFont
                                        DropdownStatus.Text = "+"
                                        DropdownStatus.TextColor3 = Library.Theme.ElementOn
                                        DropdownStatus.TextSize = Library.TextSize
                                        
                                        ContainerOutline.Name = "ContainerOutline"
                                        ContainerOutline.Parent = DropdownInner
                                        ContainerOutline.BackgroundColor3 = Library.Theme.LightContrast
                                        ContainerOutline.BorderColor3 = Library.Theme.Border
                                        ContainerOutline.Position = UDim2.new(0, -2, 1, 4);
                                        ContainerOutline.ClipsDescendants = true;
                                        ContainerOutline.Size = UDim2.new(1, 4, 0, 0);

                                        ContainerOutline.Visible = false
                                        
                                        Dropdown.Container = ContainerOutline;

                                        Container.Name = "Container"
                                        Container.Parent = ContainerOutline
                                        Container.BackgroundColor3 = Library.Theme.MedianContrast
                                        Container.BorderColor3 = Library.Theme.Border
                                        Container.Position = UDim2.new(0, 2, 0, 2)
                                        Container.Size = UDim2.new(1, -4, 1, -4)
                                        Container.Visible = true;

                                        ContainerLayout.Parent = Container
                                        ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                        
                                        DropdownTitle.Name = "DropdownTitle"
                                        DropdownTitle.Parent = NewDropdown
                                        DropdownTitle.BackgroundColor3 = Library.Theme.ElementOn
                                        DropdownTitle.BackgroundTransparency = 1.000
                                        DropdownTitle.BorderColor3 = Library.Theme.Border
                                        DropdownTitle.BorderSizePixel = 0
                                        DropdownTitle.Position = UDim2.new(0.00990098994, 0, 0, 0)
                                        DropdownTitle.Size = UDim2.new(0.990099013, 0, 0, 14)
                                        DropdownTitle.FontFace = Library.MenuFont
                                        DropdownTitle.Text = Data.Name;
                                        DropdownTitle.TextColor3 = Library.Theme.ElementOn
                                        DropdownTitle.TextSize = Library.TextSize
                                        DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                                        DropdownTitle.TextYAlignment = Enum.TextYAlignment.Top
                                    end;

                                    do --// Dropdown functions 

                                        function Dropdown:Toggle()
                                            Dropdown.IsOpen = not Dropdown.IsOpen; 
                                            local SizeToTween;

                                            if Dropdown.IsOpen then 
                                                Dropdown.Container.Visible = true;
                                            end;

                                            if Dropdown.Max ~= 1 then 
                                                SizeToTween = UDim2.new(1, 4, 0, (14 * Dropdown.Max) + 4);
                                            else 
                                                SizeToTween = UDim2.new(1, 4, 0, 14);
                                            end;

                                            if Dropdown.IsOpen then 
                                                if Library.CurrentDropdown then 
                                                    Library.CurrentDropdown.Container.Visible = false;
                                                    Library.CurrentDropdown.Container.Size = UDim2.new(1, 4, 0, 0)
                                                    Library.CurrentDropdown.IsOpen = false;
                                                end;
                                                Library.CurrentDropdown = Dropdown;

                                                Library:Tween(Dropdown.Container, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = SizeToTween});
                                            else
                                                Library.CurrentDropdown = nil;
                                                Library:Tween(Dropdown.Container, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, 4, 0, 0)});
                                                task.wait(0.2);
                                                Dropdown.Container.Visible = false;
                                            end;
                                        end;

                                        function Dropdown:Update()
                                            --if Dropdown.Max ~= 1 then 
                                            --    ContainerOutline.Size = UDim2.new(1, 4, 0, (14 * Dropdown.Max) + 4);
                                            --else 
                                            --    ContainerOutline.Size = UDim2.new(1, 4, 0, 14);
                                            --end;
                                        end;
                                        
                                        DropdownInner.MouseEnter:Connect(function()
                                            Library:Tween(DropdownOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.Accent});
                                        end);
                                        
                                        DropdownInner.MouseLeave:Connect(function()
                                            Library:Tween(DropdownOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Library.Theme.LightContrast});
                                        end);

                                        DropdownInner.MouseButton1Down:Connect(function()
                                            Dropdown:Toggle();
                                        end);
                                        
                                        function Dropdown:Set(Value)
                                            Dropdown.Value = {};
                                            DropdownFlag.Text = "";

                                            for Index, Value in next, Dropdown.Options do 
                                                Dropdown.Options[Index].IsSelected = false; 
                                                Dropdown.Options[Index].Selector.Visible = false; 
                                                Library:Tween(Dropdown.Options[Index].Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                            end;

                                            if type(Value) == "table" then 
                                                for Index, Value in next, Value do 
                                                    DropdownFlag.Text = DropdownFlag.Text .. Value..", "
                                                end;
                                                DropdownFlag.Text = DropdownFlag.Text:sub(1, -3);
                                                local Split = DropdownFlag.Text:split();
                                                
                                                if DropdownFlag.TextBounds.X > (DropdownFlag.AbsoluteSize.X - 10) then 
                                                    DropdownFlag.Text = DropdownFlag.Text:sub(1, 17) .. "...";
                                                end;
                
                                            end;
                
                                            for Index, Value in next, Value do
                                                if Dropdown.Options[Value] then
                                                    table.insert(Dropdown.Value, Value)
                                                    Dropdown.Options[Value].Selector.Visible = true;
                                                    Library:Tween(Dropdown.Options[Value].Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                                    Dropdown.Options[Value].IsSelected = true;
                                                end;
                                            end;

                                            --[[local TempTable = {};
                                            for Index, Value in next, Dropdown.Value do 
                                                TempTable[Value] = Value;
                                            end;

                                            for I, V in next, Dropdown.Options do 
                                                if not TempTable[V] then
                                                    Dropdown.Options[I].IsSelected = false;
                                                    Dropdown.Options[I].Selector.Visible = false; 
                                                    Dropdown.Options[I].Button.TextColor3 = Library.Theme.ElementOff;
                                                end;
                                            end;

                                            for Index, Value in next, Dropdown.Options do 
                                                warn(Index, Value);
                                            end;]]
                                            if Dropdown.Callback then pcall(Dropdown.Callback); end;
                                        end;

                                        function Dropdown:AddOption(Name)
                                            local NewOption = Instance.new("TextButton")
                                            local Frame = Instance.new("Frame")

                                            local Option = {
                                                Name = Name;
                                                IsSelected = false;
                                                Selector = Frame;
                                                Button = NewOption;
                                            };

                                            NewOption.Name = "NewOption"
                                            NewOption.Parent = Container
                                            NewOption.BackgroundColor3 = Library.Theme.ElementOff
                                            NewOption.BackgroundTransparency = 1.000
                                            NewOption.BorderColor3 = Library.Theme.Border
                                            NewOption.BorderSizePixel = 0
                                            NewOption.Size = UDim2.new(1, 0, 0, 14)
                                            NewOption.FontFace = Library.MenuFont
                                            NewOption.Text = Name;
                                            NewOption.TextColor3 = Library.Theme.ElementOff;
                                            NewOption.TextSize = Library.TextSize
                                            
                                            Frame.Parent = NewOption
                                            Frame.BackgroundColor3 = Library.Theme.Accent
                                            Frame.BorderColor3 = Library.Theme.Border
                                            Frame.BorderSizePixel = 0
                                            Frame.Size = UDim2.new(0, 2, 1, 0);
                                            Frame.Visible = false;

                                            NewOption.MouseButton1Down:Connect(function()
                                                Option.IsSelected = not Option.IsSelected;
                                                if Option.IsSelected then
                                                    Library:Tween(NewOption, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                                    Frame.Visible = true;
                                                    task.spawn(function()
                                                        Dropdown.Value[#Dropdown.Value+1] = Option.Name
                                                        Dropdown:Set(Dropdown.Value);
                                                    end);
                                                else
                                                    task.spawn(function()
                                                        for Index, Value in next, Dropdown.Value do 
                                                            if Value == Option.Name then 
                                                                Dropdown.Value[Index] = nil;
                                                            end;
                                                        end;
                
                                                        Dropdown:Set(Dropdown.Value);
                                                    end);
                                                    Frame.Visible = false;
                                                    Library:Tween(NewOption, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                end;
                                            end);
                                            Dropdown.Options[Option.Name] = Option;

                                            return Option;
                                        end;

                                        function Dropdown:RemoveOption(Name)
                                            if Dropdown.Options[Name] then
                                                Dropdown.Options[Name].Button:Destroy();
                                                Dropdown.Options[Name] = nil;
                                            end;
                                        end;
                                    end;

                                    for Index, Value in next, Data.Options do 
                                        Dropdown:AddOption(Value);
                                    end;

                                    if Dropdown.Default then
                                        Dropdown:Set(Dropdown.Default);
                                    else 
                                        Dropdown:Set({Data.Options[1]});
                                    end;
                                    Section.Bounds = Section.Bounds + 37;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);

                                    Library.Flags[Data.Flag] = Dropdown;
                                    return Dropdown;
                                end;

                                function Section:List(Data)
                                    local List = {
                                        Options = {};
                                        Value = "";
                                        Name = Data.Name;
                                        Flag = Data.Flag;
                                        Callback = Data.Callback or function() end;
                                    };

                                    local Holder = Instance.new("Frame")
                                    local TextLabel = Instance.new("TextLabel")
                                    local MainOutline = Instance.new("Frame")
                                    local MainOutline2 = Instance.new("Frame")
                                    local ScrollingFrame = Instance.new("ScrollingFrame")
                                    local UIListLayout = Instance.new("UIListLayout")

                                    do --// Properties
                                        Holder.Name = "Holder"
                                        Holder.Parent = SectionInner
                                        Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                        Holder.BackgroundTransparency = 1.000
                                        Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        Holder.BorderSizePixel = 0
                                        Holder.Position = UDim2.new(0, 2, 0, Section.Bounds)
                                        Holder.Size = UDim2.new(1, -4, 0, 100)

                                        TextLabel.Parent = Holder
                                        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                        TextLabel.BackgroundTransparency = 1.000
                                        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        TextLabel.BorderSizePixel = 0
                                        TextLabel.Position = UDim2.new(0.00999999978, 0, 0, 0)
                                        TextLabel.Size = UDim2.new(0.899999976, 0, 0, 14)
                                        TextLabel.FontFace = Library.MenuFont
                                        TextLabel.Text = Data.Name
                                        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        TextLabel.TextSize = Library.TextSize
                                        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

                                        MainOutline.Name = "MainOutline"
                                        MainOutline.Parent = Holder
                                        MainOutline.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
                                        MainOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        MainOutline.Position = UDim2.new(0, 0, 0, 14)
                                        MainOutline.Size = UDim2.new(1, 0, 0, 100)

                                        MainOutline2.Name = "MainOutline2"
                                        MainOutline2.Parent = MainOutline
                                        MainOutline2.BackgroundColor3 = Library.Theme.MedianContrast;
                                        MainOutline2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        MainOutline2.Position = UDim2.new(0, 2, 0, 2)
                                        MainOutline2.Size = UDim2.new(1, -4, 1, -4)

                                        ScrollingFrame.Parent = MainOutline2
                                        ScrollingFrame.Active = true
                                        ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                        ScrollingFrame.BackgroundTransparency = 1.000
                                        ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                        ScrollingFrame.BorderSizePixel = 0
                                        ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
                                        ScrollingFrame.ScrollBarThickness = 3
                                        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(34, 34, 34);
                                        ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
                                        UIListLayout.Parent = ScrollingFrame
                                        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                    end;

                                    do --// Functions 
                                        function List:AddOption(Name)
                                            local OptionData = {
                                                Name = Name;
                                                IsSelected = false;
                                            };

                                            local Option = Instance.new("TextButton");
                                            OptionData.Button = Option;
                                            Option.Name = "Option"
                                            Option.Parent = ScrollingFrame
                                            Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                            Option.BackgroundTransparency = 1.000
                                            Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            Option.BorderSizePixel = 0
                                            Option.Size = UDim2.new(1, 0, 0, 14)
                                            Option.AutoButtonColor = false
                                            Option.FontFace = Library.MenuFont;
                                            Option.TextColor3 = Library.Theme.ElementOff
                                            Option.TextSize = Library.TextSize
                                            Option.Text = OptionData.Name;

                                            Option.MouseButton1Down:Connect(function()
                                                OptionData.IsSelected = not OptionData.IsSelected

                                                for Index, Value in next, List.Options do 
                                                    if Value ~= OptionData then 
                                                        Value.IsSelected = false;
                                                        Library:Tween(Value.Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                    end;
                                                end;
                                                if OptionData.IsSelected then 
                                                    List:Set(OptionData.Name);
                                                else
                                                    Library:Tween(Option, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                end;
                                            end);

                                            List.Options[OptionData.Name] = OptionData
                                        end;

                                        function List:RemoveOption(Name)
                                            if List.Options[Name] then
                                                List.Options[Name].Button:Destroy();
                                                List.Options[Name] = nil;
                                            end;
                                        end;

                                        function List:Set(Value)
                                            if List.Options[Value] then
                                                List.Value = Value;
                                                List.Options[Value].IsSelected = true;
                                                Library:Tween(List.Options[Value].Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                            end;

                                            for Index, Val in pairs(List.Options) do 
                                                if Val ~= List.Options[Value] then 
                                                    Val.IsSelected = false; 
                                                    Library:Tween(Val.Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                end;    
                                            end;

                                            if List.Callback then pcall(List.Callback); end;
                                        end;
                                    end;

                                    for Index, Value in next, Data.Options do 
                                        List:AddOption(Value);
                                    end;

                                    Library.Flags[Data.Flag] = List;
                                    Section.Bounds = Section.Bounds + 117;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);
                                    return List;
                                end;

                                function Section:Searchbar(Data)
                                    local List = {
                                        Options = {};
                                        Value = {};
                                        Name = Data.Name;
                                        Flag = Data.Flag;
                                        Callback = Data.Callback or function() end;
                                    };

                                    pcall(function()
                                        local Holder = Instance.new("Frame")
                                        local TextLabel = Instance.new("TextLabel")
                                        local MainOutline = Instance.new("Frame")
                                        local MainOutline2 = Instance.new("Frame")
                                        local ScrollingFrame = Instance.new("ScrollingFrame")
                                        local UIListLayout = Instance.new("UIListLayout")
                                        local SearchBoxOutline = Instance.new("Frame")
                                        local Searchbox = Instance.new("TextBox");
                                    
                                        do --// Properties
                                            Holder.Name = "Holder"
                                            Holder.Parent = SectionInner
                                            Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                            Holder.BackgroundTransparency = 1.000
                                            Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            Holder.BorderSizePixel = 0
                                            Holder.Position = UDim2.new(0, 2, 0, Section.Bounds)
                                            Holder.Size = UDim2.new(1, -4, 0, 100)

                                            SearchBoxOutline.Parent = Holder; 
                                            SearchBoxOutline.BackgroundColor3 = Library.Theme.LightContrast; 
                                            SearchBoxOutline.Size = UDim2.new(1, 0, 0, 14);
                                            SearchBoxOutline.Position = UDim2.new(0, 0, 0, 13);
                                            SearchBoxOutline.BorderColor3 = Library.Theme.Border; 
                                            SearchBoxOutline.BorderSizePixel = 1; 
                                            
                                            Searchbox.Name = "SetBox"
                                            Searchbox.Parent = SearchBoxOutline
                                            Searchbox.BackgroundColor3 = Library.Theme.MedianContrast
                                            Searchbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            Searchbox.Position = UDim2.new(0, 2, 0, 2)
                                            Searchbox.Size = UDim2.new(1, -4, 1, -4)
                                            Searchbox.FontFace = Library.MenuFont;
                                            Searchbox.TextYAlignment = Enum.TextYAlignment.Bottom
                                            Searchbox.Text = "";
                                            Searchbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                                            Searchbox.TextSize = Library.TextSize

                                            TextLabel.Parent = Holder
                                            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                            TextLabel.BackgroundTransparency = 1.000
                                            TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            TextLabel.BorderSizePixel = 0
                                            TextLabel.Position = UDim2.new(0.00999999978, 0, 0, 0)
                                            TextLabel.Size = UDim2.new(0.899999976, 0, 0, 14)
                                            TextLabel.FontFace = Library.MenuFont
                                            TextLabel.Text = Data.Name
                                            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                            TextLabel.TextSize = Library.TextSize
                                            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

                                            MainOutline.Name = "MainOutline"
                                            MainOutline.Parent = Holder
                                            MainOutline.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
                                            MainOutline.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            MainOutline.Position = UDim2.new(0, 0, 0, 28)
                                            MainOutline.Size = UDim2.new(1, 0, 0, 50)

                                            MainOutline2.Name = "MainOutline2"
                                            MainOutline2.Parent = MainOutline
                                            MainOutline2.BackgroundColor3 = Library.Theme.MedianContrast;
                                            MainOutline2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            MainOutline2.Position = UDim2.new(0, 2, 0, 2)
                                            MainOutline2.Size = UDim2.new(1, -4, 1, -4)

                                            ScrollingFrame.Parent = MainOutline2
                                            ScrollingFrame.Active = true
                                            ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                            ScrollingFrame.BackgroundTransparency = 1.000
                                            ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                            ScrollingFrame.BorderSizePixel = 0
                                            ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
                                            ScrollingFrame.ScrollBarThickness = 3
                                            ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(34, 34, 34);
                                            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
                                            UIListLayout.Parent = ScrollingFrame
                                            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                        end;

                                        do --// Functions 
                                            function List:BeginSearching()
                                                for Index, Value in next, ScrollingFrame:GetChildren() do 
                                                    if Value:IsA("GuiButton") then 
                                                        local Text = string.lower(Value.Text);
                                                        local Search = string.lower(Searchbox.Text);
                                                        if Searchbox.Text == "" then 
                                                            Value.Visible = true;
                                                        else 
                                                            if string.find(Text, Search) then 
                                                                Value.Visible = true; 
                                                            else 
                                                                Value.Visible = false;
                                                            end;    
                                                        end;
                                                    end;
                                                end;
                                            end;

                                            function List:AddOption(Name)
                                                local OptionData = {
                                                    Name = Name;
                                                    IsSelected = false;
                                                };

                                                local Option = Instance.new("TextButton");
                                                OptionData.Button = Option;
                                                Option.Name = "Option"
                                                Option.Parent = ScrollingFrame
                                                Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                                Option.BackgroundTransparency = 1.000
                                                Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                                                Option.BorderSizePixel = 0
                                                Option.Size = UDim2.new(1, 0, 0, 14)
                                                Option.AutoButtonColor = false
                                                Option.FontFace = Library.MenuFont;
                                                Option.TextColor3 = Library.Theme.ElementOff
                                                Option.TextSize = Library.TextSize
                                                Option.Text = OptionData.Name;
                                                
                                                Option.MouseButton1Down:Connect(function()
                                                    OptionData.IsSelected = not OptionData.IsSelected


                                                    if OptionData.IsSelected then 
                                                        task.spawn(function()
                                                            List.Value[#List.Value+1] = OptionData.Name
                                                            List:Set(List.Value);
                                                        end);
                                                    else
                                                        for Index, Value in next, List.Value do 
                                                            if Value == OptionData.Name then 
                                                                List.Value[Index] = nil;
                                                            end;
                                                        end;

                                                        Library:Tween(Option, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                    end;
                                                end);

                                                OptionData.Button = Option;

                                                List.Options[OptionData.Name] = OptionData
                                            end;

                                            function List:Set(Value)
                                                List.Value = {};
                                                for Index, Value in next, List.Options do 
                                                    List.Options[Index].IsSelected = false; 
                                                    Library:Tween(List.Options[Index].Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOff});
                                                end;
                    
                                                for Index, Value in next, Value do
                                                    if List.Options[Value] then
                                                        table.insert(List.Value, Value)
                                                        Library:Tween(List.Options[Value].Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.ElementOn});
                                                        List.Options[Value].IsSelected = true;
                                                    end;
                                                end;
                                                if List.Callback then pcall(List.Callback); end;
                                            end;

                                            function List:RemoveOption(Name)
                                                if List.Options[Name] then
                                                    List.Options[Name].Button:Destroy();
                                                    List.Options[Name] = nil;
                                                end;
                                            end;

                                        end;

                                        do --// Searching 
                                            Searchbox:GetPropertyChangedSignal("Text"):Connect(function()
                                                List:BeginSearching();
                                            end);
                                        end;

                                        for Index, Value in next, Data.Options do 
                                            List:AddOption(Value);
                                        end;
                                    end);

                                    Library.Flags[Data.Flag] = List;
                                    Section.Bounds = Section.Bounds + 84;
                                    SectionBorder.Size = UDim2.new(1, 0, 0, Section.Bounds);
                                    return List;
                                end;
 
                            end;
                            Window.Tabs[Tab.Name].Sections[Data.Name] = Section
                            return Section
                        end;

                        Window.Tabs[Tab.Name] = Tab;
                        Window:UpdateTabs();
                        return Tab;
                    end;

                    function Window:Tooltip(Data)
                        local Tooltip = {
                            Text = Data.Text; 
                            Parent = Data.Parent;
                            PhysicalParent = nil;
                            Frame = nil;
                            IsIn = false;
                        };

                        local Parent = Tooltip.Parent;
                        Tooltip.PhysicalParent = Parent.Frame;

                        local Outline_Tip = Instance.new("Frame");
                        local Inner_Tip = Instance.new("Frame", Outline_Tip);
                        local New_Text = Instance.new("TextLabel", Inner_Tip);

                        local Frame = Tooltip.PhysicalParent;
                        Tooltip.Frame = Outline_Tip;

                        do --// Properties
                            Outline_Tip.Parent = WindowBorder;
                            Outline_Tip.Name = "Tooltip - "..Data.Text;
                            Outline_Tip.BackgroundColor3 = Library.Theme.LightContrast;
                            Outline_Tip.ZIndex = 1001;
                            Outline_Tip.BorderSizePixel = 1;
                            Outline_Tip.BorderColor3 = Library.Theme.Border;
                            Outline_Tip.Visible = true;
                            Outline_Tip.BackgroundTransparency = 1;
                            Outline_Tip.Size = UDim2.new(1, 0, 0, 12)
                            Outline_Tip.Position = UDim2.new(0, 0, 1, 3);

                            Inner_Tip.BackgroundColor3 = Library.Theme.DarkContrast;
                            Inner_Tip.BorderSizePixel = 1;
                            Inner_Tip.Size = UDim2.new(1, -4, 1, -4);
                            Inner_Tip.Position = UDim2.new(0, 2, 0, 2);
                            Inner_Tip.BorderColor3 = Library.Theme.Border;
                            Inner_Tip.BackgroundTransparency = 1;

                            New_Text.BackgroundTransparency = 1;
                            New_Text.TextTransparency = 1;
                            New_Text.FontFace  = Library.MenuFont;
                            New_Text.TextSize = Library.TextSize;
                            New_Text.TextColor3 = Color3.new(1,1,1);
                            New_Text.Size = UDim2.new(1, 0, 1, 0);
                            New_Text.Name = "New_TextTip"
                        end;

                        do --// Functions

                            Frame.MouseEnter:Connect(function()
                                Tooltip.IsIn = true;
                                Library:Tween(Inner_Tip, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0});
                                Library:Tween(Outline_Tip, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0});
                                Library:Tween(New_Text, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {TextTransparency = 0});
                            end);

                            Frame.MouseLeave:Connect(function()
                                Tooltip.IsIn = false;
                                Library:Tween(Inner_Tip, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                                Library:Tween(Outline_Tip, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1});
                                local TextTween = Library:Tween(New_Text, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1});
                            end);

                        end;
                        New_Text.Text = Tooltip.Text;
                    end;
                end;

                Window.Main = LibraryScreenGui;
                
                Library.Windows[#Library.Windows+1] = Window;
                return Window
            end;

            function Library:AddSettingsTab(Window)
                local SettingsTab = Window:NewTab({Name = "Settings"}); 

                do  --// Settings sections
                    local MenuSection = SettingsTab:NewSection({Name = "Menu", Side = "Left"}); do 

                        MenuSection:Keybind({Name = "Open / Close", Mode = "Toggle", Flag = "Open/Close", Default = Enum.KeyCode.LeftBracket, Callback = function()
                            Library:ToggleMenu()
                        end});

                        MenuSection:Toggle({Name = "Blur background when open", Flag = "Blurbackground"});

                        MenuSection:Toggle({Name = "Watermark", Flag = "ShowWatermark", Callback = function() 
                            Library.WatermarkOutline.Visible = Library.Flags.ShowWatermark.Value;
                        end});

                        MenuSection:Slider({Suffix = "%", Name = "Watermark Offset X", Flag = "WatermarkX", Default = 7, Min = 0, Max = 100, Callback = function()
                            Library.WatermarkOutline.Position = UDim2.new(Library.Flags.WatermarkX.Value / 100, 0, Library.Flags.WatermarkY.Value / 100, 0)
                        end});
        
                        MenuSection:Slider({Suffix = "%", Name = "Watermark Offset Y", Flag = "WatermarkY", Default = 0, Min = 0, Max = 100, Callback = function()
                            Library.WatermarkOutline.Position = UDim2.new(Library.Flags.WatermarkX.Value / 100, 0, Library.Flags.WatermarkY.Value / 100, 0)
                        end});

                        MenuSection:Toggle({Name = "Keybinds", Flag = "ShowKeybinds", Callback = function()
                            Library.KeybindsGUI.Visible = Library.Flags.ShowKeybinds.Value;
                        end})

                        MenuSection:Slider({Suffix = "%", Name = "Keybinds Offset X", Flag = "KeybindX", Default = 2, Min = 0, Max = 100, Callback = function()
                            Library.KeybindsGUI.Position = UDim2.new(Library.Flags.KeybindX.Value / 100, 0, Library.Flags.KeybindY.Value / 100, 0)
                        end});
        
                        MenuSection:Slider({Suffix = "%", Name = "Keybinds Offset Y", Flag = "KeybindY", Default = 46, Min = 0, Max = 100, Callback = function()
                            Library.KeybindsGUI.Position = UDim2.new(Library.Flags.KeybindX.Value / 100, 0, Library.Flags.KeybindY.Value / 100, 0)
                        end});

                        MenuSection:Button({Name = "Revert to default size", Callback = function()
                            Window.Border.Size = Window.DefaultSize;
                        end})
                    end;

                    local GameSection = SettingsTab:NewSection({Name = "Game", Side = "Left"}); do
                        GameSection:Toggle({Flag = "Telemetry", Name = "Broadcast status (TELEMETRY)", Risky = true, Callback = function()
                            if Library.Flags.Telemetry.Value then 
                                Websocket:Initialize()
                            end;
                        end})
                        GameSection:Slider({Default = 60, Flag = "FPSCAP", Name = "FPS Cap", Min = 0, Max = 400, Callback = function()
                            setfpscap(Library.Flags.FPSCAP.Value)
                        end})
                        GameSection:Button({Name = "Rejoin", Callback = function()
                            TeleportService:Teleport(game.PlaceId);
                        end});
                    end;

                    local ConfigDropdown;

                    local function RefreshConfigs()
                        if listfiles then 
                            for Index, Value in next, ConfigDropdown.Options do
                                ConfigDropdown:RemoveOption(Index)
                            end;
                            
                            local List = {};
                            for Index, File in ipairs(listfiles("Ethereal/Configs")) do
                                local FileName = File:gsub("Ethereal/Configs\\", ""):gsub(".txt", "")
                                List[#List + 1] = FileName;
                            end;
        
                            for Index, Value in next, List do
                                ConfigDropdown:AddOption(Value);
                            end;

                            --ConfigDropdown:Update();
                        else 
                            for Index, Value in next, ConfigDropdown.Options do
                                ConfigDropdown:RemoveOption(Index)
                            end;
                            ConfigDropdown:AddOption("Legit");
                            ConfigDropdown:AddOption("Rage");
                            ConfigDropdown:AddOption("Semirage");
                            ConfigDropdown:AddOption("Semilegit");
                            --ConfigDropdown:Update();
                        end;
                    end;

                    local ConfigSection = SettingsTab:NewSection({Name = "Config", Side = "Right"}); do 
                        ConfigDropdown = ConfigSection:List({Name = "Selected config", Options = {""}, Flag = "SelectedConfig"});

                        Library.WatermarkText.Text = ("Ethereal | %s | %s | Config - %s"):format(GameName, LRM_LinkedDiscordID, Library.Config);
                        ConfigSection:Button({Name = "Load selected config", Callback = function()
                            Library.Config = Library.Flags.SelectedConfig.Value;
                            Library.WatermarkText.Text = ("Ethereal | %s | %s | Config - %s"):format(GameName, LRM_LinkedDiscordID, Library.Config);
                            Library:Notify("Loading config | Config name: ".. Library.Flags.SelectedConfig.Value, 3);
                            Library:LoadConfig(readfile("Ethereal/Configs/"..Library.Flags["SelectedConfig"].Value..".txt"));
                        end});
        
                        ConfigSection:Button({Name = "Save selected config", Callback = function()
                            Library:Notify("Saving config | Config name: ".. Library.Flags.SelectedConfig.Value, 3);
                            Library:SaveConfig(Library.Flags["SelectedConfig"].Value);
                        end})
                        ConfigSection:Button({Name = "Delete selected Config", Callback = function()
                            task.spawn(function()
                                Library:Notify("Deleting config | Config name: ".. Library.Flags.SelectedConfig.Value, 3);
                                Library:DeleteConfig(Library.Flags["SelectedConfig"].Value)
                                task.wait(0.2);
                                Library:Notify("Refreshing configs...");

                                RefreshConfigs()
                            end);
                        end});
                        ConfigSection:Button({Name = "Refresh configs", Callback = function()
                            task.spawn(function()
                                Library:Notify("Refreshing configs...");
                                RefreshConfigs()
                            end);
                        end});
    
        
                        --// Refreshing configs
                        do 
                        RefreshConfigs();
                        end;
                    end;

                    local CreateSection = SettingsTab:NewSection({Name = "Create", Side = "Right"}); do 
                        CreateSection:Textbox({Name = "New Config Name Here", Flag = "NewConfigName"});
                        CreateSection:Button({Name = "Create new config", Callback = function()
                            task.spawn(function()
                                Library:Notify("Creating config | Config name: ".. Library.Flags.NewConfigName.Value, 3)
                                Library:SaveConfig(Library.Flags["NewConfigName"].Value);
                                task.wait(0.3);
                                Library.WatermarkText.Text = ("Ethereal | %s | %s | Config - %s"):format(GameName, LRM_LinkedDiscordID, Library.Config);
                                RefreshConfigs()
                                Library:Notify("Created config! | Config name: ".. Library.Flags.NewConfigName.Value .. ", refreshing configs now!", 3);
                                
                            end);
                        end})
                    end;

                    local PluginSection = SettingsTab:NewSection({Name = "Plugins", Side = "Right"}); do 
                        local function RefreshPlugins()
                            local List = {};
                            for Index, Value in next, Library.Flags.SelectedPlugin.Options do
                                Library.Flags.SelectedPlugin:RemoveOption(Index)
                            end;
                            
                            if listfiles then 
                                for Index, File in ipairs(listfiles("Ethereal/Plugins")) do
                                    local FileName = File:gsub("Ethereal/Plugins\\", ""):gsub(".lua", "")
                                    List[#List + 1] = FileName;
                                end;
            
                                for Index, Value in next, List do
                                    Library.Flags.SelectedPlugin:AddOption(Value);
                                end;
                            end;
    
                            Library.Flags.SelectedPlugin.Max = #List;
                            Library.Flags.SelectedPlugin:Update()
                        end;
                        PluginSection:Dropdown({Name = "Selected plugin", Flag = "SelectedPlugin", Max = 3, Options = {""}});
                        PluginSection:Button({Name = "Load plugin", Callback = function()
                            Library:Notify("Loading plugin | Plugin name: "..Library.Flags.SelectedPlugin.Value, 2);
                            loadfile("Ethereal/Plugins/"..Library.Flags.SelectedPlugin.Value..".lua")();
                        end})
                        PluginSection:Button({Name = "Refresh plugins", Callback = function()
                            Library:Notify("Refreshing plugins...", 2);
                            RefreshPlugins()
                        end})
                        RefreshPlugins()
                    end;

                    if not LPH_OBFUSCATED then 
                        local Test = SettingsTab:NewSection({Name = "Studio Testing", Side = "Left"}); do 
                            Test:Searchbar({Options = {"762x39", "762x39AP", "Altyn", "6b43", "DV2", "AKM", "6b12", "Makarov", "APS", "Nuts", "Oil can"}, Max = 3, Name = "Searchbar", Flag = "Searchbar"})
                        end;
                    end;
                end;
            end;

            function Library:AddFontSection(Tab, Side)
                local FontSection = Tab:NewSection({Name = "Font", Side = Side});
                local Options = {"Menu", "Smallest Pixel"}
                FontSection:Dropdown({Name = "World ESP Font", Options = Options, Max = 2, Flag = "WorldFont"});
            end; 


            function Library:UpdateNotifications()
                local i = 0
                for v in next, Notifications do
                    if v.Holder then 
                        local tween = Library:Tween(v.Holder, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0, 75 + (i * 25))})
                        i = i + 1
                    end
                end
            end;

            function Library:UpdateNotifications2(Item)
                for i,v in pairs(Item) do
                    if typeof(v) == "Instance" then
                        task.spawn(function()
                            local tween = Library:Tween(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1});

                            tween.Completed:Connect(function()
                                if v.Name == "Holder" then 
                                    v:Destroy();
                                end
                            end)
                        end);
                        if v.ClassName == "TextLabel" then 
                            local tween = Library:Tween(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
                        end
                    end
                end
            end

            function Library:Notify(Text, Time, Color)
                Time = Time or 2;
                Color = Color or Library.Theme.Accent;
                Text = Text or "No text provided? retard? "..tostring(math.random());

                local Notification = {};

                local Holder = Instance.new("Frame")
                Holder.Position = UDim2.new(0, -30, 0, 75);
                Holder.Size = UDim2.new(0, 0, 0, 23);
                Holder.BackgroundTransparency = 0;
                Holder.Parent = NotificationContainer;
                Holder.BackgroundColor3 = Library.Theme.LightContrast;
                Holder.BorderSizePixel = 1
                Holder.BorderColor3 = Library.Theme.Border
                Notification.Holder = Holder;

                local Background = Instance.new("Frame");
                Background.Parent = Holder;
                Background.Size = UDim2.new(1, -4, 1, -4);
                Background.BackgroundColor3 = Library.Theme.MedianContrast;
                Background.Position = UDim2.new(0, 2, 0, 2);
                Background.BorderSizePixel = 1
                Background.BorderColor3 = Library.Theme.Border
                Notification.Background = Background;

                local AccentBar = Instance.new("Frame");
                AccentBar.Size = UDim2.new(0, 1, 1, 0);
                AccentBar.Parent = Background;
                AccentBar.BackgroundColor3 = Color;
                AccentBar.Position = UDim2.new(0, 0, 0, 0);
                AccentBar.BorderSizePixel = 0 
                Notification.AccentBar = AccentBar;

                local AccentBar2 = Instance.new("Frame");
                AccentBar2.Size = UDim2.new(0, 0, 0, 1);
                AccentBar2.Position = UDim2.new(0, 0, 0, 15);
                AccentBar2.Parent = Background;
                AccentBar2.BackgroundColor3 = Color;
                AccentBar2.BorderSizePixel = 0 

                Notification.AccentBar2 = AccentBar2
                local NotifText = Instance.new("TextLabel");
                NotifText.TextXAlignment = Enum.TextXAlignment.Left;
                NotifText.Position = UDim2.new(0, 3, 0, 0);
                NotifText.Size = UDim2.new(1, 0, 1, 0)
                NotifText.Parent = Background;
                NotifText.FontFace = Library.MenuFont;
                NotifText.TextColor3 = Color3.new(1,1,1);
                NotifText.BackgroundTransparency = 1;
                NotifText.TextSize = Library.TextSize;
                NotifText.Text = Text; 

                Notification.NotifText = NotifText;
                Notification.Holder.Size = UDim2.new(0, (string.len(NotifText.Text) * 5) + 10, 0, 19);

                AccentBar2.Size = UDim2.new(0, 1, 0, 1)

                Notifications[Notification] = true

                local Connection
                function Notification:Remove()
                    Notifications[Notification] = nil 
                    Library:UpdateNotifications();
                end;
                task.spawn(function()
                    Library:UpdateNotifications()
                    Notification.AccentBar2:TweenSize(UDim2.new(0, Background.AbsoluteSize.X - 1, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, Time, false);
                    task.wait(Time)

                    Library:UpdateNotifications2(Notification)
                    task.wait(1.2)
                    Notification:Remove()
                end);
            end;
        end;
    end)()

    LPH_NO_VIRTUALIZE(function()
        function Library:ToggleMenu()
            if Library.Fading then 
                return 
            end; 

            Library.Fading = true;
            local Window = Library.Windows[1];
            local IsOpen = not Library.Flags["Open/Close"].Value;
            MouseLocation = UserInputService:GetMouseLocation();
            Library.MouseCursor.Position = UDim2.new(0, MouseLocation.X - 18, 0, MouseLocation.Y - 18);

            local FadeTime = 0.25;

            if IsOpen then 
                Window.Main.Enabled = true;
            end;

            do --// Fade In/Out
                local Goal = IsOpen and 0 or 1;

                if not Library.Properties then
                    Library.Properties = {};
                    local Blur = Instance.new("BlurEffect", Lighting);
                    Blur.Size = 0;
                    Blur.Enabled = true;
                    Library.Blur = Blur;

                    for _, Value in next, Window.Main:GetDescendants() do 
                        local Class = Value.ClassName; 

                        if Value.Name ~= "TabTransitioner" and Value.Name ~= "TabTransitioner2" then 
                            if Class == "Frame" and Value.BackgroundTransparency ~= 1 then 
                                Library.Properties[Value] = {["BackgroundTransparency"] = true};
                            end; 

                            if Class == "TextLabel" and Value.Name ~= "New_TextTip" then 
                                if Value.BackgroundTransparency ~= 1 then 
                                    Library.Properties[Value] = {["BackgroundTransparency"] = true, ["TextTransparency"] = true};
                                else 
                                    Library.Properties[Value] = {["TextTransparency"] = true};
                                end; 
                            end; 

                            if Class == "TextButton" then 
                                if Value.BackgroundTransparency ~= 1 then 
                                    Library.Properties[Value] = {["BackgroundTransparency"] = true, ["TextTransparency"] = true};
                                else 
                                    Library.Properties[Value] = {["TextTransparency"] = true};
                                end; 
                            end; 

                            if Class == "ScrollingFrame" then 
                                if Value.BackgroundTransparency ~= 1 then 
                                    Library.Properties[Value] = {["BackgroundTransparency"] = true};
                                elseif Value.BackgroundTransparency ~= 1 and Value.ScrollBarImageTransparency ~= 1 then 
                                    Library.Properties[Value] = {["BackgroundTransparency"] = true, ["ScrollBarImageTransparency"] = true};
                                elseif Value.BackgroundTransparency == 1 and Value.ScrollBarImageTransparency ~= 1 then 
                                    Library.Properties[Value] = {["ScrollBarImageTransparency"] = true};
                                end; 
                            end;

                            if Class == "TextBox" then 
                                Library.Properties[Value] = {["TextTransparency"] = true, ["BackgroundTransparency"] = true}
                            end;

                            if Class == "ImageLabel" then 
                                if Value.BackgroundTransparency ~= 1 and Value.ImageTransparency ~= 1 then 
                                    Library.Properties[Value] = {["BackgroundTransparency"] = true, ["ImageTransparency"] = true};
                                elseif Value.ImageTransparency ~= 1 and Value.BackgroundTransparency == 1 then 
                                    Library.Properties[Value] = {["ImageTransparency"] = true};
                                end;
                            end; 

                            if Class == "ImageButton" then 
                                if Value.BackgroundTransparency ~= 1 and Value.ImageTransparency ~= 1 then 
                                    Library.Properties[Value] = {["BackgroundTransparency"] = true, ["ImageTransparency"] = true};
                                elseif Value.ImageTransparency ~= 1 and Value.BackgroundTransparency == 1 then 
                                    Library.Properties[Value] = {["ImageTransparency"] = true};
                                end;
                            end;

                            if Class == "UIStroke" then 
                                Library.Properties[Value] = {["Transparency"] = true}
                            end;
                        end;
                    end;
                end;

                if Library.Properties then 
                    local Info = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    local TweenData = {}
                
                    for Object, Properties in next, Library.Properties do
                        local Data = {}
                
                        if Properties["BackgroundTransparency"] then 
                            Data.BackgroundTransparency = Goal
                        end
                
                        if Properties["TextTransparency"] then 
                            Data.TextTransparency = Goal
                        end
                
                        if Properties["ImageTransparency"] then 
                            Data.ImageTransparency = Goal
                        end
                
                        if Properties["ScrollBarImageTransparency"] then 
                            Data.ScrollBarImageTransparency = Goal
                        end
                        
                        if Properties["Transparency"] then 
                            Data.Transparency = Goal
                        end
                        table.insert(TweenData, {Object = Object, Data = Data})
                    end
                
                    task.spawn(function()
                        for _, TweenInfo in ipairs(TweenData) do
                            local Object = TweenInfo.Object
                            local Data = TweenInfo.Data
                            Library:Tween(Object, Info, Data)
                        end
                    end)
                end
            end;

            do --// Blur
                if Library.Flags.Blurbackground and Library.Flags.Blurbackground.Value then 
                    task.spawn(function()
                        local SizeGoal = IsOpen and 15 or  0
                        Library:Tween(Library.Blur, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = SizeGoal})
                    end);
                else 
                    Library.Blur.Size = 0;
                end;
            end;

            task.wait(FadeTime);

            if not IsOpen then 
                Window.Main.Enabled = false;
            end;

            Library.Fading = false;
        end;
    end)();
end;

return Library
