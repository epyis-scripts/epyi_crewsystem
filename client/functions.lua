---getCrewBossRank
---@param crewName string
---@return number
---@public
function getCrewBossRank(crewName)
	if not crewName then
		return 0
	end
	for _, crew in pairs(Config.crews) do
		if crew.id == crewName then
			local maxRank = 0
			for rank, _ in ipairs(crew.ranks) do
				maxRank = rank
			end
			return maxRank
		end
	end
	return 0
end

---getCrewRankLabelFromName
---@param crewName string
---@param crewRank number
---@return string
---@public
function getCrewRankLabelFromName(crewName, crewRank)
	if crewName == "citizen" and crewRank == 0 then
		return Config.noCrew.rank
	end
	for key, crew in pairs(Config.crews) do
		if crew.id == crewName then
			return crew.ranks[crewRank] and crew.ranks[crewRank].label
		end
	end
end

---markClosestPlayer
---@param r number
---@param v number
---@param b number
---@param a number
---@return void
---@public
function markClosestPlayer(r, v, b, a)
    local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
    local pos = GetEntityCoords(ped)
    local target, distance = ESX.Game.GetClosestPlayer()
    if distance <= 4.0 then
        DrawMarker(20, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, r, v, b, a, 0, 1, 2, 1, nil, nil, 0)
    end
end

---round100
---@param number number
---@return number
---@public
function round100(number)
    local rest = number % 100
    return number - rest
end

---getCrewNameLabelFromName
---@param crewName string
---@return string
---@public
function getCrewNameLabelFromName(crewName)
	if crewName == "citizen" then
		return Config.noCrew.name
	end
	for key, crew in pairs(Config.crews) do
		if crew.id == crewName then
			return crew.label
		end
	end
end