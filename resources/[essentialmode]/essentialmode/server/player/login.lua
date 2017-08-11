-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function LoadUser(identifier, source, new)
	local Source = source
	db.retrieveUser(identifier, function(user)
		Users[source] = CreatePlayer(source, user.permission_level, user.money, user.bank, user.identifier, user.group)
		
		TriggerEvent('es:playerLoaded', Source, Users[Source])

		log('User (' .. GetPlayerName(Source) .. ') loaded')

		TriggerClientEvent('es:setPlayerDecorator', Source, 'rank', Users[Source]:getPermissions())
		TriggerClientEvent('es:setMoneyIcon', Source,settings.defaultSettings.moneyIcon)

		for k,v in pairs(commandSuggestions) do
			TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
		end

		if(new)then
			TriggerEvent('es:newPlayerLoaded', Source, Users[Source])
		end
	end)
end

function getPlayerFromId(id)
	print("Test: " .. type(id) .. " | " .. id)
	return Users[id]
end

AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

function registerUser(identifier, source)
	local Source = source
	db.doesUserExist(identifier, function(exists)
		if exists then
			LoadUser(identifier, Source, false)
		else
			db.createUser(identifier, function(r, user)
				LoadUser(identifier, Source, true)
			end)
		end
	end)
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
	if(Users[user])then
		if(Users[user].get(k))then
			if(k ~= "money") then
				Users[user].set(k, v)

				db.updateUser(Users[user].get('identifier'), {[k] = v}, function(d)
					if d == true then
						cb("Player data edited", true)
					else
						cb(d, false)
					end
				end)
			end

			if(k == "group")then
				Users[user].set(k, v)
			end
		else
			cb("Column does not exist!", false)
		end
	else
		cb("User could not be found!", false)
	end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	db.updateUser(user, {[k] = v}, function(d)
		cb("Player data edited.", true)
	end)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	db.retrieveUser(identifier, function(user)
		cb(user)
	end)
end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
	SetTimeout(60000, function()
		for k,v in pairs(Users)do
			if Users[k] ~= nil then
				db.updateUser(v.get('identifier'), {money = v.getMoney(), bank = v.getBank()}, function()end)
			end
		end

		savePlayerMoney()
	end)
end

savePlayerMoney()