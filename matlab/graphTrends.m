function [fig] = graphTrends(bigData)
%graphTrends Visualize general trends in the simulation
    %plot total players, alive players, and total BP
    
    %bigData is indexed to round, fields:
    %totalBP - total amount of BP per round
    %totalPlayers - how many players were there
    %alivePlayers - how many players are alive?
    %avgExp - average experience of alive players
    
    totPlots = 4;
    
    fig = figure; %assignment
    subplot(totPlots,1,1); %create 3 graphs
    roundi = 1:size(bigData,2); %x points
    plot(roundi, [bigData.totalPlayers]);
    title("Total Players over Time");
    xlabel("Rounds");
    ylabel("Total Players");
    subplot(totPlots,1,2); %graph 2
    plot(roundi, [bigData.alivePlayers]); %currently alive players
    title("Alive Players over Time");
    xlabel("Rounds");
    ylabel("Players Alive");
    subplot(totPlots,1,3); %graph 3
    plot(roundi, [bigData.totalBP]); %total burst points
    title("Total Burst Points over Time");
    xlabel("Rounds");
    ylabel("Total Burst Points");
    subplot(totPlots,1,4); %graph 4
    plot(roundi, [bigData.avgExp]); %average exp
    title("Average Experience of all Alive Players over Time");
    xlabel("Rounds");
    ylabel("Average Experience");
end


