clear all; close all;

addpath('../dev-dataset-maps');

dirInfo = dir(['*dev*']);
addpath('../');

total = 0.0;
num = 0;

values = [];

for i = 1:size(dirInfo)
    file = dirInfo(i).name;
    file = file(5:end);
    map_est=(imread(dirInfo(i).name));
    if max(max(map_est)) > 1 
        map_est = map_est > 230;
    end
    map_est2 = imresize(map_est, [1500 2000]);
    map_est3 = logical(map_est2);
    filegt = file(1:end-4);
    filegt = strcat(filegt, '.bmp');
    map_gt=(imread(filegt));
    [F] = f_measure(map_gt,map_est3);
    map_est_inv = map_est3 == 0;
    [F2] = f_measure(map_gt,map_est_inv);
    est = max(F, F2);
    disp(dirInfo(i).name);
    disp(est);
    num = num + 1;
    total = total + est;
    values = [values, est];
end
[values_sorted, I] = sort(values);
disp(strcat('MINIM0-1: ', num2str(I(1)),'-',num2str(values_sorted(1)))); 
disp(strcat('MINIM0-2: ', num2str(I(2)),'-',num2str(values_sorted(2)))); 
disp(strcat('MINIM0-3: ', num2str(I(3)),'-',num2str(values_sorted(3)))); 
disp(strcat('MAX-1: ', num2str(I(798)),'-',num2str(values_sorted(798)))); 
disp(strcat('MAX-2: ', num2str(I(799)),'-',num2str(values_sorted(799)))); 
disp(strcat('MAX-3: ', num2str(I(800)),'-',num2str(values_sorted(800)))); 
values_sorted = values_sorted(40:end);

disp(strcat('ACTUAL MEAN:', num2str(total/num)));
disp(strcat('ACTUAL MEAN SKIMMED:', num2str(mean(values_sorted))));

% Open the example ground truth tampering map
% map_gt=double(imread('map.BMP'));
% subplot(1,2,1); imshow(map_gt);

% Simulate an estimated tampering map
% map_est = rem(map_gt+round(rand(size(map_gt))-0.4),2);
% subplot(1,2,2); imshow(map_est);

% Compute F-measure

% [F] = f_measure(map_gt,map_est);




