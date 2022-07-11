ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('xAdmin:wipe')
AddEventHandler('xAdmin:wipe', function(player)
    local xPlayer = ESX.GetPlayerFromId(player)

    MySQL.Async.execute(
        'DELETE FROM users WHERE identifier = @identifier',
        { ['@identifier'] = xPlayer.identifier }
	)
    MySQL.Async.execute(
        'DELETE FROM user_accounts WHERE identifier = @identifier',
        { ['@identifier'] = xPlayer.identifier }
	)
    MySQL.Async.execute(
        'DELETE FROM user_inventory WHERE identifier = @identifier',
        { ['@identifier'] = xPlayer.identifier }
	)
    MySQL.Async.execute(
      'DELETE FROM user_sim WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )
    MySQL.Async.execute(
      'DELETE FROM owned_vehicles WHERE owner = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )
    MySQL.Async.execute(
      'DELETE FROM owned_properties WHERE owner = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM billing WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM phone_users_contacts WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM player_clothe WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM user_licenses WHERE owner = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM user_accessories WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM properties_access WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM	twitter_accounts WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM	twitter_tweets WHERE realUser = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM user_parkings WHERE identifier = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    MySQL.Async.execute(
      'DELETE FROM yellowpages_posts WHERE realUser = @identifier',
      { ['@identifier'] = xPlayer.identifier }
    )

    DropPlayer(player, "Tu as été wipe !")
end)