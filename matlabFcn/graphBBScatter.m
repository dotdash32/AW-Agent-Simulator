function [] = graphBBScatter(app)
%graphBBScatter Graph the scatterplot of BP

hold(app.BPScatterAxes, 'off'); %clear it as we re-plot
tic
if(app.currRound == 0) %haven't run it yet)
    livelist = 1:100; %all alive at start
    playersInt = app.players(livelist); %only the ones who are alive
    
    %update other fields
    app.BPdispRound.Value = 100^2;
    app.TotalPlayersRound.Value = 100;
    app.PlayersAliveRound.Value = 100;
    app.OgsAliveRound.Value = 100;
    app.TotalExpRound.Value = mean([app.players.exp]);
    app.TotalPlayersRound1.Value = 100;
    app.SurvExpRound.Value = mean([app.players.exp]);
    app.SurvPlayersRound.Value = 0;

    %tables
    app.LvlCompTable.Data = [100 0 0 0 0 0 0 0 0 0]; %level %
    app.PureColorBPDisp.Data = [100 100 100 100 100 100]; %Pure Colors
else %all other rounds
    livelist = find([app.bigData(app.dispRound).play.BP] > 0);
    playersInt = app.bigData(app.dispRound).play(livelist);
    
    %update other fields
    app.BPdispRound.Value = app.bigData(app.dispRound).totalBP;
    app.TotalPlayersRound.Value = app.bigData(app.dispRound).totalPlayers;
    app.PlayersAliveRound.Value = app.bigData(app.dispRound).alivePlayers;
    app.OgsAliveRound.Value = app.bigData(app.dispRound).liveOrig;
    app.TotalExpRound.Value = app.bigData(app.dispRound).avgExp;
    app.TotalPlayersRound1.Value = app.bigData(app.dispRound).totalPlayers;
    if(isnan(app.bigData(app.dispRound).livingExp)) %is it a number?
        app.SurvExpRound.Value = 0; %sad
    else
        app.SurvExpRound.Value = app.bigData(app.dispRound).livingExp;
    end
    app.SurvPlayersRound.Value = app.bigData(app.dispRound).livings;

    %tables
    app.LvlCompTable.Data = app.bigData(app.dispRound).perLevel*100;%level %
    app.PureColorBPDisp.Data = app.bigData(app.dispRound).Origis(1:6);
end %if round 0

FieldUpdates = toc


cRGB = BBcolors2RGB(app.players(livelist), 0); %convert colors
wins = [playersInt.wins]'; %convert to vector
winRate = wins(:,1)./wins(:,2); %calculate win rate
scatter(app.BPScatterAxes, [playersInt.exp], winRate, [playersInt.BP],...
    cRGB, 'filled'); %plot
hold(app.BPScatterAxes, 'on')
legendo = {'Dot Color is player color'}; %initailize

Scatter1 = toc

playersO = playersInt(livelist <= 100); %originators
if(~isempty(playersO)) %none left
    winsO = [playersO.wins]'; %convert to vector
    winRateO = winsO(:,1)./winsO(:,2); %calculate win rate
    OrigRGB = BBcolors2RGB(app.players(livelist <= 100),1); %get colors
    scatter(app.BPScatterAxes,[playersO.exp], winRateO, ...
        [playersO.BP]/6, OrigRGB, 'd', 'filled') %mark whose orignating
    legendo{end+1} = sprintf('Originator (%d Left)',...
        size(playersO,2)); %add counter
end

ScatterOrigs = toc

%bords ={'k','b','g','r','c','m','y',[1 .4 .6] [1 .5 .5] [1 .5 0]};
bords2 =   [     0    0.4470    0.7410
            0.8500    0.3250    0.0980
            0.9290    0.6940    0.1250
            0.4940    0.1840    0.5560
            0.4660    0.6740    0.1880
            0.3010    0.7450    0.9330
            0.6350    0.0780    0.1840
                 0    0.4470    0.7410
            0.8500    0.3250    0.0980
            0.9290    0.6940    0.1250]; %new colors
for indLvl = 1:10 %for each level
    playersS = playersInt([playersInt.lvl] == indLvl);
        %only the players of each level
    if(isempty(playersS))
        continue; %don't do empty levels
    end
    wins1 = [playersS.wins]'; %convert to vector
    winRate1 = wins1(:,1)./wins1(:,2); %calculate win rate
    scatter(app.BPScatterAxes,[playersS.exp], winRate1, [playersS.BP]+1,...
        bords2(indLvl,:), 'LineWidth', 1); %plot by level
    legendo{end+1} = sprintf('Level %d (%d Players)',...
        indLvl, size(playersS,2)); %legend
end

ScatterLevels = toc

hold(app.BPScatterAxes, 'off')
xlabel(app.BPScatterAxes, 'Player Experience');
ylabel(app.BPScatterAxes, 'Player Win Rate');
title(app.BPScatterAxes, ['Evolution of Brain Burst Following every '...
    'player inside the simulation']);
legend(app.BPScatterAxes, legendo,'Location','southeast'); %with each color
text(app.BPScatterAxes, 0, .9, sprintf(['   Dot Size corresponds to number of BP '...
    '\n   Round: ' num2str(app.dispRound)]));
app.BPScatterAxes.XLim = [0 max([app.players.exp])*1.1]; %approximating
app.BPScatterAxes.YLim = [0 1]; %keeping it consistent

%indicator lines
timTam = cell(0);
for indAx = fieldnames(app.roundLines)' %for each axis
%     if(strcmp(indAx{1},'BPExpAxes')) %weird on
%         yyaxis(app.(indAx{1}), 'right'); %maybe? - yes, works!
%     end
    delete(app.roundLines.(indAx{1})); %clear line
    if(strcmp(indAx{1}, 'LevelAreaAxes')) % white line, hard to see
        app.roundLines.(indAx{1}) = plot(app.(indAx{1}), ...
            app.dispRound*[1 1], ylim(app.(indAx{1})),'w--','LineWidth',1);
    else %normal axes, plot red
        app.roundLines.(indAx{1}) = plot(app.(indAx{1}), ...
            app.dispRound*[1 1], ylim(app.(indAx{1})),'r--','LineWidth',1);
    end
    timTam{end+1} = toc
end %for axes, creating display lines
legend(app.BPExpAxes, {'Total Average Exp','Survivor Average Exp',...
        'Total Players','Survivors'},'Location','best'); %remove line
legend(app.PureColorsAxes, {'1: Red','2: Yellow', '3: Green','4: Blue',...
    '5: Purple','6: White'},'Location','best');

finalTime = toc
end