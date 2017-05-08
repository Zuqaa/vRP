local Mineur1 = {
	opened = false,
	title = "Patron Mineur",
	currentmenu = "main2",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.20,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main2"] = { 
			title = "", 
			name = "main2",
			buttons = { 
				-- {name = "Je viens récupérer un colis", description = ""},
				{name = "Je voudrais récolter..", description = ""},
			}
		},
		["menucolis"] = { 
			title = "", 
			name = "menucolis",
			buttons = { 
				{name = "Pour moi uniquement.", costs = 0, description = {}, model = ""},
				{name = "Pour me faire un peu de sous.", costs = 0, description = {}, model = ""},
			}
		},
		["menurecolte"] = { 
			title = "", 
			name = "menurecolte",
			buttons = { 
				{name = "Je veux bien", costs = 0, description = {}, model = ""},
				{name = "Je veux plus.. Désolé", costs = 0, description = {}, model = ""},
			}
		},
		["menurecolte2"] = { 
			title = "", 
			name = "menurecolte2",
			buttons = {
				{name = "J'veux récolter (GRATUIT)", costs = 0, description = {}, model = ""},
				{name = "J'veux traiter (GRATUIT)", costs = 0, description = {}, model = ""},
				{name = "J'veux revendre (GRATUIT)", costs = 0, description = {}, model = ""},
			}
		},
	}
}
local fakecar = {model = '', car = nil}
local Mineur1_locations = {
{insideMineur = {473.58016967773,-1951.9986572266,23.600}},
}

function DrawMissionTextMineur1(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

local Mineur1_blips ={}
local inrangeofMineur1 = false
local currentlocation = nil
local boughtcloth = false

local function LocalPed()
return GetPlayerPed(-1)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
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

function IsPlayerInRangeOfMineur1()
return inrangeofMineur1
end


function ShowInfoMineur1(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function ShowMineur1Blips(bool)
	if bool and #Mineur1_blips == 0 then
		for station,pos in pairs(Mineur1_locations) do
			local loc = pos
			pos = pos.insideMineur
			local blip = AddBlipForCoord(462.07711791992,-1944.4996337891,23.600)
			SetBlipSprite(blip,416)
			SetBlipColour(blip, 6)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Mineur Mission')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(Mineur1_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #Mineur1_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(Mineur1_blips) do
					if  Mineur1.opened == false and  GetDistanceBetweenCoords(b.pos.insideMineur[1],b.pos.insideMineur[2],b.pos.insideMineur[3],GetEntityCoords(LocalPed()),true) > 0 then
						DrawMarker(1,b.pos.insideMineur[1],b.pos.insideMineur[2],b.pos.insideMineur[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0)
						currentlocation = b
						if GetDistanceBetweenCoords(b.pos.insideMineur[1],b.pos.insideMineur[2],b.pos.insideMineur[3],GetEntityCoords(LocalPed()),true) < 4 then
						ShowInfoJob("Appuyez sur ~INPUT_CONTEXT~ pour parler avec le ~b~Patron", 0)
						inrange = true
						end
					end
				end
				inrangeofMineur1 = inrange
			end
		end)
	elseif bool == false and #Mineur1_blips > 0 then
		for i,b in ipairs(Mineur1_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		Mineur1_blips = {}
	end
end

function fi(n)
return n + 0.0001
end

function LocalPed()
return GetPlayerPed(-1)
end

function ShowInfoJob(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function trycloth(fi, catch_f)
local status, exception = pcall(fi)
if not status then
catch_f(exception)
end
end
function firstToUpperCloth(str)
    return (str:gsub("^%l", string.upper))
end
--local veh = nil
function OpenCreatorMineur1()		
	boughtcloth = false
	local ped = LocalPed()
	local pos = currentlocation.pos.insideMineur
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	Mineur1.currentmenu = "main2"
	Mineur1.opened = true
	Mineur1.selectedbutton = 0
end
local cloth_price = 0
function CloseCreatorMineur1()
	Citizen.CreateThread(function()
		local ped = LocalPed()
		if not boughtcloth then
			local pos = currentlocation.pos.insideMineur
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local model = GetEntityModel(cloth)

			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(cloth))
			local pos = currentlocation.pos.insideMineur

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			SetModelAsNoLongerNeeded(model)
			SetClothHasBeenOwnedByPlayer(skin,true)
			local id = NetworkGetNetworkIdFromEntity(skin)
			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(skin))
			SetEntityVisible(ped,true)
			FreezeEntityPosition(ped,false)		
		end
		Mineur1.opened = false
		Mineur1.menu.from = 1
		Mineur1.menu.to = 10
	end)
end
	
function drawMenuButton(button,x,y,selected)
	local menu = Mineur1.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
end

function drawMenuInfo(text)
	local menu = Mineur1.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)	
end

function drawMenuRight(txt,x,y,selected)
	local menu = Mineur1.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)	
