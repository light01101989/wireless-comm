function Es = signal_energy(M)

sym = baseline_symbols(M);
Es = 1/M*(sum(abs(sym).^2));