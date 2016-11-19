% Starter code prepared by James Hays for CS 4476, Georgia Tech
% This function returns detections on all of the images in a given path.
% You will want to use non-maximum suppression on your detections or your
% performance will be poor (the evaluation counts a duplicate detection as
% wrong). The non-maximum suppression is done on a per-image basis. The
% starter code includes a call to a provided non-max suppression function.
function [bboxes, confidences, image_ids] = .... 
    run_detector(test_scn_path, w, b, feature_params)
% 'test_scn_path' is a string. This directory contains images which may or
%    may not have faces in them. This function should work for the MIT+CMU
%    test set but also for any other images (e.g. class photos)
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.

% 'bboxes' is Nx4. N is the number of detections. bboxes(i,:) is
%   [x_min, y_min, x_max, y_max] for detection i. 
%   Remember 'y' is dimension 1 in Matlab!
% 'confidences' is Nx1. confidences(i) is the real valued confidence of
%   detection i.
% 'image_ids' is an Nx1 cell array. image_ids{i} is the image file name
%   for detection i. (not the full path, just 'albert.jpg')

% The placeholder version of this code will return random bounding boxes in
% each test image. It will even do non-maximum suppression on the random
% bounding boxes to give you an example of how to call the function.

% Your actual code should convert each test image to HoG feature space with
% a _single_ call to vl_hog for each scale. Then step over the HoG cells,
% taking groups of cells that are the same size as your learned template,
% and classifying them. If the classification is above some confidence,
% keep the detection and then pass all the detections for an image to
% non-maximum suppression. For your initial debugging, you can operate only
% at a single scale and you can skip calling non-maximum suppression. Err
% on the side of having a low confidence threshold (even less than zero) to
% achieve high enough recall.

test_scenes = dir( fullfile( test_scn_path, '*.jpg' ));

%initialize these as empty and incrementally expand them.
bboxes = zeros(0,4);
confidences = zeros(0,1);
image_ids = cell(0,1);
%constants
D = (feature_params.template_size / feature_params.hog_cell_size)^2 * 31;
cell_size = feature_params.hog_cell_size;
cell_ratio = feature_params.template_size / feature_params.hog_cell_size;
thres = -0.8;
scaling_factor = 0.75;

for i = 1:length(test_scenes)
    bboxes_new = zeros(0,4);
    confidences_new = zeros(0,1);
    image_ids_new = cell(0,1);
    fprintf('Detecting faces in %s\n', test_scenes(i).name)
    img = imread( fullfile( test_scn_path, test_scenes(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end

   % scale image and find hog features
    for s = 1:10
        img_t = imresize(img, scaling_factor^(s-1));
        hog = vl_hog(img_t, feature_params.hog_cell_size);
        [r, c, ~] = size(hog);
        r = floor(r/cell_ratio)*cell_ratio;
        c = floor(c/cell_ratio)*cell_ratio;
        
       % check all boxes
        for j = 1:r-(cell_ratio-1)
            for k = 1:c-(cell_ratio-1)
                box = hog(j:j+(cell_ratio-1),k:k+(cell_ratio-1),:);
                box = reshape(box,1,D);
                score = box * w + b;
                bbox = zeros(0,4);
                confidence = zeros(0,1);
                image_id = cell(0,1);
                if ( score > thres )
                    cur_x_min = (k*cell_size)-(cell_size-1);
                    cur_y_min = (j*cell_size)-(cell_size-1);
                    bbox = [cur_x_min, cur_y_min, (cur_x_min + feature_params.template_size), (cur_y_min + feature_params.template_size)];
                    bbox = bbox./(scaling_factor^(s-1));
                    confidence = score;
                    image_id =  {test_scenes(i).name};
                    bboxes_new = [bboxes_new ; bbox];
                    confidences_new = [confidences_new ; confidence];
                    image_ids_new = [image_ids_new ; image_id];
                end
            end
        end
    end
    

    %non_max_supr_bbox can actually get somewhat slow with thousands of
    %initial detections. You could pre-filter the detections by confidence,
    %e.g. a detection with confidence -1.1 will probably never be
    %meaningful. You probably don't want to threshold at 0.0, though. You
    %can get higher recall with a lower threshold. You don't need to modify
    %anything in non_max_supr_bbox, but you can.
    
    [is_maximum] = non_max_supr_bbox(bboxes_new, confidences_new, size(img));
    
    confidences_new = confidences_new(is_maximum,:);
    bboxes_new      = bboxes_new(     is_maximum,:);
    image_ids_new   = image_ids_new(  is_maximum,:);
    
    bboxes      = [bboxes;      bboxes_new];
    confidences = [confidences; confidences_new];
    image_ids   = [image_ids;   image_ids_new];
end


