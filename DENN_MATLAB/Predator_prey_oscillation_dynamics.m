% DESCRIPTION: % This script replicates Figure 1 from the paper, which 
%   illustrates the results of our analysis. 
% AUTHOR: Bosi Hou

m_index = 3;
h_index = 3;



currTensorSize = [size(big_data,3), 2];
curr_tensor = big_data(m_index,h_index, :, :);
curr_tensor = squeeze(curr_tensor);

% As we want to show baseline plot, we use baseline_tensor
% Note this variable is computed from baseline_plot
% Make sure it can be used from the global environment



% ==================================================================

% 1. Create a new figure
figure;
% Define position vectors for each plot as [left, bottom, width, height]
position_plot1 = [0.05, 0.1, 0.6, 0.8];  % Adjust as needed
position_plot2 = [0.7, 0.55, 0.25, 0.35];  % Adjust as needed
position_plot3 = [0.7, 0.1, 0.25, 0.35];  % Adjust as needed


% 2. Plot 1: x-y oscillation plot
subplot(2, 2, [1, 3]); 
plot(baseline_tensor(:,1), baseline_tensor(:,2), 'LineWidth', 1.5);% Make line thicker
set(gca, 'FontSize', 14); % Increase font size for readability
grid on;

% Limit the number of ticks on the axes
y_lim_tick = 0.6;

set(gca, 'XTick', [0, 1]);
set(gca, 'YTick', [0, y_lim_tick]);
set(gca, 'YLim', [min(get(gca, 'YLim')) y_lim_tick]); % Ensure the Y axis limit includes 1

% Set YTickLabels. Get rid of the '0' of y
set(gca, 'YTickLabel', {'', '0.6'});




% Label axes
xlabel('Prey'); % Replace with your actual x-axis label
ylabel('Predator'); % Replace with your actual y-axis label

% Change default color of the line
% Here, 'Color' is set to red. Replace '[1 0 0]' with your desired RGB value.
% For example, '[0 0 1]' for blue, '[0 1 0]' for green, etc.

RGB = [0.26, 0.43, 0.78]; % Dark blue-gray

set(findall(gca, 'Type', 'Line'), 'Color', RGB);

ax1 = gca;  % Get handle for the current axes (plot 1)




% 3. Plot 2 and 3: x against t & y against t
time_series_length = 6000;

% 3.1 Create the time vector
time_step = 0.01;
t = 0:time_step:(time_series_length-1)*time_step;  % Assuming you start at t=0

% 3.2 Extract x and y from the data
x = baseline_tensor(1:time_series_length, 1);
y = baseline_tensor(1:time_series_length, 2);

% 3.3 Plot x against t
subplot(2, 2, 2);
plot(t, x, 'LineWidth', 1.5);

vertical_limit_x = 1;
set(gca, 'XTick', [0, time_series_length*0.01]); % because t = 10000 * 0.01 = 100
set(gca, 'YTick', [0, vertical_limit_x]);
set(gca, 'YLim', [min(get(gca, 'YLim')) vertical_limit_x]); 
xlabel('Time (t)');
ylabel('Prey (x)');
title('');

RGB = [0.26, 0.43, 0.78]; % Dark blue-gray

set(findall(gca, 'Type', 'Line'), 'Color', RGB);

ax2 = gca;  % Get handle for the current axes (plot 1)


% 3.4 Plot y against t
subplot(2, 2, 4);
plot(t, y, 'LineWidth', 1.5);
vertical_limit_y = 0.5;
set(gca, 'XTick', [0, time_series_length*0.01]);
set(gca, 'YTick', [0, vertical_limit_y]);
set(gca, 'YLim', [min(get(gca, 'YLim')) vertical_limit_y]); 
xlabel('Time (t)');
ylabel('Predator (y)');
title('');

ax3 = gca;  % Get handle for the current axes (plot 1)





% ===============================================================

% Adjust positions
ax1.Position = [0.1, 0.1, 0.6, 0.8];  % Top-left, larger
ax2.Position = [0.75, 0.55, 0.2, 0.35];  % Top-right, narrower
ax3.Position = [0.75, 0.1, 0.2, 0.35];  % Bottom-right, narrower




% Finally, save the entire figure as an SVG file
print('Figure_2', '-dsvg');
