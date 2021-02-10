----------------------------
----- Quest class
----------------------------
require('scripts/globals/interaction/container')


Quest = setmetatable({ area = {} }, { __index = Container })
Quest.__index = Quest
Quest.__eq = function(q1, q2)
    return q1.area.quest_log == q2.area.quest_log and q1.questId == q2.questId
end

Quest.reward = {}

function Quest:new(area, questId)
    local obj = Container:new(Quest.getVarPrefix(area, questId))
    setmetatable(obj, self)
    obj.area = area
    obj.questId = questId
    return obj
end

function Quest.getVarPrefix(area, questId)
    return string.format("Quest[%d][%d]", area.quest_log, questId)
end

function Quest:getCheckArgs(player)
    return { player:getQuestStatus(self.area, self.questId) }
end

-----------------------------
-- Quest operations

function Quest:begin(player)
    player:addQuest(self.area, self.questId)
end

function Quest:complete(player)
    local didComplete = npcUtil.completeQuest(player, self.area, self.questId, self.reward)
    if didComplete then
        self:cleanup(player)
    end
    return didComplete
end
