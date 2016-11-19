% Starter code prepared by James Hays for Computer Vision

%This feature is inspired by the simple tiny images used as features in 
%  80 million tiny images: a large dataset for non-parametric object and
%  scene recognition. A. Torralba, R. Fergus, W. T. Freeman. IEEE
%  Transactions on Pattern Analysis and Machine Intelligence, vol.30(11),

function image_feats = get_tiny_images(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
%  image path on the file system.
% image_feats is an N x d matrix of resized and then vectorized tiny
%  images. E.g. if the images are resized to 16x16, d would equal 256.

% To build a tiny image feature, simply resize the original image to a very
% small square resolution, e.g. 16x16. You can either resize the images to
% square while ignoring their aspect ratio or you can crop the center
% square portion out of each image. Making the tiny images zero mean and
% unit length (normalizing them) will increase performance modestly.

% suggested functions: imread, imresize
image_height = 16;
image_width = 16;
image_size = image_width * image_height;
[N,~] = size(image_paths);
image_feats = zeros(N,image_size);
 
for i = 1:N
    image_read = double(imread(image_paths{i})); % read the image
    image_read = image_read - mean(image_read(:)); % make the image zero mean
    image_read = image_read/std(image_read(:)); % normalize the image 
    image_read = imresize(image_read,[image_width, image_height]); % resize the image
    image_feats(i,:) = imresize(image_read',[1,image_size]); % add it to the image_feats
end




