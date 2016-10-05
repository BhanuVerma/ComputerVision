% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

[row_size_1,~]=size(features1);
[row_size_2,~]=size(features2);

% Find normalized distances between features

for i=1:row_size_1
    for j=1:row_size_2
        normed(i,j)=norm(features1(i,:)-features2(j,:));
    end
end

 % Calculating Nearest Neigbours
 
matches = [];
confidences = [];

for i=1:row_size_1
    [arr,indices]=sort(normed(i,:));
    if ((arr(1)/arr(2))<0.8)
          matches=[matches;i indices(1)];
          confidences=[confidences 1-(arr(1)/arr(2))];
    end
end

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);
end