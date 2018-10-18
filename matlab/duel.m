function newPlayers = duel(players, p1,p2, round)
%DUEL simulate a battle between two players
    %p1/2 are indices, players is the input struct
    % percentage of winning chance defined by exp, color matchup
    
    players(p1).BP = players(p1).BP -1; %use pt to accelerate
    newPlayers = players; %set it to convert
    
    angleRaw = abs(players(p1).color - players(p2).color); %difference color
    if(angleRaw > 180) % get shortest angle
        angle = 360-angleRaw;
    else
        angle = angleRaw;
    end
    sweep = abs((pi*angle/180)*((players(p1).sat)^2 -(players(p2).sat)^2));
                    % swept area of difference, use for exp gain
    totalSweep = 2*pi*(100^2); %total area of color wheel
    expDiff = sweep/totalSweep; %make it easier
    lvlDiff = abs(players(p1).lvl - players(p2).lvl); %what's the diff?
    chance1 = players(p1).exp*rand(1); %chances of winning, factoring in
    chance2 = players(p2).exp*rand(1); %exp and chance
    if(chance1 > chance2) % p1 wins
        if(players(p1).lvl > players(p2).lvl) %p1 was expected to
            newPlayers(p1).BP = players(p1).BP +(10/lvlDiff);
            newPlayers(p2).BP = players(p2).BP -(10/lvlDiff); 
        elseif(players(p1).lvl < players(p2).lvl) %p1 was not expected to
            newPlayers(p1).BP = players(p1).BP +(10*lvlDiff); 
            newPlayers(p2).BP = players(p2).BP -(10*lvlDiff); 
        else %same level
            newPlayers(p1).BP = players(p1).BP +10;
            newPlayers(p2).BP = players(p2).BP -10;
        end %if level
        p1text = sprintf('Won against lvl%d %d, challenger (lvl%d)', ...
            players(p2).lvl, p2, players(p1).lvl);
        p2text = sprintf('Lost against lvl%d %d (lvl%d)', ...
            players(p1).lvl, p1, players(p2).lvl);
        newPlayers(p1).record{1,end+1} = round;
        newPlayers(p1).record{2,end} = p1text;
        newPlayers(p2).record{1,end+1} = round;
        newPlayers(p2).record{2,end} = p2text;
    elseif(chance1 < chance2) % p2 wins
        if(players(p1).lvl > players(p2).lvl) %p2 was not expected to
            newPlayers(p1).BP = players(p1).BP -(10*lvlDiff);
            newPlayers(p2).BP = players(p2).BP +(10*lvlDiff); 
        elseif(players(p1).lvl < players(p2).lvl) %p2 was expected to
            newPlayers(p1).BP = players(p1).BP -(10/lvlDiff); 
            newPlayers(p2).BP = players(p2).BP +(10*lvlDiff); 
        else %same level
            newPlayers(p1).BP = players(p1).BP -10;
            newPlayers(p2).BP = players(p2).BP +10;
        end %if level
        p1text = sprintf('Lost against lvl%d %d, challenger (lvl%d)', ...
            players(p2).lvl, p2, players(p1).lvl);
        p2text = sprintf('Won against lvl%d %d (lvl%d)', ...
            players(p1).lvl, p1, players(p2).lvl);
        newPlayers(p1).record{1,end+1} = round;
        newPlayers(p1).record{2,end} = p1text;
        newPlayers(p2).record{1,end+1} = round;
        newPlayers(p2).record{2,end} = p2text;
    else %tie, equal opp, no points lost
        newPlayers(p1).BP = players(p1).BP +0; %draw
        newPlayers(p2).BP = players(p2).BP +0; %draw
        p1text = sprintf('Draw against lvl%d %d, challenger (lvl%d)', ...
            players(p2).lvl, p2, players(p1).lvl);
        p2text = sprintf('Draw against lvl%d %d (lvl%d)', ...
            players(p1).lvl, p1, players(p2).lvl);
        newPlayers(p1).record{1,end+1} = round;
        newPlayers(p1).record{2,end} = p1text;
        newPlayers(p2).record{1,end+1} = round;
        newPlayers(p2).record{2,end} = p2text;
    end %if winning
        
    newPlayers(p1).exp = players(p1).exp +players(p2).exp*expDiff*1;
    newPlayers(p2).exp = players(p2).exp +players(p1).exp*expDiff*1; 
                %exp gain prop to color diff, other player's diff
        
end