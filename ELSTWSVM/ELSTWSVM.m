function [err,Predict_Y,A,B,x1,x2] = ELSTWSVM(TestX,DataTrain,FunPara,Energy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ELSTWSVM: Energy based Least Square Twin Support Vector Machine
%
% Predict_Y = ELSTWSVM(TestX,DataTrain,FunPara)
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
%    FunPara.kerfPara.type = 'lin';
%    Energy.E1=0.6;
%    Energy.E2=0.6;
%    Predict_Y = ELSTWSVM(TestX,DataTrain,FunPara,Energy);
%
% % Reference:
% 
% Energy-based model of least squares twin Support Vector Machines for human action recognition
% JA Nasiri, N Moghadam Charkari, K Mozafari - Signal Processing, 2014 
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

Xpos = A;
Xneg = B;
c1 = FunPara.c1;
c2 = FunPara.c2;
E1   = Energy.E1;
E2   = Energy.E2;
kerfPara = FunPara.kerfPara;
m1=size(Xpos,1);
m2=size(Xneg,1);
e1=-ones(m1,1);
e2=-ones(m2,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Kernel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(kerfPara.type,'lin')
    P=[Xpos,-e1];
    Q=[Xneg,-e2];
else
    X=[A;B];
    P=[kernelfun(Xpos,kerfPara),-e1];
    Q=[kernelfun(Xneg,kerfPara),-e2];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute (w1,b1) and (w2,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%ELSTWSVM1
H1=P'*P;epsilon=0.00001;
Q1=Q'*Q;
HH=(H1+c1*Q1+epsilon*eye(length(H1)));
HHG = inv(HH);
kerH1=-(HHG*c1)*(Q'*(-e2)*E1);
w1=kerH1(1:size(kerH1,1)-1,:);
b1=kerH1(size(kerH1,1));

HH1=(Q1+c2*H1+epsilon*eye(length(Q1)));
HHG=inv(HH1);
kerH2=(HHG*c2*(P'*(-e1)*E2));
w2=kerH2(1:size(kerH2,1)-1,:);
b2=kerH2(size(kerH2,1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,m1]=size(TestX);
if strcmp(kerfPara.type,'lin')
    P_1=TestX(:,1:m1-1);
    y1=P_1*w1+ones(m,1)*b1;
    y2=P_1*w2+ones(m,1)*b2;    
else
    C=[A;B];
    P_1=kernelfun(TestX(:,1:m1-1),kerfPara,C);
    y1=P_1*w1+ones(m,1)*b1;
    y2=P_1*w2+ones(m,1)*b2;
end
for i=1:size(y1,1)
    if abs(y1(i)/y2(i))<=1
        Predict_Y(i,1)=1;
    else
        Predict_Y(i,1)=-1;
    end
end

[no_test,no_col] = size(TestX);
err = 0.;
Predict_Y = Predict_Y';
obs = TestX(:,no_col);
for i = 1:no_test
    if(sign(Predict_Y(1,i)) ~= sign(obs(i)))
        err = err+1;
    end;
end;  
x1 =[]; x2 =[];
for i=1:no_test
    if Predict_Y(1,i) ==1
        x1 = [x1; TestX(i,1:no_col-1)];
    else 
        x2 = [x2; TestX(i,1:no_col-1)];
    end
end
end