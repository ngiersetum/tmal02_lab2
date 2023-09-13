

%% Executable Section

% Load the data from the provided file as 'acdata'
load('data/actable.mat')

%% Task 2
%acdata_matrix = table2array(acdata);
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
[max_velocity] = max(acdata{:, 99});
index_fast = find(acdata{:, 99} == max_velocity);
min_velocity = min(acdata{:, 99});
index_slow = find(acdata{:, 99} == min_velocity);
ratio_t_w1 = acdata{index_fast, 87};
ratio_t_w2 = acdata{index_slow, 87};

% d) Which aircraft has the lowest fuel consumption per passenger (pax) kilometre?
%    Which one has the highest?
highest_fuel_ppx = max(acdata{:, 116});
index_high = find(acdata{:, 116} == highest_fuel_ppx);
lowest_fuel_ppx = min(acdata{:, 116});
index_low = find(acdata{:, 116} == lowest_fuel_ppx);


%% TASK 3

% a) Wing loading vs MTOW

mtows = table2array(acdata(:,"MTOW"));
wls = table2array(acdata(:,"Perf_Maxwingloadkgm2"));
names = table2array(acdata(:,"Name"));

pfit = polyfit(mtows, wls, 1)

wl_trend_std = std(wls - polyval(pfit, mtows))

hold on
plot(mtows, polyval(pfit, mtows), 'b', 'LineWidth', 1)
plot(mtows, wls, 'ro', 'LineWidth', 1.25);
xlabel("MTOW [kg]")
ylabel("Wing Loading [kg/m^2]")
title("Wing loading over MTOW")
legend('Linear Fit', 'Location', 'northwest')

dx = 8000;
text(mtows+dx, wls, names, 'FontSize', 8);

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

pfit = polyfit(wls, cvs, 1)

cv_trend_std = std(cvs - polyval(pfit, wls))

hold off
hold on
plot(wls, polyval(pfit, wls), 'b', 'LineWidth', 1)
plot(wls, cvs, "ro", 'LineWidth', 1.25);
xlabel("Wing Loading [kg/m^2]")
ylabel("Best Cruise Velocity [kts]")
title("Best Cruise Velocity vs. Wing Loading")
legend('Linear Fit', 'Location', 'northwest')

dx = 10;
text(wls+dx, cvs, names, 'FontSize', 8);

%% c) Relations

% i total fuel consumption - pax capacity

fuelcons = table2array(acdata(:,"Perf_Cruise_LR_Fuelconsumptionkgh"));
paxseatssingle = table2array(acdata(:,"PaxSeatsSingleclass"));

plot(fuelcons, paxseatssingle, "ro");

% CLEAR CORRELATION

% ii fuel cons per pax mile - max range

fuelconspax = table2array(acdata(:,"PerfIndex_Fuelpaxnmkg"));
maxranges = table2array(acdata(:,"Range_Maxfuelpayload"));

plot(fuelconspax, maxranges, "bo")

% NO CORRELATION

% iii fuel cons per pax mile - mtow

fuelconspax = table2array(acdata(:,"PerfIndex_Fuelpaxnmkg"));
mtows = table2array(acdata(:,"MTOW"));

plot(fuelconspax, mtows, "bo")

% NO CORRELATION


%% d) range vs maxfuel/MTOW

maxranges = table2array(acdata(:,"Range_Maxfuelpayload"));
fueltoratios = table2array(acdata(:,"MaxfuelMaxTO"));
names = table2array(acdata(:,"Name"));

% plot(maxranges, fueltoratios, "bo")

% CLEAR CORRELATION

done = 0;
i = 1;
while done ~= 1
    if isnan(maxranges(i)) || isnan(fueltoratios(i))
        wsize = size(maxranges);
        maxranges = [maxranges(1:i-1,:) ; maxranges(i+1:wsize(1),:)];
        fueltoratios = [fueltoratios(1:i-1,:) ; fueltoratios(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(maxranges);
    if i > wsize(1)
        done = 1;
    end
end

pfit = polyfit(maxranges, fueltoratios, 1)

cv_trend_std = std(fueltoratios - polyval(pfit, maxranges))

hold off
hold on
plot(maxranges, polyval(pfit, maxranges), 'b', 'LineWidth', 1)
plot(maxranges, fueltoratios, "ro", 'LineWidth', 1.25);
xlabel("Range [nm]")
ylabel("Max Fuel to MTOW [-]")
title("Max Fuel to MTOW vs. Range")
legend('Linear Fit', 'Location', 'northwest')

dx = 150;
text(maxranges+dx, fueltoratios, names, 'FontSize', 8);

%% Task 4