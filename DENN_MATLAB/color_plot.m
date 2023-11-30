% Load the .mat file created in Python
data = load('graph_data_matrix_60k.mat');
graph_data_matrix_small_gap = data.array;



%====================================================
figure(6);
height = 1080;
length = 600;
set(gcf,'Position',[200 200 height length]);



x = [0.2 0.3 0.4 0.5 0.6];
y = [0.2 0.3 0.4 0.5 0.6];



for i = 1:2
    for j = 1:3
        
        plot_position = 3 * (i-1) + j;
        subplot(2,3,plot_position);

        curr_data = squeeze(graph_data_matrix_small_gap(i,j,:,:));

        imagesc(x, y, curr_data);
        %set(gca, 'Ydir', 'normal'); % flip y-axis

        % 设置颜色栏的范围
        % clim([colorbarMin colorbarMax]);
        % colorbar;

        
        if j == 1
            xlabel('CI width');
            clim([0 0.1]);
            colorbar;
        elseif j == 2
            xlabel('out of CI flag');
            clim([0 1]);
            colorbar;
        else
            xlabel('R.E');
            clim([0 10]);
            colorbar;
        end


        
        if i == 1
            ylabel('m');
        else
            ylabel('h');
        end
        



        set(gca, 'xticklabels', '');
        set(gca, 'yticklabels', '');

        % 在每一列的顶端添加文字
        % 在每一列的顶端添加文字
        



    end
end