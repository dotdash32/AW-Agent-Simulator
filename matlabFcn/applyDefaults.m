function [] = applyDefaults(app, loaded)
%Function to apply default parameters
%   loaded can be:
%       0 - nothing at all loaded, start from total defaulst
%       1 - restarting, so just save the filepath
%       2 - Loading old parameters, save everything but path
%% Def Parameters if new
if(any(loaded == [0 1])) %didn't load in old file
    app.genPara.seedy = 2039; %save for later
    rng(app.genPara.seedy); %set the seed
    app.genPara.simTitle = 'noName'; %so we can still graph
    app.genPara.SurvivRounds = 30; %how many rounds until a "survivor"
    app.genPara.preLoaded = 0; %didn't use another base
    if(loaded == 0) %none loaded at all
        app.genPara.savePath = 'None Selected';
    end 

    % makePlayer
    app.makePlayerPara.expVer = 'Continuous'; %or Discrete
    app.makePlayerPara.expRange = [1 10]; %range of experience values ('disc')
    app.makePlayerPara.expMax = 10; %max of continuous exp vals ('cont')
        %adding options for continuous or discrete starting exps
    app.makePlayerPara.lumDistro = [7 6]; %A, B for beta distrobution
    app.makePlayerPara.satDistro = [1.75 1.5]; %A, B for saturation (radius) distro

    % makePlayerPara.MoralBooster = 10; %multiplier for morality

    %duel
    app.duelPara.expMod = .05; %modifier for experience gain
    app.duelPara.drawTol = 5e-5; %tolerance for considering a draw
    app.duelPara.highWinTrans = @(lvlDiff) round(10/(1+lvlDiff)); %points 
        %transferered when player with the higher level (is expected to) wins
    app.duelPara.lowWinTrans = @(lvlDiff) (10*(1+lvlDiff)); %points transfered
        %when player with lower level (unexpected) wins
    app.duelPara.equalWinTrans = 10; %points to transfer at the same level
    app.duelPara.drawTrans = 0; %points to transfer for a draw
    app.duelPara.lvlGain = @(lvl) lvl.^2; %how does your level win chance?

    %killEm
    %none here, nothing to change yet

    %lvlUp
    app.lvlUpPara.points = [300 400 600 900 1500 3000 6000 10000]; %from JP wiki
        %number of points needed to increase in level
    app.lvlUpPara.margin = @() 1.5; %total safety margin to level up

    %makeBabes
    app.makeBabesPara.chanceFcn = @(rounds, lvl, gen) ...
        randi(floor(rounds/30)+1, 1); %chance function
        %if it is equal to itself, BB player has a child.  Should be decreasing
        %in frequency over time because the random range gets bigger

    %Pure Colors
    app.PureColors = struct('color', {0 60 120 240 275 180}, 'sat',...
        {100 100 100 100 100 0}, 'val', {50 50 50 50 37 100});
        %What colors will they be?  White Cosmos is "infinite" theta...
    app.PureColorPara.exp = 11; %super high
        %set it so they are always more powerful
        
   %round stuff
   app.currRound = 0;
   app.dispRound = 0; %start from zero every time

