function R=learn(Dim1,Count1,Dim2,Count21,Count22,Full1Dim,Alpha,EPOCH)
VALID=0;
FULL=2;
load('..\\IO\\MNISTData.mat');
addpath(genpath('..\\share'));

[~,DataInDim,DataInCount]=size(Data_train_in);
Feature2Dim=(DataInDim+1-Dim1)/2+1-Dim2;
FullinDim=(Feature2Dim/2)*(Feature2Dim/2)*Count22*(Count1/Count21);

for i=1:4
    W0=randn([Dim1,Dim1,Count1]);
    W2=randn([Dim2,Dim2,Count21,Count22]);
    %W0=2*rand(Dim1,Dim1,Count1)-1;
    %W2=2*rand(Dim2,Dim2,Count21,Count22)-1;
    W4=(2*rand(Full1Dim,FullinDim)-1)/(FullinDim/Full1Dim);
    W5=(2*rand(10,Full1Dim)-1)/(Full1Dim/10);
end

V2=zeros(Feature2Dim,Feature2Dim,Count22);
Delta2_Y1=zeros(size(W2));
TempW2=zeros(Dim2,Dim2,Count21);

for i=1:EPOCH
    for j=1:DataInCount
        X=Data_train_in(:,:,j);
        V0=Conv_2R(X,W0,VALID,2,3);%5*5*12,28*28
        Y0=max(0,V0);%24*24*12
        Y1=Pooling(Y0);%12*12*12
        for k=1:Count22
            for p=1:Count21
                TempW2(:,:,p)=rot90(W2(:,:,Count21+1-p,k),2);
            end
            V2(:,:,k)=convn(Y1,TempW2,'valid');%3*3*12*24,12*12*12
        end
        Y2=max(0,(V2/(Count21)));%10*10*24
        Y3=Pooling(Y2);
        Y3_=reshape(Y3,[],1);
        V4=W4*Y3_;
        Y4=max(0,V4);
        V5=W5*Y4;
        Y=SoftMax(V5);
        
        E5=Data_train_out(:,j)-Y;
        Delta5=E5;
        E4=W5'*E5;
        Delta4=(Y4>0).*E4;
        E3_=W4'*Delta4;
        E3=reshape(E3_,size(Y3));
        E2=PoolingR(E3);
        Delta2=(Y2>0).*E2;
        E1=zeros((DataInDim+1-Dim1)/2,(DataInDim+1-Dim1)/2,Count1);
        for k=1:Count22
            E1=E1+Conv_2R(Delta2(:,:,k),W2(:,:,:,k),FULL,2,3);
        end%10*10*24  ,  3*3*12*24,   12*12*12
        E0=PoolingR(E1);
        Delta0=(Y0>0).*E0;
        
        for k=1:Count22
            Delta2_Y1(:,:,:,k)=Conv_2R(Y1,Delta2(:,:,k),VALID,1,3);%12*12*12,10*10*24,-----3*3*12*24
        end
        Delta0_DataIn=Conv_2R(X,Delta0,VALID,2,3);%24*24*12,28,28-----5*5*12
        
        W0=W0+Alpha*Delta0_DataIn;
        W2=W2+Alpha*Delta2_Y1;
        W4=W4+Alpha*Delta4*Y3_';
        W5=W5+Alpha*Delta5*Y4';
    end
end
save('..\\IO\\Arg.mat','W0','W2','W4','W5','Dim1','Count1','Dim2','Count21','Count22','Full1Dim','Alpha','EPOCH');
R=1;
end