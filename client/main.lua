CubixLife = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		while CubixLife == nil do
			Citizen.Wait(10)
			TriggerEvent("CubixLife:getCubixSharedLifeObject", function(response)
				CubixLife = response
			end)
		end
	end
end)

Citizen.CreateThread(function()
	local hash = GetHashKey(Config.npc)
	while not HasModelLoaded(hash) do 
		RequestModel(hash)
		Citizen.Wait(20)
	end
	
	ped = CreatePed("PED_TYPE_CIVMALE", Config.npc, Config.npcPos.x, Config.npcPos.y, Config.npcPos.z - 1, Config.npcPos.a, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playercoords = GetEntityCoords(playerPed)
		local distance = Vdist(playercoords, Config.npcPos.x, Config.npcPos.y, Config.npcPos.z)
		if distance < 2 then 
			ShowHelp("Drücke ~INPUT_CONTEXT~ um zu Heiraten", true)
			if IsControlJustPressed(0, 38) then -- [E]
				CubixLife.UI.Menu.CloseAll()
		
				CubixLife.UI.Menu.Open('default', GetCurrentResourceName(), 'heiraten_actions', {
				title    = 'Heiraten',
				align    = 'top-left',
				elements = {
					{label = 'Heiraten', value = 'heiraten'},
					--{label = 'Scheiden', value = 'scheiden'},
				}}, function(data, menu)
								
					if data.current.value == 'heiraten' then

						CubixLife.UI.Menu.CloseAll()
						local closestPlayer, closestDistance = CubixLife.Game.GetClosestPlayer()
						
						if closestPlayer ~= -1 and closestDistance <= 3.0 then
							CubixLife.TriggerServerCallback('GetRPName', function(name)
								CubixLife.ShowNotification('Möchten sie '..name..' Heiraten?')
								CubixLife.UI.Menu.Open('default', GetCurrentResourceName(), 'heiraten_actions', {
								title    = 'Möchten sie '..name..' Heiraten?',
								align    = 'top-left',
								elements = {
									{label = 'Ja', value = 'ja'},
									{label = 'Nein', value = 'nein'},
								}}, function(data, menu)
									if data.current.value == 'ja' then
										local first 
										local second 
										CubixLife.UI.Menu.CloseAll()
										CubixLife.TriggerServerCallback('GetRPLastNames', function(cb)
											CubixLife.UI.Menu.Open('default', GetCurrentResourceName(), 'name_actions', {
											title    = 'Namenswahl',
											align    = 'top-left',
											elements = {
												{label = cb.first, value = 'first'},
												{label = cb.second, value = 'second'},
											}}, function(data, menu)
												if (cb.first == cb.second) then
													CubixLife.UI.Menu.CloseAll()
													CubixLife.ShowNotification('Du kannst niemanden mit dem gleichen Nachnamen Heiraten! Sweet Home Alabama! ')
												elseif data.current.value == 'first' then
													CubixLife.UI.Menu.CloseAll()
													TriggerServerEvent('CubixLife_hochzeit:heiraten', GetPlayerServerId(closestPlayer), cb.first)
												elseif data.current.value == 'second' then
													CubixLife.UI.Menu.CloseAll()
													TriggerServerEvent('CubixLife_hochzeit:heiraten', GetPlayerServerId(closestPlayer), cb.second)
												end	
											end,function(data, menu) 
												menu.close() 
											end)

										end, GetPlayerServerId(closestPlayer))
									elseif data.current.value == 'nein' then
										menu.close() 
									end	
								end,function(data, menu) 
									menu.close() 
								end)
							end, GetPlayerServerId(closestPlayer))
						else 
							CubixLife.ShowNotification('Es steht keiner neben dir!')
						end

					elseif data.current.value == 'scheiden' then
						CubixLife.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu1',
						{
							title = ('Scheiden')
						},
						function(data, menu)
									
						end,
						function(data, menu)
							menu.close()
						end)
					end	
				end,function(data, menu) 
					menu.close() 
				end)
			end 
		end
	end
end)

function ShowHelp(text, bleep)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, false, bleep, -1)
end