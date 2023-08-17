-- parent is CosmoUI
local CUITweening = require(script.Parent.CUITweening)
local CUIPresets = {
	Cosmog = {
		ButtonActivation = function(toggleButton: Instance)
			CUITweening:createTween({itemReceived = toggleButton, tweenInfo = {.5}, propertyTable = CUITweening:generateProperties(toggleButton, "Increase")}):Play()
			task.wait(.5)
			CUITweening:createTween({itemReceived = toggleButton, tweenInfo = {.5}, propertyTable = CUITweening:generateProperties(toggleButton, "Decrease")}):Play()
		end,
		MouseEnter = function(toggledInstance: Instance)
			
		end,
		MouseLeave = function(toggledInstance: Instance) 
			
		end,
	}
}

return CUIPresets
