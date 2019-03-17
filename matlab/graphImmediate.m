function [fig, movie] = graphImmediate(players, oldFig, livelist, movie)
%GraphImmediate Graph the intermediate state of the system
    %take in players struct, previous figure to regraph, livelist
    
    if(oldFig == 0) %unitialized
        fig = figure('Position',[10 10 1400 700]); %initalize figure
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
        hold off; %clear it as we re-plot

        playersInt = players(livelist); %only the ones who are alive
        cHSL = [[playersInt.color]' /360 ...
                [playersInt.sat]' /100 ...
                [playersInt.val]' /100]; %create hsv colors
        cRGB = hsl2rgb(cHSL); %convert to rgb for plotting
        wins = [playersInt.wins]'; %convert to vector
        winRate = wins(:,1)./wins(:,2); %calculate win rate
        scatter([playersInt.exp], winRate, [playersInt.BP], cRGB, 'filled'); %plot
        hold on;
        scatter([playersInt.exp], winRate, [playersInt.BP]+1, 'k'); %plot borders
        hold off;
        xlabel('Player Experience');
        ylabel('Player Win Rate');
        title(['Evolution of Brain Burst Following every player inside '...
            'the simulation']);
        legend('Dot size corresponds to number of BP');
        xlim([0 15]); %approximating
        ylim([0 1]); %keeping it consistent
        
        frame = getframe(fig); %capture frame
        writeVideo(movie, frame); %record it
    end
end



function rgb=hsl2rgb(hsl_in)
%Converts Hue-Saturation-Luminance Color value to Red-Green-Blue Color value
%
%Usage
%       RGB = hsl2rgb(HSL)
%
%   converts HSL, a M [x N] x 3 color matrix with values between 0 and 1
%   into RGB, a M [x N] X 3 color matrix with values between 0 and 1
%
%See also rgb2hsl, rgb2hsv, hsv2rgb
% (C) Vladimir Bychkovsky, June 2008
% written using: 
% - an implementation by Suresh E Joel, April 26,2003
% - Wikipedia: http://en.wikipedia.org/wiki/HSL_and_HSV
% - Copy pasted from mathworks 3/16/19
hsl=reshape(hsl_in, [], 3);
H=hsl(:,1);
S=hsl(:,2);
L=hsl(:,3);
lowLidx=L < (1/2);
q=(L .* (1+S) ).*lowLidx + (L+S-(L.*S)).*(~lowLidx);
p=2*L - q;
hk=H; % this is already divided by 360
t=zeros([length(H), 3]); % 1=R, 2=B, 3=G
t(:,1)=hk+1/3;
t(:,2)=hk;
t(:,3)=hk-1/3;
underidx=t < 0;
overidx=t > 1;
t=t+underidx - overidx;
    
range1=t < (1/6);
range2=(t >= (1/6) & t < (1/2));
range3=(t >= (1/2) & t < (2/3));
range4= t >= (2/3);
% replicate matricies (one per color) to make the final expression simpler
P=repmat(p, [1,3]);
Q=repmat(q, [1,3]);
rgb_c= (P + ((Q-P).*6.*t)).*range1 + ...
        Q.*range2 + ...
        (P + ((Q-P).*6.*(2/3 - t))).*range3 + ...
        P.*range4;
       
rgb_c=round(rgb_c.*10000)./10000; 
rgb=reshape(rgb_c, size(hsl_in));
end