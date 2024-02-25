ESX.RegisterCommand(
	{ "setcrew", "setgang", "setjob2" },
	"admin",
	function(xPlayer, args, showError)
		if not isCrewValid(args.crewName, args.crewRank) then
			xPlayer.showNotification(_U("notif_invalid_crew"))
			return
		end

		local xTarget = args.playerId

		local state = Player(xTarget.source).state
		local selfCrew = state["epyi_crewsystem:selfCrew"]

		state:set("epyi_crewsystem:selfCrew", {
			name = args.crewName,
			rank = args.crewRank,
			name_label = getCrewNameLabelFromName(args.crewName),
			rank_label = getCrewRankLabelFromName(args.crewName, args.crewRank),
		}, true)
		saveCrew(xTarget.identifier, args.crewName, args.crewRank)
		TriggerClientEvent("epyi_crewsystem:setCrew", xTarget.source, {
			name = args.crewName,
			rank = args.crewRank,
			name_label = getCrewNameLabelFromName(args.crewName),
			rank_label = getCrewRankLabelFromName(args.crewName, args.crewRank),
		})

		if selfCrew.name ~= "citizen" then
			TriggerEvent("epyi_crewsystem:updateCrewStatebag", selfCrew.name)
		end
		TriggerEvent("epyi_crewsystem:updateCrewStatebag", args.crewName)

		xTarget.showNotification(_U("notif_now_member_of_target", args.crewName, args.crewRank))
		if xTarget.source == xPlayer.source then
			return
		end
		xPlayer.showNotification(_U("notif_now_member_of_self", xTarget.getName(), args.crewName, args.crewRank))
	end,
	false,
	{
		help = _U("command_setcrew_help"),
		arguments = {
			{ name = "playerId", help = _U("command_args_playerid"), type = "player" },
			{ name = "crewName", help = _U("command_args_crewName"), type = "string" },
			{ name = "crewRank", help = _U("command_args_crewRank"), type = "number" },
		},
	}
)

ESX.RegisterCommand(
	{ "getcrew", "getgang", "getjob2" },
	"admin",
	function(xPlayer, args, showError)
		local xTarget = args.playerId

		local state = Player(xTarget.source).state
		local crewName = state["epyi_crewsystem:selfCrew"] and state["epyi_crewsystem:selfCrew"].name
		local crewRank = state["epyi_crewsystem:selfCrew"] and state["epyi_crewsystem:selfCrew"].rank

		xPlayer.showNotification(_U("notif_target_crew_is", xTarget.getName(), crewName or "citizen", crewRank or 0))
	end,
	false,
	{
		help = _U("command_getcrew_help"),
		arguments = {
			{ name = "playerId", help = _U("command_args_playerid"), type = "player" },
		},
	}
)

ESX.RegisterCommand(
	{ "influence" },
	"admin",
	function(xPlayer, args, showError)
		local action = args.actions
		local crew = args.crew
		local count = args.count
		if action ~= "get" and action ~= "set" and action ~= "add" and action ~= "remove" then
			xPlayer.showNotification(_U("notif_invalid_arg", 1))
			return
		end
		if not isCrewValid(crew, 0) then
			xPlayer.showNotification(_U("notif_invalid_arg", 2))
			return
		end
		local influences = GlobalState["epyi_crewsystem:influences"]
		if action == "get" then
			xPlayer.showNotification(_U("notif_influence_get", getCrewNameLabelFromName(crew), influences[crew]))
			return
		end
		if action == "set" then
			influences[crew] = count or 0
			TriggerEvent("epyi_crewsystem:updateInfluences", influences)
			xPlayer.showNotification(_U("notif_influence_set", getCrewNameLabelFromName(crew), influences[crew]))
			return
		end
		if action == "add" then
			influences[crew] = influences[crew] + (count or 0)
			TriggerEvent("epyi_crewsystem:updateInfluences", influences)
			xPlayer.showNotification(_U("notif_influence_set", getCrewNameLabelFromName(crew), influences[crew]))
			return
		end
		if action == "remove" then
			influences[crew] = influences[crew] - (count or 0)
			TriggerEvent("epyi_crewsystem:updateInfluences", influences)
			xPlayer.showNotification(_U("notif_influence_set", getCrewNameLabelFromName(crew), influences[crew]))
			return
		end
	end,
	false,
	{
		help = _U("command_influence_help"),
		arguments = {
			{ name = "actions", help = _U("command_args_actions"), type = "string" },
			{ name = "crew", help = _U("command_args_crewName"), type = "string" },
			{ name = "count", help = _U("command_args_count"), type = "number", validate = false },
		},
	}
)

