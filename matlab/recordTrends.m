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
    
    

end