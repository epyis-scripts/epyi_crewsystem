local isShowingTerritories = false
local territoriesCamera
local camCoords = {
	x = 0.0,
	y = 0.0,
}
local camZ = 1000.0
local isBox = false

RegisterCommand("territories", function()
	showTerritories()
end, false)

function showTerritories()
	if isShowingTerritories then
		isShowingTerritories = false
		return
	end
	if GetResourceState("vms_hud") == "started" then
		TriggerEvent("vms_hud:display", false)
	end
	isShowingTerritories = true
	territoriesCamera = CreateCameraWithParams(26379945, camCoords.x, camCoords.y, camZ, -90.0, 0.0, 0.0, 90.0, 1, 2)
	while not DoesCamExist(territoriesCamera) do
		Citizen.Wait(10)
	end
	SetCamActive(territoriesCamera, true)
	RenderScriptCams(true, false, 1, 1, 0, 0)
	while isShowingTerritories do
		FreezeEntityPosition(PlayerPedId(), true)
		SetCloudHatOpacity(0.0)
		SetOverrideWeather("CLEAR")
		NetworkOverrideClockTime(12, 00, 00)
		DisplayRadar(false)

		local territories = GlobalState["epyi_crewsystem:territories"]

		DrawRect(0.5, 0.5, 0.01 / GetAspectRatio(true), 0.01, 255, 255, 255, 255)

		for _, claim in pairs(territories) do
			if claim.owner ~= "citizen" then
				local color = { r = 0, g = 0, b = 0 }
				for key, configcrew in pairs(Config.crews) do
					if configcrew.id == claim.owner then
						color = configcrew.color
					end
				end
				DrawBox(claim.x * 100 + 0.0, claim.y * 100 + 0.0, isBox and 0.0 or 399.9, claim.x * 100 + 100.0, claim.y * 100 + 100.0, 400.0, tonumber(color.r), tonumber(color.g), tonumber(color.b), 150)
			end
		end

		-- Movements
		if IsControlPressed(0, 32) then
			if camCoords.y < 7000.0 then
				camCoords.y = camCoords.y + camZ / 70
			end
		end
		if IsControlPressed(0, 33) then
			if camCoords.y > -7000.0 then
				camCoords.y = camCoords.y - camZ / 70
			end
		end
		if IsControlPressed(0, 34) then
			if camCoords.x > -4000.0 then
				camCoords.x = camCoords.x - camZ / 70
			end
		end
		if IsControlPressed(0, 35) then
			if camCoords.x < 6500.0 then
				camCoords.x = camCoords.x + camZ / 70
			end
		end

		-- Quit territories menu
		if IsControlJustPressed(0, 202) then
			isShowingTerritories = false
		end

		-- Zoom in/out
		if IsControlPressed(0, 96) then
			if camZ > 450 then
				camZ = camZ - 70
			end
		elseif IsControlPressed(0, 97) then
			if camZ <= 3000 then
				camZ = camZ + 70
			end
		end

		-- Render type
		if IsControlJustPressed(0, 20) then
			isBox = not isBox
		end

		if IsControlJustPressed(0, 191) then
			local selfCrewDatas = LocalPlayer.state["epyi_crewsystem:selfCrew"]
			local isCrewBoss = selfCrewDatas.rank == getCrewBossRank(selfCrewDatas.name) and true or false
			if isCrewBoss and selfCrewDatas.name ~= "citizen" then
				TriggerServerEvent("epyi_crewsystem:claimChunk", round100(camCoords.x) / 100, round100(camCoords.y) / 100)
			else
				ESX.ShowNotification(_U("notif_not_boss"))
			end
		end

		-- Help text
		ESX.ShowHelpNotification(_U("help_territories"))

		SetCamCoord(territoriesCamera, camCoords.x, camCoords.y, camZ)

		Citizen.Wait(0)
	end
	if GetResourceState("vms_hud") == "started" then
		TriggerEvent("vms_hud:display", true)
	end
	FreezeEntityPosition(PlayerPedId(), false)
	SetCamActive(territoriesCamera, false)
	DestroyCam(territoriesCamera)
	territoriesCamera = nil
	RenderScriptCams(false, false, 0, true, true)
	ClearOverrideWeather()
	DisplayRadar(true)
end
