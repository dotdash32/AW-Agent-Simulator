%% Save Simulation Information
%moving this to a separate script so the main one is that much cleaner.


direc = ['SavedSims/' simTitle '/']; %concat for ease
mkdir(direc); %create
fidInfo = fopen([direc,'README.md'],'w'); %info folder
fprintf(fidInfo,'# Brain Burst Simulation: %s \n\n',simTitle); %header
fprintf(fidInfo, '## Parameters \n### Global: \n\n');
fprintf(fidInfo, 'Seed: %d, Number of Rounds: %d \n\n',seedy, roundLim);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### makePlayer (Player Creation Function): \n\n');
fprintf(fidInfo, 'Experience Version: %s (continuous or discrete)\n\n',...
    makePlayerPara.expVer);
fprintf(fidInfo, ['Possible Experience Range: %d to %d',...
    '(discrete integer values only) \n\n'], ... 
    makePlayerPara.expRange(1), makePlayerPara.expRange(2));
fprintf(fidInfo, ['Maximum possible Experience: %d (continuous'...
    ' distrobution) \n\n'], makePlayerPara.expMax); 
fprintf(fidInfo, ['Beta Distrobution Factors for Saturation: A = %0.2f',...
    'B = %0.2f \n\n'],makePlayerPara.satDistro);
fprintf(fidInfo, ['Beta Distrobution Factors for Luminance: A = %0.2f',...
    'B = %0.2f \n\n'],makePlayerPara.valDistro);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### duel (Individual Duels): \n\n');
fprintf(fidInfo, 'Modifier for experience gain: %0.2e \n\n', duelPara.expMod);
fprintf(fidInfo, 'Tolerance for Draws: %0.2e \n\n', duelPara.drawTol);
fprintf(fidInfo, ['Point Transfer Function if Winner is higher ',...
    'levelled: %s \n\n'], func2str(duelPara.highWinTrans));
fprintf(fidInfo, ['Point Transfer Function if Winner is lower ',...
    'levelled: %s \n\n'], func2str(duelPara.lowWinTrans));
fprintf(fidInfo, ['Points to tranfer if both player are of',...
    ' equal level: %d \n\n'], duelPara.equalWinTrans);
fprintf(fidInfo,'Points to transfer in a draw: %d\n\n',duelPara.drawTrans);
fprintf(fidInfo, 'Level Contribution Function to Win Chance: %s \n\n',...
    func2str(duelPara.lvlGain));
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
    lvlUpPara.points); %fill in points, no way to reach lvl10
fprintf(fidInfo, 'Safety Margin Multiplier: %0.2f\n\n', lvlUpPara.margin);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### makeBabes (Create Gen2+ Players)\n\n');
fprintf(fidInfo, 'Chance of Kid Function: %s \n\n', ...
    func2str(makeBabesPara.chanceFcn));
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER

fprintf(fidInfo, '### Pure Colors (Easy to follow Players) \n\n');
fprintf(fidInfo, 'Color Values (HSL): \n'); %start table
fprintf(fidInfo, '|King |Color|Saturation|Luminance|\n');
fprintf(fidInfo, '|---|---|---|---|\n'); %table header
kingColors = {'Red' 'Yellow' 'Green' 'Blue' 'Purple' 'White'}; %king names
for indKings = 1:size([PureColors.color],2)
    fprintf(fidInfo, '| %s | %d | %d | %d |\n',...
        kingColors{indKings}, PureColors(indKings).color,...
        PureColors(indKings).sat, PureColors(indKings).light);
end
fprintf(fidInfo, '\n'); %add an extra newline for clarity
fprintf(fidInfo, 'Experience of each Pure Color: %0.2f\n\n', ...
    PureColorPara.exp);
fprintf(fidInfo, '--- \n\n'); %SECTION SEPARATER


fprintf(fidInfo, 'Graphical Trends in the Simulation:\n');
fprintf(fidInfo, '![Trends Graphs](trendsPic.png)\n\n'); %add image
