--[[----------------------------------------------------------
	CHARACTER PROFILE COLLECTION
 ]]-----------------------------------------------------------

local slotsList = {
  ["EQUIP_SLOT_HEAD"] = "ZO_CharacterEquipmentSlotsHead",
  ["EQUIP_SLOT_CHEST"] = "ZO_CharacterEquipmentSlotsChest",
  ["EQUIP_SLOT_SHOULDERS"] = "ZO_CharacterEquipmentSlotsShoulder",
  ["EQUIP_SLOT_FEET"] = "ZO_CharacterEquipmentSlotsFoot",
  ["EQUIP_SLOT_HAND"] = "ZO_CharacterEquipmentSlotsGlove",
  ["EQUIP_SLOT_LEGS"] = "ZO_CharacterEquipmentSlotsLeg",
  ["EQUIP_SLOT_WAIST"] = "ZO_CharacterEquipmentSlotsBelt",
  ["EQUIP_SLOT_RING1"] = "ZO_CharacterEquipmentSlotsRing1",
  ["EQUIP_SLOT_RING2"] = "ZO_CharacterEquipmentSlotsRing2",
  ["EQUIP_SLOT_NECK"] = "ZO_CharacterEquipmentSlotsNeck",
  ["EQUIP_SLOT_COSTUME"] = "ZO_CharacterEquipmentSlotsCostume",
  ["EQUIP_SLOT_MAIN_HAND"] = "ZO_CharacterEquipmentSlotsMainHand",
  ["EQUIP_SLOT_OFF_HAND"] = "ZO_CharacterEquipmentSlotsOffHand",
  ["EQUIP_SLOT_BACKUP_MAIN"] = "ZO_CharacterEquipmentSlotsBackupMain",
  ["EQUIP_SLOT_BACKUP_OFF"] = "ZO_CharacterEquipmentSlotsBackupOff"
}

local statsList = {
	"STAT_ARMOR_RATING",
	"STAT_ATTACK_POWER",
	"STAT_BLOCK",
	"STAT_CRITICAL_RESISTANCE",
	"STAT_CRITICAL_STRIKE",
	"STAT_DAMAGE_RESIST_COLD",
	"STAT_DAMAGE_RESIST_DISEASE",
	"STAT_DAMAGE_RESIST_DROWN",
	"STAT_DAMAGE_RESIST_EARTH",
	"STAT_DAMAGE_RESIST_FIRE",
	"STAT_DAMAGE_RESIST_GENERIC",
	"STAT_DAMAGE_RESIST_MAGIC",
	"STAT_DAMAGE_RESIST_OBLIVION",
	"STAT_DAMAGE_RESIST_PHYSICAL",
	"STAT_DAMAGE_RESIST_POISON",
	"STAT_DAMAGE_RESIST_SHOCK",
	"STAT_DAMAGE_RESIST_START",
	"STAT_DODGE",
	"STAT_HEALING_TAKEN",
	"STAT_HEALTH_MAX",
	"STAT_HEALTH_REGEN_COMBAT",
	"STAT_HEALTH_REGEN_IDLE",
	"STAT_MAGICKA_MAX",
	"STAT_MAGICKA_REGEN_COMBAT",
	"STAT_MAGICKA_REGEN_IDLE",
	"STAT_MISS",
	"STAT_MITIGATION",
	"STAT_MOUNT_STAMINA_MAX",
	"STAT_MOUNT_STAMINA_REGEN_COMBAT",
	"STAT_MOUNT_STAMINA_REGEN_MOVING",
	"STAT_NONE",
	"STAT_PARRY",
	"STAT_PHYSICAL_PENETRATION",
	"STAT_PHYSICAL_RESIST",
	"STAT_POWER",
	"STAT_SPELL_CRITICAL",
	"STAT_SPELL_MITIGATION",
	"STAT_SPELL_PENETRATION",
	"STAT_SPELL_POWER",
	"STAT_SPELL_RESIST",
	"STAT_STAMINA_MAX",
	"STAT_STAMINA_REGEN_COMBAT",
	"STAT_STAMINA_REGEN_IDLE",
	"STAT_WEAPON_POWER",
}

local skillTypeList = {
	"SKILL_TYPE_CLASS",
	"SKILL_TYPE_WEAPON",
	"SKILL_TYPE_ARMOR",
	"SKILL_TYPE_WORLD",
	"SKILL_TYPE_GUILD",
	"SKILL_TYPE_NONE",
	"SKILL_TYPE_RACIAL",
	"SKILL_TYPE_TRADESKILL",			
}

local tradeSkillTypeList = {
	--"CRAFTING_TYPE_ALCHEMY",
	"CRAFTING_TYPE_BLACKSMITHING",
	--"CRAFTING_TYPE_CLOTHIER",
	--"CRAFTING_TYPE_ENCHANTING",
	--"CRAFTING_TYPE_INVALID",
	--"CRAFTING_TYPE_PROVISIONING",
	"CRAFTING_TYPE_WOODWORKING",
}

