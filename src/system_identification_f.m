clc; clear all; close all;

% independent variables
% push rod force
force = [1 1 1 1 1 1 1 1; ...
         0.5 1 1.5 2 2.5 3 3.5 4]'.*[1 1e3];
% push rod force rate
rate = [1 1 1 1 1 1 1 1; ...
        5 10 15 20 25 30 35 40]'.*[1 1e3];

% dependent variables
pressure1 = [0.36 0.94 1.52 2.10 2.67 3.25 3.83 4.41]'*1e6; % pressure 1
pressure2 = pressure1; % pressure 2
flow1 = [5.91 11.83 17.73 23.65 29.57 35.49 41.39 47.32]'*1e-06; % vol. floq q1
flow2 = flow1; % vol. floq q2

% normal equation
theta1 = pinv(force'*force)*force'*pressure1;
theta2 = pinv(force'*force)*force'*pressure2;
theta3 = pinv(rate'*rate)*rate'*flow1;
theta4 = pinv(rate'*rate)*rate'*flow2;

% linear regression pressure vs force(normal equation)
force_lin = linspace(0, 4000, 21);
pressure1_lin = theta1(1) + theta1(2)*force_lin;
pressure2_lin = theta2(1) + theta2(2)*force_lin;

% define rate equation considering adjustment
rate_lin = linspace(0, 5e4, 21);
flow1_lin = theta3(1) + theta3(2)*rate_lin;
flow2_lin = theta4(1) + theta4(2)*rate_lin;

figure(1)
subplot(2,1,1)
hold on
plot(force(:,2), pressure1, 'o-','LineWidth',1.25,'MarkerSize',6)
plot(force_lin,pressure1_lin,'--','LineWidth',1.25)
plot(force_lin,pressure1_lin + 2e5,'k--','LineWidth',1.25)
plot(force_lin,pressure1_lin - 2e5,'k--','LineWidth',1.25)
ylabel('P [Pa]')
xlabel({'F [N]','(a)'})
legend('data','model','threshold','location','southeast')
fig_x = [0.48 0.52];
fig_y1 = [0.83 0.81];
annotation('textarrow',fig_x,fig_y1,'String','\alpha = 1.16e^3F-2.28e^5\pm\Delta\alpha')
ax = gca; 
ax.FontSize = 10; 

subplot(2,1,2)
hold on
plot(rate(:,2), flow1, 'o-','LineWidth',1.25,'MarkerSize',6)
plot(rate_lin,flow1_lin,'--','LineWidth',1.25)
plot(rate_lin,flow1_lin + 2e-6,'k--','LineWidth',1.25)
plot(rate_lin,flow1_lin - 2e-6,'k--','LineWidth',1.25)
ylabel('Q [m^3/s]')
xlabel({'dF/dt [N/s]','(b)'})
legend('data','model','threshold','location','southeast')
fig_x = [0.48 0.52];
fig_y2 = [0.35 0.33];
str = {'\epsilon = 1.18e^{-9}dF/dt\pm\Delta\epsilon'};
annotation('textarrow',fig_x,fig_y2,'string',str)
ax = gca; 
ax.FontSize = 10; 