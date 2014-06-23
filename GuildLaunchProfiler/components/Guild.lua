--[[----------------------------------------------------------
	GUILD PROFILE COLLECTION
 ]]-----------------------------------------------------------

function GLP.CollectGuildsData(forced)
  local guilds = {}
  local numGuilds = GetNumGuilds()
  for i=1,numGuilds,1 do
    local guild_id      = GetGuildId(i)
    local guildName     = GetGuildName(guild_id)
    local guildAlliance = GetGuildAlliance(guild_id)
    local members       = GLP.GetGuildMemberData(guild_id)
    table.insert(guilds,{guild_id = guild_id, guildName = guildName, guildAlliance = guildAlliance, members = members});
  end
  GLP.savedVars.guildProfile.data = guilds
  GLP.savedVars.guildProfile.lastUpdate = GetTimeStamp()
  GLP.EmitMessage( GLP.gettext( "Guild Data Collected"))
 end
 function GLP.GetGuildMemberData(guild_id)
  local members = {};
  for x=1,GetNumGuildMembers(guild_id),1 do
  	local hasCharacter, name, location, classId, AllianceId, level, veteranRank = GetGuildMemberCharacterInfo(guild_id,x);
  	local accName, note, rankIndex;
  	table.insert(members,{name = name, location = location, classId = classId, allianceId = AllianceId, level = level, veteranRank = veteranRank, accName = accName, note = note, rankId = rankIndex});
  end
  return members;
 end