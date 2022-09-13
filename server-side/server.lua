-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
domainYRP = {}
Tunnel.bindInterface("yrp_domain",domainYRP)
vCLIENT = Tunnel.getInterface("yrp_domain")
vSurvival = Tunnel.getInterface("survival")

RegisterCommand("do",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(parseInt(user_id),"Owner") then
			vCLIENT.startDomain(-1)
		end
	end
end)

RegisterNetEvent('WeaponEvent')
AddEventHandler('WeaponEvent', function(src, cb)
end)

RegisterNetEvent('Multiverse:GetWorld')
AddEventHandler('Multiverse:GetWorld', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(WorldTracker[ids.license]);
    end
    cb("Normal");
end)

RegisterNetEvent('Multiverse:GetWorldBucketID')
AddEventHandler('Multiverse:GetWorldBucketID', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(WorldTracker[ids.license]);
    end
    cb(1);
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
  
    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
  
        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end  
    return identifiers
end

AddEventHandler('playerDropped', function (reason)
    local source = source
	local user_id = vRP.getUserId(source)
	local weapons = vRPclient.replaceWeapons(source)
	for k,v in pairs(weapons) do
		vRP.giveInventoryItem(user_id,k,1)
		vRP.execute("vRP/del_weapon", { user_id = user_id, weapon = k })
		if v.ammo > 0 then
			vRP.giveInventoryItem(user_id,vRP.itemAmmoList(k),v.ammo)
		end
	end
    local ids = ExtractIdentifiers(source);
    WorldTracker[ids.license] = nil;
    local ids = ExtractIdentifiers(source);
end)

RegisterNetEvent('Multiverse:ChangeWorld')
AddEventHandler('Multiverse:ChangeWorld', function(worldId)
    local source = source
	if (worldId ~= 0) then
		local user_id = vRP.getUserId(source)
		local weapons = {}
		weapons[string.gsub("WEAPON_MILITARYRIFLE","wbody|","")] = { ammo = 250 }
		vRPclient._giveWeapons(source,weapons)
		vRPclient.setArmour(source,100)
	else
		local weapons = vRPclient.replaceWeapons(source)
		for k,v in pairs(weapons) do
			vRP.giveInventoryItem(user_id,k,1)
			vRP.execute("vRP/del_weapon", { user_id = user_id, weapon = k })
			if v.ammo > 0 then
				vRP.giveInventoryItem(user_id,vRP.itemAmmoList(k),v.ammo)
			end
		end
	end
    local ids = ExtractIdentifiers(source);
    SetPlayerRoutingBucket(source, tonumber(worldId));
    WorldTracker[ids.license] = worldId;
    return;
end)