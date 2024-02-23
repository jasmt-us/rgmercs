local mq = require 'mq'

---@class RGMercsModuleType
---@field name string

---@type DataType
local rgMercsModuleType = mq.DataType.new('RGMercsModule', {
    Members = {
        Name = function(_, self)
            return 'string', string.format("RGMercs [Module: %s/%s] by: %s", self._name, self._version, self._author)
        end,

        State = function(_, self)
            return 'string', self:DoGetState()
        end,
    },

    Methods = {
    },

    ToString = function(self)
        return self._name
    end,
})

---@class RGMercsMainType
---@field name string

---@type DataType
local rgMercsMainType = mq.DataType.new('RGMercsMain', {
    Members = {
        Paused = function(_, self)
            return 'bool', RGMercConfig.Globals.PauseMain
        end,
        State = function(_, self)
            return 'string', RGMercConfig.Globals.PauseMain and "Paused" or "Running"
        end,
    },

    ToString = function(self)
        return self._name
    end,
})

---@return MQType, RGMercsModuleType|string|boolean
local function RGMercsTLOHandler(param)
    if not param or param:len() == 0 then
        return rgMercsMainType, RGMercConfig
    end

    if param:lower() == "curable" then
        return 'string', string.format("Disease: %d, Poison: %d, Curse: %d, Corruption: %d",
            mq.TLO.Me.Diseased.ID() or 0,
            mq.TLO.Me.Poisoned.ID() or 0,
            mq.TLO.Me.Cursed.ID() or 0,
            mq.TLO.Me.Corrupted.ID() or 0)
    end

    return rgMercsModuleType, RGMercModules:GetModule(param)
end
-- Register our TLO functions
mq.AddTopLevelObject('RGMercs', RGMercsTLOHandler)
