function checkVersion(err, responseText, headers)
	local resource = GetInvokingResource() or GetCurrentResourceName()
	local currentVersion = GetResourceMetadata(resource, "version", 0)

	if currentVersion == nil then
		print(
			"^5(^2EPYI_CREWSYSTEM^5) ^4- ^0It looks like your ressource's version checker is broken. If you want to patch this, go download the latest release of this script at -- > https://github.com/epyis-scripts/epyi_crewsystem^0"
		)
		return
	end
	if responseText == nil then
		print(
			"^5(^2EPYI_CREWSYSTEM^5) ^4- ^0It looks like github is offline. The resource uses github to check if it's up to date. This does not prevent the resource from working.^0"
		)
		return
	end
	if currentVersion:gsub("%s+", "") ~= responseText:gsub("%s+", "") then
		print(
			"^5(^2EPYI_CREWSYSTEM^5) ^4- ^0epyi_crewsystem is not up to date. The latest release is "
				.. responseText
				.. " but you are on release "
				.. currentVersion
				.. " -- > https://github.com/epyis-scripts/epyi_crewsystem^0"
		)
	end
end

function performVersionCheck()
	PerformHttpRequest(
		"https://raw.githubusercontent.com/epyidev/lyre-framework-versions/main/epyi_crewsystem",
		checkVersion,
		"GET"
	)
end