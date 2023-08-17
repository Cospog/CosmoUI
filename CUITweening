-- parent is CosmoUI
local CUITweening = {}
local tweenService = game:GetService("TweenService")
local savedTweens = {}
local tweenStyles = {
	Increase = function(itemReceived: any, inc: number?)
		return {Size = itemReceived.Size*(inc or 1.1)}
	end,
	Decrease = function(itemReceived: any, dec: number?)
		return {Size = itemReceived.Size/(dec or 1.1)}
	end,
}
function CUITweening:createTween(tweenData: {itemReceived: Instance, tweenInfo: {},propertyTable: {}})
	local tweenObject = nil
	if savedTweens[tweenData] then tweenObject = savedTweens[tweenData] else tweenObject = tweenService:Create(tweenData.itemReceived, TweenInfo.new(table.unpack(tweenData.tweenInfo)), tweenData.propertyTable) end
	return savedTweens[tweenData]
end
function CUITweening:generateProperties(itemReceived: Instance, tweenStyle: string, ...)
	assert(tweenStyles[tweenStyle], "This style does not exist.")
	local unpackedTable
	if ... then unpackedTable = table.unpack(...) end
	return tweenStyles[tweenStyle](itemReceived, unpackedTable)
end
return CUITweening
