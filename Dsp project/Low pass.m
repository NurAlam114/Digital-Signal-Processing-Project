clear all;
close all;
clc;

% Step 1: Loading the noisy sound file
[noisySound, Fs] = audioread('final_sample_noisy_sound.wav');

% Step 2: Plotting Time Domain and Frequency Domain of the Original Sound
% Creating time vector for time domain plotting
N = length(noisySound);
t = (0:N-1) / Fs;

% Computing the FFT for frequency-domain representation
NFFT = 2^nextpow2(N);                       % Find the next power of 2 for efficient FFT computation
fftSignal = fft(noisySound, NFFT);
magSpectrum = abs(fftSignal(1:NFFT/2+1));   % One-sided magnitude spectrum
freqAxis = Fs * (0:(NFFT/2)) / NFFT;        % Frequency axis

% Plotting noisy sound in the Time Domain
subplot(4, 1, 1);
plot(t, noisySound, 'b');
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain: Noisy Sound');
grid on;

% Plotting noisy sound in the Frequency Domain
subplot(4, 1, 2);
plot(freqAxis, magSpectrum, 'r');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Domain: Noisy Sound');
grid on;

% Step 3: Developing a lowpass filter that cuts off above a certain frequencies
% Designing an 64th order lowpass IIR filter with a cutoff of 4600 Hz.
lowpass_filter = designfilt('lowpassiir', 'FilterOrder', 64, 'HalfPowerFrequency', 4600, 'SampleRate', Fs);

% Applying the filter to the noisy sound
cleanSound = filter(lowpass_filter, noisySound);

% Step 4: Plotting the clean sound in both domains.
% Computing the FFT for frequency-domain representation
NFFT = 2^nextpow2(N);                  
fftClean = fft(cleanSound, NFFT);
magClean = abs(fftClean(1:NFFT/2+1));  
freqAxis = Fs * (0:(NFFT/2)) / NFFT;    

% Plotting clean sound in the Time Domain
subplot(4, 1, 3);
plot(t, cleanSound, 'g');
xlabel('Time (s)');
ylabel('Amplitude');
title('Time Domain: Clean Sound');
grid on;

% Plotting clean sound in the Frequency Domain
subplot(4, 1, 4);
plot(freqAxis, magClean, 'm');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Domain: Clean Sound');
grid on;

% Step 5: Comparring both noisy and the clean sound
compare = [noisySound; cleanSound];
sound(compare, Fs)