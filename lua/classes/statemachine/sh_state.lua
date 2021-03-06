local state = newClass("State", "Base");

function state:ctor(name, machine)
	assertArgument(2, "string");
	assertArgument(3, "StateMachine");
	getDefinition("Base").ctor(self);
	self._name = name;
	self._active = false;
	self._machine = machine;
	self._stateTickEvent = newInstance("Event");
	self._stateEnteredEvent = newInstance("Event");
	self._stateLeftEvent = newInstance("Event");
end

function state:getName()
	return self._name;
end

function state:isActive()
	return self._active;
end

function state:getMachine()
	return self._machine;
end

function state:getStateTickEvent()
	return self._stateTickEvent;
end

function state:getStateEnteredEvent()
	return self._stateEnteredEvent;
end

function state:getStateLeftEvent()
	return self._stateLeftEvent;
end

function state:tick()
	assert(self:isActive(), string.format("The state '%s' is not the active state", self:getName()));
	self:getStateTickEvent():fire(self);
end

function state:enter()
	assert(not self:isActive(), string.format("The state '%s' is not the active state", self:getName()));
	self._active = true;
	self:getStateEnteredEvent():fire(self);
end

function state:leave()
	assert(self:isActive(), string.format("The state '%s' is not the active state", self:getName()));
	self._active = false;
	self:getStateLeftEvent():fire(self);
end

function state:changeTo(stateName)
	assertArgument(2, "string");
	assert(self:isActive(), string.format("The state '%s' is not the active state", self:getName()));
	local otherState = self:getMachine():getState(stateName);
	self:getMachine():setActiveState(otherState);
end