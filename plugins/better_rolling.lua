PLUGIN.name = "Better Rolling"
PLUGIN.author = "Taylor"
PLUGIN.desc = "Gently adjusts roll results towards the average for more perceptibly fair results."

ix.config.Add("rollAdjustment", 2, "What % of the max to increase rolls by when making adjustments.", nil, {
	data = {min = 0, max = 50, decimals = 0},
	category = "rolling"
})

ix.config.Add("rollDefault", 100, "Default max value for rollf", nil, {
	data = {min = 0, max = 10000, decimals = 0},
	category = "rolling"
})

ix.log.AddType("rollf", function(client, ...)
	local arg = {...}
	return string.format("%s has rolled %s out of %s", client:Name(), arg[1], arg[2])
end)

ix.command.Add("Rollf", {
	description = "Roll, but a bit more fair.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum)
		
		character = client:GetChar()
		highRolls = character:GetData("HighR",0)
		lowRolls = character:GetData("LowR",0)
		
		maximum = math.Clamp(maximum or ix.config.Get("rollDefault"), 0, 1000000)
		
		local value = math.random(0, maximum)
		local rollPercAdj = (ix.config.Get("rollAdjustment") / 100)
		local half = (maximum/2)
		
		if (highRolls > 0 and value > half) then
			value = math.Clamp(value - (maximum * (rollPercAdj * highRolls)), half, maximum)
		elseif (lowRolls > 0 and value < half) then
			value = math.Clamp(value + (maximum * (rollPercAdj * lowRolls)), 0, half)
		end
		
		local diff = (value - (maximum/2))
		local portion = (maximum * 0.15)
		local variance = math.Round(math.abs(diff / portion))
		
		if (diff < 0) then
			character:SetData("LowR",variance + lowRolls)
			character:SetData("HighR", 0)
		elseif (diff > 0) then
			character:SetData("HighR",variance + highRolls)
			character:SetData("LowR", 0)
		else
			character:SetData("HighR",0)
			character:SetData("LowR",0)
		end
		
		ix.chat.Send(client, "roll", tostring(value), nil, nil, {
			max = maximum
		})
		
		ix.log.Add(client, "rollf", value, maximum)
	end
})