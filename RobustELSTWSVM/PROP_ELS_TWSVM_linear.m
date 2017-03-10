function [err,Predict_Y,A,B,x1,x2,dec_bdry,w1,b1,w2,b2,E1,E2] = PROP_ELS_TWSVM_linear(TestX,DataTrain,FunPara,Energy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROP_ELS_TWSVM: Energy based Least Square Twin Support Vector Machine
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
%    FunPara.c3=0.1;
%    FunPara.c4=0.1;
%    FunPara.kerfPara.type = 'lin';
%    FunPara.kerfPara.pars=mu;
%    Predict_Y = PROP_ELS_TWSVM(TestX,DataTrain,FunPara);
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
c3   = FunPara.c3;
c4   = FunPara.c4;
E1   = Energy.E1;
E2   = Energy.E2;
kerfPara = FunPara.kerfPara;
m1=size(Xpos,1);
m2=size(Xneg,1);
e1=ones(m1,1);
e2=ones(m2,1);

P=[Xpos,e1];
Q=[Xneg,e2];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute (w1,b1) and (w2,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S= inv(P'*P+c3*eye(size(P,2)));
kerH1=-(S-S*Q'*inv(eye(size(Q,1))/c1+Q*S*Q')*Q*S)*(c1*Q'*e2*E1);   
w1=kerH1(1:size(kerH1,1)-1,:);
b1=kerH1(size(kerH1,1));


T= inv(Q'*Q+c4*eye(size(Q,2)));
kerH2=(T-T*P'*inv(eye(size(P,1))/c2+P*T*P')*P*T)*(c2*P'*e1*E2); 
w2=kerH2(1:size(kerH2,1)-1,:);
b2=kerH2(size(kerH2,1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,m1]=size(TestX);
    P_1=TestX(:,1:m1-1);
    y1=P_1*w1+ones(m,1)*b1;
    y2=P_1*w2+ones(m,1)*b2;    

for i=1:size(y1,1)
    dec_bdry(i,:)=abs(y1(i)/y2(i));
    if (dec_bdry(i,:)<=1)
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


x1 =[]; x2 =[];
for i=1:no_test
    if Predict_Y(1,i) ==1
        x1 = [x1; TestX(i,1:no_col-1)];
    else 
        x2 = [x2; TestX(i,1:no_col-1)];
    end
end
end