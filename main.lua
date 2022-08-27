function Factorial(n)
	if n==1 or n==0 then return 1
	else
		-- return n*factorial(n-1) -- neat, but inefficient
		local out = 1
		for i=2,n do out=i*out end
		return out
	end
end
function Copy(self)
	local t = type(self)
	local out
	if t == 'table' then
		out = {}
		for i, v in ipairs(self) do
			out[i] = Copy(v)
		end
	else out = self end
	return out
end
function table:print()
	for i,v in pairs(self)
	do
		print(i..': '..tostring(v))
		if type(v) == 'table' then
			print('*---')
			table.print(v)
			print('---*')
		end
	end
end
function table:length()
	local out = 0
	for i,_ in pairs(self) do out = out + 1 end
	return out
end

function PropString(val, max)
	return tostring(val)..'/'..tostring(max)..
			' ('..string.format('%.2f%%', val/max*100)..')'
end

-- Incredibly inefficient (O(n!)), but it'll do for a tiny demo script
function PermIter(gen, cur, pref, len)
	if len == 1 then
		table.insert(pref, cur[1])
		table.insert(gen, pref)
		return
	end
	for i,v in ipairs(cur)
	do
		local ncur = Copy(cur)
		table.remove(ncur, i)
		local npref = Copy(pref)
		table.insert(npref, v)
		PermIter(gen, ncur, npref, len-1)
	end
end
function GenPermutations(n)
	local r = {}
	for i = 1,n do r[i] = i end
	local gen = {}
	PermIter(gen, r, {}, n)
	return gen
end

function EvalLeapPoint(perms, leap_point, len)
	local out = 0
	for _,p in pairs(perms)
	do
		local best_yet = 0
		for i=1,len
		do
			if i >= leap_point and p[i] > best_yet then
				if p[i] == len then
					out = out + 1
				end
				break
			end
			best_yet = math.max(best_yet, p[i])
		end
	end
	return out
end

local l = 9

local perfect = Factorial(l)
print('Generating '..perfect..' permutations...')
local perms = GenPermutations(l)
print('Done.')
print('Evaluating possible leap points...')
local results = {}
local winner = 1
for i=1,l do
	results[i] = EvalLeapPoint(perms, i, l)
	if results[i] > results[winner] then
		winner = i
	end
	print(tostring(i)..': '..PropString(results[i], perfect))
end
print('---')
print('winner: '..PropString(winner, l)..': '..PropString(results[winner], perfect))
