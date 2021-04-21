load('..\IO\MNISTData.mat');
load('..\IO\Arg.mat');
Data_rel_out=CNNTestProc(Data_test_in,W0,W1,W3,W4);
[~,ConV1_dim,ConV_count1]=size(W0);
[~,ConV2_dim,~,ConV_count2]=size(W1);
[Data_dim,~,~]=size(Data_test_in);
[~,Data_test_count]=size(Data_test_out);
[~,Data_test_out_01]=max(Data_test_out);
[~,Data_rel_out_01]=max(Data_rel_out);
j=1;
featureindex=1;
for i=1:10000
    if Data_test_out_01(:,i)~=Data_rel_out_01(:,i)
        Error(1,j)=i;
        [Error(2,j),~]=max(Data_rel_out_01(:,i));
        j=j+1;
    end
end
for i=1:10000 
    if Data_test_out_01(:,i)==6
        featureindex=i;
        break
    end
end
Origin=Data_test_in(:,:,featureindex);
ConV1_feature=zeros(Data_dim+1-ConV1_dim,Data_dim+1-ConV1_dim,ConV_count1);
ConV2_feature=zeros((Data_dim+1-ConV1_dim)/2+1-ConV2_dim,(Data_dim+1-ConV1_dim)/2+1-ConV2_dim,ConV_count2);
for i=1:ConV_count1
    ConV1_feature(:,:,i)=filter2(W0(:,:,i),Data_test_in(:,:,featureindex),'valid');
    minvalue=min(min(ConV1_feature(:,:,i)));
    maxvalue=max(max(ConV1_feature(:,:,i)))-minvalue;
    ConV1_feature(:,:,i)=(ConV1_feature(:,:,i)-ones(Data_dim+1-ConV1_dim,Data_dim+1-ConV1_dim)*minvalue)... 
                                                                .*ones(Data_dim+1-ConV1_dim,Data_dim+1-ConV1_dim)*(255/maxvalue);
end
temp1=(ConV1_feature(1:2:end,1:2:end,:)+... 
        ConV1_feature(1:2:end,2:2:end,:)+... 
        ConV1_feature(2:2:end,1:2:end,:)+... 
        ConV1_feature(2:2:end,2:2:end,:))/4;
for i=1:ConV_count2
    temp2=zeros((Data_dim+1-ConV1_dim)/2+1-ConV2_dim,(Data_dim+1-ConV1_dim)/2+1-ConV2_dim);
    for j=1:ConV_count1
        temp2=temp2+filter2(W1(:,:,j,i),temp1(:,:,j),'valid');
    end
    minvalue=min(min(temp2));
    maxvalue=max(max(temp2))-minvalue;
    ConV2_feature(:,:,i)=(temp2-ones((Data_dim+1-ConV1_dim)/2+1-ConV2_dim,(Data_dim+1-ConV1_dim)/2+1-ConV2_dim)*minvalue)... 
                                      .*ones((Data_dim+1-ConV1_dim)/2+1-ConV2_dim,(Data_dim+1-ConV1_dim)/2+1-ConV2_dim)*(255/maxvalue);
end
save('..\IO\feature_6.mat','Origin');
save('..\IO\feature_6.mat','ConV1_feature','-append');
save('..\IO\feature_6.mat','ConV2_feature','-append');
save('..\IO\Error.mat','Error');