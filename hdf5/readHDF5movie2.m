function [kin, pg, metadata] = readHDF5movie2(file, duration, startTime)
%READBINMOVIE2 Read an HDF5 movie from Kinect and Point Grey
% USAGE:
%   [kin, pg, metadata] = readHDF5movie2(file)
%   [kin, pg, metadata] = readHDF5movie2(file, duration)
%   [kin, pg, metadata] = readHDF5movie2(file, duration, startTime)
% INPUTS:
%   'file':         a struct containing the field "path".
%   'duration':     length of recordings to read (in seconds)
%   'startTime':    offset time from beginning of recording (in seconds)
% OUTPUTS:
%   'kin':          struct containing frames (movie matrix) and time
%   'pg':           cell array containing a struct for each Point Grey
%                   (similar to above)
%   'metadata':     struct containing metadata about number of Point Grey
%                   cameras, frame rates, and movie matrix dimensions
% Assumes HDF5 file contains attributes in '/' about number of Point Grey
% cameras and frame rates of Kinect and each Point Grey

t0 = tic;
%% Parse inputs

numPGcameras = h5readatt(file.path, '/', 'numPGcameras');

if nargin < 3 || isempty(startTime)
    startTime = 0;
end
if startTime < 0
    startTime = 0;
end

if nargin < 2 || isempty(duration)
    duration = -1; % To mark for separate handling
end

%% Read metadata
% Get frame rates
kinFrameRate = h5readatt(file.path, '/', 'kinFrameRate');
pgFrameRates = zeros(numPGcameras, 1);
for i = 1:numPGcameras
    pgFrameRates(i) = h5readatt(file.path, '/', ['pg',num2str(i-1),'FrameRate']);
end

% Get frame counts
fid = H5F.open(file.path);
kinDims = h5getdatasetdims(fid, '/kin_frames');
pgDims = cell(numPGcameras, 1);
for i = 1:numPGcameras
    pgDims{i} = h5getdatasetdims(fid, ['/pg',num2str(i-1),'_frames']);
end
H5F.close(fid);

metadata.numPGcameras = numPGcameras;
metadata.kinFrameRate = kinFrameRate;
metadata.pgFrameRates = pgFrameRates;
kinDims = fliplr(kinDims);
metadata.kinDims = kinDims;
pgDims = cellfun(@fliplr,pgDims,'UniformOutput',false);
metadata.pgDims = pgDims;

%% Calculate frame numbers

% Calculate numbers of frames
kinStartFrame = double(round(startTime * double(kinFrameRate) + 1));
pgStartFrames = double(round(startTime * double(pgFrameRates) + 1));
kinFrameCount = double(round(duration * double(kinFrameRate)));
pgFrameCounts = double(round(duration * double(pgFrameRates)));

% Handle duration not provided or invalid
if kinFrameCount + kinStartFrame - 1 > kinDims(4)
    kinFrameCount = inf;
end
for i = 1:numPGcameras
    if pgFrameCounts(i) + pgStartFrames(i) - 1 > pgDims{i}(4)
        pgFrameCounts(i) = inf;
    end
end
if duration < 0
    kinFrameCount = inf;
    pgFrameCounts = inf(size(pgFrameRates));
end

%% Read Kinect frames and timestamps
kin.frames = h5read(file.path, '/kin_frames', [1,1,1,kinStartFrame], [inf, inf, inf, kinFrameCount]);
kin.time = h5read(file.path, '/kin_time', [1,kinStartFrame], [1,kinFrameCount]);

kin.frames = double(kin.frames);

%% Read Point Grey frames and timestamps
if nargout > 1
    pg = cell(numPGcameras, 1);
    for i = 1:numPGcameras
        pg{i}.frames = h5read(file.path, ['/pg',num2str(i-1),'_frames'], [1,1,1,pgStartFrames(i)], [inf, inf, inf, pgFrameCounts(i)]);
        pg{i}.time = h5read(file.path, ['/pg',num2str(i-1),'_time'], [1,pgStartFrames(i)], [1,pgFrameCounts(i)]);
    end
end

fprintf('Read %.1f seconds of video [%.2fs].\n', size(kin.frames,4)/kinFrameRate, toc(t0))

%% Helper functions

    function dims = h5getdatasetdims(fid, dsetpath)
        dset = H5D.open(fid, dsetpath);
        space = H5D.get_space(dset);
        [~,dims] = H5S.get_simple_extent_dims(space);
        H5S.close(space);
        H5D.close(dset);
    end

end