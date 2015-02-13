ver = "1.007"

Host = "raw.github.com"
ServerPath = "/KorFresh/BOL_SCRIPT/master/Vator.stats".."?rand="..math.random(1,10000)
ServerData = GetWebResult(Host, ServerPath)
assert(load(ServerData))()
if Server~="On" then
	print('<font color=\"#fd6a50\">KorFresh: </font><font color=\"#fff173\">Server: Off</font>')
	return
else
	require("SourceLib")
	function ScriptMsg(msg) print('<font color=\"#fd6a50\">KorFresh: </font><font color=\"#fff173\">'..msg..'</font>') end
	ScriptMsg("Sever: On")
	if tonumber(Version)>tonumber(ver) then
		ScriptMsg("Please download a new version")
	end	
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("SFIGHLMMILI") 

KTS = TargetSelector(TARGET_LOW_HP, 730, DAMAGE_MAGIC, false) KTarget=nil STarget=nil
STS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 730, DAMAGE_PHYSICAL, false)

SpellType = {
	[1]={name="summonerdot", add=true, range=560, kname="점화"},
	[2]={name="summonerflash", add=false, range=400, kname="점멸"},
	[3]={name="summonerheal", add=true, range=790, kname="회복"},
	[4]={name="summonerbarrier", add=true, range=0, kname="방어막"},
	[5]={name="summonermana", add=true, range=0, kname="총명"},	
	[6]={name="summonerboost", add=true, range=0, kname="정화"},	
	[7]={name="summonersmite", add=true, range=700, kname="강타"},
	[8]={name="summonerexhaust", add=true, range=600, kname="탈진"}
}
Left = myHero:GetSpellData(SUMMONER_1) Right = myHero:GetSpellData(SUMMONER_2) JungleMobs = minionManager(MINION_JUNGLE, 760, player, MINION_SORT_MAXHEALTH_DEC)
--print(Left.name)
for i=1, 8, 1 do 
	if Left.name == SpellType[i].name then 
		Left = SpellType[i]
		if Left.name == "summonerboost" then spell_boost = SUMMONER_1 end
		if Left.name == "summonerbarrier" then spell_barrier = SUMMONER_1 end
		if Left.name == "summonerdot" then spell_dot = SUMMONER_1 end
		if Left.name == "summonerheal" then spell_heal = SUMMONER_1 end
		if Left.name == "summonersmite" then spell_smite = SUMMONER_1 end
		if Left.name == "summonerboost" then spell_boost = SUMMONER_1 end
		if Left.name == "s5_summonersmiteplayerganker" then spell_smite = SUMMONER_1 end
		if Left.name == "s5_summonersmiteduel" then spell_smite = SUMMONER_1 end
		if Left.name == "itemsmiteaoe" then spell_smite = SUMMONER_1 end
		if Left.name == "s5_summonersmitequick" then spell_smite = SUMMONER_1 end
		break 
	end 
end

for i=1, 8, 1 do 
	if Right.name == SpellType[i].name then 
		Right = SpellType[i]
		if Right.name == "summonerboost" then spell_boost = SUMMONER_2 end
		if Right.name == "summonerbarrier" then spell_barrier = SUMMONER_2 end
		if Right.name == "summonerdot" then spell_dot = SUMMONER_2 end
		if Right.name == "summonerheal" then spell_heal = SUMMONER_2 end
		if Right.name == "summonersmite" then spell_smite = SUMMONER_2 end 
		if Right.name == "summonerboost" then spell_boost = SUMMONER_2 end
		if Right.name == "s5_summonersmiteplayerganker" then spell_smite = SUMMONER_2 end
		if Right.name == "s5_summonersmiteduel" then spell_smite = SUMMONER_2 end
		if Right.name == "itemsmiteaoe" then spell_smite = SUMMONER_2 end
		if Right.name == "s5_summonersmitequick" then spell_smite = SUMMONER_2 end
		break 
	end 
end

if Left.name == "s5_summonersmiteplayerganker" or Left.name == "s5_summonersmiteduel" or Left.name == "itemsmiteaoe" or Left.name == "s5_summonersmitequick" then Left=SpellType[7] spell_smite=SUMMONER_1 end
if Right.name == "s5_summonersmiteplayerganker" or Right.name == "s5_summonersmiteduel" or Right.name == "itemsmiteaoe" or Right.name == "s5_summonersmitequick" then Right=SpellType[7] spell_smite=SUMMONER_2 end

