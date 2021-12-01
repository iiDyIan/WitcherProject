local module = {}

local statusDict= {}

function module.init(User)

    -- m6D where intended

    statusDict[User] = 1

end

function module.StartEquip(User)

    if statusDict[User] ~= 1 then return end

    statusDict[User] = 2

    -- call animation module for equip

    -- update m6D weld

    statusDict[User] = 3

    -- call animation module for loop

end

function module.StartUnequip(User)

    if statusDict[User] ~= 3 then return end

    statusDict[User] = 4

    -- stop running animations

    -- call animation module for unequip

    statusDict[User] = 1

end

function module.EngageHeavy(User)

    if not statusDict[User] == 3 then return end



end

function module.EngageLight(User)

    if not statusDict[User] == 3 then return end


end

function module.EngageParry(User)

    if not statusDict[User] == 3 then return end

    

end

return module
