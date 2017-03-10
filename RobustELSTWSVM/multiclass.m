function [err,result] = multiclass(TrainingSet,TestSet,FunPara,Energy)
%Models a given training set with a corresponding group vector and 
%classifies a given test set using an SVM classifier according to a 
%one vs. all relation. 
GroupTrain=TrainingSet(:,end);
u=unique(GroupTrain);
numClasses=length(u);
result = zeros(length(TestSet(:,1)),1);

for k=1:numClasses
        %Vectorized statement that binarizes Group
        %where 1 is the current class and 0 is all other classes
        one_vs_all=(GroupTrain-u(k));
        one_vs_all(one_vs_all~=0)=-1;
        one_vs_all(one_vs_all==0)=1;
        TrainingSet(:,end)=one_vs_all;
        [~,Predict_Y] = PROP_ELS_TWSVM(TestSet,TrainingSet,FunPara,Energy);%Predicted label of test data
        for j=1:size(TestSet,1)
            for m=1:numClasses
                if(Predict_Y(j))
                    break;
                end
            end
        result(j)=m;
        end
end
    err = 0.;
    [no_test,no_col] = size(TestSet);   
    Predict_Y = Predict_Y';
    obs = TestSet(:,no_col);
    for i = 1:no_test
        if(Predict_Y(1,i) ~= obs(i))
            err = err+1;
        end
    end
end    
