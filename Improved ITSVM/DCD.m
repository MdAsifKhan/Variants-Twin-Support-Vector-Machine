function [w,b]=DCD(Q,A,B,p,q,c1,c2,c3,c4,flag)
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
D=[diag(c1*ones(p,1)) zeros(p,q);zeros(q,p) diag(c2*ones(q,1))];
delta=Q-D;
e1=ones(q,1);
e2=ones(p,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute w and b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lambda=rand(p+q,1);
lambda_cap=zeros(p+q,1);

while(1)
    if flag==1,
        alpha=lambda(1:p);
        beta=lambda(p+1:p+q);
        w1=(1/c3)*(A'*alpha+B'*beta);
        b1=(1/c3)*(e2'*alpha*+e1'*beta);
        w_p=[w1;b1];
        lambda=[alpha;beta];
    else
        theta=lambda(1:q);
        gamma=lambda(q+1:p+q);
        w2=(1/c4)*(A'*gamma+B'*theta);
        b2=(1/c4)*(e2'*gamma+e1'*theta);
        w_p=[w2;b2];
        lambda=[theta;gamma];
    end
    ww=w_p;
    for i=1:p+q
        lambda_cap(i)=lambda(i);
        x=T(i,:)';
        G=-dot(w_p,x)-k(i)+D(i,i)*lambda(i);
        if i>=p+1 && lambda(i)==0,
            PG=min(G,0);
        else
            PG=G;
        end
        if abs(PG)~=0,
            if i<=p,
                lambda(i)=lambda(i)-G/(delta(i,i)+D(i,i));
            elseif i>=p+1,
                lambda(i)=max(lambda(i)-G/(delta(i,i)+D(i,i)),0);
            end
            w_p=w_p-(lambda(i)-lambda_cap(i)).*x;
        end   
    end
    abs(sum(lambda-lambda_cap))
    if abs(sum(lambda-lambda_cap))<0.1,
        break;
    end    
end
w=w_p(1:end-1);
b=w_p(end);
end