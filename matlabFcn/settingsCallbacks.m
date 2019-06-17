function [] = settingsCallbacks(app, event)
%settingsCallbacks Callback functions for the setup tab
%   The hope is to keep the majority of the text out of the "app" itself so
%   that it is more github trackable, and will be a little cleaner to edit
%   on my end, since it's not just one huge body of text, but several
%   smaller functions, and so people can more easily see this without
%   having matlab appdesigner themselves.

sp = {'@(lvl)', '@(lvlDiff)'}; %for splitting function strings
switch event.Source
    %General Tab
    case app.RNGSeedField %set RNG seed
        app.genPara.seedy = app.RNGSeedField.Value;
        rng(app.genPara.seedy); %reset RNG seed
    case app.SimTitleField %simulation title
        app.genPara.simTitle = app.SimTitleField.Value;
    case app.SurvRounds %rounds until surivor
        app.genPara.SurvivRounds = app.SurvRounds.Value;
    case app.SaveFolderButt
        tempy = uigetdir; %get folder location
        if(tempy ~= 0) %cancelled
            app.genPara.savePath = tempy;
        end
        app.SaveFolderDisp.Value = app.genPara.savePath;
    case app.LoadExistingParaButt
        [f, p] = uigetfile('parameters.mat', ...
            'Choose Existing Simulation Parameters'); %get old file
        if(f ~= 0) %not cancelled
            S = load([p, f]); %get the files in
            oldPath = app.genPara.savePath; %save it to replace in
            app.genPara = S.genPara; % General Parameters
            app.genPara.savePath = oldPath; %replace it
            app.makePlayerPara = S.makePlayerPara; %makePlayer parameters
            app.duelPara = S.duelPara; %duel parameters
            app.killEmPara = S.killEmPara; %killEm parameters, not used
            app.lvlUpPara = S.lvlUpPara; %lvlUp Parameters
            app.makeBabesPara = S.makeBabesPara; %makeBabes Parameters
            app.PureColors = S.PureColors; %PureColor player colors
            app.PureColorPara = S.PureColorPara; %PureColor paramters
            applyDefaults(app,2); %don't reset at all
        end
    case app.LoadExistingPlayersButt
        [f, p] = uigetfile('playersAndData.mat',...
            'Select Players and Data File');
        S = load([p,f]); %load in files
        app.players = S.players;
        app.bigData = S.bigData;
        app.currRound = size(app.bigData,2);
        app.dispRound = app.currRound;
        app.genPara.preLoaded = 2; %have players
        app.LoadExistingPlayersButt.BackgroundColor = [0 .96 0]; %green
        
    %Save and start - last thing on this screen
    case app.SaveAndStart
        ret = saveInfo(app); %save to folder
        if(ret == 1)
            return; %quit all the way up.
        end
        app.SettingsTabs.Visible = 'off'; %make it invisible
        app.SettingsEditExplain.Visible = 'on';
        app.restartButt.Visible = 'on';
        app.restartButt.Enable = 'on'; %enable restart stuff
        app.RunningGrid.Visible = 'on';
        app.RunTab.Title = 'Run';
        if(any(app.genPara.preLoaded == [0 1])) %new sim
            createStructs(app); %make the players
            app.bigData = [];
        else
            graphTrends(app); %if there's a preloaded thingy
            if(app.currRound == 1) % first round
                app.DispSlider.Limits = [1 1.1];
                app.DispSpinner.Limits = [1 1.1];
                app.DispSlider.Value = 1;
                app.DispSpinner.Value = 1;
                app.MaxRounds.Value = 1;
            else
                app.DispSlider.Limits = [1 app.currRound];
                app.DispSpinner.Limits = [1 app.currRound];
                app.DispSlider.Value = app.dispRound;
                app.DispSpinner.Value = app.dispRound;
                app.MaxRounds.Value = app.currRound;
            end
        end
%         axles = {'TotPlayandBPAxes', 'AliveOverTimeAxes','BPExpAxes',...
%             'LevelAreaAxes', 'OrigsBPAxes', 'PureColorsAxes'}; %all axes
        for indAx = fieldnames(app.roundLines)' %for each axis
            app.roundLines.(indAx{1}) = plot(app.(indAx{1}), ...
                app.currRound*[1 1], ylim(app.(indAx{1})),'r');
        end %for axes, creating display lines
        graphBBScatter(app); %preload stuff
        app.TrendyPicButton.Enable = 'off';
        app.BBVidButton.Enable = 'off'; %need data before graphing
