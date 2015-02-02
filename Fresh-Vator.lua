Left = myHero:GetSpellData(SUMMONER_1).name
Right = myHero:GetSpellData(SUMMONER_2).name
stats = myHero.controlled

summoner = {summonerdot, summonerflash, summonerheal, summonerbarrier, summonermana, summonerboost, summonersmite}
JungleMobs = minionManager(MINION_JUNGLE, 760, player, MINION_SORT_MAXHEALTH_DEC)
-- 레드골램  SRU_Krug11.1.2 / 블루 골렘 SRU_Krug5.1.2
-- 레드 레드 SRU_RED 10.1.1 / 블루 레드 SRU_RED4.1.1
-- 레드 고스트 SRU_Razorbeak9.1.1 // 블루 고스트 SRU_Razorbeak 3.1.1
-- 레드 늑대 SRU_Murkwolf8.1.1 / 블루늑대 SRU_Murkwolf2.1.1
-- 레드 블루 SRU_Blue7.1.1 / 블루블루 SRU_Blue 1.1.1
-- 레드 두꺼비 SRU_Gromp 14.1.1 / 블루두꺼비 SRU_Gromp13.1.1

-- 용 앞 게 Sru_Crab15.1.1 
-- 용 SRU_Dragon6.1.1

--바론 게 Sru_Crab16.1.1
--바론 SRU_Baron12.1.1
function OnTick()
	JungleMobs:update()
	for i, junglemob in pairs(JungleMobs.objects) do
		if junglemob == nil then
			return
		end	
		if ValidTarget(junglemob, 600) then
			print(junglemob.name)			
		end
	end
end

function OnDraw()
	DrawCircle(myHero.x, myHero.y, myHero.z, 760, 0xFFFF0000)
	DrawText("L SPELL: "..Left, 20, 700, 320, ARGB(255, 255, 255, 255))
	DrawText("R SPELL: "..Right, 20, 700, 340, ARGB(255, 255, 255, 255))
	DrawText("Move: "..stats, 20, 700, 360, ARGB(255, 255, 255, 255))
end

function Check()
	ignite = myHero.level * 20 + 50	
	if myHero.level >14 then smite = 800 + ((myHero.level-14)*50) end
	if myHero.level > 9 then smite = 600 + ((myHero.level-9)*40) end
	if myHero.level > 5 then smite = 480 + ((myHero.level-5)*30) end
	if myHero.level > 0 then smite = 370 + ((myHero.level)*20) end
	bluesmite = 20+8*myHero.level
end
