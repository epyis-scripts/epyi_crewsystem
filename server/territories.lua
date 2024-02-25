crewTerritories = {}

local response = MySQL.query.await("SELECT `x`, `y`, `owner`, `id` FROM `crews_territories`", {})
if response then
	for i = 1, #response do
		local row = response[i]
		crewTerritories[row.id] = {
			owner = row.owner,
			x = row.x,
			y = row.y,
		}
		Citizen.Wait(0)
	end
end
GlobalState:set("epyi_crewsystem:territories", crewTerritories, true)

local function saveTerritoriesToDatabase()
	local startTime <const> = os.clock()
	local count = 0
	for id, claim in pairs(crewTerritories) do
		count = count + 1
		local response = MySQL.query.await("SELECT * FROM `crews_territories` WHERE `x` = ? AND `y` = ?", {
			claim.x,
			claim.y,
		})
		if #response == 0 then
			MySQL.insert.await("INSERT INTO `crews_territories` (id, x, y, owner) VALUES (?, ?, ?, ?)", {
                id,
				claim.x,
				claim.y,
				claim.owner,
			})
		else
			MySQL.update.await("UPDATE `crews_territories` SET `owner` = @owner WHERE `x` = @x AND `y` = @y", {
				["@owner"] = claim.owner,
				["@x"] = claim.x,
				["@y"] = claim.y,
			})
		end
	end
	print(
		("^5(^2EPYI_CREWSYSTEM^5) ^4- ^0Saved ^4%s^0 crew territories over ^4%s ^0ms"):format(
			count,
			math.ceil((os.clock() - startTime) * 1000, 2)
		)
	)
end

Citizen.CreateThread(function()
	repeat
		Citizen.Wait(30 * 60 * 1000)
		saveTerritoriesToDatabase()
	until false
end)

AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() == resourceName then
		saveTerritoriesToDatabase()
	end
end)

RegisterCommand("saveterritories", function()
    saveTerritoriesToDatabase()
end, true)
