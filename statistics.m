

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

% a) pax cap vs. slenderness

paxseatssingle = table2array(acdata(:,"PaxSeatsSingleclass"));
slendernesses = table2array(acdata(:,"Fuse_FinessRatio"));
names = table2array(acdata(:,"Name"));

done = 0;
i = 1;
while done ~= 1
    if isnan(paxseatssingle(i)) || isnan(slendernesses(i))
        wsize = size(paxseatssingle);
        paxseatssingle = [paxseatssingle(1:i-1,:) ; paxseatssingle(i+1:wsize(1),:)];
        slendernesses = [slendernesses(1:i-1,:) ; slendernesses(i+1:wsize(1),:)];
        names = [names(1:i-1,:), ; names(i+1:wsize(1),:)];
    else
        i = i+1;
    end

    wsize = size(paxseatssingle);
    if i > wsize(1)
        done = 1;
    end
end

pfit = polyfit(paxseatssingle, slendernesses, 1)

slenderness_trend_std = std(slendernesses - polyval(pfit, paxseatssingle))

hold off
hold on
plot(paxseatssingle, polyval(pfit, paxseatssingle), 'b', 'LineWidth', 1)
plot(paxseatssingle, slendernesses, "ro", 'LineWidth', 1.25);
xlabel("Passenger Capacity (single class) [-]")
ylabel("Fuselage Slenderness Ratio [-]")
title("Fuselage Slenderness Ratio vs. Passenger Capacity (single class)")
legend('Linear Fit', 'Location', 'northwest')

dx = 15;
text(paxseatssingle+dx, slendernesses, names, 'FontSize', 8);


%% b) twr vs. wing loading

wloading = table2array(acdata(:,"Perf_Maxwingloadkgm2"));
twrs = table2array(acdata(:,"Perf_ThrustWeightRatio"));
names = table2array(acdata(:,"Name"));
nengs = table2array(acdata(:,"EngNumbersOf"));

% discard NaN rows
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

slenderness_trend_std = std(twr2 - polyval(pfit2, wloading))

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

dx = 10;
% text(wloading+dx, twrs, names, 'FontSize', 8);

%% Task 5

maxspeed = table2array(acdata(:,"Speed_Mno"));
thrust = table2array(acdata(:,"EngStaticThrustkN"));
names = table2array(acdata(:,"Name"));

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

pfit = polyfit(maxspeed, thrust, 1)

thrust_trend_std = std(thrust - polyval(pfit, maxspeed))

hold off
hold on
plot(maxspeed, polyval(pfit, maxspeed), 'r', 'LineWidth', 1)
plot(maxspeed, thrust, "ro", 'LineWidth', 0.75);
xlabel("Maximum Speed (Mno) [Mach]")
ylabel("Static Engine Thrust [kN]")
title("Static Engine Thrust vs. Maximum Speed")
legend('Linear Fit', 'Location', 'northwest')

dx = 0.005;
text(maxspeed+dx, thrust, names, 'FontSize', 8);



% plot(maxspeed, thrust, "bo");