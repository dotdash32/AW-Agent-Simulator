function [newPlayers] = lvlUp(players, round, para)
%lvlUp allow players to level up, maybe create kids too
    %players and round in again, no lists out
    %we only point levels for lvl2, we'll guess some exponnential curve
    %saftey margin will about 1.25x before they level up
    %index of points is to reach next lvl, points(1) is to get to lvl2
    
    %parameters
    %para.points - points required to level up
    
    newPlayers = players; %refill
    
    for ind = 1:size(players,2) %go through everyone
        if(players(ind).BP > (para.margin()*para.points(players(ind).lvl)))
                %they are over saftey margin
            newPlayers(ind).BP = players(ind).BP-para.points(players(ind).lvl);
            newPlayers(ind).lvl = players(ind).lvl +1; %level them up
            text = sprintf('Leveled up to Lvl%d', newPlayers(ind).lvl);
            newPlayers(ind).record{1,end+1} = round;
            newPlayers(ind).record{2,end} = text; %record it
        end %if
    end
end