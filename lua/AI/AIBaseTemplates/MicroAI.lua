--[[
    File    :   /lua/AI/AIBaseTemplates/MicroAI.lua
    Author  :   SoftNoob
    Summary :
        Lists AIs to be included into the lobby, see /lua/AI/CustomAIs_v2/SorianAI.lua for another example.
        Loaded in by /lua/ui/lobby/aitypes.lua, this loads all lua files in /lua/AI/CustomAIs_v2/
]]

BaseBuilderTemplate {
    BaseTemplateName = 'MicroAI',
    Builders = {
        -- List all our builder grous here
        'MicroAICommanderBuilder',
        'MicroAIEngineerBuilder',
        'MicroAILandBuilder',
        'MicroAIAirBuilder',
        'MicroAIPlatoonBuilder',
    },
    NonCheatBuilders = {
        -- Specify builders that are _only_ used by non-cheating AI (e.g. scouting)
    },
    BaseSettings = { },
    ExpansionFunction = function(aiBrain, location, markerType)
        -- This is used if you want to make stuff outside of the starting location.
        return 0
    end,
    
    FirstBaseFunction = function(aiBrain)
        local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if not per then 
            return 1, 'MicroAI'
        end

        if per != 'microai' then
            return 1, 'MicroAI'
        else
            return 9000, 'MicroAI'
        end
    end,
}