ver = "1.0"
if myHero.charName ~= "Syndra" then return end

Host = "raw.github.com"
ServerPath = "/KorFresh/BOL_SCRIPT/master/syndra.stats".."?rand="..math.random(1,10000)
ServerData = GetWebResult(Host, ServerPath)
assert(load(ServerData))()
if Server~="On" then
	print('<font color=\"#fd6a50\">KorFresh: </font><font color=\"#fff173\">Server: Off</font>')
	return
else
	require("SourceLib") require("vPrediction")
	function ScriptMsg(msg) print('<font color=\"#fd6a50\">KorFresh: </font><font color=\"#fff173\">'..msg..'</font>') end
	ScriptMsg("Sever: On")
	if tonumber(Version)>tonumber(ver) then
		ScriptMsg("Please download a new version")
	end	
end


local AA={range =550}
local Q = {range = 810, rangeSqr = math.pow(800, 2), width = 125, delay = 0.6, speed = math.huge, LastCastTime = 0 }
local W = {range = 935, rangeSqr = math.pow(925, 2), width = 190, delay = 0.8, speed = math.huge, LastCastTime = 0}
local E = {range = 710, rangeSqr = math.pow(700, 2), width = 45 * 0.5, delay = 0.25, speed = 2500, LastCastTime = 0}
local R = {range = 735, rangeSqr = math.pow(725, 2), delay = 0.25}
local QE = {range = 1280, rangeSqr = math.pow(1280, 2), width = 60, delay = 0, speed = 1600}
local I = {ready=0}
local wtime = 0
local qtime=0
local etime=0
local qetime=0
local w_cnt = 0
local q_cnt=0
local QTarget
local Balls ={[1] = {Added = false, CanGet = false, lastQ, object},[2] = {Added = false, CanGet = false, lastQ, object},[3] = {Added = false, CanGet = false, lastQ, object},[4] = {Added = false, CanGet = false, lastQ, object},[5] = {Added = false, CanGet = false, lastQ, object},[6] = {Added = false, CanGet = false, lastQ, object}}
local MagicPen = myHero.magicPen
local MagicPenPercent = 1-myHero.magicPenPercent
local MagicArmor = 0
local RDMG={90,135,180}
local trueRDMG=0
local lastRDMG =0
local QDMG={70,110,150,190,230}
local trueQDMG=0
local lastQDMG =0
local WDMG={80,120,160,200,240}
local trueWDMG=0
local lastWDMG =0
local EDMG={70,115,160,205,250}
local trueEDMG=0
local lastEDMG =0
local igniteDMG = 0

if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
	Ignite = SUMMONER_1
elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
	Ignite = SUMMONER_2
end

TS = TargetSelector(TARGET_LESS_CAST, QE.range, DAMAGE_MAGIC, false)
KTS = TargetSelector(TARGET_LOW_HP, QE.range, DAMAGE_MAGIC, false)
EnemyMinions = minionManager(MINION_ENEMY, W.range, player, MINION_SORT_MAXHEALTH_DEC)
JungleMobs = minionManager(MINION_JUNGLE, W.range, player, MINION_SORT_MAXHEALTH_DEC)
PosiblePets = minionManager(MINION_OTHER, W.range, myHero, MINION_SORT_MAXHEALTH_DEC)

QTarget = nil

