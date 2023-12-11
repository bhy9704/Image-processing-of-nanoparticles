%% read image
% Load your TEM image (replace 'your_image.png' with your image filename)
myDir = 'D:\공기원 data\2023.10.18 QD UV air 72h\2023.10.18 QD UV air 72h';
fileName = '200kV8MXImage10012.jpg';
fullFileName = fullfile(myDir,fileName); %gets all png files in struct
img = imread(fullFileName);

% Define the size of the segments (e.g., width and height)
segment_width =128; % Adjust this value based on your desired segment size
segment_height =128;

%pixel resolution of original image
pix_per_nm = 0.048;
pixel_per_frequency = (1/ (pix_per_nm * segment_height));

%adjust radius value
radius1 = (1/(0.2400*pixel_per_frequency)); 
radius2 = (1/(0.2800*pixel_per_frequency)); 
radius3 = (1/(0.2800*pixel_per_frequency)); 
radius4 = (1/(0.2900*pixel_per_frequency));    
        
        
% Get the dimensions of the image
[img_height, img_width, ~] = size(img);

% Initialize a counter for the segment index
segment_index = 0;

% phase map for detection of ZnO phase
phase_map= zeros(img_width, img_height);

%% Create a loop to sweep through the image in segments
for y = 1:1:(img_height - segment_height + 1)
    for x = 1:1:(img_width - segment_width + 1)
        % Define the position and size of the current segment
        segment_position = [x, y, segment_width - 1, segment_height - 1];

        % Extract the selected area (segment) from the image
        selected_area = imcrop(img, segment_position);

        % will use this
        fft_img = abs(fftshift(fft2(double(selected_area))));

        
        %gaussian blur
        fft_img = imgaussfilt(fft_img,0.6);
        


        %% center masking        
        % center of the FFT pattern
        [peak_row, peak_col] = find(fft_img == max(fft_img(:)));
        
        %masking the center area
        r_mask = 5;
        [center_x, center_y] = meshgrid(1:segment_width, 1:segment_height); 
        % Calculate the distance from each pixel to the center
        distanceMap = sqrt((center_x - peak_row).^2 + (center_y - peak_col).^2);
        % Create a binary radial mask based on the distance and radius
        radialMask = distanceMap >= r_mask;
        fft_img =fft_img .* radialMask;
        
        %line mask
        center = segment_height / 2;
        fft_img(center,:) = 0;
        fft_img(:,center) = 0;
        fft_img(center-1, :) = 0;
        fft_img(:, center-1)=0;
        fft_img(center+1, :) = 0;
        fft_img(:, center+1)=0;
        
        
        %figure;
        %imshow(mat2gray(log(fft_img+1)));
   
        
        %% phase analysis
        % indentification of the FFT peak
        % Set a threshold to identify peaks in the FFT magnitude
        peak_threshold1 = 0.5 * max(fft_img(:)); % Adjust the threshold as needed
        peak_threshold2 = max(fft_img(:));
        [px,py]=find(fft_img > peak_threshold1 & fft_img <= peak_threshold2);
        num_peaks = size(px);
        n = num_peaks(1,1);
        distance_map=zeros(n,1);
     
        
        for i=1:n
            distance_map(i,1) = sqrt((px(i,1) - peak_col).^2 + (py(i,1) - peak_row).^2);
            if (distance_map(i,1) >= radius2) && (distance_map(i,1) <= radius1)
            for j=x:(x+segment_height-1)
                for k=y:(y+segment_width-1)
                    phase_map(k,j) = phase_map(k,j) + 1;
                end
            end
            end
            
            if(distance_map(i,1) > radius4) && (distance_map(i,1) < radius3)
                for j=x:(x+segment_height-1)
                for k=y:(y+segment_width-1)
                    phase_map(k,j) = phase_map(k,j) + 1;
                end
                end
            end
            
        end
      
        % Increment the segment index
        segment_index = segment_index + 1;
    end
end
%% Plotting
figure;
imshow(phase_map,[]);

title('map')
colormap(winter)
c = colorbar;
ylabel(c, 'Intensity (a.u.)');

hold off;


