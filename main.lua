require('util')
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
function EvalAllLeapPoints(perms, len)
	local out = {}
	for i=1,len do out[i] = 0 end
	for _,p in pairs(perms)
	do
		local broken = {}
		local best_yet = {}
		for i=1,len do best_yet[i] = 0 end

		for i=1,len
		do
			if best_yet[i] < p[i] then
				for j=i,len do
					best_yet[j] = p[i]
				end
			end

			for j=1,i
			do
				if(broken[j]) then goto cont end
				if p[i] >= best_yet[j] then
					if p[i] == len then
						out[j] = out[j] + 1
					end
					broken[j] = true
				end
				::cont::
			end
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
local results = EvalAllLeapPoints(perms, l)
print('Done.')

local winner = 1
for i=1,l do
	if results[i] > results[winner] then
		winner = i
	end
	print(tostring(i)..': '..PropString(results[i], perfect))
end
print('---')
print('winner: '..PropString(winner, l)..': '..PropString(results[winner], perfect))
