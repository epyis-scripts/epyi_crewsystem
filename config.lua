Config = {}
Config.Locale = GetConvar("epyi_crewsystem:locale", "fr") -- Which locale you want to use : fr
Config.bridge = "ESX" -- Which bridge you want to use. Available : ESX (Only support latest version of these frameworks)

Config.menuStyle = {
	margins = { left = 10, top = 10 }, -- [table] → Set the menu margins
	bannerStyle = {
		color = { r = 150, g = 50, b = 50, a = 100 }, -- [table] → Set the banner color if no custom banner image is set
		useGlareEffect = false, -- [boolean] → Use the glare effect or not
		useInstructionalButtons = true, -- [boolean] → Use the instructionals buttons or not
		imageUrl = GetConvar("rage_banner", nil), -- [nil/string] → Set a custom image url if you want (if set, it will disable the Color configuration)
		imageSize = { width = 512, height = 128 }, -- [table] → Set the image (ImageUrl) size un pixels
		widthOffset = 0, -- [integer] → Offset of the menu (default: 0, max: 100)
	},
}

Config.noCrew = { name = "Citoyen", rank = "Espérance" }
Config.crews = {
	{
		id = "ballas",
		label = "Ballas",
		blip = {
			coords = vec3(103.07093048096, -1938.2780761719, 20.803720474243),
			style = {
				display = 4,
				sprite = 310,
				colour = 27,
				scale = 0.8,
				shortRange = true,
				label = "Zone sensible - Quartier ballas",
			},
		},
		color = { r = 138, g = 10, b = 116 },
		ranks = {
			[0] = { label = "Petite frappe" },
			[1] = { label = "Frappe" },
			[2] = { label = "Elite" },
			[3] = { label = "Capitaine" },
			[4] = { label = "O.G" },
		},
		fixedPoints = {
			{
				minRank = 0,
				coords = vec3(119.18789672852, -1968.3529052734, 21.327653884888),
				helpLabel = "~INPUT_PICKUP~ Ouvrir le coffre du gang",
				crewOwnedLoop = true,
				method = function(type, pos)
					local stash = {
						name = "ballas:storage_1",
						label = "Coffre de gang",
						slots = 50,
						weight = 150000,
						owner = false,
						coords = pos,
					}
					TriggerServerEvent("epyi_crewsystem:loadStashes", stash)
					exports.ox_inventory:openInventory("stash", stash.name)
				end,
				markers = {
					[1] = {
						type = 6,
						upAndDown = false,
						faceToPlayer = false,
						size = { x = 1.5, y = 1.5, z = 1.5 },
						rotation = { x = -90.0, y = 0.0, z = 0.0 },
						color = { r = 156, g = 42, b = 140, a = 150 },
						offset = { x = 0.0, y = 0.0, z = -0.95 },
					},
					[2] = {
						type = 20,
						upAndDown = false,
						faceToPlayer = true,
						size = { x = 1.0, y = 1.0, z = 1.0 },
						rotation = { x = 0.0, y = 0.0, z = 0.0 },
						color = { r = 156, g = 42, b = 140, a = 150 },
						offset = { x = 0.0, y = 0.0, z = 0.0 },
					},
				},
				initMethod = function() end,
			},
		},
	},
	{
		id = "families",
		label = "Families",
		blip = {
			coords = vec3(-14.182180404663, -1442.8093261719, 31.099273681641),
			style = {
				display = 4,
				sprite = 310,
				colour = 2,
				scale = 0.8,
				shortRange = true,
				label = "Zone sensible - Quartier families",
			},
		},
		color = { r = 10, g = 255, b = 10 },
		ranks = {
			[0] = { label = "Little new" },
			[1] = { label = "Families" },
			[2] = { label = "Homies" },
			[3] = { label = "Y.J" },
			[4] = { label = "O.G" },
		},
		fixedPoints = {
			{
				minRank = 1,
				coords = vec3(-17.904819488525, -1438.9136962891, 31.101552963257),
				helpLabel = "~INPUT_PICKUP~ Ouvrir le coffre du gang",
				crewOwnedLoop = true,
				method = function(type, pos)
					local stash = {
						name = "families:storage_1",
						label = "Coffre de gang",
						slots = 50,
						weight = 150000,
						owner = false,
						coords = pos,
					}
					TriggerServerEvent("epyi_crewsystem:loadStashes", stash)
					exports.ox_inventory:openInventory("stash", stash.name)
				end,
				markers = {
					[1] = {
						type = 6,
						upAndDown = false,
						faceToPlayer = false,
						size = { x = 1.5, y = 1.5, z = 1.5 },
						rotation = { x = -90.0, y = 0.0, z = 0.0 },
						color = { r = 10, g = 255, b = 10, a = 150 },
						offset = { x = 0.0, y = 0.0, z = -0.95 },
					},
					[2] = {
						type = 20,
						upAndDown = false,
						faceToPlayer = true,
						size = { x = 1.0, y = 1.0, z = 1.0 },
						rotation = { x = 0.0, y = 0.0, z = 0.0 },
						color = { r = 10, g = 255, b = 10, a = 150 },
						offset = { x = 0.0, y = 0.0, z = 0.0 },
					},
				},
				initMethod = function() end,
			},
			-- USE THIS CONFIGURATION SETTINGS ONLY IF YOU ARE USING EPYI GARAGE SYSTEM
			-- {
			-- 	minRank = 0,
			-- 	coords = vec3(-24.223567962646, -1457.0549316406, 30.642463684082),
			-- 	helpLabel = "~INPUT_PICKUP~ Ouvrir le garage du gang",
			-- 	crewOwnedLoop = false,
			-- 	method = function(type, pos) end,
			-- 	markers = {},
			-- 	initMethod = function()
			-- 		TriggerEvent("epyi_garage:registerCrewGarage", "CREW_FAMILIES", {
			-- 			crew = "families",
			-- 			location = vec3(-24.223567962646, -1457.0549316406, 30.642463684082),
			-- 			type = "car",
			-- 			crewBoss = 4,
			-- 			marker = 36,
			-- 		})
			-- 	end,
			-- },
		},
	},
	{
		id = "cayo",
		label = "Cartel de Cayo Perico",
		blip = nil,
		color = { r = 43, g = 158, b = 145 },
		ranks = {
			[0] = { label = "Recrue" },
			[1] = { label = "Soldado" },
			[2] = { label = "Homme de main" },
			[3] = { label = "Capitaine" },
			[4] = { label = "Lieutenant" },
			[5] = { label = "Bras gauche" },
			[6] = { label = "Bras droit" },
			[7] = { label = "El Patron" },
		},
		fixedPoints = {
			{
				minRank = 6,
				coords = vec3(5013.1889648438, -5756.3569335938, 28.900144577026),
				helpLabel = "~INPUT_PICKUP~ Ouvrir le coffre du patron",
				crewOwnedLoop = true,
				method = function(type, pos)
					local stash = {
						name = "cayo:storage_1",
						label = "Coffre du patron",
						slots = 50,
						weight = 70000,
						owner = false,
						coords = pos,
					}
					TriggerServerEvent("epyi_crewsystem:loadStashes", stash)
					exports.ox_inventory:openInventory("stash", stash.name)
				end,
				markers = {
					[1] = {
						type = 6,
						upAndDown = false,
						faceToPlayer = false,
						size = { x = 1.5, y = 1.5, z = 1.5 },
						rotation = { x = -90.0, y = 0.0, z = 0.0 },
						color = { r = 43, g = 158, b = 145, a = 150 },
						offset = { x = 0.0, y = 0.0, z = -0.95 },
					},
					[2] = {
						type = 20,
						upAndDown = false,
						faceToPlayer = true,
						size = { x = 1.0, y = 1.0, z = 1.0 },
						rotation = { x = 0.0, y = 0.0, z = 0.0 },
						color = { r = 43, g = 158, b = 145, a = 150 },
						offset = { x = 0.0, y = 0.0, z = 0.0 },
					},
				},
				initMethod = function() end,
			},
			{
				minRank = 1,
				coords = vec3(5028.8046875, -5734.296875, 17.865581512451),
				helpLabel = "~INPUT_PICKUP~ Ouvrir le coffre de l'organisation",
				crewOwnedLoop = true,
				method = function(type, pos)
					local stash = {
						name = "cayo:storage_2",
						label = "Coffre de l'organisation",
						slots = 50,
						weight = 200000,
						owner = false,
						coords = pos,
					}
					TriggerServerEvent("epyi_crewsystem:loadStashes", stash)
					exports.ox_inventory:openInventory("stash", stash.name)
				end,
				markers = {
					[1] = {
						type = 6,
						upAndDown = false,
						faceToPlayer = false,
						size = { x = 1.5, y = 1.5, z = 1.5 },
						rotation = { x = -90.0, y = 0.0, z = 0.0 },
						color = { r = 43, g = 158, b = 145, a = 150 },
						offset = { x = 0.0, y = 0.0, z = -0.95 },
					},
					[2] = {
						type = 20,
						upAndDown = false,
						faceToPlayer = true,
						size = { x = 1.0, y = 1.0, z = 1.0 },
						rotation = { x = 0.0, y = 0.0, z = 0.0 },
						color = { r = 43, g = 158, b = 145, a = 150 },
						offset = { x = 0.0, y = 0.0, z = 0.0 },
					},
				},
				initMethod = function() end,
			},
		},
	},
}
