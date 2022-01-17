function [ y,ply ] = sigmoidMap( x,x0,lambda,ymin,ymax,plx )
%SIGMOIDMAP Summary of this function goes here
%   Detailed explanation goes here

if(~exist('x0','var')), x0 = 0.5; end
if(~exist('lambda','var')), lambda = 2; end
if(~exist('ymin','var')), ymin = 0; end
if(~exist('ymax','var')), ymax = 1; end

a = ymax - ymin;
y = a./(1 + exp(-lambda*(x-x0))) + ymin;

if(nargin==6)
    ply = a./(1 + exp(-lambda*(plx-x0))) + ymin;
end

end

