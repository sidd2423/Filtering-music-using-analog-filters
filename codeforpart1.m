F = [500, 1500, 2000, 3000]; % Frequency edges in Hz
A = [0, 1, 0]; % amplitudes at passband and stopbands
Dev = [0.01, 0.01, 0.001]; % Stopband ripple from 0 to 500 Hz and 3000 to 4000 Hz,passband ripple
Fs = 8000; % Sampling frequency in Hz
% Estimating the filter order, normalized frequencies, amplitudes, and weights
[N, Fin, Ain, W] = firpmord(F, A, Dev, Fs);
% Designing the filter using the Parks-McClellan algorithm
h = firpm(N, Fin, Ain, W);% filter coefficient
figure;
freqz(h, 1); % Plot frequency response 
title('Frequency Response of the Designed Bandpass FIR Filter');
% Output filter length and coefficients
disp(['The filter length : ', num2str(length(h))]);
disp('filter coefficients :');
fprintf('%.4f ', h);