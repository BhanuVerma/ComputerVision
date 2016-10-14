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
[row_size , ~]=size(Points_a);

% Normalization, calculate mean
a_mu_1 = mean(Points_a(:,1));
a_mu_2 = mean(Points_a(:,2));
b_mu_1 = mean(Points_b(:,1));
b_mu_2 = mean(Points_b(:,2));

% calculate offsets 
offset_a = [[1; 0; 0],[0; 1; 0],[-a_mu_1 ; -a_mu_2 ; 1]];
offset_b = [[1; 0; 0],[0; 1; 0],[-b_mu_1 ; -b_mu_2 ; 1]];

% remove means 
s_a = zeros(row_size,2);
s_a(:,1) = Points_a(:,1) - a_mu_1;
s_a(:,2) = Points_a(:,2) - a_mu_2;

s_b = zeros(row_size,2);
s_b(:,1) = Points_b(:,1) - b_mu_1;
s_b(:,2) = Points_b(:,2) - b_mu_2;

% getting scalars for each image
norm_u_a = 1/std(s_a(:,1));
norm_v_a = 1/std(s_a(:,2));
norm_u_b = 1/std(s_b(:,1));
norm_v_b = 1/std(s_b(:,2));

% assemble scalar matrices
s_mat_a = [norm_u_a , 0 , 0 ; 0 , norm_v_a , 0 ; 0 ,0 , 1];
s_mat_b = [norm_u_b , 0 , 0 ; 0 , norm_v_b , 0 ; 0 ,0 , 1];

% generating transform matrix
trans_a = s_mat_a * offset_a;
trans_b = s_mat_b * offset_b;
out_mat_a = (trans_a * [ Points_a ones(row_size,1) ]')';
out_mat_b = (trans_b * [ Points_b ones(row_size,1) ]')';

% setting up the equation for svd
mat = zeros(row_size,9);
mat = [out_mat_a(:,1).*out_mat_b(:,1) out_mat_a(:,2).*out_mat_b(:,1) out_mat_b(:,1) out_mat_a(:,1).*out_mat_b(:,2) out_mat_a(:,2).*out_mat_b(:,2) out_mat_b(:,2) out_mat_a(:,1) out_mat_a(:,2) ones(row_size,1)];
[~, ~, v] = svd(mat);   % getting svd, magic happens here
pruned_mat = v(:,end);
reshaped_mat = reshape(pruned_mat,3,3)';
[u, s, v] = svd(reshaped_mat);

% normalizing fundamental matrix
s(3,3) = 0;
normed_F_matrix = u*s*v';
F_matrix = trans_b' * normed_F_matrix * trans_a
        
end

