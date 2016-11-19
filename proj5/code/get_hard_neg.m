function [features_hard_neg]=get_hard_neg(non_face_scn_path,w,b,features_params)
test_scenes = dir( fullfile( non_face_scn_path, '*.jpg' ));
features_hard_neg=[];
shape_size = (features_params.template_size / features_params.hog_cell_size)^2 * 31;
for i = 1:length(test_scenes)
      
    fprintf('Detecting faces in %s\n', test_scenes(i).name)
    img = imread( fullfile( non_face_scn_path, test_scenes(i).name ));
    img = single(img);
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    rand_vec=randperm(2000);
    for j=1:2:round(length(rand_vec)/18)
    I1=img(round(rand_vec(j)/255)+1:round(rand_vec(j)/255)+36,round(rand_vec(j+1)/255)+1:round(rand_vec(j+1)/255)+36);
    hog=vl_hog(I1,features_params.hog_cell_size);
    hog_final=reshape(hog,1,shape_size);
    confidence=(hog_final*w)+b;
    if (confidence>0)
        features_hard_neg=[features_hard_neg;hog_final];
    end
    end
end