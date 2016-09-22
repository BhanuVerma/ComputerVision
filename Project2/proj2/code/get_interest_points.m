% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Step 1 - Compute the horizontal and vertical derivatives of the image Ix and Iy by convolving the original image with 
% derivatives of Gaussians

blurring_filter = fspecial('gaussian', 3, 0.5);
image=imfilter(image,blurring_filter,'same');    % blurring with the help of gaussian filter 
[G_x,G_y]=gradient(blurring_filter);
I_x=imfilter(image,G_x);                         % X derivative
I_y=imfilter(image,G_y);                         % Y derivative

% Step 2 - Compute the three images corresponding to the outer products of these gradients i.e Ixx,Iyy and Ixy

Ixx = I_x.*I_x;
Iyy = I_y.*I_y;
Ixy = I_x.*I_y;

% Step 3 - Convolution of each of each image with a larger Gaussian

gaussian_filter = fspecial('gaussian', feature_width, 0.5); %designing a filter
I_xx=imfilter(Ixx, gaussian_filter); 
I_yy=imfilter(Iyy, gaussian_filter);
I_xy=imfilter(Ixy, gaussian_filter);

% Step 4 - Computation of scalar interest measure using det(A) - alpha(trace(A)^2) i.e. 
% lambda0 * lambda1 - alpha(lambda0 + lamda1)^2

alpha = 0.05;       % value proposed by Harris and Stephens (1988)
threshold_val = 0.0005;
harris_detector = (I_xx.*I_yy - I_xy.^2) - alpha*((I_xx+I_yy).^2);
normalized_detector = harris_detector/max(max(harris_detector));
normalized_detector(normalized_detector<threshold_val)=0;

% Step 5 - Detecting only local maximal points as feature point locations

filter_size = 3;
colfiltered = colfilt(normalized_detector,[filter_size filter_size],'sliding',@max);
border_filter = zeros(size(colfiltered));
padding_size = 10;
border_filter(padding_size+1:end-padding_size, padding_size+1:end-padding_size) = 1;
harris_detector = normalized_detector .*(normalized_detector==colfiltered) & border_filter;
harris_detector(harris_detector)=1;

[y,x] = find(harris_detector);
figure();
imshow(image);
hold on
scatter(x,y,'red');
end

