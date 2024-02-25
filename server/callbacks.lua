ESX.RegisterServerCallback("epyi_crewsystem:getMyCrewMemberList", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then
		cb(false)
		return
	end
	local source = xPlayer.source
	local state = Player(source).state
	local xPlayrCrewDatas = state["epyi_crewsystem:selfCrew"]
	if not xPlayrCrewDatas or not xPlayrCrewDatas.name then
		cb(false)
		return
	end
	local response = MySQL.query.await(
		"SELECT `identifier`, `crewRank`, `firstname`, `lastname` FROM `users` WHERE `crewName` = ?",
		{
			xPlayrCrewDatas.name,
		}
	)
	local memberList = {}
	if response then
		for i = 1, #response do
			local row = response[i]
			memberList[#memberList + 1] = {
				identifier = row.identifier,
				crewName = xPlayrCrewDatas.name,
				crewRank = row.crewRank,
				firstname = row.firstname,
				lastname = row.lastname,
			}
		end
	end
	cb(memberList)
	return
end)
