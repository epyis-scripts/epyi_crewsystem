Citizen.CreateThread(function()
	for _, crew in pairs(Config.crews) do
		TriggerEvent("epyi_crewsystem:updateCrewStatebag", crew.id)
	end

	local influences = {}
	local response = MySQL.query.await("SELECT `crew`, `influence` FROM `crews_influence`", {})

	if response then
		for i = 1, #response do
			local row = response[i]
			influences[row.crew] = row.influence
			GlobalState:set("epyi_crewsystem:influences", influences, true)
			Citizen.Wait(0)
		end
	end

	for key, crew in pairs(Config.crews) do
		if not influences[crew.id] then
			MySQL.insert.await("INSERT INTO `crews_influence` (crew, influence) VALUES (?, ?)", {
				crew.id,
				0,
			})
			influences[crew.id] = 0
		end
	end
	GlobalState:set("epyi_crewsystem:influences", influences, true)
end)
