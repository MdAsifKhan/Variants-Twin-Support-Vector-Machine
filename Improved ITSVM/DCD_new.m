function [w,b]=DCD_new(Q,A,B,p,q,n,c1,c2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       [w,b]=DCD(Q,A,B,p,q,c1,c2,c3,c4,flag)
% 
%       Input:
%       Q          : Hessian matrix(Require positive definite). 
%       c1,c2,c3,c4:Parameters
%       flag       :if equal to '1' 1st pair of QPP else 2nd pair of QPP
%       A,B        :Training Set
%       Output:
%       w,b - Optimum Parameters.
% 
%    Written by M. Asif Khan (mak4086@gmail.com)
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initailization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=[A;B];
T=[T ones(p+q,1)];
k=[zeros(p,1);ones(q,1)];
D=[(0.5/c1)*diag(ones(p,1)) zeros(p,q);zeros(q,p) (0.5/c2)*diag(ones(q,1))];
delta=Q-D;
%T= T(randperm(size(T,1)),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute w and b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda=zeros(p+q,1);
lambda_cap=zeros(p+q,1);
w_p=zeros(n+1,1);
tolerance=0.001;
eps=1e-3;
PGmax_old=Inf;
l=p+q;
act_size=l;
iter=1;
while(1)
    iter=iter+1
    %T=T(randperm(size(T,1)),:);    
    for i=1:act_size
        lambda_cap(i)=lambda(i);
        x=T(i,:)';
        G=-dot(w_p,x)-k(i)+D(i,i)*lambda(i);
        if lambda(i)==0 && i>=p,
           if G<0,    
                PG=G;
           else 
               continue;
           end    
        else
            PG=G;
        end
        if abs(PG)>1e-12,
            if i<=p,
               lambda(i)=lambda(i)-G/(delta(i,i)+D(i,i));
            else    
               lambda(i)=max(lambda(i)-G/(delta(i,i)+D(i,i)),0);
            end
            w_p=w_p+(lambda(i)-lambda_cap(i)).*x;
        end
    end
     if iter==100,
            break;
     end  
w=w_p(1:end-1);
b=w_p(end);
end