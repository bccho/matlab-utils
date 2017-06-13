function [x, y] = findXY(bin)
% findXY: same as find, but returns x,y coordinates instead of indices

[x,y] = ind2sub(size(bin), find(bin));

end