% Projection Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu, Grady Williams, James Hays

% Returns the projection matrix for a given set of corresponding 2D and
% 3D points. 

% 'Points_2D' is nx2 matrix of 2D coordinate of points on the image
% 'Points_3D' is nx3 matrix of 3D coordinate of points in the world

% 'M' is the 3x4 projection matrix


function M = calculate_projection_matrix( Points_2D, Points_3D )

% To solve for the projection matrix. You need to setup a homogenous
% set of equations using the corresponding 2D and 3D points:

%                                                     [M11       [ u1
%                                                      M12         v1
%                                                      M13         .
%                                                      M14         .
%[ X1 Y1 Z1 1 0  0  0  0 -u1*X1 -u1*Y1 -u1*Z1          M21         .
%  0  0  0  0 X1 Y1 Z1 1 -v1*Z1 -v1*Y1 -v1*Z1          M22         .
%  .  .  .  . .  .  .  .    .     .      .          *  M23   =     .
%  Xn Yn Zn 1 0  0  0  0 -un*Xn -un*Yn -un*Zn          M24         .
%  0  0  0  0 Xn Yn Zn 1 -vn*Zn -vn*Yn -vn*Zn ]        M31         .
%                                                      M32         un
%                                                      M33         vn ]

% Then you can solve this using least squares with the '\' operator or SVD.
% Notice you obtain 2 equations for each corresponding 2D and 3D point
% pair. To solve this, you need at least 6 point pairs.

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% To compute A\b
%% Form A
M=zeros(3,4); %Initialize M 
[n m]=size(Points_2D); 
A=zeros(n*2,11); %Initialize A
A(1:2:end)=[Points_3D ones(n,1) zeros(n,4) -Points_2D(:,1).*Points_3D(:,1) -Points_2D(:,1).*Points_3D(:,2) -Points_2D(:,1).*Points_3D(:,3)];
A(2:2:end)=[zeros(n,4) Points_3D ones(n,1) -Points_2D(:,2).*Points_3D(:,1) -Points_2D(:,2).*Points_3D(:,2) -Points_2D(:,2).*Points_3D(:,3)];

%% Form b
b = reshape(Points_2D',[],1);

%% Calculate M
M = A\b;
M = [M;1];
M = reshape(M,[],3)';
% M=M.*-0.5968;

%This M matrix came from a call to rand(3,4). It leads to a high residual.
%Your total residual should be less than 1.

end

