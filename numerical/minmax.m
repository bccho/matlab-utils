function [minout, maxout] = minmax(data)

minout = min(data(:));
maxout = max(data(:));

if nargout < 1
    fprintf('Min: %f, Max: %f\n', minout, maxout)
end