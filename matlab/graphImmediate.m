function [fig, movie] = graphImmediate(players, oldFig, livelist, movie)
%GraphImmediate Graph the intermediate state of the system
    %take in players struct, previous figure to regraph, livelist
    
    if(oldFig == 0) %unitialized
        fig = figure('Position',[10 10 800 800]); %initalize figure
        xlabel('Player Experience');
        ylabel('Player Win Rate');
        title('Evolution of Brain Burst');
        movie = VideoWriter('testing.mp4','MPEG-4'); %initalize
        movie.FrameRate = 3;
        open(movie); %starto

    elseif(oldFig == -1) % deiniialize
        fig = oldFig; %keep it the same
        close(movie); % close it up at end
    else
        fig = oldFig; %transfer
        %hold off; %clear it as we re-plot

        playersInt = players(livelist); %only the ones who are alive
        cHSV = [[playersInt.color]' /360 ...
                [playersInt.sat]' /100 ...
                ones(size(playersInt,2),1)]; %create hsv colors
        cRGB = hsv2rgb(cHSV); %convert to rgb for plotting
        wins = [playersInt.wins]'; %convert to vector
        winRate = wins(:,1)./wins(:,2); %calculate win rate
        scatter([playersInt.exp], winRate, [playersInt.BP], cRGB, 'filled'); %plot
        frame = getframe(fig); %capture frame
        writeVideo(movie, frame); %record it
    end
end