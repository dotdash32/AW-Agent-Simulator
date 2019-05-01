function newPlayers = makeBabes(players, rounds, para, makePlayerPara)
%makeBabes Make some babies to keep the pool alive
    %create new players each with 100 BP 
    
    %parameters
    %para.chanceFcn - function handle to evaulate whether or not the chosen
        %player will have a child this round or no
    
    newPlayers = players; %fill
    if(any([players.lvl] >1)) %can we even have kids? save func time
        potential = find([players.lvl] > 1); %who can have kids
        for ind = potential %loop through all the potentials
            if(players(ind).gen == 1 || players(ind).kid == 0)
                    %can they have another kid
                if(para.chanceFcn(rounds) == para.chanceFcn(rounds)) 
                                %chance decreasing
                    newb = makePlayer(ind,players(ind).gen, rounds, ...
                        makePlayerPara); %baby
                    newPlayers = [newPlayers newb]; %concat
                    newPlayers(ind).kid = players(ind).kid + 1; %number them
                end %if baby
            end %if can kid
        end %for 
    end %if over lvl1
end