%% 創建小型深度學習網路進行手寫數字分類-1

%% 載入影像資料
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet','nndemos', ...
    'nndatasets','DigitDataset');

digitData = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%% 從資料庫中顯示影像
figure;
perm = randperm(10000, 20);
for i = 1:20
    subplot(4,5,i);
    img = readimage(digitData, perm(i));
    imshow(img);
end

%% 確認每個分類中的影像數量
CountLabel = digitData.countEachLabel

%% 切割訓練與測試資料
trainingNumFiles = 750;
[trainDigitData,testDigitData] = splitEachLabel(digitData, ...
    trainingNumFiles, 'randomize');

%% 定義網路架構
% 這邊請用Deepnetwork design拉出一個與下方一樣的模型
% layers = [
%     imageInputLayer([28 28 1])
%     convolution2dLayer(5, 20)
%     reluLayer
%     maxPooling2dLayer(2, 'Stride', 2)
%     fullyConnectedLayer(10)
%     softmaxLayer
%     classificationLayer];

%% 設定訓練參數
options = trainingOptions(...
    'sgdm',...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 128,...
    'InitialLearnRate', 0.01,...
    'ExecutionEnvironment', 'auto',...
    'Plots', 'training-progress');

%% 訓練網路
convnet = trainNetwork(trainDigitData, layers_13, options);

%% 在測試影像中進行影像分類
predictedLabels  = classify(convnet, testDigitData);
valLabels  = testDigitData.Labels;

%% 計算精準度
accuracy = sum(predictedLabels == valLabels)/numel(valLabels)
