---saveCrew
---@param identifier string
---@param crewName string
---@param crewRank number
---@return void
---@public
function saveCrew(identifier, crewName, crewRank)
	MySQL.update.await("UPDATE users SET crewName = ?, crewRank = ? WHERE identifier = ?", {
		crewName,
		crewRank,
		identifier,
	})
end

---isCrewValid
---@param crewName string
---@param crewRank number
---@return boolean
---@public
function isCrewValid(crewName, crewRank)
	if crewName == "citizen" and crewRank == 0 then
		return true
	end
	local isCrewNameValid = false
	local isCrewRankValid = false
	for _, crew in pairs(Config.crews) do
		if crew.id == crewName then
			isCrewNameValid = true
			if crew.ranks[crewRank] then
				isCrewRankValid = true
			end
		end
	end
	if isCrewNameValid and isCrewRankValid then
		return true
	end
	return false
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

---getCrewBossRank
---@param crewName string
---@return number
---@public
function getCrewBossRank(crewName)
	if not crewName then
		return 0
	end
	if crewName == "citizen" then
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

---getCrewTerritoriesCount
---@param crewName string
---@return number
---@public
function getCrewTerritoriesCount(crewName)
	local count = 0
	for key, claim in pairs(GlobalState["epyi_crewsystem:territories"]) do
		if claim.owner == crewName then
			count = count + 1
		end
	end
	return count
end
