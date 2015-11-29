function [idxhat,bithat,z,beta] = mgs(par,H,y,x0,N0)
    
    H = [real(H) -imag(H);imag(H) real(H)];
    y = [real(y);imag(y)];
    x0 = [real(x0);imag(x0)];
    offset = y'*y;

    % Intializing constants
    MAXITER = 8*par.MT*sqrt(2^par.Q);
    q = 1/(2*par.MT);
    beta = costFn(x0,H,y,offset);
    z = x0;
    x1 = x0;
    t = 1;
    betavec(t) = beta;
    
    %
    rsym = unique(real(par.symbols));
    
    % Main loop
    while t <= MAXITER
        for i = 1:2*par.MT
            rk = rand();
            if (rk > q)
                for r = 1:length(rsym)
                    x1(i) = rsym(r);
                    costvec(r) = costFn(x1,H,y,offset);
                end
                [~,idx] = min(costvec);
                x1(i) = rsym(idx);
            else
                x1(i) = rsym(randi([1 length(rsym)],1,1));
            end
        end
        gamma = costFn(x1,H,y,offset);
        cf(t) = gamma;
        if (gamma <= beta)
            z = x1;
            beta = gamma;
        end
        t = t+1;
        betavec(t) = beta;
        if betavec(t) == betavec(t-1)
            t_stall = floor(stallFn(z,H,y,par,offset,N0));
            if t_stall < t
                if betavec(t) == betavec(t-t_stall)
                    break;
                end
            end
        end
    end
    xhat = z(1:par.MT) + 1i.*z(par.MT+1:end);

    [~,idxhat] = max(bsxfun(@eq,xhat,par.symbols),[],2);
    bithat = par.bits(idxhat,:);
    %plot(cf);
end


function [cost] = costFn(x,H,y,offset)
    cost = x'*H'*H*x - 2*y'*H*x + offset;
end

function [theta] = stallFn(x,H,y,par,offset,N0)
    c1=10*par.Q;
    %standMLcost = (costFn(x,H,y,offset) - par.MR*(par.sigmak).^2)/(sqrt(par.MR)*(par.sigmak).^2);
    standMLcost = (costFn(x,H,y,offset) - par.MR*N0)/(sqrt(par.MR)*N0);
    theta = max(par.cmin,c1*exp(standMLcost));
end
