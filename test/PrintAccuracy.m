function R=PrintAccuracy()
load('..\\IO\\MNISTData.mat');
load('..\\IO\\TestResult.mat');
[~,Data_test_count]=size(Data_test_out);
[~,Data_test_out_01]=max(Data_test_out);
[~,Data_rel_out_01]=max(Data_rel_out);
Correct_count=sum(Data_rel_out_01==Data_test_out_01);
fprintf('Accuracy is %f\n',Correct_count/Data_test_count);
end