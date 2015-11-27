function G=innerproduct(X,Z)
% function G=innerproduct(X,Z)
%	
% Computes the inner-product matrix. 
% Syntax:
% D=innerproduct(X,Z)
% Input:
% X: dxn data matrix with n vectors (columns) of dimensionality d
% Z: dxm data matrix with m vectors (columns) of dimensionality d
%
% Output:
% Matrix G of size nxm 
% G(i,j) is the inner-product between vectors X(:,i) and Z(:,j)
%
% call with only one input:
% innerproduct(X)=innerproduct(X,X)
%

if (nargin==1) % case when there is only one input (X)
	%% fill in code here
	G = X'*X;

else  % case when there are two inputs (X,Z)
	%% fill in code here
	G = X'*Z;

end;
