RegisterNetEvent("esx:playerLoaded", function(player, xPlayer, isNew)
	local response = MySQL.query.await(
		"SELECT `crewName`, `crewRank`, `crewPower`, `crewMaxPower` FROM `users` WHERE `identifier` = ?",
		{
			xPlayer.identifier,
		}
	)

	if response then
		for i = 1, #response do
			local row = response[i]
			local state = Player(xPlayer.source).state
			state:set("epyi_crewsystem:selfPower", row.crewPower or 0, true)
			state:set("epyi_crewsystem:selfMaxPower", row.crewMaxPower or 10, true)
			if isCrewValid(row.crewName, row.crewRank) then
				state:set("epyi_crewsystem:selfCrew", {
					name = row.crewName,
					rank = row.crewRank,
					name_label = getCrewNameLabelFromName(row.crewName),
					rank_label = getCrewRankLabelFromName(row.crewName, row.crewRank),
				}, true)
				TriggerClientEvent("epyi_crewsystem:setCrew", xPlayer.source, {
					name = row.crewName,
					rank = row.crewRank,
					name_label = getCrewNameLabelFromName(row.crewName),
					rank_label = getCrewRankLabelFromName(row.crewName, row.crewRank),
				})
			else
				state:set(
					"epyi_crewsystem:selfCrew",
					{ name = "citizen", rank = 0, name_label = Config.noCrew.name, rank_label = Config.noCrew.rank },
					true
				)
				saveCrew(xPlayer.identifier, "citizen", 0)
			end
		end
	end
end)

RegisterNetEvent("epyi_crewsystem:loadStashes", function(stash)
	exports.ox_inventory:RegisterStash(stash.name, stash.label, stash.slots, stash.weight, stash.owner, stash.coords)
end)

RegisterNetEvent("epyi_crewsystem:leaveMyCrew", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then
		return
	end
	local state = Player(_source).state
	local sourceCrewDatas = state["epyi_crewsystem:selfCrew"]
	if getCrewBossRank(sourceCrewDatas.name) <= sourceCrewDatas.rank then
		return
	end
	state:set(
		"epyi_crewsystem:selfCrew",
		{ name = "citizen", rank = 0, name_label = Config.noCrew.name, rank_label = Config.noCrew.rank },
		true
	)
	saveCrew(xPlayer.identifier, "citizen", 0)
	TriggerClientEvent("epyi_crewsystem:setCrew", xPlayer.source, {
		name = "citizen",
		rank = 0,
		name_label = Config.noCrew.name,
		rank_label = Config.noCrew.rank,
	})
	xPlayer.showNotification(_U("notif_leaved_success", sourceCrewDatas.name))
	TriggerEvent("epyi_crewsystem:updateCrewStatebag", sourceCrewDatas.name)
end)

RegisterNetEvent("epyi_crewsystem:claimChunk", function(x, y)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then
		return
	end
	local state = Player(_source).state
	local sourceCrewDatas = state["epyi_crewsystem:selfCrew"]
	if getCrewBossRank(sourceCrewDatas.name) > sourceCrewDatas.rank then
		xPlayer.showNotification(_U("notif_not_boss"))
		return
	end
	for key, claim in pairs(GlobalState["epyi_crewsystem:territories"]) do
		if claim.x == x and claim.y == y then
			if claim.owner == sourceCrewDatas.name then
				crewTerritories[key] = {
					owner = "citizen",
					x = x,
					y = y,
				}
				GlobalState:set("epyi_crewsystem:territories", crewTerritories, true)
				xPlayer.showNotification(_U("notif_unclaim_success", x, y))
			else
				if
					getCrewTerritoriesCount(sourceCrewDatas.name) + 1
					> GlobalState["epyi_crewsystem:crewInfos"][sourceCrewDatas.name].power
				then
					xPlayer.showNotification(_U("notif_claim_no_more_power"))
					return
				end
				if claim.owner ~= "citizen" then
					if
						GlobalState["epyi_crewsystem:crewInfos"][claim.owner].power
						>= getCrewTerritoriesCount(claim.owner)
					then
						xPlayer.showNotification(_U("notif_claim_no_underpower", claim.owner))
						return
					end
				end
				crewTerritories[key] = {
					owner = sourceCrewDatas.name,
					x = x,
					y = y,
				}
				GlobalState:set("epyi_crewsystem:territories", crewTerritories, true)
				xPlayer.showNotification(_U("notif_claim_success", x, y))
			end
			return
		end
	end
	if
		getCrewTerritoriesCount(sourceCrewDatas.name) + 1
		<= GlobalState["epyi_crewsystem:crewInfos"][sourceCrewDatas.name].power
	then
		crewTerritories[#crewTerritories + 1] = {
			owner = sourceCrewDatas.name,
			x = x,
			y = y,
		}
		GlobalState:set("epyi_crewsystem:territories", crewTerritories, true)
		xPlayer.showNotification(_U("notif_claim_success", x, y))
	else
		xPlayer.showNotification(_U("notif_claim_no_more_power"))
	end
end)

