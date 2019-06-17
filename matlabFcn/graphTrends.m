function [] = graphTrends(app)
%graphTrends Visualize general trends in the simulation
    %plot total players, alive players, and total BP
    
    %bigData is indexed to round, fields:
    %totalBP - total amount of BP per round
    %totalPlayers - how many players were there
    %alivePlayers - how many players are alive?
    %avgExp - average experience of alive players
    
%     fig = figure('Position',[10 10 1400 700]); %assignment
    roundi = 1:app.currRound; %x points
%     sgtitle(sprintf('Trends for %s', bigData(1).simmy)); %subplot title
    
    %Total BP and Players
    yyaxis(app.TotPlayandBPAxes, 'right'); %total players
    hold(app.TotPlayandBPAxes, 'off');
    plot(app.TotPlayandBPAxes, [0 roundi], ...
        [100 app.bigData.totalPlayers],'-');
    hold(app.TotPlayandBPAxes, 'on');
    ylabel(app.TotPlayandBPAxes, 'Total Players');
    yyaxis(app.TotPlayandBPAxes, 'left'); %Burst Points
    plot(app.TotPlayandBPAxes, [0 roundi], ...
        [10000 app.bigData.totalBP], '-');%total BP
    ylabel(app.TotPlayandBPAxes, 'BP at each Round');
    title(app.TotPlayandBPAxes, 'Total Players and BP per round');
    xlabel(app.TotPlayandBPAxes, 'Rounds');
    app.TotPlayandBPAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(app.TotPlayandBPAxes); %fixed
%     datacursormode(app.TotPlayandBPAxes); %clicky points
    app.TotPlayandBPAxes.Toolbar.Visible = 'off';
%     app.TotPlayandBPAxes.Interactions = dataTipInteraction; \
        %no need for data cursor, have it on field displays
    
    
    %Alive Players over Time
    yyaxis(app.AliveOverTimeAxes, 'left'); %all players
    hold(app.AliveOverTimeAxes, 'off');
    plot(app.AliveOverTimeAxes, [0 roundi], ...
        [100 app.bigData.alivePlayers], '-'); %currently alive players
    hold(app.AliveOverTimeAxes, 'on');
    ylabel(app.AliveOverTimeAxes, 'Players Alive');
    yyaxis(app.AliveOverTimeAxes, 'right'); %origniators
    plot(app.AliveOverTimeAxes, [0 roundi], ...
        [100 app.bigData.liveOrig], '-');
    ylabel(app.AliveOverTimeAxes, 'Originators Alive');
    title(app.AliveOverTimeAxes, 'Alive Players over Time');
    xlabel(app.AliveOverTimeAxes, 'Rounds');
%     text(app.AliveOverTimeAxes, roundi(end),app.bigData(end).liveOrig,...%how 
%         sprintf('%d Still Alive ', app.bigData(end).liveOrig), ...   %many
%         'HorizontalAlignment','right','VerticalAlignment','bottom'); %alive
    app.AliveOverTimeAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(app.AliveOverTimeAxes); %fixing
    app.AliveOverTimeAxes.Toolbar.Visible = 'off';
    

    %Average Experience
    yyaxis(app.BPExpAxes, 'right'); %Num Players
    hold(app.BPExpAxes, 'off');
    plot(app.BPExpAxes, [0 roundi], [100 app.bigData.alivePlayers],'r-');
    hold(app.BPExpAxes, 'on');
    plot(app.BPExpAxes, [0 roundi], [0 app.bigData.livings],'-','Color',...
        [1 .5 0]); %num of survivors
    ylabel(app.BPExpAxes, 'Num Players');
    yyaxis(app.BPExpAxes, 'left'); %AVG EXP
    hold(app.BPExpAxes, 'off');
    plot(app.BPExpAxes, roundi, [app.bigData.avgExp],'b-'); %average exp
    hold(app.BPExpAxes, 'on');
    plot(app.BPExpAxes, roundi, [app.bigData.livingExp],'Color',[0 .5 1]); 
        %avg exp of survivors
    ylabel(app.BPExpAxes, 'Average Experience');
    title(app.BPExpAxes, 'Average Experience');
    xlabel(app.BPExpAxes, 'Rounds');
    legend(app.BPExpAxes, {'Total Average Exp','Survivor Average Exp',...
        'Total Players','Survivors'},'Location','best');
    app.BPExpAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(app.BPExpAxes); %fix
    app.BPExpAxes.Toolbar.Visible = 'off';
    
   
 	%Level Composition
    hold(app.LevelAreaAxes, 'off');
    dat =[1 0 0 0 0 0 0 0 0 0; reshape([app.bigData.perLevel],10,[])'];
        %so we can also do round 0
    area(app.LevelAreaAxes, [0 roundi], dat);
    title(app.LevelAreaAxes, 'Level Composition');
    xlabel(app.LevelAreaAxes, 'Rounds');
    ylabel(app.LevelAreaAxes, 'Percent at each Level');
    app.LevelAreaAxes.XLim = [0 app.currRound];
    hold(app.LevelAreaAxes, 'on'); %for indicator line
    disableDefaultInteractivity(app.LevelAreaAxes); %fix
    app.LevelAreaAxes.Toolbar.Visible = 'off'; 
    

    %Each originator over time
    hold(app.OrigsBPAxes, 'off');
    cRGB = BBcolors2RGB(app.players(1:100), 0); %get colors
    arrayData = [app.bigData.Origis]; %into an array
    for indP = 1:100
        plot(app.OrigsBPAxes, [0 roundi], [100 arrayData(indP:100:end)],...
            'Color', cRGB(indP,:)); %avg exp of survivors
        if(indP == 1)
            hold(app.OrigsBPAxes, 'on');
        end %one hold on
    end
    title(app.OrigsBPAxes, 'BP of Originators');
    xlabel(app.OrigsBPAxes, 'Rounds');
    ylabel(app.OrigsBPAxes, 'BP');
    app.OrigsBPAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(app.OrigsBPAxes); %fix
    app.OrigsBPAxes.Toolbar.Visible = 'off';
    
    %BP of Pure Colors
    hold(app.PureColorsAxes, 'off');
    legendo = cell(6,1); %initalize
    King = {'Red','Yellow', 'Green','Blue','Purple','White'}; %names
    cRGBO = BBcolors2RGB(app.players(1:6),0); %get origi colors
    cRGBO(6,:) = [.7 .7 .7]; %so white isn't pure white
    arrayData1 = [app.bigData.pureBP]; %arrayify
    for indPure = 1:6
        plot(app.PureColorsAxes, [0 roundi], [100 arrayData1(...
            indPure:6:end)], 'Color', cRGBO(indPure,:), ...
            'LineWidth', 1); %just pure colors
        legendo{indPure} = sprintf('%d: %s', indPure, King{indPure}); 
            %label who is who
        if(indPure == 1)
            hold(app.PureColorsAxes, 'on');
        end %only 1 hold on

    end
    legend(app.PureColorsAxes, legendo,'Location','best'); %whomstve
    title(app.PureColorsAxes, 'BP of Pure Colors');
    xlabel(app.PureColorsAxes, 'Rounds');
    ylabel(app.PureColorsAxes, 'BP');
    app.PureColorsAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(app.PureColorsAxes); %fix
    app.PureColorsAxes.Toolbar.Visible = 'off';
end


