function [err,Predict_Y,w1,b1,w2,b2] = ITSVM(TestX,DataTrain,FunPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ITSVM: Improved Twin Support Vector Machine
%
% Predict_Y =ITSVM(TestX,DataTrain,FunPara)
% 
% Input:
%    TestX - Test Data matrix. Each row vector of it is a data point.
%
%    DataTrain - Struct value in Matlab(Training data).
%                DataTrain: input Data matrix for training.
%
%    FunPara - Struct value in Matlab. The fields in options that can be set: 
%               c1: [0,inf] Paramter to tune the weight. 
%               c2: [0,inf] Paramter to tune the weight. 
%               c3: [0,inf] Paramter to tune the weight. 
%               c4: [0,inf] Paramter to tune the weight. 
%    Energy  - Energy Parameter        
%               E1: Energy of 1st Hyperplane
%               E2: Energy of 2nd Hyperplane
%               kerfPara:Kernel parameters. See kernelfun.m.
%
% Output:
%    Predict_Y - Predict value of the TestX.
%
% Examples:
%    DataTrain = rand(100,10);
%    TestX=rand(20,10);
%    FunPara.c1=0.1;
%    FunPara.c2=0.1;
%    FunPara.c3=0.1;
%    FunPara.c4=0.1;
%    FunPara.kerfPara.type = 'lin';
%    FunPara.kerfPara.pars=mu;
%    Predict_Y = ITSVM(TestX,DataTrain,FunPara);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initailization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tic;
[no_input,no_col]=size(DataTrain);
  obs =DataTrain(:,no_col);    
 A = zeros(1,no_col-1);
 B = zeros(1,no_col-1);

for i = 1:no_input
    if(obs(i) == 1)
        A = [A;DataTrain(i,1:no_col-1)];
    else
        B = [B;DataTrain(i,1:no_col-1)];
    end
end

c1 = FunPara.c1;
c2 = FunPara.c2;
c3 = FunPara.c3;
c4 = FunPara.c4;
kerfPara = FunPara.kerfPara;
p=size(A,1);
q=size(B,1);
A_c=A;B_c=B;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Kernel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(kerfPara.type,'lin')
   ;
else
    X=[A;B];
    A=kernelfun(A,kerfPara,X);
    B=kernelfun(B,kerfPara,X);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute (w1,b1) and (w2,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e1=ones(q,1);
e2=ones(p,1);
%%%%ITSVM1
Q=[A*A'+c3*eye(p) A*B';B*A' B*B'];
Q=Q+ones(size(Q,1));
% k=[zeros(1,p) c3*ones(1,q)];
% mu=SOR(Q,0.5,k,c1);
mu=qpSOR(Q,0.5,c1,0.05);
mu=mu';
lamda=mu(1:p)';
alpha=mu(p+1:p+q)';
w1=-(1/c3)*(A'*lamda+B'*alpha);
b1=-(1/c3)*(e2'*lamda+e1'*alpha);


%%%%ITSVM2
Q=[B*B'+c4*eye(q) B*A';A*B' A*A'];
Q=Q+ones(size(Q,1));
% k=[zeros(1,q) c4*ones(1,p)]; 
% mu=SOR(Q,0.5,k,c2);
mu=qpSOR(Q,0.5,c2,0.05);
mu=mu';
theta=mu(1:q)';
gamma=mu(q+1:p+q)';
w2=-(1/c4)*(A'*gamma+B'*theta);
b2=-(1/c4)*(e1'*theta+e2'*gamma);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,col]=size(TestX);
if strcmp(kerfPara.type,'lin')
    P_1=TestX(:,1:col-1);
    y1=P_1*w1+ones(m,1)*b1;
    y2=P_1*w2+ones(m,1)*b2;    
else
    C=[A_c;B_c];
    P_1=kernelfun(TestX(:,1:col-1),kerfPara,C);
    y1=P_1*w1+ones(m,1)*b1;
    y2=P_1*w2+ones(m,1)*b2;
end
for i=1:size(y1,1)
   if abs(y1(i)) < abs(y2(i))
        Predict_Y(i,1)=1;
    else
        Predict_Y(i,1)=-1;
    end
end
err = 0.;
[no_test,no_col] = size(TestX);   
Predict_Y = Predict_Y';
obs = TestX(:,no_col);
for i = 1:no_test
    if(sign(Predict_Y(1,i)) ~= sign(obs(i)))
        err = err+1;
    end
end
end