end %if loaded
%% Apply them into the thing
    
    app.SettingsTabs.Visible = 'on'; %make it visible again
    app.SettingsEditExplain.Visible = 'off';
    app.restartButt.Visible = 'off';
    app.restartButt.Enable = 'off'; %disable old stuff
    app.RunningGrid.Visible = 'off';
    app.RunTab.Title = 'Please setup First';
    pause('on'); %enable pls

    %General Tab
    app.RNGSeedField.Value = app.genPara.seedy;
    app.SimTitleField.Value = app.genPara.simTitle;
    app.SurvRounds.Value = app.genPara.SurvivRounds; 
    app.SaveFolderDisp.Value = app.genPara.savePath;
    app.LoadExistingPlayersButt.BackgroundColor = [.96 .96 .96];
    
    %makePlayer Tab
    %Exp
    app.ExpModeSwi.Value = app.makePlayerPara.expVer;
    app.ContMaxExp.Value = app.makePlayerPara.expMax;
    app.DiscMaxExp.Value = app.makePlayerPara.expRange(2);
    app.DiscMinExp.Value = app.makePlayerPara.expRange(1);
    %Color
    app.SatA.Value = app.makePlayerPara.satDistro(1);
    app.SatB.Value = app.makePlayerPara.satDistro(2);
    app.LumA.Value = app.makePlayerPara.lumDistro(1);
    app.LumB.Value = app.makePlayerPara.lumDistro(2);
    
    %duel
    app.ExpModField.Value = app.duelPara.expMod;
    app.DrawTolField.Value = app.duelPara.drawTol;
    sp = {'@(lvl)', '@(lvlDiff)'}; %for splitting function strings
    tempFcn = strsplit(func2str(app.duelPara.lvlGain), sp{1});
    app.lvlExpContFunc.Value = tempFcn{end};
    tempFcn1 = strsplit(func2str(app.duelPara.highWinTrans),sp{2});
    tempFcn2 = strsplit(func2str(app.duelPara.lowWinTrans),sp{2});
    app.HighWinFunc.Value = tempFcn1{end};
    app.LowWinFunc.Value = tempFcn2{end};
    app.EqualLvlTrans.Value = app.duelPara.equalWinTrans;
    app.DrawTrans.Value = app.duelPara.drawTrans;
    
    %killEm
    %None here :(
    
    %lvlUp
    tempFcn3 = strsplit(func2str(app.lvlUpPara.margin),'@()');
    app.lvlUpFOS.Value = tempFcn3{end};
    app.lvlUpPointsTable.Data = {'1 --> 2'; '2 --> 3'; '3 --> 4';...
        '4 --> 5'; '5 --> 6'; '6 --> 7'; '7 --> 8'; '8 --> 9'};
    app.lvlUpPointsTable.Data(:,2) = num2cell(app.lvlUpPara.points');
    app.lvlUpPointsTable.ColumnEditable = logical([0 1]); %can only changes pts
    
    %makeBabes
    tempFcn4 = strsplit(func2str(app.makeBabesPara.chanceFcn),...
        '@(rounds,lvl,gen)');
    app.kidChanceFcn.Value = tempFcn4{end};
    
    %Pure Colors
    app.PCexp.Value = app.PureColorPara.exp;
    dat = struct2cell(app.PureColors); %3x1x6, [hue; sat; light]
    app.PureColorTable.RowName = {'Red'; 'Yellow'; 'Green'; 'Blue'; ...
        'Purple'; 'White'}; %names
    app.PureColorTable.ColumnName = {'Hue','Sat','Lum'}; %titles
    app.PureColorTable.Data(:,1) = [dat{1,1,:}]; %colors
    app.PureColorTable.Data(:,2) = [dat{2,1,:}]; %sats
    app.PureColorTable.Data(:,3) = [dat{3,1,:}]; %lums
    app.PureColorTable.ColumnEditable = true;
    app.PCColorDisplay.Data = cell([6,1]);
    app.PCColorDisplay.BackgroundColor = BBcolors2RGB(app.PureColors,0);
    
    %Export settings
    app.VidFrameRate.Value = 5; 
    app.VidIntroLength.Value = 1; %reset
    app.PicName.Value = 'trendsPic';
    app.VidName.Value = 'BBoverTime'; %defaults for display
    
    
    %Run tabs - things that need to be static
%     app.LvlCompTable.ColumnName = {'Lvl 1', 'Lvl 2', 'Lvl 3', 'Lvl 4',...
%         'Lvl 5', 'Lvl 6', 'Lvl 7', 'Lvl 8', 'Lvl 9', 'Lvl 10'};
%     app.LvlCompTable.RowName = '% Players';
%     

%% Reset graphs on restart
if(loaded == 1) %restarting
    for indAx = fieldnames(app.roundLines)'
        cla(app.(indAx{1}), 'reset') %clear axes
    end %for axes
    app.DispSlider.Limits = [0 realmax]; %so we can move our setpoint
    app.DispSlider.Value = 0;
    app.DispSlider.Limits = [0 0.1]; %can't move
    app.DispSpinner.Limits = [0 realmax]; %so we can move
    app.DispSpinner.Value = 0;
    app.DispSpinner.Limits = [0 0.1]; %resolidify
    app.MaxRounds.Value = 0; 
    app.RunXSpinner.Value = 10;
end
end
