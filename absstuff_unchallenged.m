%%
clear;
clc;
close all;
% Define the shorthand codes and full names
codes = {'FF', 'SI', 'FC', 'CH', 'FS', 'SL', 'ST', 'SV', 'CU', 'KC', 'KN', 'CS','FO'};
names = {'4-Seam Fastball', 'Sinker', 'Cutter', 'Changeup', 'Splitter', ...
         'Slider', 'Sweeper', 'Slurve', 'Curveball', 'Knuckle Curve', ...
         'Knuckleball', 'Slow Curve','Forkball'};
pitch_lookup = dictionary(codes, names);

T_not=readtable("challengeable_data.csv");
not_x=T_not{:,"plate_x"};
not_z=T_not{:,"plate_z"};

not_sz_top=T_not{:,"sz_top"};
not_sz_bot=T_not{:,"sz_bot"};
not_sz_out=.8308;

date=T_not{:,"game_date"};
inning=T_not{:,"inning"};
balls=T_not{:,"balls"};
strikes=T_not{:,"strikes"};
outs_when_up=T_not{:,"outs_when_up"};
name_runners=[T_not{:,"on_1b"},T_not{:,"on_2b"},T_not{:,"on_3b"}];
runners=sum(~isnan(name_runners),2);
delta_run_exp=T_not{:,"delta_run_exp"};
call=T_not{:,"description"};


distance=ones(length(not_x),1);
for i = 1:length(not_x)
    
    dx = abs(not_x(i)) - not_sz_out;     % Horizontal distance outside plate
    dy_top = not_z(i) - not_sz_top(i);   % Vertical distance above the zone
    dy_bot = not_sz_bot(i) - not_z(i);   % Vertical distance below the zone

    if dx <= 0 && dy_top <= 0 && dy_bot <= 0
        % CASE 1: Strike
        distance(i) = min([abs(dx), abs(dy_top), abs(dy_bot)]);
        
    elseif dx > 0 && dy_top <= 0 && dy_bot <= 0
        % CASE 2: Wide
        distance(i) = dx;
        
    elseif dx <= 0 && dy_top > 0
        % CASE 3: High
        distance(i) = dy_top;
        
    elseif dx <= 0 && dy_bot > 0
        % CASE 4: Low
        distance(i) = dy_bot;
        
    elseif dx > 0 && dy_top > 0
        % CASE 5: Top Corners
        distance(i) = sqrt(dx^2 + dy_top^2);
        
    elseif dx > 0 && dy_bot > 0
        % CASE 6: Bottom corners
        distance(i) = sqrt(dx^2 + dy_bot^2);
    end
    
end

% define reasonable
% umpire mistake or with 3 inches or challenge prob. of 20%
distance_from_edge=distance;
[is_true_strike,is_true_ball]=calcTrueZone(not_x,not_z,not_sz_top,not_sz_bot);
is_blown_call = (is_true_strike & strcmp(call,'ball')) | (is_true_ball & strcmp(call,'strike'));
leverage_impact=abs(delta_run_exp);

is_reasonable=is_blown_call | (distance_from_edge<=.25 & leverage_impact>=.3);
x_reasonable_strike=not_x(is_reasonable & is_true_strike);
x_reasonable_ball=not_x(is_reasonable & is_true_ball);
z_reasonable_strike=not_z(is_reasonable & is_true_strike);
z_reasonable_ball=not_z(is_reasonable & is_true_ball);

%% plot balls and strikes
figure;
hold on;
scatter(x_reasonable_strike,z_reasonable_strike,'r');
scatter(x_reasonable_ball,z_reasonable_ball,'b')
xline(.8308,"LineStyle","--");
xline(-.8308,"LineStyle","--");
yline(mean(not_sz_top,"omitnan"),"LineStyle","--");
yline(mean(not_sz_bot,"omitnan"),"LineStyle","--");
grid on;
xlabel("X Position (ft)");
ylabel("Z Position (ft)");
title("Reasonable but Unchallenged Pitches");
legend('True Strikes','True Balls');


%% Challenged vs Unchallenged plot
T_conf=readtable("confirmed data.csv");
T_over=readtable("overturned data.csv");

conf_x=T_conf{:,"plate_x"};
conf_z=T_conf{:,"plate_z"};
conf_sz_top=T_conf{:,"sz_top"};
conf_sz_bot=T_conf{:,"sz_bot"};
over_x=T_over{:,"plate_x"};
over_z=T_over{:,"plate_z"};
over_sz_top=T_over{:,"sz_top"};
over_sz_bot=T_over{:,"sz_bot"};
reasonable_x=not_x(is_reasonable);
reasonable_z=not_z(is_reasonable);
challenged_x=[conf_x;over_x];
challenged_z=[conf_z;over_z];
sz_top=[over_sz_top;conf_sz_top;not_sz_top];
sz_bot=[over_sz_bot;conf_sz_bot;not_sz_bot];

figure;
hold on;
scatter(challenged_x,challenged_z,'o','b')
scatter(reasonable_x,reasonable_z,'o','r')
title("Position of Challenged and Unchallenged Reasonable Pitches")
xlabel("X Position (ft)")
ylabel("Z Position (ft)")
xline(.8308,"LineStyle","--","LineWidth",1);
xline(-.8308,"LineStyle","--","LineWidth",1);
yline(mean(sz_top,"omitnan"),"LineStyle","--","LineWidth",1);
yline(mean(sz_bot,"omitnan"),"LineStyle","--","LineWidth",1);
legend("Challenge","Unchallenged","Location","best")