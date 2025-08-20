local ADMIN_GUN_HASH = `WEAPON_RAYPISTOL` -- Up-n-Atomizer

RegisterCommand("admingun", function(source, args)
    GiveWeaponToPed(PlayerPedId(), ADMIN_GUN_HASH, 0, false, true)
end, false)

RegisterCommand("dv", function(source, args)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    DeleteVehicle(vehicle)
end, false)

RegisterCommand("car", function(source, args)
    local vehicle = args[1]
    local PlayerPedId = PlayerPedId()
    local spawnedVeh = 0

    RequestModel(vehicle)
    if not IsModelInCdimage(vehicle) then return end
        RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(0)
    end
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId, true)
    if currentVehicle ~= 0 then DeleteVehicle(currentVehicle) end
    spawnedVeh = CreateVehicle(vehicle, GetEntityCoords(PlayerPedId), GetEntityHeading(PlayerPedId))
    TaskWarpPedIntoVehicle(PlayerPedId, spawnedVeh, -1)
end, false)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local _, weapon = GetCurrentPedWeapon(playerPed, true)

        if weapon == ADMIN_GUN_HASH then
            SetPedAmmo(playerPed, ADMIN_GUN_HASH, 0)
            DisablePlayerFiring(playerPed, true)
            local player = PlayerId()
            
            if IsPlayerFreeAiming(player) then
                local aiming, entity = GetEntityPlayerIsFreeAimingAt(player)
                local modelName = GetEntityArchetypeName(entity)

                if entity and DoesEntityExist(entity) then
                    local coords = GetEntityCoords(entity)
                    local heading = GetEntityHeading(entity)

                    drawText(string.format("~y~Name: ~w~%s~n~~y~Coords: ~w~%.2f, %.2f, %.2f~n~~y~Heading: ~w~%.2f", 
                        modelName, coords.x, coords.y, coords.z, heading))

                    if IsControlJustPressed(0, 27) then -- SCROLLWHEEL BUTTON
                        print("\nName: " .. modelName .. "\nHandles: " .. entity .. "\nCoords: " .. coords .. "\nHeading: " .. heading)
                        ShowNotification("~w~Wysłano do konsoli!")
                    end
                end
            end
        else
            Wait(250)
        end
    end
end)

-- function getEntityPlayerIsLookingAt()
--     local playerPed = PlayerPedId()
--     local playerCoords = GetEntityCoords(playerPed)
--     local forwardVector = GetEntityForwardVector(playerPed)
--     local rayEnd = vector3(playerCoords.x + forwardVector.x * 10.0, playerCoords.y + forwardVector.y * 10.0, playerCoords.z + forwardVector.z * 10.0)

--     local hit, entity = GetRaycastResult(playerCoords, rayEnd)

--     if hit and entity and DoesEntityExist(entity) then
--         return entity
--     end
--     return nil
-- end

-- function GetRaycastResult(from, to)
--     local shapeTest = StartShapeTestRay(from.x, from.y, from.z, to.x, to.y, to.z, 16, PlayerPedId(), 0)
--     local retval, hit, _, _, entity = GetShapeTestResult(shapeTest)

--     if hit == 1 and DoesEntityExist(entity) then
--         return true, entity
--     end
--     return false, nil
-- end

function drawText(text)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.3, 0.3)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.88)
end

function ShowNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end
