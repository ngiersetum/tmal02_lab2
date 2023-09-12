

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


%% TASK 3

% a) Wing loading vs MTOW

mtows = table2array(wl_vs_mtow(:,"MTOW"));
wls = table2array(wl_vs_mtow(:,"Perf_Maxwingloadkgm2"));

pfit = polyfit(mtows, wls, 1);

wl_trend_std = std(wls - polyval(pfit, mtows));

hold on
plot(mtows, wls, 'ro');
plot(mtows, polyval(pfit, mtows), 'b')
xlabel("MTOW [kg]")
ylabel("Max Wing Loading [kg/m^2]")
title("Wing loading over MTOW")

%% b) Cruise velocity vs wing loading

wls = table2array(acdata(:,"Perf_Maxwingloadkgm2"));
cvs = table2array(acdata(:,"Perf_Cruise_LR_Speedkt"));
names = table2array(acdata(:,"Name"));

done = 0;
i = 1;
while done ~= 1
    if isnan(wls(i)) || isnan(cvs(i))
        wsize = size(wls);
        wls = [wls(1:i-1,:) ; wls(i+1:wsize(1),:)];
        cvs = [cvs(1:i-1,:) ; cvs(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(wls);
    if i > wsize(1)
        done = 1;
    end
end

pfit = polyfit(wls, cvs, 1);

wl_trend_std = std(cvs - polyval(pfit, wls));

hold off
hold on
plot(wls, cvs, "ro", 'LineWidth', 1.5);
plot(wls, polyval(pfit, wls), 'b')
xlabel("Max Wing Loading [kg/m^2]")
ylabel("Best Cruise Velocity [kts]")
ylabel("Wind loading over Best Cruise Velocity")

dx = 4;
text(wls+dx, cvs, names, 'FontSize', 8);

%% c) Relations

% i total fuel consumption - pax capacity



% ii fuel cons per pax mile - max range

% iii fuel cons per pax mile - mtow


%% Task 4