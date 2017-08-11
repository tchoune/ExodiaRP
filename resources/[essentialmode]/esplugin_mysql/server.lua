-- Make sure you set this convar: 
-- set es_enableCustomData 1

local mReady = false

AddEventHandler('onMySQLReady', function ()
	mReady = true
end)

AddEventHandler('es_db:firstRunCheck', function(ip, port)
	-- Not in use
end)

AddEventHandler('es_db:doesUserExist', function(identifier, callback)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE `identifier`=@identifier;', {identifier = identifier}, function(users)
		if users[1] then
			callback(true)
		else
			callback(false)
		end
	end)
end)

AddEventHandler('es_db:retrieveUser', function(identifier, callback)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE `identifier`=@identifier;', {identifier = identifier}, function(users)
		if users[1] then
			callback(users[1])
		else
			callback(false)
		end
	end)
end)

AddEventHandler('es_db:createUser', function(identifier, cash, bank, callback)
	local user = { identifier = identifier, money = cash or 0, bank = bank or 0, group = "user", permission_level = 0 }

	MySQL.Async.execute('INSERT INTO users (`identifier`, `money`, `bank`, `group`, `permission_level`) VALUES (@identifier, @money, @bank, @group, @permission_level);', {identifier = user.identifier, money = user.money, bank = user.bank, permission_level = user.permission_level, group = user.group}, function(e)
		callback()
	end)
end)

AddEventHandler('es_db:updateUser', function(identifier, new, callback)
	Citizen.CreateThread(function()
		local updateString = ""

		local length = tLength(new)
		local cLength = 1
		for k,v in pairs(new)do
			if cLength < length then
				if(type(v) == "number")then
					updateString = updateString .. "`" .. k .. "`=" .. v .. ","
				else
					updateString = updateString .. "`" .. k .. "`='" .. v .. "',"
				end
			else
				if(type(v) == "number")then
					updateString = updateString .. "`" .. k .. "`=" .. v .. ""
				else
					updateString = updateString .. "`" .. k .. "`='" .. v .. "'"
				end
			end
			cLength = cLength + 1
		end

		MySQL.Async.execute('UPDATE users SET ' .. updateString .. ' WHERE `identifier`=@identifier', {identifier = identifier}, function(done)
			if callback then
				callback(true)
			end
		end)
	end)
end)

function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end

	return l
end