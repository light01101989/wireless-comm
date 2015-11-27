function D=l2distance(X,Z)
% function D=l2distance(X,Z)
%	
% Computes the Euclidean distance matrix. 
% Syntax:
% D=l2distance(X,Z)
% Input:
% X: dxn data matrix with n vectors (columns) of dimensionality d
% Z: dxm data matrix with m vectors (columns) of dimensionality d
%
% Output:
% Matrix D of size nxm 
% D(i,j) is the Euclidean distance of X(:,i) and Z(:,j)
%
% call with only one input:
% l2distance(X)=l2distance(X,X)
%

if (nargin==1) % case when there is only one input (X)
	%% fill in code here
	[d n] = size(X);
	G = innerproduct(X,X);
	R = repmat(sum(X.^2,1),n,1);
	S = R';
	D = sqrt(max((S+R-2*G),0));
	%D = sqrt(abs(S+R-2*G));
	%D = sqrt(S+R-2*G);

else  % case when there are two inputs (X,Z)
	%% fill in code here
	[d, n] = size(X);
	[~, m] = size(Z);
	G = innerproduct(X,Z);
	S = repmat(sum(X.^2,1)',1,m);
	R = repmat(sum(Z.^2,1),n,1);
	D = sqrt(max((S+R-2*G),0));
	%D = sqrt(abs(S+R-2*G));
	%D = sqrt(S+R-2*G);
	%tic;D = sqrt(repmat(diag(innerproduct(X,X)),1,m) + repmat(diag(innerproduct(Z,Z)),1,n)' - 2*innerproduct(X,Z));toc
end;
