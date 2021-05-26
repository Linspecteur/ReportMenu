local reportlist = {}
local TGSE = TriggerServerEvent

local function getInfoReport()
    local info = {}
    ESX.TriggerServerCallback('dReport:infoReport', function(info)
        reportlist = info
    end)
end

local reportMenu = false
RMenu.Add('dReport', 'main', RageUI.CreateMenu('Menu Signalement', 'Votre signalement'))
RMenu.Add('dReport', 'info', RageUI.CreateSubMenu(RMenu:Get("dReport", "main"), 'Menu Signalement', 'Info Signalement'))
RMenu:Get('dReport', 'main'):SetRectangleBanner(178,13,13)
RMenu:Get('dReport', 'info'):SetRectangleBanner(178,13,13)
RMenu:Get('dReport', 'main').Closed = function()
    reportMenu = false
end

local function openMenuReport()
    if reportMenu then
        reportMenu = false
    else
        reportMenu = true
        defESX()
        getInfoReport()
        RageUI.Visible(RMenu:Get('dReport', 'main'), true)
        Citizen.CreateThread(function()
            while reportMenu do
                Wait(1)

                RageUI.IsVisible(RMenu:Get('dReport', 'main'), true, true, true, function()

                    if #reportlist >= 1 then
                        RageUI.Separator("↓ Nouveaux Signalement ↓")

                        for k,v in pairs(reportlist) do
                            RageUI.ButtonWithStyle(k.." - Signalement de  ~r~"..v.nom.."~s~  | Id :  ~p~"..v.id.."~s~ ", nil, {RightLabel = "→→"},true , function(_,_,s)
                                if s then
                                    nom = v.nom
                                    nbreport = k
                                    id = v.id
                                    raison = v.args
                                end
                            end, RMenu:Get("dReport", "info"))
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun Signalement~s~")
                        RageUI.Separator("~1~( /report + raison )~s~")
                        RageUI.Separator("")
                    end
                    
                end, function()end)

                RageUI.IsVisible(RMenu:Get('dReport', 'info'), true, true, true, function()
                    RageUI.Separator("")
                    RageUI.Separator("Signalement numéro : ~r~"..nbreport)
                    RageUI.Separator("Auteur : ~r~"..nom.."~s~ [ ~p~"..id.."~s~ ]")
                    RageUI.Separator("Raison du signalement : ~r~"..raison)
                    RageUI.Separator("")

                    RageUI.ButtonWithStyle("Se téléporter sur ~r~"..nom, nil, {RightLabel = "→→"}, true, function(_,_,s)
                        if s then
                            setpsurlemec(id)
                        end
                    end)

                    RageUI.ButtonWithStyle("Téléporter ~r~"..nom.."~s~ sur moi", nil, {RightLabel = "→→"}, true, function(_,_,s)
                        if s then
                            tplemecsurmoi(id)
                        end
                    end)

                    RageUI.ButtonWithStyle("Répondre au report", nil, {RightLabel = "→→"}, true, function(_, _, s)
                        if s then 
                            local reponse = KeyboardInput('~c~Entrez le message ici :', nil, 30)
                            local reponseReport = GetOnscreenKeyboardResult(reponse)
                            if reponseReport == "" then
                                Notification("~r~Admin\n~r~Vous n'avez pas fourni de message")
                            else
                                if reponseReport then
                                    Notification("Le message : ~b~"..reponseReport.."~s~ a été envoyer à ~r~"..GetPlayerName(GetPlayerFromServerId(id))) 
                                    TGSE("dReport:message", id, "~r~Staff~s~\n"..reponseReport)
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Fermer le report de ~r~"..nom, nil, {RightLabel = "→→"}, true, function(_,_,s)
                        if s then
                            TGSE('dReport:CloseReport', nom, raison)
                            TGSE("dReport:message", id, "~r~Staff~s~\nVotre report à été fermé !")
                            RageUI.CloseAll()
                            reportMenu = false
                        end
                    end)
                    
                end, function()end)

            end
        end)
    end
end

Keys.Register('F11', '-openReportMenu', 'Ouverture du Menu Signalement', function()
    ESX.TriggerServerCallback('dReport:getUsergroup', function(group)
        if group == 'superadmin' or group == 'admin' or group == 'mod' then
            if reportMenu == false then
                openMenuReport()
            end
        end
    end) 
end)