end

function drawMenuTitleMineur(txt,x,y)
local menu = Mineur1.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function NotifyMineur1(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function DoesPlayerHaveMineur(model,button,y,selected)
		local t = false
		--TODO:check if player own car
		if t then
			drawMenuRight("OWNED",Mineur1.menu.x,y,selected)
		else
			drawMenuRight(button.costs.."€",Mineur1.menu.x,y,selected)
		end
end

local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,38) and IsPlayerInRangeOfMineur1() then
			if Mineur1.opened then
				CloseCreatorMineur1()
			else
			    if (clientjobID ~= 10) then
				OpenCreatorMineur1()
				DrawMissionTextMineur1("~h~~g~Patron~w~ : Bonjour !", 1000)
				Wait(1000)
				DrawMissionTextMineur1("~h~~g~Patron~w~ : Qu'est-ce que je peux faire pour toi ?", 10000)
				else
					DrawMissionTextMineur1("~h~~g~Patron~w~ : Désolé, je ne peux rien pour toi.", 10000)
				end
			end
		end
		if Mineur1.opened then
			local ped = LocalPed()
			local menu = Mineur1.menu[Mineur1.currentmenu]
			drawTxt(Mineur1.title,1,1,Mineur1.menu.x,Mineur1.menu.y,1.0, 255,255,255,255)
			drawMenuTitleMineur(menu.title, Mineur1.menu.x,Mineur1.menu.y + 0.08)
			drawTxt(Mineur1.selectedbutton.."/"..tablelength(menu.buttons),0,0,Mineur1.menu.x + Mineur1.menu.width/2 - 0.0385,Mineur1.menu.y + 0.067,0.4, 255,255,255,255)
			local y = Mineur1.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			
			for i,button in pairs(menu.buttons) do
				if i >= Mineur1.menu.from and i <= Mineur1.menu.to then
					
					if i == Mineur1.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,Mineur1.menu.x,y,selected)
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelectedMineur1(button)
					end
				end
			end	
		end
		if Mineur1.opened then
			if IsControlJustPressed(1,202) then
				BackMineur()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if Mineur1.selectedbutton > 1 then
					Mineur1.selectedbutton = Mineur1.selectedbutton -1
					if buttoncount > 10 and Mineur1.selectedbutton < Mineur1.menu.from then
						Mineur1.menu.from = Mineur1.menu.from -1
						Mineur1.menu.to = Mineur1.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if Mineur1.selectedbutton < buttoncount then
					Mineur1.selectedbutton = Mineur1.selectedbutton +1
					if buttoncount > 10 and Mineur1.selectedbutton > Mineur1.menu.to then
						Mineur1.menu.to = Mineur1.menu.to + 1
						Mineur1.menu.from = Mineur1.menu.from + 1
					end
				end	
			end
		end
		
	end
end)


function roundMineur1(num1, idp2)
  if idp2 and idp2>0 then
    local mult = 10^idp2
    return math.floor(num1 * mult + 0.5) / mult
  end
  return math.floor(num1 + 0.5)
end
function ButtonSelectedMineur1(button)
	local ped = GetPlayerPed(-1)
	local this = Mineur1.currentmenu
	local btn = button.name
	if this == "main2" then
		if btn == "Je viens récupérer un colis" then
			OpenMenuMineur('menucolis')
			DrawMissionTextMineur1(m_text, 10000)
		elseif btn == "Je voudrais récolter.." then
			OpenMenuMineur('menurecolte')
			DrawMissionTextMineur1("~h~~g~Patron~w~ : Oui j'ai un truc pour toi.", 10000)
		end
	-- elseif this == "menucolis" then
		-- if btn == "Je viens récupérer un colis" then
			-- OpenMenuWeed('menucolis')
		-- elseif btn == "T'as pas une info pour moi ?" then
			-- OpenMenuWeed('menurecolte')
		-- end
	elseif this == "menurecolte" then
		if btn == "Je veux bien" then
			OpenMenuMineur('menurecolte2')
			DrawMissionTextMineur1("~h~~g~Patron~w~ : Bah écoutes man, moi je connais la Sainte fougère..", 10000)
		elseif btn == "Je veux plus.. Désolé" then
			CloseCreatorMineur1()
		end
	elseif this == "menurecolte2" then
		if btn == "J'veux récolter (GRATUIT)" then
			TriggerServerEvent('CheckMineur1PointRecolte', 0)
			DrawMissionTextMineur1("~h~~g~Patron~w~ : Va chercher le cuivre !", 20000)
		elseif btn == "J'veux traiter (GRATUIT)" then
			TriggerServerEvent('CheckMineur1PointTraitos', 0)
			DrawMissionTextMineur1("~h~~g~Patron~w~ : Tu peux désormais traiter ton cuivre!", 20000)
		elseif btn == "J'veux revendre (GRATUIT)" then
			TriggerServerEvent('CheckMineur1PointRevente', 0)
			DrawMissionTextMineur1("~h~~g~Patron~w~ : Tu peux aller revendre tes minerais au SUD !", 20000)
		end
	end
