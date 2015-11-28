function [complexs,s,n] = symbol_vec_gen(par)    

    % generate all combination of transmit vector s for QPSK
    n = length(par.symbols)^par.MT;     % Total number of possible transmit vector
    raw = de2bi(0:n-1,par.Q*par.MT,'left-msb');
    s = zeros(n,par.MT);
    for i=1:par.MT
        s(:,i) = bi2de(raw(:,2*i-1:2*i),'left-msb');
    end
    s = s';
    complexs = par.symbols(s+1);