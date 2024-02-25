Citizen.CreateThread(function()
	for key, datas in pairs(Config.crews) do
		if datas.blip then
			local blip = AddBlipForCoord(datas.blip.coords)
			SetBlipSprite(blip, datas.blip.style.sprite)
			SetBlipDisplay(blip, datas.blip.style.display)
			SetBlipScale(blip, datas.blip.style.scale)
			SetBlipColour(blip, datas.blip.style.colour)
			SetBlipAsShortRange(blip, datas.blip.style.shortRange)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(datas.blip.style.label)
			EndTextCommandSetBlipName(blip)

			local area = AddBlipForRadius(datas.blip.coords, 100.0)
			SetBlipColour(area, datas.blip.style.colour)
			SetBlipAlpha(area, 150)
		end
	end
end)