AddEventHandler("epyi_crewsystem:removePower", function(target, count)
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then
		return
	end
	local state = Player(target).state
	local targetPower = state["epyi_crewsystem:selfPower"] or 0
	local targetCrew = state["epyi_crewsystem:selfCrew"]
	if targetPower - count >= -5 then
		state:set("epyi_crewsystem:selfPower", targetPower - count, true)
		MySQL.update.await("UPDATE `users` SET `crewPower` = @crewPower WHERE `identifier` = @identifier", {
			["@crewPower"] = state["epyi_crewsystem:selfPower"] or 0,
			["@identifier"] = xTarget.identifier,
		})
		xTarget.showNotification(_U("notif_loss_power", count))
		TriggerEvent("epyi_crewsystem:updateCrewStatebag", targetCrew.name)
		return
	end
	state:set("epyi_crewsystem:selfPower", -5, true)
	MySQL.update.await("UPDATE `users` SET `crewPower` = @crewPower WHERE `identifier` = @identifier", {
		["@crewPower"] = state["epyi_crewsystem:selfPower"] or 0,
		["@identifier"] = xTarget.identifier,
	})
	xTarget.showNotification(_U("notif_power_min", count))
	TriggerEvent("epyi_crewsystem:updateCrewStatebag", targetCrew.name)
	return
end)

RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(data)
	data.victim = source

	if data.killedByPlayer then
		TriggerEvent("epyi_crewsystem:removePower", data.victim, 2)
	else
		TriggerEvent("epyi_crewsystem:removePower", data.victim, 1)
	end
end)

local lastPowerTick = {}

RegisterNetEvent("epyi_crewsystem:selfPowerTick", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then
		return
	end
	if lastPowerTick[xPlayer.identifier] and lastPowerTick[xPlayer.identifier] + 1798 >= os.time() then
		return
	end
	local state = Player(_source).state
	local playerPower = state["epyi_crewsystem:selfPower"] or 0
	local playerMaxPower = state["epyi_crewsystem:selfMaxPower"] or 10
	local playerCrew = state["epyi_crewsystem:selfCrew"]
	if playerPower + 1 > playerMaxPower then
		return
	end
	state:set("epyi_crewsystem:selfPower", playerPower + 1, true)
	MySQL.update.await("UPDATE `users` SET `crewPower` = @crewPower WHERE `identifier` = @identifier", {
		["@crewPower"] = state["epyi_crewsystem:selfPower"] or 0,
		["@identifier"] = xPlayer.identifier,
	})
	if playerCrew.name ~= "citizen" then
		local influences = GlobalState["epyi_crewsystem:influences"]
		influences[playerCrew.name] = influences[playerCrew.name] + getCrewTerritoriesCount(playerCrew.name)
		TriggerEvent("epyi_crewsystem:updateInfluences", influences)
	end

	xPlayer.showNotification(_U("notif_gain_power_activity", 1))
	lastPowerTick[xPlayer.identifier] = os.time()
	TriggerEvent("epyi_crewsystem:updateCrewStatebag", playerCrew.name)
end)

