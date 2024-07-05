% DESCRIPTION: This script demonstrates the process of preparing the training 
%   data required for the neural network. It also details the steps to reproduce 
%   the 5-by-5 plot as shown in the associated paper. The script generates a 
%   dataset, referred to as 'big_data', which will subsequently be utilized by 
%   the 'Poincare_section.m' script. The 'Poincare_section.m' script extracts 
%   [X, Y, T] features from 'big_data', essential for training the neural 
%   network model.
% AUTHOR: Bosi Hou


% =================== Initial setting =====================

clear big_data; % big_data is our data file
clear length; % length is the size of our data file


n = 500000; % number of steps in generating numerical version of ODE


% Grid size determines how fine you want the data. 
% For replicating the 5-by-5 oscillation plot in the paper, use grid_size = 0.1
grid_size = 0.1; 
if grid_size == 0.1
    length = 5;
elseif grid_size == 0.02
    length = 21;
end 


% Initialize the "big_data" variable. The data struture is a tensor
tensorSize = [length, length, n, 2];
big_data = zeros(tensorSize);

% ===========================================================







r_bar = 1; k_bar = 1; a_bar = 2; b_bar = 0.5; % Specify parameter baseline values. a = 2; b = 0.5; k = 1 will not change
r = 1; k = 1; a = 2; b = 0.5; %initialize parameters
dt = 0.01; % time step 
sqrt_dt = sqrt(dt); % squared value of time step




dr = 0; dh = 0; dm = 0; % Initialize difference values (dr, dh, dm) for SDE computations
gamma = 1; % speed of adjustment to mean p bar
sigma = 0.1; % sd of CIR process
epsilon = randn(n,3); % epsilon ~ N(0,1)



figure(25); % figure
figure_width = 1280; % in pixels
figure_height = 1280; % in pixels
% Adjust subplot margins for better label visibility
%subplot_adjustment = 0.01; % Adjust as needed for optimal layout
%set(gcf, 'DefaultAxesPosition', [subplot_adjustment, subplot_adjustment, 1-2*subplot_adjustment, 1-2*subplot_adjustment]);




% for current storage. 1 is x index, 2 is y index
curr_tensor = zeros(n,2);
for m_index = 1:length
    m_bar = 0.2 + grid_size*(m_index-1);
    m = m_bar;

    for h_index = 1:length
        h_bar = 0.2 + grid_size*(h_index-1);
        h = h_bar;

        curr_tensor(1,1) = 0.1;
        curr_tensor(1,2) = 0.02;

        
        figure_pos = (5 -  h_index)* 5 + m_index; % Figure position given m and h index




        % when m and h are given, determine whether we need a break
        if m_bar + h_bar > 0.8
            break;
        end


        for i = 2:n
            currx = curr_tensor(i-1,1); 
            curry = curr_tensor(i-1,2);

            dr = gamma * (r_bar - r) * dt + sigma * sqrt(r) * epsilon(i,1) * sqrt_dt;
            r = r + dr;
            dh = gamma * (h_bar - h) * dt + sigma * sqrt(h) * epsilon(i,2) * sqrt_dt;
            h = h + dh;
            dm = gamma * (m_bar - m) * dt + sigma * sqrt(m) * epsilon(i,3) * sqrt_dt;
            m = m + dm;


            curr_tensor(i,1) = (r * currx * (1 - currx/k) - a * currx * curry / (currx + h)) * dt + currx;
            curr_tensor(i,2) = (a*b*currx*curry / (currx + h) - m*curry)*dt + curry;

        end


        % Only when m+h <0.8 will this be executed
        big_data(m_index,h_index, :, :) = curr_tensor;


        disp(h_index); %test progress

        subplot(5,5,figure_pos);
        plot(curr_tensor(:,1), curr_tensor(:,2));
        xlim([0 1]);
        ylim([0 0.8]);
        set(gca, 'XTick', [0 1], 'YTick', [0 0.8]);

        % Adding labels with specified text
        m_label = 0.1 * m_index +0.1
        h_label = 0.1 * h_index +0.1
        title(['(', num2str(m_label) ',' num2str(h_label), ')'], 'FontSize', 14)

        %xlabel(['x']);
        %ylabel(['y'], 'Rotation', 0);

        if m_index == 1 & h_index == 1
            xlabel('x', 'Position', [0.5, -0.05], 'VerticalAlignment', 'top', 'FontSize', 18);  % Adjust the y-value as needed
            ylabel('y', 'Position', [-0.05, 0.5], 'HorizontalAlignment', 'right', 'Rotation',0, 'FontSize', 18);  % Adjust the x-value as needed
        end 

        
 

        %text(0.5, 1.04, title(['(', num2str(m_label) ',' num2str(h_label), ')']), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Units', 'normalized');


        
        curr_tensor = zeros(n,2);


    end


end

set(gcf, 'Position', [50, 50, figure_width, figure_height]); % [left, bottom, width, height]
print('five_by_five_figure.jpg', '-djpeg', '-r300'); % Replace 300 with the desired DPI

save('data.mat', 'big_data', '-v7.3');