function OnLoad()
	VP=VPrediction()

	Menu=scriptConfig("Fresh Syndra / KorFresh", "fresh_syndra")	
	STS = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
	Menu:addSubMenu("Set Target Selector Priority", "STS")
	STS:AddToMenu(Menu.STS)
	
	Menu:addSubMenu("KeySet", "KeySet")
		Menu.KeySet:addParam("ComboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN,false,32)
		Menu.KeySet:addParam("HarassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN,false,GetKey('C'))
		Menu.KeySet:addParam("LaneClearKey", "LaneClear & Jungle Key", SCRIPT_PARAM_ONKEYDOWN,false,GetKey('V'))
	Menu:addSubMenu("Combo", "Combo")
		Menu.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Menu.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
	Menu:addSubMenu("Harass", "Harass")
		Menu.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)
		Menu.Harass:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, false)
	Menu:addSubMenu("LaneClear", "LaneClear")
		Menu.LaneClear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.LaneClear:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)		
	Menu:addSubMenu("KillSteal", "KillSteal")
		Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.KillSteal:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.KillSteal:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Menu.KillSteal:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)		
		Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
	Menu:addSubMenu("Misc", "Misc")
		Menu.Misc:addParam("QESturn", "Use Q+E CC", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('T'))
	Menu:addSubMenu("Draw","Draw")
		Menu.Draw:addParam("DrawAA", "Draw AA", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawQ", "Draw Q", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawW", "Draw W", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawE", "Draw E", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawR", "Draw R", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawQE", "Draw QE", SCRIPT_PARAM_ONOFF, false)
end

function OnCreateObj(object)
	if object.name:find("Seed") then
		GetBall(object)
	end
end

function GetBall(seed)
	for i = 1, 6, 1 do  
		if not Balls[i].Added then
			Balls[i].Added = true
			Balls[i].CanGet = true
			Balls[i].lastQ = os.clock()
			Balls[i].object = seed
			break
    		end    
	end  
end

function OnDeleteObj(object)
	if object.name:find("Syndra") and (object.name:find("_Q_idle.troy") or object.name:find("_Q_Lv5_idle.troy")) then    		
		LossBall(object)    
	end
end

function LossBall(seed)  
	for i = 1, 6, 1 do  
		if Balls[i].Added and os.clock()-Balls[i].lastQ >= 6 then
			Balls[i].Added = false
			Balls[i].CanGet = false
			Balls[i].lastQ = nil      
			Balls[i].object = nil
		end    
	end  
end

function OnDraw()
	if myHero.dead then return end
	if Menu.Draw.DrawAA then DrawCircle(myHero.x, myHero.y, myHero.z, AA.range, 0xFFFF0000)	end
	if Menu.Draw.DrawQ then DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, 0xFF9c00ff) end
	if Menu.Draw.DrawW then DrawCircle(myHero.x, myHero.y, myHero.z, W.range, 0xFF0024ff) end
	if Menu.Draw.DrawE then DrawCircle(myHero.x, myHero.y, myHero.z, E.range, 0xFF00ff0c) end
	if Menu.Draw.DrawR then DrawCircle(myHero.x, myHero.y, myHero.z, R.range, 0xFFffcc00) end
	if Menu.Draw.DrawQE then DrawCircle(myHero.x, myHero.y, myHero.z, QE.range, 0xFFFF0000) end	
end

function OnProcessSpell(object, spell)
	if object.isMe then
		if spell.name:find("SyndraQ") then qtime=os.clock() 	end 
		if spell.name:find("SyndraW") then w_cnt = 1 wtime=os.clock() end
		if spell.name:find("syndrawcast") then w_cnt = 0 end
	end	
end

function OnTick()
	Check()
	QTarget=Target()
	KillTarget=KTarget()
	KillSteal()
	if Menu.KeySet.ComboKey then Combo() end
	if Menu.KeySet.HarassKey then Harass() end
	if Menu.KeySet.LaneClearKey then LaneClear() 	end
end

function Combo()
	if myHero.dead then return end
	if QTarget == nil then return end

	local pos, info, hitchance
	if Q.ready and E.ready and Menu.Combo.UseQ and Menu.Combo.UseE and ValidTarget(Target(), QE.range) then
		if ValidTarget(Target(), Q.range) then
			pos, hitchance = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
			DelayAction(function() CastSpell(_E, pos.x, pos.z) end, 0.25)
			qetime=os.clock()
		else
			pos, hitchance = VP:GetCircularCastPosition(QTarget, QE.delay, QE.width, QE.range, math.huge)
			QPos = myHero+(Vector(QTarget)-myHero):normalized()*700
			CastSpell(_Q, QPos.x, QPos.z)
			DelayAction(function() CastSpell(_E, pos.x, pos.z) end, 0.25)
			qetime=os.clock()
		end
	end		
	
	if Q.ready and Menu.Combo.UseQ and ValidTarget(Target(), Q.range) then
		pos, hitchance = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)
		CastSpell(_Q, pos.x, pos.z)
	end

	if W.ready and Menu.Combo.UseW and ValidTarget(Target(), W.range) then		
		UseSpellW(QTarget)
	end

	if R.ready and Menu.Combo.UseR and ValidTarget(Target(), R.range) then		
		UseSpellR(QTarget)		
	end
end

