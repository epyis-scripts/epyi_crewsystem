local bannerTexture
local isMenuOpened = false
local menuItemsCooldown = false
local myCrewMemberList = {}
local memberListActionsArray = {
	_("menu_crewmenu_manage_action_fire"),
	_("menu_crewmenu_manage_action_promote"),
	_("menu_crewmenu_manage_action_demote"),
}
local memberListActionsArrayIndex = 1
local nearPlayerCrewActionArray = {
	_("menu_crewmenu_manage_action_hire"),
	_("menu_crewmenu_manage_action_fire"),
}
local nearPlayerCrewActionArrayIndex = 1
local nearPlayerRankActionArray = {
	_("menu_crewmenu_manage_action_promote"),
	_("menu_crewmenu_manage_action_demote"),
}
local nearPlayerRankActionArrayIndex = 1

if Config.menuStyle.bannerStyle.imageUrl ~= nil then
	local runtimeTXD = CreateRuntimeTxd("custom_menu_header")
	local Object = CreateDui(
		Config.menuStyle.bannerStyle.imageUrl,
		Config.menuStyle.bannerStyle.imageSize.width,
		Config.menuStyle.bannerStyle.imageSize.height
	)
	_G.Object = Object
	local objectTexture = GetDuiHandle(Object)
	local Texture = CreateRuntimeTextureFromDuiHandle(runtimeTXD, "custom_menu_header", objectTexture)
	bannerTexture = "custom_menu_header"
end

local crewMenuObject = RageUI.CreateMenu(
	_U("menu_crewmenu_title"),
	_U("menu_crewmenu_subtitle"),
	Config.menuStyle.margins.left,
	Config.menuStyle.margins.top,
	bannerTexture,
	bannerTexture
)
local crewMenuObject_manage = RageUI.CreateSubMenu(
	crewMenuObject,
	_U("menu_crewmenu_title"),
	_U("menu_crewmenu_subtitle_manage"),
	Config.menuStyle.margins.left,
	Config.menuStyle.margins.top,
	bannerTexture,
	bannerTexture
)
local crewMenuObject_manage_list = RageUI.CreateSubMenu(
	crewMenuObject_manage,
	_U("menu_crewmenu_title"),
	_U("menu_crewmenu_subtitle_manage_list"),
	Config.menuStyle.margins.left,
	Config.menuStyle.margins.top,
	bannerTexture,
	bannerTexture
)
local crewMenuObject_top = RageUI.CreateSubMenu(
	crewMenuObject,
	_U("menu_crewmenu_title"),
	_U("menu_crewmenu_subtitle_top"),
	Config.menuStyle.margins.left,
	Config.menuStyle.margins.top,
	bannerTexture,
	bannerTexture
)
crewMenuObject.Closed = function()
	isMenuOpened = false
	LocalPlayer.state:set("RageUI:menuOpened", false, false)
end
if Config.menuStyle.bannerStyle.imageUrl == nil then
	crewMenuObject:SetRectangleBanner(
		Config.menuStyle.bannerStyle.color.r,
		Config.menuStyle.bannerStyle.color.g,
		Config.menuStyle.bannerStyle.color.b,
		Config.menuStyle.bannerStyle.color.a
	)
	crewMenuObject_manage:SetRectangleBanner(
		Config.menuStyle.bannerStyle.color.r,
		Config.menuStyle.bannerStyle.color.g,
		Config.menuStyle.bannerStyle.color.b,
		Config.menuStyle.bannerStyle.color.a
	)
	crewMenuObject_manage_list:SetRectangleBanner(
		Config.menuStyle.bannerStyle.color.r,
		Config.menuStyle.bannerStyle.color.g,
		Config.menuStyle.bannerStyle.color.b,
		Config.menuStyle.bannerStyle.color.a
	)
	crewMenuObject_top:SetRectangleBanner(
		Config.menuStyle.bannerStyle.color.r,
		Config.menuStyle.bannerStyle.color.g,
		Config.menuStyle.bannerStyle.color.b,
		Config.menuStyle.bannerStyle.color.a
	)
end

