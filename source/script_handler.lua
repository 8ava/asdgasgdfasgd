
local method = nil


local primatives = {
	table = nil -- uninitialized so that it can index its hierarchy
}

local function apply(parent, index)
	local value = parent[index]
	
	parent[index] = method(value)
end

primatives.table = function(primative)
	local iter = 0
	local iter_FLAG = false

	local next_layer = {}

	local function add()
		iter = iter + 1 -- still no compound operations in most executors

		if iter > _G._RTCEnvironment.vars.recursive_layer_threshold then
			iter_FLAG = true
		end
	end

	for index, value in next, primative do
		local type_ = typeof(value)
		
		
		if type_ == 'table' then
			table.insert(next_layer, value)

			continue
		end

		apply(primative, index)
	end

	add() if iter_FLAG then return end


	for index, value in next_layer do
		add() if iter_FLAG then return end
		
		
		local type_ = typeof(value)
		
		if type_ == 'table' then
			continue
		end
		
		apply(next_layer, index)
	end
end



local module = {}

function module.set(primative)
	method = _G._RTCEnvironment.vars.CurrentEngine.get


	local type_ = typeof(primative)

	if primatives[type_] then
		local a, message = pcall(primatives[type_], primative) if not a then warn(message) end
	else
		-- later
	end
end


return module
