local HttpService = game:GetService("HttpService")

local Translate = {}

local TranslationData = {
    Languages = {
        ["English"] = "en",
        ["Filipino"] = "fil",
        ["Indonesian"] = "id",
        ["Spanish"] = "es",
        ["French"] = "fr",
        ["German"] = "de",
        ["Japanese"] = "ja",
        ["Korean"] = "ko",
        ["Vietnamese"] = "vi",
        ["Thai"] = "th",
        ["Russian"] = "ru",
        ["Portuguese"] = "pt",
        ["Turkish"] = "tr",
        ["Hindi"] = "hi",
        ["Chinese Simplified"] = "zh-cn",
        ["Chinese Traditional"] = "zh-tw",
        ["Arabic"] = "ar",
        ["Italian"] = "it",
        ["Polish"] = "pl",
        ["Dutch"] = "nl",
        ["Ukrainian"] = "uk",
        ["Malay"] = "ms",
        ["Bengali"] = "bn",
        ["Urdu"] = "ur",
        ["Persian"] = "fa",
        ["Romanian"] = "ro",
        ["Czech"] = "cs",
        ["Greek"] = "el",
        ["Swedish"] = "sv",
        ["Hungarian"] = "hu",
        ["Danish"] = "da",
        ["Finnish"] = "fi",
        ["Norwegian"] = "no",
        ["Hebrew"] = "he",
        ["Slovak"] = "sk",
        ["Bulgarian"] = "bg",
        ["Croatian"] = "hr",
        ["Serbian"] = "sr",
        ["Lithuanian"] = "lt",
        ["Latvian"] = "lv",
        ["Slovenian"] = "sl",
    },
    RegisteredElements = {},
    Cache = {},
    DebounceTimer = nil,
    PendingLang = nil
}

function Translate.BatchTranslate(Lang, texts)
    if not texts or #texts == 0 then return {} end
    local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. Lang .. "&dt=t"
    for _, text in ipairs(texts) do
		url = url .. "&q=" .. HttpService:UrlEncode(text)
    end
    local response = game:HttpGet(url)
    local decoded = HttpService:JSONDecode(response)
    local results = {}
    if decoded and #decoded == #texts then
        for i, res in ipairs(decoded) do
            if res and res[1] and res[1][1] then
                results[texts[i]] = res[1][1]
            else
                results[texts[i]] = texts[i]
            end
        end
    else
        if decoded and decoded[1] then
            local out = ""
            for _, v in ipairs(decoded[1]) do
                if v[1] then out = out .. v[1] end
            end
            for _, text in ipairs(texts) do
                results[text] = out
            end
        else
            for _, text in ipairs(texts) do
                results[text] = text
            end
        end
    end
    return results
end

function Translate.RegisterTranslatable(instance, text)
    if not instance or not text or text == "" then return end
    TranslationData.RegisteredElements[instance] = { original = text }
end

function Translate.ApplyTranslation(Lang)
    if TranslationData.DebounceTimer then
        task.cancel(TranslationData.DebounceTimer)
    end
    TranslationData.PendingLang = Lang
    TranslationData.DebounceTimer = task.delay(0.4, function()
        TranslationData.DebounceTimer = nil
        local TargetLang = TranslationData.PendingLang
        if not TargetLang then return end
        TranslationData.PendingLang = nil

        if TargetLang == "en" then
            for instance, data in pairs(TranslationData.RegisteredElements) do
                if instance and instance.Parent then
                    instance.Text = data.original
                end
            end
            return
        end
        local needed = {}
        local seen = {}
        for instance, data in pairs(TranslationData.RegisteredElements) do
            if instance and instance.Parent then
                local text = data.original
                local cacheKey = TargetLang .. ":" .. text
                if not TranslationData.Cache[cacheKey] and not seen[text] then
                    seen[text] = true
                    table.insert(needed, text)
                end
            end
        end
        if #needed == 0 then
            for instance, data in pairs(TranslationData.RegisteredElements) do
                if instance and instance.Parent then
                    local cacheKey = TargetLang .. ":" .. data.original
                    local translated = TranslationData.Cache[cacheKey]
                    if translated then
                        instance.Text = translated
                    end
                end
            end
            return
        end
        local BATCH_SIZE = 10
        local batches = {}
        for i = 1, #needed, BATCH_SIZE do
            local batch = {}
            for j = i, math.min(i + BATCH_SIZE - 1, #needed) do
                table.insert(batch, needed[j])
            end
            table.insert(batches, batch)
        end
        task.spawn(function()
            for _, batch in ipairs(batches) do
                local translations = Translate.BatchTranslate(TargetLang, batch)
                for _, text in ipairs(batch) do
                    local translated = translations[text]
                    if translated and translated ~= "" then
                        local CacheKey = TargetLang .. ":" .. text
                        TranslationData.Cache[CacheKey] = translated
                    end
                end
                task.wait(0.1)
            end
            for i,v in pairs(TranslationData.RegisteredElements) do
                if i and i.Parent then
                    local CacheKey = TargetLang .. ":" .. v.original
                    local translated = TranslationData.Cache[CacheKey]
                    i.Text = translated or v.original
                end
            end
        end)
    end)
end

return Translate