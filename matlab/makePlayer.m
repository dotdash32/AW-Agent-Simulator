function player = makePlayer(parent, parentGen, round)
%makePlayer create a new BBplayer
if(parent == 0) %originator
    player.gen = 1;
    player.record = {round; 'Created, Originator'}; %whose nonkid
else
    player.gen = parentGen+1;
    text = sprintf("Created, %d's child", parent);
    player.record = {round; text}; %label parent
end
player.color = randi([1 360], 1); %assign color
player.sat = randi([0 100], 1); %assign saturation
player.rounds = [round, 0]; %still alive
player.lvl = 1; %start at round 1
player.kid = 0; %how many children
player.BP = 100; %starts with 100 points
player.exp = randi([1  10], 1); %base exp, from IRL?

end


% gen - which generation are they?
% color - what is their color 1-360
% sat - saturation 0-100
% rounds - which rounds did they play in [start end] 
%       if end != 0, they are dead
% BP - burst points, starts at 100, if hits 0 --> dead
% exp - personal experience, increments through battles
% record - cell of everything that happened
%   {round #, text description}