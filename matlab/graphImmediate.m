function [fig, movie] = graphImmediate(players, oldFig, livelist, movie, simRounds)
%GraphImmediate Graph the intermediate state of the system
    %take in players struct, previous figure to regraph, livelist
    
    if(oldFig == 0) %unitialized
        fig = figure('Position',[10 10 1400 700]); %initalize figure
        xlabel('Player Experience');
        ylabel('Player Win Rate');
        title('Evolution of Brain Burst');
        movie = VideoWriter(['savedSims/',simRounds, '/BBoverTime.mp4']...
            ,'MPEG-4'); %initalize
        movie.FrameRate = 3;
        open(movie); %starto

    elseif(oldFig == -1) % deiniialize
        fig = oldFig; %keep it the same
        close(movie); % close it up at end
    else
        fig = oldFig; %transfer
        hold off; %clear it as we re-plot

        playersInt = players(livelist); %only the ones who are alive
        cRGB = BBcolors2RGB(playersInt); %convert colors
        wins = [playersInt.wins]'; %convert to vector
        winRate = wins(:,1)./wins(:,2); %calculate win rate
        scatter([playersInt.exp], winRate, [playersInt.BP], cRGB, 'filled'); %plot
        hold on;
        legendo = {'Dot Color is player color'}; %initailize
        
        playersO = playersInt([playersInt.gen] == 1); %originators
        if(~isempty(playersO)) %none left
            winsO = [playersO.wins]'; %convert to vector
            winRateO = winsO(:,1)./winsO(:,2); %calculate win rate
            scatter([playersO.exp], winRateO, [playersO.BP]/5, [.7 .7 .7]...
                , 'x') %mark whose orignating
            legendo{end+1} = sprintf('Originator (%d Left)',...
                size(playersO,2)); %add counter
        end
        
        %bords ={'k','b','g','r','c','m','y',[1 .4 .6] [1 .5 .5] [1 .5 0]};
        bords2 =   [     0    0.4470    0.7410
                    0.8500    0.3250    0.0980
                    0.9290    0.6940    0.1250
                    0.4940    0.1840    0.5560
                    0.4660    0.6740    0.1880
                    0.3010    0.7450    0.9330
                    0.6350    0.0780    0.1840
                         0    0.4470    0.7410
                    0.8500    0.3250    0.0980
                    0.9290    0.6940    0.1250]; %new colors
        for indLvl = 1:10 %for each level
            playersS = playersInt([playersInt.lvl] == indLvl);
                %only the players of each level
            if(isempty(playersS))
                continue; %don't do empty levels
            end
            wins1 = [playersS.wins]'; %convert to vector
            winRate1 = wins1(:,1)./wins1(:,2); %calculate win rate
            scatter([playersS.exp], winRate1, [playersS.BP]+1, ...
                bords2(indLvl,:), 'LineWidth', 1); %plot by level
            legendo{end+1} = sprintf('Level %d (%d Players)',...
                indLvl, size(playersS,2)); %legend
        end
        hold off;
        xlabel('Player Experience');
        ylabel('Player Win Rate');
        title(['Evolution of Brain Burst Following every player inside '...
            'the simulation']);
        legend(legendo,'Location','southeast'); %with each color
        text(0, .9, sprintf(['   Dot Size corresponds to number of BP '...
            '\n   Round: ' num2str(simRounds)]));
        xlim([0 max([players.exp])*1.1]); %approximating
        ylim([0 1]); %keeping it consistent
        
        frame = getframe(fig); %capture frame
        writeVideo(movie, frame); %record it
    end
end



