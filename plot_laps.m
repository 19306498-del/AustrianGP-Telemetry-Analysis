%% Load lap data exported from Python/FastF1
data = readtable('austria_2026_laps.csv');

% List of drivers and colours to match (RGB triplets, 0-1 scale)
drivers = {'RUS', 'VER', 'ANT', 'PIA', 'HAM'};
colors = [
    0.00  0.82  0.75;   % RUS - teal
    0.02  0.00  0.94;   % VER - blue
    0.15  0.96  0.82;   % ANT - light teal
    1.00  0.50  0.00;   % PIA - orange
    0.88  0.02  0.00;   % HAM - red
];

%% --- CHART 1: Lap Time Evolution (3-lap rolling average) ---
figure;
hold on;

for i = 1:length(drivers)
    driverName = drivers{i};

    % filter rows for this driver only
    driverRows = strcmp(data.Driver, driverName);
    lapNumbers = data.LapNumber(driverRows);
    lapTimes = data.LapTimeSeconds(driverRows);

    % sort by lap number just in case
    [lapNumbers, sortIndex] = sort(lapNumbers);
    lapTimes = lapTimes(sortIndex);

    % 3-lap rolling average using MATLAB's built-in movmean
    rollingAvg = movmean(lapTimes, 3);

    plot(lapNumbers, rollingAvg, 'Color', colors(i,:), 'LineWidth', 2, ...
        'DisplayName', driverName);
end

xlabel('Lap Number');
ylabel('Lap Time - 3 lap rolling average (s)');
title('Austrian GP 2026 - Lap Time Evolution');
legend('show');
grid on;
hold off;

%% --- CHART 2: Driver Consistency (box plot) ---
figure;

% boxplot needs the values and a matching group label per value
boxplot(data.LapTimeSeconds, data.Driver);

xlabel('Driver');
ylabel('Representative lap time (s)');
title('Austrian GP 2026 - Driver Consistency');
grid on;

fprintf('%-6s %-12s %-10s %-10s\n' , 'Driver', 'FastestAvg' , 'Median' , 'Spread(IQR)')
for i = 1:length(drivers)
    driverName = drivers{i};
    driverRows = strcmp(data.Driver , driverName);
    lapNumbers = data.LapNumber(driverRows);
    [lapNumbers, sortIndex] = sort(lapNumbers);
    lapTimes = lapTimes(sortIndex);
    rollingAvg = movmean(lapTimes, 3);
    
    [minTime, minIndex] = min(rollingAvg);
    medianTime = median(lapTimes);
    iqrTime = iqr(lapTimes);
    
    fprintf('%-6s %-12.2f %-10.2f %-10.2f (fastest avg lap at %d)\n',...
        driverName, minTime, medianTime, iqrTime, lapNumbers(minIndex));
end

