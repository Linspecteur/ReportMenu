ESX = nil

function defESX()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end

Citizen.CreateThread(function()
    defESX()
end)

function Notification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

RegisterNetEvent("dReport:Notification")
AddEventHandler("dReport:Notification", function(msg) 
	Notification(msg) 
end)

RegisterNetEvent("dReport:Open/CloseReport")
AddEventHandler("dReport:Open/CloseReport", function(type, nomdumec, raisondumec)
    if type == 1 then
        ESX.TriggerServerCallback('dReport:getUsergroup', function(group)
            if group == 'superadmin' or group == 'admin' or group == 'mod' then
                ESX.ShowNotification('Un nouveau report à été effectué !')
            end
        end)
    elseif type == 2 then
        ESX.TriggerServerCallback('dReport:getUsergroup', function(group)
            if group == 'superadmin' or group == 'admin' or group == 'mod' then
                ESX.ShowNotification('Le report de ~b~'..nomdumec..'~s~ à été fermé !')
            end
        end)
    end
end)

function setpsurlemec(iddumec) 
    if iddumec then
        local PlayerPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(iddumec)))
        SetEntityCoords(PlayerPedId(), PlayerPos.x, PlayerPos.y, PlayerPos.z)
    end
end

function tplemecsurmoi(iddugars)
    if iddugars then
        local plyPedCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('dReport:bring', iddugars, plyPedCoords, "bring")
    end
end

RegisterNetEvent('dReport:bring')
AddEventHandler('dReport:bring', function(plyPedCoords)
    plyPed = PlayerPedId()
	SetEntityCoords(plyPed, plyPedCoords)
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end