

%% Executable Section

% Load the data from the provided file as 'acdata'
load('data/actable.mat')

%% Task 2
% Averages
average1 = mean(acdata{:, 4:17}, 'omitnan');
average2 = mean(acdata{:, 20:56}, 'omitnan');
average3 = mean(acdata{:, 58:117}, 'omitnan');
average = [average1, average2, average3];

% Standard deviations

Std1 = std(acdata{:, 4:17}, 'omitnan');
Std2 = std(acdata{:, 20:56}, 'omitnan');
Std3 = std(acdata{:, 58:117}, 'omitnan');
Std = [Std1, Std2, Std3]

% a) Average wingload in kg/m^2
%avg_wingload = average(1, 83);

% b) parameter with lowest standard deviation
%[smallest_Std, position] = min(Std)
%% Task 3


%% Task 4