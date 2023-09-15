% Statistics Script
%   Calculations of different statistical correlations from an external
%   data set on different aircraft types.
%
%   Code should be run in isolated sections to obtain certain plots,
%   otherwise they will overwrite each other. As long as the first section
%   is run once to load in the data, every section can run in any order.
%
% References
%   Lab Data Set
%
% Authors
    liuID1 = "nikgi434"; % Niklas Gierse
    liuID2 = "leomu719"; % Leonhard Muehlstrasser
%
% License
%   This program is part of an academic exercise for the course TMAL02,
%   Linköping University, year 2023. The program is therefore free for 
%   non-commercial academic use.
%
% Code History
%   https://github.com/ngiersetum/tmal02_lab2
%
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
avg_wingload = average(1, 86)

% b) Which parameter has the lowest standard deviation?
%    Why? Makes it sense to specify the standard deviation for this parameter?
[smallest_Std, position] = min(Std);

% c) Which is the fastest aircraft in the table, which one is the slowest?
%    Do they have a difference in the thrust-to-weight ratio [N/N]?
[max_velocity] = max(acdata{:, "Speed_Mno"});
index_fast = find(acdata{:, "Speed_Mno"} == max_velocity);
min_velocity = min(acdata{:, "Speed_Mno"});
index_slow = find(acdata{:, "Speed_Mno"} == min_velocity);
ratio_t_w1 = acdata{index_fast, "Perf_ThrustWeightRatio"};
ratio_t_w2 = acdata{index_slow, "Perf_ThrustWeightRatio"};

% d) Which aircraft has the lowest fuel consumption per passenger (pax) kilometre?
%    Which one has the highest?
highest_fuel_ppx = max(acdata{:, "PerfIndex_Fuelpaxnmkg"});
index_high = find(acdata{:, "PerfIndex_Fuelpaxnmkg"} == highest_fuel_ppx);
lowest_fuel_ppx = min(acdata{:, "PerfIndex_Fuelpaxnmkg"});
index_low = find(acdata{:, "PerfIndex_Fuelpaxnmkg"} == lowest_fuel_ppx);


%% TASK 3

% a) Wing loading vs MTOW

mtows = table2array(acdata(:,"MTOW"));
wls = table2array(acdata(:,"Perf_Maxwingloadkgm2"));
names = table2array(acdata(:,"Name"));

% Trend Line
pfit = polyfit(mtows, wls, 1)

wl_trend_std = std(wls - polyval(pfit, mtows))

% Plotting
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

% Eliminate NaN rows
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

% Trend Line
pfit = polyfit(wls, cvs, 1)

cv_trend_std = std(cvs - polyval(pfit, wls))

% Plotting
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
names = table2array(acdata(:,"Name"));

% Eliminate NaN rows
done = 0;
i = 1;
while done ~= 1
    if isnan(fuelcons(i)) || isnan(paxseatssingle(i))
        wsize = size(fuelcons);
        fuelcons = [fuelcons(1:i-1,:) ; fuelcons(i+1:wsize(1),:)];
        paxseatssingle = [paxseatssingle(1:i-1,:) ; paxseatssingle(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(fuelcons);
    if i > wsize(1)
        done = 1;
    end
end

% Trend Line
pfit = polyfit(fuelcons, paxseatssingle, 1)

cv_trend_std = std(paxseatssingle - polyval(pfit, fuelcons))

% Plotting
hold off
hold on
plot(fuelcons, polyval(pfit, fuelcons), 'r', 'LineWidth', 1)
plot(fuelcons, paxseatssingle, "ro", 'LineWidth', 1.25);
xlabel("Total Fuel Consumption [kg/h]")
ylabel("Passenger Capacity (single class) [-]")
title("Passenger Capacity (single class) vs. Total Fuel Consumption")
legend('Linear Fit', 'Location', 'northwest')

dx = 200;
text(fuelcons+dx, paxseatssingle, names, 'FontSize', 8);
% CLEAR CORRELATION


% ii fuel cons per pax mile - max range

fuelconspax = table2array(acdata(:,"PerfIndex_Fuelpaxnmkg"));
maxranges = table2array(acdata(:,"Range_Maxfuelpayload"));

% plot(fuelconspax, maxranges, "bo")
% NO CORRELATION


% iii fuel cons per pax mile - mtow

fuelconspax = table2array(acdata(:,"PerfIndex_Fuelpaxnmkg"));
mtows = table2array(acdata(:,"MTOW"));

% plot(fuelconspax, mtows, "bo")
% NO CORRELATION


%% d) range vs maxfuel/MTOW

maxranges = table2array(acdata(:,"Range_Maxfuelpayload"));
fueltoratios = table2array(acdata(:,"MaxfuelMaxTO"));
names = table2array(acdata(:,"Name"));

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

fuelratio_trend_std = std(fueltoratios - polyval(pfit, maxranges))

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

% a) pax cap vs. slenderness, divided by seats configuration

paxseatssingle = table2array(acdata(:,"PaxSeatsSingleclass"));
slendernesses = table2array(acdata(:,"Fuse_FinessRatio"));
names = table2array(acdata(:,"Name"));
abreast = table2array(acdata(:,"Abreast"));

