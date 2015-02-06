ver = "1.002"

Host = "raw.github.com"
ServerPath = "/KorFresh/BOL_SCRIPT/master/Vator.stats".."?rand="..math.random(1,10000)
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

KTS = TargetSelector(TARGET_LOW_HP, 730, DAMAGE_MAGIC, false) KTarget=nil STarget=nil
STS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 730, DAMAGE_PHYSICAL, false)

SpellType = {
	[1]={name="summonerdot", add=true, range=560, kname="점화"},	-- success
	[2]={name="summonerflash", add=false, range=400, kname="점멸"},	-- success
	[3]={name="summonerheal", add=true, range=790, kname="회복"},	-- success
	[4]={name="summonerbarrier", add=true, range=0, kname="방어막"},	-- success
	[5]={name="summonermana", add=true, range=0, kname="총명"},	
	[6]={name="summonerboost", add=true, range=0, kname="정화"},	
	[7]={name="summonersmite", add=true, range=700, kname="강타"},	-- success
	[8]={name="summonerexhaust", add=true, range=600, kname="탈진"}	-- success
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
		if Right.name == "s5_summonersmiteplayerganker" then spell_smite = SUMMONER_2 end
		if Right.name == "s5_summonersmiteduel" then spell_smite = SUMMONER_2 end
		if Right.name == "itemsmiteaoe" then spell_smite = SUMMONER_2 end
		if Right.name == "s5_summonersmitequick" then spell_smite = SUMMONER_2 end
		break 
	end 
end

if Left.name == "s5_summonersmiteplayerganker" or Left.name == "s5_summonersmiteduel" or Left.name == "itemsmiteaoe" or Left.name == "s5_summonersmitequick" then Left=SpellType[7] spell_smite=SUMMONER_1 end
if Right.name == "s5_summonersmiteplayerganker" or Right.name == "s5_summonersmiteduel" or Right.name == "itemsmiteaoe" or Right.name == "s5_summonersmitequick" then Right=SpellType[7] spell_smite=SUMMONER_2 end
--print("L: "..spell_smite)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnLoad()
	Menu=scriptConfig("FreshVator / KorFresh", "FreshVator")	
	Menu:addSubMenu("Language", "Language")
		Menu.Language:addParam("Language", "Language", SCRIPT_PARAM_LIST, 2, { "Korean", "English"})
	Menu:addSubMenu("Draw", "Draw")
		if Left then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("leftspell", Left.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("leftspell", Left.name, SCRIPT_PARAM_ONOFF, true)
			end
		end
		if Right then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("rightspell", Right.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("rightspell", Right.name, SCRIPT_PARAM_ONOFF, true)
			end
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
				Menu.boost:addParam("autouse", "자용사용", SCRIPT_PARAM_ONOFF, true)						
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
end

function OnTick()
	if myHero.dead then return end
	Check()

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







local mybuff={
	[1]={add=false, name="Stun", clock=nil}, 
	[2]={add=false, name="taunt", clock=nil}, 
	[3]={add=false, name="slow", clock=nil}, 
	[4]={add=false, name="root", clock=nil},
	[5]={add=false, name="fear", clock=nil}, 
	[6]={add=false, name="charm", clock=nil},
	[7]={add=false, name="suppress", clock=nil}, 
	[8]={add=false, name="flee", clock=nil}, 
	[9]={add=false, name="knockup", clock=nil} 
}

function OnGainBuff(unit, buff)	
	if unit.isMe then
		for i=1, 9, 1 do			
			if buff.name==mybuff[i].name then				
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
	item = {
		[1] = myHero:GetSpellData(ITEM_1)
	}
		
		print(item[1].name)
	
end
item_name = {
	["RegenerationPotion"]={},
	["FlaskOfCrystalWater"]={}
}

function Target(spell) 
	if spell==K then KTS:update() if KTS.target then return KTS.target end end
	if spell==S then STS:update() if STS.target then return STS.target end end	
endver = "1.003"

Host = "raw.github.com"
ServerPath = "/KorFresh/BOL_SCRIPT/master/Vator.stats".."?rand="..math.random(1,10000)
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

KTS = TargetSelector(TARGET_LOW_HP, 730, DAMAGE_MAGIC, false) KTarget=nil STarget=nil
STS = TargetSelector(TARGET_LESS_CAST_PRIORITY, 730, DAMAGE_PHYSICAL, false)

SpellType = {
	[1]={name="summonerdot", add=true, range=560, kname="횁징횊짯"},	-- success
	[2]={name="summonerflash", add=false, range=400, kname="횁징쨍챗"},	-- success
	[3]={name="summonerheal", add=true, range=790, kname="횊쨍쨘쨔"},	-- success
	[4]={name="summonerbarrier", add=true, range=0, kname="쨔챈쩐챤쨍쨌"},	-- success
	[5]={name="summonermana", add=true, range=0, kname="횄횗쨍챠"},	
	[6]={name="summonerboost", add=true, range=0, kname="횁짚횊짯"},	
	[7]={name="summonersmite", add=true, range=700, kname="째짯횇쨍"},	-- success
	[8]={name="summonerexhaust", add=true, range=600, kname="횇쨩횁첩"}	-- success
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
		if Right.name == "s5_summonersmiteplayerganker" then spell_smite = SUMMONER_2 end
		if Right.name == "s5_summonersmiteduel" then spell_smite = SUMMONER_2 end
		if Right.name == "itemsmiteaoe" then spell_smite = SUMMONER_2 end
		if Right.name == "s5_summonersmitequick" then spell_smite = SUMMONER_2 end
		break 
	end 
end

if Left.name == "s5_summonersmiteplayerganker" or Left.name == "s5_summonersmiteduel" or Left.name == "itemsmiteaoe" or Left.name == "s5_summonersmitequick" then Left=SpellType[7] spell_smite=SUMMONER_1 end
if Right.name == "s5_summonersmiteplayerganker" or Right.name == "s5_summonersmiteduel" or Right.name == "itemsmiteaoe" or Right.name == "s5_summonersmitequick" then Right=SpellType[7] spell_smite=SUMMONER_2 end
--print("L: "..spell_smite)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnLoad()
	Menu=scriptConfig("FreshVator / KorFresh", "FreshVator")	
	Menu:addSubMenu("Language", "Language")
		Menu.Language:addParam("Language", "Language", SCRIPT_PARAM_LIST, 2, { "Korean", "English"})
	Menu:addSubMenu("Draw", "Draw")
		if Left then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("leftspell", Left.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("leftspell", Left.name, SCRIPT_PARAM_ONOFF, true)
			end
		end
		if Right then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("rightspell", Right.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("rightspell", Right.name, SCRIPT_PARAM_ONOFF, true)
			end
		end
	if Menu.Language.Language==1 then
		Menu:addSubMenu("쨔째쩐횪", "posion")
			Menu.posion:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONOFF, true)
			Menu.posion:addParam("health", "횄쩌쨌횂 % 횑횉횕횕 쨋짠", SCRIPT_PARAM_SLICE, 50, 0, 100)
			Menu.posion:addParam("mana", "쨍쨋쨀짧 % 횑횉횕횕 쨋짠", SCRIPT_PARAM_SLICE, 50, 0, 100)
	else
		Menu:addSubMenu("posion", "posion")
			Menu.posion:addParam("autouse", "autouse", SCRIPT_PARAM_ONOFF, true)
			Menu.posion:addParam("health", "Health % Below", SCRIPT_PARAM_SLICE, 50, 0, 100)
			Menu.posion:addParam("mana", "Mana % Below", SCRIPT_PARAM_SLICE, 50, 0, 100)
	end
	if spell_boost then
		if Menu.Language.Language==1 then
			Menu:addSubMenu("횁짚횊짯", "boost")
				Menu.boost:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONOFF, true)						
				Menu.boost:addParam("boost", "쨉척쨌쨔횑(횄횎)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
		else
			Menu:addSubMenu("Boost", "boost")
				Menu.boost:addParam("autouse", "autouse", SCRIPT_PARAM_ONOFF, true)						
				Menu.boost:addParam("boost", "delay(sec)", SCRIPT_PARAM_SLICE, 0.5, 0, 1, 2)
		end
	end
	if spell_barrier then
		if Menu.Language.Language==1 then
			Menu:addSubMenu("쨔챈쩐챤쨍쨌", "barrier")
				Menu.barrier:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONOFF, true)						
				Menu.barrier:addParam("barrierrate", "횄쩌쨌횂 % 횑횉횕횕 쨋짠", SCRIPT_PARAM_SLICE, 15, 0, 100)
		else
			Menu:addSubMenu("Barrier", "barrier")
				Menu.barrier:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)				
				Menu.barrier:addParam("barrierrate", "Health % Below", SCRIPT_PARAM_SLICE, 15, 0, 100)
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") or myHero:GetSpellData(SUMMONER_2).name:find("summonerheal") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("횊쨍쨘쨔", "heal")
				Menu.heal:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONOFF, true)		
				Menu.heal:addParam("selheal", "쨩챌쩔챘쨈챘쨩처", SCRIPT_PARAM_LIST, 2, { "쨀짧쨍쨍", "쩐횈짹쨘"})		
				Menu.heal:addParam("healrate", "횄쩌쨌횂 % 횑횉횕횕 쨋짠", SCRIPT_PARAM_SLICE, 15, 0, 100)
		else
			Menu:addSubMenu("heal", "heal")
				Menu.heal:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
				Menu.heal:addParam("selheal", "For Use", SCRIPT_PARAM_LIST, 2, { "Olny Me", "My Team"})		
				Menu.heal:addParam("healrate", "Me/Team Health % Below", SCRIPT_PARAM_SLICE, 15, 0, 100)
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerexhaust") or myHero:GetSpellData(SUMMONER_2).name:find("summonerexhaust") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("횇쨩횁첩", "exhaust")
				Menu.exhaust:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONKEYDOWN,false,32)
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
			Menu:addSubMenu("횁징횊짯", "ignite")
				Menu.ignite:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONOFF, true)
		else
			Menu:addSubMenu("ignite", "ignite")
				Menu.ignite:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
		end
	end	
	if spell_smite then		
		if Menu.Language.Language==1 then
			Menu:addSubMenu("째짯횇쨍", "smite")
				Menu.smite:addParam("autouse", "횣쨉쩔쨩챌쩔챘", SCRIPT_PARAM_ONKEYTOGGLE,true,GetKey('G'))				
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite0", "쨈챘쨩처: 횄짢횉횉쩐챨 CC", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite00", "쨈챘쨩처: 횄짢횉횉쩐챨 쨍쨌횇쨍", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite1", "쨔횢쨌횖", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite2", "쨉책쨌징째챦", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite3", "째징챌(쨔횢쨌횖/쨉책쨌징째챦)", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite4", "쨘챠쨌챌횁첩쩔쨉 체횄쩌", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite5", "쨌쨔쨉책", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite6", "쨘챠쨌챌", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite7", "쨉횓짼짢쨘챰", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite8", "쨈횁쨈챘", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite9", "쨉쨋쩌철쨍짰", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite10", "째챰쨌쩍", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite11", "쨌쨔쨉책횁첩쩔쨉 체횄쩌", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite12", "쨌쨔쨉책", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite13", "쨘챠쨌챌", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite14", "쨉횓짼짢쨘챰", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite15", "쨈횁쨈챘", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite16", "쨉쨋쩌철쨍짰", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite17", "째챰쨌쩍", SCRIPT_PARAM_ONOFF, true)
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
end

function OnTick()
	if myHero.dead then return end
	Check()

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







local mybuff={
	[1]={add=false, name="Stun", clock=nil}, 
	[2]={add=false, name="taunt", clock=nil}, 
	[3]={add=false, name="slow", clock=nil}, 
	[4]={add=false, name="root", clock=nil},
	[5]={add=false, name="fear", clock=nil}, 
	[6]={add=false, name="charm", clock=nil},
	[7]={add=false, name="suppress", clock=nil}, 
	[8]={add=false, name="flee", clock=nil}, 
	[9]={add=false, name="knockup", clock=nil} 
}

function OnGainBuff(unit, buff)	
	if unit.isMe then
		for i=1, 9, 1 do			
			if buff.name==mybuff[i].name then				
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
	item = {
		[1] = myHero:GetSpellData(ITEM_1)
	}
		
		print(item[1].name)
	
end
item_name = {
	["RegenerationPotion"]={},
	["FlaskOfCrystalWater"]={}
}

function Target(spell) 
	if spell==K then KTS:update() if KTS.target then return KTS.target end end
	if spell==S then STS:update() if STS.target then return STS.target end end	
end
