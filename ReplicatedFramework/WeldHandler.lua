local module = {}

function module.WeldInPlace(sendModule, part0, part1)
	
	local weld = Instance.new("Weld")
	
	weld.Part0 = part0
	weld.Part1 = part1
	
	weld.C0 = part0.CFrame:Inverse()
	weld.C1 = part1.CFrame:Inverse()
	
	weld.Parent = part0
	weld.Name = part0.Name
	
	return	
	
end

function module.Weld(sendModule, part0, part1, cFrame, cFrame2)
	
	local weld = Instance.new("Weld")

	weld.Part0 = part0
	weld.Part1 = part1
	
	if cFrame2 then
		
		weld.C0 = cFrame2
		
	end
	
	if cFrame then
		
		weld.C0 = weld.C0 * cFrame
		
	end
	
	weld.Parent = part0
	weld.Name = part1.Name

	return
	
end

function module.M6DWeld(sendModule, part0, part1, cFrame, cFrame2)

	local weld = Instance.new("Motor6D")

	weld.Part0 = part0
	weld.Part1 = part1

	if cFrame2 then

		weld.C0 = cFrame2

	end

	if cFrame then

		weld.C0 = weld.C0 * cFrame

	end

	weld.Parent = part0
	weld.Name = part0.Name
		
	return

end

function module.M6DInPlaceWeld(sendModule, part0, part1)

	local m6D = Instance.new("Motor6D")

	m6D.Part0 = part0
	m6D.Part1 = part1
	
	m6D.C0 = part0.CFrame:Inverse()
	m6D.C1 = part1.CFrame:Inverse()
	
	m6D.Parent = part0
	m6D.Name = part1.Name

	return

end

function module.LocateAndDestroyWelds(sendModule, targetPart, stringTargetWeld)
	
	local childObjects = targetPart:GetChildren()
	local c0
	
	for i = 1,#childObjects do
		
		if childObjects[i].ClassName == "Weld" or childObjects[i].ClassName == "Motor6D" then
			
			if stringTargetWeld then
				
				if childObjects[i].Name == stringTargetWeld then
					c0 = childObjects[i].C0
					childObjects[i]:Destroy()
				end
				
			else	
				childObjects[i]:Destroy()

			end
			
		end
		
	end
	
	if c0 then
		return c0
	end
	
end

return module
