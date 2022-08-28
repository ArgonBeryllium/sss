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

