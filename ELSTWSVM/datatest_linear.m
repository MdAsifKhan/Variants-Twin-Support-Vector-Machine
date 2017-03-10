    clc;
    clear all;
    close all;
     file1 = fopen('results_ELSTWSVM_BCI_linear.txt','w+');
 
    A=load('Traindata_0.txt');
    B=load('Traindata_1.txt');
    C=load('Testdata.txt');
    D=load('testlabels.txt');
    
    dat =[A(:,2:end);B(:,2:end)];
    label=[A(:,1);B(:,1)];
    options=[];
    options.ReducedDim=0;
    [eigvector, eigvalue] = PCA(dat,options);
    data=dat*eigvector;
    DataTrain = [data label];  
    DataTrain(DataTrain==0)=-1;
    [m,n] = size(DataTrain);
    shuffle=randperm(size(DataTrain,1));
    DataTrain=DataTrain(shuffle,:);
    D(D==0)=-1;
    options=[];
    options.ReducedDim=0;
    [eigvec, eigval] = PCA(C,options);
    test=C*eigvec;
    TestX=[test D];
%                 DataTrain(:,1:n-1) = scale (DataTrain(:, 1:n-1));
%                 TestX(:,1:n-1) = scale (TestX(:, 1:n-1));  
    
    cvs1=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
    Energy1=[0.6 0.7 0.8 0.9 1];
%       t = cputime;   
% % --------------------------------------------------------------------------     
     no_part = 10.;
%    initialize minimum error variable and corresponding c
    min_c1 = 1.;min_c2 = 1.;min_err=1000000000000000.;min_E1=1.;min_E2=1.0;
         for ci=1:length(cvs1)
                c1=cvs1(ci);c2=c1;
            for Ei=1:length(Energy1)  
                E1=Energy1(Ei);
                for Eii=1:length(Energy1) 
                    E2=Energy1(Eii);
%   training statement
                    block_size=m/(no_part*1.0);
                    part=0;avgerr=0;t_1=0;t_2=0;
                    while ((part+1)* block_size) <= m
                        t_1 = ceil(part*block_size);
                        t_2 = ceil((part+1)*block_size);                
                        Data_test= DataTrain(t_1+1: t_2,:); 
                        Data =[DataTrain(1:t_1,:); DataTrain(t_2+1:m,:)];
                        FunPara.c1=c1;FunPara.c2=c2;Energy.E1=E1;Energy.E2=E2;FunPara.kerfPara.type = 'lin';
                        [err]=  ELSTWSVM(Data_test,Data,FunPara,Energy);
                        avgerr = avgerr + err;
                        part=part+1;
                    end
                %             testing statement
                %             for particular c and for particular file
                    if avgerr < min_err
                        min_c1 =c1;min_c2 =c2;
                        min_err=avgerr;
                        min_E1=E1;min_E2=E2;
                    end
               end  % for Energy1  
            end % for Energy2  
          end %for c values
%     final training
%   _______________________________________________________________________
    FunPara.c1=min_c1;FunPara.c2=min_c2;Energy.E1=min_E1;Energy.E2=min_E2;
    FunPara.kerfPara.type = 'lin';
    tstart=tic;
    [err,Predict_Y,A,B,x1,x2]= ELSTWSVM(TestX,DataTrain,FunPara,Energy);
     telapsed=toc(tstart);
     time=telapsed
     file='BCI-Ia';
     accuracy=1-err/length(Predict_Y);           
     fprintf(file1,'example file: %s;err = %8.6g of %g,accuracy= %8.6g,\t c1 = %8.6g,c2 = %8.6g\t E1=%g E2=%g  \n',...
                          file,err,length(Predict_Y),accuracy,FunPara.c1,FunPara.c2,Energy.E1,Energy.E2);
% end
%     save('time_energybased_algo','telapsed');

     fclose(file1);
% fclose(file2);
%................complete code.............................%    
                 

    
   
    
    