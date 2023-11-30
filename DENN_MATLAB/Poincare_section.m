% assumes dt=0.01, dat is column of x values, y values
az=-26.3
el=44.4





counter = 15; % counter = 1-15




% figure
% hist3(dat,[20,20])
% set(gca,'FontSize',16)
% view(az,el)
% xlabel('x','FontSize',16),ylabel('y','FontSize',16)


clear x_max
clear x_min
clear y_max
clear y_min

clear per
clear x_amp
clear y_amp




dt=0.01;
%dt=0.001;
t=[0.01:dt:1000];
%t=[0.001:dt:10000];

%yt=0.14; xt=0.2;
%yt=0.08; xt=0.15;
yt=0.2; xt=0.2;


data1 = data_tensor(:,:,counter);

dat = data1;


dat = curr_tensor;



s=size(dat);
c1=min(find(dat(:,2)>yt));
% c1 = 262, it means at the 262-th data, we find the first data
% s.t. its y value > 0.15


dat=dat(c1:s(1),:); 
% use 262 - 10000
% use both x and y 




%s=size(dat);
%c2=min(find(dat(:,1)<0.2));
%dat=dat(c2:s(1),:);

s=size(dat);
s1=s(1);
j=1;

while s1>0,

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

       per(j)=(yc3+yc2+xc1)*dt; %0.01; 
       
       x_max(j) = max(dat(1: curr_period_end_index,1));
       x_min(j) = min(dat(1: curr_period_end_index,1));

       y_max(j) = max(dat(1:curr_period_end_index,2));
       y_min(j) = min(dat(1:curr_period_end_index,2));
       

       x_amp(j) = x_max(j) - x_min(j);
       y_amp(j) = y_max(j) - y_min(j);




       j=j+1;
       dat=dat(yc1+xc1+yc2+yc3:s1,:);
       % Till this step of the iteration, the data will be truncated 



       s=size(dat);
       s1=s(1);
   else s1=0;
   end
end




% 算法没有大毛病，但是有bug
% 第一次iteration数值比较正确，后面的有显著误差


per_t = transpose(per);
x_amp_t = transpose(x_amp);
y_amp_t = transpose(y_amp);


data_final_i = [x_amp_t y_amp_t per_t];


%writematrix(data_final_i, "/Users/andersen/Desktop/2023 Spring/Oscillation Project/NN_data/data_final_15.xlsx");



% Save variables A and B into a MAT file
save('test_gr.mat', 'data_final_i');




%writematrix(M,'M.xls')



color_plot_data(counter,1) = mean(per); % x_amp
color_plot_data(counter,2) = mean(x_amp); % y_amp
color_plot_data(counter,3) = mean(y_amp); % per


disp(color_plot_data);



% 
% fprintf('mean period = %5.3f\n', mean(per));
% fprintf('median period = %5.3f\n', median(per));
% fprintf('sd period = %5.3f\n', std(per));
% fprintf('CV period = %5.3f\n', std(per)/mean(per));
% fprintf('\n')


% fprintf('mean x_amp = %5.3f\n', mean(x_amp));
% fprintf('median x_amp = %5.3f\n', median(x_amp));
% fprintf('sd x_amp = %5.3f\n', std(x_amp));
% fprintf('CV x_amp = %5.3f\n', std(x_amp)/mean(x_amp));
% fprintf('\n')
% 
% fprintf('mean y_amp = %5.3f\n', mean(y_amp));
% fprintf('median y_amp = %5.3f\n', median(y_amp));
% fprintf('sd y_amp = %5.3f\n', std(y_amp));
% fprintf('CV y_amp = %5.3f\n', std(y_amp)/mean(y_amp));
% fprintf('\n')
% 
% 
% 
% % Data works fine; graph positioning is a bit off
% 
% figure(4);
% % set(gcf,'Position',[200 200 1000 1000]);
% set(gca,'FontSize',12);
% 
% histogram(x_amp);
% subplot(221);
% title('distribution of x amp');
% xlabel('x amp');
% ylabel('number of cycles');
% 
% histogram(y_amp);
% subplot(222);
% title('distribution of y\_amp');
% xlabel('y\_amp');
% ylabel('number of cycles');
% 
% histogram(per);
% subplot(223);
% title('distribution of cycle period');
% xlabel('cycle period');
% ylabel('number of cycles');
% 
% 
% 
% 
