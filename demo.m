
clearvars; close all;
clc;

% input_image = './images1/bird9.jpg';
% input_image = './images1/peacock5.jpg';
input_image = 'tiger1.jpg';
% input_image = './images1/flower9.jpg';
input_image = 'seahorse1.jpg';

rsz = 1;      % Resize input image by this factor

% Parameters
rad = 5;    % Filter kernel radius
a = 1;

%% Read & display image
f = imread(input_image);

% f = f(271:end,1:1160,:);

if(size(f,3)==2)
    f = f(:,:,1);
end
f = imresize(f,rsz);
f = double(f);
figure; imshow(uint8(f)); pause(0.01); title('Input'); drawnow;

%% Saliency
% Compute visual saliency map
fprintf('Computing saliency map ...\n');
% sal = calcSaliency(f);
sal = saliencyIG(f);
% S = gbvs(uint8(f)); sal = S.master_map_resized;
fprintf('Done\n');

% Compute edge map
ed = edgemap(f);

% Remove sharp edges from saliency map
% sal(ed>=0.5) = 0;

figure; imshow(sal); title('Saliency'); colorbar; pause(0.01);

%% Adaptive BF, non-adaptive K
lambda_sigmar = 20;       % Growth/Decay parameter of mapping curve
sigma_min = 0;     % Min. value of sigma_r
sigma_max = 80;     % Max. value of sigma_r
cen_sigmar = 0.5;
K_fixed = 4;
[sigma_r,sigmar_plotdata] = sigmoidMap(sal,cen_sigmar,lambda_sigmar,0,sigma_max,0:0.01:1);
sigma_r = round(sigma_r);
% [g1,t1] = enhance(f,K_fixed,rad,sigma_r,a,false,false);
[g2,t2] = enhance(f,K_fixed,rad,sigma_r,a,true,false);

figure; imshow(uint8(g2)); pause(0.01); title('Output'); drawnow;

% d1 = display_Diff_Img(g1 - f,30);
% d2 = display_Diff_Img(g2 - f,30);
% hf1 = figure;
% figure(hf1); subplot(2,3,1); imshow(uint8(f)); title('Input'); drawnow; pause(0.01);
% figure(hf1); subplot(2,3,2); imshow(uint8(g1)); title('Channelwise'); drawnow; pause(0.01);
% figure(hf1); subplot(2,3,3); imshow(uint8(g2)); title('Joint'); drawnow; pause(0.01);
% figure(hf1); subplot(2,3,4); imshow(sigma_r,[]); colorbar; title('\sigma_r'); drawnow; pause(0.01);
% figure(hf1); subplot(2,3,5); imshow(uint8(d1)); title('Residue'); drawnow; pause(0.01);
% figure(hf1); subplot(2,3,6); imshow(uint8(d2)); title('Residue'); drawnow; pause(0.01);

% Non-adaptive BF, adaptive K
% lambda_K = 10;       % Growth/Decay parameter of mapping curve
% K_min = 1;     % Min. value of sigma_r
% K_max = 5;     % Max. value of sigma_r
% cen_K = 0.4;
sigma_r_fixed = 60;
K = K_fixed;
% [K,K_plotdata] = sigmoidMap(sal,cen_K,lambda_K,K_min,K_max,0:0.01:1);
% [g3,t3] = enhance(f,K,rad,sigma_r_fixed,a,false,false);
[g4,t4] = enhance(f,K,rad,sigma_r_fixed,a,true,false);
% d3 = display_Diff_Img(g3 - f,30);
% d4 = display_Diff_Img(g4 - f,30);
% % hf2 = figure;
% % figure(hf2); subplot(2,3,1); imshow(uint8(f)); title('Input'); drawnow; pause(0.01);
% % figure(hf2); subplot(2,3,2); imshow(uint8(g3)); title('Channelwise'); drawnow; pause(0.01);
% % figure(hf2); subplot(2,3,3); imshow(uint8(g4)); title('Joint'); drawnow; pause(0.01);
% % figure(hf2); subplot(2,3,4); imshow(K,[]); colorbar; title('K'); drawnow; pause(0.01);
% % figure(hf2); subplot(2,3,5); imshow(uint8(d3)); title('Residue'); drawnow; pause(0.01);
% % figure(hf2); subplot(2,3,6); imshow(uint8(d4)); title('Residue'); drawnow; pause(0.01);

%% Non-adaptive BF, non-adaptive K
% % [g5,t5] = enhance(f,K_fixed,rad,sigma_r_fixed,a,false,false);
% [g6,t6] = enhance(f,K_fixed,rad,sigma_r_fixed,a,true,false);
% % d5 = display_Diff_Img(g5 - f,30);
% d6 = display_Diff_Img(g6 - f,30);
% % hf3 = figure;
% % figure(hf3); subplot(2,3,1); imshow(uint8(f)); title('Input'); drawnow; pause(0.01);
% % figure(hf3); subplot(2,3,2); imshow(uint8(g5)); title('Channelwise'); drawnow; pause(0.01);
% % figure(hf3); subplot(2,3,3); imshow(uint8(g6)); title('Joint'); drawnow; pause(0.01);
% % figure(hf3); subplot(2,3,5); imshow(uint8(d5)); title('Residue'); drawnow; pause(0.01);
% % figure(hf3); subplot(2,3,6); imshow(uint8(d6)); title('Residue'); drawnow; pause(0.01);

%% Adaptive BF, adaptive K
% [g7,t7] = enhance(f,K,rad,sigma_r,a,false,false);
% [g8,t8] = enhance(f,K,rad,sigma_r,a,true,false);

%% Hard segmentation
% sigma_r_bin = sigma_max*ones(size(f,1),size(f,2));
% sigma_r_bin(sal<cen_sigmar) = 0;
% [g9,t9] = enhance(f,K_fixed,rad,sigma_r_bin,a,false,false);
% [g10,t10] = enhance(f,K_fixed,rad,sigma_r_bin,a,true,false);
% d9 = display_Diff_Img(g9 - f,30);
% d10 = display_Diff_Img(g10 - f,30);

% figure; imshow(uint8(g1)); title('Adaptive \sigma_r, channelwise'); pause(0.01); drawnow;
% figure; imshow(uint8(g4)); title('Adaptive K, joint'); pause(0.01); drawnow;
% figure; imshow(uint8(g2)); title('Adaptive \sigma_r, joint'); pause(0.01); drawnow;
% figure; imshow(uint8(g3)); title('Adaptive K, channelwise'); pause(0.01); drawnow;
% figure; imshow(uint8(g7)); title('Adaptive \sigma_r and K, channelwise'); pause(0.01); drawnow;
% figure; imshow(uint8(g8)); title('Adaptive \sigma_r and K, joint'); pause(0.01); drawnow;