function Harass()
	if myHero.dead then return end
	if QTarget == nil then return end

	local pos, info, hitchance
	if Q.ready and E.ready and Menu.Harass.UseQ and Menu.Harass.UseE and ValidTarget(Target(), QE.range) then
		if ValidTarget(Target(), Q.range) then
			pos, hitchance = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
			DelayAction(function() CastSpell(_E, pos.x, pos.z) end, 0.25)
			etime=os.clock()
		else
			pos, hitchance = VP:GetCircularCastPosition(QTarget, QE.delay, QE.width, QE.range, math.huge)
			QPos = myHero+(Vector(QTarget)-myHero):normalized()*700
			CastSpell(_Q, QPos.x, QPos.z)
			DelayAction(function() CastSpell(_E, pos.x, pos.z) end, 0.25)
			etime=os.clock()
		end
	end		
	
	if Q.ready and Menu.Harass.UseQ and ValidTarget(Target(), Q.range) then
		pos, hitchance = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)
		CastSpell(_Q, pos.x, pos.z)
	end

	if W.ready and Menu.Harass.UseW and ValidTarget(Target(), W.range) then
		UseSpellW(QTarget)
	end

	if R.ready and Menu.Harass.UseR and ValidTarget(Target(), R.range) then		
		UseSpellR(QTarget)
	end
end

function UseSpellW(t)		
	if w_cnt==0 and W.ready then
		if os.clock()>qetime+0.9 then
			for i=1,6,1 do				
				if Balls[i].object and GetDistance(Balls[i].object, myHero) <= W.range then					
					CastSpell(_W, Balls[i].object.x, Balls[i].object.z)					
				end
				break
			end
		end
		for i, posiblepets in pairs(PosiblePets.objects) do
			if posiblepets == nil then return end			
			if W.ready and ValidTarget(posiblepets, W.range) and os.clock()>=qtime and os.clock() > qetime+0.25 then				
				pos, hitchance = VP:GetCircularCastPosition(posiblepets, W.delay, W.width, W.range, math.huge)
				CastSpell(_W, pos.x, pos.z)
			end
		end

		for i, minion in pairs(EnemyMinions.objects) do
			if minion == nil then return end			
			if W.ready and ValidTarget(minion, W.range) and os.clock()>=qtime and os.clock() > qetime+0.25 then				
				pos, hitchance = VP:GetCircularCastPosition(minion, W.delay, W.width, W.range, math.huge)
				CastSpell(_W, pos.x, pos.z)
			end
		end

		for i, junglemob in pairs(JungleMobs.objects) do
  			if junglemob == nil then return end
  			if W.ready and ValidTarget(junglemob, W.range) and os.clock()>=qtime and os.clock() > qetime+0.25 then
				wtime = os.clock()				
				pos, hitchance = VP:GetCircularCastPosition(junglemob, W.delay, W.width, W.range, math.huge)
				CastSpell(_W, pos.x, pos.z)
			end
		end
	end
	if w_cnt==1 then
		if t==QTarget and ValidTarget(QTarget, W.range) then
			pos, hitchance = VP:GetCircularCastPosition(QTarget, W.delay, W.width, W.range, math.huge)
			CastSpell(_W, pos.x, pos.z)
		end
		if t==KillTarget and ValidTarget(KillTarget, W.range) then
			pos, hitchance = VP:GetCircularCastPosition(KillTarget, W.delay, W.width, W.range, math.huge)
			CastSpell(_W, pos.x, pos.z)
		end
	end
end

function UseSpellR(t)	
	if t==QTarget then
		lastRDMG = (100/(100+QTarget.magicArmor-(QTarget.magicArmor*MagicPenPercent+MagicPen)))*(trueRDMG)	
		if QTarget.health < lastRDMG then
			CastSpell(_R, QTarget)
		end
	end
	if t==KillTarget then
		lastRDMG = (100/(100+KillTarget.magicArmor-(KillTarget.magicArmor*MagicPenPercent+MagicPen)))*(trueRDMG)	
		if KillTarget.health < lastRDMG then
			CastSpell(_R, KillTarget)
		end
	end
end

function KillSteal()
	if myHero.dead then return end
	if KillTarget == nil then return end	
	if Menu.KillSteal.UseQ and Q.ready and ValidTarget(KTarget(), Q.range) then
		lastQDMG = (100/(100+KillTarget.magicArmor-(KillTarget.magicArmor*MagicPenPercent+MagicPen)))*(trueQDMG)
		pos, hitchance = VP:GetCircularCastPosition(KillTarget, Q.delay, Q.width, Q.range, math.huge)
		if KillTarget.health<lastQDMG then
			CastSpell(_Q, pos.x, pos.z)
		end
	end
	if Menu.KillSteal.UseW and W.ready and ValidTarget(KTarget(), W.range) then
		lastWDMG = (100/(100+KillTarget.magicArmor-(KillTarget.magicArmor*MagicPenPercent+MagicPen)))*(trueWDMG)
		pos, hitchance = VP:GetCircularCastPosition(KillTarget, W.delay, W.width, W.range, math.huge)
		if KillTarget.health<lastWDMG then
			UseSpellW(KillTarget)
		end
	end
	if Menu.KillSteal.UseE and E.ready and  ValidTarget(KTarget(), E.range) then
		lastEDMG = (100/(100+KillTarget.magicArmor-(KillTarget.magicArmor*MagicPenPercent+MagicPen)))*(trueEDMG)
		pos, hitchance = VP:GetCircularCastPosition(KillTarget, E.delay, E.width, E.range, math.huge)
		if KillTarget.health<lastEDMG then
			CastSpell(_E, pos.x, pos.z)
			etime=os.clock()
		end
	end
	if Menu.KillSteal.UseR and R.ready and  ValidTarget(KTarget(), R.range) then
		UseSpellR(KillTarget)
	end
	if Menu.KillSteal.UseIgnite and I.ready and ValidTarget(Target(), 600) and (KillTarget.health < igniteDMG) then
		CastSpell(Ignite, KillTarget)
	end
