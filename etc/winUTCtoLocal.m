function local = winUTCtoLocal(winutc, utcoffset, format)
%winUTCtoLocal: Converts Windows timestamp format to other local time formats
%   Windows UTC is a floating point number of seconds since Jan 1, 1601
% Inputs:
%   winutc:     Windows UTC timestamp
%   utcoffset:  Offset of local time from UTC. Use utcoffset = 0 for regular UTC
%   format:     Output format. Can be any of the following:
%       'string' (default): string-formatted date-time
%                           (format: yyyy-mm-dd HH:MM:SS.FFF)
%       'datenum':          MATLAB's datenum format (floating point number of
%                           days since Jan 1, 0000)
%       'datevec':          MATLAB's datevec format (MATLAB vector with format
%                           [year, month, day, hours, minutes, seconds])
% Written by Byung-Cheol Cho July 2, 2017

% Default arguments
if nargin < 3 || isempty(format)
    format = 'string';
end

local_datenum = datenum([1601, 1, 1, utcoffset, 0, winutc]);

switch format
case 'string'
    local = datestr(local_datenum, 'yyyy-mm-dd HH:MM:SS.FFF');
case 'datenum'
    local = local_datenum;
case 'datevec'
    local = datevec(local_datenum);
otherwise
    local = [];
end

end
