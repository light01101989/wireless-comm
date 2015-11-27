%% ECE 5680 - Wireless Communication
%% HW2: Ques 3
%% Author: Arjun Jauhari
%% Email/Netid: aj526
%% Date: 09/24/2015
%% Monte-Carlo simulation for estimating SER(Symbol Error rate) of QPSK and BPSK in AWGN complex(I/Q) noise

function SER = HW2_Q3()
SNR_db = -10:20;  % Sweeping over SNR of -10dB to 20dB
SNR = 10.^(SNR_db/10);
sd_qpsk = sqrt(2./SNR);   % Standard Deviation
sd_bpsk = sqrt(1./SNR);   % Standard Deviation

% Number of Monte carlo iteration
T = 10000;

%% STEP 1 OF MONTE CARLO SIMULATION
%% Generating transmit data
S_qpsk = [1+1i 1-1i -1+1i -1-1i];    %%QPSK
x_qpsk = S_qpsk(randi([1 4], 1, T));
x_bpsk = sign(randn(1,T));

noise = zeros(1,T);
x_hat = zeros(1,T);
SER = zeros(2,length(SNR_db));
y(length(SNR_db),T) = 0;
for m=1:2
    if m == 1
        x = x_qpsk;
        sd = sd_qpsk;
    else
        x = x_bpsk;
        sd = sd_bpsk;
    end
for k = 1:length(sd)
  %%STEP 2 OF M-C SIMULATION
  % Generating RANDOM NOISE WITH MEAN 0 AND VARIANCE VAR == sd^2
  noise = (1/sqrt(2))*sd(1,k)*randn(1,T) + 1i*(1/sqrt(2))*sd(1,k)*randn(1,T);

  %%STEP 3 OF M-C SIMULATION
  %% RECEIVED SIGNAL ACCORDING TO RELATION y = x + n
  y = x + noise;

  %% STEP 4 OF M-C SIMULATION
  %% Using the detector threshold to do detection and get x_hat
  if m == 1
      x_hat = sign(real(y)) + 1i*sign(imag(y));
  else
      x_hat = sign(real(y));
  end

  %% STEP 5 OF M-C SIMULATION
  %% Evaluate I and calculate SER
  SER(m,k) = mean(x_hat~=x);

end
end

%figure(1)
%plot(abs(y(1,:)))
%plot(real(y(30,:)),imag(y(30,:)),'o')
%%PLOTTING
figure(1)
semilogy(SNR_db,SER(1,:),'bo-',SNR_db,SER(2,:),'ko-')
grid on
axis([-10 20 1e-6 1])
xlabel('signal-to-noise ratio (SNR) [dB]')
ylabel('symbol error rate (SER)')
%legend('QPSK SER', 'BPSK SER')

hold on

%%calculation SER from analytical equation
%SER_calc = 0.5*erfc(sqrt(SNR./2));
%SER_calc = erfc(sqrt(SNR./2));
SER_calc = 2*qfunc(sqrt(SNR)) - qfunc(sqrt(SNR)).^2;
semilogy(SNR_db,SER_calc,'ro-')
legend('QPSK SER', 'BPSK SER', 'analytical SER')
