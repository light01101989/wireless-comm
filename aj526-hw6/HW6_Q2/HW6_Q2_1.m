function [] = HW6_Q2_1()


    %par.runId = 0; % simulation ID (used to reproduce results)
    %par.MR = 1; % receive antennas 
    %par.MT = 1; % transmit antennas (set not larger than MR!) 
    %par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    %par.SNRdB_list = -10:4:20; % list of SNR [dB] values to be simulated
    %par.trials = 200; % number of channel realizations
    %par.integral = 200; % number of Monte-Carlo integration samples
    %par.simName = [ 'P1CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    %par.MR = 4; % receive antennas 
    %par.MT = 1; % transmit antennas (set not larger than MR!) 
    %par.simName = [ 'P1CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    %par.MR = 1; % receive antennas 
    %par.MT = 4; % transmit antennas (set not larger than MR!) 
    %par.simName = [ 'P1CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    %par.MR = 4; % receive antennas 
    %par.MT = 4; % transmit antennas (set not larger than MR!) 
    %par.simName = [ 'P1CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);


    figure()
    hold on;
    load('P1CAP_1x1_QPSK_0.mat')
    plot(par.SNRdB_list,res.E_GCAP,'bo-','LineWidth',2)
    load('P1CAP_4x1_QPSK_0.mat')
    plot(par.SNRdB_list,res.E_GCAP,'rs-','LineWidth',2)
    load('P1CAP_1x4_QPSK_0.mat')
    plot(par.SNRdB_list,res.E_GCAP,'m+-','LineWidth',2)
    load('P1CAP_4x4_QPSK_0.mat')
    plot(par.SNRdB_list,res.E_GCAP,'k*-','LineWidth',2)
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('bits per channel use [bit/s/Hz]','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 10])
  legend('1x1','4x1','1x4','4x4',2)
  title('Ergodic Capacity')
  set(gca,'FontSize',13)
  hold off;
