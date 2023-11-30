clear big_data;
clear length; % length is the size of our data file

n = 500000;
% 定义张量的大小



% Initial setting
% =============================================
step = 0.1; % grid size

if step == 0.1
    length = 5;
elseif step == 0.02
    length =21;
end 


tensorSize = [length, length, n, 2];
% =============================================




big_data = zeros(tensorSize);



r_bar = 1; k_bar = 1; a_bar = 2; b_bar = 0.5; % a = 2; b = 0.5; k = 1 will not change

r = 1; k = 1; a = 2; b = 0.5; %initialize parameters
dt = 0.01; % time step
sqrt_dt = sqrt(dt);




dr = 0; dh = 0; dm = 0;
gamma = 1;
% speed of adjustment to mean p bar
sigma = 0.1;
% sd of CIR process
epsilon = randn(n,3); % epsilon ~ N(0,1)



figure(25); % figure



% for current storage. 1 is x index, 2 is y index
curr_tensor = zeros(n,2);
for m_index = 1:length
    m_bar = 0.2 + step*(m_index-1);
    m = m_bar;

    for h_index = 1:length
        h_bar = 0.2 + step*(h_index-1);
        h = h_bar;

        curr_tensor(1,1) = 0.1;
        curr_tensor(1,2) = 0.02;

        
        figure_pos = (5 -  h_index)* 5 + m_index;




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

        curr_tensor = zeros(n,2);



    end


end




save('data.mat', 'big_data', '-v7.3');


