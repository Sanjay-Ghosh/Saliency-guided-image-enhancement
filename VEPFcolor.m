function [ Bf ] = VEPFcolor( f,filtype,sigma_s,sigma_r,padtype )
%VEPFCOLOR Summary of this function goes here
%   Detailed explanation goes here

f = double(f);
[fr, fc, ~] = size(f);
if(strcmp(filtype,'gaussian'))
    kerrad = 3*sigma_s;
elseif(strcmp(filtype,'box'))
    kerrad = sigma_s;
end

% Initialize
W = zeros([fr,fc,3]);
Z = zeros([fr,fc]);
Bf = zeros([fr,fc,3]);
mask = (sigma_r~=0);
mask3 = repmat(mask,1,1,3);
Bf(~mask3) = f(~mask3);

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
            nb = f(j1-kerrad:j1+kerrad,j2-kerrad:j2+kerrad,:);
            r_arg = sum((nb-f(j1,j2,:)).^2,3);
            rker = exp(-0.5*r_arg/(sigma_r(j1-kerrad,j2-kerrad)^2));
            W(j1-kerrad,j2-kerrad,:) = sum(sum(repmat(spker.*rker,1,1,3) .* nb,1),2);
            Z(j1-kerrad,j2-kerrad) = sum(sum(spker .* rker));
        end
    end
end

Z3 = repmat(Z,1,1,3);
Bf(mask3) = W(mask3) ./ Z3(mask3);

end


