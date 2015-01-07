ver = "1.00"
if myHero.charName ~= "Zyra" then return end

Host = "raw.github.com"
ServerPath = "/KorFresh/BOL_SCRIPT/master/Zyra.stats".."?rand="..math.random(1,10000)
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

AA={range =575}
Q = {range = 830, rangeSqr = math.pow(800, 2), width = 85, delay = 0, speed = math.huge, LastCastTime = 0 }
W = {range = 880, rangeSqr = math.pow(925, 2), width = 0, delay = 0, speed = math.huge, LastCastTime = 0}
E = {range = 1180, rangeSqr = math.pow(700, 2), width = 70, delay = 0, speed = 1400, LastCastTime = 0}
R = {range = 730, rangeSqr = math.pow(725, 2), width = 70, delay = 0, speed = 1900, LastCastTime =0}
P = {range = 830, rangeSqr = math.pow(800, 2), width = 85, delay = 0, speed = math.huge, LastCastTime = 0 }

MagicPen = myHero.magicPen
MagicPenPercent = 1-myHero.magicPenPercent
MagicArmor = 0

QDMG={70,105,140,175,210}
WDMG={80,120,160,200,240}
EDMG={60,95,130,165,200}
RDMG={180,265,350}
igniteDMG = 0

ppos=false

if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
	Ignite = SUMMONER_1
elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
	Ignite = SUMMONER_2
end

QTS = TargetSelector(TARGET_LESS_CAST_PRIORITY, Q.range, DAMAGE_MAGIC, false)
WTS = TargetSelector(TARGET_LESS_CAST_PRIORITY, W.range, DAMAGE_MAGIC, false)
ETS = TargetSelector(TARGET_LESS_CAST_PRIORITY, E.range, DAMAGE_MAGIC, false)
RTS = TargetSelector(TARGET_LESS_CAST_PRIORITY, R.range, DAMAGE_MAGIC, false)
PTS = TargetSelector(TARGET_LESS_CAST_PRIORITY, P.range, DAMAGE_MAGIC, false)
KTS = TargetSelector(TARGET_LOW_HP, Q.range, DAMAGE_MAGIC, false)

EnemyMinions = minionManager(MINION_ENEMY, E.range, player, MINION_SORT_MAXHEALTH_DEC)
JungleMobs = minionManager(MINION_JUNGLE, E.range, player, MINION_SORT_MAXHEALTH_DEC)
PosiblePets = minionManager(MINION_OTHER, E.range, myHero, MINION_SORT_MAXHEALTH_DEC)

