function [] = saveTrends(app)
%saveTrends Visualize general trends in the simulation and save
    %plot total players, alive players, and total BP
    
    %bigData is indexed to round, fields:
    %totalBP - total amount of BP per round
    %totalPlayers - how many players were there
    %alivePlayers - how many players are alive?
    %avgExp - average experience of alive players
    
%     fig = figure('Position',[10 10 1400 700]); %assignment
    fig = figure('CloseRequestFcn',{@TrendPicClose, app},...
                 'WindowState','maximized');
    pause(0.001);
    fig.Visible = 'off'; %make it disappear?
%     ax = gca;
%     outerpos = ax.OuterPosition;
%     ti = ax.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     ax.Position = [left bottom ax_width ax_height];
    
    roundi = 1:app.currRound; %x points
    sgtitle(sprintf('Trends for %s', app.genPara.simTitle)); %subplot title

    %Total BP and Players
    TotPlayandBPAxes = subplot(4, 2, 1); %subplots
    yyaxis(TotPlayandBPAxes, 'right'); %total players
    hold(TotPlayandBPAxes, 'off');
    plot(TotPlayandBPAxes, [0 roundi], ...
        [100 app.bigData.totalPlayers],'-');
    hold(TotPlayandBPAxes, 'on');
    ylabel(TotPlayandBPAxes, 'Total Players');
    yyaxis(TotPlayandBPAxes, 'left'); %Burst Points
    plot(TotPlayandBPAxes, [0 roundi], ...
        [10000 app.bigData.totalBP], '-');%total BP
    ylabel(TotPlayandBPAxes, 'BP at each Round');
    title(TotPlayandBPAxes, 'Total Players and BP per round');
    xlabel(TotPlayandBPAxes, 'Rounds');
    TotPlayandBPAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(TotPlayandBPAxes); %fixed
%     datacursormode(app.TotPlayandBPAxes); %clicky points
    TotPlayandBPAxes.Toolbar.Visible = 'off';
%     app.TotPlayandBPAxes.Interactions = dataTipInteraction; \
        %no need for data cursor, have it on field displays
    %maximize size?
    outerpos = TotPlayandBPAxes.OuterPosition;
    ti = TotPlayandBPAxes.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    TotPlayandBPAxes.Position = [left bottom ax_width ax_height];
    
    
    
    %Alive Players over Time
    AliveOverTimeAxes = subplot( 4, 2, 3);
    yyaxis(AliveOverTimeAxes, 'left'); %all players
    hold(AliveOverTimeAxes, 'off');
    plot(AliveOverTimeAxes, [0 roundi], ...
        [100 app.bigData.alivePlayers], '-'); %currently alive players
    hold(AliveOverTimeAxes, 'on');
    ylabel(AliveOverTimeAxes, 'Players Alive');
    yyaxis(AliveOverTimeAxes, 'right'); %origniators
    plot(AliveOverTimeAxes, [0 roundi], ...
        [100 app.bigData.liveOrig], '-');
    ylabel(AliveOverTimeAxes, 'Originators Alive');
    title(AliveOverTimeAxes, 'Alive Players over Time');
    xlabel(AliveOverTimeAxes, 'Rounds');
