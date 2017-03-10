function [err,Predict_Y,A,B,x1,x2] = TWSVM(TestX,DataTrain,FunPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TWSVM: Twin Support Vector Machine
%
% Predict_Y = TWSVM(TestX,DataTrain,FunPara)
% 
%   Input:
%    TestX - Test Data matrix. Each row vector of it is a data point.
%
%    DataTrain - Struct value in Matlab(Training data).
%                DataTrain: input Data matrix for training.
%
%    FunPara - Struct value in Matlab. The fields in options that can be set: 
%               c1: [0,inf] Paramter to tune the weight. 
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
kerfPara = FunPara.kerfPara;
m1=size(A,1);
m2=size(B,1);
e1=ones(m1,1);
e2=ones(m2,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Kernel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(kerfPara.type,'lin')
    P=[A,e1];
    Q=[B,e2];
else
    X=[A;B];
    P=[kernelfun(A,kerfPara,X),e1];
    Q=[kernelfun(B,kerfPara,X),e2];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute (w1,b1) and (w2,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%TWSVM1
H1=P'*P;
Q1=Q'*Q;epsilon=0.0001;
invHTH = inv(H1 + epsilon*speye(length(H1)));
GINVGT = Q*invHTH*Q';
invGTG = inv(Q1 + epsilon*speye(length(Q1)));
HINVHT = P*invGTG *P';
f1 = -e2';
f2 = -e1';
lowb1=zeros(m2,1);
lowb2=zeros(m1,1);
upb1 = c1*ones(m2,1);
upb2 = c2*ones(m1,1);
alpha = quadprog(GINVGT,f1,[],[],[],[],lowb1,upb1);
gamma = quadprog(HINVHT,f2,[],[],[],[],lowb2,upb2);

kerH1=-(invHTH*Q'*alpha);
w1=kerH1(1:size(kerH1,1)-1,:);
b1=kerH1(size(kerH1,1));

kerH2=invGTG*P'*gamma;
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
   if abs(y1(i)) < abs(y2(i))
        Predict_Y(i,1) = 1;
    else
        Predict_Y(i,1) =-1;
    end
end
[no_test,no_col] = size(TestX);
err = 0.;
obs = TestX(:,no_col);
for i = 1:no_test
    if(sign(Predict_Y(i,1)) ~= sign(obs(i)))
        err = err+1;
    end;
end;  
x1 =[]; x2 =[];
for i=1:no_test
    if Predict_Y(i,1) ==1
        x1 = [x1; TestX(i,1:no_col-1)];
    else 
        x2 = [x2; TestX(i,1:no_col-1)];
    end
end
end