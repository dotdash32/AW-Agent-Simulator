function [] = saveBBScatter(app)
%saveBBScatter Save the scatterplot of BP over time

%% Setup

dlg = uiprogressdlg(app.AWSim, 'Title', 'Saving BB Scatter plot',...
    'Cancelable', 'on', 'Message', 'Initializing movie and gif');

%movie/gif setup
direc = [app.genPara.savePath,'/',app.genPara.simTitle '/']; 
fileMP4 = [direc app.VidName.Value,'.mp4'];
fileGIF = [direc app.VidName.Value, '.gif'];
movie = VideoWriter(fileMP4,'MPEG-4'); %initalize
movie.FrameRate = app.VidFrameRate.Value; %adjustable
open(movie); %starto

%figure display setup
fig = figure('CloseRequestFcn',{@BBPicClose, app, movie, dlg},...
                 'WindowState','maximized');
pause(1); %stability
fig.Visible = 'off'; %wooosh away
xlabel('Player Experience');
ylabel('Player Win Rate');
title('Evolution of Brain Burst');

%resize to maximize
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

xlim([0 max([app.players.exp])*1.1]); %approximating
ylim([0 1]); %keeping it consistent
text(mean(xlim),.9, 'Accel World Agent Simulator','FontSize',36,...
    'HorizontalAlignment','center');
text(mean(xlim),.8, 'Start!','FontSize',48,...
    'HorizontalAlignment','center');


frame = getframe(fig); %capture frame
frameCount = round(app.VidIntroLength.Value*movie.FrameRate); %intro length
delaytime = 1/movie.FrameRate; %how long should gif frames be
for inF = 1:frameCount %match GIF length
    writeVideo(movie, frame); %record it
end
[A,map] = rgb2ind(frame2im(frame),256); %for gif
imwrite(A,map,fileGIF,'gif','LoopCount',Inf,'DelayTime',...
    app.VidIntroLength.Value);

%% Run Rounds and record TODO

for indRound = 1:app.currRound
    %progressbar
    dlg.Message = sprintf('Saving Round %d of %d', indRound, app.currRound);
    dlg.Value = indRound/(app.currRound+1); %update bar distance
    
    if(dlg.CancelRequested) %want to break
        canc = close(fig); %kill con fuego
        if(canc == 1) %cancel confirmed
            return
        end
    end %cancels
    
    livelist = find([app.bigData(indRound).play.BP] > 0);
    playersInt = app.bigData(indRound).play(livelist);

    cRGB = BBcolors2RGB(app.players(livelist),0); %convert colors
    wins = [playersInt.wins]'; %convert to vector
    winRate = wins(:,1)./wins(:,2); %calculate win rate
    scatter([playersInt.exp], winRate, [playersInt.BP],...
        cRGB, 'filled'); %plot
    hold('on')
    legendo = {'Dot Color is player color'}; %initailize

    playersO = playersInt(livelist <= 100); %originators
    if(~isempty(playersO)) %none left
        winsO = [playersO.wins]'; %convert to vector
        winRateO = winsO(:,1)./winsO(:,2); %calculate win rate
        OrigsRGB = BBcolors2RGB(app.players(livelist <= 100),1); %get colors
        scatter([playersO.exp], winRateO, ...
            [playersO.BP]/5, OrigsRGB, 'x') %mark whose orignating
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
        scatter([playersS.exp], winRate1, [playersS.BP]+1,...
            bords2(indLvl,:), 'LineWidth', 1); %plot by level
        legendo{end+1} = sprintf('Level %d (%d Players)',...
            indLvl, size(playersS,2)); %legend
    end
    hold('off')
    xlabel('Player Experience');
    ylabel('Player Win Rate');
    title(['Evolution of Brain Burst Following every '...
        'player inside the simulation']);
    legend(legendo,'Location','southeast'); %with each color
    text(0, .9, sprintf(['   Dot Size corresponds to number of BP '...
        '\n   Round: ' num2str(indRound)]));
    xlim([0 max([app.players.exp])*1.1]); %approximating
    ylim([0 1]); %keeping it consistent

    frame = getframe(fig); %capture frame
    writeVideo(movie, frame); %record it
    [A,map] = rgb2ind(frame2im(frame),256); %for gif

    imwrite(A,map,fileGIF,'gif','WriteMode','append','DelayTime',delaytime);
end %for rounds

%% Closing up
dlg.Message = 'Finalizing';
dlg.Value = app.currRound/(app.currRound+1); %almost there
close(movie); % close it up at end
app.BBVidButton.Enable = 'off'; %can't regraph yet
close(dlg); 
close(fig); %automatically close it

end

function [canc] = BBPicClose(src, ~, app, movie, dlg)
%close request, will stop it
if(strcmp(app.BBVidButton.Enable, 'on')) %still working
    sel = uiconfirm(app.AWSim, ['Are you sure you want to abort video'...
        ' creation?  Doing so will stop the video at the '...
        'current round.'], 'Confirm close?');
    if(strcmp(sel, 'OK'))
        close(movie); %terminate it
        close(dlg); %close dialog box
        delete(src); %kill the thing with so much fire
        canc = 1; %cancelling, quit func
    else
        canc = 0; %not cancelling
        dlg.CancelRequested = 0; %uncancel
    end %ok to cancel
else %all done
    delete(src); %kill it with fire
end %if still working


end