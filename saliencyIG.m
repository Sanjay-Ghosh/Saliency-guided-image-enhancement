function [ sm ] = saliencyIG( img )
%SALIENCYIG Summary of this function goes here
%   Detailed explanation goes here

img = uint8(img);
gfrgb = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

% cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
% lab = applycform(gfrgb,cform);

lab = rgb2lab(gfrgb,'WhitePoint','d65');

l = double(lab(:,:,1)); lm = mean(mean(l));
a = double(lab(:,:,2)); am = mean(mean(a));
b = double(lab(:,:,3)); bm = mean(mean(b));

sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
sm = (sm-min(sm(:)))/(max(sm(:))-min(sm(:)));

end

