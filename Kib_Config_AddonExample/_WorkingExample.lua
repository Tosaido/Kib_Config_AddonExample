--<<START>>-----------------------------------------------------------------------------------------<<>>

	local ThisAddon, AddonDB = ...

--[[
	I suggest you read _OnlyTheEssentials.lua first, to better understand the essential elements with Kib_Config

	NOTE: Kib_Config is a standalone addon... which means some people may not want to install it because they don't care for the options available.
	Because of this reason, you must correctly setup the register process, or your addon will produce errors. I will explain more later.

	This is only one way of manipulating the provided data, once you have the data you can use it whatever way you like.

	For this example we are going to create a basic Button on the left side of the screen that we are going to manipulate with options.
	and when clicked it will open the config to a specific location we have choosen

	First lets setup some variables
]]

	-- Define the variable here, so we don't have scope issues later
	local Button

	-- A dummy frame that is used to handle event related things
	local EventDummy = CreateFrame("Frame")

	-- used to initialize the addon
    EventDummy:RegisterEvent("ADDON_LOADED")

    -- Just to keep things tidy
	local MediaLocation = "Interface\\AddOns\\Kib_Config_AddonExample\\media\\"

	-- Used for our Slider setting [TextureVariant]
	local ButtonTextures = {MediaLocation .. "Example1", MediaLocation .. "Example2", MediaLocation .. "Example3"}

	-- Used for our DropDown setting [TextAnchor]. It is important that we set it up this way (explained in _OnlyTheEssentials.lua)
	-- I have only added the second value in a few of the tables, just as an example
	local TextAnchorLocations = {
		{"BOTTOM", "Anchor to the Bottom"}, 
		{"BOTTOMLEFT"}, 
		{"LEFT"}, 
		{"TOPLEFT"}, 
		{"TOP"}, 
		{"TOPRIGHT", "Anchor to the Top Right"}, 
		{"RIGHT"}, 
		{"BOTTOMRIGHT"}
	}

--[[
	Setup our Defaults table
]]

	local Defaults = {
		State = true,
        DisableInCombat = true,
        Color = {r = 0.1, g = 1, b = 0.1},
        TextureVariant = 1,
        YOffset = 0,
        TextAnchor = 1,
    }

--[[
	Register with Kib_Config (Kib_Register_Addon is Kib_Configs global function)
]]

	-- Define the variable here, out side of the if statement so we don't have scope issues
	local SavedVars, GlobalDatabase

	-- If Kib_Config is not installed then Kib_Register_Addon will not be found, so this if statement is important
	if Kib_Register_Addon then

		-- Read about the significants of these variables in _OnlyTheEssentials.lua
        SavedVars, GlobalDatabase = Kib_Register_Addon("Kib Config Example", 1.0, Defaults, "Tosaido")
    else

    	-- Fallback on default variables and replace GlobalDatabase that we didn't get from Kib_Config (If you won't use [Font or Localization] in GlobalDatabase, just remove it)
    	SavedVars, GlobalDatabase = Defaults, {Font = "Fonts\\FRIZQT__.TTF", Localization = GetLocale()}
    end

--[[
	Core functionality
]]

	-- A reset function is very important, so you don't need to preform a UIReload
	-- This reset functions fired whenever one of our settings is changed in Kib_Config (and in this case, when the button is created. To prevent redundancy)
	-- It basically just refreshes the button with every adjustable setting. (I prefer to use one update function rather than a single update function for each setting)
	local function ResetButton()
		local Colour = SavedVars.Color

		Button:SetPoint("LEFT", 50, SavedVars.YOffset)

		Button.Text:SetPoint("CENTER", Button, TextAnchorLocations[SavedVars.TextAnchor][1])

		Button.Texture:SetTexture(ButtonTextures[SavedVars.TextureVariant])
        Button.Texture:SetVertexColor(Colour.r, Colour.g, Colour.b, 1)
		Button.Texture:SetVertexColor(Colour.r, Colour.g, Colour.b, 1)
	end

	local function CreateButton()
		Button = CreateFrame("Button", nil, UIParent)
		Button:SetSize(64, 128)

		Button:SetScript("OnClick", function(self)

			-- [GlobalDatabase.Config_Open] opens the config GUI to a specific tab/subtab

				-- GlobalDatabase.Config_Open(Send_A, Send_B, Send_C, Send_D)
				-- Send_A = The type of tab to open, "tab", "subtab" or "both" (no caps)
				-- Send_B = Tab to open (you will define a tab and its name later, in the function [GlobalDatabase.Config_Add])
				-- Send_C = Subtab to open (must be present if using "subtab" or "both" as [Send_A])
				-- Send_D = Force the config to open. If true the config GUI will open when this function is fired
            GlobalDatabase.Config_Open("both", "Kib Example Addon", "Sub Tab A", true)
        end)

		Button.Texture = Button:CreateTexture(nil, "OVERLAY")                                   
        Button.Texture:SetAllPoints()

        Button.Text = Button:CreateFontString(nil, "OVERLAY", "GameTooltipTextSmall")
        Button.Text:SetFont(GlobalDatabase.Font, 12, "THINOUTLINE")
        Button.Text:SetText("EXAMPLE")

        ResetButton()
	end

	function EventDummy.PLAYER_REGEN_DISABLED() Button:Hide() end

	function EventDummy.PLAYER_REGEN_ENABLED() Button:Show() end

