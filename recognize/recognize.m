function R=recognize(Source)
load('..\IO\Arg.mat');
[~,Source_dim]=size(Source);
[~,Conv_dim0,ConvK_count0]=size(W0);
[~,Conv_dim1,~,ConvK_count1]=size(W1);
Feat_dim0=Source_dim-Conv_dim0+1;
Feat_dim1=Feat_dim0/2-Conv_dim1+1;
Pooling_idx=2;
V11=zeros(Feat_dim1,Feat_dim1,ConvK_count0,ConvK_count1);
V1=zeros(Feat_dim1,Feat_dim1,ConvK_count1);
V0=zeros(Feat_dim0,Feat_dim0,ConvK_count0);
for j=1:ConvK_count0
    V0(:,:,j)=filter2(W0(:,:,j),Source,'valid');
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
      [~,R]=max(y4);
      R=mod(R,10);
end