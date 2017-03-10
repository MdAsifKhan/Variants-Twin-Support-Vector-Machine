function MU=SOR(Q,w,c3,c1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       bestalpha=SOR(Q,t,C,smallvalue)
% 
%       Input:
%               Q     - Hessian matrix(Require positive definite). 
%
%               w     - (0,2) Paramter to control training.
%
%               C     - Upper bound
%
%               smallvalue - Termination condition
%
%       Output:
%               MU - Solutions of QPPs.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initailization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smallvalue=0.05;
[m,n]=size(Q);
alpha0=zeros(m,1);
L=tril(Q);
D=diag(diag(Q));
mu=alpha0;
k=[zeros(p,1);c3*ones(q,1)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu_i=mu;
mu_j=zeros(m,1);
while(1)
    mu_j=mu_i-w*inv(D)*(Q*mu_i+k+L*(mu_j-mu_i));
    if norm(mu_j)<0,
        mu_j(1:end)=0;
    elseif norm(mu_j)>=c1,
        mu_j(1:end)=c1;
    else
        ;
    end
    if norm(mu_j-mu_i)<smallvalue,
        break;
    else
        mu_i=mu_j;
    end    
end
MU=mu_j;
end


