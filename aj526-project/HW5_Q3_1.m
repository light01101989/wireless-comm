function [] = HW5_Q3_1()    

    % set simulation parameters 
    par.simName = 'HW5_Q3_1_2x2_QPSK'; % simulation name (used for saving results)
    par.runId = 0; % simulation ID (used to reproduce results)
    par.MR = 2; % receive antennas 
    par.MT = 2; % transmit antennas (set not larger than MR!) 
    par.mod = 'QPSK'; % modulation type: 'BPSK','QPSK','16QAM','64QAM'
    par.trials = 10000; % number of Monte-Carlo trials (transmissions)
    par.SNRdB_list = 10:1:40; % list of SNR [dB] values to be simulated
    par.detector = {'ZF','bMMSE','ML'}; % define detector(s) to be simulated  
    par.algotime = 0; % calculate individual detector algo time: can only be used if one detector specified
    
    simpleMIMOsim(par);
   