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

maxcount=0;
thres = 0.08;
iter = 2000;

for j=1:iter
    
    random_indices=randsample(size(matches_a,1),8);
    Points_a=matches_a(random_indices,:);
    Points_b=matches_b(random_indices,:);
    
    F_matrix=estimate_fundamental_matrix(Points_a,Points_b);
    
    inliercount=0;
    for i=1:size(matches_a,1)
        if ~any(i==random_indices)
            residue=abs([matches_b(i,:) 1]*F_matrix*[matches_a(i,:) 1]');
            if residue<thres
                inliercount=inliercount+1;
            end
        end
    end
    
    if(inliercount>maxcount)
        maxcount=inliercount;
        Best_Fmatrix=F_matrix;
    end
end

val=zeros(size(matches_a,1),1);
for i=1:size(matches_a,1)
    val(i)=abs([matches_b(i,:) 1] * Best_Fmatrix * [matches_a(i,:) 1]');
end

[B I]=sort(val,'ascend');

inliers_a=matches_a(I(1:30),:);
inliers_b=matches_b(I(1:30),:);

end

