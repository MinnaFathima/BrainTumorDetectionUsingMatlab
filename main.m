clc;
close all;
clear all;

% Input
[Ipath, pathname] = uigetfile('*.jpg', 'Select an input image');
str = fullfile(pathname, Ipath);
s = imread(str);
figure;
imshow(s);
title('Input image', 'FontSize', 20);

% Filter (Anisotropic Diffusion)
num_iter = 10;
delta_t = 1/7;
kappa = 15;
option = 2;
disp('Preprocessing image please wait . . .');
inp = anisodiff(s, num_iter, delta_t, kappa, option);  % Call to anisodiff.m
inp = uint8(inp);

inp = imresize(inp, [256 256]);
if size(inp, 3) > 1
    inp = rgb2gray(inp);
end
figure;
imshow(inp);
title('Filtered image', 'FontSize', 20);

% Thresholding
sout = imresize(inp, [256 256]);
t0 = 60;  %offset value
th = t0 + ((max(inp(:)) + min(inp(:))) / 2);
for i = 1:size(inp, 1)
    for j = 1:size(inp, 2)
        if inp(i, j) > th  %pixels above the threshold are set to 1 (white) indicating tumor, and those below are set to 0 (black), creating a binary image.
            sout(i, j) = 1;
        else
            sout(i, j) = 0;
        end
    end
end

% Morphological Operations
label = bwlabel(sout);
stats = regionprops(logical(sout), 'Solidity', 'Area', 'BoundingBox');
density = [stats.Solidity];
area = [stats.Area];
high_dense_area = density > 0.6;
max_area = max(area(high_dense_area));
tumor_label = find(area == max_area);
tumor = ismember(label, tumor_label);

if max_area > 100
    figure;
    imshow(tumor);
    title('Tumor alone', 'FontSize', 20);
else
    msgbox('No Tumor!!', 'status');
    return;
end

% Bounding Box
box = stats(tumor_label);
wantedBox = box.BoundingBox;
figure;
imshow(s);
title('Bounding Box', 'FontSize', 20);
hold on;
rectangle('Position', wantedBox, 'EdgeColor', 'y');
hold off;

% Getting tumor outline - erosion
dilationAmount = 5;
rad = floor(dilationAmount);
[r, c] = size(tumor);
filledImage = imfill(tumor, 'holes');

erodedImage = tumor;  % Initialize erodedImage
for i = 1:r
    for j = 1:c
        x1 = max(1, i - rad);
        x2 = min(r, i + rad);
        y1 = max(1, j - rad);
        y2 = min(c, j + rad);
        erodedImage(i, j) = min(min(filledImage(x1:x2, y1:y2)));
    end
end

% Subtracting eroded image from original BW image
tumorOutline = tumor;
tumorOutline(erodedImage) = 0;

figure;
imshow(tumorOutline);
title('Tumor Outline', 'FontSize', 20);

% Inserting the outline in the filtered image
rgb = cat(3, inp, inp, inp);
red = rgb(:, :, 1);
green = rgb(:, :, 2);
blue = rgb(:, :, 3);
red(tumorOutline == 1) = 255;
green(tumorOutline == 1) = 0;
blue(tumorOutline == 1) = 0;
tumorOutlineInserted = cat(3, red, green, blue);

figure;
imshow(tumorOutlineInserted);
title('Detected Tumor', 'FontSize', 20);

% Display everything together
figure;
subplot(2, 3, 1); imshow(s); title('Input image', 'FontSize', 10);
subplot(2, 3, 2); imshow(inp); title('Filtered image', 'FontSize', 10);
subplot(2, 3, 3); imshow(inp); title('Bounding Box', 'FontSize', 10);
hold on; rectangle('Position', wantedBox, 'EdgeColor', 'y'); hold off;
subplot(2, 3, 4); imshow(tumor); title('Tumor alone', 'FontSize', 10);
subplot(2, 3, 5); imshow(tumorOutline); title('Tumor Outline', 'FontSize', 10);
subplot(2, 3, 6); imshow(tumorOutlineInserted); title('Detected Tumor', 'FontSize', 10);
