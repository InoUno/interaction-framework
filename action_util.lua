require('scripts/globals/interaction/actions/event')
require('scripts/globals/interaction/actions/message')
require('scripts/globals/interaction/actions/sequence')

actionUtil = actionUtil or {}

-- Parses out short-hand ways of writing quest actions, in order to avoid having to make function declarations for each simple interaction.
-- Some examples of things it can parse, and what the corresponding actions are:
--
-- Event examples:
--          { event = 123 }                             == quest:event(123)
--          { event = 123, progress = true }            == quest:progressEvent(123)
--          { cutscene = 123 }                          == quest:cutscene(123)
--          { event = 123, options = { [2] = 555 } }    == quest:event(123, { [2] = 555 })
--
-- Message examples:
--          { text = 456 }          == quest:message(456)
--          { message = 456 }       == quest:message(456)
--
-- Sequence example:
--      { { text = 11470, wait = 1000 }, { text = 11471, face = 82, wait = 2000 }, { face = 115 } }
function actionUtil.parseActionDef(actionDef)
    if not actionDef or type(actionDef) ~= 'table' or actionDef.onTrigger or actionDef.onTrade then
        return nil
    end

    -- Action definition is a fully fledged action
    if actionDef.type then
        return actionDef
    end

    -- Event or cutscene
    local info = actionDef.event or actionDef.cutscene
    if info then
        local event = Event:new(info, actionDef.options)
        if actionDef.cutscene then
            event = event:cutscene()
        end
        if actionDef.progress then
            event = event:progress()
        end
        return event
    end

    -- Message
    info = actionDef.text or actionDef.message
    if info then
        local message = Message:new(info)
        return message
    end

    if #actionDef > 0 and type(actionDef[1]) == "table" then
        local sequence = Sequence:new(actionDef)
        if sequence then
            return sequence
        end
    end
end


-- Returns a string containing identification for a specific action
function actionUtil.getActionVarName(secondLevelKey, thirdLevelKey, suffix)
    suffix = suffix or ""
    return string.format("[Action][%s][%s]%s", secondLevelKey, thirdLevelKey, suffix)
end

return actionUtil
