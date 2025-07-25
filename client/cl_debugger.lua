local QBCore = exports['qb-core']:GetCoreObject()

Debugger = {
	speedBuffer = {},
	speed = 0.0,
	accel = 0.0,
	decel = 0.0,
	toggle = false
}

--[[ Functions ]]--
function TruncateNumber(value)
	value = value * Config.Precision

	return (value % 1.0 > 0.5 and math.ceil(value) or math.floor(value)) / Config.Precision
end

function Debugger:LoadBaseHandling(display_name)
	local p = promise.new()
	QBCore.Functions.TriggerCallback('v-tuner:LoadBaseHandling', function(result)
	  p:resolve(result)
	end, display_name)
	local handling_result = Citizen.Await(p)
	return handling_result
end

function Debugger:Set(vehicle)
	self.vehicle = vehicle
	self:ResetStats()

	local current_handling = {}

	-- Loop fields.
	for key, field in pairs(Config.Fields) do
		-- Get field type.
		local fieldType = Config.Types[field.type]
		if fieldType == nil then error("no field type") end

		-- Get value.
		local value = fieldType.getter(vehicle, "CHandlingData", field.name)
		if type(value) == "vector3" then
			---@diagnostic disable-next-line: cast-local-type
			value = ("%s,%s,%s"):format(value.x, value.y, value.z)
		elseif field.type == "float" then
			value = TruncateNumber(value)
		end

		table.insert(current_handling, {
			key = key, 
			name = field.name, 
			value = value, 
			description = field.description or "Unspecified."
		})
	end

	local display_name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	local base_handling = self:LoadBaseHandling(display_name)
	if base_handling == nil then
		local p = promise.new()
		QBCore.Functions.TriggerCallback('v-tuner:SetBaseHandling', function(result)
			p:resolve(result)
		end, display_name, current_handling)
		local handling_result = Citizen.Await(p)
		base_handling = current_handling
	else
		for i, v in pairs(base_handling) do
			print(i..': ', v)
		end
		local new_base_handling = {}
		for key, field in pairs(Config.Fields) do
			-- Get field type.
			local fieldType = Config.Types[field.type]
			if fieldType == nil then error("no field type") end
	
			-- Get value.
			local value = base_handling[field.name]
			print(field.name..": ", value, field.type)
			if value == nil then
				value = current_handling[key].value
				goto next
			end
			if field.type == "vector" then 
				local axes = 1
				local vector = {}

				for axis in value:gmatch("([^,]+)") do
					vector[axes] = tonumber(axis)
					axes = axes + 1
				end

				for i = 1, 3 do
					if vector[i] == nil then
						print("missing vector")
						self:SetHandling(key, current_handling[key].value)
						goto next 
					end
				end
			end

			if type(value) == "vector3" then
				value = ("%s,%s,%s"):format(value.x, value.y, value.z)
			elseif field.type == "float" then
				local number = tonumber(value)
				if number == nil then 
					self:SetHandling(key, current_handling[key].value)
					goto next 
				end
				value = TruncateNumber(tonumber(value))
			end
			self:SetHandling(key, value)
			::next::
			table.insert(new_base_handling, {
				key = key, 
				name = field.name, 
				value = value, 
				description = field.description or "Unspecified."
			})
		end
		base_handling = new_base_handling
		current_handling = new_base_handling
	end

	-- Update text.
	self:Invoke("updateCurrentHandling", current_handling)
	self:Invoke("updateBaseHandling", base_handling)
end

function Debugger:UpdateVehicle()
	local ped = PlayerPedId()
	local isInVehicle = IsPedInAnyVehicle(ped, false)
	local vehicle = GetVehiclePedIsIn(ped, false)

	if self.isInVehicle ~= isInVehicle or self.vehicle ~= vehicle then
		self.vehicle = vehicle
		self.isInVehicle = isInVehicle

		if isInVehicle and DoesEntityExist(vehicle) then
			self:Set(vehicle)
		end
	end
