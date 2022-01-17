function [ sal ] = calcSaliency( f )
%CALCSALIENCY Summary of this function goes here
%   Detailed explanation goes here

if(size(f,3)==1)
    sal = channelSaliency(f);
else
    s1 = channelSaliency(f(:,:,1));
    s2 = channelSaliency(f(:,:,2));
    s3 = channelSaliency(f(:,:,3));
    
    % Normalize and combine channelwise saliencies
    s1 = (s1-min(s1(:)))/(max(s1(:))-min(s1(:)));
    s2 = (s2-min(s2(:)))/(max(s2(:))-min(s2(:)));
    s3 = (s3-min(s3(:)))/(max(s3(:))-min(s3(:)));
    s1_new = medfilt2(s1,[5,5]);
    s2_new = medfilt2(s2,[5,5]);
    s3_new = medfilt2(s3,[5,5]);
    sal = (s1_new+s2_new+s3_new)/3;
end

% Apply Gaussian bluring
hsize = round(size(f,1)/30);
if(mod(hsize,2)==0), hsize = hsize+1; end
hsigma = hsize/6;
sal = imfilter(sal,fspecial('gaussian',hsize,hsigma));

end


function [ S ] = channelSaliency( x )

[m1, n1, ~] = size(x);
S = zeros(m1,n1);

z = 6;
N = (2*z+1)^2;
Set = zeros(N, 2);
p = 1;
for i = -z:z    
    for j = -z:z
        Set(p,1) = i;
        Set(p,2)=j;
        p = p+1;
    end
end
Set;

% lab = rgb2lab(x);
% x = uint8(lab);
% x = rgb2gray(x);
% x = uint8(rgb2ycbcr(x));

r = x;
[H, SI] = graycomatrix(r, 'Offset',Set, 'NumLevels', 256, 'GrayLimits',[]);
H1 = sum(H,3);
P = H1./sum(H1(:));

nz = nnz(P);
U = 1/nz;

p_bar = zeros(size(P));
[m, n] = size(P);

mask = (P<=U);
p_bar(mask) = U - P(mask);

% for i = 1:m
%     for j = 1:n
%         if P(i,j) <= U
%             p_bar(i, j) = U - P(i,j);
%         end
%     end
% end

for i = 1:m1
    for j = 1:n1
        t1 = r(i, j);
        for i1 = max(i-z, 1) : min(i+z, m1)
            for j1 = max(j-z, 1) : min(j+z, n1)
                t2 = r(i1, j1);
                S(i,j) = S(i, j) + p_bar(t1 + 1, t2 + 1);
            end
        end
    end
end

end

