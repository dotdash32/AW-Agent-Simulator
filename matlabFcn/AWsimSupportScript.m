%% AWSimulation Support Script
% Run simulation function in here to create players
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

makePlayerPara.MoralBooster = 10; %multiplier for morality

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
killEmPara.usefulness = 'none'; %fill it out
%No other parameters

%lvlUp
lvlUpPara.points = [300 400 600 900 1500 3000 6000 10000]; %from JP wiki
    %number of points needed to increase in level
lvlUpPara.margin = 1.5; %total safety margin to level up
    
%makeBabes
makeBabesPara.chanceFcn = @(x) randi(floor(x/30)+1, 1); %chance function
    %if it is equal to itself, BB player has a child.  Should be decreasing
    %in frequency over time because the random range gets bigger

%Pure Colors
PureColors = struct('color', {0 60 120 240 300 180}, 'sat',...
    {100 100 100 100 100 0}, 'light', {50 50 50 50 50 100});
    %What colors will they be?  White Cosmos is "infinite" theta...
PureColorPara.exp = makePlayerPara.expMax*1.1; %super high
    %set it so they are always more powerful

%Apply all the parameters to one to send into function
GenPara.makePlayer = makePlayerPara;
GenPara.makeBabes = makeBabesPara;
GenPara.duel = duelPara;
GenPara.killEm = killEmPara; %non yet
GenPara.lvlUp = lvlUpPara;
GenPara.PureColor = PureColorPara; %might not exactly need it
GenPara.PureColors = PureColors;
GenPara.seedy = seedy; %seed number

%% Create structs
% gen - which generation are they?
% color - what is their color 1-360
% sat - saturation 0-100
% rounds - which rounds did they play in [start end] 
%       if end != 0, they are dead
% BP - burst points, starts at 100, if hits 0 --> dead
% exp - personal experience, increments through battles
%players = struct('gen','','color','', 'sat','','rounds','','BP','', 'exp','');

players = struct([]); %intiliaze

%make Pure Colors and follow them
for numPures = 1:6
    newPlayer = makePureColor(PureColors(numPures),PureColorPara);
        %create pure colors, only varying color, keeping Exp, etc const
    players = [players newPlayer];
end

%make Normal players
for numOrig = 7:100
    newPlayer = makePlayer(0,0,1, makePlayerPara);
    players = [players newPlayer];
end

%% Run the Sim

AWsim(players, roundLim, GenPara); %actually do it
