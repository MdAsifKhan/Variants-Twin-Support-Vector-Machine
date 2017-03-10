clc
clear all
close all
        
test_start = 247;   
Funpara.c1=10^-5;
Funpara.c2= 10^-3;
Funpara.c3=Funpara.c1;
Funpara.c4=Funpara.c2;
Funpara.kerfPara= 2^0;
Funpara.kerfPara.type='lin';
Energy.E1=0.6;
 Energy.E2= Energy.E1;

A =  load('iono.txt');
[m,n] = size(A);    
TestX= A(test_start:m,:);
if test_start > 1
     DataTrain= A(1:test_start-1,:);        
end  
 [m,n] = size(DataTrain);
DataTrain(:,1:n-1) = scale (DataTrain(:, 1:n-1));
TestX(:,1:n-1) = scale (TestX(:, 1:n-1));  
[err,Predict_Y,A,B,x1,x2,test1,test2] = PROP_ELS_TWSVM(TestX,DataTrain,Funpara,Energy);
plot(test1(:,1),test1(:,2),'r-',test2(:,1),test2(:,2),'b-',A(:,1),A(:,2),'bo',B(:,1),B(:,2),'ko')

