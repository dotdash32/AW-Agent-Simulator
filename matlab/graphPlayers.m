%% Plot Some players created

%% Define parameters
% (Pulled from Main Sim)
% makePlayer
makePlayerPara.expVer = 'cont'; %or discr
makePlayerPara.expRange = [1 10]; %range of experience values ('disc')
makePlayerPara.expMax = 10; %max of continuous exp vals ('cont')
    %adding options for continuous or discrete starting exps
makePlayerPara.valDistro = [7 6]; %A, B for beta distrobution
makePlayerPara.satDistro = [1.75 1.5]; %A, B for satruation (radius) distro
makePlayerPara.MoralBooster = 10; %multiplier for morality

%Pure Colors
PureColors = struct('color', {0 60 120 240 300 180}, 'sat',...
    {100 100 100 100 100 0}, 'light', {50 50 50 50 50 100});
    %What colors will they be?  White Cosmos is "infinite" theta...
PureColorPara.exp = makePlayerPara.expMax; %super high
    %set it so they are always more powerful

%% Create a bunch

totalP = 1000; %how many to make?

players = struct([]); %intiliaze

for numPures = 1:6
    newPlayer = makePureColor(PureColors(numPures),PureColorPara);
        %create pure colors, only varying color, keeping Exp, etc const
    players = [players newPlayer];
end

for numOrig = 1:totalP
    newPlayer = makePlayer(0,0,1, makePlayerPara);
    players = [players newPlayer];
end

%% Graph some stuff
close all
figure('Position',[10 10 1200 8000]); %make it big

dimmies = [4 4];
tot = dimmies(1)*dimmies(2);
subplot(dimmies(1),dimmies(2), [1:tot-4])
hold on
cRGB = BBcolors2RGB(players); %convert colors
scatter([players.exp], [players.val], [players.BP]+1,...
    cRGB, 'filled'); %plot
lightP = players([players.val] > 80); %need borders
scatter([lightP.exp], [lightP.val], [lightP.BP]+1,...
    'c'); %plot borders
plot([0 10], [max([players(7:end).val]) max([players(7:end).val])],'r');
text(0, 100 ,sprintf('Max = %d', max([players(7:end).val])),...
    'VerticalAlignment','top');
plot([0 10], [min([players.val]) min([players.val])],'r');
text(0, 0,sprintf('Min = %d', min([players.val])),...
    'VerticalAlignment','bottom');
ylim([0 100]);
title('Players by Color')
xlabel('Experience')
ylabel('Luminance (50 is "Pure")')


subplot(dimmies(1),dimmies(2),tot-3)
histogram([players.sat]);
title('Distrobution of Saturation');
xlabel(sprintf('Avg = %2.0f', mean([players.sat])))

subplot(dimmies(1),dimmies(2),tot-2)
As = makePlayerPara.satDistro(1); Bs = makePlayerPara.satDistro(2); %for simplicity
x = 0:.01:1;
y = betapdf(x,As,Bs);
plot(x,y)
title('Beta Distrobution for Saturation');
xlabel(sprintf('Avg = %2.0f', 100*x(y == max(y))))

subplot(dimmies(1),dimmies(2),tot-1)
histogram([players.val]);
title('Distrobution of Luminance');
xlabel(sprintf('Avg = %2.0f', mean([players.val])))

subplot(dimmies(1),dimmies(2),tot)
Ac = makePlayerPara.valDistro(1); Bc = makePlayerPara.valDistro(2); %for simplicity
x = 0:.01:1;
y = betapdf(x,Ac,Bc);
plot(x,y)
title('Beta Distrobution for Luminance');
xlabel(sprintf('Avg = %2.0f', 100*x(y == max(y))))
print('ColoringNotes/Distrobutions.png','-dpng')

%% 3D scatter
% close all;
figure('Position',[200 10 1200 800]);
subplot(3,4,[1 2 3 5 6 7 9 10 11])
r = [players.sat];%.*(betapdf([players.val]/100,A,B)./max(y));
xs = r.*cosd([players.color]);
ys = r.*sind([players.color]);
scatter3(xs,ys, [players.val],100, cRGB,'filled')
hold on
lightP = players([players.val] > 80); %need borders
xsL = [lightP.sat].*cosd([lightP.color]);
ysL = [lightP.sat].*sind([lightP.color]);
scatter3(xsL,ysL, [lightP.val],100,'c'); %plot borders
plot3(100*cosd(0:360), 100*sind(0:360),50*ones(1,361))
zlim([0 100])

[tt, rr] = meshgrid(0:20:360,0:25:100); %grid to plot on, polar
xx = rr.*cosd(tt);
yy = rr.*sind(tt); %polar coords
zTop = -sqrt((1/4)*xx.^2+(1/4)*yy.^2)+100;
zBot = sqrt((1/4)*xx.^2+(1/4)*yy.^2); %cone parts
mesh(xx,yy,zTop,'edgecolor','k')
mesh(xx,yy,zBot,'edgecolor','k')
hidden off

subplot(3,4,4)
scatter([players.sat],[players.val],10,cRGB,'filled')
hold on
scatter([lightP.sat],[lightP.val],1,'c')
plot([0 100 0], [0 50 100], 'k:')
plot(mean([players.sat])*[1 1],[0 100],'r--')
plot([0 100], mean([players.val])*[1 1], 'r--')
xlabel('Saturation')
ylabel('Luminance')
title('Saturation versus Luminance')

subplot(3,4,8)
polarscatter([players.color]*(pi/180),[players.sat],1, cRGB)
title('Color versus Saturation')
rticks([]) %no ticks

subplot(3,4,12)
polarscatter([players.color]*(pi/180),[players.val],1, cRGB)
title('Color versus Luminance')
rticks([]); %cleaner

print('ColoringNotes/chartByChart.png','-dpng')
