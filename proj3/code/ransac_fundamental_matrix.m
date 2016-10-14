% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

iter_size = 2000;
threshold = 0.08;
max_val = 0;

% Calculating best f_matrix
for ind=1:iter_size
    rand_i = randsample(size(matches_a,1),8);
    
    a_points = matches_a(rand_i,:);
    b_points = matches_b(rand_i,:);
    
    % calling estimate_fundamental_matrix
    f_mat = estimate_fundamental_matrix(a_points,b_points);
    
    in_count=0;
    
    for i=1:size(matches_a,1)
        if ~any(i == rand_i)
            residue = abs([matches_b(i,:) 1]*f_mat*[matches_a(i,:) 1]');
            if residue < threshold
                in_count = in_count+1;
            end
        end
    end
    
    % updating max value and best f_matrix
    if in_count > max_val
        max_val = in_count;
        Best_Fmatrix = f_mat;
    end
end

% Calculating inliers
val = zeros(size(matches_a,1),1);

for i = 1:size(matches_a,1)
    val(i) = abs([matches_b(i,:) 1] * Best_Fmatrix * [matches_a(i,:) 1]');
end

[~, indices] = sort(val,'ascend');      % helps in getting top matches

inliers_a = matches_a(indices(1:30),:);
inliers_b = matches_b(indices(1:30),:);

end