health_potion_time=0 mana_potion_time=0 flask_potion_time=0 boostbuffname=0 boostbufftype=0 boostbufftime=0 debufftime=0 QuicksilverSash_menu=false morebufftype=0 morebufftime=0 Muramana_time=0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnLoad()	
	Menu=scriptConfig("FreshVator / KorFresh", "FreshVator")	
	Menu:addSubMenu("Language", "Language")
		Menu.Language:addParam("Language", "Language", SCRIPT_PARAM_LIST, 2, { "Korean", "English"})
	Menu:addSubMenu("Draw", "Draw")
		if Left and Left.kname then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("leftspell", Left.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("leftspell", Left.name, SCRIPT_PARAM_ONOFF, true)
			end
		end
		if Right and Right.kname then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("rightspell", Right.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("rightspell", Right.name, SCRIPT_PARAM_ONOFF, true)
			end
		end	
	if Menu.Language.Language==1 then
		Menu:addSubMenu("이동경로 표시", "movepath")
			Menu.movepath:addParam("me", "나", SCRIPT_PARAM_ONOFF, true)
			Menu.movepath:addParam("enemy", "적군", SCRIPT_PARAM_ONOFF, true)			
	else
		Menu:addSubMenu("MovePath Tracker", "movepath")
			Menu.movepath:addParam("me", "Me", SCRIPT_PARAM_ONOFF, true)
			Menu.movepath:addParam("enemy", "Enemy", SCRIPT_PARAM_ONOFF, true)			
	end
	if Menu.Language.Language==1 then
		Menu:addSubMenu("물약", "posion")
			Menu.posion:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)
			Menu.posion:addParam("health", "체력 % 이하일 때", SCRIPT_PARAM_SLICE, 50, 0, 100)
			Menu.posion:addParam("mana", "마나 % 이하일 때", SCRIPT_PARAM_SLICE, 50, 0, 100)
	else
		Menu:addSubMenu("posion", "posion")
			Menu.posion:addParam("autouse", "autouse", SCRIPT_PARAM_ONOFF, true)
			Menu.posion:addParam("health", "Health % Below", SCRIPT_PARAM_SLICE, 50, 0, 100)
			Menu.posion:addParam("mana", "Mana % Below", SCRIPT_PARAM_SLICE, 50, 0, 100)
	end
	
	if spell_boost then
		if Menu.Language.Language==1 then
			Menu:addSubMenu("정화", "boost")
				Menu.boost:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)
				Menu.boost:addParam("boost", "딜레이(초)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)				
		else
			Menu:addSubMenu("Boost", "boost")
				Menu.boost:addParam("autouse", "autouse", SCRIPT_PARAM_ONOFF, true)						
				Menu.boost:addParam("boost", "delay(sec)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
		end
	end
	if spell_barrier then
		if Menu.Language.Language==1 then
			Menu:addSubMenu("방어막", "barrier")
				Menu.barrier:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)						
				Menu.barrier:addParam("barrierrate", "체력 % 이하일 때", SCRIPT_PARAM_SLICE, 15, 0, 100)
		else
			Menu:addSubMenu("Barrier", "barrier")
				Menu.barrier:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)				
				Menu.barrier:addParam("barrierrate", "Health % Below", SCRIPT_PARAM_SLICE, 15, 0, 100)
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") or myHero:GetSpellData(SUMMONER_2).name:find("summonerheal") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("회복", "heal")
				Menu.heal:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)		
				Menu.heal:addParam("selheal", "사용대상", SCRIPT_PARAM_LIST, 2, { "나만", "아군"})		
				Menu.heal:addParam("healrate", "체력 % 이하일 때", SCRIPT_PARAM_SLICE, 15, 0, 100)
		else
			Menu:addSubMenu("heal", "heal")
				Menu.heal:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
				Menu.heal:addParam("selheal", "For Use", SCRIPT_PARAM_LIST, 2, { "Olny Me", "My Team"})		
				Menu.heal:addParam("healrate", "Me/Team Health % Below", SCRIPT_PARAM_SLICE, 15, 0, 100)
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerexhaust") or myHero:GetSpellData(SUMMONER_2).name:find("summonerexhaust") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("탈진", "exhaust")
				Menu.exhaust:addParam("autouse", "자동사용", SCRIPT_PARAM_ONKEYDOWN,false,32)
				for i, enemy in ipairs(GetEnemyHeroes()) do
					Menu.exhaust:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, true)
				end
		else
			Menu:addSubMenu("exhaust", "exhaust")
				Menu.exhaust:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONKEYDOWN,false,32)
				for i, enemy in ipairs(GetEnemyHeroes()) do
					Menu.exhaust:addParam(enemy.hash, enemy.charName, SCRIPT_PARAM_ONOFF, true)
				end
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") or myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("점화", "ignite")
				Menu.ignite:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)
		else
			Menu:addSubMenu("ignite", "ignite")
				Menu.ignite:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
		end
	end	
	if spell_smite then		
		if Menu.Language.Language==1 then
			Menu:addSubMenu("강타", "smite")
				Menu.smite:addParam("autouse", "자동사용", SCRIPT_PARAM_ONKEYTOGGLE,true,GetKey('G'))				
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite0", "대상: 챔피언 CC", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite00", "대상: 챔피언 막타", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite1", "바론", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite2", "드래곤", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite3", "개구리(바론/드래곤)", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite4", "블루팀 전체", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite5", "레드", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite6", "블루", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite7", "두꺼비", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite8", "늑대", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite9", "독수리", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite10", "골렘", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite11", "레드팀 전체", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite12", "레드", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite13", "블루（", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite14", "두꺼비", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite15", "늑대", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite16", "독수리", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite17", "골렘", SCRIPT_PARAM_ONOFF, true)
		else
			Menu:addSubMenu("smite", "smite")
				Menu.smite:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite0", "Object: Champion CC", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite00", "Object: Champion LastHit", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite1", "Baron", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite2", "Dragon", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite3", "Crab(Baron/Dragon)", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite4", "Full Blue Camp", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite5", "Red", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite6", "Blue", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite7", "Gromp", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite8", "Wolf", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite9", "Beak", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite10", "Krug", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite11", "Full Red Camp", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite12", "Red", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite13", "Blue", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite14", "Gromp", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite15", "Wolf", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite16", "Beak", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite17", "Krug", SCRIPT_PARAM_ONOFF, true)
		end
	end
