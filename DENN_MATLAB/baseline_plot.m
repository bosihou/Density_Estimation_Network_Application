% DESCRIPTION: This file provides a script for simulating predator-prey 
%   oscillations using the Rosenzweig-MacArthur equations.
% AUTHOR: Bosi Hou

n = 500000; % number of iterations

% Initializing vectors
x = zeros(n,1);
y = zeros(n,1);
x(1,1) = 0.1;
y(1,1) = 0.02;

% Initializing tensor
data_tensor = zeros(n,2,20);



%testing purpose
T_track = zeros(n,1);
M_track = zeros(n,1);



r_bar = 1; k_bar = 1; a_bar = 2; h_bar = 0.35; b_bar = 0.5; m_bar = 0.35;
% baseline values
% a = 2; b = 0.5; k = 1 will not change


r = 1; k = 1; a = 2; h = 0.35; b = 0.5; m = 0.35;
%initialize parameters
dt = 0.01;
% time step
sqrt_dt = sqrt(dt);




dr = 0;
% noise of r
dh = 0;
% noise of h
gamma = 1;
% speed of adjustment to mean p bar
sigma = 0.1;
% sd of CIR process
% When sd is small, graphs are stable; when sd approaches to 0.3, it gets
% more and more unstable
% In the jpeg graph, we use sigma = 0.10




rng('default');
rng(1);
epsilon = randn(n,3); % epsilon ~ N(0,1)
% seeded random number generator







M = zeros(1,5);
for q = 1:5
    M(1,q) = 0.2 + 0.1 * (q-1);
end





H = k * (a*b - M) ./ (a*b +M);
% upper bound of h; Actual h shall not exceed such value

num_of_m = numel(M);


lb_h = 0.2;
% Suppose h is always greater than 0.2





figure;




x(1,1) = 0.1;
y(1,1) = 0.02;

curr_tensor = zeros(n,2);

curr_tensor(1,1) = x(1,1);
curr_tensor(1,2) = y(1,1);

for i = 2:n
    currx = x(i-1,1); curry = y(i-1,1);

    dr = gamma * (r_bar - r) * dt + sigma * sqrt(r) * epsilon(i,1) * sqrt_dt;
    r = r + dr;
    dh = gamma * (h_bar - h) * dt + sigma * sqrt(h) * epsilon(i,2) * sqrt_dt;
    h = h + dh;
    dm = gamma * (m_bar - m) * dt + sigma * sqrt(m) * epsilon(i,3) * sqrt_dt;
    m = m + dm;


    x(i,1) = (r * currx * (1 - currx/k) - a * currx * curry / (currx + h)) * dt + currx;
    y(i,1) = (a*b*currx*curry / (currx + h) - m*curry)*dt + curry;
    
    curr_tensor(i,1) = x(i,1);
    curr_tensor(i,2) = y(i,1);

    if i < 1000 
        disp(curr_tensor(i,:));
    end

    
end

baseline_tensor = [x, y]; % Use in global environment




plot(x(:,1), y(:,1), 'LineWidth', 1.5); % Make line thicker
set(gca, 'FontSize', 14); % Increase font size for readability
grid on;

% Limit the number of ticks on the axes
set(gca, 'XTick', [0, 1]);
set(gca, 'YTick', [0, 0.75]);
set(gca, 'YLim', [min(get(gca, 'YLim')) 0.75]); % Ensure the Y axis limit includes 1



% Set YTickLabels
set(gca, 'YTickLabel', {'', '0.75'});

% Label axes
xlabel('prey'); % Replace with your actual x-axis label
ylabel('predator'); % Replace with your actual y-axis label

% Change default color of the line
% Here, 'Color' is set to red. Replace '[1 0 0]' with your desired RGB value.
% For example, '[0 0 1]' for blue, '[0 1 0]' for green, etc.

RGB = [0.26, 0.43, 0.78]; % Dark blue-gray

set(findall(gca, 'Type', 'Line'), 'Color', RGB);

% Save the figure
print('MyFigure','-dsvg');
