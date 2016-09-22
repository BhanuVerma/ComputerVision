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

bins=8;
H1=[];
for z=1:length(x)
    r=y(z);
    c=x(z);
    har=image(r-8:r+7,c-8:c+7);
    bsize=4;
    x1=size(har,1)/bsize; y1=size(har,2)/bsize; %f is the original image
    q=bsize*ones(1,x1); n=bsize*ones(1,y1);
    har=mat2cell(har,q,n);
    H=[];
    for i=1:4
        for j=1:4
            har1=cell2mat(har(i,j));
            [mag,ang]=imgradient(har1);
            mag1=zeros(1,8);
            for k=1:4
                for l=1:4
                    if (ang(k,l)>0 && ang(k,l)<45)
                        mag1(1)=mag1(1)+mag(k,l);
                    elseif (ang(k,l)>45 && ang(k,l)<90)
                        mag1(2)=mag1(2)+mag(k,l);
                    elseif (ang(k,l)>90 && ang(k,l)<135)
                        mag1(3)=mag1(3)+mag(k,l);
                    elseif (ang(k,l)>135 && ang(k,l)<180)
                        mag1(4)=mag1(4)+mag(k,l);
                    elseif (ang(k,l)>-45 && ang(k,l)<0)
                        mag1(5)=mag1(5)+mag(k,l);
                    elseif (ang(k,l)>-90 && ang(k,l)<-45)
                        mag1(6)=mag1(6)+mag(k,l);
                    elseif (ang(k,l)>-135 && ang(k,l)<-90)
                        mag1(7)=mag1(7)+mag(k,l);
                    elseif (ang(k,l)>-180 && ang(k,l)<-135)
                        mag1(8)=mag1(8)+mag(k,l);
                    end
                 end
            end
            H=[H mag1];                       
        end
    end
    d=norm(H);
    H=H./d;
    for w=1:128
        if(H(w)>0.2)
            H(w)=0.2;
        end
    end
    d=norm(H);
    H=H./d;
    H1=[H1;H];   
end
features=H1;

end








