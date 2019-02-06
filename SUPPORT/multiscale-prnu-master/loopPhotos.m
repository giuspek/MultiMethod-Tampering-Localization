d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, 'dev*.tif'));
mkdir('PRNU-maptest');

size(files)
for i = 1:2
    pixmap = imread(files(i).name);
    pixmap = pixmap(:,:,1:3);
    cam = load('data/camera_models/flat-camera-1.mat');
    response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
    8, true, false);
    decision_ss2 = response_ss2.map_prp > 0.5;
    decision_ss2 = mapCleanup(decision_ss2, 64);
    decision_ss2 = imdilate(decision_ss2, strel('disk', 2));
    imwrite(decision_ss2,strcat('PRNU-maptest/map-',files(i).name,'-1.bmp'))
    cam = load('data/camera_models/flat-camera-2.mat');
    response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
    8, true, false);
    decision_ss2 = response_ss2.map_prp > 0.5;
    decision_ss2 = mapCleanup(decision_ss2, 64);
    decision_ss2 = imdilate(decision_ss2, strel('disk', 2));
    imwrite(decision_ss2,strcat('PRNU-maptest/map-',files(i).name,'-2.bmp'))
    cam = load('data/camera_models/flat-camera-3.mat');
    response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
    8, true, false);
    decision_ss2 = response_ss2.map_prp > 0.5;
    decision_ss2 = mapCleanup(decision_ss2, 64);
    decision_ss2 = imdilate(decision_ss2, strel('disk', 2));
    imwrite(decision_ss2,strcat('PRNU-maptest/map-',files(i).name,'-3.bmp'))
    cam = load('data/camera_models/flat-camera-4.mat');
    response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
    8, true, false);
    decision_ss2 = response_ss2.map_prp > 0.5;
    decision_ss2 = mapCleanup(decision_ss2, 64);
    decision_ss2 = imdilate(decision_ss2, strel('disk', 2));
    imwrite(decision_ss2,strcat('PRNU-maptest/map-',files(i).name,'-4.bmp'))
end