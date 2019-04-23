function [player] = makePureColor(colorIn,params)
%makePureColor - make a pure color to easily follow interesting players
player.gen = 1;
player.record = {1; 'Created, Originator (Pure Color)'}; %whomstve

player.color = colorIn.color; %assign color
player.sat = colorIn.sat; %assign saturation
player.val = colorIn.light; %assign value (HSL thingy)
player.rounds = [1, 0]; %still alive
player.lvl = 1; %start at round 1
player.kid = 0; %how many children
player.BP = 100; %starts with 100 points

player.exp = params.exp; %specifically assign
player.wins = [0;1]; %how many wins
end