%         app.sliderTimer = timer('ExecutionMode', 'FixedSpacing','Name',...
%             'sliderUpdateTimer','Period',.1, 'TimerFcn',...
%             {@slideUpdate, app, event});

            
        
    %makePlayer Tab
    %Exp
    case app.ExpModeSwi
        app.makePlayerPara.expVer = app.ExpModeSwi.Value;
    case app.ContMaxExp
        app.makePlayerPara.expMax = app.ContMaxExp.Value;
    case app.DiscMaxExp
        app.makePlayerPara.expRange(2) = app.DiscMaxExp.Value;
    case app.DiscMinExp
        app.makePlayerPara.expRange(1) = app.DiscMinExp.Value;
    %Color
    case app.SatA
        app.makePlayerPara.satDistro(1) = app.SatA.Value;
    case app.SatB
        app.makePlayerPara.satDistro(2) = app.SatB.Value;
    case app.LumA
        app.makePlayerPara.lumDistro(1) = app.LumA.Value;
    case app.LumB
        app.makePlayerPara.lumDistro(2) = app.LumB.Value;
    
    %duel
    case app.ExpModField
        app.duelPara.expMod = app.ExpModField.Value;
    case app.DrawTolField
        app.duelPara.drawTol = app.DrawTolField.Value;
    case app.lvlExpContFunc
        app.duelPara.lvlGain = funcyDunc(app, app.lvlExpContFunc.Value,...
            sp{1});
    case app.HighWinFunc
        app.duelPara.highWinTrans = funcyDunc(app, app.HighWinFunc.Value,...
            sp{2});
    case app.LowWinFunc
        app.duelPara.lowWinTrans = funcyDunc(app, app.LowWinFunc.Value,...
            sp{2});
    case app.EqualLvlTrans
        app.duelPara.equalWinTrans = app.EqualLvlTrans.Value;
    case app.DrawTrans
        app.duelPara.drawTrans = app.DrawTrans.Value;
    
    %killEm
    %none, again
    
    %lvlUp
    case app.lvlUpFOS
        app.lvlUpPara.margin = funcyDunc(app, app.lvlUpFOS.Value,'@()');
    case app.lvlUpPointsTable
        app.lvlUpPara.points(event.Indices(1)) = event.NewData;
%     app.lvlUpPointsTable.Data(:,2) = app.lvlUpPara.points';
        
    %makeBabes
    case app.kidChanceFcn
        app.makeBabesPara.chanceFcn = funcyDunc(app, ...
            app.kidChanceFcn.Value, '@(rounds,lvl,gen)');
    
    %Pure Colors
    case app.PCexp
        app.PureColorPara.exp = app.PCexp.Value;
    case app.PureColorTable
        field = {'color', 'sat', 'val'}; %placeholders
        app.PureColors(event.Indices(1)).(field{event.Indices(2)}) = ...
            event.NewData;
        app.PCColorDisplay.BackgroundColor = BBcolors2RGB(app.PureColors);
        
    %Restart
    case app.restartButt
        direc = [app.genPara.savePath,'/',app.genPara.simTitle '/']; 
        players = app.players; %players struct
        bigData = app.bigData; %historical Data
        save([direc 'playersAndData.mat'], 'players','bigData');
        applyDefaults(app, 1); %reset from zero, but save filepath
end %switch
end


function [func] = funcyDunc(app, expression, header)
%funcyDunc Test and build function handles
%   Also checks if the function is a valid matlab func and error catches
    try %in case func invalid
        func = eval([header,' ',expression]);
    catch
        func = NaN;
        uialert(app.AWSim,'Please use a valid MATLAB Function',...
            'Error: Invalid Function','Icon','error');

    end
end

function [] = createStructs(app)
% Create structs
% gen - which generation are they?
% color - what is their color 1-360
% sat - saturation 0-100
% rounds - which rounds did they play in [start end] 
%       if end != 0, they are dead
% BP - burst points, starts at 100, if hits 0 --> dead
% exp - personal experience, increments through battles
%   players = struct('gen','','color','', 'sat','','rounds','','BP','',
%       'exp','');

clear app.players; %start clean
app.players = makePlayer(0,0,1, app.makePlayerPara); %needs to init
app.players(100) = makePlayer(0,0,1, app.makePlayerPara); %start at end

%make Pure Colors and follow them
for numPures = 1:6
    newPlayer = makePureColor(app.PureColors(numPures), app.PureColorPara);
        %create pure colors, only varying color, keeping Exp, etc const
    app.players(numPures) = newPlayer;
end
%make Normal players
for numOrig = 7:99
    newPlayer = makePlayer(0,0,1, app.makePlayerPara);
    app.players(numOrig) = newPlayer;
end

end

function [] = slideUpdate(~, ~, app, ~)
%slideUpdate - update the slider in real time
%   will end up disabling callbacks for it though...
if(app.dispRound ~= app.DispSlider.Value) %mismatch
    disp('tim tim!');
    app.dispRound = round(app.DispSlider.Value); %round display
    app.DispSpinner.Value = app.dispRound; %display
    app.DispSlider.Value = app.dispRound; %discretize?
    graphBBScatter(app); %regraph
end %if need to do stuff
end