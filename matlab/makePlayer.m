function player = makePlayer(parent, parentGen, round, para)
%makePlayer create a new BBplayer

    %parameters to change:
    %para.expRange - vector of range of experiences
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
player.val = randi([0 100], 1); %assign value (HSV thingy)
player.rounds = [round, 0]; %still alive
player.lvl = 1; %start at round 1
player.kid = 0; %how many children
player.BP = 100; %starts with 100 points

%base exp, from IRL?
if(strcmp(para.expVer,'cont')) %continuous distrobution
    player.exp = rand(1)*para.expMax; %between 0-expMax
elseif(strcmp(para.expVer,'disc')) %discrete integer vals
    player.exp = randi(para.expRange, 1); %only ints allowed
end
player.wins = [0;1]; %how many wins/total battles

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