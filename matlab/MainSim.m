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

rng(2039); %set the seed

for numOrig = 1:100
    newPlayer = makePlayer(0,0,1);
    players = [players newPlayer];
end

%% Run sim

deadlist = []; %no one's dead yet
livelist = 1:100; %everyone's alive


for rounds = 1:400 %loop the simulation
    
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
        players = duel(players,per1,per2,rounds); %FIGHT
        fights = fights +1;
    end
    [players, deadlist, livelist] = killEm(players, rounds); %eliminate dead players
    players = lvlUp(players, rounds); %do level ups
    players = makeBabes(players, rounds); %add BP
end




