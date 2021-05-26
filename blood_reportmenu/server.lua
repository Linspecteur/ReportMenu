ESX = nil
local reportTable = {}
print('[^1Author^0]: Linspecteur#9273')

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('dReport:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
end)

RegisterCommand('report', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
    local NomDuMec = xPlayer.getName()
    local idDuMec = source
    local RaisonDuMec = table.concat(args, " ")
    if #RaisonDuMec <= 1 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison valable.")
    elseif #RaisonDuMec >= 20 then
        TriggerClientEvent("esx:showNotification", source, "~r~Veuillez rentrer une raison moins longue.")
    else
        TriggerClientEvent("esx:showNotification", source, "~g~Votre report à bien été envoyer à l'équipe de modération.")
        TriggerClientEvent("dReport:Open/CloseReport", -1, 1)
        table.insert(reportTable, {
            id = idDuMec,
            nom = NomDuMec,
            args = RaisonDuMec,
        })
    end
end, false)

RegisterServerEvent("dReport:CloseReport")
AddEventHandler("dReport:CloseReport", function(nomMec, raisonMec)
    TriggerClientEvent("dReport:Open/CloseReport", -1, 2, nomMec, raisonMec)
    table.remove(reportTable, id, nom, args)
end)

ESX.RegisterServerCallback('dReport:infoReport', function(source, cb)
    cb(reportTable)
end)

RegisterServerEvent("dReport:bring")
AddEventHandler("dReport:bring",function(IdDuMec, plyPedCoords, lequel)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "helper" or xPlayer.getGroup() == "superadmin" then
        if lequel == "bring" then
            TriggerClientEvent("dReport:bring", IdDuMec, plyPedCoords)
        else
            TriggerClientEvent("dReport:bring", plyPedCoords, IdDuMec)
        end
    else
        print('Tu ne peux pas faire ça (PERMISSION) !')
    end
end)

RegisterServerEvent("dReport:message")
AddEventHandler("dReport:message", function(onlyjoueurs, message)
    TriggerClientEvent("dReport:Notification", onlyjoueurs, message)
end)
