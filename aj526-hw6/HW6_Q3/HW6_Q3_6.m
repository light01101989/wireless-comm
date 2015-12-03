function [] = HW6_Q3_6()    

    % set simulation parameters 
    par.simName = 'HW6_Q3_6_4x4_16QAM_complexity'; % simulation name (used for saving results)
    par.runId = 0; % simulation ID (used to reproduce results)
    par.MR = 4; % receive antennas 
    par.MT = 4; % transmit antennas (set not larger than MR!) 
    par.mod = '16QAM'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    par.trials = 1; % number of Monte-Carlo trials (transmissions)
    par.SNRdB_list = 40:41; % list of SNR [dB] values to be simulated
    %par.detector = {'ZF','ZF-comp'}; % define detector(s) to be simulated  
    par.detector = {'ZF-comp'}; % define detector(s) to be simulated  
    par.algotime = 0; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);
   