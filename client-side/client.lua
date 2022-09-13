-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
domainYRP = {}
Tunnel.bindInterface("yrp_domain",domainYRP)
vSERVER = Tunnel.getInterface("yrp_domain")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blip = nil
local radius = 1500.0
local inService = false
local driverPosition = 1
local timeSeconds = 60000
local started = 0
local started = false
local event = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local coords = { -319.8,2804.87,72.27 }
function domainYRP.startDomain()
	local ped = PlayerPedId()
	started = true
	if not inService and event then
		inService = true
		makeBlipsPosition()
		startthreadtimeseconds()
		local ped = PlayerPedId()
		local coordsPed = GetEntityCoords(ped)
		local distance = #(coordsPed - vector3(coords[1],coords[2],coords[3]))
		if distance <= radius then
			--TriggerEvent("Notify","aviso","Área reduzida.",60000)
		end
		TriggerEvent("Notify","verde","Evento iniciado, boa sorte a todos.",15000)
	else
		TriggerEvent("Notify","vermelho","Você não está participando do evento, as regras de RDM aplicam a você",5000)
	end
end

RegisterNetEvent("Multiverse:ChangeCoords")
AddEventHandler("Multiverse:ChangeCoords", function(x, y, z)
    SetEntityCoords(GetPlayerPed(-1), x, y, z, false, false, false, false);
end)

RegisterCommand("joinbr", function(source, args, rawCommand)
    local src = source;
	if not started then
		event = true
    	TriggerServerEvent('Multiverse:ChangeWorld', 1);
		TriggerEvent("Notify","verde","Você entrou para o evento, aguarde ele começar",15000)
	else
		TriggerEvent("Notify","vermelho","Evento já iniciado, quem sabe da próxima",15000)
	end
end)

RegisterCommand("lvbr", function(source, args, rawCommand)
    local src = source;
    TriggerServerEvent('Multiverse:ChangeWorld', 0);
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function startthreadtimeseconds()
	Citizen.CreateThread(function()
		while true do
			if timeSeconds > 0 then
				timeSeconds = timeSeconds - 1
				radius = radius - 2.0
				makeBlipsPosition()
				local ped = PlayerPedId()
				local coordsPed = GetEntityCoords(ped)
				local distance = #(coordsPed - vector3(coords[1],coords[2],coords[3]))
				if distance >= radius then
					local health = GetEntityHealth(ped)
					SetEntityHealth(ped,parseInt(health-15))
				end
			end
			Citizen.Wait(1000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPSPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipsPosition()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end

	if not DoesBlipExist(blip) then
		blip = AddBlipForRadius(coords[1],coords[2],coords[3],radius)
		SetBlipHighDetail(blip,true)
		SetBlipColour(blip,75)
		SetBlipAlpha(blip,150)
		SetBlipAsShortRange(blip,true)
	end
end