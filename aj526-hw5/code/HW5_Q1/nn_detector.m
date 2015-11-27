function x_hat = nn_detector(M,recv)

sym = baseline_symbols(M);

sym_vec = [real(sym);imag(sym)];    %becomes 2xM
recv_vec = [real(recv);imag(recv)]; %becomes 2xT

D = l2distance(sym_vec,recv_vec);   %returns MxT matrix with pairwise euclidean distances
[~, i_min] = min(D,[],1);    %returns row vector with minimums

x_hat = sym(i_min);

