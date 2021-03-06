function [] = HW6_Q2_2()

    %par.runId = 0; % simulation ID (used to reproduce results)
    %par.MR = 4; % receive antennas 
    %par.MT = 4; % transmit antennas (set not larger than MR!) 
    %par.mod = 'BPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    %par.SNRdB_list = -10:4:20; % list of SNR [dB] values to be simulated
    %par.trials = 100; % number of channel realizations
    %par.integral = 30; % number of Monte-Carlo integration samples
    %par.simName = [ 'P2CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %%cap_sim_fixthis(par);

    %par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    %par.simName = [ 'P2CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %%cap_sim_fixthis(par);
    %par.mod = '16QAM'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    %par.simName = [ 'P2CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    figure()
    hold on;
    load('P2CAP_4x4_BPSK_0.mat')
    plot(par.SNRdB_list,res.E_GCAP,'k*-','LineWidth',2)
    plot(par.SNRdB_list,res.E_DCAP,'bo-','LineWidth',2)
    load('P2CAP_4x4_QPSK_0.mat')
    plot(par.SNRdB_list,res.E_DCAP,'rs-','LineWidth',2)
    load('P2CAP_4x4_16QAM_0.mat')
    plot(par.SNRdB_list,res.E_DCAP,'m+-','LineWidth',2)
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('bits per channel use [bit/s/Hz]','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 20])
  legend('Capacity','BPSK-MAR','QPSK-MAR','16QAM-MAR',2)
  title('4x4 Maximum Achievable Rates')
  set(gca,'FontSize',13)
  hold off;
