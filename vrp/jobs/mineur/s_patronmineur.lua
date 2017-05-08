RegisterServerEvent('CheckMineur1PointRecolte')
AddEventHandler('CheckMineur1PointRecolte', function(price)
	TriggerEvent('es:getPlayerFromId', source, function(user)

	if (tonumber(user.money) >= tonumber(price)) then
    local player = user.identifier
    print(player)
			-- Pay the shop (price)
			user:removeMoney((price))
      -- Save this shit to the database
            -- Trigger some client stuff
      TriggerClientEvent('GoToMineraisChamps',source)
    else
      -- Inform the player that he needs more money
      TriggerClientEvent('PatronNoMoney',source)
	end
end)
end)

RegisterServerEvent('CheckMineur1PointTraitos')
AddEventHandler('CheckMineur1PointTraitos', function(price)
  TriggerEvent('es:getPlayerFromId', source, function(user)

  if (tonumber(user.money) >= tonumber(price)) then
    local player = user.identifier
    print(player)
      -- Pay the shop (price)
      user:removeMoney((price))
      -- Save this shit to the database
            -- Trigger some client stuff
      TriggerClientEvent('GoToMineraisTraitos',source)
    else
      -- Inform the player that he needs more money
            TriggerClientEvent('PatronNoMoney',source)

    TriggerClientEvent('GoToMineraisTraitos',0)

  end
end)
end)

RegisterServerEvent('CheckMineur1PointRevente')
AddEventHandler('CheckMineur1PointRevente', function(price)
  TriggerEvent('es:getPlayerFromId', source, function(user)

  if (tonumber(user.money) >= tonumber(price)) then
    local player = user.identifier
    print(player)
      -- Pay the shop (price)
      user:removeMoney((price))
      -- Save this shit to the database
            -- Trigger some client stuff
      TriggerClientEvent('GoToMineraisRevente',source)
    else
      -- Inform the player that he needs more money
            TriggerClientEvent('PatronNoMoney',source)

    TriggerClientEvent('GoToMineraisRevente',0)

  end
end)
end)