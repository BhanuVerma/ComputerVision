% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

final_hist=[];
for ind=1:length(x)
    % slice image 16x16
    row=y(ind);
    col=x(ind);
    sliced_image=image(row-8:row+7,col-8:col+7);
    
    % slice by bin size
    bin_size=4;
    x_dash=size(sliced_image,1)/bin_size; 
    y_dash=size(sliced_image,2)/bin_size;
    dim_x=bin_size*ones(1,x_dash); 
    dim_y=bin_size*ones(1,y_dash);
    
    % Array to Cell Array conversion
    sliced_image=mat2cell(sliced_image,dim_x,dim_y);        
    temp_hist=[];
    
    for i=1:4
        for j=1:4
            arr=cell2mat(sliced_image(i,j));    % Cell Array to Array conversion
            [magnitude,theta]=imgradient(arr);
            mag_final=zeros(1,8);
            for k=1:4                           % 4x4 grid celss
                for l=1:4
                    if (theta(k,l)>=0 && theta(k,l)<45)
                        mag_final(1)=mag_final(1)+magnitude(k,l);
                    elseif (theta(k,l)>=45 && theta(k,l)<90)
                        mag_final(2)=mag_final(2)+magnitude(k,l);
                    elseif (theta(k,l)>=90 && theta(k,l)<135)
                        mag_final(3)=mag_final(3)+magnitude(k,l);
                    elseif (theta(k,l)>=135 && theta(k,l)<180)
                        mag_final(4)=mag_final(4)+magnitude(k,l);
                    elseif (theta(k,l)>=-45 && theta(k,l)<0)
                        mag_final(5)=mag_final(5)+magnitude(k,l);
                    elseif (theta(k,l)>=-90 && theta(k,l)<-45)
                        mag_final(6)=mag_final(6)+magnitude(k,l);
                    elseif (theta(k,l)>=-135 && theta(k,l)<-90)
                        mag_final(7)=mag_final(7)+magnitude(k,l);
                    elseif (theta(k,l)>=-180 && theta(k,l)<-135)
                        mag_final(8)=mag_final(8)+magnitude(k,l);
                    end
                 end
            end
            temp_hist=[temp_hist mag_final];                       
        end
    end
    
    % normalized to unit length
    normalized=norm(temp_hist);
    temp_hist=temp_hist./normalized;
    
    for dim=1:128                              % 4*4*8
        if(temp_hist(dim)>0.2)
            temp_hist(dim)=0.2;
        end
    end
    
    % normalized again
    normalized=norm(temp_hist);
    temp_hist=temp_hist./normalized;
    
    final_hist=[final_hist;temp_hist];   
end

features=final_hist;

end








