%% Main simulation Body
%Create a simulation of Brain Burst in the early days

%% Define parameters
% Define parameters to be passed into functions, for easier editing

seedy = 2039; %save for later
rng(seedy); %set the seed

roundLim = 10; %how many rounds to run of the simulation


% makePlayer
makePlayerPara.expVer = 'cont'; %or discr
makePlayerPara.expRange = [1 10]; %range of experience values ('disc')
makePlayerPara.expMax = 10; %max of continuous exp vals ('cont')
    %adding options for continuous or discrete starting exps
makePlayerPara.valDistro = [7 6]; %A, B for beta distrobution
makePlayerPara.satDistro = [1.75 1.5]; %A, B for saturation (radius) distro

% makePlayerPara.MoralBooster = 10; %multiplier for morality

%duel
duelPara.expMod = .05; %modifier for experience gain
duelPara.drawTol = 5e-5; %tolerance for considering a draw
duelPara.highWinTrans = @(lvlDiff) round(10/(1+lvlDiff)); %points 
    %transferered when player with the higher level (is expected to) wins
duelPara.lowWinTrans = @(lvlDiff) (10*(1+lvlDiff)); %points transfered
    %when player with lower level (unexpected) wins
duelPara.equalWinTrans = 10; %points to transfer at the same level
duelPara.drawTrans = 0; %points to transfer for a draw
duelPara.lvlGain = @(lvl) lvl.^2; %how does your level win chance?

%killEm
%none here, nothing to change yet

%lvlUp
lvlUpPara.points = [300 400 600 900 1500 3000 6000 10000]; %from JP wiki
    %number of points needed to increase in level
lvlUpPara.margin = 1.5; %total safety margin to level up
    
%makeBabes
makeBabesPara.chanceFcn = @(x) randi(floor(x/30)+1, 1); %chance function
    %if it is equal to itself, BB player has a child.  Should be decreasing
    %in frequency over time because the random range gets bigger

%Pure Colors
PureColors = struct('color', {0 60 120 240 275 180}, 'sat',...
    {100 100 100 100 100 0}, 'light', {50 50 50 50 37 100});
    %What colors will they be?  White Cosmos is "infinite" theta...
PureColorPara.exp = makePlayerPara.expMax*1.1; %super high
    %set it so they are always more powerful


%% Title and Preface simulation
% Move titling up, and create text file of parameters


simTitle=inputdlg('Sim Title, hit cancel to not save', 'Save Simulation?');
if(~isempty(simTitle)) %are we saving?
    simTitle = simTitle{1}; %to string
    direc = ['SavedSims/' simTitle '/']; %concat for ease
    while(isfolder(direc)) %overwritting
        simTitle1 = inputdlg(sprintf(['Warning: Directory "%s" already'...
            ' exists, and will overwrite old data.\n  Do you wish to'...
            ' re-title the simulation?\n  Press Cancel to continue and'...
            ' overwrite existing data.'],simTitle),...
            'Warning!  Overwritting Data');
        if(isempty(simTitle1)) %we'll overwrite
            break;
        else
            simTitle = simTitle1{1}; %for new data
        end
    end
    saveInfo; %save information, now in separate script
    % Things to do
    %Add round number to bb chart
    % internlzie LIvelist funciton --> create mainsim function
    % make iterative version?  click through and analyze?
    
else %there's no value
    simTitle = 'noName'; %filler so it still graphs
end

%% Create structs
% gen - which generation are they?
% color - what is their color 1-360
% sat - saturation 0-100
% rounds - which rounds did they play in [start end] 
%       if end != 0, they are dead
% BP - burst points, starts at 100, if hits 0 --> dead
% exp - personal experience, increments through battles
%players = struct('gen','','color','', 'sat','','rounds','','BP','', 'exp','');

clear players; %start clean
players(100) = makePlayer(0,0,1, makePlayerPara); %start at end

%make Pure Colors and follow them
for numPures = 1:6
    newPlayer = makePureColor(PureColors(numPures),PureColorPara);
        %create pure colors, only varying color, keeping Exp, etc const
    players(numPures) = newPlayer;
end
%make Normal players
for numOrig = 7:99
    newPlayer = makePlayer(0,0,1, makePlayerPara);
    players(numOrig) = newPlayer;
end




%% Run sim

close all;

deadlist = []; %no one's dead yet
livelist = 1:100; %everyone's alive
bigData = struct; %empty, no data yet

[stateFig, movie] = graphImmediate(players, 0, livelist, 0, {0, simTitle}); %initialize

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
    [stateFig, movie] = graphImmediate(players, stateFig, livelist, movie,...
        {rounds, simTitle});
    if(size(livelist,2)  <= 1)
        %can't duel any more
        break;
    end %if out of players
end


%% Graphing and Analysis
%Analyze what happened, hopefully

bigData(1).simmy = simTitle; %save it to pass in for graphing
[stateFig, movie] = graphImmediate(players, -1, livelist, movie,...
    {rounds, simTitle}); %initialize
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

