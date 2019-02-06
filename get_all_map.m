% The demo image is taken from the dataset used in:
% Fontani, Marco, Tiziano Bianchi, Alessia De Rosa, Alessandro Piva, and
% Mauro Barni. "A framework for decision fusion in image forensics based on
% Dempster–Shafer theory of evidence." Information Forensics and Security,
% IEEE Transactions on 8, no. 4 (2013): 593-607.
% Original image name: Forgery_final 15.jpg
% Dataset available at: http://clem.dii.unisi.it/~vipp/index.php/imagerepos
% itory/129-a-framework-for-decision-fusion-in-image-forensics-based-on-dem
% pster-shafer-theory-of-evidence

% Copyright (C) 2016 Markos Zampoglou
% Information Technologies Institute, Centre for Research and Technology Hellas
% 6th Km Harilaou-Thermis, Thessaloniki 57001, Greece

close all; clear all


addpath(genpath(pwd))
camera1 = load('flat-camera-1.mat');
camera2 = load('flat-camera-2.mat');
camera3 = load('flat-camera-3.mat');
camera4 = load('flat-camera-4.mat');

camera1 = camera1.camera_model;
camera2 = camera2.camera_model;
camera3 = camera3.camera_model;
camera4 = camera4.camera_model;

w = [30,2.5];
th = 0.4;

