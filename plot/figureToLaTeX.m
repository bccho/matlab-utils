function [latex] = figureToLaTeX(fig, clip, fname, dir, absfpath)
%figureToLaTeX Exports figure (fig) to directory (dir) and outputs LaTeX
%code that will include that figure using the graphicx package. Uses name
%given by fname. Uses absolute file path if absfpath; otherwise returns
%only the filename.
%   fig:      figure handle
%   clip:     copy to clipboard if true, defaults to false
%   dir:      if not provided, assumes current working directory
%   fname:    if not provided, uses datetime stamp
%   absfpath: if not provided, assumes true
%Exports as PNG

if ~exist('clip', 'var') || isempty(clip)
    clip = false;
end

if ~exist('fname', 'var') || isempty(fname)
    fname = datestr(now);
    fname = strrep(fname, ' ', '');
    fname = strrep(fname, ':', '');
end

if ~exist('dir', 'var') || isempty(dir)
    dir = '';
    outdir = pwd;
else
    outdir = dir;
end

if ~exist('absfpath', 'var') || isempty(absfpath)
    absfpath = true;
end

print(fig, [dir, fname], '-dpng')

if absfpath
    outfile = [outdir, '/', fname, '.png'];
else
    outfile = [fname, '.png'];
end

latex = ['\includegraphics[width=0.8\textwidth]{', outfile, '}'];

if clip
    clipboard('copy', latex)
end

end

