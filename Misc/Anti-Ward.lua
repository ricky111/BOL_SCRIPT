local blackColor  = 4278190080
local purpleColor = 4294902015
local greenColor  = 4278255360
local aquaColor = ARGB(255,102, 205, 170)

local whiteColor = ARGB(255,255, 255, 255)
local grayColor = ARGB(255, 200, 200, 200)

function OnLoad()
  placedWards = {}

  Config = scriptConfig("AntiWard", "AntiWard")
  Config:addParam("OwnTeam", "show my own team wards", SCRIPT_PARAM_ONOFF, false)
  Config:addParam("ShowPinks", "show pink wards", SCRIPT_PARAM_ONOFF, true)
  Config:addParam("ShowTraps", "show traps", SCRIPT_PARAM_ONOFF, true)

  Config:addParam("PingWards", "ping wards near you", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))

  Config:addParam("Manual", "manual ward editing (put/delete)", SCRIPT_PARAM_ONOFF, false)

  Config:addParam("DeleteWard", "delete ward", SCRIPT_PARAM_ONKEYDOWN, false, 0)

  Config:addParam("PutWard1", "put 1 minute ward", SCRIPT_PARAM_ONKEYDOWN, false, 0)
  Config:addParam("PutWard2", "put 2 minute ward", SCRIPT_PARAM_ONKEYDOWN, false, 0)
  Config:addParam("PutWard3", "put 3 minute ward", SCRIPT_PARAM_ONKEYDOWN, false, 0)

	PrintChat(" >> AntiWard 3.15 (2014-02-03)")

  TriggerTrap()
end

local _allyHeroes
function GetAllyHeroes()
    if _allyHeroes then return _allyHeroes end
    _allyHeroes = {}
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.team == myHero.team then
            table.insert(_allyHeroes, hero)
        end
    end
    return setmetatable(_allyHeroes,{
        __newindex = function(self, key, value)
            error("Adding to AllyHeroes is not granted. Use table.copy.")
        end,
    })
end

function TriggerTrap()
  for ID, ward in pairs(placedWards) do
    for i = 1, heroManager.iCount do
      local hero = heroManager:GetHero(i)

      if ward.trap and ward.team ~= hero.team and GetDistance(ward, hero) <= ward.triggerRange then
        placedWards[ID] = nil
      end
    end
  end

  DelayAction(TriggerTrap, 0.2)
end

function OnTick()
  if Config.Manual then
    if Config.DeleteWard then DeleteWard(mousePos.x, mousePos.y, mousePos.z) end

    if Config.PutWard1 then PutWard(mousePos.x, mousePos.y, mousePos.z, 1 * 60) end
    if Config.PutWard2 then PutWard(mousePos.x, mousePos.y, mousePos.z, 2 * 60) end
    if Config.PutWard3 then PutWard(mousePos.x, mousePos.y, mousePos.z, 3 * 60) end
  end
end

function OnDraw()
  local PingWards = Config.PingWards
  local Pinged = false

	for ID, ward in pairs(placedWards) do
		if (GetTickCount() - ward.spawnTime) > ward.duration + 5000 or (ward.object and ward.object.health == 0) then
			placedWards[ID] = nil
		elseif (ward.team == TEAM_ENEMY or Config.OwnTeam) and (ward.duration < math.huge or Config.ShowPinks) and (not ward.trap or Config.ShowTraps) then
      if PingWards and GetDistance(ward, mousePos) <= 1500 and (ward.lastPing == nil or GetGameTimer() - ward.lastPing > 20) then
        PingSignal(0, ward.x, ward.y, ward.z, PING_FALLBACK)

        ward.lastPing = GetGameTimer()
        Pinged = true
      end

			local minimapPosition = GetMinimap(ward)
			DrawTextWithBorder('.', 60, minimapPosition.x - 3, minimapPosition.y - 43, ward.color, blackColor)

			local x, y, onScreen = get2DFrom3D(ward.x, ward.y, ward.z)
			DrawTextWithBorder(TimerText((ward.duration - (GetTickCount() - ward.spawnTime)) / 1000), 20, x - 15, y - 11, ward.color, blackColor)
      if ward["creator"] then DrawTextWithBorder(ward["creator"].charName, 16, x - 20, y + 10, whiteColor, blackColor) end

			DrawCircle2(ward.x, ward.y, ward.z, 90, ward.color)
			if IsKeyDown(16) then
				DrawCircle2(ward.x, ward.y, ward.z, ward.visionRange, ward.color)
			end

		end
	end

  if Pinged then SendChat('wards there') end
end

function DrawTextWithBorder(textToDraw, textSize, x, y, textColor, backgroundColor)
	DrawText(textToDraw, textSize, x + 1, y, backgroundColor)
	DrawText(textToDraw, textSize, x - 1, y, backgroundColor)
	DrawText(textToDraw, textSize, x, y - 1, backgroundColor)
	DrawText(textToDraw, textSize, x, y + 1, backgroundColor)
	DrawText(textToDraw, textSize, x , y, textColor)
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))

	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 75)	
	end
end

function get2DFrom3D(x, y, z)
    local pos = WorldToScreen(D3DXVECTOR3(x, y, z))
    return pos.x, pos.y, OnScreen(pos.x, pos.y)
end

function FindObjAt(x, y, z, distance, timediff, timestart)
  if not distance then distance = 1 end
  if not timediff then timediff = math.huge end
  if not timestart then timestart = GetTickCount() end

  for networkID, ward in pairs(placedWards) do
    if GetDistance(ward, Vector(x, y, z)) < distance and timestart - ward.spawnTime < timediff then return networkID end
  end

  return nil
