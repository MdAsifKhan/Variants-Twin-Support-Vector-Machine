clc
clear all
close all

%#dataset
load weizmann_HOOF
[~,~,labels] = unique(HOG_feature(:,end));   %# labels: 1/2/3
data = HOG_feature(:,1:end-1);              %# scale features
numInst = size(data,1);
numLabels = max(labels);

%# split training/testing
idx = randperm(numInst);
numTrain = 40; numTest = numInst - numTrain;
trainData = data(idx(1:numTrain),:);  testData = data(idx(numTrain+1:end),:);
trainLabel = labels(idx(1:numTrain)); testLabel = labels(idx(numTrain+1:end));
testLabel_new=[];trainLabel_new=[];
FunPara.c1=2^-5;FunPara.c2=2^-5;FunPara.c3=2^-3;FunPara.c4=2^-3;FunPara.kerfPara.type = 'lin';Energy.E1=0.8;Energy.E2=0.9;
for k=1:numLabels
    testLabel_new=double(testLabel & double(testLabel==k)); 
    trainLabel_new=double(trainLabel & double(trainLabel==k));
    
    testLabel_new(testLabel_new~=0)=-1;
    testLabel_new(testLabel_new==0)=1;
    trainLabel_new(trainLabel_new~=0)=-1;
    trainLabel_new(trainLabel_new==0)=1;
    TestSet=[testData testLabel_new];
    TrainingSet=[trainData trainLabel_new];
    [err,Predict_Y] = PROP_ELS_TWSVM_linear(TestSet,TrainingSet,FunPara,Energy);%Predicted label of test data
    disp(err);
end

% % %# predict the class with the highest probability
%   [~,pred] = max(prob,[],2);
%   acc = sum(pred == testLabel) ./ numel(testLabel)    %# accuracy
%   C = confusionmat(testLabel, pred)                   %# confusion matrix