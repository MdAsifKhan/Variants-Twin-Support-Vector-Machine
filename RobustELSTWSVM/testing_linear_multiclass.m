    clc;
    clear all;
    close all;
    file1 = fopen('results_PROP_ELS_TWSVM_multi_class_linear.txt','w+');
    file2 = fopen('results_c_mu_multi_class_linear.txt','w+');
   
    for load_file = 1:1  
    switch load_file
        case 1
            file = 'tic';            
                    test_start = 672; 
        otherwise
            continue;
    end   

                cvs1=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
                cvs3=[2^-5,2^-3,2^-1,2^0,2^1,2^3,2^5];
                Energy1=[0.6 0.7 0.8 0.9 1];
                cvs2=cvs1;cvs4=cvs3;
                A =  load(strcat('C:\Users\Sony\Downloads\Prop Algorithm\Prop Algorithm\Dataset\',file,'.txt') );
                m = size(A,1);    
                TestX = A(test_start:m,:);
                if test_start > 1
                    DataTrain = A(1:test_start-1,:);        
                end  
                [m,n] = size(DataTrain);
                DataTrain(:,1:n-1) = scale (DataTrain(:, 1:n-1));
                TestX(:,1:n-1) = scale (TestX(:, 1:n-1));  
                t = cputime;   
% % --------------------------------------------------------------------------     
     no_part = 10.;
%    initialize minimum error variable and corresponding c
    min_c1 = 1.;min_c3 = 1.;min_c2=min_c1;min_c4=min_c3;min_err=1000000000000000.;min_E1=0.1;min_E2=0.1;
                for ci=1:length(cvs1)
                     c1=cvs1(ci);
                     for cii=1:length(cvs3)
                          c3=cvs3(cii);
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
                                      Data=[DataTrain(1:t_1,:); DataTrain(t_2+1:m,:)];
                                      c2=c1;c4=c3;
                                      FunPara.c1=c1;FunPara.c2=c2;FunPara.c3=c3;FunPara.c4=c4;Energy.E1=E1;Energy.E2=E2;FunPara.kerfPara.type = 'lin';
                                      [err] = multiclass(Data,Data_test,FunPara,Energy);
                                      fprintf(file2, 'example file %s; err= %8.6g, part num= %8.6g,c1= %8.6g, c2= %8.6g,c3= %8.6g,c4= %8.6g,E1= %8.6g,E2= %8.6g\n', file,err,part,c1,c2,c3,c4,E1,E2);
                                      avgerr = avgerr + err;
                                      part=part+1;
                                end
                                fprintf(file2, 'example no: %s\t avgerr: %g\t c1=%g\t c2=%g c3=%g c4=%g E1=%g E2=%g \n',file, avgerr,c1,c2,c3,c4,E1,E2);
                                if (avgerr<min_err)
                                    min_c1 =c1;min_c2 =c2;min_c3 =c3;min_c4 =c4;
                                    min_err=avgerr;min_E1=E1;min_E2=E2;
                                end
                                end % for E1 values
                         end %for E2 values
                    end % for c3 values
                end %for c1 values    
%     final training
%    _______________________________________________________________________
    FunPara.c1=min_c1;FunPara.c2=min_c2;FunPara.c3=min_c3;FunPara.c4=min_c4;Energy.E1=min_E1;Energy.E2=min_E2;
    FunPara.kerfPara.type = 'lin';
    [err,result]=multiclass(Data,Data_test,FunPara,Energy);
    fprintf(file1,'example file: %s;err = %8.6g of %g,c1 = %8.6g,c2 = %8.6g c3=%8.6g, c4=%8.6g,E1= %8.6g,E2= %8.6g\n', file,err,length(Predict_Y),FunPara.c1,FunPara.c2,FunPara.c3,FunPara.c4,Energy.E1,Energy.E2)
end
   fclose(file1);fclose(file2);
    
%................complete code.....................................................................................................................%    
         

    
   
    
    