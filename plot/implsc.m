function implsc(I, fps, clims, cmap)
%IMPLSC implay using imagesc

%% Arguments
assert(nargin > 0)
I = double(I);

if nargin < 2 || isempty(fps) || fps <= 0
    fps = 30;
end
if nargin < 3 || isempty(clims)
    clims = [min(I(:)), max(I(:))];
end
if nargin < 4 || isempty(cmap)
    cmap = 'parula';
end

assert(ndims(I) == 4)
assert(size(I, 3) == 1)

%% Variables
% For video playback
nFrames = size(I, 4);
t = 1;
playing = false;

play_timer = timer('TimerFcn', @timer_callback, ...
    'ExecutionMode', 'fixedRate', ...
    'Period', round(1 / double(fps), 3));

%% Constants
% For GUI
text_height = 15;
btn_height = 25;
btn_width = 50;
fig_margin = 15;
comp_sep = 10;
img_width = 400;
img_height = 400;

%% Initialization
% Create window UI
fig_width = img_width+fig_margin*2;
fig_height = img_height+fig_margin*2+btn_height+comp_sep;
f = figure('Visible', 'off', 'Resize', 'off', ...
    'Position', [0, 0, fig_width, fig_height], ...
    'NumberTitle', 'off', ...
    'Name', 'Scaled video GUI', ...
    'WindowKeyPressFcn', @keypress_callback);

% Construct components
h_ax = axes('Units', 'Pixels', ...
    'XTick', [], 'YTick', [], ...
    'Position', [fig_margin, comp_sep + btn_height + fig_margin, img_width, img_height]);
h_img = imagesc(h_ax, I(:,:,:,1));
caxis([-40, 160])
h_btn_left = uicontrol('Style', 'pushbutton', ...
    'String', '<', ...
    'Position', [fig_margin, fig_margin, btn_width, btn_height], ...
    'Callback', @btnleft_callback);
h_btn_right = uicontrol('Style', 'pushbutton', ...
    'String', '>', ...
    'Position', [fig_margin + img_width - btn_width*2 - comp_sep, fig_margin, btn_width, btn_height], ...
    'Callback', @btnright_callback);
h_btn_playpause = uicontrol('Style', 'togglebutton', ...
    'String', 'Play', ...
    'Position', [fig_margin + img_width - btn_width, fig_margin, btn_width, btn_height], ...
    'Callback', @btnplaypause_callback);
h_lbl_frame_num = uicontrol('Style', 'text', ...
    'String', 'Frame ', ...
    'HorizontalAlignment', 'right', ...
    'Position', [fig_margin + btn_width + comp_sep, fig_margin + (btn_height - text_height)/2, btn_width, text_height]);
h_edit_frame_num = uicontrol('Style', 'edit', ...
    'String', num2str(t), ...
    'HorizontalAlignment', 'left', ...
    'Position', [fig_margin + btn_width + comp_sep + btn_width, fig_margin, btn_width, btn_height], ...
    'Callback', @framenum_callback);
h_lbl_frame_total = uicontrol('Style', 'text', ...
    'String', sprintf(' of %d', nFrames), ...
    'HorizontalAlignment', 'left', ...
    'Position', [fig_margin + btn_width + comp_sep + btn_width*2, fig_margin + (btn_height - text_height)/2, btn_width*2, text_height]);

%% Show
movegui(f, 'center')
showFrame(t)
axis off
caxis(clims)
colormap(cmap)
f.Visible = 'on';

%% Helper functions
% Show frame
    function showFrame(ind)
        t = ind;
        % Update image
        h_img.CData = I(:,:,:,t);
        % Update GUI
        updateGUI
    end
% Update GUI
    function updateGUI
        h_edit_frame_num.String = num2str(t);
        % Left/right button enables
        if t > 1
            h_btn_left.Enable = 'on';
        else
            h_btn_left.Enable = 'off';
        end
        if t < nFrames
            h_btn_right.Enable = 'on';
        else
            h_btn_right.Enable = 'off';
        end
    end

%% Other callbacks
% Timer callback
    function timer_callback(src, event)
        if t < nFrames
            showFrame(t+1)
        else
            playing = false;
            stop(play_timer)
        end
    end
% Figure keypress callback
    function keypress_callback(src, event)
        switch event.Key
            case 'space'
                btnplaypause_callback(src, event)
            case 'leftarrow'
                btnleft_callback(src, event)
            case 'rightarrow'
                btnright_callback(src, event)
            otherwise
        end
    end

%% Component callbacks
    function btnleft_callback(src, event)
        if t > 1
            showFrame(t-1)
        end
    end
    function btnright_callback(src, event)
        if t < nFrames
            showFrame(t+1)
        end
    end
    function btnplaypause_callback(src, event)
        if playing
            playing = false;
            stop(play_timer)
            h_btn_playpause.String = 'Play';
            h_btn_playpause.Value = h_btn_playpause.Min;
        else
            if t == nFrames
                t = 1;
            end
            playing = true;
            start(play_timer)
            h_btn_playpause.String = 'Pause';
            h_btn_playpause.Value = h_btn_playpause.Max;
        end
    end
    function framenum_callback(src, event)
        val = str2double(h_edit_frame_num.String);
        if isnan(val)
            h_edit_frame_num.String = num2str(t);
        else
            t = val;
            showFrame(t)
        end
    end
end