RegisterNetEvent("epyi_crewsystem:updateCrewStatebag", function(crew)
	if not isCrewValid(crew, 0) then
		return
	end
	local power = 0
	local maxPower = 0
	local members = {}
	local response = MySQL.query.await(
		"SELECT `identifier`, `firstname`, `lastname`, `crewName`, `crewRank`, `crewPower`, `crewMaxPower` FROM `users` WHERE `crewName` = ?",
		{ crew }
	)
	if response then
		for i = 1, #response do
			local row = response[i]
			power = power + row.crewPower
			maxPower = maxPower + row.crewMaxPower
			members[row.identifier] = {
				identifier = row.identifier,
				crewName = row.crewName,
				crewRank = row.crewRank,
				crewPower = row.crewPower,
				crewMaxPower = row.crewMaxPower,
				firstname = row.firstname,
				lastname = row.lastname,
			}
		end
	end
	local infos = GlobalState["epyi_crewsystem:crewInfos"] or {}
	infos[crew] = {
		name = crew,
		power = power,
		maxPower = maxPower,
		members = members,
	}
	GlobalState:set("epyi_crewsystem:crewInfos", infos, true)
end)

RegisterNetEvent("epyi_crewsystem:bossActionOnCrewMember", function(targetType, target, action)
	-- Try to get the source extended player
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	-- Catch if source isn't online
	if not xPlayer then
		return
	end

	-- Get source state bags
	local xPlayerState = Player(_source).state
	local xPlayerCrewDatas = xPlayerState["epyi_crewsystem:selfCrew"]

	-- Check if source has the max rank in his crew
	if getCrewBossRank(xPlayerCrewDatas.name) > xPlayerCrewDatas.rank then
		return
	end

	-- Try to get the target extended player
	local xTarget
	if targetType == "serverid" then
		xTarget = ESX.GetPlayerFromId(target)
	elseif targetType == "identifier" then
		xTarget = ESX.GetPlayerFromIdentifier(target)
	else
		return
	end
	-- Catch if target isn't online
	if targetType == "serverid" and not xTarget then
		return
	end

	-- Get target crew datas
	local xTargetState
	local xTargetCrewDatas
	if xTarget then
		xTargetState = Player(xTarget.source).state
		xTargetCrewDatas = xTargetState["epyi_crewsystem:selfCrew"]
	elseif targetType == "identifier" then
		local response =
			MySQL.query.await("SELECT `crewName`, `crewRank` FROM `users` WHERE `identifier` = ?", { target })
		if response then
			for i = 1, #response do
				local row = response[i]
				xTargetCrewDatas = {
					name = row.crewName,
					rank = row.crewRank,
					name_label = getCrewNameLabelFromName(row.crewName),
					rank_label = getCrewRankLabelFromName(row.crewName, row.crewRank),
				}
			end
		end
	else
		return
	end

	-- Chef if player interact with themself
	if xPlayer.identifier == (xTarget and xTarget.identifier or target) then
		xPlayer.showNotification(_U("notif_connot_interact_self"))
		return
	end

	-- Check if xPlayer and xTarget are in the same crew
	if action ~= "hire" and xTargetCrewDatas.name ~= xPlayerCrewDatas.name then
		xPlayer.showNotification(_U("notif_not_in_same_crew"))
		return
	end

	-- Check if xTarget has no crew
	if action == "hire" and xTargetCrewDatas.name ~= "citizen" then
		xPlayer.showNotification(_U("notif_already_in_crew"))
		return
	end

	-- Check if xPlayer has a higher rank than xTarget
	if action ~= "hire" and xTargetCrewDatas.rank >= xPlayerCrewDatas.rank then
		xPlayer.showNotification(_U("notif_higher_rank"))
		return
	end

	if action == "hire" then
		MySQL.update.await(
			"UPDATE `users` SET `crewName` = @crewName, `crewRank` = @crewRank WHERE `identifier` = @identifier",
			{
				["@crewName"] = xPlayerCrewDatas.name,
				["@crewRank"] = 0,
				["@identifier"] = xTarget and xTarget.identifier or target,
			}
		)
		if xTarget then
			xTargetState:set("epyi_crewsystem:selfCrew", {
				name = xPlayerCrewDatas.name,
				rank = 0,
				name_label = getCrewNameLabelFromName(xPlayerCrewDatas.name),
				rank_label = getCrewRankLabelFromName(xPlayerCrewDatas.name, 0),
			}, true)
			xPlayer.showNotification(_U("notif_hire_success", xTarget.getName()))
		else
			xPlayer.showNotification(_U("notif_hire_success", _U("utils_the_target")))
		end
	elseif action == "fire" then
		MySQL.update.await(
			"UPDATE `users` SET `crewName` = @crewName, `crewRank` = @crewRank WHERE `identifier` = @identifier",
			{
				["@crewName"] = "citizen",
				["@crewRank"] = 0,
				["@identifier"] = xTarget and xTarget.identifier or target,
			}
		)
		if xTarget then
			xTargetState:set("epyi_crewsystem:selfCrew", {
				name = "citizen",
				rank = 0,
				name_label = Config.noCrew.name,
				rank_label = Config.noCrew.rank,
			}, true)
			xPlayer.showNotification(_U("notif_fire_success", xTarget.getName()))
		else
			xPlayer.showNotification(_U("notif_fire_success", _U("utils_the_target")))
		end
	elseif action == "promote" then
		if xTargetCrewDatas.rank + 1 >= xPlayerCrewDatas.rank then
			xPlayer.showNotification(_U("notif_max_promote", xTarget and xTarget.getName() or _("utils_the_target")))
			return
		end
		MySQL.update.await(
			"UPDATE `users` SET `crewName` = @crewName, `crewRank` = @crewRank WHERE `identifier` = @identifier",
			{
				["@crewName"] = xTargetCrewDatas.name,
				["@crewRank"] = xTargetCrewDatas.rank + 1,
				["@identifier"] = xTarget and xTarget.identifier or target,
			}
		)
		if xTarget then
			xTargetState:set("epyi_crewsystem:selfCrew", {
				name = xTargetCrewDatas.name,
				rank = xTargetCrewDatas.rank + 1,
				name_label = getCrewNameLabelFromName(xPlayerCrewDatas.name),
				rank_label = getCrewRankLabelFromName(xPlayerCrewDatas.name, xTargetCrewDatas.rank + 1),
			}, true)
			xPlayer.showNotification(_U("notif_promote_success", xTarget.getName()))
		else
			xPlayer.showNotification(_U("notif_promote_success", _U("utils_the_target")))
		end
	elseif action == "demote" then
		if xTargetCrewDatas.rank - 1 < 0 then
			xPlayer.showNotification(_U("notif_max_demote", xTarget and xTarget.getName() or _("utils_the_target")))
			return
		end
		MySQL.update.await(
			"UPDATE `users` SET `crewName` = @crewName, `crewRank` = @crewRank WHERE `identifier` = @identifier",
			{
				["@crewName"] = xTargetCrewDatas.name,
				["@crewRank"] = xTargetCrewDatas.rank - 1,
				["@identifier"] = xTarget and xTarget.identifier or target,
			}
		)
		if xTarget then
			xTargetState:set("epyi_crewsystem:selfCrew", {
				name = xTargetCrewDatas.name,
				rank = xTargetCrewDatas.rank - 1,
				name_label = getCrewNameLabelFromName(xPlayerCrewDatas.name),
				rank_label = getCrewRankLabelFromName(xPlayerCrewDatas.name, xTargetCrewDatas.rank - 1),
			}, true)
			xPlayer.showNotification(_U("notif_demote_success", xTarget.getName()))
		else
			xPlayer.showNotification(_U("notif_demote_success", _U("utils_the_target")))
		end
	end
	TriggerEvent("epyi_crewsystem:updateCrewStatebag", xPlayerCrewDatas.name)
	return
end)

AddEventHandler("epyi_crewsystem:updateInfluences", function(newInfluences)
	GlobalState:set("epyi_crewsystem:influences", newInfluences, true)
	for crewName, crewInfluence in pairs(newInfluences) do
		MySQL.update.await("UPDATE `crews_influence` SET `influence` = @influence WHERE `crew` = @crew", {
			["@influence"] = crewInfluence,
			["@crew"] = crewName,
		})
	end
end)