function GLP.CollectCharacterData(forced)

	--[[
	This is the character basic info
	]]

	-- Gather character information
	characterProfile		= {
		["name"] 		= GetUnitName( 'player' ),
		["race"]		= GetUnitRace( 'player' ),
		["class"]		= GetUnitClass( 'player' ),
		["nicename"]	= string.gsub( GetUnitName( 'player' ) , "%-", "%%%-"),
		["level"]		= GetUnitLevel('player'),
		["vlevel"]		= GetUnitVeteranRank('player'),
		["alevel"]		= GetUnitAvARank('player'),
		["exp"]			= GetUnitXP('player'),
		["vet"]			= GetUnitVeteranPoints('player'),
	}

	--[[
	This is the character items
	]]

	characterProfile.items = {}

	for k, v in pairs(slotsList) do
    	local textureName,stack,sellPrice,meetsUsageRequirement, locked, equipType, iemStyle,quality = GetItemInfo(0, _G[k])
    	local itemName = tostring(GetItemName(0, _G[k]))

    	itemInfo		= {
    		["itemName"] 				= itemName,
			["textureName"] 			= textureName,
			["stack"]					= stack,
			["sellPrice"]				= sellPrice,
			["meetsUsageRequirement"]	= meetsUsageRequirement,
			["locked"]					= locked,
			["equipType"]				= equipType,
			["iemStyle"]				= iemStyle,
			["quality"]					= quality,
		}
    	
    	characterProfile.items[k] = itemInfo
    end

    --[[
	This is the Stats
	]]

	characterProfile.stats = {}

	for k,v in pairs(statsList) do
		local statValue = GetPlayerStat(_G[v],_G['STAT_BONUS_OPTION_APPLY_BONUS'],_G['STAT_SOFT_CAP_OPTION_APPLY_SOFT_CAP'])
		--GLP.EmitMessage(v);
		--GLP.EmitMessage(statValue);
		characterProfile.stats[v] = statValue
	end


    --[[
	This is the Skills - based on skillTypeList
	]]	
	characterProfile.skills = {}
	numSkillTypes = GetNumSkillTypes()
	GLP.Debug( "Skill Types:"..numSkillTypes)	
	for i = 1, numSkillTypes, 1 do
		numSkillLines = GetNumSkillLines(i)		
		GLP.Debug( "Skill Lines:"..numSkillLines)	
		if i ~= 6 then -- the 6th item is unused for some reason
			--GLP.EmitMessage( "Skill Type:"..skillTypeList[i])	
			characterProfile.skills[skillTypeList[i]]={}
			for j = 1, numSkillLines, 1 do				
				name, rank = GetSkillLineInfo(i, j)
				numSkillAbilities = GetNumSkillAbilities(i,j)
				GLP.Debug( "Skill Abili:"..numSkillAbilities)	
				if name ~= nil and name ~= '' then
					--GLP.EmitMessage( "Skill:"..name.."--"..rank)	
					characterProfile.skills[skillTypeList[i]][name]={}
					for k = 1, numSkillAbilities, 1 do
						abilityName, texture, earnedRank, passive, ultimate, purchased, progressionIndex = GetSkillAbilityInfo(i,j,k)						
						if abilityName ~= nil and abilityName ~= '' then
							currentUpgradeLevel, maxUpgradeLevel = GetSkillAbilityUpgradeInfo(i,j,k)							
							if (passive) then
								GLP.Debug("Passive Ability: "..abilityName.." current: "..tostring(currentUpgradeLevel).." max: "..tostring(maxUpgradeLevel))
							else
								GLP.Debug("Active Ability: "..abilityName.."--"..earnedRank.."--"..tostring(passive).."--ProgIndex:"..tostring(progressionIndex).."--"..tostring(purchased).."--"..tostring(ultimate))
							end							
							if progressionIndex ~= nil then								
								progressionName, progressionMorph, progressionRank = GetAbilityProgressionInfo(progressionIndex)							
								GLP.Debug("Progression: "..progressionName.." morph: "..tostring(progressionMorph).." rank: "..tostring(progressionRank))
							end							
							skillInfo = {
								["earnedRank"] = earnedRank,
								["progressionIndex"] = tostring(progressionIndex),
								["purchased"] = tostring(purchased),
								["ultimate"] = tostring(ultimate),
								["texture"] = texture,
								["passive"] = tostring(passive),
							}							
							characterProfile.skills[skillTypeList[i]][name][abilityName]=skillInfo
						end
					end
				end
			end	
		end
	end

	--[[
	These are crafting traits - only woodworking and smithing 
	seem to follow the trait system currently... I expect this to chaneg
	]]	
	for k,v in pairs(tradeSkillTypeList) do
		numLines = GetNumSmithingResearchLines(_G[v])
		for i = 1, numLines, 1 do
			local name, icon, numTraits,_ = GetSmithingResearchLineInfo(_G[v], i)
			for j = 1, numTraits, 1 do
				local traitType, traitDescription, known = GetSmithingResearchLineTraitInfo(_G[v],i,j)
				local _, itemName,texture,_,_,_,_ = GetSmithingTraitItemInfo(traitType)				
				if (known == true) then
					GLP.EmitMessage( "Trait Known for " .. v .. " " .. name .. " " .. icon.. traitType .. " " .. itemName .. " " .. traitDescription .. " " .. tostring(known))
				end
			end
		end
	end

    -- store the profile
    --ZO_SavedVars:New("GLP_SavedVariables", 2, "character", { characterProfile = characterProfile })
    GLP.savedVars.characterProfile.data = characterProfile

    if (GetTimeStamp() - GLP.savedVars.characterProfile.lastUpdate) > 30 or forced == true then
		GLP.EmitMessage( GLP.gettext( "Profile Data Collected"))	
	end
	GLP.savedVars.characterProfile.lastUpdate = GetTimeStamp();

end