function MU=SOR(Q,w,k,C)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NSVM: Nonparallel support vector machine
%
%       bestalpha=SOR(Q,t,C,smallvalue)
% 
%       Input:
%               Q     - Hessian matrix(Require positive definite). 
%
%               t     - (0,2) Paramter to control training.
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
D=diag(Q);
mu=alpha0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:n
    mu(j,1)=alpha0(j,1)-(w/D(j,1))*(Q(j,:)*mu(:,1)+k(j)+L(j,:)*(mu(:,1)-alpha0));
    if mu(j,1)<0
        mu(j,1)=0;
    elseif mu(j,1)>C
        mu(j,1)=C;
    else
        ;
    end
end

alpha=[alpha0,mu];
while norm(alpha(:,2)-alpha(:,1))>smallvalue 
    for j=1:n
        mu(j,1)=alpha(j,2)-(w/D(j,1))*(Q(j,:)*mu(:,1)+k(j)+L(j,:)*(mu(:,1)-alpha(:,2)));
        if mu(j,1)<0
            mu(j,1)=0;
        elseif mu(j,1)>C
            mu(j,1)=C;
        else
            ;
        end
    end
    alpha(:,1)=[];
    alpha=[alpha,mu];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MU=alpha(:,2);