% dirInfo         = dir(['dev*.jpg']);
% [no, noOfImages] = size(dirInfo);
% size(dirInfo)
% for i = 7:no
%     % ADQ2
%     im = dirInfo(i).name;
%     disp(im);
%     OutputMap = analyze(im);
%     OutputMap = OutputMap > 0.75;
%     decision_ss2 = mapCleanup(OutputMap, 64);
%     if sum(sum(decision_ss2)) < 2350 || sum(sum(decision_ss2)) > 44650
%         % CAGI
%         [ cagi, cagi_inv ] = CAGI(dirInfo(i).name);
%         maxi = max(max(cagi));
%         mini = min(min(cagi));
%         inter = maxi - mini;
%         cagi_dd = cagi > (maxi - (inter *0.5));
%         if inter < 0.5 || (sum(sum(cagi_dd)) < 36000 || sum(sum(cagi_dd)) > 1764000)
%             % CAGI INV
%             maxi_i = max(max(cagi_inv));
%             mini_i = min(min(cagi_inv));
%             inter_i = maxi_i - mini_i;
%             cagi_inv_dd = cagi_inv < (mini_i + (inter_i * 0.5));
%             if inter_i < 0.48 || (sum(sum(cagi_inv_dd)) < 36000 || sum(sum(cagi_inv_dd)) > 1764000)
%                 %PRNU
%                 pixmap2 = imread(dirInfo(i).name);
%                 image = double(rgb2gray(pixmap2));
%                 std_image = stdfilt3(image);
%                 hpf_std_image = stdfilt3(highPass(image));
%                 prnu1 = rgb2gray1(camera1.prnu);
%                 prnu2 = rgb2gray1(camera2.prnu);
%                 prnu3 = rgb2gray1(camera3.prnu);
%                 prnu4 = rgb2gray1(camera4.prnu);
%                 try
%                     corrA = corr2( prnu1 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 1');
%                     corrA = 0;
%                 end
%                 try
%                     corrB = corr2( prnu2 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 2');
%                     corrB = 0;
%                 end
%                 try
%                     corrC = corr2( prnu3 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 3');
%                     corrC = 0;
%                 end
%                 try
%                     corrD = corr2( prnu4 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 4');
%                     corrD = 0;
%                 end
%                 max_corr = max([corrA corrB corrC corrD]);
%                 true_camera = []
%                 switch max_corr
%                     case corrA
%                         true_camera = camera1;
%                     case corrB
%                         true_camera = camera2;
%                     case corrC
%                         true_camera = camera3;
%                     case corrD
%                         true_camera = camera4;
%                 end
%                 % CORRELAZIONE NON VALIDA, FUORI CICLO
%                 if max_corr < 0.001
%                    disp('NO PRNU')
%                    disp(max_corr)
%                    continue
%                 end
%                 im = imread(dirInfo(i).name);
%                 response_96 = detectForgeryPRNUCentral(im, true_camera, 97, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_96 = response_96.map_prp > 0.5;
%                 decision_96 = mapCleanup(decision_96, 64);
%                 decision_96 = imdilate(decision_96, strel('disk', 2));
%                 response{1}.candidate = decision_96;
%                 response{1}.reliability = 1 - exp(-abs(w(1)*(response{1}.candidate - 0.5).^w(2)));
%     
%                 response_128 = detectForgeryPRNUCentral(im, true_camera, 129, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_128 = response_128.map_prp > 0.5;
%                 decision_128 = mapCleanup(decision_128, 64);
%                 decision_128 = imdilate(decision_128, strel('disk', 2));
%                 response{2}.candidate = decision_128;
%                 response{2}.reliability = 1 - exp(-abs(w(1)*(response{2}.candidate - 0.5).^w(2)));
%     
%                 response_192 = detectForgeryPRNUCentral(im, true_camera, 193, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_192 = response_192.map_prp > 0.5;
%                 decision_192 = mapCleanup(decision_192, 64);
%                 decision_192 = imdilate(decision_192, strel('disk', 2));
%                 response{3}.candidate = decision_192;
%                 response{3}.reliability = 1 - exp(-abs(w(1)*(response{3}.candidate - 0.5).^w(2)));
%     
%                 response_256 = detectForgeryPRNUCentral(im, true_camera, 257, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_256 = response_256.map_prp > 0.5;
%                 decision_256 = mapCleanup(decision_256, 64);
%                 decision_256 = imdilate(decision_256, strel('disk', 2));
%                 response{4}.candidate = decision_256;
%                 response{4}.reliability = 1 - exp(-abs(w(1)*(response{4}.candidate - 0.5).^w(2)));
%     
%                 response_maps = postprocessMaps(response, @(x) imresize(x, 0.5, 'bilinear'));
%                 fusion_labeling = fuseCRF(response_maps, im, th, [-1 0.5 5.6 25 0.18]);
%                 fusion_labeling = imresize(fusion_labeling, [1500 2000]);
%                 if sum(sum(fusion_labeling)) < 36000 || sum(sum(fusion_labeling)) > 1764000
%                     disp(['No map for ' dirInfo(i).name inter_i]);
%                     bozza = [1,1,1,1;1,0,0,1;1,0,0,1;1,1,1,1];
%                     bozza = imresize(bozza, [1500,2000]);
%                     imwrite(bozza, strcat('ADQ2/map-',dirInfo(i).name))
%                     disp(inter_i);
%                 else
%                     disp(['PRNU' dirInfo(i).name]);
%                     disp(true_camera.name);
%                     imwrite(fusion_labeling, strcat('ADQ2/map-',dirInfo(i).name))
%                 end
%             else
%                 disp(['CAGI INV' dirInfo(i).name]);
%                 disp(inter_i);
%                 imwrite(cagi_inv_dd, strcat('ADQ2/map-',dirInfo(i).name))
%             end
%         else
%             disp(['CAGI' dirInfo(i).name]);
%             imwrite(cagi_dd, strcat('ADQ2/map-',dirInfo(i).name))
%         end
%     else
%         disp('ADQ2')
%         imwrite(decision_ss2, strcat('ADQ2/map-',dirInfo(i).name));
%     end
% end

% dirInfo         = dir(['dev*.tif']);
% [no, noOfImages] = size(dirInfo);
% size(dirInfo)
% for i = 523:size(dirInfo)
%     disp(dirInfo(i).name)
%     pixmap = imread(dirInfo(i).name);
%     pixmap2 = (pixmap(:,:,1:3));
%     prova = strcat('prova-',num2str(i),'.jpg');
%     imwrite(pixmap2,prova, 'Quality', 100); %metti 80/70
%     im = prova;
%     OutputMap = analyze(im);
%     OutputMap = OutputMap > 0.75;
%     decision_ss2 = mapCleanup(OutputMap, 64);
%     % SE NULLA E' STATO TROVATO CON IL METODO ADQ2...
%     if sum(sum(decision_ss2)) < 2350 || sum(sum(decision_ss2)) > 44650
%         [a,b,c] = size(pixmap);
%         % TOGLI LA TRASPARENZA
%         if c ~= 3
%            notrasp_name = strcat('no-trasp-',num2str(i),'.tif');
%            imwrite(pixmap2,notrasp_name);
%            dirInfo(i).name = notrasp_name;
%         end
%         % CAGI
%         [ cagi, cagi_inv ] = CAGI(dirInfo(i).name);
%         maxi = max(max(cagi));
%         mini = min(min(cagi));
%         inter = maxi - mini;
%         cagi_dd = cagi > (maxi - (inter *0.5));
%         if inter < 0.5 || (sum(sum(cagi_dd)) < 36000 || sum(sum(cagi_dd)) > 1764000)
%             % CAGI INVERSA
%             maxi_i = max(max(cagi_inv));
%             mini_i = min(min(cagi_inv));
%             inter_i = maxi_i - mini_i;
%             cagi_inv_dd = cagi_inv < (mini_i + (inter_i * 0.5));
%             if inter_i < 0.48 || (sum(sum(cagi_inv_dd)) < 36000 || sum(sum(cagi_inv_dd)) > 1764000)
%                 % PRNU
%                 image = double(rgb2gray(pixmap2));
%                 std_image = stdfilt3(image);
%                 hpf_std_image = stdfilt3(highPass(image));
%                 prnu1 = rgb2gray1(camera1.prnu);
%                 prnu2 = rgb2gray1(camera2.prnu);
%                 prnu3 = rgb2gray1(camera3.prnu);
%                 prnu4 = rgb2gray1(camera4.prnu);
%                 try
%                     corrA = corr2( prnu1 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 1');
%                     corrA = 0;
%                 end
%                 try
%                     corrB = corr2( prnu2 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 2');
%                     corrB = 0;
%                 end
%                 try
%                     corrC = corr2( prnu3 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 3');
%                     corrC = 0;
%                 end
%                 try
%                     corrD = corr2( prnu4 .* image, image - hpf_std_image);
%                 catch
%                     disp('Error in camera 4');
%                     corrD = 0;
%                 end
%                 max_corr = max([corrA corrB corrC corrD]);
%                 true_camera = [];
%                 switch max_corr
%                     case corrA
%                         true_camera = camera1;
%                     case corrB
%                         true_camera = camera2;
%                     case corrC
%                         true_camera = camera3;
%                     case corrD
%                         true_camera = camera4;
%                 end
%                 % CORRELAZIONE NON VALIDA, FUORI CICLO
%                 if max_corr < 0.001
%                    disp('NO PRNU')
%                    disp(max_corr)
%                    continue
%                 end
%                 
%                 im = imread(dirInfo(i).name);
%                 response_96 = detectForgeryPRNUCentral(im, true_camera, 97, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_96 = response_96.map_prp > 0.5;
%                 decision_96 = mapCleanup(decision_96, 64);
%                 decision_96 = imdilate(decision_96, strel('disk', 2));
%                 response{1}.candidate = decision_96;
%                 response{1}.reliability = 1 - exp(-abs(w(1)*(response{1}.candidate - 0.5).^w(2)));
%     
%                 response_128 = detectForgeryPRNUCentral(im, true_camera, 129, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_128 = response_128.map_prp > 0.5;
%                 decision_128 = mapCleanup(decision_128, 64);
%                 decision_128 = imdilate(decision_128, strel('disk', 2));
%                 response{2}.candidate = decision_128;
%                 response{2}.reliability = 1 - exp(-abs(w(1)*(response{2}.candidate - 0.5).^w(2)));
%     
%                 response_192 = detectForgeryPRNUCentral(im, true_camera, 193, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_192 = response_192.map_prp > 0.5;
%                 decision_192 = mapCleanup(decision_192, 64);
%                 decision_192 = imdilate(decision_192, strel('disk', 2));
%                 response{3}.candidate = decision_192;
%                 response{3}.reliability = 1 - exp(-abs(w(1)*(response{3}.candidate - 0.5).^w(2)));
%     
%                 response_256 = detectForgeryPRNUCentral(im, true_camera, 257, ...
%                     struct('verbose', true, 'stride', 8, 'image_padding', true));
%                 decision_256 = response_256.map_prp > 0.5;
%                 decision_256 = mapCleanup(decision_256, 64);
%                 decision_256 = imdilate(decision_256, strel('disk', 2));
%                 response{4}.candidate = decision_256;
%                 response{4}.reliability = 1 - exp(-abs(w(1)*(response{4}.candidate - 0.5).^w(2)));
%     
%                 response_maps = postprocessMaps(response, @(x) imresize(x, 0.5, 'bilinear'));
%                 fusion_labeling = fuseCRF(response_maps, im, th, [-1 0.5 5.6 25 0.18]);
%                 fusion_labeling = imresize(fusion_labeling, [1500 2000]);
%                 if sum(sum(fusion_labeling)) < 36000 || sum(sum(fusion_labeling)) > 1764000 
%                     disp(['No map for ' dirInfo(i).name inter_i]);
%                     bozza = [1,1,1,1;1,0,0,1;1,0,0,1;1,1,1,1];
%                     bozza = imresize(bozza, [1500,2000]);
%                     imwrite(bozza, strcat('ADQ2/map-',dirInfo(i).name))
%                     disp(inter);
%                     disp(inter_i);
%                 else
%                     disp(['PRNU' dirInfo(i).name]);
%                     disp(true_camera.name);
%                     imwrite(fusion_labeling, strcat('ADQ2/map-',dirInfo(i).name))
%                 end
%             else
%                 disp(['CAGI INV' dirInfo(i).name]);
%                 disp(inter_i);
%                 imwrite(cagi_inv_dd, strcat('ADQ2/map-',dirInfo(i).name))
%             end
%         else
%             disp(['CAGI' dirInfo(i).name]);
%             disp(inter);
%             imwrite(cagi_dd, strcat('ADQ2/map-',dirInfo(i).name))
%         end
%     else
%         disp('ADQ2')
%         imwrite(decision_ss2, strcat('ADQ2/map-',dirInfo(i).name));
%     end
% end

% img = 'dev_0011.tif';
% % img2 = 'prova-2.jpg';
% % % img2 = 'dev_0005.tif';
% % 
% pixmap = imread(img);
% pixmap = pixmap(:,:,1:3);
% % imwrite(pixmap,'prova-2.jpg', 'Quality', 100);
% % pixmap2 = imread(img2);
% cam = load('data/camera_models/flat-camera-4.mat');
% response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
%     8, true, false);
% max(max(response_ss2.map_cor))
% decision_ss2 = response_ss2.map_prp > 0.5;
% decision_ss2 = mapCleanup(decision_ss2, 64);
% decision_ss2 = imdilate(decision_ss2, strel('disk', 2));
% imshow(decision_ss2)
% imwrite(decision_ss2,strcat('adaptive-test','-1.bmp'))
% 
% % ADQ2
% % OutputMap = analyze(img2);
% % 
% % OutputMap = OutputMap > 0.75;
% % decision_ss2 = mapCleanup(OutputMap, 128);
% % imshowpair(decision_ss2, imread(img2), 'montage');
% % imwrite(OutputMap, 'map-natale.jpg');
% % if max(max(OutputMap)) == 0
% %    disp('cretino') 
% % else
% %     disp('1')
% % end

mkdir('DEMO-RESULTS');
dirInfo         = dir(['test*']);
[no, noOfImages] = size(dirInfo);
size(dirInfo)

 for j = 2:size(dirInfo)
    disp(dirInfo(j).name);
    get_map(dirInfo(j).name);
 end

% PER DOPO
% for j = 1:4
%             cam = load(strcat('data/camera_models/flat-camera-',num2str(j),'.mat'));
%             response_ss2 = detectForgeryPRNU(pixmap, cam.camera_model, 128, ...
%                 8, true, false);
%             disp(max(max(response_ss2.map_cor)))
%             if max(max(response_ss2.map_cor)) > 0.1
%                 decision_ss2 = response_ss2.map_prp > 0.5;
%                 decision_ss2 = mapCleanup(decision_ss2, 64);
%                 decision_ss2 = imdilate(decision_ss2, strel('disk', 2));
%                 imwrite(decision_ss2,strcat('ADQ2/map-',dirInfo(i).name));
%                 break;
%             end
%         end