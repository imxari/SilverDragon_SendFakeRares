local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Mod_AnnounceFakeRares", "AceConsole-3.0")

function module:OnInitialize()
	self:RegisterChatCommand("sdfr", "OnChatCommand")
end

function module:GetXY(tag)
	if tag then
		local mapID = C_Map.GetBestMapForUnit(tag)
		local position = C_Map.GetPlayerMapPosition(mapID, tag)
		return mapID, position:GetXY()
	end
end

function module:cmdSend(callback, mobid, mapid, x, y, dead, source, unit)
	-- Set defaults if not parsed
	if not mapid or not x or not y then
		mapid, x, y = module:GetXY("player")
	end

	core.events:Fire(callback, mobid, mapid, x, y, dead, source, unit)
end

function module:cmdSpam(callback, mobid, mapid, x, y, dead, source, unit)
	-- Set defaults if not parsed
	if not mapid or x or y then
		mapid, x, y = module:GetXY("player")
	end

	for i=0,25,1 do
		core.events:Fire(callback, mobid, mapid, x, y, dead, source, unit)
	end
end

function module:OnChatCommand(input)
	local inInstance, instanceType = IsInInstance()
	if inInstance == true then
		self:Print("Sorry, you cannot use SendFakeRares in an instance!")
		return
	end

	local command, arg1, arg2, arg3, arg4 = self:GetArgs(input, 5) -- command, mobid, mapid, x, y

	-- BugFix: Prevents LUA error when no command is parsed
	if command then
		-- BugFix: Prevents string matching issues
		command = command:lower()

	if command == "help" then
		self:Print("SendFakeRares Commands:")
		self:Print(" -> /sdfr send <mobid> [mapid] [x] [y]")
		self:Print(" -> /sdfr spam <mobid> [mapid] [x] [y]")
		self:Print("Key: <required> [optional]")
	elseif command == "send" then
			-- BugFix: Prevents LUA error when no arg1 is parsed
			if arg1 then
				module:cmdSend("Seen", arg1, arg2, arg3, arg4, false, "Send", false)
			end
		elseif command == "spam" then
			-- BugFix: Prevents LUA error when no arg2 is parsed
			if arg2 then
				module:cmdSpam("Seen", arg1, arg2, arg3, arg4, false, "Send", false)
			end
		end
	else
		self:Print("Usage: /sdfr help")
	end
end