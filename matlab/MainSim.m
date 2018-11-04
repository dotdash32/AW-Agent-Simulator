%% Define parameters
% Define parameters to be passed into functions, for easier editing

rng(2039); %set the seed

% makePlayer
makePlayerPara.expRange = [1 20]; %range of experience values

%duel
duelPara.expMod = .01; %modifier for experience gain
duelPara.drawTol = 5e-5; %tolerance for considering a draw
duelPara.highWinTrans = @(lvlDiff) round(10/(1+lvlDiff)); %points 
    %transferered when player with the higher level (is expected to) wins
duelPara.lowWinTrans = @(lvlDiff) (10*(1+lvlDiff)); %points transfered
    %when player with lower level (unexpected) wins
duelPara.equalWinTrans = 10; %points to transfer at the same level
duelPara.drawTrans = 0; %points to transfer for a draw

%killEm
%none here, nothing to change yet

%lvlUp
lvlUpPara.points = [300 400 600 900 1500 3000 6000 10000]; %from JP wiki
    %number of points needed to increase in level
    
%makeBabes
makeBabesPara.chanceFcn = @(x) randi(floor(x/30)+1, 1); %chance function
    %if it is equal to itself, BB player has a child.  Should be decreasing
    %in frequency over time because the random range gets bigger


%% Create structs
% gen - which generation are they?
% color - what is their color 1-360
% sat - saturation 0-100
% rounds - which rounds did they play in [start end] 
%       if end != 0, they are dead
% BP - burst points, starts at 100, if hits 0 --> dead
% exp - personal experience, increments through battles
%players = struct('gen','','color','', 'sat','','rounds','','BP','', 'exp','');

players = []; %intiliaze


for numOrig = 1:100
    newPlayer = makePlayer(0,0,1, makePlayerPara);
    players = [players newPlayer];
end

%% Run sim

deadlist = []; %no one's dead yet
livelist = 1:100; %everyone's alive
bigData = struct; %empty, no data yet


for rounds = 1:50 %loop the simulation
    
    numsPicked = []; %zero out picked duelers
    fights = 0; %reset counter
    while fights < .8*((size(players,2)-size(deadlist,2))/2) 
                            %set number of duel 
        per1Ind = randi(size(livelist),1); %pick a player
        per1 = livelist(per1Ind); %assign them the actual number
        if(any(find(numsPicked == per1))) %already picked
            continue;
        end
        numsPickedMini = [numsPicked, per1]; %include per1 now
        per2Ind = randi(size(livelist),1); %pick a player
        per2 = livelist(per2Ind); %assign real number
        if(any(find(numsPickedMini == per2))) %already picked
            continue;
        end
        numsPicked = [numsPickedMini, per2]; %now include both pers
        players = duel(players,per1,per2,rounds, duelPara); %FIGHT
        fights = fights +1;
    end
    [players, deadlist, livelist] = killEm(players, rounds); %eliminate dead players
    players = lvlUp(players, rounds, lvlUpPara); %do level ups
    players = makeBabes(players, rounds, makeBabesPara); %add players
    
    bigData = recordTrends(players, rounds, livelist, bigData); %record info
    
end


%% Graphing and Analysis
%Analyze what happened, hopefully

fig = graphTrends(bigData); %graph what's happening



