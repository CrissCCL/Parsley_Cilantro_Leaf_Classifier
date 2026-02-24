clear; clc; close all;

% ===== load trained model =====
S = load('model_green_svm.mat');   % contains: mdl_final, Nang, Kfft, minArea
mdl = S.mdl_final;
Nang = S.Nang;
Kfft = S.Kfft;
minArea = S.minArea;

resizeFactor = 0.2;  % same resize factor used during dataset generation

% ===== select image =====
[file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp','Images'}, 'Select an image');
if isequal(file,0), return; end
I0 = imread(fullfile(path,file));
Iresize = imresize(I0, resizeFactor);

% ===== manual ROI on resized image =====
figure('Name','Select ROI','Color','w');
imshow(Iresize);
title('Draw ROI around the leaf and press Enter');
h = drawrectangle('Color','r','LineWidth',2);
wait(h);
bbox_r = h.Position;
close(gcf);

bbox = bbox_r / resizeFactor;
Iroi = imcrop(I0, bbox);

% ===== green segmentation + cleanup =====
[BW_green, dbg] = segment_green_minus_gray(Iroi, minArea);

% ===== radial feature + prediction =====
x = radial_fourier_descriptor(BW_green, Nang, Kfft);   % 1xKfft
y = predict(mdl, x);

if y==1
    label = "CILANTRO";
else
    label = "PARSLEY";
end

% ===== visualization (similar to your debug figures) =====
...
fprintf('\nPrediction: %s\n', label);


% ===== visualización (similar a tus figuras) =====
Iroi_d = im2double(Iroi);
G = Iroi(:,:,2);
R = Iroi_d(:,:,1); Gd = Iroi_d(:,:,2); B = Iroi_d(:,:,3);
ExG_norm = mat2gray(2*Gd - R - B);
figure('Name','FINAL classification (green + SVM)','Color','w');
subplot(2,3,1); imshow(Iresize); title('Imagen (resize 0.2)');
hold on; rectangle('Position',bbox_r,'EdgeColor','r','LineWidth',2); hold off;

subplot(2,3,2); imshow(Iroi); title('selected ROI');
subplot(2,3,3); imshow(G,[]); title('Green (G)');
subplot(2,3,4); imshow(ExG_norm,[]); title('Green Bias (norm)');
subplot(2,3,5); imshow(dbg.Sg,[]); title('G - Gray (norm)');
%subplot(2,3,5); imshow(dbg.ExG,[]); title('G - Gray (norm)');
subplot(2,3,6); imshow(BW_green); title('BW green (clean)');

sgtitle(sprintf('FINAL prediction: %s (SVM) | Nang=%d Kfft=%d', label, Nang, Kfft), ...
    'FontWeight','bold');

fprintf('\nPredicción: %s\n', label);


plot_radial_descriptor(BW_green, Nang, Kfft, outPath)