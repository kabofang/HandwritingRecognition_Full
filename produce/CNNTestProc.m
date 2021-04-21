function R=CNNTestProc(Data_test_in,W0,W1,W3,W4)
[~,Source_dim,Data_test_count]=size(Data_test_in);
[~,Conv_dim0,ConvK_count0]=size(W0);
[~,Conv_dim1,~,ConvK_count1]=size(W1);
Feat_dim0=Source_dim-Conv_dim0+1;
Feat_dim1=Feat_dim0/2-Conv_dim1+1;
Pooling_idx=2;
Data_rel_out=zeros(10,Data_test_count);
V11=zeros(Feat_dim1,Feat_dim1,ConvK_count0,ConvK_count1);
for i=1:Data_test_count
    V1=zeros(Feat_dim1,Feat_dim1,ConvK_count1);
    V0=zeros(Feat_dim0,Feat_dim0,ConvK_count0);
    for j=1:ConvK_count0
        V0(:,:,j)=filter2(W0(:,:,j),Data_test_in(:,:,i),'valid');
    end
    Y0=max(0,V0);
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
          +Y1(2:2:end,2:2:end,:));
      y2=reshape(Y2,[],1);
      v3=W3*y2;
      y3=max(0,v3);
      v4=W4*y3;
      y4=SoftMax(v4);
      Data_rel_out(:,i)=y4;
end
R=Data_rel_out;