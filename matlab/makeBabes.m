function newPlayers = makeBabes(players, rounds)
%makeBabes Make some babies to keep the pool alive
    %create new players each with 100 BP 
    
    newPlayers = players; %fill
    if(any([players.lvl] >1)) %can we even have kids? save func time
        potential = find([players.lvl] > 1); %who can have kids
        for ind = potential %loop through all the potentials
            if(players(ind).gen == 1 || players(ind).kid == 0)
                    %can they have another kid
                if(randi(floor(rounds/30)+1, 1) == randi(floor(rounds/30)+1,1)) 
                %if(1) %try max reproduction
                                %chance decreasing
                    newb = makePlayer(ind,players(ind).gen, rounds); %baby
                    newPlayers = [newPlayers newb]; %concat
                    newPlayers(ind).kid = players(ind).kid + 1; %number them
                end %if baby
            end %if can kid
        end %for 
    end %if over lvl1
end