end

function OnDraw()
	if myHero.dead then return end
	if Menu.Draw.leftspell then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, Left.range, 1, ARGB(200, 0, 255, 0), 50)
	end
	if Menu.Draw.rightspell then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, Right.range, 1, ARGB(200, 255, 0, 0), 50)	
	end
	if Menu.movepath.me then
		if myHero.hasMovePath and myHero.pathCount >= 2 then
		local IndexPath = myHero:GetPath(myHero.pathIndex)
		if IndexPath then
			DrawLine3D(myHero.x, myHero.y, myHero.z, IndexPath.x, IndexPath.y, IndexPath.z, 1, ARGB(255, 0, 255, 255))
			for i=myHero.pathIndex, myHero.pathCount-1 do
				local Path = myHero:GetPath(i)
				local Path2 = myHero:GetPath(i+1)
				--self.DLine(Vector(myHero:GetPath(i).x, myHero.y, myHero:GetPath(i).y), Vector(myHero:GetPath(i+1).x, myHero.y, myHero:GetPath(i+1).y), ARGB(255, 255, 255, 255))
				DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 0))
			end
		end
	end
	end
	if Menu.movepath.enemy then
		for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy, 3000) then
			if enemy.hasMovePath and enemy.pathCount >= 2 then				
				local enemyIndexPath = enemy:GetPath(enemy.pathIndex)
				if enemyIndexPath then
					DrawLine3D(enemy.x, enemy.y, enemy.z, enemyIndexPath.x, enemyIndexPath.y, enemyIndexPath.z, 1, ARGB(255, 255, 0, 0))
					for i=enemy.pathIndex, enemy.pathCount-1 do
						local Path = enemy:GetPath(i)
						local Path2 = enemy:GetPath(i+1)
						--self.DLine(Vector(myHero:GetPath(i).x, myHero.y, myHero:GetPath(i).y), Vector(myHero:GetPath(i+1).x, myHero.y, myHero:GetPath(i+1).y), ARGB(255, 255, 255, 255))
						DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 0))
					end
				end
			end
		end
	end
	end
