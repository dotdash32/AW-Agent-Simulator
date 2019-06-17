function [ret] = saveInfo(app)
%Save Simulation Information
%moving this to a separate script so the main one is that much cleaner.

if(strcmp(app.genPara.savePath, 'None Selected'))
    uialert(app.AWSim, 'Please select a save folder','No Save Path!');
    ret = 1;
    return; %leave and never return
end
direc = [app.genPara.savePath,'/',app.genPara.simTitle '/']; %concat for ease
if(isfolder(direc))
    resp = uiconfirm(app.AWSim, ['This folder already exists, '...
        'do you want to continue and overwrite it?'], ...
        'Continue and Overwrite?','Icon','warning');
    if(strcmp(resp, 'Cancel'))
        uialert(app.AWSim, ['Please change the save folder and try'...
            ' again.'], 'Reselect Folder');
        ret = 1; %full return
        return; %quit, don't save
    end %if response
else
    mkdir(direc); %create
end %isfolder
ret = 0; %not returning
fidInfo = fopen([direc,'README.md'],'w'); %info folder
fprintf(fidInfo,'# Brain Burst Simulation: %s \n\n', app.genPara.simTitle);
    %header, now with graphics close by
fprintf(fidInfo, 'Graphical Trends in the Simulation:\n\n');
fprintf(fidInfo, '![Trends Graphs](trendsPic.png)\n\n'); %add image
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '## Parameters \n### Global: \n\n');
fprintf(fidInfo, 'Seed: %d \n\n',app.genPara.seedy);
fprintf(fidInfo, 'Rounds to count as a Survivor: %d \n\n', ...
    app.genPara.SurvivRounds);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### makePlayer (Player Creation Function): \n\n');
fprintf(fidInfo, 'Experience Version: %s (continuous or discrete)\n\n',...
    app.makePlayerPara.expVer);
fprintf(fidInfo, ['Possible Experience Range: %d to %d',...
    '(discrete integer values only) \n\n'], ... 
    app.makePlayerPara.expRange(1), app.makePlayerPara.expRange(2));
fprintf(fidInfo, ['Maximum possible Experience: %d (continuous'...
    ' distrobution) \n\n'], app.makePlayerPara.expMax); 
fprintf(fidInfo, ['Beta Distrobution Factors for Saturation: A = %0.2f',...
    ' B = %0.2f \n\n'], app.makePlayerPara.satDistro);
fprintf(fidInfo, ['Beta Distrobution Factors for Luminance: A = %0.2f',...
    ' B = %0.2f \n\n'], app.makePlayerPara.lumDistro);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### duel (Individual Duels): \n\n');
fprintf(fidInfo, 'Modifier for experience gain: %0.2e \n\n', ...
    app.duelPara.expMod);
fprintf(fidInfo, 'Tolerance for Draws: %0.2e \n\n', app.duelPara.drawTol);
fprintf(fidInfo, ['Point Transfer Function if Winner is higher ',...
    'levelled: %s \n\n'], func2str(app.duelPara.highWinTrans));
fprintf(fidInfo, ['Point Transfer Function if Winner is lower ',...
    'levelled: %s \n\n'], func2str(app.duelPara.lowWinTrans));
fprintf(fidInfo, ['Points to tranfer if both player are of',...
    ' equal level: %d \n\n'], app.duelPara.equalWinTrans);
fprintf(fidInfo,'Points to transfer in a draw: %d\n\n',...
    app.duelPara.drawTrans);
fprintf(fidInfo, 'Level Contribution Function to Win Chance: %s \n\n',...
    func2str(app.duelPara.lvlGain));
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### killEm (Eliminate Players):\n\n');
fprintf(fidInfo, 'None here yet :(\n\n');
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### lvlUp (Level Up Players) \n\n');
fprintf(fidInfo, 'Points needed for each Level:\n\n'); 
fprintf(fidInfo, ['|Level|1 -> 2|2 -> 3|3 -> 4|4 -> 5|5 -> 6|6 -> 7|',...
    '7 -> 8|8 -> 9|9 -> 10|\n']); %start a table
fprintf(fidInfo, '|---|---|---|---|---|---|---|---|---|---|\n'); 
fprintf(fidInfo, '|Points|%d|%d|%d|%d|%d|%d|%d|%d|Undefined|\n\n',...
    app.lvlUpPara.points); %fill in points, no way to reach lvl10
fprintf(fidInfo, 'Safety Margin Multiplier: %s\n\n', ...
    func2str(app.lvlUpPara.margin));
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### makeBabes (Create Gen2+ Players)\n\n');
fprintf(fidInfo, 'Chance of Kid Function: %s \n\n', ...
    func2str(app.makeBabesPara.chanceFcn));
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### Pure Colors (Easy to follow Players) \n\n');
fprintf(fidInfo, 'Color Values (HSL): \n\n'); %start table
fprintf(fidInfo, '|King |Color|Saturation|Luminance|\n');
fprintf(fidInfo, '|---|---|---|---|\n'); %table header
kingColors = {'Red' 'Yellow' 'Green' 'Blue' 'Purple' 'White'}; %king names
for indKings = 1:size([app.PureColors.color],2)
    fprintf(fidInfo, '| %s | %d | %d | %d |\n',...
        kingColors{indKings}, app.PureColors(indKings).color,...
        app.PureColors(indKings).sat, app.PureColors(indKings).val);
end
fprintf(fidInfo, '\n'); %add an extra newline for clarity
fprintf(fidInfo, 'Experience of each Pure Color: %0.2f\n\n', ...
    app.PureColorPara.exp);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER


%Save parameters to file
genPara = app.genPara; % General Parameters
makePlayerPara = app.makePlayerPara; %makePlayer parameters
duelPara = app.duelPara; %duel parameters
killEmPara = app.killEmPara; %killEm parameters, not used
lvlUpPara = app.lvlUpPara; %lvlUp Parameters
makeBabesPara = app.makeBabesPara; %makeBabes Parameters
PureColors = app.PureColors; %PureColor player colors
PureColorPara = app.PureColorPara; %PureColor paramters

save([direc, 'parameters.mat'],'genPara','makePlayerPara','duelPara',...
    'killEmPara','lvlUpPara','makeBabesPara','PureColors','PureColorPara');

end
