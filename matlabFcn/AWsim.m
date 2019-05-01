function [] = AWsim(players,roundLim, GenPara)
%AWSIM Functionized simulation for Coder

%% Expand out parameters

makePlayerPara = GenPara.makePlayer;
makeBabesPara = GenPara.makeBabes;
duelPara = GenPara.duel;
killEmPara = GenPara.killEm; %non yet
lvlUpPara = GenPara.lvlUp;
PureColorPara = GenPara.PureColor; %might not exactly need it
PureColors = GenPara.PureColors;
seedy = GenPara.seedy; %rng seed

%% Define save parameters
simTitle=inputdlg('Sim Title, hit cancel to not save', 'Save Simulation?');
if(~isempty(simTitle)) %are we saving?
    simTitle = simTitle{1}; %to string
    saveInfo; %save information, now in separate script
    % Things to do
    %Add round number to bb chart
    % internlzie LIvelist funciton --> create mainsim function
    % make iterative version?  click through and analyze?
    
else %there's no value
    simTitle = 'noName'; %filler so it still graphs
end

%% Run Simulation
close all;

deadlist = []; %no one's dead yet
livelist = 1:100; %everyone's alive
bigData = struct; %empty, no data yet

[stateFig, movie] = graphImmediate(players, 0, livelist, 0, simTitle); %initialize

for rounds = 1:roundLim %loop the simulation
    
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
    players = makeBabes(players, rounds, makeBabesPara, makePlayerPara); %add players
    
    bigData = recordTrends(players, rounds, livelist, bigData); %record info
    
    %Graph each round's state
    [stateFig, movie] = graphImmediate(players, stateFig, livelist, movie, rounds);
    
    if(size(livelist,2)  <= 1)
        %can't duel any more
        break;
    end %if out of players
end

%% Graphing and Analysis
%Analyze what happened, hopefully

bigData(1).simmy = simTitle; %save it to pass in for graphing
[stateFig, movie] = graphImmediate(players, -1, livelist, movie, rounds); %initialize
fig = graphTrends(bigData, players); %graph what's happening

%still check if saving
if(~isempty(simTitle)) %are we saving?
    
    filepath1 = sprintf('SavedSims/%s/data.mat', simTitle); %for data
    filepath2 = sprintf('SavedSims/%s/trendsFig.fig', simTitle); %for figure
    filepath3 = sprintf('SavedSims/%s/trendsPic.png', simTitle); %for image
    save(filepath1, 'bigData','players'); %save data and players struct
    savefig(fig, filepath2); % save the figure
    print(fig, filepath3, '-dpng');
    
end 



end