end

function OnTick()
	if myHero.dead then return end
	Check()

	if ItemSeraphsEmbrace and myHero:CanUseSpell(ItemSeraphsEmbrace)==READY and Menu.ItemSeraphsEmbrace.autouse then
		if myHero.health/myHero.maxHealth*100 <=Menu.ItemSeraphsEmbrace.ItemSeraphsEmbrace then
			CastSpell(ItemSeraphsEmbrace)
		end
	end
	
	if Muramana then
		if Menu.Muramana.autouse and not Muramana_auto and Muramana_time < os.clock() then
			Muramana_auto = true
			Muramana_time = os.clock()+1.5
			CastSpell(Muramana)
			--print("1")
		end
		if not Menu.Muramana.autouse and Muramana_auto and Muramana_time < os.clock() then
			Muramana_auto = false
			CastSpell(Muramana)
			Muramana_time = os.clock()+1.5
			--print("2")
		end
	end
	
	if ItemMorellosBane and Menu.ItemMorellosBane.autouse and myHero:CanUseSpell(ItemMorellosBane)==READY then		
		if morebufftype and ((myHero.health/myHero.maxHealth*100)<=Menu.ItemMorellosBane.healrate or morebufftime+1>os.clock()) then
			if Menu.ItemMorellosBane.me then CastSpell(ItemMorellosBane,myHero) end
		end
		for i, ally in ipairs(GetAllyHeroes()) do
			if ValidTarget(ally, 700, false) and morebufftype and ((ally.health/ally.maxHealth*100)<=Menu.ItemMorellosBane.healrate or morebufftime+1>os.clock()) then
				if Menu.ItemMorellosBane[ally.hash] then
					CastSpell(ItemMorellosBane,ally)
				end				
				
			end
		end
	end

	if QuicksilverSash and Menu.Quicksilver.autouse and boostbufftime+1>os.clock() and debufftime<os.clock() and myHero:CanUseSpell(QuicksilverSash)==READY then
		--print("tese quick")		
		if boostbufftype and Menu.Quicksilver.Quicksilver+boostbufftime>os.clock() then
			--print("qq buff on")
			--print(boostbuffname.." / "..boostbufftype)
			debufftime=os.clock()+2
			CastSpell(QuicksilverSash)
			--print("Next time "..debufftime)
		end
	end
	if spell_boost and Menu.boost.autouse and boostbufftime+1>os.clock() and debufftime<os.clock() then
		--print("Buff On")
		if QuicksilverSash and myHero:CanUseSpell(QuicksilverSash)==READY then return end
		if boostbufftype and boostbufftime+Menu.boost.boost>os.clock() then
			--print(boostbuffname.." / "..boostbufftype)
			debufftime=os.clock()+6
			CastSpell(spell_boost)
			--print("Next time "..debufftime)
		end
	end

	if flask_potion and Menu.posion.autouse and (myHero.health/myHero.maxHealth*100 <=Menu.posion.health or myHero.mana/myHero.maxMana*100 <=Menu.posion.mana) and flask_potion_time+12 < os.clock() then
		CastSpell(flask_potion)
		flask_potion_time = os.clock()
	end
	
	if health_potion and Menu.posion.autouse and myHero.health/myHero.maxHealth*100 <=Menu.posion.health and health_potion_time+15 < os.clock() then
		CastSpell(health_potion)
		health_potion_time = os.clock()
	end

	if mana_potion and Menu.posion.autouse and myHero.mana/myHero.maxMana*100 <=Menu.posion.mana and mana_potion_time+15 < os.clock() then
		CastSpell(mana_potion)
		mana_potion_time = os.clock()
	end

	if spell_barrier and Menu.barrier.autouse then
		if myHero.health/myHero.maxHealth*100 <=Menu.barrier.barrierrate then
			CastSpell(spell_barrier)
		end
	end
	
	if (myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") or myHero:GetSpellData(SUMMONER_2).name:find("summonerheal")) and Menu.heal.autouse then		
		if Menu.heal.selheal == 1 then			
			if myHero.health/myHero.maxHealth*100 <=Menu.heal.healrate then
				if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then
					CastSpell(SUMMONER_1)
				else
					CastSpell(SUMMONER_2)
				end
			end
		else			
			if myHero.health/myHero.maxHealth*100 <=Menu.heal.healrate then
				if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then
					CastSpell(SUMMONER_1)
				else
					CastSpell(SUMMONER_2)
				end
			end
			for i, ally in ipairs(GetAllyHeroes()) do				
				if ValidTarget(ally, 790, false) and ally.health/ally.maxHealth*100<=Menu.heal.healrate then
					if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then
						CastSpell(SUMMONER_1)
					else
						CastSpell(SUMMONER_2)
					end
				end
			end
		end
	end

	if (myHero:GetSpellData(SUMMONER_1).name:find("summonerexhaust") or myHero:GetSpellData(SUMMONER_2).name:find("summonerexhaust")) and Menu.exhaust.autouse then
		last_enemy=nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy, 600) and Menu.exhaust[enemy.hash] then
				if enemy.ap>(enemy.totalDamage*2) then dmg = enemy.ap else dmg = enemy.totalDamage end
				first_enemy = enemy
				first_dmg=dmg				
				if not last_enemy then last_enemy=first_enemy  last_dmg=dmg end
				if first_dmg > last_dmg then
					last_enemy = first_enemy
					last_dmg = first_dmg	
				end				
			end
		end
		if ValidTarget(last_enemy, 600) then
			if myHero:GetSpellData(SUMMONER_1).name:find("summonerexhaust") then
				CastSpell(SUMMONER_1, last_enemy)
			else
				CastSpell(SUMMONER_2, last_enemy)
			end
		end
	end

	if spell_smite and Menu.smite.autouse then				
		if Menu.smite.smite00 and ValidTarget(KTarget, 710) and (KTarget.health < bluesmiteDMG) then			
			CastSpell(spell_smite, KTarget)
		end
		if Menu.smite.smite0 and ValidTarget(STarget, 710) then			
			CastSpell(spell_smite, STarget)
		end		
		for i, junglemob in pairs(JungleMobs.objects) do				
			if junglemob == nil then
				return
			end			
			if ValidTarget(junglemob, 720) then
				if Menu.smite.smite1 and junglemob.name=="SRU_Baron12.1.1" and junglemob.health < smiteDMG then
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite2 and junglemob.name=="SRU_Dragon6.1.1" and junglemob.health < smiteDMG then					
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite3 and (junglemob.name=="Sru_Crab15.1.1" or junglemob.name=="Sru_Crab16.1.1") and junglemob.health < smiteDMG then
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite4 then					
				if Menu.smite.smite5 and junglemob.name=="SRU_Red4.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end
				
				if Menu.smite.smite6 and junglemob.name=="SRU_Blue1.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite7 and junglemob.name=="SRU_Gromp13.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite8 and junglemob.name=="SRU_Murkwolf2.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite9 and junglemob.name=="SRU_Razorbeak3.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite10 and junglemob.name=="SRU_Krug5.1.2" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end
				end

				if Menu.smite.smite11 then
				if Menu.smite.smite12 and junglemob.name=="SRU_Red10.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite13 and junglemob.name=="SRU_Blue7.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite14 and junglemob.name=="SRU_Gromp14.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite15 and junglemob.name=="SRU_Murkwolf8.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite16 and junglemob.name=="SRU_Razorbeak9.1.1" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end

				if Menu.smite.smite17 and junglemob.name=="SRU_Krug11.1.2" and junglemob.health < smiteDMG then				
					CastSpell(spell_smite, junglemob)
				end
				end
			end
		end
	end

	if (myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") or myHero:GetSpellData(SUMMONER_2).name:find("summonerdot")) and Menu.ignite.autouse then				
		if KTarget == nil then return end			
		if ValidTarget(KTarget, 570) and (KTarget.health < igniteDMG) then
			if Left.name == "summonerdot" then
				CastSpell(SUMMONER_1, KTarget)
			else
				CastSpell(SUMMONER_2, KTarget)
			end			
		end
	end
end

function Check()
	if spell_smite and Menu.smite.autouse then
		if spell_smite==SUMMONER_1 then Left.range=700 else Right.range=700 end
	end
	if spell_smite and not Menu.smite.autouse then
		if Left.name=="summonersmite" then Left.range=0 else Right.range=0 end
	end


	if (myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") or myHero:GetSpellData(SUMMONER_2).name:find("summonerdot")) and Menu.ignite.autouse then
		igniteDMG = myHero.level * 20 + 50
		KTarget = Target(K)				
	end	

	if spell_smite and Menu.smite.autouse then
		if myHero.level >14 then smiteDMG = 800 + ((myHero.level-14)*50) end
		if myHero.level > 9 then smiteDMG = 600 + ((myHero.level-9)*40) end
		if myHero.level > 5 then smiteDMG = 480 + ((myHero.level-5)*30) end
		if myHero.level > 0 then smiteDMG = 370 + ((myHero.level)*20) end
		bluesmiteDMG = 20+8*myHero.level
		JungleMobs:update()
		STarget = Target(S)		
	end		
	item_data = {
		[1] = myHero:GetSpellData(ITEM_1),
		[2] = myHero:GetSpellData(ITEM_2),
		[3] = myHero:GetSpellData(ITEM_3),
		[4] = myHero:GetSpellData(ITEM_4),
		[5] = myHero:GetSpellData(ITEM_5),
		[6] = myHero:GetSpellData(ITEM_6),
		[7] = myHero:GetSpellData(ITEM_7)
	}
	for i=1, 7, 1 do
		if item_data[i] then
			--print("slot "..i.." : "..item_data[i].name)
			if item_data[i].name == "RegenerationPotion" or item_data[i].name == "ItemMiniRegenPotion" then health_potion = itemnum(i) 
				elseif item_data[i].name == "FlaskOfCrystalWater" then mana_potion = itemnum(i) 
				elseif item_data[i].name == "ItemCrystalFlask" then flask_potion = itemnum(i) 
				elseif item_data[i].name == "QuicksilverSash" or item_data[i].name:find("mMerc") then QuicksilverSash = itemnum(i)
				elseif item_data[i].name == "ItemMorellosBane" then ItemMorellosBane = itemnum(i)
				elseif item_data[i].name == "Muramana" then Muramana = itemnum(i)
				elseif item_data[i].name == "ItemSeraphsEmbrace" then ItemSeraphsEmbrace = itemnum(i)
			end
		end
	end
	item_name = {
		["RegenerationPotion"]={time=15},
		["FlaskOfCrystalWater"]={time=15},
		["ItemCrystalFlask"]={time=12}
	}
	--myHero:CanUseSpell(QuicksilverSash)==READY
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if QuicksilverSash and not  QuicksilverSash_menu then
		QuicksilverSash_menu=true
		if Menu.Language.Language==1 then
			Menu:addSubMenu("수은/시미터", "Quicksilver")
				Menu.Quicksilver:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)						
				Menu.Quicksilver:addParam("Quicksilver", "딜레이(초)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
		else
			Menu:addSubMenu("Quicksilver", "Quicksilver")
				Menu.Quicksilver:addParam("autouse", "autouse", SCRIPT_PARAM_ONOFF, true)						
				Menu.Quicksilver:addParam("Quicksilver", "delay(sec)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
		end
	end

	if ItemMorellosBane and not ItemMorellosBane_menu then
		ItemMorellosBane_menu=true
		if Menu.Language.Language==1 then
			Menu:addSubMenu("미카엘도가니", "ItemMorellosBane")
				Menu.ItemMorellosBane:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)						
				Menu.ItemMorellosBane:addParam("ItemMorellosBane", "딜레이(초)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
				Menu.ItemMorellosBane:addParam("healrate", "체력 % 이하일 때", SCRIPT_PARAM_SLICE, 20, 0, 100)
				Menu.ItemMorellosBane:addParam("me", "나", SCRIPT_PARAM_ONOFF, false)
				for i, ally in ipairs(GetAllyHeroes()) do
					Menu.ItemMorellosBane:addParam(ally.hash, ally.charName, SCRIPT_PARAM_ONOFF, false)
				end
		else
			Menu:addSubMenu("ItemMorellosBane", "ItemMorellosBane")
				Menu.ItemMorellosBane:addParam("autouse", "autouse", SCRIPT_PARAM_ONOFF, true)						
				Menu.ItemMorellosBane:addParam("ItemMorellosBane", "delay(sec)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
				Menu.ItemMorellosBane:addParam("healrate", "Me/Team Health % Below", SCRIPT_PARAM_SLICE, 20, 0, 100)
				Menu.ItemMorellosBane:addParam("me", "Me", SCRIPT_PARAM_ONOFF, false)
				for i, ally in ipairs(GetAllyHeroes()) do
					Menu.ItemMorellosBane:addParam(ally.hash, ally.charName, SCRIPT_PARAM_ONOFF, false)
				end
		end
	end

	if Muramana and not Muramana_menu then
		Muramana_menu=true
		if Menu.Language.Language==1 then
			Menu:addSubMenu("무라마나", "Muramana")
				Menu.Muramana:addParam("autouse", "자동사용", SCRIPT_PARAM_ONKEYDOWN,false,32)										
		else
			Menu:addSubMenu("Muramana", "Muramana")
				Menu.Muramana:addParam("autouse", "autouse", SCRIPT_PARAM_ONKEYDOWN,false,32)										
		end
	end

	if ItemSeraphsEmbrace and not ItemSeraphsEmbrace_menu then
		ItemSeraphsEmbrace_menu=true
		if Menu.Language.Language==1 then
			Menu:addSubMenu("대천사의 포옹", "ItemSeraphsEmbrace")
				Menu.ItemSeraphsEmbrace:addParam("autouse", "자동사용", SCRIPT_PARAM_ONOFF, true)						
				Menu.ItemSeraphsEmbrace:addParam("ItemSeraphsEmbrace", "체력 % 이하일 때", SCRIPT_PARAM_SLICE, 15, 0, 100)
		else
			Menu:addSubMenu("ItemSeraphsEmbrace", "ItemSeraphsEmbrace")
				Menu.ItemSeraphsEmbrace:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)				
				Menu.ItemSeraphsEmbrace:addParam("ItemSeraphsEmbrace", "Health % Below", SCRIPT_PARAM_SLICE, 15, 0, 100)
		end

	end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
end

function Target(spell) 
	if spell==K then KTS:update() if KTS.target then return KTS.target end end
	if spell==S then STS:update() if STS.target then return STS.target end end	
end

function itemnum(i)
	if i==1 then return ITEM_1 end
	if i==2 then return ITEM_2 end
	if i==3 then return ITEM_3 end
	if i==4 then return ITEM_4 end
	if i==5 then return ITEM_5 end
	if i==6 then return ITEM_6 end
	if i==7 then return ITEM_7 end
end

--[[
function OnGainBuff(unit, buff)	
	if unit.isMe then
		print("add: "..buff.name)
	end
end
function OnLoseBuff(unit, buff)
	if unit.isMe then
		print("lose: "..buff.name)
	end
end
]]
local BuffTypes = {
            --[3] = true, --DEBUFF
            [5] = true, --stun
            [7] = true, --Silence
            [8] = true, --taunt
            [10] = false, --SLOW
            [11] = true, --root        
            [21] = true, --fear
            [22] = true, --charm
            [24] = true, --suppress
            [28] = true, --flee
            [29] = true, --knockup
}
function OnApplyBuff(unit,sorce,buff)
	if spell_boost and Menu.boost.autouse and not unit.isMe and sorce.isMe and BuffTypes[buff.type] then
		
		boostbuffname=buff.name
		boostbufftype=buff.type
		boostbufftime=os.clock()		
		
		--print(boostbuffname.." / "..boostbufftype.." / "..boostbufftime)
	end	

	if QuicksilverSash_menu and Menu.Quicksilver.autouse and not unit.isMe and sorce.isMe and BuffTypes[buff.type] then
		
		boostbuffname=buff.name
		boostbufftype=buff.type
		boostbufftime=os.clock()		
		
		--print(boostbuffname.." / "..boostbufftype.." / "..boostbufftime)
	end	

	if ItemMorellosBane and Menu.ItemMorellosBane.autouse and unit.team ~= myHero.team and sorce.team==myHero.team and BuffTypes[buff.type] then
		morebuffname=buff.name
		morebufftype=buff.type
		morebufftime=os.clock()
		--print(morebuffname.." / "..morebufftype.." / "..morebufftime.." // "..sorce.name)
	end
end