end

function GetLandingPos(CastPoint)
	local wall = IsWall(D3DXVECTOR3(CastPoint.x, CastPoint.y, CastPoint.z))
	local Point = Vector(CastPoint)
	local StartPoint = Vector(Point)
        if not wall then return Point end
	for i = 0, 700, 10--[[Decrease for better precision, increase for less fps drops:]] do
		for theta = 0, 2 * math.pi + 0.2, 0.2 --[[Same :)]] do
			local c = Vector(StartPoint.x + i * math.cos(theta), StartPoint.y, StartPoint.z + i * math.sin(theta))
			if not IsWall(D3DXVECTOR3(c.x, c.y, c.z)) then
				return c
			end
		end
	end
	return Point
end

local types = {
  { duration=60 * 1000, sightRange=1350, triggerRange=70, charName="SightWard", name="YellowTrinket", spellName="RelicSmallLantern", color = aquaColor }, -- 1 minute trinket
  { duration=120 * 1000, sightRange=1350, triggerRange=70, charName="SightWard", name="YellowTrinketUpgrade", spellName="RelicLantern", color = aquaColor }, -- 2 minute trinket
  { duration=180 * 1000, sightRange=1350, triggerRange=70, charName="SightWard", name="SightWard", spellName="SightWard", color = greenColor }, -- 3 minute green ward
  { duration=180 * 1000, sightRange=1350, triggerRange=70, charName="SightWard", name="SightWard", spellName="wrigglelantern", color = greenColor }, -- 3 minute lantern ward
  { duration=180 * 1000, sightRange=1350, triggerRange=70, charName="VisionWard", name="SightWard", spellName="ItemGhostWard", color = greenColor }, -- 3 minute item ward
  { duration=math.huge, sightRange=1350, triggerRange=70, charName="VisionWard", name="VisionWard", spellName="VisionWard", color = purpleColor }, -- pink ward

  { duration=600 * 1000, sightRange=405, triggerRange=115, charName="Noxious Trap", name="TeemoMushroom", spellName="BantamTrap", color = whiteColor, trap = true }, -- teemo mushroom
  { duration=60 * 1000, sightRange=690, triggerRange=300, charName="Jack In The Box", name="ShacoBox", spellName="JackInTheBox", color = whiteColor, trap = true }, -- shaco trap
  { duration=240 * 1000, sightRange=150, triggerRange=150, charName="Cupcake Trap", name="CaitlynTrap", spellName="CaitlynYordleTrap", color = whiteColor, trap = true }, -- caitlyn trap
  { duration=240 * 1000, sightRange=0, triggerRange=150, charName="Noxious Trap", name="Nidalee_Spear", spellName="Bushwhack", color = whiteColor, trap = true } -- nidalee trap
}

function OnDeleteObj(object)
	if object and object.name and object.valid and object.type == "obj_AI_Minion" then

    for _,type in ipairs(types) do

      if object.name == type.charName and object.charName == type.name then

        local ID = FindObjAt(object.x, object.y, object.z) 

        if ID and object.health == 0 then
          placedWards[ID] = nil
        end
      end

    end

  end
end

COOLDOWN = GetGameTimer()

function PutWard(x, y, z, time)
  if GetGameTimer() - COOLDOWN < 1 then return end

  local ID = FindObjAt(x, y, z, 150)

  if ID == nil then
    placedWards["user:" .. GetTickCount()] = { x = x, y = y, z = z, visionRange = 1350, color = grayColor, 
                                                                              spawnTime = GetTickCount(), duration = time*1000, creator = nil, team = nil }
  end

  COOLDOWN = GetGameTimer()
end

function DeleteWard(x, y, z)
  if GetGameTimer() - COOLDOWN < 1 then return end

  local ID = FindObjAt(x, y, z, 100)

  if ID then placedWards[ID] = nil end

  COOLDOWN = GetGameTimer()
end

function OnCreateObj(object)

	if object and object.name and object.valid and object.type == "obj_AI_Minion" then

    DelayAction(function(object, timer, gtimer)

      for _,type in ipairs(types) do

        if object.name == type.charName and object.charName == type.name then

          local ID = FindObjAt(object.x, object.y, object.z, 1100, 500, timer)

          if object.health > 0 then
            if ID == nil then
              placedWards["create:" .. GetTickCount()] = { x = object.x, y = object.y, z = object.z, visionRange = type.sightRange, color = type.color, object = object, 
                triggerRange = type.triggerRange, spawnTime = timer, duration = type.duration, creator = nil, team = object.team, trap = type.trap }
            else
              placedWards[ID].x = object.x
              placedWards[ID].y = object.y
              placedWards[ID].z = object.z
            end
          end


        end

      end
    end, 1, { object, GetTickCount(), GetGameTimer() } )

  end
end

function OnProcessSpell(unit, spell)

  if unit.type == "obj_AI_Hero" then
		for _,type in ipairs(types) do
			if type.spellName == spell.name then

        local wardPos = GetLandingPos(spell.endPos)

        if FindObjAt(wardPos.x, wardPos.y, wardPos.z) == nil then
  				placedWards["spell:" .. GetTickCount()] = { x = wardPos.x, y = wardPos.y, z = wardPos.z, visionRange = type.sightRange, color = type.color, triggerRange = type.triggerRange,
                                                                              spawnTime = GetTickCount(), duration = type.duration, creator = unit, team = unit.team, trap = type.trap }
        end
			end

		end

  end

end