function OnLoad()
	VP=VPrediction()

	Menu=scriptConfig("Fresh Zyra / KorFresh", "fresh_zyra")	
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
		Menu.LaneClear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, false)		
	Menu:addSubMenu("KillSteal", "KillSteal")
		Menu.KillSteal:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Menu.KillSteal:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
		Menu.KillSteal:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
		Menu.KillSteal:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)		
		Menu.KillSteal:addParam("UseIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)	
	Menu:addSubMenu("Misc","Misc")
		Menu.Misc:addParam("Debug", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
		Menu.Misc:addParam("UltHit", "Ult HitNumber", SCRIPT_PARAM_SLICE,1,1,5,0)
	Menu:addSubMenu("Draw","Draw")
		Menu.Draw:addParam("DrawAA", "Draw AA", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawQ", "Draw Q", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawW", "Draw W", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawE", "Draw E", SCRIPT_PARAM_ONOFF, false)
		Menu.Draw:addParam("DrawR", "Draw R", SCRIPT_PARAM_ONOFF, false)
end

function OnProcessSpell(object, spell)
	if object.isMe then
		if spell.name:find("SyndraQ") then
			qtime=os.clock()
		end 		
	end
end

function OnCreateObj(object)
	--if object.name:find("Seed") then	
	--end
end

function OnDeleteObj(object)	
end

function Check()
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
	
	igniteDMG = 50 + 20 * player.level
end

function OnDraw()
	if myHero.dead then return end
	if Menu.Draw.DrawAA then DrawCircle(myHero.x, myHero.y, myHero.z, AA.range, 0xFFFF0000)	end
	if Menu.Draw.DrawQ then DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, 0xFF9c00ff) end
	if Menu.Draw.DrawW then DrawCircle(myHero.x, myHero.y, myHero.z, W.range, 0xFF0024ff) end
	if Menu.Draw.DrawE then DrawCircle(myHero.x, myHero.y, myHero.z, E.range, 0xFF00ff0c) end
	if Menu.Draw.DrawR then DrawCircle(myHero.x, myHero.y, myHero.z, R.range, 0xFFffcc00) end	
	if Menu.Misc.Debug then		
		if Q.ready then
			DrawText("Q: READY", 20, 600, 300, ARGB(255, 255, 255, 255))
		else
			DrawText("Q: Wait", 20, 600, 300, ARGB(255, 255, 255, 255))
		end
		if QTarget then
			DrawText("Q Target: "..QTarget.charName, 20, 600, 320, ARGB(255, 255, 255, 255))			
		else
			DrawText("Q Target: Nil", 20, 600, 320, ARGB(255, 255, 255, 255))
		end
		if W.ready then
			DrawText("W: READY", 20, 600, 360, ARGB(255, 255, 255, 255))
		else
			DrawText("W: Wait", 20, 600, 360, ARGB(255, 255, 255, 255))
		end
		if WTarget then
			DrawText("W Target: "..WTarget.charName, 20, 600, 380, ARGB(255, 255, 255, 255))
		else
			DrawText("W Target: Nil", 20, 600, 380, ARGB(255, 255, 255, 255))
		end
		if E.ready then
			DrawText("E: READY", 20, 600, 420, ARGB(255, 255, 255, 255))
		else
			DrawText("E: Wait", 20, 600, 420, ARGB(255, 255, 255, 255))
		end
		if ETarget then
			DrawText("E Target: "..ETarget.charName, 20, 600, 440, ARGB(255, 255, 255, 255))
		else
			DrawText("E Target: Nil", 20, 600, 440, ARGB(255, 255, 255, 255))
		end
		if R.ready then
			DrawText("R: READY", 20, 600, 480, ARGB(255, 255, 255, 255))
		else
			DrawText("R: Wait", 20, 600, 480, ARGB(255, 255, 255, 255))
		end
		if RTarget then
			DrawText("R Target: "..RTarget.charName, 20, 600, 500, ARGB(255, 255, 255, 255))
		else
			DrawText("R Target: Nil", 20, 600, 500, ARGB(255, 255, 255, 255))			
		end			
	end
end

function OnTick()
	Check()
	QTarget=Target(Q)
	WTarget=Target(W)
	ETarget=Target(E)
	RTarget=Target(R)
	if Menu.KeySet.ComboKey then Combo() end
	if Menu.KeySet.HarassKey then Harass() end
	if Menu.KeySet.LaneClearKey then LaneClear() end
end

function Combo()
	if myHero.dead then return end
	if QTarget == nil and ETarget == nil and RTarget == nil then return end
	if E.ready and Menu.Combo.UseE and ValidTarget(ETarget, E.range) and Q.ready and Menu.Combo.UseQ and ValidTarget(QTarget, Q.range) then
		UseSpell(Q)
	end
	if E.ready and Menu.Combo.UseE and ValidTarget(ETarget, E.range) then
		UseSpell(E)
	end
	if Q.ready and Menu.Combo.UseQ and ValidTarget(QTarget, Q.range) then
		UseSpell(Q)
	end
	if R.ready and Menu.Combo.UseR and ValidTarget(RTarget, R.range) then		
		UseSpell(R)
	end
end

function Harass()
	if myHero.dead then return end
	if QTarget == nil and ETarget == nil and RTarget == nil then return end
	if E.ready and Menu.Harass.UseE and ValidTarget(ETarget, E.range) and Q.ready and Menu.Harass.UseQ and ValidTarget(QTarget, Q.range) then
		pos, hitchance = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)		
		CastSpell(_Q, pos.x, pos.z)		
		if Menu.Combo.UseW then
			if W.ready then
				CastSpell(_W, pos.x, pos.z)
				DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.25)
				DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.5)				
			end
		end
	end
	if E.ready and Menu.Harass.UseE and ValidTarget(ETarget, E.range) then
		pos, hitchance = VP:GetLineCastPosition(ETarget, E.delay, E.width, E.range, math.huge)
		CastSpell(_E, pos.x, pos.z)
		if Menu.Combo.UseW then
			CastSpell(_W, pos.x, pos.z)
			DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.25)
			DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.5)
		end
	end
	if Q.ready and Menu.Harass.UseQ and ValidTarget(QTarget, Q.range) then
		pos, hitchance = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)		
		CastSpell(_Q, pos.x, pos.z)		
		if Menu.Combo.UseW then
			if W.ready then
				CastSpell(_W, pos.x, pos.z)
				DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.25)
				DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.5)				
			end
		end
	end
	if R.ready and Menu.Harass.UseR and ValidTarget(RTarget, R.range) then		
		UseSpell(R)
	end
