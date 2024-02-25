local defaultLocale = "en"
Locales = {}

function Translate(str, ...)
	if Locales[Config.Locale] then
		if Locales[Config.Locale][str] then
			return string.format(Locales[Config.Locale][str], ...)
		elseif Config.Locale ~= "en" and Locales["en"] and Locales["en"][str] then
			return string.format(Locales["en"][str], ...)
		else
			return "Translation [" .. Config.Locale .. "][" .. str .. "] does not exist"
		end
	elseif Config.Locale ~= defaultLocale and Locales[defaultLocale] and Locales[defaultLocale][str] then
		return string.format(Locales[defaultLocale][str], ...)
	else
		return "Locale [" .. Config.Locale .. "] does not exist"
	end
end

function TranslateCap(str, ...)
	return _(str, ...):gsub("^%l", string.upper)
end

_ = Translate
_U = TranslateCap