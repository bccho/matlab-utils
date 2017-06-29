function savevidsc(filename, I, fps, clims, cmap)
%SAVEVIDSC Save out video using imagesc

%% Arguments
assert(nargin > 1)
I = double(I);

if nargin < 3 || isempty(fps) || fps <= 0
    fps = 30;
end
if nargin < 4 || isempty(clims)
    clims = [min(I(:)), max(I(:))];
end
if nargin < 5 || isempty(cmap)
    cmap = 'parula';
end

assert(ndims(I) == 4)
assert(size(I, 3) == 1)

%% Set up video output
nFrames = size(I, 4);

f = figure;%('Visible', 'off');
h_img = imagesc(I(:,:,:,1));
axis off
caxis(clims)
colormap(cmap)

v = VideoWriter(filename, 'Motion JPEG AVI');
v.FrameRate = fps;
open(v)

%% Write frames to video
try
    h = waitbar(0, sprintf('Saving frame %d/%d...', 1, nFrames));
    for t = 1:nFrames
        waitbar(t/nFrames, h, sprintf('Saving frame %d/%d...', t, nFrames));
        h_img.CData = I(:,:,:,t);
        drawnow;
        writeVideo(v, getframe(f))
    end
catch ME
end

try
    close(h)
catch
end
close(f)
close(v)

rethrow(ME)

end

