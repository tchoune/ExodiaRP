-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- Global variables
Users = {}
commands = {}
settings = {}
settings.defaultSettings = {
	['pvpEnabled'] = false,
	['permissionDenied'] = false,
	['debugInformation'] = false,
	['startingCash'] = 0,
	['startingBank'] = 0,
	['enableRankDecorators'] = false,
	['moneyIcon'] = "$",
	['nativeMoneySystem'] = false,
	['commandDelimeter'] = '/',
	['enableLogging'] = false,
	['enableCustomData'] = GetConvar('es_enableCustomData', 'false')
}
settings.sessionSettings = {}
commandSuggestions = {}

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function startswith(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
		i = i + 1
	end
	return i;
end

function debugMsg(msg)
	if(settings.defaultSettings.debugInformation and msg)then
		print("ES_DEBUG: " .. msg)
	end
end

function logExists(date, cb)
	Citizen.CreateThread(function()
		local log = io.open(date, "r")
		if log~=nil then io.close(log) cb(true) else cb(false) end
		return
	end)
end

local directory = 'resources/essentialmode/logs/'
function doesLogExist(cb)
	logExists(directory .. string.gsub(os.date('%x'), '(/)', '-') .. '.txt', function(exists)
		Citizen.CreateThread(function()
			if not exists then
				local file = io.open(directory .. string.gsub(os.date('%x'), '(/)', '-') .. '.txt', 'w')
				file:write('-- Begin of log for ' .. string.gsub(os.date('%x'), '(/)', '-') .. ' --')
				file:close()
			end
			cb(exists)

			log('== EssentialMode started, version ' .. _VERSION .. ' ==')

			return
		end)
	end)
end
Citizen.CreateThread(function()
	if settings.defaultSettings.enableLogging then doesLogExist(function()end) end
	return
end)


function log(log)
	if settings.defaultSettings.enableLogging then
		Citizen.CreateThread(function()
			local file = io.open(directory .. string.gsub(os.date('%x'), '(/)', '-') .. '.txt', 'a')
			file:write('\n[' .. os.date('%H') .. ':' .. os.date('%M')  .. '] ' .. log)
			file:close()
			return
		end)
	end
end

AddEventHandler("es:debugMsg", debugMsg)