    clc;
    clear all;
    close all;
     file1 = fopen('results_LSTWSVM_nonlinear.txt','w+');
     file2 = fopen('results_c_mu_LSTWSVM_nonlinear.txt','w+');
   
    for load_file = 1:21
    switch load_file
     
        case 1
           file= 'Ripley',       
                    test_start = 251;c1 =      0.5,c2 =      0.5 ,c3= 0.03125, c4= 0.03125
        case 2
            file= 'Heart-c',          
                    test_start = 178;
        case 3
            file = 'heart-stat',
                    test_start = 201;
                    c1 =  0.03125,c2 =  0.03125 ,c3=       8, c4=       8             
       
        case 4
            file = 'iono',           
                    test_start = 247;c1 =      0.5,c2 =      0.5 ,c3=       8, c4=       8    
        case 5
             file = 'bupa',             
                    test_start = 242; c1 =    0.125,c2 =    0.125 ,c3=     0.5, c4=     0.5
        case 6
            file= 'votes',
                    test_start = 307;  c1 =  0.03125,c2 =  0.03125 ,c3=      32, c4=      32
        case 7
            file= 'wpbc',           
                    test_start = 138;  c1 =    0.125,c2 =    0.125 ,c3=       8, c4=       8
        case 8
            file= 'pima',           
                    test_start = 538;    c1 =    0.125,c2 =    0.125, c3=   0.125, c4=   0.125
    
       case 9
            file= 'ger',          
                    test_start = 801; c1 =  0.03125,c2 =  0.03125 ,c3=      32, c4=      32
        case 10
             file= 'aus',          
                    test_start = 541;c1 =    0.125,c2 =    0.125 ,c3=   0.125, c4=   0.125
        case 11
            file = 'haberman',
                    test_start = 201; c1 =  0.03125,c2 =  0.03125 ,c3=       2, c4=       2
        case 12
            file = 'transfusion',
                    test_start = 601;c1 =    0.125,c2 =    0.125 ,c3=   0.125, c4=   0.125
        case 13
            file = 'wdbc',
                    test_start = 501;  c1 =    0.125,c2 =    0.125, c3=   0.125, c4=   0.125
             
        case 14
            file = 'splice',
                    test_start = 501;c1 =      0.5,c2 =      0.5 ,c3=     0.5, c4=     0.5
       case 15            
            file= 'cmc',
                    test_start = 1001; c1 =  0.03125,c2 =  0.03125 , c3=       8, c4=       8 
        case 16
            file= 'cleve',
                    test_start = 178; c1 =  0.03125,c2 =  0.03125 ,c3=       8, c4=       8
        case 17
            file = 'tic',            
                    test_start = 672;c1 =        1,c2 =        1 ,c3=      32, c4=      32
        case 18
            file = 'monk2',
                    test_start = 170; % its a special dataset, cant change test_size   
                    c1 =  0.03125,c2 =  0.03125, c3=       2, c4=       2
        case 19
            file = 'monk3',
                    test_start = 123; % its a special dataset, cant change test_size   
                    c1 =      0.5,c2 =      0.5 ,c3=      32, c4=      32
      
        case 20
            file= 'sonar',
                    test_start = 151;c1 =  0.03125,c2 =  0.03125 ,c3=       8, c4=       8
      
        case 21
            file= 'crossplane150', 
                    test_start = 81;c1 =        1,c2 =        1 ,c3=     0.5, c4=     0.5
          
 
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

%                  cvs1=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
%                  cvs3=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
%                  cvs2=cvs1;cvs4=cvs3;
                A =  load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\Final Codes\Proposed Algorithm\Dataset\',file,'.txt') );
                m = size(A,1);    
                TestX = A(test_start:m,:);
                if test_start > 1
                    DataTrain = A(1:test_start-1,:);        
                end  
                [m,n] = size(DataTrain);
                DataTrain(:,1:n-1) = scale (DataTrain(:, 1:n-1));
                TestX(:,1:n-1) = scale (TestX(:, 1:n-1));  
% % % --------------------------------------------------------------------------     
%      no_part = 10.;
%      energ=[];error=[];
% %    initialize minimum error variable and corresponding c
%     min_c1 = 1.;min_c2 = 1.;min_mu=1.0;
%     min_err=1000000000000000.;
%     for mu=1:length(muvs)
%              for ci=1:length(cvs1)
%                 c1=cvs1(ci);
%                 %   training statement
%                      block_size=m/(no_part*1.0);
%                      part=0;avgerr=0;t_1=0;t_2=0;
%                      while ((part+1)* block_size) <= m,
%                         t_1 = ceil(part*block_size);
%                         t_2 = ceil((part+1)*block_size);                
%                         Data_test= DataTrain(t_1+1: t_2,:); 
%                         Data=[DataTrain(1:t_1,:); DataTrain(t_2+1:m,:)];
%                         c2=c1;
%                         FunPara.c1=c1;FunPara.c2=c2;FunPara.kerfPara.pars=mu;
%                         FunPara.kerfPara.type = 'rbf';
%                         [err]= LSTWSVM(Data_test,Data,FunPara);
%                         fprintf(file2, 'example file %s; err= %8.6g, part num= %8.6g,c1= %8.6g, c2= %8.6g\n',...
%                              file,err,part,c1,c2);
%                         avgerr = avgerr + err;
%                         part=part+1;
%                      end
%                       fprintf(file2, 'example no: %s\t avgerr: %g\t c1=%g\t c2=%g\n',file, avgerr,c1,c2);
%                      if (avgerr<min_err),
%                          min_c1 =c1;min_c2 =c2;min_mu=mu;
%                          min_err=avgerr;
%                      end
%              end % for c1 values
% %     final training
%     end
% %    _______________________________________________________________________
     FunPara.c1=1;FunPara.c2=1;
     
     FunPara.kerfPara.pars=1;
     FunPara.kerfPara.type = 'rbf';
     tstart=tic;
     [err,Predict_Y] = LSTWSVM(TestX,DataTrain,FunPara);
     telapsed(load_file)=toc(tstart);
     

%     fprintf(file1,'example file: %s;err = %8.6g of %g,c1 = %8.6g,c2 = %8.6g,mu =%8.6g \n', ...
%                  file,err,length(Predict_Y),FunPara.c1,FunPara.c2,FunPara.kerfPara.pars);
    end
  save('time_prop_algo','telapsed');
  fclose(file1);fclose(file2);
%     
%................complete code.....................................................................................................................%    
         

    
   
    
    