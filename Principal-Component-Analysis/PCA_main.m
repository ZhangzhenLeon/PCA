%导入数据
clc
clear all
A=xlsread('data');

%z-score标准化处理
corporationNumber=size(A,1);
variableNumber=size(A,2);
for i=1:variableNumber
    SA(:,i)=(A(:,i)-mean(A(:,i)))./std(A(:,i));
end

%计算协方差矩阵的特征值和特征向量，并由大到小排序
relativeCoefficientMatrix=corrcoef(SA);
[eigenVector,eigenValueDig]=eig(relativeCoefficientMatrix);%计算特征值和特征向量
for j=1:variableNumber
    eigenValue(j,1)=eigenValueDig(j,j);
end
eigenValue=sort(eigenValue,'descend');
disp("特征值从大到小排列结果")
eigenValue

%计算排序后的主成分的贡献率以及累计贡献率
for k=1:variableNumber
    contributionRateOfEachEigenValue=eigenValue(k,1)/sum(eigenValue);
    accumulativeContributionRate(k,1)=sum(eigenValue(1:k,1))/sum(eigenValue);
end

%设置主成分信息保留率
pcaInformationRetensionRatio=0.9;
%统计在满足主成分保留率的主成分的数量。
for l=1:variableNumber
    if accumulativeContributionRate(l,1)>pcaInformationRetensionRatio;
        mainComponentNumber=l;
        break;
    end
end
%截取主成分对应的特征向量
for ii=1:mainComponentNumber
    mainComponentBasedVector(:,ii)=eigenVector(:,variableNumber+1-ii);
end

disp("降维后得到的主成分变量")
scoreMatrix=SA*mainComponentBasedVector
scatter(scoreMatrix(:,1),scoreMatrix(:,2))

%计算最终的公司的总打分，finalScoreMatrix的第一列为打分值，第二列为公司序号。
for jj=1:corporationNumber
    finalScoreMatrix(jj,1)=sum(scoreMatrix(jj,:));
    finalScoreMatrix(jj,2)=jj;
end
%对打分矩阵按照分数那一列进行降序排列
finalScoreMatrix=sortrows(finalScoreMatrix,-1);
disp('the final result is: ')
finalScoreMatrix








