----------------------------
----- Action base class
----------------------------
Action = { }

Action.Priority = {
    Ignore = 1,
    Minimum = 5,
    Message = 10,
    Event = 50,
    ReplaceDefault = 100,
    Progress = 1000,
}

Action.Type = {
    Event = 1,
    Message = 2,
    Sequence = 3,
    Face = 4,
    Wait = 5,
    Release = 6,
    KeyItem = 7,
}

function Action:new(type)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.type = type
    return obj
end

function Action:perform(player, targetEntity)
    -- Functionality is implemented in the specific sub-classes
end

function Action:setPriority(priorityArg)
    self.priority = priorityArg
    return self
end

function Action:progress()
    -- Set highest priority for action
    return self:setPriority(Action.Priority.Progress)
end

function Action:replaceDefault()
     -- Always prefer this over falling back to default in lua file
    return self:setPriority(Action.Priority.ReplaceDefault)
end

 -- After the first time the action is performed, it will have a lower priority
function Action:importantOnce()
    self.priority = Action.Priority.ReplaceDefault
    self.secondaryPriority = Action.Priority.Message
    return self
end

 -- Only do this action once per zone, unless there's nothing else to do
function Action:oncePerZone()
    self.secondaryPriority = Action.Priority.Ignore
    return self
end
