function bwcc = bwLargestCC(bw)
%BWLARGESTCC Returns binary image of largest connected component
%   Input:  bw   = binary image
%   Output: bwcc = binary image of same size as bw with only the
%                  connected commponent with the largest area
% Byung-Cheol Cho, 2017

stats = regionprops(bw, 'PixelIdxList', 'Area');
[~, maxind] = max(cat(1, stats.Area));
bwcc = false(size(bw));
bwcc(stats(maxind).PixelIdxList) = true;

end