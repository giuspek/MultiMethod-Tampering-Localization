function [] = get_map(image_name)
    % ADDITION OF ALL SUPPORT PATHS
    addpath(genpath(pwd))

    % LOADING OF ALL CAMERA MODELS
    camera1 = load('flat-camera-1.mat');
    camera2 = load('flat-camera-2.mat');
    camera3 = load('flat-camera-3.mat');
    camera4 = load('flat-camera-4.mat');

    camera1 = camera1.camera_model;
    camera2 = camera2.camera_model;
    camera3 = camera3.camera_model;
    camera4 = camera4.camera_model;

    % THRESHOLD VALUE AND PARAMETERS USED BY THE PRNU ANF CFA ANALYSIS
    w = [30,2.5];
    th = 0.4;
    Nb = 14;
    Ns = 1;
    bayer = [0, 1;
         1, 0];
    
    isTIF = false;
    hasTrasparency = false;
    
    % READING OF IMAGE AND SETTING NAME FOR BMP MAP
    image = imread(image_name);
    image_name_bmp = strcat(image_name(1:end-4), '.bmp');
    
    % IF 4 OR MORE LAYERS (TRASPARENCY), REDUCE TO RGB
    [~,~,z] = size(image);
    if z ~= 3 
        disp(z);
        disp('REMOVE TRASPARENCY');
        hasTrasparency = true;
        image_reduced = image(:,:,1:3);
        image_name_reduced = strcat(image_name(1:end-4), '-reduced.tif');
        imwrite(image_reduced, image_name_reduced);
        
    end
    
    % IF TIF FILE, ADD A JPG FILE FOR ANALYSIS
    if endsWith(image_name, '.tif') || endsWith(image_name, '.TIF')
        isTIF = true;
        image_name_jpg = strcat(image_name(1:end-4), '.jpg');
        if hasTrasparency
            imwrite(image_reduced, image_name_jpg, 'Quality', 100);
        else
            imwrite(image, image_name_jpg, 'Quality', 100);
        end
    end 
    
   % ADQ2 ANALYSIS
    try
        if isTIF
           OutputADQ = analyze(image_name_jpg); 
        else
           OutputADQ = analyze(image_name); 
        end   
        OutputADQ = OutputADQ > 0.75;
        decision_ss2 = mapCleanup(OutputADQ, 64);
        
        % VALID ONLY IF TAMPERED BITS ARE BETWEEN 5% AND 95%
        if sum(sum(decision_ss2)) >= 2350 && sum(sum(decision_ss2)) <= 44650
            disp('ADQ2')
            map = imresize(decision_ss2, [1500 2000]);
            imwrite(map, strcat('DEMO-RESULTS/map-',image_name_bmp));
            disp(max(max(map)));
            return
        end
    catch e
         disp('Error on ADQ2');
         disp(e.message)
    end
    
    % CAGI
    try
        if hasTrasparency
           [ cagi, cagi_inv ] = CAGI(image_name_reduced); 
        else
           [ cagi, cagi_inv ] = CAGI(image_name); 
        end
        maxi = max(max(cagi));
        mini = min(min(cagi));
        inter = maxi - mini;
        cagi_dd = cagi > (maxi - (inter *0.5));
        cagi_dd = mapCleanup(cagi_dd, 64);
        % VALID ONLY IF TAMPERED BITS ARE BETWEEN 5% AND 95%
        if inter < 0.5 || (sum(sum(cagi_dd)) < 36000 || sum(sum(cagi_dd)) > 1764000)
            % INVERSE CAGI
            maxi_i = max(max(cagi_inv));
            mini_i = min(min(cagi_inv));
            inter_i = maxi_i - mini_i;
            cagi_inv_dd = cagi_inv < (mini_i + (inter_i * 0.5));
            cagi_inv_dd = mapCleanup(cagi_inv_dd, 64);
            % VALID ONLY IF TAMPERED BITS ARE BETWEEN 5% AND 95%
            if inter_i > 0.48 && (sum(sum(cagi_inv_dd)) >= 36000 && sum(sum(cagi_inv_dd)) <= 1764000)
                disp('CAGI INV');
                map = imresize(cagi_inv_dd, [1500 2000]);
                imwrite(map, strcat('DEMO-RESULTS/map-',image_name_bmp));
                return
            end
        else
            disp('CAGI');
            map = imresize(cagi_dd, [1500 2000]);
            imwrite(map, strcat('DEMO-RESULTS/map-',image_name_bmp));
            return
        end
    catch e
         disp('Error on CAGI');
         disp(e.message)
    end 
    
    % CFA
    try
        if hasTrasparency
            image = imread(image_name_reduced);
        else
            image = imread(image_name);
        end
        [map, stat] = CFAloc(image, bayer, Nb,Ns);
        [h w] = size(map);
        %    NaN and Inf management
        stat(isnan(stat)) = 1;
        data = log(stat(:)); 
        data = data(not(isinf(data)|isnan(data)));
        % square root rule for bins
        n_bins = round(sqrt(length(data)));
        if abs(max(max(map))) - 100 > abs(min(min(map)))
            result = map < min(min(map)) + 0.05 * abs(max(max(map)) - min(min(map)));
            disp('Big GAP');
        elseif abs(max(max(map)) - min(min(map))) > 5
            result = map < 0; 
            disp('Small GAP');
        else
            result = map < -1000000;
        end
        decision_ss2 = mapCleanup(result, 64);
        if sum(sum(decision_ss2)) >= 772 && sum(sum(decision_ss2)) <= 14671
            disp(['CFA']);
            imwrite(decision_ss2,strcat('DEMO-RESULTS/map-', image_name_bmp));
            return
        end
    catch e
        disp('Error on CAGI');
        disp(e.message);
    end
    
    % MULTI-PRNU
    try
        if hasTrasparency
            image = double(rgb2gray(imread(image_name_reduced)));
            im = imread(image_name_reduced);
        else
            image = double(rgb2gray(imread(image_name)));
            im =imread(image_name);
        end
        std_image = stdfilt3(image);
        hpf_std_image = stdfilt3(highPass(image));
        prnu1 = rgb2gray1(camera1.prnu);
        prnu2 = rgb2gray1(camera2.prnu);
        prnu3 = rgb2gray1(camera3.prnu);
        prnu4 = rgb2gray1(camera4.prnu);
        corrA = corr2( prnu1 .* image, image - hpf_std_image);
        corrB = corr2( prnu2 .* image, image - hpf_std_image);
        corrC = corr2( prnu3 .* image, image - hpf_std_image);
        corrD = corr2( prnu4 .* image, image - hpf_std_image);
        max_corr = max([corrA corrB corrC corrD]);
        true_camera = [];
        switch max_corr
            case corrA
            true_camera = camera1;
            case corrB
                true_camera = camera2;
            case corrC
                true_camera = camera3;
            case corrD
                true_camera = camera4;
        end
        % CORRELAZIONE NON VALIDA, FUORI CICLO
        if max_corr < 0.001
           error('No valid camera model for image');
        end
        response_96 = detectForgeryPRNUCentral(im, true_camera, 97, ...
            struct('verbose', true, 'stride', 8, 'image_padding', true));
        decision_96 = response_96.map_prp > 0.5;
        decision_96 = mapCleanup(decision_96, 64);
        decision_96 = imdilate(decision_96, strel('disk', 2));
        response{1}.candidate = decision_96;
        response{1}.reliability = 1 - exp(-abs(30*(response{1}.candidate - 0.5).^2.5));

        response_128 = detectForgeryPRNUCentral(im, true_camera, 129, ...
            struct('verbose', true, 'stride', 8, 'image_padding', true));
        decision_128 = response_128.map_prp > 0.5;
        decision_128 = mapCleanup(decision_128, 64);
        decision_128 = imdilate(decision_128, strel('disk', 2));
        response{2}.candidate = decision_128;
        response{2}.reliability = 1 - exp(-abs(30*(response{2}.candidate - 0.5).^2.5));

        response_192 = detectForgeryPRNUCentral(im, true_camera, 193, ...
            struct('verbose', true, 'stride', 8, 'image_padding', true));
        decision_192 = response_192.map_prp > 0.5;
        decision_192 = mapCleanup(decision_192, 64);
        decision_192 = imdilate(decision_192, strel('disk', 2));
        response{3}.candidate = decision_192;
        response{3}.reliability = 1 - exp(-abs(30*(response{3}.candidate - 0.5).^2.5));

        response_256 = detectForgeryPRNUCentral(im, true_camera, 257, ...
            struct('verbose', true, 'stride', 8, 'image_padding', true));
        decision_256 = response_256.map_prp > 0.5;
        decision_256 = mapCleanup(decision_256, 64);
        decision_256 = imdilate(decision_256, strel('disk', 2));
        response{4}.candidate = decision_256;
        response{4}.reliability = 1 - exp(-abs(30*(response{4}.candidate - 0.5).^2.5));

        response_maps = postprocessMaps(response, @(x) imresize(x, 0.5, 'bilinear'));
        fusion_labeling = fuseCRF(response_maps, im, th, [-1 0.5 5.6 25 0.18]);
        fusion_labeling = imresize(fusion_labeling, [1500 2000]);
        if sum(sum(fusion_labeling)) >= 36000 && sum(sum(fusion_labeling)) <= 1764000 
            disp(['PRNU']);
            imwrite(fusion_labeling, strcat('DEMO-RESULTS/map-',image_name_bmp))       
        end
    catch e
        disp('Error on PRNU');
        disp(e.message);
    end
    
    
end


