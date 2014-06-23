--[[----------------------------------------------------------
	Launch Profiler
	----------------------------------------------------------
	* Provides core profile support for Guild Launch
  ]]--

--[[----------------------------------------------------------
	INITIALIZATION
  ]]----------------------------------------------------------
GLP 				= {}
GLP.name 			= "GuildLaunchProfiler"
GLP.command 		= "/glp"
GLP.version			= 0.01
GLP.profileVersion	= 0.01
GLP.debugDefault 	= 1
GLP.savedVars 		= {}
GLP.validCommands 	= {
	"debug",
	"collect",
	"list",
}
GLP.BufferTable = {}
--[[ 
 * Get stuff going. Runs on load.
 ]]-- 
function GLP.OnLoad( eventCode, addOnName )

	-- Only set up for FTC
	if ( addOnName ~= GLP.name ) then return end
	
	-- initialize vars
	GLP.InitializeSavedVars()

	-- Register universal event listeners - do we need any?
	EVENT_MANAGER:RegisterForEvent( "GLP" 	, EVENT_PLAYER_ACTIVATED  , GLP.InitializeUI )
	EVENT_MANAGER:RegisterForEvent( "GLP" 	, EVENT_LEVEL_UPDATE  , GLP.HandleUpdate )
	EVENT_MANAGER:RegisterForEvent( "GLP" 	, EVENT_INVENTORY_SINGLE_SLOT_UPDATE , GLP.HandleUpdate )
	EVENT_MANAGER:RegisterForEvent( "GLP" 	, EVENT_SKILL_POINTS_CHANGED , GLP.HandleUpdate )
	EVENT_MANAGER:RegisterForEvent( "GLP" 	, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED  , GLP.HandleUpdate )

	-- Register the slash command handler
	SLASH_COMMANDS[GLP.command] = GLPSlashCommands
end

-- Hook initialization onto the ADD_ON_LOADED event
EVENT_MANAGER:RegisterForEvent( "GLP" , EVENT_ADD_ON_LOADED , GLP.OnLoad )

function GLP.InitializeUI()
	-- Display successful startup
	GLP.EmitMessage( GLP.gettext( "Guild Launch Profiler Enabled - New Data Will be Collected automatically for Upload After Logout" ))	

	-- get the initial character profile
	GLP.CollectCharacterData()
	GLP.CollectGuildsData()
end

function GLP.HandleUpdate()
	--if not GLP.BufferReached("GLPUpdateBuffer", 1) then return; end
	-- update characetr data
	GLP.CollectCharacterData(false)
	GLP.CollectGuildsData(false)
	-- GLP.Debug( GLP.savedVars )
end

function GLP.HandleManualUpdate()
	GLP.CollectCharacterData(true)
	GLP.CollectGuildsData(true)
	-- GLP.Debug( GLP.savedVars )
end

function GLP.InitializeSavedVars()
	-- Load saved variables
	--GLP.vars = ZO_SavedVars:New( "GLPvars" , math.floor( GLP.version * 100 ) , nil , GLP.defaults , nil )

	GLP.savedVars = {
        ["internal"]     		= ZO_SavedVars:New("GLP_SavedVariables", 1, "internal", { debug = GLP.debugDefault }),
        ["characterProfile"]    = ZO_SavedVars:New("GLP_SavedVariables", 2, "characterProfile", { profileVersion = GLP.profileVersion, lastUpdate = GetTimeStamp() }),
    	["guildProfile"]		= ZO_SavedVars:New("GLP_SavedVariables", 2, "guilds", {profileVersion = GLP.profileVersion, lastUpdate = GetTimeStamp()}),
    }

    if GLP.savedVars["internal"].debug == "1" then
        GLP.Debug( GLP.gettext("Guild Launch Profiler addon initialized. Debugging: enabled."))
    else
        GLP.Debug( GLP.gettext("Guild Launch Profiler addon initialized. Debugging: disabled."))
    end
end

--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------
 --[[ 
 * The slash command handler
 ]]-- 
function GLPSlashCommands( text )
	local param , data = SplitString( " " , text )

	-- handle valid commands and return
	if param == "debug" then
		if data ~= "1" and data ~= "0" then
			data = "0"
		end
		GLP.savedVars.internal.debug = data
		if GLP.savedVars.internal.debug == "1" then
			GLP.EmitMessage( GLP.gettext( 'Debug Output Enabled' ) )
		else
			GLP.EmitMessage( GLP.gettext( 'Debug Output Disabled' ) )
		end	
		-- do something
		return true 
	elseif param == "collect" then
		-- do collection
		GLP.HandleManualUpdate()
		return true
	elseif param == "list" then
		-- list something
		return true
	end

	-- if it falls thorugh then it's not valid currently
	GLP.EmitMessage( param .. GLP.gettext( ' is an invalid GLP command.' ) )	
end

function GLP.BufferReached(key, buffer)
	if key == nil then return end
	if GLP.BufferTable[key] == nil then GLP.BufferTable[key] = {} end
	GLP.BufferTable[key].buffer = buffer or 3
	GLP.BufferTable[key].now = GetFrameTimeSeconds()
	if GLP.BufferTable[key].last == nil then GLP.BufferTable[key].last = GLP.BufferTable[key].now end
	GLP.BufferTable[key].diff = GLP.BufferTable[key].now - GLP.BufferTable[key].last
	GLP.BufferTable[key].eval = GLP.BufferTable[key].diff >= GLP.BufferTable[key].buffer
	if GLP.BufferTable[key].eval then GLP.BufferTable[key].last = GLP.BufferTable[key].now end
	return GLP.BufferTable[key].eval
end