% Eliminate NaN rows
done = 0;
i = 1;
while done ~= 1
    if isnan(paxseatssingle(i)) || isnan(slendernesses(i)) || isnan(abreast(i))
        wsize = size(paxseatssingle);
        paxseatssingle = [paxseatssingle(1:i-1,:) ; paxseatssingle(i+1:wsize(1),:)];
        slendernesses = [slendernesses(1:i-1,:) ; slendernesses(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
        abreast = [abreast(1:i-1,:), ; abreast(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(paxseatssingle);
    if i > wsize(1)
        done = 1;
    end
end

% Split datasets by number of seats abreast
sld3 = slendernesses;
sld4 = slendernesses;
sld5 = slendernesses;
sld6 = slendernesses;
sld8 = slendernesses;
sld9 = slendernesses;
sld10 = slendernesses;

len = size(abreast);

for i=1:len(1)
    sld3(i) = nan;
    sld4(i) = nan;
    sld5(i) = nan;
    sld6(i) = nan;
    sld8(i) = nan;
    sld9(i) = nan;
    sld10(i) = nan;

    if abreast(i) == 3
        sld3(i) = slendernesses(i);
    elseif abreast(i) == 4
        sld4(i) = slendernesses(i);
    elseif abreast(i) == 5
        sld5(i) = slendernesses(i);
    elseif abreast(i) == 6
        sld6(i) = slendernesses(i);
    elseif abreast(i) == 8
        sld8(i) = slendernesses(i);
    elseif abreast(i) == 9
        sld9(i) = slendernesses(i);
    else
        sld10(i) = slendernesses(i);
    end
end

% Create trend lines for each category
ps3fit = [];
sl3fit = [];
ps4fit = [];
sl4fit = [];
ps5fit = [];
sl5fit = [];
ps6fit = [];
sl6fit = [];
ps8fit = [];
sl8fit = [];
ps9fit = [];
sl9fit = [];
ps10fit = [];
sl10fit = [];


for i=1:len(1)
    if ~isnan(sld3(i))
        ps3fit = [ps3fit; paxseatssingle(i)];
        sl3fit = [sl3fit; sld3(i)];
    elseif ~isnan(sld4(i))
        ps4fit = [ps4fit; paxseatssingle(i)];
        sl4fit = [sl4fit; sld4(i)];
    elseif ~isnan(sld5(i))
        ps5fit = [ps5fit; paxseatssingle(i)];
        sl5fit = [sl5fit; sld5(i)];
    elseif ~isnan(sld6(i))
        ps6fit = [ps6fit; paxseatssingle(i)];
        sl6fit = [sl6fit; sld6(i)];
    elseif ~isnan(sld8(i))
        ps8fit = [ps8fit; paxseatssingle(i)];
        sl8fit = [sl8fit; sld8(i)];
    elseif ~isnan(sld9(i))
        ps9fit = [ps9fit; paxseatssingle(i)];
        sl9fit = [sl9fit; sld9(i)];
    else
        ps10fit = [ps10fit; paxseatssingle(i)];
        sl10fit = [sl10fit; sld10(i)];
    end
end

pfit3 = polyfit(ps3fit, sl3fit, 1)
pfit4 = polyfit(ps4fit, sl4fit, 1)
pfit5 = polyfit(ps5fit, sl5fit, 1)
pfit6 = polyfit(ps6fit, sl6fit, 1)
pfit8 = polyfit(ps8fit, sl8fit, 1)
pfit9 = polyfit(ps9fit, sl9fit, 1)
pfit10 = polyfit(ps10fit, sl10fit, 1)


% Plot trend lines and data
hold off
hold on
plot(ps3fit, polyval(pfit3, ps3fit), 'Color', "#0072BD", 'LineWidth', 1)
plot(ps4fit, polyval(pfit4, ps4fit), 'Color', "#D95319", 'LineWidth', 1)
plot(ps5fit, polyval(pfit5, ps5fit), 'Color', "#EDB120", 'LineWidth', 1)
plot(ps6fit, polyval(pfit6, ps6fit), 'Color', "#7E2F8E", 'LineWidth', 1)
plot(ps8fit, polyval(pfit8, ps8fit), 'Color', "#77AC30", 'LineWidth', 1)
plot(ps9fit, polyval(pfit9, ps9fit), 'Color', "#4DBEEE", 'LineWidth', 1)
plot(ps10fit, polyval(pfit10, ps10fit), 'Color', "#A2142F", 'LineWidth', 1)
scatter(paxseatssingle, sld3, 'Color', "#0072BD", 'LineWidth', 1.25);
scatter(paxseatssingle, sld4, 'Color', "#D95319", 'LineWidth', 1.25);
scatter(paxseatssingle, sld5, 'Color', "#EDB120", 'LineWidth', 1.25);
scatter(paxseatssingle, sld6, 'Color', "#7E2F8E", 'LineWidth', 1.25);
scatter(paxseatssingle, sld8, 'Color', "#77AC30", 'LineWidth', 1.25);
scatter(paxseatssingle, sld9, 'Color', "#4DBEEE", 'LineWidth', 1.25);
scatter(paxseatssingle, sld10, 'Color', "#A2142F", 'LineWidth', 1.25);

xlabel("Passenger Capacity (single class) [-]")
ylabel("Fuselage Slenderness Ratio [-]")
title("Fuselage Slenderness Ratio vs. Passenger Capacity (single class)")
legend('3 abreast', '4 abreast', '5 abreast', '6 abreast', '8 abreast', '9 abreast', '10 abreast', 'Location', 'northwest')

% Data labels
dx = 12;
text(paxseatssingle+dx, slendernesses, names, 'FontSize', 8);


%% b) twr vs. wing loading

wloading = table2array(acdata(:,"Perf_Maxwingloadkgm2"));
twrs = table2array(acdata(:,"Perf_ThrustWeightRatio"));
names = table2array(acdata(:,"Name"));
nengs = table2array(acdata(:,"EngNumbersOf"));

% Eliminate NaN rows
done = 0;
i = 1;
while done ~= 1
    if isnan(wloading(i)) || isnan(twrs(i))
        wsize = size(wloading);
        wloading = [wloading(1:i-1,:) ; wloading(i+1:wsize(1),:)];
        twrs = [twrs(1:i-1,:) ; twrs(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
        nengs = [nengs(1:i-1,:), ; nengs(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(wloading);
    if i > wsize(1)
        done = 1;
    end
end

% Split datasets by number of engines
twr2 = twrs;
twr3 = twrs;
twr4 = twrs;

len = size(nengs);

for i=1:len(1)
    twr2(i) = nan;
    twr3(i) = nan;
    twr4(i) = nan;
    if nengs(i) == 2
        twr2(i) = twrs(i);
    elseif nengs(i) == 3
        twr3(i) = twrs(i);
    else
        twr4(i) = twrs(i);
    end
end

% Create trend lines for each category
wl2fit = [];
tw2fit = [];
wl3fit = [];
tw3fit = [];
wl4fit = [];
tw4fit = [];

for i=1:len(1)
    if ~isnan(twr2(i))
        wl2fit = [wl2fit; wloading(i)];
        tw2fit = [tw2fit; twr2(i)];
    elseif ~isnan(twr3(i))
        wl3fit = [wl3fit; wloading(i)];
        tw3fit = [tw3fit; twr3(i)];
    else
        wl4fit = [wl4fit; wloading(i)];
        tw4fit = [tw4fit; twr4(i)];
    end
end

pfit2 = polyfit(wl2fit, tw2fit, 1)
pfit3 = polyfit(wl3fit, tw3fit, 1)
pfit4 = polyfit(wl4fit, tw4fit, 1)

% Plot everything
hold off
hold on
plot(wl2fit, polyval(pfit2, wl2fit), 'r', 'LineWidth', 1)
plot(wl3fit, polyval(pfit3, wl3fit), 'g', 'LineWidth', 1)
plot(wl4fit, polyval(pfit4, wl4fit), 'b', 'LineWidth', 1)
plot(wloading, twr2, "ro", 'LineWidth', 1.25);
plot(wloading, twr3, "go", 'LineWidth', 1.25);
plot(wloading, twr4, "bo", 'LineWidth', 1.25);
xlabel("Wing Loading [kg/m^2]")
ylabel("Thrust to Weight Ratio [-]")
title("Thrust to Weight Ratio vs. Wing Loading")
legend('2 engines', '3 engines', '4 engines', 'Location', 'northwest')

% Data labels
dx = 10;
% text(wloading+dx, twrs, names, 'FontSize', 8);

%% Task 5

maxspeed = table2array(acdata(:,"Speed_Mno"));
thrust = table2array(acdata(:,"EngStaticThrustkN"));
names = table2array(acdata(:,"Name"));

% Eliminate NaN rows
done = 0;
i = 1;
while done ~= 1
    if isnan(maxspeed(i)) || isnan(thrust(i))
        wsize = size(maxspeed);
        maxspeed = [maxspeed(1:i-1,:) ; maxspeed(i+1:wsize(1),:)];
        thrust = [thrust(1:i-1,:) ; thrust(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(maxspeed);
    if i > wsize(1)
        done = 1;
    end
end

% Generate trend line
pfit = polyfit(maxspeed, thrust, 1)

thrust_trend_std = std(thrust - polyval(pfit, maxspeed))

% Plot the stuff
hold off
hold on
plot(maxspeed, polyval(pfit, maxspeed), 'r', 'LineWidth', 1)
plot(maxspeed, thrust, "ro", 'LineWidth', 0.75);
xlabel("Maximum Speed (Mno) [Mach]")
ylabel("Static Engine Thrust [kN]")
title("Static Engine Thrust vs. Maximum Speed")
legend('Linear Fit', 'Location', 'northwest')

% Data labels
dx = 0.005;
text(maxspeed+dx, thrust, names, 'FontSize', 8);



% plot(maxspeed, thrust, "bo");