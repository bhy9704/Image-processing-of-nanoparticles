clear; clc; close;

myDir = 'D:\공기원 data\2023.11.16 QD Ar\EDS\reports\site 6\not filtered_In';
fileName = 'site6_p5_In.tif';

fullFileName = fullfile(myDir,fileName); %gets all png files in struct

[I, Fs] = imread(fullFileName);
I = I(:,:,1);
I = wiener2(I,[30 30]);
I = im2double(I);
I = I - I(1,1);

[a, b] = size(I);
%I(47:108, 119:139) = 0; I(109:134, 22:72) = 0; 


I_ref = ones(a, b) * mean(I(:));

props = regionprops(true(size(I)), I, 'WeightedCentroid');
comX = props.WeightedCentroid(1);
comY = props.WeightedCentroid(2);

[X, Y] = meshgrid(1:a, 1:b);
distMat = ((X - comX).^2 + (Y - comY).^2).^0.5;
scatterness = sum(sum(distMat .* I')) / sum(sum(distMat .* I_ref'));

estimate_noise(I)

%imshow(I, []);

%% Noise level estimation
% https://kr.mathworks.com/matlabcentral/fileexchange/36941-fast-noise-estimation-in-images?s_tid=mwa_osa_a
function Sigma = estimate_noise(I)

[H W]=size(I);
I=double(I);

% compute sum of absolute values of Laplacian
M=[1 -2 1; -2 4 -2; 1 -2 1];
Sigma=sum(sum(abs(conv2(I, M))));

% scale sigma with proposed coefficients
Sigma=Sigma*sqrt(0.5*pi)./(6*(W-2)*(H-2));

end