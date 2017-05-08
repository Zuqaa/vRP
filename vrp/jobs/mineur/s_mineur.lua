require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "1234")

RegisterServerEvent('CheckCuivre')
AddEventHandler('CheckCuivre', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)

          local player = user.identifier
          --print(player)
              -- Pay the shop (price)
          user:removeMoney(tonumber(1))
        -- Save this shit to the database
        MySQL:executeQuery("UPDATE users SET cuivre = cuivre+1 WHERE identifier = '@username'",{['@username'] = player})
end)
end)


RegisterServerEvent('CheckMinerais')
AddEventHandler('CheckMinerais', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)

          local player = user.identifier
          --print(player)
              -- Pay the shop (price)
          user:removeMoney(tonumber(1))
        -- Save this shit to the database
        MySQL:executeQuery("UPDATE users SET cuivre = cuivre-1 WHERE identifier = '@username'",{['@username'] = player})
        MySQL:executeQuery("UPDATE users SET minerais = minerais+1 WHERE identifier = '@username'",{['@username'] = player})
end)
end)


RegisterServerEvent('CheckMineraisVendu')
AddEventHandler('CheckMineraisVendu', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)

          local player = user.identifier
          --print(player)
              -- Pay the shop (price)
          --user:removeMoney(tonumber(1))
        -- Save this shit to the database
        MySQL:executeQuery("UPDATE users SET minerais = minerais-1 WHERE identifier = '@username'",{['@username'] = player})
        user:addMoney((600))
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Tu as reçu ~g~600 $")

end)
end)


RegisterServerEvent('MyInventaire')
  AddEventHandler('MyInventaire', function()
      TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local nbcuivre = MySQL:executeQuery("SELECT cuivre FROM users WHERE identifier = '@username'",{['@username'] = player})
      local result = MySQL:getResults(nbcuivre, {'cuivre'})
      print(tonumber(result[1].cuivre))
      local nbminerais = MySQL:executeQuery("SELECT minerais FROM users WHERE identifier = '@username'",{['@username'] = player})
      local result2 = MySQL:getResults(nbminerais, {'minerais'})
      print(tonumber(result2[1].minerais))
      local hours = 16
      TriggerClientEvent('MyInventaireClient', source, tonumber(result[1].cuivre), tonumber(result2[1].minerais), hours)
  end)
end)