--[[
	Create config element data

	It is possible to just use the function within the elements [func] variable to reset your button, but in most cases it's cleaner to use one function 
]]

	local ConfigElementsTabA = {
	    [1] = {
	        element = "Color", 
	        text = "Button Colour", 
	        tip = "The button will be displayed in this colour", 
	        value = SavedVars.Color, 
	        func = function(value) SavedVars.Color = value ResetButton() end
	    },
	    [2] = {
	        element = "Slider", 
	        text = "Texture Variation", 
	        tip = "Changes the texture of the button", 
	        value = SavedVars.TextureVariant, 
	        minmax = {1, #ButtonTextures}, 
	        step = 1, 
	        func = function(value) SavedVars.TextureVariant = value ResetButton() end
	    },
	    [3] = {
	        element = "Slider", 
	        text = "Vertical Offset", 
	        tip = "Moves the button either up or down", 
	        value = SavedVars.YOffset, 
	        minmax = {-100, 100}, 
	        step = 5, 
	        func = function(value) SavedVars.YOffset = value ResetButton() end
	    },
	}

	local ConfigElementsTabB = {

		-- I have used "popup_text" with this particular element because a UIReload is just more cleaner then cluttering the ResetButton function with register/unregister event calls
		-- or leaving the PLAYER_REGEN_DISABLED/PLAYER_REGEN_ENABLED functions constantly running with if statements, you need to find a good medium, in terms of functionality or excess overhead
		[1] = {
	        element = "CheckButton",   
	        text = "Disable in Combat",
	        tip = "The button will not be displayed when you enter combat", 
	        value = SavedVars.DisableInCombat, 
	        popup_text = "Toggle disable in combat",
	        func = function(value) SavedVars.DisableInCombat = value end
	    },
	    [2] = {
	        element = "DropDown", 
	        text = "Text Anchor",
	        tip = "The location of the text, relative to the button", 
	        value = SavedVars.TextAnchor, 
	        Contents = TextAnchorLocations,
	        func = function(value) SavedVars.TextAnchor = value ResetButton() end
	    },
	}

--[[
	Create config elements
]]
	         
	local function CreateConfigElements()

		-- If Kib_Config is not installed and Config_Add is not found, then do nothing.
		if not GlobalDatabase.Config_Add then return end   

		-- Just as an example, we will create two sub tabs, called "Sub Tab A" and "Sub Tab B" within a tab called "Kib Example Addon"
		-- using the texture "ExampleConfigButton" and finaly, some text which will display when you mouse over the "Kib Example Addon" tab we created.
	    GlobalDatabase.Config_Add(ConfigElementsTabA, "Kib Example Addon", "Sub Tab A", MediaLocation .. "ExampleConfigIcon", "An example addon for Kib_Config")
	    GlobalDatabase.Config_Add(ConfigElementsTabB, "Kib Example Addon", "Sub Tab B")
	end

--[[
	Initialize the addon
]]

    EventDummy:SetScript("OnEvent", function(self,_, Addon)
        if Addon ~= ThisAddon then return end
        self:UnregisterEvent("ADDON_LOADED")

        -- Only initialize the addon if the state reads true or if it wasn't found (as in Kib_Config is not installed) 
        if SavedVars.State == true then

        	-- Only register the Regen events if the DisableInCombat variable is true
            if SavedVars.DisableInCombat then  
            	self:RegisterEvent("PLAYER_REGEN_DISABLED")
            	self:RegisterEvent("PLAYER_REGEN_ENABLED")

            	self:SetScript("OnEvent", function(self, event) self[event]() end)
            end

            -- Fire the Create Config Elements function, and finally create the button
            CreateConfigElements()
            CreateButton()
        end
    end)
               
----------------------------------------------------------------------------------------------------<<END>>