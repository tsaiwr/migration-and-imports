
% on the state level
num_row=length(ACS_Migration);  % total num of lines in dataset
fraction_Mig=ACS_Migration./State2_Pop; % fraction of outgoing people in the total population of that state
figure;
histogram(ACS_Migration./State2_Pop);

figure;
plot(ACS_Migration, PopDif, 'o'); 

figure;
plot(ACS_Migration./State2_Pop, PopDif./Distance, 'o');  % fraction of outgoing people vs population difference between states (normalized by the distance between states)
hold on;
lsline;
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% on the regional level
S1region_ID=zeros(num_row,1);   % in-state
for i=1:num_row
    if strcmp(S1region{i},'Midwest')
        S1region_ID(i)=1;
    end
    if strcmp(S1region{i},'Northeast')
        S1region_ID(i)=2;
    end
    if strcmp(S1region{i},'South')
        S1region_ID(i)=3;
    end
    if strcmp(S1region{i},'West')
        S1region_ID(i)=4;
    end
end
S2region_ID=zeros(num_row,1);   % out-state
for i=1:num_row
    if strcmp(S2region{i},'Midwest')
        S2region_ID(i)=1;
    end
    if strcmp(S2region{i},'Northeast')
        S2region_ID(i)=2;
    end
    if strcmp(S2region{i},'South')
        S2region_ID(i)=3;
    end
    if strcmp(S2region{i},'West')
        S2region_ID(i)=4;
    end
end

num_region=4;  % 4 big regions
id_region_out=cell(num_region,1);
id_region_in=cell(num_region,1);
id_region_trans=cell(num_region,num_region);
avg_fraction_region_out=zeros(num_region,1);
avg_fraction_region_in=zeros(num_region,1);


for i=1:num_region
    id_region_out{i}=find(S2region_ID == i);   % find out-states in region i
    avg_fraction_region_out(i)=mean(fraction_Mig(id_region_out{i}));  % average fraction of outgoing population in region i
end
for i=1:num_region
    id_region_in{i}=find(S1region_ID == i);    % find in-states in region i
    avg_fraction_region_in(i)=mean(fraction_Mig(id_region_in{i}));    % average fraction of incoming population in region i
end

avg_fraction_region_trans=zeros(num_region,num_region);
for i=1:num_region
    for j=1:num_region
        id_region_trans{i,j}=intersect(id_region_in{i},id_region_out{j});  % find dyadic relation: in-state in region i and out-state in region j
        avg_fraction_region_trans(i,j)=mean(fraction_Mig(id_region_trans{i,j}));  % average fraction of population migrating from region j to i
    end
end

Imports_region_trans=zeros(num_region,num_region);
for i=1:num_region
    for j=1:num_region
        temp=Imports(id_region_trans{i,j})
        temp = temp(~isnan(temp))';
    Imports_region_trans(i,j)=sum(temp);   % Imports from region j to i
    end
end

[Imports_region_trans_sorted, I_sorted]=sort(reshape(Imports_region_trans,[num_region*num_region,1]),'descend');  % Imports sorted
figure;
bar(reshape(Imports_region_trans_sorted,[num_region*num_region,1]),'stacked');
pbaspect([1 0.8 1]);
box on;

[Migration_region_trans_sorted, I_sorted_pop]=sort(reshape(avg_fraction_region_trans,[num_region*num_region,1]),'descend');   % Migration sorted
figure;
bar(reshape(Migration_region_trans_sorted,[num_region*num_region,1]),'stacked');
pbaspect([1 0.8 1]);
box on;

for i=1:num_region*num_region
    i
    id_array{I_sorted(i)}   % print out the sorted region to region type according to imports
end

for i=1:num_region*num_region
    i
    id_array{I_sorted_pop(i)}   % print out the sorted region to region type  according to migration
end

figure;
hold on;
avg_fraction_region_trans_array=reshape(avg_fraction_region_trans,[num_region*num_region,1]);
Imports_region_trans_array=reshape(Imports_region_trans,[num_region*num_region,1]);
plot(avg_fraction_region_trans_array,Imports_region_trans_array,'o', 'MarkerFaceColor','r','MarkerSize',8);
pbaspect([1 0.8 1]);
box on;
lsline;  % linear fit
hold off;