%     text(app.AliveOverTimeAxes, roundi(end),app.bigData(end).liveOrig,...%how 
%         sprintf('%d Still Alive ', app.bigData(end).liveOrig), ...   %many
%         'HorizontalAlignment','right','VerticalAlignment','bottom'); %alive
    AliveOverTimeAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(AliveOverTimeAxes); %fixing
    AliveOverTimeAxes.Toolbar.Visible = 'off';
    %positioning
    outerpos = AliveOverTimeAxes.OuterPosition;
    ti = AliveOverTimeAxes.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    AliveOverTimeAxes.Position = [left bottom ax_width ax_height];
    

    %Average Experience
    BPExpAxes = subplot( 4, 2, [5 7]);
    yyaxis(BPExpAxes, 'right'); %Num Players
    hold(BPExpAxes, 'off');
    plot(BPExpAxes, [0 roundi], [100 app.bigData.alivePlayers],'r-');
    hold(BPExpAxes, 'on');
    plot(BPExpAxes, [0 roundi], [0 app.bigData.livings],'-','Color',...
        [1 .5 0]); %num of survivors
    ylabel(BPExpAxes, 'Num Players');
    yyaxis(BPExpAxes, 'left'); %AVG EXP
    hold(BPExpAxes, 'off');
    plot(BPExpAxes, roundi, [app.bigData.avgExp],'b-'); %average exp
    hold(BPExpAxes, 'on');
    plot(BPExpAxes, roundi, [app.bigData.livingExp],'Color',[0 .5 1]); 
        %avg exp of survivors
    ylabel(BPExpAxes, 'Average Experience');
    title(BPExpAxes, 'Average Experience');
    xlabel(BPExpAxes, 'Rounds');
    legend(BPExpAxes, {'Total Average Exp','Survivor Average Exp',...
        'Total Players','Survivors'},'Location','best');
    BPExpAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(BPExpAxes); %fix
    BPExpAxes.Toolbar.Visible = 'off';
    %positioning
    outerpos = BPExpAxes.OuterPosition;
    ti = BPExpAxes.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    BPExpAxes.Position = [left bottom ax_width ax_height];
    
   
 	%Level Composition
    LevelAreaAxes = subplot( 4, 2, 2);
    hold(LevelAreaAxes, 'off');
    dat =[1 0 0 0 0 0 0 0 0 0; reshape([app.bigData.perLevel],10,[])'];
        %so we can also do round 0
    area(LevelAreaAxes, [0 roundi], dat);
    title(LevelAreaAxes, 'Level Composition');
    xlabel(LevelAreaAxes, 'Rounds');
    ylabel(LevelAreaAxes, 'Percent at each Level');
    LevelAreaAxes.XLim = [0 app.currRound];
    hold(LevelAreaAxes, 'on'); %for indicator line
    disableDefaultInteractivity(LevelAreaAxes); %fix
    LevelAreaAxes.Toolbar.Visible = 'off'; 
    %positioning
    outerpos = LevelAreaAxes.OuterPosition;
    ti = LevelAreaAxes.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    LevelAreaAxes.Position = [left bottom ax_width ax_height];
    

    %Each originator over time
    OrigsBPAxes = subplot(4, 2, 4);
    hold(OrigsBPAxes, 'off');
    cRGB = BBcolors2RGB(app.players(1:100), 0); %get colors
    arrayData = [app.bigData.Origis]; %into an array
    for indP = 1:100
        plot(OrigsBPAxes, [0 roundi], [100 arrayData(indP:100:end)],...
            'Color', cRGB(indP,:)); %avg exp of survivors
        if(indP == 1)
            hold(OrigsBPAxes, 'on');
        end %one hold on
    end
    title(OrigsBPAxes, 'BP of Originators');
    xlabel(OrigsBPAxes, 'Rounds');
    ylabel(OrigsBPAxes, 'BP');
    OrigsBPAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(OrigsBPAxes); %fix
    OrigsBPAxes.Toolbar.Visible = 'off';
    %positioning
    outerpos = OrigsBPAxes.OuterPosition;
    ti = OrigsBPAxes.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    OrigsBPAxes.Position = [left bottom ax_width ax_height];
    
    %BP of Pure Colors
    PureColorsAxes = subplot(4, 2, [6,8]);
    hold(PureColorsAxes, 'off');
    legendo = cell(6,1); %initalize
    King = {'Red','Yellow', 'Green','Blue','Purple','White'}; %names
    cRGBO = BBcolors2RGB(app.players(1:6), 0); %get origi colors
    cRGBO(6,:) = [.7 .7 .7]; %so white isn't pure white
    arrayData1 = [app.bigData.pureBP]; %arrayify
    for indPure = 1:6
        plot(PureColorsAxes, [0 roundi], [100 arrayData1(...
            indPure:6:end)], 'Color', cRGBO(indPure,:), ...
            'LineWidth', 1); %just pure colors
        legendo{indPure} = sprintf('%d: %s', indPure, King{indPure}); 
            %label who is who
        if(indPure == 1)
            hold(PureColorsAxes, 'on');
        end %only 1 hold on

    end
    legend(PureColorsAxes, legendo,'Location','best'); %whomstve
    title(PureColorsAxes, 'BP of Pure Colors');
    xlabel(PureColorsAxes, 'Rounds');
    ylabel(PureColorsAxes, 'BP');
    PureColorsAxes.XLim = [0 app.currRound];
    disableDefaultInteractivity(PureColorsAxes); %fix
    PureColorsAxes.Toolbar.Visible = 'off';
    %positioning
    outerpos = PureColorsAxes.OuterPosition;
    ti = PureColorsAxes.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    PureColorsAxes.Position = [left bottom ax_width ax_height];


%all repositioning later? - not helping
%     outerpos = TotPlayandBPAxes.OuterPosition;
%     ti = TotPlayandBPAxes.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     TotPlayandBPAxes.Position = [left bottom ax_width ax_height];
%     
%     outerpos = AliveOverTimeAxes.OuterPosition;
%     ti = AliveOverTimeAxes.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     AliveOverTimeAxes.Position = [left bottom ax_width ax_height];
%     
%     outerpos = BPExpAxes.OuterPosition;
%     ti = BPExpAxes.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     BPExpAxes.Position = [left bottom ax_width ax_height];
%     
%     outerpos = LevelAreaAxes.OuterPosition;
%     ti = LevelAreaAxes.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     LevelAreaAxes.Position = [left bottom ax_width ax_height];
%     
%     outerpos = OrigsBPAxes.OuterPosition;
%     ti = OrigsBPAxes.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     OrigsBPAxes.Position = [left bottom ax_width ax_height];
%     
%     outerpos = PureColorsAxes.OuterPosition;
%     ti = PureColorsAxes.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     PureColorsAxes.Position = [left bottom ax_width ax_height];
    
    %Save the figure
    direc = [app.genPara.savePath,'/',app.genPara.simTitle '/']; 
    print(fig, [direc, app.PicName.Value, '.png'], '-dpng'); 
    
    %Disable button when we're done
    app.TrendyPicButton.Enable = 'off'; %can't save after we just did
    close(fig); %close it when finished
end

function TrendPicClose(src, ~, app)
    if(strcmp(app.TrendyPicButton.Enable,'on')) %can still save
        sel = uiconfirm(app.AWSim, ['The Trends Picture is not done'...
            ' saving.  Closing now will cancel its creation.'],...
            'Confirm Premature close?', 'Icon','warning');
        if(strcmp(sel, 'OK')) %terminate
            delete(src);
        end %close
    else
        delete(src); %so we can actually close it still
    end %if still working
end



