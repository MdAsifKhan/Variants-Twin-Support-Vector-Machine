function [err,Predict_Y,w1,b1,w2,b2] = Improved_ITSVM(TestX,DataTrain,FunPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Improved_ITSVM: Robust Improved Twin Support Vector Machine
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
%    Predict_Y =  Improved_ITSVM(TestX,DataTrain,FunPara);
%

%    Written by M. Asif Khan (mak4086@gmail.com)
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

n=size(A,2);
%%%%Improved ITSVM1
Q=[A*A'+c3*eye(p) A*B';B*A' B*B'+(c3/c1)*eye(q)];
Q=Q+ones(size(Q,1));
[w1,b1]=DCD_new(Q,A,B,p,q,n,c1,c2);

%%%%Improved ITSVM2
Q=[B*B'+c4*eye(q) B*A';A*B' A*A'+(c4/c2)*eye(p)];
Q=Q+ones(size(Q,1));
[w2,b2]=DCD_new(Q,A,B,p,q,n,c1,c2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,col]=size(TestX);
if strcmp(kerfPara.type,'lin')
    P_1=TestX(:,1:col-1);
    y1=P_1*w1+ones(m,1)*b1;
    y2=P_1*w2+ones(m,1)*b2;    
else
    C=[A;B];
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