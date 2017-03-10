    clc;
    clear all;
    close all;
%     file1 = fopen('results_ELS_TWSVM_Ia_nonlinear.txt','w+');
%     file2 = fopen('results_c_mu_Ia_nonlinear.txt','w+');
   
    for load_file = 7:7  
    switch load_file
        case 1
            file = 'tic',            
                    test_start = 672; mu=        2,c1 =      0.1,c2 =      0.1 ,E1=       1, E2=       1;
        case 2
            file = 'iono',           
                    test_start = 247;  mu=        1,c1 =    0.001,c2 =    0.001 ,E1=       1, E2=       1;
        case 3
             file = 'bupa',             
                    test_start = 242;mu=        2,c1 =      0.1,c2 =      0.1 ,E1=       1, E2=       1;
        case 4
            file= 'votes',
                    test_start = 307; mu=        2,c1 =      0.1,c2 =      0.1 ,E1=       1, E2=       1;
        case 5
            file= 'wpbc',           
                    test_start = 138; mu=        8,c1 =      0.1,c2 =      0.1, E1=       1, E2=       1;
        case 6
            file= 'pima',           
                    test_start = 538;mu=        8,c1 =      0.1,c2 =      0.1, E1=       1, E2=       1; 
     
        case 7
           file= 'Ripley',       
                    test_start = 251;mu=       32,c1 =      0.1,c2 =      0.1, E1=       1, E2=       1;
        case 8
           file= 'ndc1100',         
                    test_start = 771;mu=       32,c1 =        1,c2 =        1 ,E1=       1, E2=       1;    
        case 9
            file= 'cleve',
                    test_start = 178;mu=       16,c1 =   1e-005,c2 =   1e-005, E1=       1, E2=       1;
        case 10
            file= 'ger',          
                    test_start = 801;mu=     0.25,c1 =        1,c2 =        1 ,E1=       1, E2=       1;
        case 11
             file= 'aus',          
                    test_start = 541;mu=      0.5,c1 =        1,c2 =        1 ,E1=       1, E2=       1;
        case 12
            file = 'haberman',
                    test_start = 201; mu=        4,c1 =      0.1,c2 =      0.1, E1=       1, E2=       1;
        case 13
            file = 'transfusion',
                    test_start = 601; mu=       32,c1 =      0.1,c2 =      0.1, E1=       1, E2=       1;
        case 14
            file = 'wdbc',
                    test_start = 501;mu=      0.5,c1 =    0.001,c2 =    0.001, E1=       1, E2=       1;
             
        case 15
            file = 'splice',
                    test_start = 501;mu=        1,c1 =      0.1,c2 =      0.1, E1=       1, E2=       1;
        case 16
            file = 'monk2',
                     mu=       16,c1 =   1e-005,c2 =   1e-005 ,E1=       1, E2=       1;
                    test_start = 170; % its a special dataset, cant change test_size   
        case 17
            file = 'monk3',
                     mu=   0.0625,c1 =    0.001,c2 =    0.001, E1=       1, E2=       1
                    test_start = 123; % its a special dataset, cant change test_size   
        case 18
            file = 'monks-1', % its a special dataset, cant change test_size
                    test_start = 125;  c1 =        2,c2 =        2	 ;E1=1 ;E2=0.6 ; 
        case 19
            file = 'heart-stat',
                    test_start = 201; c1 =  0.03125,c2 =  0.03125	; E1=0.7 ;E2=0.6; 
        case 20
            file= 'sonar',
                    test_start = 151;c1 =  0.03125,c2 =  0.03125	 ;E1=0.9 ;E2=1;  
        case 21
            file= 'cmc',
                    test_start = 1001; c1 =      0.5,c2 =      0.5	 ;E1=0.6 ;E2=0.7;  
        case 22
            file= 'crossplane150', 
                    test_start = 81;c1 =  0.03125,c2 =  0.03125	 ;E1=0.6 ;E2=0.7 ; 
          
        case 23
            file= 'Heart-c',          
                    test_start = 178; c1 =        1,c2 =        1	 ;E1=0.8 ;E2=1 ; 
        case 24
            file= 'ndc500';  %Only NDC datasets, we normalize in standard manner (not scalling)        
                    test_start = 501;  
        case 25
            file= 'ndc1k';          
                    test_start = 1001; 
        case 26
            file= 'ndc2k';          
                    test_start = 2001; 
        case 27
            file= 'ndc3k';          
                    test_start = 3001; 
        case 28
            file= 'ndc5k';          
                    test_start = 5001;        
        case 29
            file= 'ndc8k';          
                    test_start = 8001;   
        case 30
            file= 'ndc10k';          
                    test_start = 10001;
        case 31
            file= 'ndc50k';          
                    test_start = 50001;
        case 32
            file= 'twindata';          
                    test_start = 1001;
       otherwise
            continue;
    end   

