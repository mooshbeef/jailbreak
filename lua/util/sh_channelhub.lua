channelhub = channelhub or {};
channelhub.NETWORK_STRING = "networkchannel";

local channelInstances = {};
local networkingAvailable = false;

function channelhub.add(channel)
	assertArgument(1, "NetworkChannel");
	local channelName = channel:getChannelName();
	channelInstances[channelName] = channelInstances[channelName] or newInstance("WeakList");
	channelInstances[channelName]:add(channel);
end

function channelhub.encode(data)
	return util.Compress(pon.encode(data));
end

function channelhub.decode(message)
	return pon.decode(util.Decompress(message));
end

net.Receive(channelhub.NETWORK_STRING, function(length, ply)
	local contentLength = net.ReadUInt(32);
	local packet = channelhub.decode(net.ReadData(contentLength));
	local channelName = packet.channel;
	local data = packet.data;
	for _, channel in pairs(channelInstances[channelName]) do
		channel:receive(data, ply);
	end
end);

if SERVER then
	util.AddNetworkString(channelhub.NETWORK_STRING);
end

hook.Add("InitPostEntity", "channelhub", function()
	networkingAvailable = true;
end);

function channelhub.assertNetworkingAvailable()
	assert(networkingAvailable, "networking not yet available");
end

