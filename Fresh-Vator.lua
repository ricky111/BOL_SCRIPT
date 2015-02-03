ver = "1.0"

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

KTS = TargetSelector(TARGET_LOW_HP, 760, DAMAGE_MAGIC, false) KTarget=nil

SpellType = {
	[1]={name="summonerdot", add=true, range=600, kname="점화"},	
	[2]={name="summonerflash", add=false, range=400, kname="점멸"},	
	[3]={name="summonerheal", add=true, range=800, kname="회복"},	
	[4]={name="summonerbarrier", add=true, range=0, kname="방어막"},	
	[5]={name="summonermana", add=true, range=0, kname="총명"},	
	[6]={name="summonerboost", add=true, range=0, kname="정화"},	
	[7]={name="summonersmite", add=true, range=760, kname="강타"},	
	[8]={name="summonerexhaust", add=true, range=650, kname="탈진"}
}
Left = myHero:GetSpellData(SUMMONER_1) Right = myHero:GetSpellData(SUMMONER_2) JungleMobs = minionManager(MINION_JUNGLE, 760, player, MINION_SORT_MAXHEALTH_DEC)

for i=1, 8, 1 do 	if Left.name == SpellType[i].name then Left = SpellType[i] break end end
for i=1, 8, 1 do 	if Right.name == SpellType[i].name then Right = SpellType[i] break end end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnLoad()
	Menu=scriptConfig("FreshVator / KorFresh", "FreshVator")	
	Menu:addSubMenu("Language", "Language")
		Menu.Language:addParam("Language", "Language", SCRIPT_PARAM_LIST, 2, { "Korean", "English"})
	Menu:addSubMenu("Draw", "Draw")
		if Left.add then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("leftspell", Left.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("leftspell", Left.name, SCRIPT_PARAM_ONOFF, true)
			end
		end
		if Right.add then
			if Menu.Language.Language==1 then
				Menu.Draw:addParam("rightspell", Right.kname, SCRIPT_PARAM_ONOFF, true)
			else
				Menu.Draw:addParam("rightspell", Right.name, SCRIPT_PARAM_ONOFF, true)
			end
		end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") or myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("점화", "ignite")
				Menu.ignite:addParam("autouse", "자동점화", SCRIPT_PARAM_ONOFF, true)
		else
			Menu:addSubMenu("ignite", "ignite")
				Menu.ignite:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_2).name:find("summonersmite") then 
		if Menu.Language.Language==1 then
			Menu:addSubMenu("강타", "smite")
				Menu.smite:addParam("autouse", "자동강타", SCRIPT_PARAM_ONKEYTOGGLE,true,GetKey('G'))				
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite0", "대상: 챔피언 CC", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite00", "대상: 챔피언 막타", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite1", "바론", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite2", "드래곤", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite3", "가재(바론/드래곤)", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite4", "블루진영 전체", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite5", "레드", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite6", "블루", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite7", "두꺼비", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite8", "늑대", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite9", "독수리", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite10", "골램", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
				Menu.smite:addParam("smite11", "레드진영 전체", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite12", "레드", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite13", "블루", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite14", "두꺼비", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite15", "늑대", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite16", "독수리", SCRIPT_PARAM_ONOFF, true)
				Menu.smite:addParam("smite17", "골램", SCRIPT_PARAM_ONOFF, true)
		else
			Menu:addSubMenu("smite", "smite")
				Menu.smite:addParam("autouse", "Auto Use", SCRIPT_PARAM_ONOFF, true)
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
	if (myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") or myHero:GetSpellData(SUMMONER_2).name:find("summonerdot")) and Menu.ignite.autouse then
		if KTarget == nil then return end	
		if ValidTarget(KTarget, 600) and (KTarget.health < igniteDMG) then
			if Left.name == "summonerdot" then
				CastSpell(SUMMONER_1, KTarget)
			else
				CastSpell(SUMMONER_2, KTarget)
			end			
		end
	end

	if (myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_2).name:find("summonersmite")) and Menu.smite.autouse then
		for i, junglemob in pairs(JungleMobs.objects) do
			if junglemob == nil then
				return
			end
			--print(junglemob.name)
			if ValidTarget(junglemob, 760) then
				if Menu.smite.smite1 and junglemob.name=="SRU_Baron12.1.1" and junglemob.health < smiteDMG then
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite2 and junglemob.name=="SRU_Dragon6.1.1" and junglemob.health < smiteDMG then					
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite3 and (junglemob.name=="Sru_Crab15.1.1" or junglemob.name=="Sru_Crab16.1.1") and junglemob.health < smiteDMG then
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite4 then
				if Menu.smite.smite5 and junglemob.name=="SRU_Red4.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end
				
				if Menu.smite.smite6 and junglemob.name=="SRU_Blue1.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite7 and junglemob.name=="SRU_Gromp13.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite8 and junglemob.name=="SRU_Murkwolf2.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite9 and junglemob.name=="SRU_Razorbeak3.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite10 and junglemob.name=="SRU_Krug5.1.2" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end
				end

				if Menu.smite.smite11 then
				if Menu.smite.smite12 and junglemob.name=="SRU_Red10.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite13 and junglemob.name=="SRU_Blue7.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite14 and junglemob.name=="SRU_Gromp14.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite15 and junglemob.name=="SRU_Murkwolf8.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite16 and junglemob.name=="SRU_Razorbeak9.1.1" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end

				if Menu.smite.smite17 and junglemob.name=="SRU_Krug11.1.2" and junglemob.health < smiteDMG then				
					if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
						CastSpell(SUMMONER_1, junglemob)
					else
						CastSpell(SUMMONER_2, junglemob)
					end
				end
				end
			end
		end
	end
end







local mybuff={
	[1]={add=false, name="Stun", clock=nil}, -- 횂쩍횂쨘짚횚짚쩐짚횋짚쨘짚횚짚쩐짚횎짚짧 pass
	[2]={add=false, name="taunt", clock=nil}, -- 횂쨉횂쨉횂쨔짚횚짚쩐짚횏짚징
	[3]={add=false, name="slow", clock=nil}, -- 횂쩍횂쩍횂쨌짚횚짚쩐짚횎짚짠횂쩔횄짭 pass
	[4]={add=false, name="root", clock=nil}, -- 횂쩌짚횚짚쩐짚횎짚짰횂쨔짚횚짚쩐짚횎짚쨘
	[5]={add=false, name="fear", clock=nil}, -- 횂째횄쨍짚횚짚쩐짚횋짚쨩횄쨌
	[6]={add=false, name="charm", clock=nil}, --횂쨍짚횚짚쩐짚횋짚쨘짚횚짚쩐짚횋짚쩍횂짚
	[7]={add=false, name="suppress", clock=nil}, --횂쨔횂짬횄짜짚횚짚쩐짚횋짚쩌짚횚짚쩐짚횎짚쨋짚횚짚쩐짚횋짚짼횂짝
	[8]={add=false, name="flee", clock=nil}, -- 횂쨉횂쨉횂쨍짚횚짚쩐짚횋짚짼
	[9]={add=false, name="knockup", clock=nil} --횂쩔횂징횂쩐횄짰횂쨘횂쨩
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
	if (myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_2).name:find("summonersmite")) and Menu.smite.autouse then
		if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then Left.range=760 else Right.range=760 end
	end
	if (myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_2).name:find("summonersmite")) and not Menu.smite.autouse then
		if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then Left.range=0 else Right.range=0 end
	end


	if (myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") or myHero:GetSpellData(SUMMONER_2).name:find("summonerdot")) and Menu.ignite.autouse then
		igniteDMG = myHero.level * 20 + 50
		KTarget = Target(K)				
	end	

	if (myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") or myHero:GetSpellData(SUMMONER_2).name:find("summonersmite")) and Menu.smite.autouse then
		if myHero.level >14 then smiteDMG = 800 + ((myHero.level-14)*50) end
		if myHero.level > 9 then smiteDMG = 600 + ((myHero.level-9)*40) end
		if myHero.level > 5 then smiteDMG = 480 + ((myHero.level-5)*30) end
		if myHero.level > 0 then smiteDMG = 370 + ((myHero.level)*20) end
		bluesmiteDMG = 20+8*myHero.level
		JungleMobs:update()
	end	
end

function Target(spell) 
	if spell==K then KTS:update() if KTS.target then return KTS.target end end
end
