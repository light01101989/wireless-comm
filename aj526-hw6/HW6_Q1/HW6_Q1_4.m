%% ECE 5680 - Wireless Communication
%% HW6: Ques 1_4
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 11/24/2015
%% Maximum Achievable Rate (MAR)for various rates in SISO AWGN channel

function [I_xy,legendtext] = HW6_Q1_4(mod,SNR_db,splot)
%description:
%
% Input:
%
% Output:
%
% Plot:
%

% Number of Monte carlo iteration
T = 10000;
%T = 10;

if ~exist('splot','var')
    splot = 0;
end

if ~exist('SNR_db','var')
    SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
end
SNR = 10.^(SNR_db/10);

switch mod
    case 'bpsk'
        M = 2;
    case 'qpsk'
        M = 4;
    case '16qam'
        M = 16;
    case '64qam'
        M = 64;
    case '8psk'
        M = 8;
    otherwise
        cons = {'bpsk','qpsk','16qam','64qam'};
        M = [2,4,16,64];
        %cons = {'qpsk','16qam','64qam'};
        %M = [4,16,64];
end

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
for k=1:length(M)
    sd_noise = sqrt(signal_energy(M(k))./SNR);   % Standard Deviation of noise
    bitspsym = log2(M(k));      %bits per symbol
    n = T*bitspsym;             %number of bits to generate
    bitsIn = randi([0 1],n,1);  %input bits nx1
    bsymIn = reshape(bitsIn,length(bitsIn)/bitspsym,bitspsym);  %matrix form one row per sym
    symIn = bi2de(bsymIn);      %sym in decimal
    if M(k) == 8
        sym(k,:) = pskmod(symIn,M(k),0,'gray'); %gray mod
    else
        %sym(k,:) = qammod(symIn,M(k),0,'gray'); %gray mod
        sym(k,:) = qammod(symIn,M(k)); %gray mod % row vector
    end

    for i = 1:length(sd_noise)
        %%STEP 2 OF M-C SIMULATION
        % Generating RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR == sd^2
        noise = (1/sqrt(2))*sd_noise(1,i)*randn(1,T) + 1i*(1/sqrt(2))*sd_noise(1,i)*randn(1,T);

        %%STEP 3 OF M-C SIMULATION
        %% RECEIVED SIGNAL ACCORDING TO RELATION y = x + n
        y = sym(k,:) + noise;

        %% Probability of y given x
        p_ygx = exp(-(abs(y - sym(k,:)).^2)./(sd_noise(1,i).^2));

        %% Probability of y
        p_y = zeros(1,T);
        bl_sym = baseline_symbols(M(k));
        for r=1:length(bl_sym)
            p_y = p_y + exp(-(abs(y - bl_sym(r)).^2)./(sd_noise(1,i).^2));
        end
        p_y = p_y/length(bl_sym);

        I_xy(k,i) = mean(log2(p_ygx./p_y));
    end
end

if ~exist('cons','var')
    legendtext = ['MAR-' mod];
else
    legendtext = [strcat('MAR-', cons)];
end
if (splot)
    [r,c] = size(I_xy);
    for p=1:r
        plot(SNR_db,I_xy(p,:),'*-')
        hold all
    end
    grid on
    xlabel('signal-to-noise ratio (SNR) [dB]')
    ylabel('Max Achievable Rate [bits/s/Hz]')
    title('AWGN MAR for various modulations')
    legend(legendtext);
end
