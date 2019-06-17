function [bigData] = recordTrends(players, rounds, livelist, oldData)
%recordTrends Follow general trends of the simulation
    %Report total BP over time, total players over time
    
    %bigData is indexed to round, fields:
    %totalBP - total amount of BP per round
    %totalPlayers - how many players were there
    %alivePlayers - how many players are alive?
    %avgExp - average experience of alive players
    
    bigData = oldData; %transfer the stuff over
    bigData(rounds).totalBP = sum([players.BP]); %total burst points
    bigData(rounds).totalPlayers = size(players, 2); %how many ever alive
    bigData(rounds).alivePlayers = size(livelist,2); % alive now
    bigData(rounds).avgExp = mean([players(livelist).exp]); %average exp of
        %all alive players
        
    %assuming if a player survives around 20ish rounds, they aren't just
    %immediately dying, so let's follow that average experience
    alives = players(livelist); %whose alive
    longLives = [alives.rounds];
    roundCheck = 30; %how long do they need to survive?
    bigData(rounds).livingExp = mean([alives(longLives(1:2:end) ...
        +roundCheck -rounds < 0).exp]); %players who've stayed alive
    bigData(rounds).livings = size([alives(longLives(1:2:end) ...
        +roundCheck -rounds < 0).exp],2); %how many are there
    
    bigData(rounds).Origis = [players(1:100).BP]; %follow just Gen1
    bigData(rounds).liveOrig = sum(livelist <= 100); %how many originators?
    
    bigData(rounds).pureBP = [players(1:6).BP]; %BP for pure colors
    
    for indLvls = 1:10 %through each level
        numLvl = sum([players(livelist).lvl] == indLvls); %how many total
        bigData(rounds).perLevel(indLvls) = numLvl/size(livelist,2);
        
    end
    
    %player data for each round to graph
    for indP = 1:size(players,2) %iterate through each player
        bigData(rounds).play(indP).BP = players(indP).BP;
        bigData(rounds).play(indP).exp = players(indP).exp;
        bigData(rounds).play(indP).wins = players(indP).wins;
        bigData(rounds).play(indP).lvl = players(indP).lvl; 
    end %for
    
    

end