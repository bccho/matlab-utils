% This code exports a matlab figure with fixed font size for embedding
% in a paper. To use, set IMAGE_WIDTH and IMAGE_HEIGHT to your desired
% values (in inches). Force your typesetting program to resize the image to
% those values, and everything should come out at the right size

IMAGE_WIDTH = 7;
IMAGE_HEIGHT = 3;
set(gcf, ...
    'PaperPosition', [0, 0, IMAGE_WIDTH, IMAGE_HEIGHT], ...
    'PaperSize', [IMAGE_WIDTH, IMAGE_HEIGHT]);
options.Units = 'inches';
options.Width = IMAGE_WIDTH;
options.Height = IMAGE_HEIGHT;
options.Resolution = 600;
options.FontMode = 'Fixed';
options.FixedFontSize = 10;
options.FontName = 'Input Sans';
options.Format = 'png';
hgexport(gcf, 'image.png', options);