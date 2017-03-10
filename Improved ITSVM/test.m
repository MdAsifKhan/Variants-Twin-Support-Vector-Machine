    clc;
    clear all;
    close all;
 for load_file = 4:4  
    switch load_file
        case 1
            file = 'tic'            
                    test_start = 672; c1 =1;
        case 2
            file = 'iono'           
                    test_start = 247;     c1 =  0.03125,c2 =  0.03125;
        case 3
             file = 'bupa'             
                    test_start = 242;c1 =      0.5,c2 =      0.5;   
        case 4
            file= 'votes'
                    test_start = 307;c1 =  0.0125,c2 =0.0125,c3 = 0.03125,c4 = 0.031250;
        case 5
            file= 'wpbc'           
                    test_start = 138;c1 =      0.5,c2 =      0.5;  
        case 6
            file= 'pima'           
                    test_start = 538;c1 =    0.125,c2 =    0.125;     
     
        case 7
           file= 'Ripley',       
                    test_start = 251;c1 =  0.03125,c2 =  0.03125;  
        case 8
           file= 'ndc1100',         
                    test_start = 771;c1 =        1,c2 =        1;     
        case 9
            file= 'cleve',
                    test_start = 178;c1 =  0.03125,c2 =  0.03125;     
        case 10
            file= 'ger',          
                    test_start = 801;c1 =    0.125,c2 =    0.125;    
        case 11
             file= 'aus',          
                    test_start = 541;c1 =  0.03125,c2 =  0.03125;  
        case 12
            file = 'haberman',
                    test_start = 201;c1 =        1,c2 =        1;  
        case 13
            file = 'transfusion',
                    test_start = 601; c1 =    0.125,c2 =    0.125;   
        case 14
            file = 'wdbc',
                    test_start = 501;   c1 =        1,c2 =        1;
             
        case 15
            file = 'splice',
                    test_start = 501;  c1 =      0.5,c2 =      0.5;
        case 16
            file = 'monk2',
                    test_start = 170; % its a special dataset, cant change test_size   
                    c1 =  0.03125,c2 =  0.03125;
        case 17
            file = 'monk3',
                    test_start = 123; % its a special dataset, cant change test_size   
                    c1 =    0.125,c2 =    0.125;
        case 18
            file = 'monks-1', % its a special dataset, cant change test_size
                    test_start = 125;  c1 =    0.125,c2 =    0.125;
        case 19
            file = 'heart-stat',
                    test_start = 201; c1 =    0.125,c2 =    0.125;
        case 20
            file= 'sonar', 
                    test_start = 151;  c1 =    0.125,c2 =    0.125;
        case 21
            file= 'cmc',
                    test_start = 1001; c1 =        1,c2 =        1;
        case 22
            file= 'crossplane150', 
                    test_start = 81;c1 =  0.03125,c2 =  0.03125;
        case 23
            file= 'Heart-c',          
                    test_start = 178; c1 =      0.5,c2 =      0.5;
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
    A =  load(strcat('G:\Digital Image Processing\Codes (Asif)\Project\Final Codes\Proposed Algorithm\Dataset\',file,'.txt') );
    m = size(A,1);    
    TestX = A(test_start:m,:);
    if test_start > 1
       DataTrain = A(1:test_start-1,:);        
    end  
    [m,n] = size(DataTrain);
    DataTrain(:,1:n-1) = scale (DataTrain(:, 1:n-1));
    TestX(:,1:n-1) = scale (TestX(:, 1:n-1));  
    FunPara.c1=c1;FunPara.c2=c2;FunPara.c3=c3;FunPara.c4=c4;
    FunPara.kerfPara.type = 'lin';
    [err,Predict_Y,A,B,x1,x2]= Improved_ITSVM(TestX,DataTrain,FunPara);
 end
 %................complete code.............................%    
                 

    
   
    
    