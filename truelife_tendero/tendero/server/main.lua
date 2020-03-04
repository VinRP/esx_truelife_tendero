ESX = nil

passanger1 = nil
passanger2 = nil
passanger3 = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('tendero:pay')
AddEventHandler('tendero:pay', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local payamount = math.ceil(amount)
	xPlayer.addMoney(tonumber(payamount))
	TriggerClientEvent('esx:showNotification', source, '~s~Recibiste~g~ '..payamount..' ~s~$ de esta parada~s~!')
end)

RegisterServerEvent('tendero:binselect')
AddEventHandler('tendero:binselect', function(binpos, platenumber, bagnumb)
	TriggerClientEvent('tendero:setbin', -1, binpos, platenumber,  bagnumb)
end)

RegisterServerEvent('tendero:requestpay')
AddEventHandler('tendero:requestpay', function(platenumber, amount)
	TriggerClientEvent('tendero:startpayrequest', -1, platenumber, amount)
end)

RegisterServerEvent('tendero:bagremoval')
AddEventHandler('tendero:bagremoval', function(platenumber)
	TriggerClientEvent('tendero:removedbag', -1, platenumber)

end)

RegisterServerEvent('tendero:endcollection')
AddEventHandler('tendero:endcollection', function(platenumber)
	TriggerClientEvent('tendero:clearjob', -1, platenumber)
end)

RegisterServerEvent('tendero:reportbags')
AddEventHandler('tendero:reportbags', function(platenumber)
	TriggerClientEvent('tendero:countbagtotal', -1, platenumber)
end)

RegisterServerEvent('tendero:bagsdone')
AddEventHandler('tendero:bagsdone', function(platenumber, bagstopay)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('tendero:addbags', -1, platenumber, bagstopay, xPlayer )
end)