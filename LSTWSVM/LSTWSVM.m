function [err,Predict_Y,A,B,x1,x2] = LSTWSVM(TestX,DataTrain,FunPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LSTWSVM: Least Square Twin Support Vector Machine
%
% Predict_Y = LSTWSVM(TestX,DataTrain,FunPara)
% 
%   Input:
%    TestX - Test Data matrix. Each row vector of it is a data point.
%
%    DataTrain - Struct value in Matlab(Training data).
%                DataTrain: input Data matrix for training.
%
%    FunPara - Struct value in Matlab. The fields in options that can be set: 
%               c1: [0,inf] Paramter to tune the weight. 
%               c2: [0,inf] Paramter to tune the weight. 
% 

% Output:
%    Predict_Y - Predict value of the TestX.
%
% Examples:
%    DataTrain = rand(100,10);
%    TestX=rand(20,10);
%    FunPara.c1=0.1;
%    FunPara.c2=0.1;
%    FunPara.kerfPara=mu;
%    FunPara.kerfPara.type = 'lin';
%    Predict_Y = LSTWSVM(TestX,DataTrain,FunPara);
%

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
kerfPara = FunPara.kerfPara;
m1=size(A,1);
m2=size(B,1);
e1=ones(m1,1);
e2=ones(m2,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Kernel 
% Compute (w1,b1) and (w2,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(kerfPara.type,'lin')
    P=[A,e1];
    Q=[B,e2];
    H1=P'*P;
    Q1=Q'*Q;epsilon=0.0001;
    kerH1=-(inv(H1/c1+Q1+epsilon*eye(length(Q1)))*Q'*(e2));
    w1=kerH1(1:size(kerH1,1)-1,:);
    b1=kerH1(size(kerH1,1));
    kerH2=(inv(Q1/c2+H1+epsilon*eye(length(H1)))*P'*(e1));
    w2=kerH2(1:size(kerH2,1)-1,:);
    b2=kerH2(size(kerH2,1));
else
    X=[A;B];
    G=[kernelfun(A,kerfPara,X),e1];
    H=[kernelfun(B,kerfPara,X),e2];
    H11=H*H';
    G11=G*G';
    epsilon=0.0001;
    if (m1<m2)
        Y=(1/epsilon)*(eye(size(H,2))-H'*inv(epsilon*eye(length(H11))+H11)*H);
        Y11=G*Y*G';
        kerH1=-(Y-Y*G'*inv(c1*eye(length(Y11))+Y11)*G*Y)*(H'*(e2));
        w1=kerH1(1:size(kerH1,1)-1,:);
        b1=kerH1(size(kerH1,1));
        kerH2=c2*(Y-Y*G'*inv(eye(length(Y11))/c2+Y11)*G*Y)*(G'*(e1));
        w2=kerH2(1:size(kerH2,1)-1,:);
        b2=kerH2(size(kerH2,1));
    elseif (m1==m2)
        P=[kernelfun(A,kerfPara,X),e1];
        Q=[kernelfun(B,kerfPara,X),e2];
        H1=P'*P;
        Q1=Q'*Q;epsilon=0.0001;
        kerH1=-(inv(H1/c1+Q1+epsilon*eye(length(Q1)))*Q'*(e2));
        w1=kerH1(1:size(kerH1,1)-1,:);
        b1=kerH1(size(kerH1,1));
        kerH2=(inv(Q1/c2+H1+epsilon*eye(length(H1)))*P'*(e1));
        w2=kerH2(1:size(kerH2,1)-1,:);
        b2=kerH2(size(kerH2,1));
    else
        
        Z=(1/epsilon)*(eye(size(G,2))-G'*inv(epsilon*eye(length(G11))+G11)*G);
        Z11=H*Z*H';
        kerH1=-c1*(Z-Z*H'*inv(eye(length(Z11))/c1+Z11)*H*Z)*(H'*(e2));
        w1=kerH1(1:size(kerH1,1)-1,:);
        b1=kerH1(size(kerH1,1));
        kerH2=(Z-Z*H'*inv(c2*eye(length(Z11))+Z11)*H*Z)*(G'*(e1));
        w2=kerH2(1:size(kerH2,1)-1,:);
        b2=kerH2(size(kerH2,1));
    end 
 end


%%%%LSTWSVM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,m1]=size(TestX);
if strcmp(kerfPara.type,'lin')
    P_1=TestX(:,1:m1-1);
    y1=P_1*w1+b1;
    y2=P_1*w2+b2;    
else
    C=[A;B];
    P_1=kernelfun(TestX(:,1:m1-1),kerfPara,C);
    y1=P_1*w1+b1;
    y2=P_1*w2+b2;
end
for i=1:size(y1,1)
    if (min(abs(y1(i)),abs(y2(i)))==abs(y1(i)))
        Predict_Y(i,1) = 1;
    else
        Predict_Y(i,1) =-1;
    end
end
[no_test,no_col] = size(TestX);
x1=[]; x2 =[];err = 0.;
Predict_Y = Predict_Y';
obs = TestX(:,no_col);
for i = 1:no_test
    if(sign(Predict_Y(1,i)) ~= sign(obs(i)))
        err = err+1;
    end
end  
for i=1:no_test
    if Predict_Y(1,i) ==1
        x1 = [x1; TestX(i,1:no_col-1)];
    else 
        x2 = [x2; TestX(i,1:no_col-1)];
    end
end
end