Left = myHero:GetSpellData(SUMMONER_1).name
Right = myHero:GetSpellData(SUMMONER_2).name
stats = myHero.controlled

summoner = {summonerdot, summonerflash, summonerheal, summonerbarrier, summonermana, summonerboost, summonersmite}

function OnDraw()
	DrawText("L SPELL: "..Left, 20, 700, 320, ARGB(255, 255, 255, 255))
	DrawText("R SPELL: "..Right, 20, 700, 340, ARGB(255, 255, 255, 255))
	DrawText("Move: "..stats, 20, 700, 360, ARGB(255, 255, 255, 255))
end
