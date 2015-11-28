function [idxhat,bithat] = SIC(par,H,y)

    % Do QR decomposition of H
    [Q,R] = qr(H);
    
    Qa = Q(:,1:par.MT);
    R_tilda = R(1:par.MT,:); % MTxMT
    
    y_tilda = Qa'*y; % MTx1
    
    x_hat = zeros(par.MT,length(par.symbols));
    x_dfe = zeros(par.MT,1);
    for i=fliplr(1:par.MT)
        x_hat(i,:) = par.symbols;
        [~,x_dfe(i)] = min(abs(repmat(y_tilda(i),1,length(par.symbols)) - R_tilda(i,:)*x_hat).^2);
        x_hat(i,:) = repmat(par.symbols(x_dfe(i)),1,length(par.symbols));
    end
    
    idxhat = x_dfe;
    bithat = par.bits(idxhat,:);    