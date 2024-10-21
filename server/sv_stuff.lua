local QBCore = exports['qb-core']:GetCoreObject()

function HasPermission(source)
    local Player = QBCore.Functions.GetPlayer(source)
    local cid = Player.PlayerData.citizenid
    local devs = {}
    local dev = false
    for i, v in ipairs(devs) do
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


QBCore.Commands.Add("vehdebug", "Enable Vehicle Debugger", {}, false, function(source)
    local src = source
    if HasPermission(src) == true then
        TriggerClientEvent('vehicleDebug:client:toggleDebug', src)
    end
end)

QBCore.Commands.Add('devcar', "spawn a car", {{ name = "model", help = "Car model name." }}, true, function(source, args)
    local src = source
    if HasPermission(src) == true then
        TriggerClientEvent('QBCore:Command:SpawnVehicle', src, args[1])
    end
end)