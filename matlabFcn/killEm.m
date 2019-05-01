function [newPlayers, deadlist, livelist] = killEm(players, round)
%killEm eliminate players from BB simulation.
    %intake players and round for tracking
    %output new list of players, and list of dead players
    
    newPlayers = players; %set up new struct
    
    bps = [players.BP]; %get points list
    deadlist = find(bps <= 0); %find all those who should be dead
    livelist = find(bps > 0); %find those alive
    for murder = deadlist %for every dead person
        if(players(murder).rounds(1,2) == 0) %weren't already dead
            newPlayers(murder).rounds(1,2) = round; %when did they die?
            newPlayers(murder).BP = 0; %sad bears
            text = sprintf('Uninstalled'); %print it out
            newPlayers(murder).record{1,end+1} = round;
            newPlayers(murder).record{2,end} = text;
        end
    end

end