clc; clear all; close all;

% load data from mat files
load('../data/runs_1_81.mat');
load('../data/fault_1.mat');
load('../data/fault_2.mat');
n = data.numElements;

% variable declaration
resp_1 = string();
resp_2 = string();
t = cell(n,1);
P1 = cell(n,1);
P2 = cell(n,1);
Q11 = cell(n,1);
Q12 = cell(n,1);
Q21 = cell(n,1);
Q22 = cell(n,1);
diag_1 = cell(n,1);
diag_2 = cell(n,1);
f_10 = cell(n,1);
f_11 = cell(n,1);
f_12 = cell(n,1);
f_20 = cell(n,1);
f_21 = cell(n,1);
f_22 = cell(n,1);

% populate variables using data from mat file
for i = 1:n
    % time result
    t{i} = data{i}{1}.Values.P1.Time;
    % pressure result
    P1{i} = data{i}{1}.Values.P1.Data(:,:);
    P2{i} = data{i}{1}.Values.P2.Data(:,:);
    % volumetric flow result
    Q11{i} = data{i}{1}.Values.Q11.Data(:,:);
    Q12{i} = data{i}{1}.Values.Q12.Data(:,:);
    Q21{i} = data{i}{1}.Values.Q21.Data(:,:);
    Q22{i} = data{i}{1}.Values.Q22.Data(:,:);
    % fault diagnosis result
    diag_1{i} = squeeze(data{i}{1}.Values.S1.Data(1,:,:));
    diag_2{i} = squeeze(data{i}{1}.Values.S2.Data(1,:,:));

    % verify fault diagnosis result
    resp_1(i,1) = isequal(fault_1(i, :),diag_1{i}(:,end)');
    resp_2(i,1) = isequal(fault_2(i, :),diag_2{i}(:,end)');

    % verify fault diagnosis at each location
    for j = 1:length(t{i})
        f_10{i}(j,1) = isequal([11 1 -1 -1],diag_1{i}(:,j)');
        f_11{i}(j,1) = isequal([8 -1 1 -1],diag_1{i}(:,j)');
        f_12{i}(j,1) = isequal([8 -1 -1 1],diag_1{i}(:,j)');
        f_20{i}(j,1) = isequal([11 1 -1 -1],diag_2{i}(:,j)');
        f_21{i}(j,1) = isequal([8 -1 1 -1],diag_2{i}(:,j)');
        f_22{i}(j,1) = isequal([8 -1 -1 1],diag_2{i}(:,j)');
    end
end

% simulation run number to plot
% single fault k = 81
% multiple fault k = 1
k = 1;
% plot pressure and volumetric flow
figure(1)
subplot(2,1,1)
hold on
plot(t{k},P1{k},'k')
plot(t{k},P2{k},'r')
legend('P_1','P_2','location','northwest')
xlabel('(a)')
ylabel('P [Pa]')
ax = gca; 
ax.FontSize = 11;

subplot(2,1,2)
hold on
plot(t{k},Q11{k},'k')
plot(t{k},Q12{k},'k--')
plot(t{k},Q21{k},'r')
plot(t{k},Q22{k},'r--')
legend({'Q_{11}','Q_{12}','Q_{21}','Q_{22}'},'NumColumns',2)
xlabel('(b)')
ylabel('Q [m^3/s]')
ax = gca; 
ax.FontSize = 11;

% plot fault occurrence over time
figure(2)
subplot(2,1,1)
hold on
plot(t{k},f_10{k},'-k')
plot(t{k},f_11{k},'--k')
plot(t{k},f_12{k},'-.k')
plot(t{k},f_20{k},'-r')
plot(t{k},f_21{k},'--r')
plot(t{k},f_22{k},'-.r')
legend({'f_{10}','f_{11}','f_{12}','f_{20}','f_{21}','f_{22}'},'NumColumns',2)
xlabel({'(c)','time [s]'})
yticks([0 1]);
yticklabels({'false', 'true'});
ylabel('Response')
ax = gca; 
ax.FontSize = 11;
