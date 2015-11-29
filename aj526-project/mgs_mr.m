function [idxhat,bithat,i,minMlcost] = mgs_mr(par,H,y,N0)

    Rmax = 50;
    H_temp = [real(H) -imag(H);imag(H) real(H)];
    y_temp = [real(y);imag(y)];
    offset = y'*y;
    minMlcost = Inf;
    repcnt = 0;
    solvec = [];
    c2 = 0.5*par.Q;
    i=1;
    while i<=Rmax
        % generate initial random vector
        x0 = par.symbols(randi([1 length(par.symbols)],par.MT,1))';
        [~,~,z(:,i),beta(i)] = mgs(par,H,y,x0,N0);

        if beta(i)<minMlcost
            minMlcost = beta(i);
            solvec = z(:,i);
            standMLcost = standMLcostFn(solvec,H_temp,y_temp,par,offset,N0);
            P = floor(max(0,c2*standMLcost))+1;
            repcnt = 0;
        end

        if beta(i) == minMlcost
            repcnt = repcnt+1;
        end

        if repcnt>=P
            break;
        end

        i=i+1;
    end
    xhat = solvec(1:par.MT) + 1i.*solvec(par.MT+1:end);

    [~,idxhat] = max(bsxfun(@eq,xhat,par.symbols),[],2);
    bithat = par.bits(idxhat,:);
end

function [standMLcost] = standMLcostFn(x,H,y,par,offset,N0)
    cost = x'*H'*H*x - 2*y'*H*x + offset;
    standMLcost = (cost - par.MR*N0)/(sqrt(par.MR)*N0);
end
