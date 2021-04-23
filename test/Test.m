function R=test()
load('..\\IO\\MNISTData.mat');
load('..\\IO\\Arg.mat');

addpath(genpath('..\\share'))
VALID=0;
FULL=2;
[~,DataInDim,DataInCount]=size(Data_test_in);
Feature2Dim=(DataInDim+1-Dim1)/2+1-Dim2;
[~,~,Count21,~]=size(W2);

V2=zeros(Feature2Dim,Feature2Dim,Count22);
Data_rel_out=zeros(10,DataInCount);

for j=1:DataInCount
    X=Data_test_in(:,:,j);
    V0=Conv_2R(X,W0,VALID,2,3);
    Y0=max(0,V0);
    Y1=Pooling(Y0);%12*12*12
    for k=1:Count22
        for p=1:Count21
            TempW2(:,:,p)=rot90(W2(:,:,Count21+1-p,k),2);
        end
        V2(:,:,k)=convn(Y1,TempW2,'valid');
    end
    Y2=max(0,(V2/(Count21)));
    Y3=Pooling(Y2);
    Y3_=reshape(Y3,[],1);
    V4=W4*Y3_;
    Y4=max(0,V4);
    V5=W5*Y4;
    Data_rel_out(:,j)=SoftMax(V5);
end
save('..\\IO\\TestResult.mat','Data_rel_out');