end

function Debugger:UpdateAverages()
	if not DoesEntityExist(self.vehicle or 0) then return end

	-- Get the speed.
	local speed = GetEntitySpeed(self.vehicle)

	-- Speed buffer.
	table.insert(self.speedBuffer, speed)

	if #self.speedBuffer > 100 then
		table.remove(self.speedBuffer, 1)
	end

	-- Calculate averages.
	local accel = 0.0
	local decel = 0.0
	local accelCount = 0
	local decelCount = 0

	for k, v in ipairs(self.speedBuffer) do
		if k > 1 then
			local change = (v - self.speedBuffer[k - 1])
			if change > 0.0 then
				accel = accel + change
				accelCount = accelCount + 1
			else
				decel = accel + change
				decelCount = decelCount + 1
			end
		end
	end

	accel = accel / accelCount
	decel = decel / decelCount

	-- Set tops.
	self.speed = math.max(self.speed, speed)
	self.accel = math.max(self.accel, accel)
	self.decel = math.min(self.decel, decel)

	self.gear = GetVehicleCurrentGear(self.vehicle)

	-- Update text.
	self:Invoke("updateHUD", {
		["top-speed"] = self.speed * 2.236936,
		["top-accel"] = self.accel * 60.0 * 2.236936,
		["top-decel"] = math.abs(self.decel) * 60.0 * 2.236936,
		["gear"] = self.gear,
	})
end

function Debugger:ResetStats()
	self.speed = 0.0
	self.accel = 0.0
	self.decel = 0.0
	self.speedBuffer = {}
end

function Debugger:SetHandling(key, value)
	if not DoesEntityExist(self.vehicle or 0) then return end

	-- Get field.
	local field = Config.Fields[key]
	if field == nil then error("no field") end

	-- Get field type.
	local fieldType = Config.Types[field.type]
	if fieldType == nil then error("no field type") end

	-- Set field.
	fieldType.setter(self.vehicle, "CHandlingData", field.name, value)

	-- Needed for some values to work.
	ModifyVehicleTopSpeed(self.vehicle, 1.0)
end

function Debugger:CopyHandling()
	local text = ""

	-- Line writer.
	local function writeLine(append)
		if text ~= "" then
			text = text.."\n\t\t\t"
		end
		text = text..append
	end

	-- Get vehicle.
	local vehicle = self.vehicle
	if not DoesEntityExist(vehicle) then return end

	-- Loop fields.
	for key, field in pairs(Config.Fields) do
		-- Get field type.
		local fieldType = Config.Types[field.type]
		if fieldType == nil then error("no field type") end

		-- Get value.
		local value = fieldType.getter(vehicle, "CHandlingData", field.name)
		local nValue = tonumber(value)

		-- Append text.
		if nValue ~= nil then
			writeLine(("<%s value=\"%s\" />"):format(field.name, field.type == "float" and TruncateNumber(nValue) or nValue))
		elseif field.type == "vector" then
			writeLine(("<%s x=\"%s\" y=\"%s\" z=\"%s\" />"):format(field.name, value.x, value.y, value.z))
		end
	end

	-- Copy text.
	self:Invoke("copyText", text)
end

function Debugger:Focus(toggle)
	if toggle and not DoesEntityExist(self.vehicle or 0) then return end

	SetNuiFocus(toggle, toggle)
	--SetNuiFocusKeepInput(toggle)

	self.hasFocus = toggle
	self:Invoke("setFocus", toggle)
end

function Debugger:ToggleOn(toggleData)
	-- if toggle and not DoesEntityExist(self.vehicle or 0) then return end

	self.toggle = toggleData
	SendNUIMessage({
        action = 'setVisible',
        data = toggleData
    })
end

function Debugger:Invoke(_type, data)
	SendNUIMessage({
        action = _type,
        data = data
	})
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		Debugger:UpdateVehicle()
	end
end)

