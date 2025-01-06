% FFT Method - Frequency Domain

% Load the noisy music file
[audioSignal, sampleRate] = audioread('music_noisy.wav');

% Apply Fourier Transform
audioFFT = fft(audioSignal);
signalLength = length(audioSignal);

% Frequency vector
frequencyVector = sampleRate * (0:(signalLength/2)) / signalLength;

% calculating single-sided amplitude spectrum
twoSidedSpectrum = abs(audioFFT / signalLength);
singleSidedSpectrum = twoSidedSpectrum(1:signalLength/2+1);
singleSidedSpectrum(2:end-1) = 2 * singleSidedSpectrum(2:end-1);

% Plot the original spectrum
figure;
subplot(4, 1, 1);
plot(frequencyVector, singleSidedSpectrum);
title('Original Spectrum - Before Filtering');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Identify interference frequencies and define width
interferenceFrequencies = [1102.48, 2756.26]; % Adjust these based on visual inspection
filterWidth = 10; % Frequency width around interference to filter out

% Suppress interference frequencies
for freqIdx = 1:length(interferenceFrequencies)
    centerFrequency = interferenceFrequencies(freqIdx);
    
    % Identify indices in the frequency domain to zero out
    targetIndices = frequencyVector > centerFrequency - filterWidth & ...
                    frequencyVector < centerFrequency + filterWidth;
    audioFFT(targetIndices) = 0;

    % Handle negative frequencies (mirrored indices in FFT)
    mirroredIndices = length(audioFFT) - find(targetIndices) + 1;
    audioFFT(mirroredIndices) = 0;
end

% Apply Inverse Fourier Transform
filteredSignalFFT = ifft(audioFFT, 'symmetric');

% Computing and plot the spectrum after filtering
filteredSpectrum = abs(audioFFT / signalLength);
filteredSingleSided = filteredSpectrum(1:signalLength/2+1);
filteredSingleSided(2:end-1) = 2 * filteredSingleSided(2:end-1);

subplot(4, 1, 2);
plot(frequencyVector, filteredSingleSided);
title('Filtered Spectrum - After Filtering');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Saving and playing the filtered audio
audiowrite('FFT_filtered_audio.wav', filteredSignalFFT, sampleRate);
sound(filteredSignalFFT, sampleRate);

% Plot amplitude vs. time for noisy and filtered signals
timeVector = (0:signalLength-1) / sampleRate;

subplot(4, 1, 3);
plot(timeVector, audioSignal);
title('Noisy Signal - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4, 1, 4);
plot(timeVector, filteredSignalFFT);
title('Filtered Signal - Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Spectrograms
figure;

% Noisy signal spectrogram
subplot(2, 1, 1);
spectrogram(audioSignal, 1024, 512, 1024, sampleRate, 'yaxis');
title('Spectrogram of Noisy Signal');
colorbar;

% Filtered signal spectrogram
subplot(2, 1, 2);
spectrogram(filteredSignalFFT, 1024, 512, 1024, sampleRate, 'yaxis');
title('Spectrogram of Filtered Signal');
colorbar;