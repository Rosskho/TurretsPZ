require "MapObjects"

-- Define turret behavior
Turret = {}
Turret.Range = 10
Turret.RateOfFire = 2
Turret.AmmoType = "Bullets9mm"  --can change to what you want

function Turret:place(player, square)
    local turret = IsoObject.new(square:getCell(), square)
    turret:setSprite("media/textures/turret.png")
    turret.ammo = 30 -- Starting ammo
    turret.isPowered = true
    square:AddSpecialObject(turret)
end

function Turret:detectAndShoot(turret)
    if not turret.isPowered or turret.ammo <= 0 then return end
    local zombies = getZombiesInRange(turret:getSquare(), Turret.Range)
    for _, zombie in ipairs(zombies) do
        turret.ammo = turret.ammo - 1
        zombie:Damage(20) -- Example damage value
        if turret.ammo <= 0 then break end
    end
end

-- Hook turret detection into game updates
Events.OnTick.Add(function()
    for _, turret in ipairs(getPlacedTurrets()) do
        Turret:detectAndShoot(turret)
    end
end)
