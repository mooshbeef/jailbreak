local guards = newClass("Jailbreak.GuardsTeam", "Jailbreak.Team");

function guards:ctor(identifier)
	getDefinition("Jailbreak.Team").ctor(self, identifier);
	self:setName("guards");
end

function guards:initLoadout(loadout)
	
end
