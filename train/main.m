function R=main(a1,a2,alpha)
Cur_time=fix(clock);
fprintf('%.2d:%.2d:%.2d\n',Cur_time(4),Cur_time(5),Cur_time(6));
load('..\IO\MNISTData.mat');
EPOCH=1;
% W0=randn([5,5,a1]);
% W1=randn([3,3,a1,a2]);
W0=(2*rand(5,5,a1)-1);
W1=(2*rand(3,3,a1,a2)-1);
W3=(2*rand(100,5*5*a2)-1)/(5*5*a2/100);
W4=(2*rand(10,100)-1)/10;
for i=1:EPOCH
    [W0,W1,W3,W4]=CNNTrainProc(Data_train_in,Data_train_out,W0,W1,W3,W4,alpha); 
end
Data_rel_out=CNNTestProc(Data_test_in,W0,W1,W3,W4);
[~,Data_test_count]=size(Data_test_out);
[~,Data_test_out_01]=max(Data_test_out);
[~,Data_rel_out_01]=max(Data_rel_out);
Correct_count=sum(Data_rel_out_01==Data_test_out_01);
fprintf('Accuracy is %f\n',Correct_count/Data_test_count);
Cur_time=fix(clock); 
fprintf('%.2d:%.2d:%.2d\n',Cur_time(4),Cur_time(5),Cur_time(6));
R=0;
save('..\IO\Arg.mat','a2')
save('..\IO\Arg.mat','a1','-append')
save('..\IO\Arg.mat','alpha','-append')
save('..\IO\Arg.mat','W0','-append');
save('..\IO\Arg.mat','W1','-append');
save('..\IO\Arg.mat','W3','-append');
save('..\IO\Arg.mat','W4','-append');