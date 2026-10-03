do
	local base = "https://raw.githubusercontent.com/ru-3/PhantomOnyx/refs/heads/main/modules/"
	local old = "https://raw.githubusercontent.com/flazhy/QuantumLibrary/refs/heads/main/"
	local themesUrl = base .. "util/Themes.lua"
	local map = {
		[old .. "Core.lua"] = base .. "Core.lua",
		[old .. "Notification.lua"] = base .. "Notification.lua",
		[old .. "Save.lua"] = base .. "Save.lua",
		[old .. "Theme.lua"] = base .. "Theme.lua",
		[old .. "Translation.lua"] = base .. "Translation.lua",
		["https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/Util/LibraryModule/Themes.lua"] = themesUrl,
	}

	local env = (getgenv and getgenv()) or _G

	local function swap(url)
		if type(url) == "string" and map[url] then
			return map[url]
		end
		return url
	end

	local function wrapThemes(src)
		return [[
local __T = (function()
]] .. src .. [[

end)()
local __env = (getgenv and getgenv()) or _G
__env.PhantomThemes = __T

local __alias = { Dark = "Midnight", Light = "Silver", Blue = "Ocean", Red = "Crimson" }

function __T.List()
	local names = {}
	for name in pairs(__T.Themes) do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function __T.Apply(name)
	name = __alias[name] or name
	local theme = __T.Themes[name]
	if not theme then
		return false
	end
	__T.Current = theme
	for _, fn in pairs(__T._listeners) do
		if type(fn) == "function" then
			pcall(fn, theme, name)
		end
	end
	return true
end

if __env.PhantomDebug then
	print("[Phantom] themes loaded:", table.concat(__T.List(), ", "))
	task.spawn(function()
		local last
		while true do
			if __T.Current ~= last then
				last = __T.Current
				print("[Phantom] Current theme ->", last and last.DisplayName or "nil")
			end
			task.wait(0.25)
		end
	end)
end

return __T
]]
	end

	if hookfunction and newcclosure then
		local originalHttpGet
		originalHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
			local target = swap(url)
			local result = originalHttpGet(self, target, ...)
			if target == themesUrl and type(result) == "string" then
				return wrapThemes(result)
			end
			return result
		end))
	end

	for _, name in ipairs({ "request", "http_request" }) do
		local fn = env[name]
		if type(fn) == "function" then
			env[name] = function(opts, ...)
				if type(opts) == "table" and map[opts.Url] then
					local copy = {}
					for k, v in pairs(opts) do
						copy[k] = v
					end
					copy.Url = map[opts.Url]
					opts = copy
				end
				return fn(opts, ...)
			end
		end
	end
end
