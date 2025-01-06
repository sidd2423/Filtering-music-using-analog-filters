% Chebyshev Type I Filtering - Time Domain
clear; clc;

% Loading the noisy audio file
[audioSignal, sampleRate] = audioread('music_noisy.wav');

% Defining cutoff frequencies for noise bands
lowCut1 = 1081; highCut1 = 1126; % First interference band
lowCut2 = 2726; highCut2 = 2783; % Second interference band

% Filtering design parameters
ripple = 1; % Maximum ripple allowed in the passband (in dB)

% Designing Chebyshev Type I stop-band filters 
[b1, a1] = cheby1(4, ripple, [lowCut1, highCut1] / (sampleRate / 2), 'stop');
[b2, a2] = cheby1(4, ripple, [lowCut2, highCut2] / (sampleRate / 2), 'stop');

% Applying filters sequentially this helps us to address each noise band independently
filteredSignalCheby = filter(b1, a1, audioSignal);
filteredSignalCheby = filter(b2, a2, filteredSignalCheby);

% Save and play the filtered audio
audiowrite('cheby_filtered_audio.wav', filteredSignalCheby, sampleRate);
sound(filteredSignalCheby, sampleRate);

% Time and frequency domain analysis
signalLength = length(audioSignal);
timeVector = (0:signalLength-1) / sampleRate;

% Compute spectrum for noisy and filtered signals
audioFFT = fft(audioSignal);
filteredFFT = fft(filteredSignalCheby);

twoSidedSpectrumOriginal = abs(audioFFT / signalLength);
singleSidedSpectrumOriginal = twoSidedSpectrumOriginal(1:signalLength/2+1);
singleSidedSpectrumOriginal(2:end-1) = 2 * singleSidedSpectrumOriginal(2:end-1);

twoSidedSpectrumFiltered = abs(filteredFFT / signalLength);
singleSidedSpectrumFiltered = twoSidedSpectrumFiltered(1:signalLength/2+1);
singleSidedSpectrumFiltered(2:end-1) = 2 * singleSidedSpectrumFiltered(2:end-1);

frequencyVector = sampleRate * (0:(signalLength/2)) / signalLength;

% Plot the results
figure;

% Time domain
subplot(4, 1, 1);
plot(timeVector, audioSignal);
title('Noisy Signal - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 1, 2);
plot(timeVector, filteredSignalCheby);
title('Filtered Signal (Chebyshev Type I) - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Frequency domain
subplot(4, 1, 3);
plot(frequencyVector, singleSidedSpectrumOriginal);
title('Original Spectrum - Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(4, 1, 4);
plot(frequencyVector, singleSidedSpectrumFiltered);
title('Filtered Spectrum (Chebyshev Type I) - Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Spectrograms for Chebyshev filtering
figure;

% Noisy signal spectrogram
subplot(2, 1, 1);
spectrogram(audioSignal, 1024, 512, 1024, sampleRate, 'yaxis');
title('Spectrogram of Noisy Signal');
colorbar;

% Filtered signal spectrogram
subplot(2, 1, 2);
spectrogram(filteredSignalCheby, 1024, 512, 1024, sampleRate, 'yaxis');
title('Spectrogram of Filtered Signal (Chebyshev Type I)');
colorbar;