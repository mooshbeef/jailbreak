local settingsManager = newClass("SettingsManager", "TypedList");
settingsManager.REQUEST_ACCEPTED = 0;
settingsManager.REQUEST_DENIED = 1;
settingsManager.COMMIT_ACCEPTED = 0;
settingsManager.COMMIT_DENIED = 1;

function settingsManager:ctor()
	getDefinition("TypedList").ctor(self, "Setting");
	self:initChannels();
	self:initEvents();
end

function settingsManager:getSetting(name)
	for _, setting in self:enumerate() do
		if (setting:getName() == name) then
			return setting;
		end
	end
end

function settingsManager:hasSetting(name)
	return self:getSetting(name) != nil;
end

function settingsManager:initChannels()
	self._updateChannel = newInstance("NetworkChannel", "SettingsManager.UpdateChannel");
	self._updateChannel:getTransmissionReceivedEvent():subscribe(self, self.handleUpdate);
	self._requestChannel = newInstance("NetworkChannel", "SettingsManager.RequestChannel");
	self._requestChannel:getTransmissionReceivedEvent():subscribe(self, self.handleRequest);
	self._commitChannel = newInstance("NetworkChannel", "SettingsManager.CommitChannel");
	self._commitChannel:getTransmissionReceivedEvent():subscribe(self, self.handleCommit);
end

function settingsManager:getUpdateChannel()
	return self._updateChannel;
end

function settingsManager:getRequestChannel()
	return self._commitChannel;
end

function settingsManager:getCommitChannel()
	return self._commitChannel;
end

function settingsManager:initEvents()
	self._settingUpdatedEvent = newInstance("Event");
	self._requestAcceptedEvent = newInstance("Event");
	self._requestDeniedEvent = newInstance("Event");
	self._commitAcceptedEvent = newInstance("Event");
	self._commitDeniedEvent = newInstance("Event");
end

function settingsManager:getSettingUpdatedEvent()
	return self._settingUpdatedEvent;
end

function settingsManager:getRequestAcceptedEvent()
	return self._requestAcceptedEvent;
end

function settingsManager:getRequestDeniedEvent()
	return self._requestDeniedEvent;
end

function settingsManager:getCommitAcceptedEvent()
	return self._commitAcceptedEvent;
end

function settingsManager:getCommitDeniedEvent()
	return self._commitDeniedEvent;
end