ESX.RegisterCommand(
	{ "power" },
	"admin",
	function(xPlayer, args, showError)
		local action = args.actions
		if action ~= "get" and action ~= "set" and action ~= "add" and action ~= "remove" then
			xPlayer.showNotification(_U("notif_invalid_arg", 1))
			return
		end
		local xTarget = args.playerId
		if action == "get" then
			local state = Player(xTarget.source).state
			local power = state["epyi_crewsystem:selfPower"]
			xPlayer.showNotification(_U("notif_power_get", xTarget.getName(), power or 0))
			return
		end
		if action == "set" then
			local state = Player(xTarget.source).state
			state:set("epyi_crewsystem:selfPower", args.count or 0, true)
			MySQL.update.await("UPDATE `users` SET `crewPower` = @crewPower WHERE `identifier` = @identifier", {
				["@crewPower"] = args.count or 0,
				["@identifier"] = xTarget.identifier,
			})
			xPlayer.showNotification(_U("notif_power_set", xTarget.getName(), args.count or 0))
			local targetCrew = state["epyi_crewsystem:selfCrew"]
			if targetCrew.name and targetCrew.name ~= "citizen" then
				TriggerEvent("epyi_crewsystem:updateCrewStatebag", targetCrew.name)
			end
			return
		end
		if action == "add" then
			local state = Player(xTarget.source).state
			local actualPower = state["epyi_crewsystem:selfPower"]
			local newPower = actualPower + (args.count or 0)
			state:set("epyi_crewsystem:selfPower", newPower, true)
			MySQL.update.await("UPDATE `users` SET `crewPower` = @crewPower WHERE `identifier` = @identifier", {
				["@crewPower"] = newPower,
				["@identifier"] = xTarget.identifier,
			})
			xPlayer.showNotification(_U("notif_power_set", xTarget.getName(), newPower))
			local targetCrew = state["epyi_crewsystem:selfCrew"]
			if targetCrew.name and targetCrew.name ~= "citizen" then
				TriggerEvent("epyi_crewsystem:updateCrewStatebag", targetCrew.name)
			end
			return
		end
		if action == "remove" then
			local state = Player(xTarget.source).state
			local actualPower = state["epyi_crewsystem:selfPower"]
			local newPower = actualPower - (args.count or 0)
			state:set("epyi_crewsystem:selfPower", newPower, true)
			MySQL.update.await("UPDATE `users` SET `crewPower` = @crewPower WHERE `identifier` = @identifier", {
				["@crewPower"] = newPower,
				["@identifier"] = xTarget.identifier,
			})
			xPlayer.showNotification(_U("notif_power_set", xTarget.getName(), newPower))
			local targetCrew = state["epyi_crewsystem:selfCrew"]
			if targetCrew.name and targetCrew.name ~= "citizen" then
				TriggerEvent("epyi_crewsystem:updateCrewStatebag", targetCrew.name)
			end
			return
		end
	end,
	false,
	{
		help = _U("command_power_help"),
		arguments = {
			{ name = "actions", help = _U("command_args_actions"), type = "string" },
			{ name = "playerId", help = _U("command_args_playerid"), type = "player" },
			{ name = "count", help = _U("command_args_count"), type = "number", validate = false },
		},
	}
)
