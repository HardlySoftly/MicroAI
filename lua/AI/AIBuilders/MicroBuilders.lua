--[[
    File    :   /lua/AI/AIBuilders/MicroBuilders.lua
    Author  :   SoftNoob
    Summary :
        All the builders that are used by MicroAI.
        The keys for these builders are included AI/AIBaseTemplates/MicroAI.lua.
]]

local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local SBC = '/lua/editor/SorianBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'MicroAICommanderBuilder', -- Globally unique key that the AI base template file uses to add the contained builders to your AI.
    BuildersType = 'EngineerBuilder', -- The kind of builder this is.  One of 'EngineerBuilder', 'PlatoonFormBuilder', or 'FactoryBuilder'.
    -- The initial build order
    Builder {
        BuilderName = 'MicroAI Initial Commander BO', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.
        PlatoonTemplate = 'CommanderBuilder', -- Specify what platoon template to use, see the PlatoonTemplates folder.
        Priority = 1000, -- Make this super high priority.  The AI chooses the highest priority builder currently available.
        BuilderConditions = { -- The build conditions determine if this builder is available to be used or not.
                { IBC, 'NotPreBuilt', {}}, -- Only run this if the base isn't pre-built.
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddBehaviors = { 'CommanderBehaviorSorian' }, -- Add a behaviour to the Commander unit once its done with it's BO.
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, }, -- Flag this builder to be only run once.
        BuilderData = {
            Construction = {
                BuildStructures = { -- The buildings to make
                    'T1LandFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1Resource', -- Mass Extractor
                    'T1Resource',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'MicroAIEngineerBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'MicroAI T1Engineer Mex',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 100,
        InstanceCount = 2, -- The max number concurrent instances of this builder.
        BuilderConditions = { },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'MicroAI T1Engineer Pgen',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 90,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'LessThanEconStorageRatio', { 1.1, 0.99}}, -- If less than full energy, build a pgen.
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'MicroAI T1Engineer LandFac',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 95,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.5}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, 'FACTORY TECH1' } }, -- Stop after 10 facs have been built.
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildStructures = {
                    'T1LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'MicroAI T1Engineer AirFac',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 90,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.1, 0.8}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'FACTORY TECH1' } }, -- Don't build air fac immediately.
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, 'FACTORY TECH1' } }, -- Stop after 5 facs have been built.
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            Construction = {
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'MicroAILandBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'MicroAi Factory Engineer',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 100, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ENGINEER - categories.COMMAND } }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'MicroAi Factory Scout',
        PlatoonTemplate = 'T1LandScout',
        Priority = 90,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatio', { 0.15, categories.LAND * categories.SCOUT * categories.MOBILE,
                                       '<=', categories.LAND * categories.MOBILE - categories.ENGINEER } }, -- Don't make scouts if we have lots of them.
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'MicroAi Factory Tank',
        PlatoonTemplate = 'T1LandDFTank',
        Priority = 80,
        BuilderConditions = {
            { UCBC, 'HaveUnitRatio', { 0.65, categories.LAND * categories.DIRECTFIRE * categories.MOBILE,
                                       '<=', categories.LAND * categories.MOBILE - categories.ENGINEER } }, -- Don't make tanks if we have lots of them.
        },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'MicroAi Factory Artillery',
        PlatoonTemplate = 'T1LandArtillery',
        Priority = 70,
        BuilderConditions = { },
        BuilderType = 'All',
    },
    Builder {
        BuilderName = 'MicroAi Factory AntiAir',
        PlatoonTemplate = 'T1LandAA',
        Priority = 110,
        BuilderConditions = {
            { TBC, 'EnemyThreatGreaterThanValueAtBase', { 'LocationType', 0, 'Air', 1 } }, -- Build AA if the enemy is threatening our base with air units.
            { UCBC, 'HaveUnitRatio', { 0.35, categories.LAND * categories.ANTIAIR * categories.MOBILE,
                                       '<', categories.LAND  * categories.MOBILE - categories.ENGINEER } },
        },
        BuilderType = 'All',
    },
}

BuilderGroup {
    BuilderGroupName = 'MicroAIAirBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'MicroAI Factory Bomber',
        PlatoonTemplate = 'T1AirBomber',
        Priority = 80,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.0, 0.7}},
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'MicroAI Factory Intie',
        PlatoonTemplate = 'T1AirFighter',
        Priority = 90,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
            { SBC, 'HaveRatioUnitsWithCategoryAndAlliance', { false, 1.5, categories.AIR * categories.ANTIAIR, categories.AIR * categories.MOBILE, 'Enemy'}},
            { EBC, 'GreaterThanEconStorageRatio', { 0.0, 0.7}},
        },
        BuilderType = 'Air',
    },
}

BuilderGroup {
    BuilderGroupName = 'MicroAIPlatoonBuilder',
    BuildersType = 'PlatoonFormBuilder', -- A PlatoonFormBuilder is for builder groups of units.
    Builder {
        BuilderName = 'MicroAI Land Attack',
        PlatoonTemplate = 'MicroAILandAttack', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 100,
        InstanceCount = 200,
        BuilderType = 'Any',
        BuilderData = {
            NeverGuardBases = true,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = { },
    },
    Builder {
        BuilderName = 'MicroAI Air Attack',
        PlatoonTemplate = 'BomberAttack',
        Priority = 100,
        InstanceCount = 2,
        BuilderType = 'Any',        
        BuilderConditions = { },
    },
    Builder {
        BuilderName = 'MicroAI Air Intercept',
        PlatoonTemplate = 'AntiAirHunt',
        Priority = 100,
        InstanceCount = 200,
        BuilderType = 'Any',     
        BuilderConditions = { },
    },
}
