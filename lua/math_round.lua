-- ref: https://docs.rainmeter.net/snippets/round/
function math.round(num, idp)

	assert(tonumber(num), 'Round expects a number.')

	local mult = 10 ^ (idp or 0)
	if num >= 0 then
		return math.floor(num * mult + 0.5) / mult
	else
		return math.ceil(num * mult - 0.5) / mult
	end

end
