function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

filter_length = size(filter,1);                         % get number of rows in filter
filter_width = size(filter,2);                          % get number of columns in filter
row_offset = (filter_length-1)/2;                       % get length or row offset
col_offset = (filter_width-1)/2;                        % get width or column offset
output = zeros(size(image));                            % initialize the output image with zeroes
image = im2double(image);                               % increase precision
padsize = [(filter_length-1)/2 (filter_width-1)/2];
padded_image = padarray(image, padsize, 'symmetric');   % 'both' is set by default
image_length = size(padded_image,1);                    % get image length
image_width = size(padded_image,2);                     % get image width

for image_dim=1:size(padded_image,3)
    for row=(filter_length+1)/2:image_length-row_offset
        for col=(filter_width+1)/2:image_width-col_offset
            dot_product = sum(filter.*padded_image(row-row_offset:row+row_offset, col-col_offset:col+col_offset, image_dim));
            output(row-row_offset,col-col_offset,image_dim)=sum(dot_product);
        end
    end
end



