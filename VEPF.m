function [ Bf ] = VEPF( f,filtype,sigma_s,sigma_r,padtype )
%VEPF Variable Edge-Preserving Filter
% Direct implementation of the bilateral filter
% with Gaussian/box spatial kernel.
% Input args:
%   f = m-by-n Input image (double)
%   sigma_s = Standard deviation of Gaussian spatial kernel
%   sigma_r = m-by-n matrix of standard deviations of Gaussian range kernels
% Output args:
%   Bf = Output image

f = double(f);
[fr, fc] = size(f);
if(strcmp(filtype,'gaussian'))
    kerrad = 3*sigma_s;
elseif(strcmp(filtype,'box'))
    kerrad = sigma_s;
end

% Initialize
W = zeros([fr,fc]);
Z = zeros([fr,fc]);
Bf = zeros([fr,fc]);
mask = (sigma_r~=0);
Bf(~mask) = f(~mask);

if(strcmp(padtype,'zeros'))
    f = padarray(f,[kerrad, kerrad, 0]);
elseif(strcmp(padtype,'symmetric'))
    f = padarray(f,[kerrad, kerrad, 0],'symmetric');  % Pad image
end

% Gaussian spatial kernel
if(strcmp(filtype,'gaussian'))
    spker = fspecial('gaussian',2*kerrad+1,sigma_s);
elseif(strcmp(filtype,'box'))
    spker = ones(2*kerrad+1);
end

% Start implementation
for j1 = kerrad+1:kerrad+fr
    for j2 = kerrad+1:kerrad+fc
        if(mask(j1-kerrad,j2-kerrad))
            nb = f(j1-kerrad:j1+kerrad,j2-kerrad:j2+kerrad);
            r_arg = (nb-f(j1,j2)).^2;
            rker = exp(-0.5*r_arg/(sigma_r(j1-kerrad,j2-kerrad)^2));
            W(j1-kerrad,j2-kerrad) = sum(sum(spker .* rker .* nb));
            Z(j1-kerrad,j2-kerrad) = sum(sum(spker .* rker));
        end
    end
end

Bf(mask) = W(mask) ./ Z(mask);

end
