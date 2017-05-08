local MineurCrimi = {
	opened = false,
	title = "Mineur",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 155, g = 155, b = 255, a = 200, type = 1 },
}

local MineurCrimi_locations = {
{enteringMineurCrimi = {474.3488,-1951.734,23.63132}, innutile4 = {474.3488,-1951.734,23.63132}, outsideMineurCrimi = {476.7798,-1970.316,24.64362}},
}

local MineurCrimi_blips ={}
local inrangeofMineurCrimi = false
local inrangeofMineurCrimi3 = false
local currentlocation = nil
local boughtcar = false

local function LocalPed()
return GetPlayerPed(-1)
end

function drawTxtMineurCrimi(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)	
end

function IsPlayerInRangeOfMineurCrimi()
return inrangeofMineurCrimi
end

function IsPlayerInRangeOfMineurCrimi3()
return inrangeofMineurCrimi3
end


function DrawMissionTextMineurCrimi(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

nbcuivrecrimi = 0
nbmineraiscrimi = 0
clocktime = 0

function ShowInfoMinerais(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

onCrimiMineur1 = 1
inrecoltMinerais = false
intraitosMinerais = false
inreventeMinerais = false
inrangeofchampsMinerais = false
inrangeoftraitosMinerais = false
inrangeofreventeMinerais = false

RegisterNetEvent('MyInventaireClient')
AddEventHandler('MyInventaireClient', function(param1,param2,hours)

    nbcuivrecrimi = param1
    nbmineraiscrimi = param2
    clocktime = hours
    clocktime = 16


end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if onCrimiMineur1 == 1 then
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2680.654296875,2817.6748046875,40.449901580811, true) > 20.0001 then
						inrangeofchampsMinerais = false
					elseif IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 2680.654296875,2817.6748046875,40.449901580811, true) < 20.0001 then
						inrangeofchampsMinerais = true
						if (inrecoltMinerais == false) then
						    ShowInfoMinerais("Appuyez sur ~INPUT_CONTEXT~ pour récolter.", 0)
						end
					    if (inrecoltMinerais == true) then
						    ShowInfoMinerais("Appuyez sur ~INPUT_CONTEXT~ pour ~r~arrêter~w~ de récolter.", 0)
						end
					end
					
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1735.5379638672,-1538.5463867188,112.70690155029, true) > 15.0001 then
						inrangeoftraitosMinerais = false
					elseif IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1735.5379638672,-1538.5463867188,112.70690155029, true) < 15.0001 then
						inrangeoftraitosMinerais = true
						if (intraitosMinerais == false) then
					        ShowInfoMinerais("Appuyez sur ~INPUT_CONTEXT~ pour traiter.", 0)
						end
					    if (intraitosMinerais == true) then
						    ShowInfoMinerais("Appuyez sur ~INPUT_CONTEXT~ pour ~r~arrêter~w~ de traiter.", 0)
						end
					end
					
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-98.597305297852,-1022.6029663086,27.273557662964, true) > 5.0001 then
						inrangeofreventeMinerais = false
					elseif IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -98.597305297852,-1022.6029663086,27.273557662964, true) < 5.0001 then
					    inrangeofreventeMinerais = true
					    if (inreventeMinerais == false) then
						    ShowInfoMinerais("Appuyez sur ~INPUT_CONTEXT~ pour vendre.", 0)
						end
					    if (inreventeMinerais == true) then
						    ShowInfoMinerais("Appuyez sur ~INPUT_CONTEXT~ pour ~r~arrêter~w~ de vendre.", 0)
						end
					end
		end
	end
