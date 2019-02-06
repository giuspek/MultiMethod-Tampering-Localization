% The demo image is taken from the dataset used in:
% Fontani, Marco, Tiziano Bianchi, Alessia De Rosa, Alessandro Piva, and 
% Mauro Barni. "A framework for decision fusion in image forensics based on 
% Dempster–Shafer theory of evidence." Information Forensics and Security, 
% IEEE Transactions on 8, no. 4 (2013): 593-607.
% Original image name: Forgery_final 15.jpg
% Dataset available at: http://clem.dii.unisi.it/~vipp/index.php/imagerepos
% itory/129-a-framework-for-decision-fusion-in-image-forensics-based-on-dem
% pster-shafer-theory-of-evidence

close all; clear all;
addpath('../');
addpath('../multiscale-prnu-master/commons/');
im='dev_0396.jpg';
% im='dev_015.jpg';
OutputMap = analyze(im);
% imagesc(OutputMap);
disp(max(max(OutputMap)));
disp(min(min(OutputMap)));
disp(max(max(OutputMap)) - min(min(OutputMap)));
% imshow(OutputMap)
img = OutputMap > (max(max(OutputMap))*8/100);
r=4;
n=4;
se = strel('disk',r);
imgg = imdilate(img,se);
imggez = mapCleanup(imgg,4096);

if sum(sum(imggez))<100000 || sum(sum(imggez))>2850000 
    img = OutputMap > (max(max(OutputMap))*4/100);
    disp('culo')
    r=4;
    n=4;
    se = strel('disk',r);
    imgg = imdilate(img,se);
    imggez = mapCleanup(imgg,4096);
    if sum(sum(imggez))>=100000 && sum(sum(imggez))<=2850000
        imwrite(imggez, strcat('../DEMO-RESULTS/', im(1:end-4), '.bmp'));
    else
        disp('CAZZO');
    end
else
    imwrite(imggez, strcat('../DEMO-RESULTS/', im(1:end-4), '.bmp'));
end


