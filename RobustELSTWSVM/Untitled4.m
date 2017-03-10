%% SVM Multiclass Example 
% SVM is inherently one vs one classification. 
% This is an example of how to implement multiclassification using the 
% one vs all approach. 
TrainingSet=[ 1 10;2 20;3 30;4 40;5 50;6 66;3 30;4.1 42]; 
TestSet=[3 34; 1 14; 2.2 25; 6.2 63]; 
TrainingSet(:,end+1)=[1;1;2;2;3;3;2;2];
TestSet(:,end+1)=[2;1;1;3];
FunPara.c1=2^-2;FunPara.c2=2^-2;FunPara.c3=2^-1;FunPara.c4=2^-1;Energy.E1=1;Energy.E2=1;
FunPara.kerfPara.type = 'lin';
results=multiclass(TrainingSet,TestSet,FunPara,Energy);
disp('multi class problem'); 
disp(results);