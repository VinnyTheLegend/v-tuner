local QBCore = exports['qb-core']:GetCoreObject()
-- add citizen ids here for people allowed to use the UI and spawn cars
-- admin and god can use it by default
local DEVS = {

}

function HasPermission(source)
    local Player = QBCore.Functions.GetPlayer(source)
    local cid = Player.PlayerData.citizenid
    local dev = false
    for i, v in ipairs(DEVS) do
        if cid == v then dev = true end
    end
    if QBCore.Functions.HasPermission(source, 'god') == true or QBCore.Functions.HasPermission(source, 'admin') == true then
        return true
    elseif dev == true then
        return true
    else
        TriggerClientEvent('QBCore:Notify', source, 'You don\'t have permission to do this', 'error')
        return false 
    end
end

local arguments = {
    {name = 'car/reset', help = 'Optional: \"car\" or \"reset\"'},
    {name = 'car model', help = 'Optional: Vehicle model name if \"car\" is specified'},
}
QBCore.Commands.Add("v-tuner", "Enable the vehicle handling editor.", arguments, false, function(source, args)
    local src = source
    if HasPermission(src) == true then
        if args[1] == nil or args[1] == "" then
            TriggerClientEvent('vehicleDebug:client:toggleDebug', src)
        elseif args[1] == "reset" then
            TriggerClientEvent('vehicleDebug:client:resetBaseHandling', src)
        elseif args[1] == "car" then
            if not args[2] or args[2] == "" then
                TriggerClientEvent('QBCore:Notify', src, 'You need to specify a vehicle model.', 'error')
                return
            end
            local ped, bucket = GetPlayerPed(src), GetPlayerRoutingBucket(src)
            local _, vehicle = qbx.spawnVehicle({
                model = args[2],
                spawnSource = ped,
                warp = true,
                bucket = bucket
            })
            local plate = qbx.getVehiclePlate(vehicle)
            exports.qbx_vehiclekeys:GiveKeys(src, vehicle)
        end
    end
end)

QBCore.Functions.CreateCallback('v-tuner:LoadBaseHandling', function(source, cb, display_name)
	local result = MySQL.query.await('SELECT * FROM v_tuner_base WHERE name = ?', { display_name })
    if result[1] ~= nil then
        return cb(result[1])
    end
    return cb(nil)
end)

QBCore.Functions.CreateCallback('v-tuner:SetBaseHandling', function(source, cb, display_name, handling_data)
    local new_handling_data = {}
    for index, field in ipairs(handling_data) do
        new_handling_data[field.name] = field.value
    end

    local result = MySQL.insert('INSERT INTO v_tuner_base (name, fMass, fInitialDragCoeff, fDownforceModifier, fPercentSubmerged, vecCentreOfMassOffset, vecInertiaMultiplier, fDriveBiasFront, nInitialDriveGears, fInitialDriveForce, fDriveInertia, fClutchChangeRateScaleUpShift, fClutchChangeRateScaleDownShift, fInitialDriveMaxFlatVel, fBrakeForce, fBrakeBiasFront, fHandBrakeForce, fSteeringLock, fTractionCurveMax, fTractionCurveMin, fTractionCurveLateral, fTractionSpringDeltaMax, fLowSpeedTractionLossMult, fCamberStiffnesss, fTractionBiasFront, fTractionLossMult, fSuspensionForce, fSuspensionCompDamp, fSuspensionReboundDamp, fSuspensionUpperLimit, fSuspensionLowerLimit, fSuspensionRaise, fSuspensionBiasFront, fAntiRollBarForce, fAntiRollBarBiasFront, fRollCentreHeightFront, fRollCentreHeightRear, fCollisionDamageMult, fWeaponDamageMult, fDeformationDamageMult, fEngineDamageMult, fPetrolTankVolume, fOilVolume, fSeatOffsetDistX, fSeatOffsetDistY, fSeatOffsetDistZ, nMonetaryValue) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', 
        {
            display_name,
            new_handling_data["fMass"],
            new_handling_data["fInitialDragCoeff"],
            new_handling_data["fDownforceModifier"],
            new_handling_data["fPercentSubmerged"],
            new_handling_data["vecCentreOfMassOffset"],
            new_handling_data["vecInertiaMultiplier"],
            new_handling_data["fDriveBiasFront"],
            new_handling_data["nInitialDriveGears"],
            new_handling_data["fInitialDriveForce"],
            new_handling_data["fDriveInertia"],
            new_handling_data["fClutchChangeRateScaleUpShift"],
            new_handling_data["fClutchChangeRateScaleDownShift"],
            new_handling_data["fInitialDriveMaxFlatVel"],
            new_handling_data["fBrakeForce"],
            new_handling_data["fBrakeBiasFront"],
            new_handling_data["fHandBrakeForce"],
            new_handling_data["fSteeringLock"],
            new_handling_data["fTractionCurveMax"],
            new_handling_data["fTractionCurveMin"],
            new_handling_data["fTractionCurveLateral"],
            new_handling_data["fTractionSpringDeltaMax"],
            new_handling_data["fLowSpeedTractionLossMult"],
            new_handling_data["fCamberStiffnesss"],
            new_handling_data["fTractionBiasFront"],
            new_handling_data["fTractionLossMult"],
            new_handling_data["fSuspensionForce"],
            new_handling_data["fSuspensionCompDamp"],
            new_handling_data["fSuspensionReboundDamp"],
            new_handling_data["fSuspensionUpperLimit"],
            new_handling_data["fSuspensionLowerLimit"],
            new_handling_data["fSuspensionRaise"],
            new_handling_data["fSuspensionBiasFront"],
            new_handling_data["fAntiRollBarForce"],
            new_handling_data["fAntiRollBarBiasFront"],
            new_handling_data["fRollCentreHeightFront"],
            new_handling_data["fRollCentreHeightRear"],
            new_handling_data["fCollisionDamageMult"],
            new_handling_data["fWeaponDamageMult"],
            new_handling_data["fDeformationDamageMult"],
            new_handling_data["fEngineDamageMult"],
            new_handling_data["fPetrolTankVolume"],
            new_handling_data["fOilVolume"],
            new_handling_data["fSeatOffsetDistX"],
            new_handling_data["fSeatOffsetDistY"],
            new_handling_data["fSeatOffsetDistZ"],
            new_handling_data["nMonetaryValue"]
        })
    cb(result)
end)

RegisterNetEvent('v-tuner:server:SpawnVehicle', function(vehicle_name)
    local src = source
    if not HasPermission(src) then
        return
    end
    local ped, bucket = GetPlayerPed(src), GetPlayerRoutingBucket(src)

    local _, vehicle = qbx.spawnVehicle({
        model = vehicle_name,
        spawnSource = ped,
        warp = true,
        bucket = bucket
    })
    local plate = qbx.getVehiclePlate(vehicle)
    exports.qbx_vehiclekeys:GiveKeys(src, vehicle)

end)


QBCore.Functions.CreateCallback('v-tuner:deleteBaseHandling', function(source, cb, display_name)
	local result = MySQL.update.await('DELETE FROM v_tuner_base WHERE name = ?', { display_name })
    cb(result)
end)

QBCore.Functions.CreateCallback('v-tuner:UpdateBaseHandling', function(source, cb, display_name, field, value)
	local result = MySQL.update('UPDATE v_tuner_base SET '..field..' = ? WHERE name = ?', { value, display_name })
    cb(result)
end)