function [ out,runtime ] = enhance( f,K,rad,sigma_r,a,col_flag,fast_flag,H )
%ENHANCE Detail enhancement using user-supplied parameters
% f = Input image (scale [0,255])
% K = Gain applied to detail layer
% rad = Radius of filter kernel
% sigma_r = sigma_r map
% col_flag = true to perform filtering in joint RGB space
% fast_flag = true to use fast approximation of adaptive bilateral filter
% H = 1-by-size(f,3) cell of channelwise integral histograms of f
% out = Output (enhanced) image
% runtime = Execution time for FILTERING only

if(nargin==4)
    a = 1; col_flag = false; fast_flag = false;
elseif(nargin==5)
    col_flag = false; fast_flag = false;
elseif(nargin==6)
    fast_flag=false;
end
if(fast_flag && nargin==7)
    error('Channelwise integral histograms not supplied');
end
if(col_flag && size(f,3)~=3)
    error('Color filtering can be performed only on RGB images');
end

if(isscalar(K))
    K = K*ones(size(f,1),size(f,2));
end
if(isscalar(sigma_r))
    sigma_r = sigma_r*ones(size(f,1),size(f,2));
end

% Extract base & detail layers for each channel
if(col_flag && size(f,3)==3)
    tic;
    base = VEPFcolor(f,'box',rad,sigma_r,'zeros');
    runtime = toc;
else
    base = nan(size(f));
    if(fast_flag)
        tic;
        for k = 1:size(f,3)
            base(:,:,k) = fastbilateral(f(:,:,k),H{k},rad,sigma_r);
        end
        runtime = toc;
    else
        tic;
        for k = 1:size(f,3)
            base(:,:,k) = VEPF(f(:,:,k),'box',rad,sigma_r,'zeros');
        end
        runtime = toc;
    end
end
detail = f - base;

out = base + repmat(K,1,1,3).*(detail.^a);

end