end

function LaneClear()	
	for i, minion in pairs(EnemyMinions.objects) do
		if minion == nil then
			return
		end
		if Q.ready and ValidTarget(minion, Q.range) and Menu.LaneClear.UseQ then
			pos, hitchance = VP:GetCircularCastPosition(minion, Q.delay, Q.width, Q.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
		end		
		if E.ready and ValidTarget(minion, E.range) and Menu.LaneClear.UseE then
			pos, hitchance = VP:GetLineCastPosition(minion, E.delay, E.width, E.range, math.huge)
			CastSpell(_E, pos.x, pos.z)
		end
	end
	for i, junglemob in pairs(JungleMobs.objects) do
  		if junglemob == nil then
    			return
  		end
  		if Q.ready and ValidTarget(junglemob, Q.range) and Menu.LaneClear.UseQ then
			pos, hitchance = VP:GetCircularCastPosition(junglemob, Q.delay, Q.width, Q.range, math.huge)
			CastSpell(_Q, pos.x, pos.z)
		end		
		if E.ready and ValidTarget(junglemob, E.range) and Menu.LaneClear.UseE then
			pos, hitchance = VP:GetLineCastPosition(junglemob, E.delay, E.width, E.range, math.huge)
			CastSpell(_E, pos.x, pos.z)
		end		
	end
end

function Target(spell) 
	if spell==Q then		
		QTS:update()		
		if QTS.target then
			return QTS.target
		end
	end
	if spell==W then
		WTS:update()
		if WTS.target then
			return WTS.target
		end
	end
	if spell==E then
		ETS:update()
		if ETS.target then
			return ETS.target
		end
	end
	if spell==R then
		RTS:update()
		if RTS.target then
			return RTS.target
		end
	end
	if spell==P then
		PTS:update()
		if PTS.target then
			return PTS.target
		end
	end
end

function UseSpell(spell)
	if spell==Q then
		pos, hitchance, NT = VP:GetCircularCastPosition(QTarget, Q.delay, Q.width, Q.range, math.huge)
		CastSpell(_Q, pos.x, pos.z)		
		if Menu.Combo.UseW then
			if W.ready then
				CastSpell(_W, pos.x, pos.z)
				DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.25)
				DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.5)				
			end
		end
	end
	if spell==E then
		pos, hitchance = VP:GetLineCastPosition(ETarget, E.delay, E.width, E.range, math.huge)
		CastSpell(_E, pos.x, pos.z)
		if Menu.Combo.UseW then
			CastSpell(_W, pos.x, pos.z)
			DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.25)
			DelayAction(function() CastSpell(_W, pos.x, pos.z) end, 0.5)
		end
	end
	if spell==R then
		pos, hitchance, NT = VP:GetCircularCastPosition(RTarget, R.delay, R.width, R.range, math.huge)
		CastSpell(_R, pos.x, pos.z)
	end
end
