return function(size, fieldWidth, fieldHeight)
	local t = {}
	t.n = 0
	t.lMax = 0
	for i=1,fieldWidth,1 do	
		if i < 5 or i > 6 then
		for j=1,fieldHeight,1 do
			local tempBlockPart = {	i * size		,	(j-1) * size	,
									i * size		,	j * size		,
									(i-1) * size	,	j * size		,
									(i-1) * size	,	(j-1) * size
									}
			tempBlockPart.center = {}
			tempBlockPart.center[1] = (i-0.5) * size
			tempBlockPart.center[2] = (j-0.5) * size
			table.insert(t,tempBlockPart)
			t.n = t.n + 1
		end	
		end
	end
	print(t.n)
	print(table.getn(t))
	return t
end