clear all; close all; clc;
set(0, 'DefaultFigureWindowStyle', 'normal');
currentFolder = pwd;
addpath(genpath(pwd));
%
span = 0.075;
smoothMethod = 'sgolay'; % 'lowess', 'loess', 'sgolay', 'rlowess', 'rloess', 'moving'
%
rawFeatureStep = (1:1:20)';
trainingType = 'net'; % 'net'

if strcmp(trainingType, 'svm') 
    sheet = 'FS comparison (SVM)';
    xlRange = 'C4:P23';
elseif strcmp(trainingType, 'net') 
    sheet = 'FS comparison (NET)';
    xlRange = 'C112:P131'; 
end

rawAccuracy = xlsread('Feature engineering (not separated).xlsm', sheet, xlRange);
smoothFeatureStep = (1:0.1:20)';
interpRawAccuracy = interp1(rawFeatureStep, rawAccuracy, smoothFeatureStep, 'pchip');

numRows = size(interpRawAccuracy, 1);
numCols = size(interpRawAccuracy, 2); 
smoothAccuracy = zeros(numRows, numCols);
for i = 1:numCols
    rawAccuracyVector = interpRawAccuracy(:,i);
    smoothAccuracyVector = smooth(rawAccuracyVector, span, smoothMethod);
    smoothAccuracy(:,i) = smoothAccuracyVector;
end

DrawPlot(rawFeatureStep, rawAccuracy, smoothFeatureStep, smoothAccuracy);
%%
% Fitted curve
if size(rawAccuracy, 2) == 1
    f = fit(rawFeatureStep, rawAccuracy, 'smoothingspline');
    plot(f, rawFeatureStep, rawAccuracy);
    xlim([0 21]);
    ylim([0 1]);
end

%%
plot(rawFeatureStep, rawAccuracy,'--', smoothFeatureStep, smoothAccuracy, '-');
%%
function DrawPlot(Xraw, Yraw, Xsmooth, Ysmooth)
    % Create figure
    figure1 = figure;
    scrSz = get(0, 'Screensize');
    set(gcf, 'Position', scrSz, 'Color', 'w');
    % Create axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');

    % Create multiple lines using matrix input to plot 
    if size(Yraw, 2) == 1
        plot1 = plot(Xraw, Yraw*100, 'b.', Xsmooth, Ysmooth, 'r-');
        set(plot1(1),'DisplayName','Original data');
        set(plot1(2),'DisplayName','Smoothed data');
    elseif size(Yraw, 2) == 14
        plot1 = plot(Xsmooth, Ysmooth*100, 'LineWidth', 1.5, 'MarkerSize', 4, 'Parent', axes1);
        set(plot1(1),'DisplayName','ILFS');
        set(plot1(2),'DisplayName','INFS');
        set(plot1(3),'DisplayName','ECFS');
        set(plot1(4),'DisplayName','MRMR');
        set(plot1(5),'DisplayName','RFFS');
        set(plot1(6),'DisplayName','MIFS');
        set(plot1(7),'DisplayName','FSCM');
        set(plot1(8),'DisplayName','LSFS');
        set(plot1(9),'DisplayName','MCFS');
        set(plot1(10),'DisplayName','UDFS');
        set(plot1(11),'DisplayName','CFS');
        set(plot1(12),'DisplayName','BDFS');
        set(plot1(13),'DisplayName','OFS');
        set(plot1(14),'DisplayName','ADFS');
    end

    % Create ylabel
    textSize = 28;
    ylabel('Accuracy, %','FontSize',textSize);

    % Create xlabel
    xlabel('Number of features','FontSize',textSize);

    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[0 21]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[0 1]);
    box(axes1,'on');
    grid(axes1,'on');
    % Set the remaining axes properties
    set(axes1,'FontName','Times New Roman','FontSize',textSize,'XMinorGrid','on',...
        'YMinorGrid','off','ZMinorGrid','on');
    % Create legend
    legend1 = legend(axes1,'show');
    set(legend1,'FontSize',textSize,'EdgeColor',[0 0 0],'Location','best');

    ylim([0 100]);
    xlim([0 21]);
    grid on
    grid minor
    % grid toggles
%     title('PCHIP Interpolation');
end


