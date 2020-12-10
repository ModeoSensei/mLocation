ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


function SelectSpawnPoint()
    local found = false
    for k,v in pairs(zoneDeSpawn) do
        local clear = ESX.Game.IsSpawnPointClear(v.pos, 5.0)
        if clear and not found then
            found = true
            return v.pos, v.heading
        end
    end
    return false
end

RMenu.Add('location', 'location_main', RageUI.CreateMenu("Location véhicule", "Séléctionne un véhicule"))
RMenu:Get('location', 'location_main'):SetSubtitle("~b~LOCATION VEHICULE CIVIL")
RMenu:Get('location', 'location_main').EnableMouse = false;
RMenu:Get('location', 'location_main').Closed = function()
    SetBlockingOfNonTemporaryEvents(Ped, 1)
end

RMenu.Add("location", "location_main2", RageUI.CreateSubMenu(RMenu:Get("location", "location_main"), "Voitures", "Voici les 4 roues à louer"))
RMenu:Get('location', 'location_main2').EnableMouse = false;
RMenu:Get('location', 'location_main2').Closed = function()
    SetBlockingOfNonTemporaryEvents(Ped, 1)
end

RMenu.Add("location", "location_main3", RageUI.CreateSubMenu(RMenu:Get("location", "location_main"), "Motos & Vélo", "Voici les Motos & Vélo à louer"))
RMenu:Get('location', 'location_main3').EnableMouse = false;
RMenu:Get('location', 'location_main3').Closed = function()
    SetBlockingOfNonTemporaryEvents(Ped, 1)
end

local modeo = {
	{x = -1043.4936523438, y = -2661.5031738281, z = 13.830758094788},
}

Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local dest = vector3(-1034.85, -2732.86, 20.17)
        local distance = GetDistanceBetweenCoords(pos, dest, true)

        for k in pairs(modeo) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, modeo[k].x, modeo[k].y, modeo[k].z)

        if distance > 30 then
            interval = 200 
        else
            interval = 1
            DrawMarker(32, zone.x, zone.y, zone.z+2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 0, 255, 0, 170, 0, 0, 2, 1, nil, nil, 0)
            if distance < 1 then  
                AddTextEntry("HELP", "Appuyer sur ~b~E~w~ pour parler avec la personne.")
                DisplayHelpTextThisFrame("HELP", false)
                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get("location","location_main"), true)
                end
            end
        end
        Citizen.Wait(interval)
    end
    end
end)

local vec = {
    "Blista",
    "Panto",
    "Rhapsody"
}

local vecIndex = 1

local vec2 = {
    "Faggio",
    "Bmx",
    "Cruiser",
    "Scorcher"
}

local vec2Index = 1

local index = {
    sourie = false,
    veh = 1,
}

Citizen.CreateThread(function()
    local cooldown = false
    while true do

        RageUI.IsVisible(RMenu:Get("location","location_main"),true,true,true,function()

            RageUI.ButtonWithStyle("Voitures", nil, {RightLabel = "→→"}, not cooldown,function(h,a,s)
            end, RMenu:Get("location","location_main2"))

            RageUI.ButtonWithStyle("Motos & Vélo", nil, {RightLabel = "→→"}, not cooldown,function(h,a,s)
            end, RMenu:Get("location","location_main3"))

        end, function()end, 1)

        RageUI.IsVisible(RMenu:Get("location","location_main2"),true,true,true,function()
            
            RageUI.List("Véhicule", vec, vecIndex, "Choix du véhicule", {}, true, function(h, a, s, i) vecIndex = i end, RMenu:Get("location","location_main2")) 

            RageUI.ButtonWithStyle("Louer: ~b~"..vec[vecIndex], nil, {RightBadge = RageUI.BadgeStyle.Car}, not cooldown,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    local model = GetHashKey(vec[vecIndex])
                    RequestModel(model)
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    local vehicle = CreateVehicle(model, -1030.28, -2732.32, 20.07, 239.0, true, false)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetVehicleNumberPlateText(vehicle, "LOCATION")
                    SetVehicleMaxSpeed(vehicle, 23.0)
                    SetVehicleHasBeenOwnedByPlayer(vehicle, 1)
                    RageUI.Popup({
                        colors = 140,
                        message = "Véhicule de location sortie. Soit prudent sur la route.",
                    })
                    RageUI.Popup({
                        colors = 140,
                        message = "Attention, les véhicule gratuit on leur moteur bridé",
                    })

                   cooldown = true
                   Citizen.SetTimeout(5000, function()
                        cooldown = false
                   end)
                end
            end)

        end, function()end, 1)

        RageUI.IsVisible(RMenu:Get("location","location_main3"),true,true,true,function()

            RageUI.List("Motos & Vélo", vec2, vec2Index, "Choix du véhicule", {}, true, function(h, a, s, i) vec2Index = i end, RMenu:Get("location","location_main3")) 

            RageUI.ButtonWithStyle("Louer: ~b~"..vec2[vec2Index], nil, {RightBadge = RageUI.BadgeStyle.Bike}, not cooldown,function(h,a,s)
                if s then
                    RageUI.CloseAll()
                    local model = GetHashKey(vec2[vec2Index])
                    RequestModel(model)
                    while not HasModelLoaded(model) do Citizen.Wait(10) end
                    local pos = GetEntityCoords(PlayerPedId())
                    local vehicle = CreateVehicle(model, -1030.28, -2732.32, 20.07, 239.0, true, false)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    SetVehicleNumberPlateText(vehicle, "LOCATION")
                    SetVehicleMaxSpeed(vehicle, 23.0)
                    SetVehicleHasBeenOwnedByPlayer(vehicle, 1)
                    RageUI.Popup({
                        colors = 140,
                        message = "Véhicule de location sortie. Soit prudent sur la route.",
                    })
                    RageUI.Popup({
                        colors = 140,
                        message = "Attention, les véhicule gratuit on leur moteur bridé",
                    })

                   cooldown = true
                   Citizen.SetTimeout(5000, function()
                        cooldown = false
                   end)
                end
            end)

        end, function()end, 1)

        Citizen.Wait(0)
    end
end)



--------- PED & BLIPS -----------

DecorRegister("Yay", 4)
pedHash = "s_m_m_security_01"
zone = vector3(-1034.42, -2732.15, 19.17)
Heading = 149.7
Ped = nil
HeadingSpawn = 250.61288452148

Citizen.CreateThread(function()
    LoadModel(pedHash)
    Ped = CreatePed(2, GetHashKey(pedHash), zone, Heading, 0, 0)
    DecorSetInt(Ped, "Yay", 5431)
    FreezeEntityPosition(Ped, 1)
    TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_CLIPBOARD", 0, false)
    SetEntityInvincible(Ped, true)
    SetBlockingOfNonTemporaryEvents(Ped, 1)

    local blip = AddBlipForCoord(zone)
    SetBlipSprite(blip, 464)
    SetBlipScale(blip, 0.7)
    SetBlipShrink(blip, true)
    SetBlipColour(blip, 11)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Location")
    EndTextCommandSetBlipName(blip)
    end)

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end