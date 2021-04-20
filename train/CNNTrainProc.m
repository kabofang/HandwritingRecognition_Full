function [R0,R1,R2,R3]=CNNTrainProc(Data_train_in,Data_train_out,W0,W1,W3,W4,alpha)
alpha
[~,Source_dim,Data_train_count]=size(Data_train_in);
[~,Conv_dim0,ConvK_count0]=size(W0);
[~,Conv_dim1,~,ConvK_count1]=size(W1);
Feat_dim0=Source_dim-Conv_dim0+1;
Feat_dim1=Feat_dim0/2-Conv_dim1+1;
Pooling_idx=2;
V0=zeros(Feat_dim0,Feat_dim0,ConvK_count0);
V11=zeros(Feat_dim1,Feat_dim1,ConvK_count0,ConvK_count1);
E0=zeros(Feat_dim0,Feat_dim0,ConvK_count0);
ET=zeros(Feat_dim0/2,Feat_dim0/2,ConvK_count0);
for i=1:Data_train_count
    E01=zeros(size(ET));
    V1=zeros(Feat_dim1,Feat_dim1,ConvK_count1);
    for j=1:ConvK_count0
        V0(:,:,j)=filter2(W0(:,:,j),Data_train_in(:,:,i),'valid');
    end
    Y0=max(0,V0);%24*24*20
    Y01=(Y0(1:2:end,1:2:end,:) ...
          +Y0(1:2:end,2:2:end,:) ...
          +Y0(2:2:end,1:2:end,:) ...
          +Y0(2:2:end,2:2:end,:))/(Pooling_idx*Pooling_idx);
    for j=1:ConvK_count1
        for k=1:ConvK_count0
            V11(:,:,k,j)=filter2(W1(:,:,k,j),Y01(:,:,k),'valid');
            V1(:,:,j)=V1(:,:,j)+V11(:,:,k,j);
        end
    end
     Y1=max(0,V1)/(ConvK_count0/2);
     Y2=(Y1(1:2:end,1:2:end,:) ...
          +Y1(1:2:end,2:2:end,:) ...
          +Y1(2:2:end,1:2:end,:) ...
          +Y1(2:2:end,2:2:end,:))/(Pooling_idx*Pooling_idx);
      y2=reshape(Y2,[],1); 
      v3=W3*y2;
      y3=max(0,v3);
      v4=W4*y3;
      y4=SoftMax(v4);
      e4=Data_train_out(:,i)-y4;
      delta4=e4;
      e3=W4'*delta4;
      delta3=(y3>0).*e3;
      e2=W3'*delta3;
      E2=reshape(e2,size(Y2));
      E1=zeros(size(Y1));
      Etemp=E2/4;
      E1(1:2:end,1:2:end,:)=Etemp;
      E1(1:2:end,2:2:end,:)=Etemp;
      E1(2:2:end,1:2:end,:)=Etemp;
      E1(2:2:end,2:2:end,:)=Etemp;
      DELTA1=(V1>0).*E1;
      for j=1:ConvK_count1
          WTemp=W1(:,:,:,j);
          for k=1:ConvK_count0
              WTemp1=flipud(fliplr(WTemp(:,:,k)));
              ET(:,:,k)=filter2(WTemp1,DELTA1(:,:,j),'full');
          end
          E01=E01+ET;
      end
      Etemp=E01/(4);
      E0(1:2:end,1:2:end,:)=Etemp;
      E0(1:2:end,2:2:end,:)=Etemp;
      E0(2:2:end,1:2:end,:)=Etemp;
      E0(2:2:end,2:2:end,:)=Etemp;
      DELTA0=(V0>0).*E0;
      dW4=alpha*delta4*y3';
      dW3=alpha*delta3*y2';
      dW1=zeros(size(W1));
      dW1Temp=zeros(Conv_dim1,Conv_dim1,ConvK_count0);
      for j=1:ConvK_count1
          for k=1:ConvK_count0
              dW1Temp(:,:,k)=filter2(DELTA1(:,:,j),Y01(:,:,k),'valid');
          end
          dW1(:,:,:,j)=alpha*dW1Temp;
      end
      dW0=zeros(size(W0));
      for j=1:ConvK_count0
        dW0(:,:,j)=alpha*filter2(DELTA0(:,:,j),Data_train_in(:,:,i),'valid');
      end
      W4=W4+dW4;
      W3=W3+dW3;
      W1=W1+dW1;
      W0=W0+dW0;
end
R0=W0;R1=W1;R2=W3;R3=W4;