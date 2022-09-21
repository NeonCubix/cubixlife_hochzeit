CubixLife = nil

TriggerEvent('CubixLife:getCubixSharedLifeObject', function(obj) CubixLife = obj end)

RegisterServerEvent('CubixLife_hochzeit:heiraten')
AddEventHandler('CubixLife_hochzeit:heiraten', function(pClosestPlayer, pNachname)
	local _source = source
	local EhePartnerEins = _source
	local EhePartnerZwei = pClosestPlayer
	local EhePartnerEinsName
	local EhePartnerZweiName
	local NeuerNachname = pNachname

	GetRPName(EhePartnerEins, function(pFirstname, pLastname)
		EhePartnerEinsName = {firstname = pFirstname, lastname = pLastname}
	end)
		
	GetRPName(EhePartnerZwei, function(pFirstname, pLastname)
		EhePartnerZweiName = {firstname = pFirstname, lastname = pLastname}
	end)
	
	while (EhePartnerEinsName == nil) do
		Citizen.Wait(0)
	end

	SetLastName(EhePartnerEins, NeuerNachname)
	SetLastName(EhePartnerZwei, NeuerNachname)
	TriggerClientEvent('fijhdsifujsif:iujshdfiuohsfduf', -1, 'Hochzeit', EhePartnerEinsName.firstname.." und "..EhePartnerZweiName.firstname.." haben Geheiratet und nehmen den Namen "..NeuerNachname.." an! Glückwunsch an euch Zwei!", 14000)
end)

function GetRPName(playerId, data)
	local Identifier = CubixLife.GetPlayerFromId(playerId).identifier
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		data(result[1].firstname, result[1].lastname)
	end)
end

function SetLastName(playerId, lastName)
	local identifier = CubixLife.GetPlayerFromId(playerId).identifier
	MySQL.Async.execute('UPDATE `users` SET `lastname` = @lastname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@lastname']		= lastName
	})
end

CubixLife.RegisterServerCallback('GetRPName', function(src, cb, pClosestPlayer)
	local Identifier = CubixLife.GetPlayerFromId(pClosestPlayer).identifier
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb(result[1].firstname.." "..result[1].lastname)
	end)
end)

CubixLife.RegisterServerCallback('GetRPFirstName', function(src, cb, pClosestPlayer)
	local Identifier = CubixLife.GetPlayerFromId(pClosestPlayer).identifier
	MySQL.Async.fetchAll("SELECT firstname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb(result[1].firstname)
	end)
end)

CubixLife.RegisterServerCallback('GetRPLastName', function(src, cb, pClosestPlayer)
	local Identifier = CubixLife.GetPlayerFromId(pClosestPlayer).identifier
	MySQL.Async.fetchAll("SELECT lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb(result[1].lastname)
	end)
end)

CubixLife.RegisterServerCallback('GetRPLastNames', function(source, cb, pSecond)
	local first
	local second
	local IdentifierFirst = CubixLife.GetPlayerFromId(source).identifier
	local IdentifierSecond = CubixLife.GetPlayerFromId(pSecond).identifier
	MySQL.Async.fetchAll("SELECT lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = IdentifierFirst }, function(result)
		first = result[1].lastname
	end)
	
	MySQL.Async.fetchAll("SELECT lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = IdentifierSecond }, function(result)
		second = result[1].lastname
	end)
	while (second == nil) do
		Citizen.Wait(0)
	end

	cb({first = first, second = second})
end)