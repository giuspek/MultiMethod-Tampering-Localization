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

close all; clear all;

% dirInfo         = dir(['*.jpg']);
% [no, noOfImages] = size(dirInfo);
% size(dirInfo)
% for i = 1:no
%     im = dirInfo(i).name;
%     OutputMap = analyze(im);
%     imwrite(OutputMap, strcat('map-',dirInfo(i).name));
% end

dirInfo         = dir(['*.tif']);
[no, noOfImages] = size(dirInfo);
size(dirInfo)
for i = 1:no
    a = imread(dirInfo(i).name);
    a = (a(:,:,1:3));
    prova = strcat('prova-',num2str(i),'.jpg');
    imwrite(a,prova, 'Quality', 100);
    im = prova;
    OutputMap = analyze(im);
    imwrite(OutputMap, strcat('map-',dirInfo(i).name));
end

% imagesc(OutputMap);