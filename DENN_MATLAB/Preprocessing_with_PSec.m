% DESCRIPTION: This script preprocesses the 'big_data' dataset created by 
%   "big_data_file.m". It extracts the [X, Y, T] features using the Poincare 
%   Section method, which are essential for training the DENN.
% AUTHOR: Bosi Hou


num_of_obs = 100; % number of observation data for each grid point


outputSize = [21, 21, num_of_obs, 3];
final_training_data = zeros(outputSize); % A tensor which stores all training data. 


% clear x_max
% clear x_min
% clear y_max
% clear y_min
% 
% clear per
% clear x_amp
% clear y_amp



curr_output = zeros(num_of_obs, 3); %[X_amp, Y_amp, T]

% i, k values is determined by grid_size you specified earlier
for i = 1:5
    for k = 1:5
        disp(k);


        dt=0.01;
        %dt=0.001;
        t=[0.01:dt:1000];



        yt=0.2; xt=0.2; % threshold


        dat = squeeze(big_data(i,k,:,:));

       



        s=size(dat);
        c1=min(find(dat(:,2)>yt));
        % c1 = 262, it means at the 262-th data, we find the first data
        % s.t. its y value > 0.15


        dat=dat(c1:s(1),:);
        % use 262 ~ 10000
        % use both x and y




        %s=size(dat);
        %c2=min(find(dat(:,1)<0.2));
        %dat=dat(c2:s(1),:);

        s=size(dat);
        s1=s(1);

        j=1; % counter

        while s1>0,

            if j > 100
                break;
            end


            yc1=min(find(dat(:,2)<yt)); % across y_threshold
            % For the first iteration, yc1 may be large
            % For the iterations afterwards, yc1 is small (took one step to
            % find that value)

            xc1=min(find(dat(yc1:s1,1)>xt)); % across x_threshold ,1
            % The xc1-th in the data


            yc2=min(find(dat(yc1+xc1:s1,2)>yt)); % 2
            yc3=min(find(dat(yc1+xc1+yc2:s1,2)<yt)); % 3

            if yc3,   % what does if yc3 means?
                curr_period_end_index = yc1+xc1+yc2+yc3-1;


                T =(yc3+yc2+xc1)*dt; %0.01;

                x_max = max(dat(1: curr_period_end_index,1));
                x_min = min(dat(1: curr_period_end_index,1));

                y_max = max(dat(1:curr_period_end_index,2));
                y_min = min(dat(1:curr_period_end_index,2));


                curr_output(j,1) = x_max - x_min;
                curr_output(j,2) = y_max - y_min;
                curr_output(j,3) = T;




                j=j+1;
                dat=dat(yc1+xc1+yc2+yc3:s1,:);
                % Till this step of the iteration, the data will be truncated



                s=size(dat);
                s1=s(1);
            else 
                s1=0;
            end


            
            
        end
        final_training_data(i,k,:,:) = curr_output;


    end
end



