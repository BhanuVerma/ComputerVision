% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Build the matrices
 [n m]=size(Points_a);
% 
% %%  Without Normalization
% A=zeros(n,9);
% A = [ Points_a(:,1).*Points_b(:,1) Points_a(:,2).*Points_b(:,1) Points_b(:,1) Points_a(:,1).*Points_b(:,2)  Points_a(:,2).*Points_b(:,2) Points_b(:,2) Points_a(:,1) Points_a(:,2) ones(n,1)];
% 
% % Find the Fundamental Matrix
% [U, S, V] = svd(A);
% f = V(:, end);
% F=reshape(f,3,3)';
% [U, S, V] = svd(F);
% S(3,3) = 0;
% F_matrix = U*S*V';


 %% With Normalization
%Compute the mean
a_cu = mean(Points_a(:,1));
a_cv = mean(Points_a(:,2));
b_cu = mean(Points_b(:,1));
b_cv = mean(Points_b(:,2));

%Form the offset 
Oa = [[1; 0; 0] [0; 1; 0] [-a_cu ; -a_cv ; 1]]; %offset matrix for a
Ob = [[1; 0; 0] [0; 1; 0] [-b_cu ; -b_cv ; 1]]; %offset matrix for b

% Subtract the means 
% S_Points_a = Points_a;
% S_Points_b = Points_b;
S_Points_a = zeros(n,2);
S_Points_a(:,1) = Points_a(:,1)-a_cu;
S_Points_a(:,2) = Points_a(:,2)-a_cv;

S_Points_b = zeros(n,2);
S_Points_b(:,1) = Points_b(:,1)-b_cu;
S_Points_b(:,2) = Points_b(:,2)-b_cv;

% Compute the scalars for each image
s_u_a = 1/std(S_Points_a(:,1));
s_v_a = 1/std(S_Points_a(:,2));
s_u_b = 1/std(S_Points_b(:,1));
s_v_b = 1/std(S_Points_b(:,2));

% Form the Scalar matrix
Sa = [s_u_a , 0 , 0 ; 0 , s_v_a , 0 ; 0 ,0 , 1];
Sb = [s_u_b , 0 , 0 ; 0 , s_v_b , 0 ; 0 ,0 , 1];

% Form  the transform matrix
Ta = Sa * Oa;
Tb = Sb * Ob;


Out_a = (Ta * [ Points_a ones(n,1) ]')';
Out_b = (Tb * [ Points_b ones(n,1) ]')';

A=zeros(n,9);
A = [Out_a(:,1).*Out_b(:,1) Out_a(:,2).*Out_b(:,1) Out_b(:,1) Out_a(:,1).*Out_b(:,2) Out_a(:,2).*Out_b(:,2) Out_b(:,2) Out_a(:,1) Out_a(:,2) ones(n,1)];
[U, S, V] = svd(A);
f = V(:,end);
F=reshape(f,3,3)';
[U, S, V] = svd(F);
S(3,3) = 0;
F_matrix_norm = U*S*V';
F_matrix = Tb' * F_matrix_norm * Ta;

end

