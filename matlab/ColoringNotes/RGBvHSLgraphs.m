%% Color Spaces
close all;
nums = 20;
spacer = linspace(0,1,nums); %for linear
spacerL = linspace(0,1,nums/2);
spacerH = linspace(0,1,nums*2);
angles = linspace(0,360,nums); %for angles
[xx, yy, zz] = meshgrid(spacer);
x = reshape(xx,[1 nums^3]);
y = reshape(yy,[1 nums^3]);
z = reshape(zz,[1 nums^3]);
[tt, rr, ll] = meshgrid(angles, spacerL, spacerH);
t = reshape(tt,[1 nums^3]);
rRaw = reshape(rr,[1 nums^3]);
l = reshape(ll,[1 nums^3]);
r = rRaw.*((-abs(l-.5)+.5)/.5);
xs = cosd(t).*r; ys = sind(t).*r;
c = hsl2rgb([t'./360, r', l']);
figure('Position',[10 10 1400 700])
subplot(1,2,1)
scatter3(x,y,z,400,[x' y' z'], 'filled')
subplot(1,2,2)
scatter3(xs,ys,l,300, c, 'filled')
    
%% Funky Functions

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