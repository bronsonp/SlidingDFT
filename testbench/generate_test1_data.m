%% Generate test data
FFT_Length = 64;
t = (0:(1/100):1.2)';
% FFT_Length = 8;
% t = linspace(0, 10, 16)';
v = 0.5*randn(size(t)) + 2*sin(2*pi*(0.1+t/0.07).*t);
plot(t, v)

% Calculate the FFT
s = zeros(numel(v) - FFT_Length, FFT_Length);
window = hanning(FFT_Length, 'periodic');
num_FFTs = numel(v) - FFT_Length + 1;
for i = 1:num_FFTs
   s(i, :) = fft(window .* v(i+(1:FFT_Length)-1));
end

% Plot the amplitude
figure()
surf(1:num_FFTs, 1:FFT_Length, (abs(s)'), 'LineStyle', 'none')
xlabel('time');
ylabel('freq');

%% Write the data file
fid = fopen('test1_data.h', 'wt');
% fid = 1;

fprintf(fid, 'static const size_t test1_FFT_LENGTH = %i;\n', FFT_Length);
fprintf(fid, 'static const size_t test1_TIME_LENGTH = %i;\n\n', numel(t));

fprintf(fid, 'static const unsigned long long test1_time_domain_data [test1_TIME_LENGTH] = {\n    ');
for i = 1:numel(v)
    fprintf(fid, '0x%s', num2hex(v(i)));
    if i < numel(v)
        fprintf(fid, ',');
    end
    if mod(i-1, 8) == 7
        fprintf(fid, '\n    ');
    end
end
fprintf(fid, '};\n');
fprintf(fid, 'static const double *test1_time_domain = (const double *)test1_time_domain_data;\n\n');

fprintf(fid, 'static const unsigned long long test1_dft_real_data [test1_TIME_LENGTH-test1_FFT_LENGTH+1][test1_FFT_LENGTH] = {\n');
for i = 1:num_FFTs
    fprintf(fid, '    { // time index = %i\n        ', i-1);
    for j = 1:FFT_Length
        fprintf(fid, '0x%s', num2hex(real(s(i, j))));
        if j < FFT_Length
            fprintf(fid, ',');
            if mod(j-1, 8) == 7
                fprintf(fid, '\n        ');
            end
        end
    end
    fprintf(fid, '\n    }');
    if i < num_FFTs
        fprintf(fid, ',');
    end
    fprintf(fid, '\n');
end
fprintf(fid, '};\n');
fprintf(fid, 'static const double (*test1_dft_real)[test1_FFT_LENGTH] = (const double (*)[test1_FFT_LENGTH])test1_dft_real_data;\n\n');

fprintf(fid, 'static const unsigned long long test1_dft_imag_data [test1_TIME_LENGTH-test1_FFT_LENGTH+1][test1_FFT_LENGTH] = {\n');
for i = 1:num_FFTs
    fprintf(fid, '    { // time index = %i\n        ', i-1);
    for j = 1:FFT_Length
        fprintf(fid, '0x%s', num2hex(imag(s(i, j))));
        if j < FFT_Length
            fprintf(fid, ',');
            if mod(j-1, 8) == 7
                fprintf(fid, '\n        ');
            end
        end
    end
    fprintf(fid, '\n    }');
    if i < num_FFTs
        fprintf(fid, ',');
    end
    fprintf(fid, '\n');
end
fprintf(fid, '};\n');
fprintf(fid, 'static const double (*test1_dft_imag)[test1_FFT_LENGTH] = (const double (*)[test1_FFT_LENGTH])test1_dft_imag_data;\n\n');

fclose(fid);