end)
	
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
			if (inrecoltMinerais == true) then
			    if (inrangeofchampsMinerais == true) then
           		    if (tonumber(nbcuivrecrimi) >= 32) then
				    	DrawMissionTextMineurCrimi("~h~~r~Inventaire Complet", 10000)
				    	inrecoltMinerais = false
				    else
				        while (tonumber(nbcuivrecrimi) <= 31) and (inrecoltMinerais == true) and (inrangeofchampsMinerais == true) do
				        DrawMissionTextMineurCrimi("~h~~b~Récolte~w~ en cours...", 3000)
				    	Wait(3000)
				        DrawMissionTextMineurCrimi("~h~~g~+1~w~ Cuivre...", 1000)
				    	TriggerServerEvent('CheckCuivre')
					    Wait(1000)
					    TriggerServerEvent('MyInventaire')
					    Wait(1)
					    end
				    end
				else
				    inrecoltMinerais = false
				end
			
			end
			
			if (intraitosMinerais == true) then
			    if (inrangeoftraitosMinerais == true) then
				if ((clocktime>13) or (clocktime<2)) then
           		    if (tonumber(nbcuivrecrimi) <= 0) then
				    	DrawMissionTextMineurCrimi("~h~~g~Traitement terminé", 10000)
				    	intraitosMinerais = false
				    else
				        while (tonumber(nbcuivrecrimi) >= 2) and (intraitosMinerais == true) and (inrangeoftraitosMinerais == true) do
				        DrawMissionTextMineurCrimi("~h~~b~Traitement~w~ en cours...", 3000)
				    	Wait(3000)
				        DrawMissionTextMineurCrimi("~h~~g~+1~w~ Minerais...", 1000)
				    	TriggerServerEvent('CheckMinerais')
					    Wait(1000)
					    TriggerServerEvent('MyInventaire')
					    Wait(1)
					    end
				    end
				end
				else
				    intraitosMinerais = false
				end
			
			end
			
			if (inreventeMinerais == true) then
			    if (inrangeofreventeMinerais == true) then
				
           		    if (tonumber(nbmineraiscrimi) <= 0) then
				    	DrawMissionTextMineurCrimi("~h~~g~Revente terminée", 10000)
				    	inreventeMinerais = false
				    else
				        while (tonumber(nbmineraiscrimi) >= 2) and (inreventeMinerais == true) and (inrangeofreventeMinerais == true) do
				        DrawMissionTextMineurCrimi("~h~~b~Revente~w~ en cours...", 3000)
				    	Wait(3000)
				        DrawMissionTextMineurCrimi("~h~Vous avez vendu ~g~1 Minerais~w~...", 1000)
				    	TriggerServerEvent('CheckMineraisVendu')
					    Wait(1000)
					    TriggerServerEvent('MyInventaire')
					    Wait(1)
						end
				    end
					
				else
				    inreventeMinerais = false
				end
			
			end
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 38) and (inrangeofchampsMinerais == true) and (inrecoltMinerais == false) then
           TriggerServerEvent('MyInventaire')
		   inrecoltMinerais = true
        elseif IsControlJustPressed(1, 38) and (inrangeofchampsMinerais == true) and (inrecoltMinerais == true) then
           TriggerServerEvent('MyInventaire')
		   inrecoltMinerais = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 38) and (inrangeoftraitosMinerais == true) and (intraitosMinerais == false) then
           TriggerServerEvent('MyInventaire')
		   intraitosMinerais = true
        elseif IsControlJustPressed(1, 38) and (inrangeoftraitosMinerais == true) and (intraitosMinerais == true) then
           TriggerServerEvent('MyInventaire')
		   intraitosMinerais = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 38) and (inrangeofreventeMinerais == true) and (inreventeMinerais == false) then
           TriggerServerEvent('MyInventaire')
		   inreventeMinerais = true
        elseif IsControlJustPressed(1, 38) and (inrangeofreventeMinerais == true) and (inreventeMinerais == true) then
           TriggerServerEvent('MyInventaire')
		   inreventeMinerais = false
        end
    end
end)

--Citizen.CreateThread(function()
--    while true do
--        Citizen.Wait(0)
--        if IsControlJustPressed(1, 38) then
--			TriggerServerEvent('MyInvCrimi')
--            DrawMissionTextCannaCrimi("coucou " .. tonumber(nbcannacrimi) .. tonumber(nbchanvrecrimi), 10000)
--		end
--    end
--end)



local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	firstspawn = 1
end
end)