%                 muvs=[2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5,2^6,2^7,2^8,2^9,2^10];
%                 cvs1=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
%                 Energy2= Energy1;
              %               cvs1= 10^-5;cvs2= 10^-5;muvs= 2^0;
                A =  load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\Final Codes\Proposed Algorithm\Dataset\',file,'.txt') );
                m = size(A,1);    
                TestX = A(test_start:m,:);
                if test_start > 1
                    DataTrain = A(1:test_start-1,:);        
                end  
                [m,n] = size(DataTrain);
                DataTrain(:,1:n-1) = scale (DataTrain(:, 1:n-1));
                TestX(:,1:n-1) = scale (TestX(:, 1:n-1));  
                min_c1 = c1;min_c2=min_c1;min_E1=E1;min_E2=E2;min_mu=mu;
              
%     file='Traindata_0';
%     file11='Traindata_1';
%     file22='Testdata';
%     A =  load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\New TWSVM\',file,'.txt') );
%     B =  load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\New TWSVM\',file11,'.txt') );
%     A=[A(:,2:size(A,2)) ones(size(A,1),1)];
%     B=[B(:,2:size(B,2)) -ones(size(B,1),1)];
% 
%     DataTrain = [A;B];        
%     [m,n] = size(DataTrain);
% %   DataTrain(:,1:n-1) = scale(DataTrain(:, 1:n-1));
%     C=load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\New TWSVM\',file22,'.txt') );
%     [a,b]=size(C);
%     c=(a+1)/2;
%     Test_a=C(1:c,:);
%     Test_b=C(c+1:end,:);
%     Test_a=[Test_a ones(c,1)];
%     Test_b=[Test_b -ones(a-c,1)];
%     TestX=[Test_a;Test_b]; 
%     t = cputime;    
% % --------------------------------------------------------------------------     
%      no_part = 10.;
% %    initialize minimum error variable and corresponding c
%     min_c1 = 1.;min_c2 = 1.;min_err=1000000000000000.;min_mu=1.;min_E1=1;min_E2=1;
%                 for mui=1:length(muvs)
%                     mu=muvs(mui);
%                     for ci=1:length(cvs1)
%                         c1=cvs1(ci);
%                         c2=c1;
%                         for Ei=1:length(Energy1)  
%                                 E1=Energy1(Ei);
%                                 for Eii=1:length(Energy1) 
%                                     E2=Energy1(Eii);
% %   training statement
%                                     block_size=m/(no_part*1.0);
%                                     part=0;avgerr=0;t_1=0;t_2=0;
%                                     while ((part+1)* block_size) <= m
%                                         t_1 = ceil(part*block_size);
%                                         t_2 = ceil((part+1)*block_size);                
%                                         Data_test= DataTrain(t_1+1: t_2,:); 
%                                         Data=[DataTrain(1:t_1,:); DataTrain(t_2+1:m,:)];
%                                         FunPara.c1=c1;FunPara.c2=c2;FunPara.kerfPara.pars=mu;Energy.E1=E1;Energy.E2=E2;FunPara.kerfPara.type = 'rbf';
%                                         [err]= ELSTWSVM(Data_test,Data,FunPara,Energy);
%                                         fprintf(file2, 'example file %s; err= %8.6g, part num= %8.6g, mu= %8.6g, c1= %8.6g, c2= %8.6g,E1= %8.6g, E2= %8.6g\n', file,err,part,mu,c1,c2,E1,E2);
%                                         avgerr = avgerr + err;
%                                         part=part+1;
%                                     end
%                                     fprintf(file2, 'example no: %s\t avgerr: %g\t mu=%g\t c1=%g\t c2=%g E1=%g E2=%g \n',file, avgerr,mu,c1,c2,E1,E2);
%                                     if avgerr < min_err
%                                         min_c1 =c1;min_c2 =c2;
%                                         min_err=avgerr;
%                                         min_mu=mu;
%                                         min_E1=E1;min_E2=E2;
%                                     end
%                                 end % for Energy1 values
%                         end    %for Energy2 value   
%                     end %for c values
%                 end %for mu values
% %     final training
% %    _______________________________________________________________________
    FunPara.c1=min_c1;FunPara.c2=min_c2;FunPara.kerfPara.pars=min_mu;Energy.E1=E1;Energy.E2=E2;
    FunPara.kerfPara.type = 'rbf';
     tstart=tic;
    [err,Predict_Y,A,B,x1,x2]=ELSTWSVM(TestX,DataTrain,FunPara,Energy);
    telapsed(load_file)=toc(tstart) 
%     fprintf(file1,'example file: %s;err = %8.6g of %g,mu= %8.6g,c1 = %8.6g,c2 = %8.6g E1=%8.6g, E2=%8.6g\n', file,err,length(Predict_Y),FunPara.kerfPara.pars,FunPara.c1,FunPara.c2,Energy.E1,Energy.E2)
    end
    save('time_energybased_algo_nonlinear','telapsed');
%     fclose(file1);
%     fclose(file2);
    
%................complete code.............................%    
                

    
   
    
    