clear all
close all

load KoNViD1k.mat % video names and MOS

pathKoNViD1k = "C:\Users\Public\QualityAssessment\KoNViD_1k_videos";

numVideos  = size(MOS, 1);
Features   = zeros(numVideos,126);

parfor i=1:numVideos
    if(mod(i,50)==0)
        disp(i);
    end
    videoName = Name{i};
    v = VideoReader( char(strcat(pathKoNViD1k, filesep, Name{i}, '.mp4')));
    videoDataGray = [];
    videoDataRGB  = {};
    ind = 1;
    while hasFrame(v)
        frameRGB = readFrame(v);
        frameGray= rgb2gray(frameRGB);
        videoDataGray(:,:,ind) = frameGray;
        videoDataRGB{ind}  = frameRGB;
        ind = ind + 1;
    end
    Features(i,:) = getFeatureVector(videoDataGray,videoDataRGB);
end

numberOfSplits = 1000;
PLCC = zeros(1,numberOfSplits); SROCC = zeros(1,numberOfSplits); KROCC = zeros(1,numberOfSplits);

parfor i=1:numberOfSplits
    rng(i);
    disp(i);
    
    p = randperm(numVideos);
    
    Data_1 = Features(p,:);
    Target = MOS(p);
    
    Train_1 = Data_1(1:round(numVideos*0.8),:);
    TrainLabel = Target(1:round(numVideos*0.8));
    
    Test_1  = Data_1(round(numVideos*0.8)+1:end,:);
    TestLabel = Target(round(numVideos*0.8)+1:end);   
   
    Mdl = fitrgp(Train_1, TrainLabel', 'KernelFunction', 'rationalquadratic', 'Standardize', true);
        
    Pred= predict(Mdl,Test_1);
    
    eval = metric_evaluation(Pred, TestLabel);
    PLCC(i) = eval(1);
    SROCC(i)= eval(2);
    KROCC(i)= eval(3);
end

disp('----------------------------------');
X = ['Median PLCC after 1000 random train-test splits: ', num2str(round(median(PLCC(:)),3))];
disp(X);
X = ['Median SROCC after 1000 random train-test splits: ', num2str(round(median(SROCC(:)),3))];
disp(X);
X = ['Median KROCC after 1000 random train-test splits: ', num2str(round(median(KROCC(:)),3))];
disp(X);

disp('----------------------------------');
X = ['Std PLCC after ', num2str(numberOfSplits), ' random train-test splits: ', num2str(round(std(PLCC(:)),3))];
disp(X);
X = ['Std SROCC after ', num2str(numberOfSplits),' random train-test splits: ', num2str(round(std(SROCC(:)),3))];
disp(X);
X = ['Std KROCC after ', num2str(numberOfSplits),' random train-test splits: ', num2str(round(std(KROCC(:)),3))];
disp(X);