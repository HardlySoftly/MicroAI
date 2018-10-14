--[[
    File    :   /lua/AI/CustomAIs_v2/MicroAI.lua
    Author  :   SoftNoob
    Summary :
        Lists AIs to be included into the lobby, see /lua/AI/CustomAIs_v2/SorianAI.lua for another example.
        Loaded in by /lua/ui/lobby/aitypes.lua, this loads all lua files in /lua/AI/CustomAIs_v2/
]]

AI = {
	Name = 'MicroAI',
	Version = '1',
	AIList = {
		{
			key = 'microai',
			name = '<LOC MicroAI_0001>AI: Micro',
		},
	},
	CheatAIList = {
		{
			key = 'microaicheat',
			name = '<LOC MicroAI_0003>AIx: Micro',
		},
	},
}