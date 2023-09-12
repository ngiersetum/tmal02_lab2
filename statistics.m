

%% Executable Section

% Load the data from the provided file as 'acdata'
load('data/actable.mat')

%% Task 2
% Averages
average1 = mean(acdata{:, 4:17}, 'omitnan');
average2 = mean(acdata{:, 20:56}, 'omitnan');
average3 = mean(acdata{:, 58:117}, 'omitnan');
average = [average1, nan, nan, average2, nan, average3];

% Standard deviations

Std1 = std(acdata{:, 4:17}, 'omitnan');
Std2 = std(acdata{:, 20:56}, 'omitnan');
Std3 = std(acdata{:, 58:117}, 'omitnan');
Std = [Std1, nan, nan, Std2, nan, Std3];

% a) What is the average wing-loading in [kg/m2]?
avg_wingload = average(1, 86);

% b) Which parameter has the lowest standard deviation?
%    Why? Makes it sense to specify the standard deviation for this parameter?
[smallest_Std, position] = min(Std);

% c) Which is the fastest aircraft in the table, which one is the slowest?
%    Do they have a difference in the thrust-to-weight ratio [N/N]?
[max_velocity, index_fast] = max(acdata{:, 98});
[min_velocity, index_slow] = min(acdata{:, 98});

ratio_t_w1 = acdata{index_fast, 87};
ratio_t_w2 = acdata{index_slow, 87};

% d) Which aircraft has the lowest fuel consumption per passenger (pax) kilometre?
%    Which one has the highest?
[highest_fuel_ppx, index_high] = max(acdata{:, 116});
[lowest_fuel_ppx, index_low] = min(acdata{:, 116});
%% Task 3


%% Task 4