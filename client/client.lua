for key, crew in pairs(Config.crews) do
	for key, point in pairs(crew.fixedPoints) do
		if point.crewOwnedLoop then
			Citizen.CreateThread(function()
				repeat
					local ped = PlayerPedId()
					local pedCoords = GetEntityCoords(ped)
					local state = LocalPlayer.state["epyi_crewsystem:selfCrew"]
					local selfCrew = state and state.name
					local selfRank = state and state.rank
					if #(point.coords - pedCoords) < 50 and crew.id == selfCrew and selfRank >= point.minRank then
						repeat
							pedCoords = GetEntityCoords(ped)
							state = LocalPlayer.state["epyi_crewsystem:selfCrew"]
							selfCrew = state and state.name
							selfRank = state and state.rank
							if #(point.coords - pedCoords) < 10 and crew.id == selfCrew and selfRank >= point.minRank then
								repeat
									pedCoords = GetEntityCoords(ped)
									state = LocalPlayer.state["epyi_crewsystem:selfCrew"]
									selfCrew = state and state.name
									selfRank = state and state.rank
									for key, datas in pairs(point.markers) do
										DrawMarker(
											datas.type,
											point.coords.x + datas.offset.x,
											point.coords.y + datas.offset.y,
											point.coords.z + datas.offset.z,
											0.0,
											0.0,
											0.0,
											datas.rotation.x,
											datas.rotation.y,
											datas.rotation.z,
											datas.size.x,
											datas.size.y,
											datas.size.z,
											datas.color.r,
											datas.color.g,
											datas.color.b,
											datas.color.a,
											datas.upAndDown,
											datas.faceToPlayer
										)
									end
									if #(point.coords - pedCoords) < 1.5 then
										ESX.ShowHelpNotification(point.helpLabel)
										if IsControlJustPressed(0, 38) then
											point.method()
										end
									end
									Citizen.Wait(1)
								until #(point.coords - pedCoords) >= 10 or crew.id ~= selfCrew or selfRank < point.minRank
							end
							Citizen.Wait(1000)
						until #(point.coords - pedCoords) >= 50 or crew.id ~= selfCrew or selfRank < point.minRank
					end
					Citizen.Wait(5000)
				until false
			end)
		end
		point.initMethod()
	end
end

Citizen.CreateThread(function()
	repeat
		TriggerServerEvent("epyi_crewsystem:selfPowerTick")
		Citizen.Wait(30 * 60 * 1000)
	until false
end)
