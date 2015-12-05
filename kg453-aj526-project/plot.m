 marker_style = {'bo-','rs--','mv-.','kp:','g*-','c>--','yx:'};
  figure(1)
  for d=1:length(par.detector)
    if d==1
      semilogy(par.SNRdB_list,res.BER(d,:),marker_style{d},'LineWidth',2)
      hold on
    else
      semilogy(par.SNRdB_list,res.BER(d,:),marker_style{d},'LineWidth',2)
    end
  end
  
  hold on
  hold off
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('bit error rate (BER)','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 1e-6 1])
  legend(par.detector,'FontSize',18)
%   legend(sprintf('%s\n%s','MGS','MT=16,MR=16 with 16-QAM'))
  set(gca,'FontSize',18)
  figure(2)
  semilogy(par.SNRdB_list,res.comp(1,:),marker_style{1},'LineWidth',2)
  hold on 
  semilogy(par.SNRdB_list,res.comp(2,:),marker_style{2},'LineWidth',2)
  grid on
  xlabel('average SNR per receive antenna [dB]','FontSize',12)
  ylabel('Real Computations','FontSize',12)
  axis([min(par.SNRdB_list) max(par.SNRdB_list) 1e6 1e09])
%   legend(sprintf('%s\n%s','MGS','MT=16,MR=16 with QPSK'))
  legend(par.detector,'FontSize',18)
  set(gca,'FontSize',18)