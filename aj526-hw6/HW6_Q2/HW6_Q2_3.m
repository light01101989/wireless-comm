function [] = HW6_Q2_3()


    %par.runId = 0; % simulation ID (used to reproduce results)
    %par.MR = 1; % receive antennas 
    %par.MT = 1; % transmit antennas (set not larger than MR!) 
    %par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    %par.SNRdB_list = -10:4:20; % list of SNR [dB] values to be simulated
    %par.trials = 200; % number of channel realizations
    %par.integral = 200; % number of Monte-Carlo integration samples
    %par.simName = [ 'P3CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    %par.MR = 4; % receive antennas 
    %par.MT = 1; % transmit antennas (set not larger than MR!) 
    %par.simName = [ 'P3CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    %par.MR = 1; % receive antennas 
    %par.MT = 4; % transmit antennas (set not larger than MR!) 
    %par.simName = [ 'P3CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);

    %par.MR = 4; % receive antennas 
    %par.MT = 4; % transmit antennas (set not larger than MR!) 
    %par.simName = [ 'P3CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
    %cap_sim_fixthis(par);



    figure()
    hold on;

   load('P3CAP_1x1_QPSK_0.mat')
   plot(par.SNRdB_list,res.CG_epsout,'bo-','LineWidth',2)
   load('P3CAP_4x1_QPSK_0.mat')
   plot(par.SNRdB_list,res.CG_epsout,'rs-','LineWidth',2)
   load('P3CAP_1x4_QPSK_0.mat')
   plot(par.SNRdB_list,res.CG_epsout,'m+-','LineWidth',2)
   load('P3CAP_4x4_QPSK_0.mat')
   plot(par.SNRdB_list,res.CG_epsout,'k*-','LineWidth',2)
 grid on
 xlabel('average SNR per receive antenna [dB]','FontSize',12)
 ylabel('bits per channel use [bit/s/Hz]','FontSize',12)
 axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 10])
 legend('1x1','4x1','1x4','4x4',2)
 title('eps-outage Capacity')
 set(gca,'FontSize',13)
 hold off;
 print('-depsc','HW6_Q2_31.eps')
 close all

%     par.runId = 0; % simulation ID (used to reproduce results)
%     par.MR = 4; % receive antennas 
%     par.MT = 4; % transmit antennas (set not larger than MR!) 
%     par.mod = 'BPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
%     par.SNRdB_list = -10:4:20; % list of SNR [dB] values to be simulated
%     par.trials = 100; % number of channel realizations
%     par.integral = 30; % number of Monte-Carlo integration samples
%     par.simName = [ 'P33CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
%     cap_sim_fixthis(par);
% 
%     par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
%     par.simName = [ 'P33CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
%     cap_sim_fixthis(par);
%     par.mod = '16QAM'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
%     par.simName = [ 'P33CAP_' num2str(par.MR) 'x' num2str(par.MT) '_' par.mod ]; % simulation name (used for saving results)
%     %cap_sim_fixthis(par);

    figure()
    hold on;
    load('P33CAP_4x4_BPSK_0.mat')
    plot(par.SNRdB_list,res.CG_epsout,'k*-','LineWidth',2)
    plot(par.SNRdB_list,res.CD_epsout,'bo-','LineWidth',2)
    load('P33CAP_4x4_QPSK_0.mat')
    plot(par.SNRdB_list,res.CD_epsout,'rs-','LineWidth',2)
    load('P33CAP_4x4_16QAM_0.mat')
    plot(par.SNRdB_list,res.CD_epsout,'m+-','LineWidth',2)
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('bits per channel use [bit/s/Hz]','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 0 20])
  legend('Capacity','BPSK-MAR','QPSK-MAR','16QAM-MAR',2)
  title('epsilon-outage:4x4 Maximum Achievable Rates')
  set(gca,'FontSize',13)
  hold off;
 print('-depsc','HW6_Q2_32.eps')