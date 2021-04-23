function ret=main()
load('..\\IO\\MNISTData.mat');
addpath(genpath('..\\learn'));
addpath(genpath('..\\test'));
Learn(5,12,3,12,24,100,0.034,1);
Test();
PrintAccuracy();
WriteSomeForAnalysis();
end