Citizen.CreateThread(function()
	while true do
		if Debugger.isInVehicle then
			Citizen.Wait(100)
			Debugger:UpdateAverages()
		else
			Citizen.Wait(1000)
		end
	end
end)

--[[ NUI Events ]]--
RegisterNUICallback("updateCurrentHandling", function(data, cb)

	if pcall(function() return Debugger:SetHandling(tonumber(data.key), data.value) end) then
		cb(true)
	else
		cb(false)
	end
end)

RegisterNUICallback("updateBaseHandling", function(data, cb)
	local value
	local fieldType = Config.Fields[data.key].type
	if fieldType == nil then error("no field") end

	print("key: ", data.key)
	print("field: ", fieldType)
	print("value: ", data.value)
	
	if fieldType == "float" then
		if tonumber(data.value) == nil then
			Citizen.Wait(100)
			cb(false)
			return
		end
		value = data.value + 0.0
	elseif fieldType == "integer" then
		if tonumber(data.value) == nil then
			Citizen.Wait(100)
			cb(false)
			return
		end
		value = math.floor(data.value)
	elseif fieldType == "vector" then
		local axes = 1
		local vector = {}

		for axis in data.value:gmatch("([^,]+)") do
			vector[axes] = tonumber(axis)
			axes = axes + 1
		end

		for i = 1, 3 do
			if vector[i] == nil then
				Citizen.Wait(100)
				cb(false)
				return
			end
		end
		value = vector3(vector[1], vector[2], vector[3])
	end

	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local display_name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	local p = promise.new()
	QBCore.Functions.TriggerCallback('v-tuner:UpdateBaseHandling', function(result)
		p:resolve(result)
	end, display_name, data.field, value)
	local result = Citizen.Await(p)
	print(result)
	cb(result)
end)

RegisterNUICallback("copyHandling", function(data, cb)
	cb(true)
	Debugger:CopyHandling()
end)

RegisterNUICallback("resetStats", function(data, cb)
	cb(true)
	Debugger:ResetStats()
end)

--[[ Commands ]]--
RegisterCommand("+vehicleDebug", function()
	if not Debugger.toggleOn then 
		return 
	end
	Debugger:Focus(not Debugger.hasFocus)
end, true)

RegisterKeyMapping("+vehicleDebug", "Vehicle Debugger", "keyboard", "LCONTROL")

RegisterNetEvent("vehicleDebug:client:toggleDebug", function()
	Debugger:ToggleOn(not Debugger.toggleOn)
	Debugger.toggleOn = not Debugger.toggleOn
end)

RegisterNetEvent("vehicleDebug:client:resetBaseHandling", function()
	SetNuiFocus(true, true)
	SendNUIMessage({
        action = 'resetConfirm',
        data = true
    })
end)

RegisterNUICallback("resetConfirm", function(data, cb)
	SetNuiFocus(Debugger.hasFocus, Debugger.hasFocus)
	if not data then
		cb(false)
		return
	end
	ResetBaseHandling()
	cb(true)
end)

function ResetBaseHandling()
	local ped = PlayerPedId()
	-- local isInVehicle = IsPedInAnyVehicle(ped, false)
	local vehicle = GetVehiclePedIsIn(ped, false)
	local display_name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	if display_name == nil or display_name == "" then
		print("No vehicle found to reset handling for.")
		return
	end
	local p = promise.new()
	QBCore.Functions.TriggerCallback('v-tuner:deleteBaseHandling', function(result)
		p:resolve(result)
	end, display_name)
	local result = Citizen.Await(p)
	DeleteVehicle(vehicle)
	Debugger.vehicle = nil
	TriggerServerEvent('v-tuner:server:SpawnVehicle', display_name)
	Debugger:UpdateVehicle()
	QBCore.Functions.Notify("Vehicle handling reset.", "success")
end

RegisterNUICallback("CloseMenu", function(_, cb)
	cb({})
	Debugger:Focus(not Debugger.hasFocus)
end)