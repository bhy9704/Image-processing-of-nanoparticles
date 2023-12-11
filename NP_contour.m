%% read image
clear all
im = imread('uv in air-200kV3MXImage10051.jpg');

%% binarize image
% Convert the image to grayscale
grayImage = rgb2gray(im);
%img_contrast = imadjust(grayImage,[0.2,0.8],[]);
K = wiener2(grayImage,[5 5]);

% Define a structuring element for erosion (a disk-shaped structuring element)
se = strel("disk",2,0); % 'radius' is the size of the structuring element

% Perform erosion on the binary image
erodedImage = imerode(K, se);

% Define a structuring element for dilation (same size as used for erosion)
se = strel("disk",1,0); 
dilatedImage = imdilate(erodedImage, se);
bw = imbinarize(dilatedImage,0.2);


% Perform dilation on the eroded image

BWdfill = imfill(bw,'holes');

%% Calculate lengths of each boundary contour
boundaries = bwboundaries(BWdfill,4);
contourLengths = zeros(1, numel(boundaries));
circularity = zeros(1,numel(boundaries));
mat_log = zeros(1,1);

for k = 1:numel(boundaries)
    contour = boundaries{k};
    contourLengths(k) = length(contour);
    area = polyarea(contour(:, 2), contour(:, 1));
    circularity(k) = 12.57 * (area / ((contourLengths(k))^2));
    mat_log(k,1) = area;
    mat_log(k,2) = circularity(k);
end


%% plot contour and image together
imshow(im);
hold on;

% Plot boundary contours & numbering each contours
for k = 1:numel(boundaries)
    contour = boundaries{k};
    plot(contour(:, 2), contour(:, 1), 'r', 'LineWidth', 2);
    centroid = mean(contour);
    text(contour(1, 2), contour(1, 1), num2str(circularity(k)), 'Color', 'g', 'FontSize', 12);
end


hold off;
