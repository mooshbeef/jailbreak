local team = newClass("Team", "Base");

function team:ctor(identifier)
	assertArgument(2, "number");
	getDefinition("Base").ctor(self);
	self._name = "Unnamed";
	self._identifier = identifier;
	self._loadout = newInstance("Loadout");
	self._defaultPlayerModel = "models/Kleiner.mdl";
	self._playerJoinEvent = newInstance("Event");
	self._playerLeaveEvent = newInstance("Event");
	
	self:initLoadout(self:getLoadout());
end

function team:getIdentifier()
	return self._identifier;
end

function team:getName()
	return self._name;
end

function team:setName(value)
	assertArgument(2, "string");
	self._name = value;
end

function team:getLoadout()
	return self._loadout;
end

function team:setLoadout(value)
	self._loadout = value;
end

function team:initLoadout(loadout)
	
end

function team:getDefaultPlayerModel()
	return self._defaultPlayerModel;
end

function team:setDefaultPlayerModel(value)
	assertArgument(2, "string");
	self._defaultPlayerModel = value;
end

function team:getPlayerJoinEvent()
	return self._playerJoinEvent;
end

function team:getPlayerLeaveEvent()
	return self._playerLeaveEvent;
end

function team:selectSpawnPoint(ply)
	assertArgument(2, "Player");
	local spawns = ents.FindByClass("info_player_start");
	return spawns[math.random(#spawns)];
end

function team:handleSpawn(ply)
	assertArgument(2, "Player");
	self:applyObserverMode(ply);
	self:initializePlayer(ply);
	self:equipPlayer(ply);
	self:runLegacySpawnHooks(ply);
end

function team:applyObserverMode(ply)
	assertArgument(2, "Player");
	ply:UnSpectate();
end

function team:initializePlayer(ply)
	assertArgument(2, "Player");
	ply:SetupHands();
	ply:SetWalkSpeed(400);
	ply:SetRunSpeed(600);
	ply:SetCrouchedWalkSpeed(0.3);
	ply:SetDuckSpeed(0.3);
	ply:SetUnDuckSpeed(0.3);
	ply:SetJumpPower(200);
	ply:AllowFlashlight(true);
	ply:SetMaxHealth(100);
	ply:SetHealth(100);
	ply:SetArmor(0);
	ply:ShouldDropWeapon(true);
	ply:SetNoCollideWithTeammates(true);
	ply:SetAvoidPlayers(true);
end

function team:equipPlayer(ply)
	assertArgument(2, "Player");
	ply:StripWeapons();
	ply:StripAmmo();
	ply:SetModel(self:getDefaultPlayerModel());
	self:getLoadout():giveToPlayer(ply);
end

function team:runLegacySpawnHooks(ply)
	assertArgument(2, "Player");
	hook.Run("PlayerLoadout", ply);
	hook.Run("PlayerSetModel", ply);
end

function team:unequipPlayer(ply)
	assertArgument(2, "Player");
	ply:StripWeapons();
	ply:StripAmmo();
end

function team:onPlayerJoin(ply)
	assertArgument(2, "Player");
	self:getPlayerJoinEvent():fire(ply, self);
end

function team:onPlayerLeave(ply)
	assertArgument(2, "Player");
	self:getPlayerLeaveEvent():fire(ply, self);
end

function team:getPlayerCount()
	return #self:getPlayers();
end

function team:getPlayers()
	local players = {};
	for _, ply in pairs(player.GetAll()) do
		if (ply:getTeam() == self) then
			table.insert(players, ply);
		end
	end
	return players;
end

local meta = FindMetaTable("Player");

--The team class table is used as key to ensure that it is always unique

function meta:getTeam()
	return self[team];
end

function meta:setTeam(value)
	assertArgument(2, "Team", "nil");
	if (self[team] != nil) then
		self[team]:onPlayerLeave(self);
	end
	self[team] = value;
	value:onPlayerJoin(self);
end