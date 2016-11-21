function y = notch60(x)
%NOTCH60 Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.0 and the DSP System Toolbox 9.2.
% Generated on: 27-Oct-2016 22:29:51

persistent Hd;

if isempty(Hd)
    
    % IIR Notching filter designed using the IIRNOTCH function.
    
    % All frequency values are in Hz.
    Fs = 500;  % Sampling Frequency
    
    Fnotch = 60;  % Notch Frequency
    BW     = 2;   % Bandwidth
    Apass  = 5;   % Bandwidth Attenuation
    
    [b, a] = iirnotch(Fnotch/(Fs/2), BW/(Fs/2), Apass);Hd = dsp.IIRFilter( ...
        'Structure', 'Direct form II', ...
        'Numerator', b, ...
        'Denominator', a);
end

y = step(Hd,x);


% [EOF]