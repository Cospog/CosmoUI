local cosmoUI = {activeItems = {}, menuData = nil}
local CUIPresets = require(script.CUIPresets)
local allowedTypes = {"ImageButton", "TextButton", "TextBox", "TextLabel", "ImageLabel", "Frame", "ScrollingFrame"}
local defaultSettings = {Visible = false, scriptConnections = {}, settingsKeywords = {Visible = {"visibility", "view", "enabled", "visible"}}}
local settingsWithKeywords = {"Visible"}
function cosmoUI:registerItem(itemReceived: Instance, itemSettings: {Visible: boolean, scriptConnections: {}, settingsKeywords: {}})
	assert(table.find(allowedTypes, itemReceived.ClassName), "This item is not supported ("..itemReceived.ClassName..").")
	assert(not cosmoUI.activeItems[itemReceived], "This item has already been registered, use getItem.")
	for i,v in pairs(defaultSettings) do if not itemSettings[i] then itemSettings[i] = v end end
	for i,v in pairs(itemSettings.scriptConnections) do
		local success, res = pcall(function() return itemReceived[i]:Connect(v) end)
		if success then itemSettings.scriptConnections[i] = res else warn("An error has occured, make sure this is a valid connection.") end
	end
	local rawMetaSettings = {instance = itemReceived, iConnections = itemSettings.scriptConnections}
	
	local metaSettings = setmetatable(rawMetaSettings, {
		__index = itemSettings,
		__newindex = function(tbl, key, val)
			if table.find(settingsWithKeywords, key) then itemReceived[key] = val return end
			for i,v in ipairs(itemSettings.settingsKeywords) do
				if (i == key or v == key) and table.find(settingsWithKeywords, i) then
					itemReceived[i] = val
					return
				end
			end
			return error("The keyword "..key.." is not supported.")
		end,
	})
	cosmoUI.activeItems[itemReceived] = {metaSettings = metaSettings, normalSettings = itemSettings}
	return metaSettings
end

function cosmoUI:getItem(itemReceived: Instance)
	assert(cosmoUI.activeItems[itemReceived], "This item was not registered, use registerItem.")
	return cosmoUI.activeItems[itemReceived].metaSettings
end
function cosmoUI:unregisterItem(itemReceived: Instance, destroy: boolean?)
	assert(cosmoUI.activeItems[itemReceived], "This item was not registered or was unofficially destroyed, unable to unregister.")
	setmetatable(cosmoUI.activeItems[itemReceived].metaSettings, nil)
	for i,v in pairs(cosmoUI.activeItems[itemReceived].metaSettings.scriptConnections) do v:Disconnect() end
	cosmoUI.activeItems[itemReceived] = nil
	if destroy then itemReceived:Destroy() end
	return true
end
function cosmoUI:setupMenu(...: {toggleButton: Instance, toggledInstance: Instance, tweenPreset: string})
	assert(not cosmoUI.menuData, "A menu has already been setup.")
	local menuData = {}
	for i,v in pairs(...) do
		if (v.toggleButton and v.toggledInstance) then
			if not menuData[v.toggleButton] then
				if v.toggleButton:IsA("TextButton") or v.toggleButton:IsA("ImageButton") then
					v.toggleButton.MouseButton1Click:Connect(function()
						if not v.toggledInstance.Visible then for i2,v2 in pairs(cosmoUI.menuData) do v2.Visible = false end end
						v.toggledInstance.Visible = not v.toggledInstance.Visible
						local tweenPreset = CUIPresets[v.tweenPreset]
						if tweenPreset then
							if tweenPreset.ButtonActivation then tweenPreset.ButtonActivation(v.toggleButton) end
							for i2,v2 in pairs(tweenPreset) do
								if i2 ~= "ButtonActivation" then
									pcall(function() return v.toggledInstance[i2]:Connect(function() v2(v.toggledInstance) end) end)
								end
							end
						end
					end)
					menuData[v.toggleButton] = v.toggledInstance
				else
					warn("The item "..v.toggleButton.Name.." is not a valid button.")
				end
			else
				warn("The item "..v.toggleButton.Name.." is already being used for "..menuData[v.toggleButton].Name..".")
			end
		else
			warn("An argument is missing, this item was not implemented to the menu.")
		end
	end
	cosmoUI.menuData = menuData
end
return cosmoUI
