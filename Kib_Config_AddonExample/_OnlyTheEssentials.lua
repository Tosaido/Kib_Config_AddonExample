--<<START>>-----------------------------------------------------------------------------------------<<>>

--[[
	First off, make sure [## OptionalDeps: Kib_Config] is in your .toc file

	Note: Variable names are not important, name them whatever you like

	Default settings: One table containing all your default settings
]]

	local MyDefaultsTable = {

		-- "State" stands for the enabled of disables state of your addon. it's just a value... no magic happening here. 
		-- If you want the addon to physically be enabled or disabled that is up to your coding (Not required, but if not included, it will default to true)
		State = true,

		-- Every variable is very generic, float, int string, bool, etc. Except for the custom colour variable, use the same structure as the provided variable called "Colour"
        Colour = {r = 0.1, g = 1, b = 0.1},
    }

--[[
	Register with Kib_Config: This one functions all you need for setting up saved variables and profiling
]]

	--Return_A = Table containing all your saved variables related to this addon for your selected profile (The same settings defined within Defaults)
	--Return_B = Table containing important, variables, function, etc. From Kib_Config that we will use later

	--Send_A = Name of your addon
	--Send_B = Version of your addon (It's only used as a text display, so nothing will break if it's wrong)
	--Send_C = Your defaults table you created earlier
	--Send_D = The name of the addon author (You)
    local Return_A, Return_B = Kib_Register_Addon(Send_A, Send_B, Send_C, Send_D)

--[[
	Create options data table: A table containing the data of any config elements

	Note: You do not need to name each element with a number ([1] = {}, [2] = {}) for example. You can just use ({}, {}).
	However, if you do, they have to all be numbered in order. Never name them with a string.

	You can find full examples within the WorkingExample.lua file
]]

	local MyConfigElements = {
	    [1] = {

	    	-- The type of element you would like to create. Current element types:
	    		--"Title" 			- basic line that displays plain text
				--"CheckButton"		- toggle button
				--"Slider" 			- drag left/right slider
				--"DropDown" 		- dropdown menu displaying many options
				--"Color" 			- R-G-B colour selector
	        element = "", 

	        -- Text displayed next to this setting
	        text = "", 

	        -- Text that will be displayed when mousing over the setting
	        tip = "", 

	        -- The saved variable value of your setting
	        value = SavedValue,

	        -- !Slider Element Only! [{Min, Max}] The slider will use these values, Min is the slider all the way to the left and max is to the right (minus values are allowed)
	        minmax = {n, n}, 

	        -- !Slider Element Only! The step value when dragging the slider
	        step = n,

	        -- If present, when the setting has changed it will activate a pop up window displaying this text and if accept is clicked the UI will reload
	        popup_text = "",

	        --!DropDown Element Only! A table containing every dropdown item. Use the same structure as the table below to setup your contents.
	        -- Each dropdown item must be within its own table, even if only one variable is present
	        -- local Contents = {[1] = {Variable_A, Variable_B}, }
	        -- Variable_A = The value of the setting
			-- Variable_B = The text used in the drop down for the setting (if not present, then just use Variable_A as the text)
	        Contents = {},

	        -- The function that will be fired when the setting has been changed (Must folow the same structure)
	        func = function(value) SavedValue = value end
	    },
	}

--[[
	Create options, using new options data:
]]
	      
	--Send_A = The table with your config elements data, which you just created
	--Send_B = The name of your tab in the config GUI (Normally your addons name)
	--Send_C = The name of a sub tab, nil if you don't want any sub tabs. (If adding element to a tab which has sub tabs and "Send_C" is nil then a subtab called "General" will be created)
	--Send_D = The texture you want to use for your new tab. You only need to send this once (If sent twice, it will overwrite the first one)                 
	GlobalDatabase.Config_Add(Send_A, Send_B, Send_C, send_D)
               
----------------------------------------------------------------------------------------------------<<END>>