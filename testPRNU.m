addpath(genpath(pwd))

camera1 = load('flat-camera-1');
camera2 = load('flat-camera-2');
camera3 = load('flat-camera-3');
camera4 = load('flat-camera-4');

im = imread('dev_0004.tif');
im = im(:,:,1:3);
w = [30, 2.5];

th = 0.4;
image = double(rgb2gray(im));
std_image = stdfilt3(image);
hpf_std_image = stdfilt3(highPass(image));
prnu1 = rgb2gray1(camera1.camera_model.prnu);
prnu2 = rgb2gray1(camera2.camera_model.prnu);
prnu3 = rgb2gray1(camera3.camera_model.prnu);
prnu4 = rgb2gray1(camera4.camera_model.prnu);
% prnu1 = WienerInDFT(prnu,std2(prnu));

corrA = corr2( prnu1 .* image, image - hpf_std_image);
corrB = corr2( prnu2 .* image, image - hpf_std_image);
corrC = corr2( prnu3 .* image, image - hpf_std_image);
corrD = corr2( prnu4 .* image, image - hpf_std_image);

if corrA > 0.001
    response = cell(1, 4);
    disp('Camera 1')
    
    response_96 = detectForgeryPRNUCentral(im, camera1.camera_model, 97, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_96 = response_96.map_prp > 0.5;
    decision_96 = mapCleanup(decision_96, 64);
    decision_96 = imdilate(decision_96, strel('disk', 2));
    response{1}.candidate = decision_96;
    response{1}.reliability = 1 - exp(-abs(w(1)*(response{1}.candidate - 0.5).^w(2)));
    
    response_128 = detectForgeryPRNUCentral(im, camera1.camera_model, 129, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_128 = response_128.map_prp > 0.5;
    decision_128 = mapCleanup(decision_128, 64);
    decision_128 = imdilate(decision_128, strel('disk', 2));
    response{2}.candidate = decision_128;
    response{2}.reliability = 1 - exp(-abs(w(1)*(response{2}.candidate - 0.5).^w(2)));
    
    response_192 = detectForgeryPRNUCentral(im, camera1.camera_model, 193, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_192 = response_192.map_prp > 0.5;
    decision_192 = mapCleanup(decision_192, 64);
    decision_192 = imdilate(decision_192, strel('disk', 2));
    response{3}.candidate = decision_192;
    response{3}.reliability = 1 - exp(-abs(w(1)*(response{3}.candidate - 0.5).^w(2)));
    
    response_256 = detectForgeryPRNUCentral(im, camera1.camera_model, 257, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_256 = response_256.map_prp > 0.5;
    decision_256 = mapCleanup(decision_256, 64);
    decision_256 = imdilate(decision_256, strel('disk', 2));
    response{4}.candidate = decision_256;
    response{4}.reliability = 1 - exp(-abs(w(1)*(response{4}.candidate - 0.5).^w(2)));
    
    response_maps = postprocessMaps(response, @(x) imresize(x, 0.5, 'bilinear'));
    fusion_labeling = fuseCRF(response_maps, im, th, [-1 0.5 5.6 25 0.18]);
    imshow(fusion_labeling);
elseif corrD > 0.001
    disp('Camera 4')
    response_96 = detectForgeryPRNUCentral(im, camera4.camera_model, 97, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_96 = response_96.map_prp > 0.5;
    decision_96 = mapCleanup(decision_96, 64);
    decision_96 = imdilate(decision_96, strel('disk', 2));
    response{1}.candidate = decision_96;
    response{1}.reliability = 1 - exp(-abs(w(1)*(response{1}.candidate - 0.5).^w(2)));
    
    response_128 = detectForgeryPRNUCentral(im, camera4.camera_model, 129, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_128 = response_128.map_prp > 0.5;
    decision_128 = mapCleanup(decision_128, 64);
    decision_128 = imdilate(decision_128, strel('disk', 2));
    response{2}.candidate = decision_128;
    response{2}.reliability = 1 - exp(-abs(w(1)*(response{2}.candidate - 0.5).^w(2)));
    
    response_192 = detectForgeryPRNUCentral(im, camera4.camera_model, 193, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_192 = response_192.map_prp > 0.5;
    decision_192 = mapCleanup(decision_192, 64);
    decision_192 = imdilate(decision_192, strel('disk', 2));
    response{3}.candidate = decision_192;
    response{3}.reliability = 1 - exp(-abs(w(1)*(response{3}.candidate - 0.5).^w(2)));
    
    response_256 = detectForgeryPRNUCentral(im, camera4.camera_model, 257, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));
    decision_256 = response_256.map_prp > 0.5;
    decision_256 = mapCleanup(decision_256, 64);
    decision_256 = imdilate(decision_256, strel('disk', 2));
    response{4}.candidate = decision_256;
    response{4}.reliability = 1 - exp(-abs(w(1)*(response{4}.candidate - 0.5).^w(2)));
    
    response_maps = postprocessMaps(response, @(x) imresize(x, 0.5, 'bilinear'));
    fusion_labeling = fuseCRF(response_maps, im, th, [-1 0.5 5.6 25 0.18]);
    imshow(fusion_labeling);
else
    disp('No camera')
end