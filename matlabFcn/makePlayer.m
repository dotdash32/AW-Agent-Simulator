function player = makePlayer(parent, parentGen, rounds, para)
%makePlayer create a new BBplayer

    %parameters to change:
    %para.expRange - vector of range of experiences
if(parent == 0) %originator
    player.gen = 1;
    player.record = {rounds; 'Created, Originator'}; %whose nonkid
else
    player.gen = parentGen+1;
    text = sprintf("Created, %d's child", parent);
    player.record = {rounds; text}; %label parent
end
player.color = randi([1 360], 1); %assign color
Av = para.valDistro(1); Bv = para.valDistro(2); %for simplicity
As = para.satDistro(1); Bs = para.satDistro(2); %for simplicity
maxRad = max(betapdf(0:.01:1,Av,Bv)); %dividing factor
player.val = round(100*random('beta',Av,Bv)); %assign lightness (HSL thingy)
player.sat = round(100*random('beta',As,Bs))*...%assign saturation
    (-abs(player.val-50)+50)/50;%modify radius like cone
    %(betapdf(player.val/100,Av,Bv)/maxRad); %modify radius
  
player.rounds = [rounds, 0]; %still alive
player.lvl = 1; %start at round 1
player.kid = 0; %how many children
player.BP = 100; %starts with 100 points
%player.morals = para.MoralBooster*rand(1); %morality parameter.  
    %Higher is more "Moral", less likely to be mean, NOT READY YET

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
% val - 1-100 value for HSV colors
% rounds - which rounds did they play in [start end] 
%       if end != 0, they are dead
% BP - burst points, starts at 100, if hits 0 --> dead
% exp - personal experience, increments through battles
% record - cell of everything that happened
%   {round #, text description}