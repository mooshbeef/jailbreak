local freeroam = newClass("Jailbreak.FreeRoamState", "Jailbreak.RoundState");

function freeroam:ctor(machine)
	getDefinition("Jailbreak.RoundState").ctor(self, "FreeRoam", machine);
end

function freeroam:enter()
	getDefinition("Jailbreak.RoundState").enter(self);
	game.CleanUpMap();
end

function freeroam:leave()
	getDefinition("Jailbreak.RoundState").leave(self);
	for _, ply in pairs(player.GetAll()) do
		if ply:Alive() then
			ply:KillSilent();
		end
	end
end

function freeroam:shouldStateChange()
	return #player.GetAll() >= 2;
end

function freeroam:getNextState()
	return self:getMachine():getState("Prepare");
end