local function openCrewMenu()
	if (IsPlayerDead(PlayerId()) or LocalPlayer.state["RageUI:menuOpened"]) and not isMenuOpened then
        return
    end
	local selfCrewDatas = LocalPlayer.state["epyi_crewsystem:selfCrew"]
	local selfPower = LocalPlayer.state["epyi_crewsystem:selfPower"]
	local selfMaxPower = LocalPlayer.state["epyi_crewsystem:selfMaxPower"]
	local crewsInfos = GlobalState["epyi_crewsystem:crewInfos"]
	if selfCrewDatas.name == "citizen" then
		return
	end
	if isMenuOpened then
		isMenuOpened = false
		LocalPlayer.state:set("RageUI:menuOpened", false, false)
		return
	end
	isMenuOpened = true
	LocalPlayer.state:set("RageUI:menuOpened", true, false)
	RageUI.Visible(crewMenuObject, true)
	while isMenuOpened do
		selfCrewDatas = LocalPlayer.state["epyi_crewsystem:selfCrew"]
		selfPower = LocalPlayer.state["epyi_crewsystem:selfPower"]
		selfMaxPower = LocalPlayer.state["epyi_crewsystem:selfMaxPower"]
		crewsInfos = GlobalState["epyi_crewsystem:crewInfos"]
		local isCrewBoss = selfCrewDatas.rank == getCrewBossRank(selfCrewDatas.name) and true or false
		if not selfCrewDatas or not selfCrewDatas.name or selfCrewDatas.name == "citizen" then
			isMenuOpened = false
			LocalPlayer.state:set("RageUI:menuOpened", false, false)
		end
		RageUI.IsVisible(
			crewMenuObject,
			true,
			Config.menuStyle.bannerStyle.useGlareEffect,
			Config.menuStyle.bannerStyle.useInstructionalButtons,
			function()
				RageUI.Separator(_U("menu_crewmenu_mycrew", selfCrewDatas.name_label))
				RageUI.Separator(_U("menu_crewmenu_mycrew_rank", selfCrewDatas.rank_label))
				RageUI.Progress(_U("menu_crewmenu_mypower", selfPower, selfMaxPower), selfPower > 0 and selfPower or 0, selfMaxPower, _U("menu_crewmenu_mypower_desc"), 0, true, function()end)
				RageUI.Progress(_U("menu_crewmenu_crewpower", crewsInfos[selfCrewDatas.name].power, crewsInfos[selfCrewDatas.name].maxPower), crewsInfos[selfCrewDatas.name].power > 0 and crewsInfos[selfCrewDatas.name].power or 0, crewsInfos[selfCrewDatas.name].maxPower, _U("menu_crewmenu_crewpower_desc"), 0, true, function()end)
				RageUI.ButtonWithStyle(_U("menu_crewmenu_territories"), _U("menu_crewmenu_territories_desc"), { RightLabel = "→" }, true, function(h, a, s)
					if s then
						showTerritories()
					end
				end)
				RageUI.ButtonWithStyle(
					_U("menu_crewmenu_top"),
					_U("menu_crewmenu_top_desc"),
					{ RightLabel = "→" },
					true,
					function(h, a, s) end,
					crewMenuObject_top
				)
				RageUI.ButtonWithStyle(
					_U("menu_crewmenu_manage"),
					isCrewBoss and _U("menu_crewmenu_manage_desc") or _U("menu_crewmenu_manage_desc_cannot"),
					{ RightLabel = "→" },
					isCrewBoss,
					function(h, a, s) end,
					crewMenuObject_manage
				)
				RageUI.ButtonWithStyle(
					_U("menu_crewmenu_leave"),
					isCrewBoss and _U("menu_crewmenu_leave_desc_cannot") or _U("menu_crewmenu_leave_desc"),
					{ RightLabel = "→", Color = { BackgroundColor = { 150, 50, 50, 20 } } },
					not isCrewBoss,
					function(h, a, s)
						if s then
							TriggerServerEvent("epyi_crewsystem:leaveMyCrew")
						end
					end
				)
			end
		)
		RageUI.IsVisible(
			crewMenuObject_manage,
			true,
			Config.menuStyle.bannerStyle.useGlareEffect,
			Config.menuStyle.bannerStyle.useInstructionalButtons,
			function()
				RageUI.ButtonWithStyle(
					_U("menu_crewmenu_manage_list"),
					_U("menu_crewmenu_manage_list_desc"),
					{ RightLabel = "→" },
					true,
					function(h, a, s)end,
					crewMenuObject_manage_list
				)

				local isNearestPlayer = false
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 4.0 then
                    isNearestPlayer = false
                else
                    isNearestPlayer = true
                    markClosestPlayer(145, 21, 21, 150)
                end
				RageUI.Separator(_U("menu_crewmenu_manage_nearest"))
				RageUI.List(_U("menu_crewmenu_manage_nearest_crew"), nearPlayerCrewActionArray, nearPlayerCrewActionArrayIndex, _U("menu_crewmenu_manage_nearest_crew_desc"), {}, isNearestPlayer, function(h, a, s, i)
					nearPlayerCrewActionArrayIndex = i
					if s then
						if nearPlayerCrewActionArray[nearPlayerCrewActionArrayIndex] == _("menu_crewmenu_manage_action_hire") then
							TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "serverid", GetPlayerServerId(closestPlayer), "hire")
						elseif nearPlayerCrewActionArray[nearPlayerCrewActionArrayIndex] == _("menu_crewmenu_manage_action_fire") then
							TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "serverid", GetPlayerServerId(closestPlayer), "fire")
						end
					end
				end)
				RageUI.List(_U("menu_crewmenu_manage_nearest_rank"), nearPlayerRankActionArray, nearPlayerRankActionArrayIndex, _U("menu_crewmenu_manage_nearest_rank_desc"), {}, isNearestPlayer, function(h, a, s, i)
					nearPlayerRankActionArrayIndex = i
					if s then
						if nearPlayerRankActionArray[nearPlayerRankActionArrayIndex] == _("menu_crewmenu_manage_action_promote") then
							TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "serverid", GetPlayerServerId(closestPlayer), "promote")
						elseif nearPlayerRankActionArray[nearPlayerRankActionArrayIndex] == _("menu_crewmenu_manage_action_demote") then
							TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "serverid", GetPlayerServerId(closestPlayer), "demote")
						end
					end
				end)
			end
		)
		RageUI.IsVisible(
			crewMenuObject_manage_list,
			true,
			Config.menuStyle.bannerStyle.useGlareEffect,
			Config.menuStyle.bannerStyle.useInstructionalButtons,
			function()
				local playerIndex = 0
				for key, member in pairs(crewsInfos[selfCrewDatas.name].members) do
					playerIndex = playerIndex + 1
					RageUI.List(member.firstname .. " " .. member.lastname .. " ~c~[" .. string.upper(getCrewRankLabelFromName(member.crewName, member.crewRank)) ..  "]", memberListActionsArray, memberListActionsArrayIndex, _U("menu_crewmenu_manage_list_unit_desc"), {}, true, function(h, a, s, i)
						memberListActionsArrayIndex = i
						if s then
							if memberListActionsArray[memberListActionsArrayIndex] == _("menu_crewmenu_manage_action_fire") then
								TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "identifier", member.identifier, "fire")
							elseif memberListActionsArray[memberListActionsArrayIndex] == _("menu_crewmenu_manage_action_promote") then
								TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "identifier", member.identifier, "promote")
							elseif memberListActionsArray[memberListActionsArrayIndex] == _("menu_crewmenu_manage_action_demote") then
								TriggerServerEvent("epyi_crewsystem:bossActionOnCrewMember", "identifier", member.identifier, "demote")
							end
						end
					end)
					RageUI.PercentagePanel(member.crewPower / member.crewMaxPower, _U("menu_crewmenu_manage_list_power", member.firstname, member.crewPower, member.crewMaxPower), 0, tostring(member.crewMaxPower), function(Hovered, Active, Percentage)
					end, playerIndex)
				end
			end
		)
		RageUI.IsVisible(
			crewMenuObject_top,
			true,
			Config.menuStyle.bannerStyle.useGlareEffect,
			Config.menuStyle.bannerStyle.useInstructionalButtons,
			function()
				local influences = GlobalState["epyi_crewsystem:influences"]
				local sortInfluences = {}
				local keys = {}
				local function compareInfluences(a, b)
					return influences[a] > influences[b]
				end
				for key in pairs(influences) do
					table.insert(keys, key)
				end
				table.sort(keys, compareInfluences)
				for index, key in ipairs(keys) do
					sortInfluences[index] = { crew = key, influence = influences[key] }
				end
				RageUI.Separator(_U("menu_crewmenu_top_actual", influences[selfCrewDatas.name]))
				for key, datas in pairs(sortInfluences) do
					RageUI.ButtonWithStyle(_("menu_crewmenu_top_class", key, getCrewNameLabelFromName(datas.crew)), _U("menu_crewmenu_top_class_desc", getCrewNameLabelFromName(datas.crew), datas.influence, key), { RightLabel = datas.influence .. " " .. _("utils_points")}, true, function(h, a, s)end)
				end
			end
		)
		if menuItemsCooldown then
			crewMenuObject.Controls.Back.Enabled = false
			crewMenuObject_manage.Controls.Back.Enabled = false
			crewMenuObject_manage_list.Controls.Back.Enabled = false
			crewMenuObject_top.Controls.Back.Enabled = false
		else
			crewMenuObject.Controls.Back.Enabled = true
			crewMenuObject_manage.Controls.Back.Enabled = true
			crewMenuObject_manage_list.Controls.Back.Enabled = true
			crewMenuObject_top.Controls.Back.Enabled = true
		end
		Citizen.Wait(0)
	end
	RageUI.CloseAll()
end

RegisterKeyMapping("epyi_crewsystem:openCrewMenu", _U("keymapping_crewmenu_desc"), "keyboard", "F7")
RegisterCommand("epyi_crewsystem:openCrewMenu", function()
	openCrewMenu()
end)
