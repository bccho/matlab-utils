function mask = ellipseMask(imsize, x0, y0, a, b, ang)
% ellipseMask: Make mask of ellipse
% Inputs:
%   imsize: array with 2 elements for width and height of output mask
%   x0, y0: x and y position of ellipse center
%   a:      semi-major axis length
%   b:      semi-minor axis length
%   ang:    angle of semi-major axis (in degrees) CCW from x axis
%
% Hastily coded by Byung-Cheol Cho, February 2017

%% check arguments
narginchk(6, 6)
assert(numel(imsize) == 2)

%% prepare mask
w = imsize(1);
h = imsize(2);
[X, Y] = meshgrid(1:w, 1:h);

% rotate grid
t = -ang;
Xr = (X-x0)*cosd(t) + (Y-y0)*sind(t);
Yr = -(X-x0)*sind(t) + (Y-y0)*cosd(t);

%% make mask
mask = (Xr.^2 ./ a^2 + Yr.^2 ./ b^2 <= 1)';

end