end

patronchamps = nil
patrontraitos = nil
patronrevente = nil

RegisterNetEvent('PatronNoMoney')
AddEventHandler('PatronMoney', function()
   DrawMissionTextMineur1("~h~~g~Patron~w~ : Désolé, on pas de charité ici!", 10000)	
end)

RegisterNetEvent('GoToMineraisChamps')
AddEventHandler('GoToMineraisChamps', function()
   patronchamps = 1	
end)

RegisterNetEvent('GoToMineraisTraitos')
AddEventHandler('GoToMineraisTraitos', function()
   patrontraitos = 1	
end)

RegisterNetEvent('GoToMineraisRevente')
AddEventHandler('GoToMineraisRevente', function()
   patronrevente = 1	
end)

function StopPatron()
		if MineraisChamps ~= nil and DoesBlipExist(MineraisChamps) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineraisChamps))
			MineraisChamps = nil
		end
		if MineraisTraitos ~= nil and DoesBlipExist(MineraisTraitos) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineraisTraitos))
			MineraisTraitos = nil
		end
		if MineraisRevente ~= nil and DoesBlipExist(MineraisRevente) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(MineraisRevente))
			MineraisRevente = nil
		end
		patronchamps = nil
		patrontraitos = nil
		patronrevente = nil
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if (patronchamps == 1) then
			MineraisChamps = AddBlipForCoord(2680.654296875,2817.6748046875,40.449901580811)
			SetBlipSprite(MineraisChamps,416)
			SetBlipColour(MineraisChamps, 1)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Terrain de Cuivre')
			EndTextCommandSetBlipName(MineraisChamps)
			Wait(3600000)
			patronchamps = 2
		end
		if (patronchamps == 2) then
		    StopPatron()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if (patrontraitos == 1) then
			MineraisTraitos = AddBlipForCoord(1735.5379638672,-1538.5463867188,112.70690155029)
			SetBlipSprite(MineraisTraitos,416)
			SetBlipColour(MineraisTraitos, 2)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Traitement Cuivre')
			EndTextCommandSetBlipName(MineraisTraitos)
			Wait(3600000)
			patrontraitos = 2
		end
		if (patrontraitos == 2) then
		    StopPatron()
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if (patronrevente == 1) then
			MineraisRevente = AddBlipForCoord(-98.597305297852,-1022.6029663086,27.273557662964)
			SetBlipSprite(MineraisRevente,416)
			SetBlipColour(MineraisRevente, 3)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Revente Minerais')
			EndTextCommandSetBlipName(MineraisRevente)
			Wait(3600000)
			patronrevente = 2
		end
		if (patronrevente == 2) then
		    StopPatron()
		end
	end
end)

RegisterNetEvent('FinishCheckMineur1')
AddEventHandler('FinishCheckMineur1', function()
	boughtcloth = true
	CloseCreatorMineur1()
	Mineur1.opened = false
	Mineur1.menu.from = 1
	Mineur1.menu.to = 10
	
end)

function OpenMenuMineur(menu)
	Mineur1.lastmenu = Mineur1.currentmenu
	if menu == "menucolis" then
		Mineur1.lastmenu = "main2"
	elseif menu == "menurecolte"  then
		Mineur1.lastmenu = "main2"
	elseif menu == 'menurecolte' then
		Mineur1.lastmenu = "main2"
	elseif menu == "race_create_objects_spawn" then
		Mineur1.lastmenu = "race_create_objects"
	end
	Mineur1.menu.from = 1
	Mineur1.menu.to = 10
	Mineur1.selectedbutton = 0
	Mineur1.currentmenu = menu	
end


function BackMineur()
	if backlock then
		return
	end
	backlock = true
	if Mineur1.currentmenu == "main2" then
	    
		DrawMissionTextMineur1("~h~~g~Patron~w~ : Avant de partir prend ton camion a coté !", 5000)
		CloseCreatorMineur1()
	elseif Mineur1.currentmenu == "menucolis" or Mineur1.currentmenu == "menurecolte" or Mineur1.currentmenu == "menurecolte2" then
		fakecar = {model = '', car = nil}
		OpenMenuMineur(Mineur1.lastmenu)
	else
		OpenMenuMineur(Mineur1.lastmenu)
	end
	
end

function stringstartsMineur(String1,Start2)
   return string.sub(String1,1,string.len(Start2))==Start2
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	ShowMineur1Blips(true)
	firstspawn = 1
end
end)