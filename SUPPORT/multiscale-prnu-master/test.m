img = 'dev_0018.tif';
map = 'dev_0018.bmp';
addpath('../dev-dataset-forged/')
addpath('../dev-dataset-maps/')
pixmap = imread(img);
gt = imread(map);

cam = load('data/camera_models/flat-camera-4.mat');

response_ss = detectForgeryPRNUCentral(pixmap, cam.camera_model, 129, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));

response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
    8, true, false);

% response_sg = detectForgeryPRNUCentral(pixmap, cam.camera_model, 129, ...
%     struct('verbose', true, 'stride', 8, 'segmentwise_correlation', true, ...
%     'image_padding', true));

response_aw = detectForgeryPRNUAdaptiveWnd(pixmap, cam.camera_model, ...
    struct('verbose', true, 'stride', 8, 'image_padding', true));

decision_ss = response_ss.map_prp > 0.5;
decision_ss = mapCleanup(decision_ss, 64);
decision_ss = imdilate(decision_ss, strel('disk', 2));
decision_ss2 = response_ss2.map_prp > 0.5;
decision_ss2 = mapCleanup(decision_ss2, 64);
decision_ss2 = imdilate(decision_ss2, strel('disk', 2));

% decision_aw = fuseCRF(response_aw.map_prp, pixmap, 0.5, [-1 1 4 25 0]);


clf;
subplot(2,4,1);
imsc(pixmap, 'tampered image');

subplot(2,4,5);
imsc(gt, 'ground truth');

subplot(2,4,2);
imsc(response_ss.map_prp, 'tamp. prob. (single-scale)');

subplot(2,4,6);
imsc(colorCodeMap(decision_ss, gt), 'decision (single-scale)');

subplot(2,4,3);
imsc(response_ss2.map_prp, 'tamp. prob. (segmentation-guided)');

subplot(2,4,7);
imsc(colorCodeMap(decision_ss2, gt), 'decision (segmentation-guided)');

subplot(2,4,4);
imsc(response_aw.map_prp, 'tamp. prob. (adaptive-window)');

% subplot(2,4,8);
% imsc(colorCodeMap(decision_aw, gt), 'decision (adaptive-window)');

