-- made by kamalsarasq

-- // SERVICES //
local HttpService = game:GetService("HttpService")

-- // IDGenerator //
local IDGenerator = {}
IDGenerator.__index = IDGenerator

-- // IDGen CONSTRUCTOR //
function IDGenerator.new(alphabet: string?, digits: string?)
	local self = setmetatable({}, IDGenerator)
	self._alphabet = alphabet or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	self._digits = digits or "0123456789"
	return self
end

-- // GUID GENERATOR //
function IDGenerator:GenerateGUID()
	return HttpService:GenerateGUID(false)
end

-- // ALPHABET STRING GENERATOR //
function IDGenerator:GenerateAlphabetString(length: number): string
	local builder = table.create(length)
	for i = 1, length do
		local idx = math.random(1, #self._alphabet)
		builder[i] = self._alphabet:sub(idx, idx)
	end
	return table.concat(builder)
end

-- // TAG GENERATOR //
function IDGenerator:GenerateTagNumber(prefix: string, length: number): string
	local builder = table.create(length)
	for i = 1, length do
		local idx = math.random(1, #self._digits)
		builder[i] = self._digits:sub(idx, idx)
	end
	return prefix .. table.concat(builder)
end

-- // COMPOSED ID GENERATOR //
function IDGenerator:ComposeID(prefix: string, alphaLength: number, tagLength: number): string
	local alphabetPart = self:GenerateAlphabetString(alphaLength)
	local tagPart = self:GenerateTagNumber(prefix, tagLength)

	return alphabetPart .. tagPart
end

return IDGenerator
