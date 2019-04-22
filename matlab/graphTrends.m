function [fig] = graphTrends(bigData, players)
%graphTrends Visualize general trends in the simulation
    %plot total players, alive players, and total BP
    
    %bigData is indexed to round, fields:
    %totalBP - total amount of BP per round
    %totalPlayers - how many players were there
    %alivePlayers - how many players are alive?
    %avgExp - average experience of alive players
    
    totPlots = [4,2];
    
    fig = figure('Position',[10 10 1400 700]); %assignment
    roundi = 1:size(bigData,2); %x points
    sgtitle(sprintf('Trends for %s', bigData(1).simmy)); %subplot title
    
    subplot(totPlots(1),totPlots(2),1); %create some graphs
    yyaxis right; %total players
    plot(roundi, [bigData.totalPlayers]);
    ylabel("Total Players");
    yyaxis left; %Burst Points
    plot(roundi, [bigData.totalBP]); %total burst points
    ylabel('BP at each Round');
    title('Total Players and BP per round');
    xlabel("Rounds");

    
    
    subplot(totPlots(1),totPlots(2),3); %graph 1,2
    yyaxis left; %all players
    plot(roundi, [bigData.alivePlayers]); %currently alive players
    ylabel("Players Alive");
    yyaxis right; %origniators
    plot(roundi, [bigData.liveOrig]);
    ylabel('Originators Alive');
    title('Alive Players over Time');
    xlabel("Rounds");
    text(roundi(end),bigData(end).liveOrig, sprintf('%d Still Alive ',...
        bigData(end).liveOrig), 'HorizontalAlignment','right',...
        'VerticalAlignment','bottom'); %how many alive
    
    subplot(totPlots(1),totPlots(2),[5,7]); %graph 1, (3&4)
    yyaxis right; %Num Players
    hold on
    plot(roundi, [bigData.alivePlayers],'r-');
    plot(roundi, [bigData.livings],'-','Color',[1 .5 0]); %num of survivors
    ylabel("Num Players");
    yyaxis left; %AVG EXP
    hold on
    plot(roundi, [bigData.avgExp],'b-'); %average exp
    plot(roundi, [bigData.livingExp],'Color',[0 .5 1]); %avg exp of survivors
    ylabel("Average Experience");
    title("Average Experience");
    xlabel("Rounds");
    legend({'Total Average Exp','Survivor Avergae Exp',...
        'Total Players','Survivors'},'Location','best');
    
   
    subplot(totPlots(1),totPlots(2), 2) %graph 2, (1)
    hold on
    bords = {'k','b','g','r','c','m','y',[1 .4 .6] [1 .5 .5] [1 .5 0]}; 
        %colors for levels
    h = area(reshape([bigData.perLevel],10,[])');
    h.FaceColor
    title('Level Composition');
    xlabel('Rounds');
    ylabel('Percent at each Level');
    
    subplot(totPlots(1),totPlots(2), 4) %graph 2, (2)
    %Each originator over time
    hold on
    cRGB = BBcolors2RGB(players(1:100)); %get colors
    cellData = [bigData.Origis]; %get it in a cell
    arrayData = [cellData{:}]; %into an array
    for indP = 1:100
        plot([0 roundi], [100 arrayData(indP:100:end)], ...
            'Color', cRGB(indP,:)); %avg exp of survivors
    end
    title("BP of Originators");
    xlabel("Rounds");
    ylabel("BP");
    
    subplot(totPlots(1),totPlots(2), [6,8]) %graph 2, (34)
    hold on
    legendo = cell(0); %initalize
    King = {'Red','Yellow', 'Green','Blue','Purple','White'}; %names
    cRGBO = BBcolors2RGB(players(1:6)); %get origi colors
    cRGBO(6,:) = [.7 .7 .7]; %so white isn't pure white
    arrayData1 = [bigData.pureBP]; %arrayify
    for indPure = 1:6
        plot([0 roundi], [100 arrayData1(indPure:6:end)],...
            'Color', cRGBO(indPure,:), 'LineWidth', 1); %just pure colors
        legendo{end+1} = sprintf('%d: %s', indPure, King{indPure}); 
            %label who is who
    end
    legend(legendo,'Location','best'); %whomstve
    title("BP of Pure Colors");
    xlabel("Rounds");
    ylabel("BP");
end


