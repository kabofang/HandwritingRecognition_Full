load('MNISTData.mat');
load('..\IO\Arg.mat');
Data_rel_out=CNNTestProc(Data_test_in,W0,W1,W3,W4);
[~,Data_test_count]=size(Data_test_out);
[~,Data_test_out_01]=max(Data_test_out);
[~,Data_rel_out_01]=max(Data_rel_out);
j=1;
for i=1:10000
    if Data_test_out_01(:,i)~=Data_rel_out_01(:,i)
        Error(1,j)=i;
        [Error(2,j),~]=max(Data_rel_out_01(:,i));
        j=j+1;
    end
end
save('..\IO\Error.mat','Error');