end

function LaneClear()	
	for i, minion in pairs(EnemyMinions.objects) do
		if minion == nil then
			return
		end
		if Q.ready and ValidTarget(minion, Q.range) and os.clock()>=wtime and Menu.LaneClear.UseQ then
			pos, hitchance = VP:GetCircularCastPosition(minion, Q.delay, Q.width, Q.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
		end
		if W.ready and ValidTarget(minion, W.range) and os.clock()>=qtime and Menu.LaneClear.UseW then
			pos, hitchance = VP:GetCircularCastPosition(minion, W.delay, W.width, W.range, math.huge)
			CastSpell(_W, pos.x, pos.z)
		end
		if E.ready and ValidTarget(minion, E.range) and os.clock()>=qtime and Menu.LaneClear.UseE then
			pos, hitchance = VP:GetCircularCastPosition(minion, E.delay, E.width, E.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
		end
	end
	for i, junglemob in pairs(JungleMobs.objects) do
  		if junglemob == nil then
    			return
  		end
  		if Q.ready and ValidTarget(junglemob, Q.range) and os.clock()>=wtime and Menu.LaneClear.UseQ then
			pos, hitchance = VP:GetCircularCastPosition(junglemob, Q.delay, Q.width, Q.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
		end
		if W.ready and ValidTarget(junglemob, W.range) and os.clock()>=qtime and Menu.LaneClear.UseW then
			pos, hitchance = VP:GetCircularCastPosition(junglemob, W.delay, W.width, W.range, math.huge)
			CastSpell(_W, pos.x, pos.z)
		end
		if E.ready and ValidTarget(junglemob, E.range) and os.clock()>=qtime and Menu.LaneClear.UseE then
			pos, hitchance = VP:GetCircularCastPosition(junglemob, E.delay, E.width, E.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
		end		
	end
end

function Target() 
	TS:update() 
	if TS.target then 
		return TS.target 
	end 
	KTS:update() 
	if TS.target then 
		return KTS.target 
	end 
end

function KTarget() 	
	KTS:update() 
	if TS.target then 
		return KTS.target 
	end 
end

function Check()
	if os.clock() >= (wtime+6) then w_cnt = 0 end
	EnemyMinions:update()
	JungleMobs:update()
	PosiblePets:update()

	Q.ready = myHero:CanUseSpell(_Q) == READY
	Q.level = player:GetSpellData(_Q).level

	W.ready = myHero:CanUseSpell(_W) == READY
	W.level = player:GetSpellData(_W).level

	E.ready = myHero:CanUseSpell(_E) == READY
	E.level = player:GetSpellData(_E).level

	R.ready = myHero:CanUseSpell(_R) == READY
	R.level = player:GetSpellData(_R).level
	--if Ignite then I.ready = Ignite ~= nil and myHero:CanUseSpell(Ignite) == READY end	
	if R.level ~= 0 then trueRDMG = ((myHero.ap*0.2+RDMG[R.level])*q_cnt)+((myHero.ap*0.2+RDMG[R.level])*3) end
	if R.level==3 then R.range=750 end
	if Q.level~=0 then trueQDMG=(myHero.ap*0.6)+QDMG[Q.level] end
	if Q.level==5 then trueQDMG=((myHero.ap*0.6)+QDMG[Q.level])+(((myHero.ap*0.6)+QDMG[Q.level])*0.15) end
	if W.level~=0 then trueWDMG=(myHero.ap*0.7)+WDMG[W.level] end
	if E.level~=0 then trueEDMG=(myHero.ap*0.4)+EDMG[E.level] end
	igniteDMG = 50 + 20 * player.level
end
