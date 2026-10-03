do
	local base = "https://raw.githubusercontent.com/ru-3/PhantomOnyx/refs/heads/main/modules/"
	local old = "https://raw.githubusercontent.com/flazhy/QuantumLibrary/refs/heads/main/"
	local map = {
		[old .. "Core.lua"] = base .. "Core.lua",
		[old .. "Notification.lua"] = base .. "Notification.lua",
		[old .. "Save.lua"] = base .. "Save.lua",
		[old .. "Theme.lua"] = base .. "Theme.lua",
		[old .. "Translation.lua"] = base .. "Translation.lua",
		["https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/Util/LibraryModule/Themes.lua"] = base .. "util/Themes.lua",
	}

	local function swap(url)
		if type(url) == "string" and map[url] then
			return map[url]
		end
		return url
	end

	if hookfunction and newcclosure then
		local originalHttpGet
		originalHttpGet = hookfunction(game.HttpGet, newcclosure(function(self, url, ...)
			return originalHttpGet(self, swap(url), ...)
		end))
	end

	local env = (getgenv and getgenv()) or _G
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
