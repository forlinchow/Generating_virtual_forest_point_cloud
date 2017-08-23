# Generating-virtual-forest-
Generating virtual forest point cloud base on the single trees' point cloud through matlab

test code:

% Virtual_forest
border_x=50;
border_y=50;
cover_rate=0.95;
gridsize=2.5;
coniferous_rate=1;
[FileNameGet,PathName]=uigetfile({'*.csv';'*.txt'},'select Coniferous sample','MultiSelect','on');  
if ~isequal(FileNameGet,0)   
    if iscell(FileNameGet)   
        FileName=FileNameGet;    
        nFile=length(FileName);   
        for i=1:nFile  
			temp=dlmread([PathName FileNameGet{i}],',',1,0);
			temp=temp(:,1:3);temp(:,4)=1;
			coniferous_sample{i}=temp;
			clear temp
        end  
    else  
        nFile=1; 
    end  
else   
    disp('no select.');   
	coniferous_sample=0;
end  
[FileNameGet,PathName]=uigetfile({'*.csv';'*.txt'},'select Broadleaf sample','MultiSelect','on');  
if ~isequal(FileNameGet,0)   
    if iscell(FileNameGet) 
        FileName=FileNameGet;    
        nFile=length(FileName);    
        for i=1:nFile   
			temp=dlmread([PathName FileNameGet{i}],',',1,0);
			temp=temp(:,1:3);temp(:,4)=2;
			broadleaf_sample{i}=temp;
			clear temp	
        end  
    else  
        nFile=1; 
    end  
else  
    disp('no select.');  
	broadleaf_sample=0;
end  
[forest true]=Virtual_forest(border_x,border_y,cover_rate,gridsize,coniferous_sample,coniferous_rate,broadleaf_sample);
dlmwrite('Virtual_forest.csv',forest,'delimiter',',','precision', '%.4f');
dlmwrite('Virtual_forest_true.csv',true,'delimiter',',','precision', '%.4f');
