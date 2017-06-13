function [adv,tdv] = allan_deviation(data,Fs,plt)
%Fs = sampling rate
if nargin < 3 || isempty(plt)
    plt = 1;
end
len = length(data); % length of data set
max_tau = floor(len/2);
avar = zeros(1,max_tau);
%==========================================================================
for i = 1:max_tau
    sec_avg = [];                   % section average

    for j = 1:floor(len/i)
        sec_avg(j) = mean( data( ((j-1)*i+1) : (j*i) ) );
    end
    sec_diff = diff(sec_avg); % difference between two neighboring sections
    sec_diff_sqrd = sec_diff.^2; % squared section difference
    avar(i) = (0.5) * mean(sec_diff_sqrd); % allan variance
end
tdv = (1:max_tau)/Fs; % integration time vector
adv = sqrt(avar); % allan deviation

%==========================================================================
if plt == 1
    %---------------------------------------------------
    figure;
    hold on; box on; grid on;
    plot(tdv,adv,'linewidth',1.5);
    set(gca,'Xscale','log');
    set(gca,'Yscale','log');
    %---------------------------------------------------
end
%==========================================================================
end