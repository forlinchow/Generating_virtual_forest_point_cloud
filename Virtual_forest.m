% Generating virtual forest point cloud base on the single trees' point cloud 
%      -Matlab version 1.2 
% motifled by zhoufoling at 2017.03.15
% upgrade:
% 1.added toomin function to solve the problem that the trees are too close.
% 2.added DEM module.
% 


% border_x,border_y   虚拟森林边界　1*1 double
% cover_rate   森林覆盖率  1*1 double eg. 0.8-80%森林覆盖率
% coniferous_sample   针叶林样本 cell 每个cell内为n*4列矩阵 xyz classification
% broadleaf_sample   阔叶林样本 cell 每个cell内为n*4列矩阵
% gridsize  小网格大小
% coniferous_rate  针叶林百分比 0~1, 1*1 double
% broadleaf_rate 阔叶林百分比

function [forest true]=Virtual_forest(border_x,border_y,cover_rate,gridsize,coniferous_sample,coniferous_rate,broadleaf_sample)
	forest=[];true=[];
	broadleaf_rate=1-coniferous_rate;     %阔叶林百分比

	tree_open=rand(floor(border_x/gridsize),floor(border_y/gridsize));   %种树阈值，大于覆盖率的区位不种树
	% grid_nums=ceil(border_x/gridsize)*ceil(border_y/gridsize);
	grid_nums=ceil(border_x/gridsize)*ceil(border_y/gridsize);      %网格总数量
	tree_nums=ceil(grid_nums*cover_rate);                         %树总数量

	C_size=size(coniferous_sample,2);		%针叶林样本大小
	B_size=size(broadleaf_sample,2);         %阔叶林样本大小
	% tree_list=ceil(rand(1,ceil(floor(tree_nums*coniferous_rate)))*(C_size+B_size));

	seed_nums=1;
	tree_list=rand(1,tree_nums);   %树种类矩阵

	for i=1:floor(border_x/gridsize)
		for j=1:floor(border_y/gridsize)
			if tree_open(i,j)<cover_rate
				if tree_list(seed_nums)<=coniferous_rate
					temp_tree=coniferous_sample{ceil(rand(1,1)*C_size)};
					temp_tree(:,1:3)=rot3d(temp_tree(:,1:3),[mean(temp_tree(:,1)) mean(temp_tree(:,2)) 0],[0 0 1],rand(1,1)*2*pi);
				else
					temp_tree=broadleaf_sample{ceil(rand(1,1)*B_size)};
					temp_tree(:,1:3)=rot3d(temp_tree(:,1:3),[mean(temp_tree(:,1)) mean(temp_tree(:,2)) 0],[0 0 1],rand(1,1)*2*pi);
				end
				while 1
					pos_x=(i-1)*gridsize+rand(1,1)*gridsize;
					pos_y=(j-1)*gridsize+rand(1,1)*gridsize;
					if toomin(pos_x,pos_y,temp_tree,true,gridsize,forest)==0
						break;
					else	
						if tree_list(seed_nums)<=coniferous_rate
							temp_tree=coniferous_sample{ceil(rand(1,1)*C_size)};
							temp_tree(:,1:3)=rot3d(temp_tree(:,1:3),[mean(temp_tree(:,1)) mean(temp_tree(:,2)) 0],[0 0 1],rand(1,1)*2*pi);
						else
							temp_tree=broadleaf_sample{ceil(rand(1,1)*B_size)};
							temp_tree(:,1:3)=rot3d(temp_tree(:,1:3),[mean(temp_tree(:,1)) mean(temp_tree(:,2)) 0],[0 0 1],rand(1,1)*2*pi);
						end
					end 
				end		
				delta_x=pos_x-mean(temp_tree(:,1));
				delta_y=pos_y-mean(temp_tree(:,2));
				temp_tree(:,1)=temp_tree(:,1)+delta_x;
				temp_tree(:,2)=temp_tree(:,2)+delta_y;
				forest=[forest;temp_tree];
				if tree_list(seed_nums)<=coniferous_rate
					temp_tree=sortrows(temp_tree,-3);
					temp_inf=temp_tree(1,1:4);
				else
					temp_inf=[pos_x pos_y max(temp_tree(:,3)) temp_tree(1,4)];
				end
				true=[true;temp_inf];
				clear temp_tree pos_x pos_y delta_x delta_y temp_inf 			
				seed_nums=seed_nums+1;
			end
		end
	end
end

function a=toomin(pos_x,pos_y,temp_tree,true,gridsize,forest)
	if size(true,1)<1
		a=0;
	else
		temp_tree=sortrows(temp_tree,-3);
		ind1=forest(:,3)>temp_tree(1,3);
		forest2=forest(ind1,:);
		dis=pdist2(forest2(:,1:2),temp_tree(1,1:2),'euclidean');
		% dis=(true(:,1)-pos_x).^2+(true(:,2)-pos_y).^2;
		% if sqrt(min(dis))>max((max(temp_tree(:,1))+min(temp_tree(:,1)))/2,(max(temp_tree(:,2))+min(temp_tree(:,2)))/2)
		if min(dis)>1
			a=0;
		else
			a=1;
		end
	end
end


		
		