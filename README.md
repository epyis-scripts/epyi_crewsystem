<h1 align='center'>Epyi's Scripts → Crew System</a></h1>
<p align='center'><a href='https://discord.gg/VyRPheG6Es'>Discord</a> - <a href='https://work-fivem.fr/'>Website</a></b></h5>

<p align='center'><b>Crew System (Integrated Double Job) for FiveM using RageUI library. The script was made for <a href="https://github.com/esx-framework/esx_core">ESX Legacy 1.7.5</a> and newer</b></p>

```diff
- Be vigilant and download a release and not the source code directly.
```
## 👀 Characteristics of the script
- Compatible only on <a href="https://github.com/esx-framework/esx_core">ESX Legacy 1.7.5</a> and above
- Integrated double job (the system uses statebags and not SetJob2 or SetFaction type events. The script is not drag and dropable!)
- Territory claiming system similar to minecraft PVP Faction
- Power system similar to minecraft PVP Faction
- Influence point system for each gang with ranking
- Compatible with epyi_garage script (need to configure garage in the config file)
- Commands to manage player power and crew influence points
- The menu is made with the RageUI lib and is completely configurable
- Ability to easily change all script language messages
- Very customizable configuration
- The script is optimized (0.00ms/0.00%)

## 🔧 How to use it ? (because the script is not 100% drag and dropable)
```lua
-- GET SELF CREW DATAS IN CLIENT SIDE
local myCrewDatas = LocalPlayer.state["epyi_crewsystem:selfCrew"]
print(myCrewDatas.name) -- myCrewDatas.name will return the crew name
print(myCrewDatas.name_label) -- myCrewDatas.name_label will return the crew display name
print(myCrewDatas.rank) -- myCrewDatas.rank will return the rank number
print(myCrewDatas.rank_label) -- myCrewDatas.rank will return the rank display name 
```

## 💾 Dependencies
- **es_extended** from <a href="https://github.com/esx-framework/esx_core">esx_core official repository</a>
- **ox_inventory** from <a href="https://github.com/overextended/ox_inventory">ox_inventory official repository</a>
## 🔧 Installation guide
1. Go download a **release of the script**
2. Extract the downloaded zip
3. Drag and drop the **epyi_crewsystem** folder into your server
4. Import the sql file (import.sql) into your database
5. Start the resource folder by using **ensure epyi_crewsystem** in your server.cfg
6. **IMPORTANT →** Configure the script by editing the **config.lua** file (Some examples gang and organization are already configured, you need to configure others by yourself)
## 📜 License
### Licence of the script
    Copyright (C) 2023 Epyi's Scripts

    This program Is free software: you can redistribute it And/Or modify it under the terms Of the MIT License.
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/epyis-scripts/epyi_administration/blob/main/LICENSE)
