function [ ed ] = edgemap( f )
%EDGEMAP Summary of this function goes here
%   Detailed explanation goes here

gamma_grad = 0.8;

fr = f(:,:,1);
fg = f(:,:,2);
fb = f(:,:,3);

[rG,~] = imgradient(fr,'prewitt');
[gG,~] = imgradient(fg,'prewitt');
[bG,~] = imgradient(fb,'prewitt');

rG = rG/max(rG(:));
rG = imadjust(rG,[min(rG(:)),max(rG(:))],[],gamma_grad);
gG = gG/max(gG(:));
gG = imadjust(gG,[min(gG(:)),max(gG(:))],[],gamma_grad);
bG = bG/max(bG(:));
bG = imadjust(bG,[min(bG(:)),max(bG(:))],[],gamma_grad);

ed = (rG+gG+bG)/3;
% ed(ed<0.2) = 0;
ed = imdilate(ed,ones(3));  % Thicken edges

end

