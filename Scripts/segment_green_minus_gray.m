function [BW, dbg] = segment_green_minus_gray(Irgb, minArea)
%SEGMENT_GREEN_MINUS_GRAY Green segmentation using "Green minus Gray".
%
% This method is very stable when the background is gray/neutral.
%
% Inputs:
%   Irgb    : RGB image (uint8/uint16/double)
%   minArea : minimum connected-component area to keep
%
% Outputs:
%   BW  : cleaned binary mask (leaf = 1)
%   dbg : debug struct with intermediate images

if nargin < 2, minArea = 150; end

I = im2double(Irgb);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

% --- Option A: "Green minus Gray" index (very stable on gray backgrounds) ---
Gray = (R + G + B)/3;
Sg = G - Gray;               % enhance green relative to neutral background
Sg = mat2gray(Sg);           % normalize for thresholding

% --- Otsu threshold over Sg ---
t = graythresh(Sg);
BW0 = imbinarize(Sg, t);

% --- Cleanup ---
BW1 = imfill(BW0,'holes');
BW1 = bwareaopen(BW1, minArea);
BW  = bwareafilt(BW1, 1);

% Ensure consistent polarity (leaf should be foreground)
if nnz(BW) > 0.5*numel(BW)
    BW = ~BW;
    BW = bwareafilt(BW,1);
end

% Light smoothing
BW = imopen(BW, strel('disk',2));
BW = imclose(BW, strel('disk',3));
BW = bwareafilt(BW,1);

dbg.Sg = Sg;
dbg.BW0 = BW0;
dbg.BW = BW;

end