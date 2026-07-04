%%
clear;
clc;
% Define the shorthand codes and full names
codes = {'FF', 'SI', 'FC', 'CH', 'FS', 'SL', 'ST', 'SV', 'CU', 'KC', 'KN', 'CS','FO'};
names = {'4-Seam Fastball', 'Sinker', 'Cutter', 'Changeup', 'Splitter', ...
         'Slider', 'Sweeper', 'Slurve', 'Curveball', 'Knuckle Curve', ...
         'Knuckleball', 'Slow Curve','Forkball'};
pitch_lookup = dictionary(codes, names);

% read in data
T_conf=readtable("confirmed data.csv");
result_conf=T_conf{:,"description"};
condition_conf=result_conf=="ball";

conf_x=T_conf{:,"plate_x"};
conf_z=T_conf{:,"plate_z"};
conf_date=T_conf{:,"game_date"};
conf_by_date = days(conf_date - min(conf_date));
conf_by_date =double(conf_by_date(:));

T_over=readtable("overturned data.csv");
result_over=T_over{:,"description"};
condition_over= result_over=="ball";
overturned_x = T_over{:,"plate_x"};
overturned_z = T_over{:,"plate_z"};
over_date=T_over{:,"game_date"};
over_by_date = days(over_date - min(over_date));
over_by_date =double(over_by_date(:));

T_unchall=readtable("challengeable_data.csv");
result_unchall=T_unchall{:,"description"};
condition_unchall= result_unchall=="ball";
unchall_x = T_unchall{:,"plate_x"};
unchall_z = T_unchall{:,"plate_z"};

% strike zone heights
sz_top_conf=T_conf{:,"sz_top"};
sz_bot_conf=T_conf{:,"sz_bot"};
sz_top_over=T_over{:,"sz_top"};
sz_bot_over=T_over{:,"sz_bot"};

sz_top=[sz_top_conf;sz_top_over];
sz_bot=[sz_bot_conf;sz_bot_over];

sz_out=.8308;

% location plots
% confirmed
figure;
hold on; 
scatter(conf_x(~condition_conf), conf_z(~condition_conf), 36, 'red', 'filled');
scatter(conf_x(condition_conf), conf_z(condition_conf), 36, 'green', 'filled');
xline(-sz_out,"LineWidth",1,"LineStyle","--");
xline(sz_out,"LineWidth",1,"LineStyle","--");
yline(mean(sz_top),"LineWidth",1,"LineStyle","--");
yline(mean(sz_bot),"LineWidth",1,"LineStyle","--");
hold off;
xlabel('Plate X');
ylabel('Plate Z');
title('ABS Coordinates for Confirmed');
grid on;
legend('Strike', 'Ball', 'Location', 'best');

% overturned
figure;
hold on;
scatter(overturned_x(condition_over), overturned_z(condition_over), 36, 'green', 'filled');
scatter(overturned_x(~condition_over), overturned_z(~condition_over), 36, 'red', 'filled');
xline(-sz_out,"LineWidth",1,"LineStyle","--");
xline(sz_out,"LineWidth",1,"LineStyle","--");
yline(mean(sz_top),"LineWidth",1,"LineStyle","--");
yline(mean(sz_bot),"LineWidth",1,"LineStyle","--");
hold off;
xlabel('Plate X');
ylabel('Plate Z');
title('ABS Coordinates for Overturned');
grid on;
legend('Strike', 'Ball', 'Location', 'best');

% both
figure;
hold on;
scatter(overturned_x,overturned_z,36,'red','o');
scatter(conf_x,conf_z,36,'blue','o');
xlabel('Plate X');
ylabel('Plate Z');
xline(-sz_out,"LineWidth",1,"LineStyle","--");
xline(sz_out,"LineWidth",1,"LineStyle","--");
yline(mean(sz_top),"LineWidth",1,"LineStyle","--");
yline(mean(sz_bot),"LineWidth",1,"LineStyle","--");
title('ABS Coordinates for Overturned & Confirmed');
legend('Overturned','Confirmed','Location','Best');
grid on;
hold off;

%% confirmed distance calc
distance_conf=ones(length(result_conf),1);
for i = 1:length(result_conf)
    dx = abs(conf_x(i)) - sz_out;          % Horizontal distance outside plate
    dy_top = conf_z(i) - sz_top_conf(i);   % Vertical distance above the zone
    dy_bot = sz_bot_conf(i) - conf_z(i);   % Vertical distance below the zone

    if dx <= 0 && dy_top <= 0 && dy_bot <= 0
        % CASE 1: Strike
        distance_conf(i) = min([abs(dx), abs(dy_top), abs(dy_bot)]);
        
    elseif dx > 0 && dy_top <= 0 && dy_bot <= 0
        % CASE 2: Wide
        distance_conf(i) = dx;
        
    elseif dx <= 0 && dy_top > 0
        % CASE 3: High
        distance_conf(i) = dy_top;
        
    elseif dx <= 0 && dy_bot > 0
        % CASE 4: Low
        distance_conf(i) = dy_bot;
        
    elseif dx > 0 && dy_top > 0
        % CASE 5: Top corners
        distance_conf(i) = sqrt(dx^2 + dy_top^2);
        
    elseif dx > 0 && dy_bot > 0
        % CASE 6: Bottom corners
        distance_conf(i) = sqrt(dx^2 + dy_bot^2);
    end
end

distance_over=ones(length(result_over),1);
for i = 1:length(result_over)
    
    dx = abs(overturned_x(i)) - sz_out;          % Horizontal distance outside plate
    dy_top = overturned_z(i) - sz_top_over(i);   % Vertical distance above the zone
    dy_bot = sz_bot_over(i) - overturned_z(i);   % Vertical distance below the zone

    if dx <= 0 && dy_top <= 0 && dy_bot <= 0
        % CASE 1: Strike
        distance_over(i) = min([abs(dx), abs(dy_top), abs(dy_bot)]);
        
    elseif dx > 0 && dy_top <= 0 && dy_bot <= 0
        % CASE 2: Wide
        distance_over(i) = dx;
        
    elseif dx <= 0 && dy_top > 0
        % CASE 3: High
        distance_over(i) = dy_top;
        
    elseif dx <= 0 && dy_bot > 0
        % CASE 4: Low
        distance_over(i) = dy_bot;
        
    elseif dx > 0 && dy_top > 0
        % CASE 5: Top corners
        distance_over(i) = sqrt(dx^2 + dy_top^2);
        
    elseif dx > 0 && dy_bot > 0
        % CASE 6: Bottom corners
        distance_over(i) = sqrt(dx^2 + dy_bot^2);
    end
    
end

% average distance
% confirmed
[unique_days_conf, ~, idx_conf] = unique(conf_date);
daily_avg_distance_conf = accumarray(idx_conf, distance_conf, [], @mean);
avg_distance_conf=mean(distance_conf);

% overturned
[unique_days_over, ~, idx_over] = unique(over_date);
daily_avg_distance_over = accumarray(idx_over, distance_over, [], @mean);
avg_distance_over=mean(distance_over);

% both
all_dates=[conf_date; over_date];
all_distance=[distance_conf; distance_over];
[unique_days_all, ~,idx_all]=unique(all_dates);
daily_avg_distance_all=accumarray(idx_all, all_distance,[],@mean);
total_avg_distance=mean(all_distance);

% distance day plots
% confirmed
figure;
hold on;
plot(conf_date,distance_conf.*12,".","MarkerSize",12);
plot (unique_days_conf,daily_avg_distance_conf.*12,'Color','r','LineWidth',1.5);
yline(avg_distance_conf*12,"Color",'k','LineStyle','--',"LineWidth",2);
xlabel("Date");
ylabel("Distance (in)");
title("Distance from Strike Zone Boarder by Date for Confirmed Calls");
legend("Data","Daily Average","Overall Average","Location","Best")
hold off;

% overturned
figure;
hold on;
plot(over_date,distance_over.*12,".","MarkerSize",12);
plot (unique_days_over,daily_avg_distance_over.*12,'Color','r','LineWidth',1.5);
yline(avg_distance_over*12,"Color",'k','LineStyle','--',"LineWidth",2);
xlabel("Date");
ylabel("Distance (in)");
title("Distance from Strike Zone Boarder by Date for Overturned Calls");
legend("Data","Daily Average", "Overall Average","Location","Best");
hold off;

% both
figure;
hold on;
plot(conf_date,distance_conf.*12,".","MarkerSize",12);
plot(over_date,distance_over.*12,".","MarkerSize",12,'Color','r');
plot(unique_days_all, daily_avg_distance_all.*12,'Color', [0.49 0.18 0.56],"LineWidth",2);
yline(total_avg_distance*12,"Color",'k','LineStyle','--',"LineWidth",2);
xlabel("Date");
ylabel("Distance (in)");
title("Distance from Strike Zone Boarder by Date for All Challenged Calls");
legend("Confirmed Calls","Overturned Calls","Combined Daily Average Distance", "Combined Overall Average Distance", "Location", "Best");
hold off;

%% Umpire margin of error
human_margin=median(distance_over);
fprintf('Calls overturned are an average of %.2f inches away from the strike zone line.\n',human_margin.*12);

%% Pitch types
conf_type=T_conf{:,"pitch_type"};
over_type=T_over{:,"pitch_type"};

[unique_type_conf, ~, idx_conf_type] = unique(conf_type);
conf_type_distance = accumarray(idx_conf_type, distance_conf, [], @mean);
real_names_conf=pitch_lookup(unique_type_conf);
[unique_type_over, ~, idx_over_type] = unique(over_type);
over_type_distance = accumarray(idx_over_type, distance_over, [], @mean);
real_names_over=pitch_lookup(unique_type_over);

% confirmed
figure;
bar(categorical(real_names_conf),conf_type_distance*12);
ylabel('Average Distance from Edge (in)');
title('Confirmed Calls: Average Distance by Pitch Type');

% overturned
figure;
bar(categorical(real_names_over),over_type_distance*12);
ylabel('Average Distance from Edge (in)');
title('Overturned Calls: Average Distance by Pitch Type');

%% Other Conditions
% inning
inning=[T_conf{:,"inning"};T_over{:,"inning"}];
all_inning=[inning;T_unchall{:,"inning"}];
[unique_innings, ~,idx_inning]=unique(inning);
[unique_innings, ~,idx_inning_all]=unique(all_inning);
inning_avg_distance=accumarray(idx_inning, all_distance,[],@mean);
inning_counts=accumarray(idx_inning,1);
all_inning_counts=accumarray(idx_inning_all,1);
prob_inning=inning_counts./all_inning_counts;

subplot(2,1,1);
bar(categorical(unique_innings),inning_avg_distance.*12);
yline(total_avg_distance*12,'Color','r','LineWidth',2,'Label','Average');
title("Average Distance vs Innings");
ylabel("Distance (in)");
xlabel("Inning");

subplot(2,1,2);
bar(categorical(unique_innings),inning_counts);
title("Challenges per Inning");
ylabel("Challenges");
xlabel("Inning");
figure;
bar(categorical(unique_innings),prob_inning);
title("Probability of Challenge by Inning");
ylabel("Probability");
xlabel("Inning");

%%
% balls
balls=[T_conf{:,"balls"};T_over{:,"balls"}];
all_balls=[balls;T_unchall{:,"balls"}];
[unique_balls, ~,idx_balls]=unique(balls);
balls_avg_distance=accumarray(idx_balls,all_distance,[],@mean);
balls_count=accumarray(idx_balls,1);

% figure;
% subplot(2,1,1);
% bar(categorical(unique_balls),balls_avg_distance.*12);
% yline(total_avg_distance*12,'Color','r','LineWidth',2,'Label','Average');
% title("Average Distance per Ball Count");
% ylabel("Distance (in)");
% xlabel("Ball Count");
% 
% subplot(2,1,2);
% bar(categorical(unique_balls),balls_count);
% title("Challenges per Ball Count");
% ylabel("Challenges");
% xlabel("Ball Count");

% strikes
strikes=[T_conf{:,"strikes"};T_over{:,"strikes"}];
all_strikes=[strikes;;T_unchall{:,"strikes"}];
[unique_strikes, ~,idx_strikes]=unique(strikes);
strikes_avg_distance=accumarray(idx_strikes,all_distance,[],@mean);
strikes_count=accumarray(idx_strikes,1);

% figure;
% subplot(2,1,1);
% bar(categorical(unique_strikes),strikes_avg_distance.*12);
% yline(total_avg_distance*12,'Color','r','LineWidth',2,'Label','Average');
% title("Average Distance per Strike Count");
% ylabel("Distance (in)");
% xlabel("Strike Count");
% 
% subplot(2,1,2);
% bar(categorical(unique_strikes),strikes_count);
% title("Challenges per Strike Count");
% ylabel("Challenges");
% xlabel("Strike Count");
figure;
count_strings=strcat(string(balls), "-", string(strikes));
all_count_strings=strcat(string(all_balls), "-", string(all_strikes));
count_order = {'0-0', '1-0', '2-0', '3-0', '0-1', '1-1', '2-1', '3-1', '0-2', '1-2', '2-2', '3-2'};
[unique_counts,~,idx_count]=unique(count_strings);
[unique_counts,~,idx_all_count]=unique(all_count_strings);
frequencies_count=accumarray(idx_count,1);
all_frequencies_count=accumarray(idx_all_count,1);
probabilites_count=frequencies_count./all_frequencies_count;
bar(unique_counts, frequencies_count);
title("Challenges by Count");
xlabel("Count");
ylabel("Challenges");

figure;
bar(unique_counts,probabilites_count);
title("Probability of Challenge by Count");
xlabel("Count");
ylabel("Probability");

%%
% outs
outs=[T_conf{:,"outs_when_up"};T_over{:,"outs_when_up"}];
all_outs=[outs;T_unchall{:,"outs_when_up"}];
[unique_outs, ~,idx_outs]=unique(outs);
[unique_outs, ~,idx_outs_all]=unique(all_outs);
outs_avg_distance=accumarray(idx_outs,all_distance,[],@mean);
outs_count=accumarray(idx_outs,1);
all_outs_count=accumarray(idx_outs_all,1);
prob_outs=outs_count./all_outs_count;

figure;
subplot(2,1,1);
bar(categorical(unique_outs),outs_avg_distance.*12);
yline(total_avg_distance*12,'Color','r','LineWidth',2,'Label','Average');
title("Average Distance per Outs When Up");
ylabel("Distance (in)");
xlabel("Outs When Up");

subplot(2,1,2);
bar(categorical(unique_outs),outs_count);
title("Challenges per Outs When Up");
ylabel("Challenges");
xlabel("Outs When Up");
figure;
bar(categorical(unique_outs),prob_outs);
title("Probability of Challenge by Outs When Up");
ylabel("Probability");
xlabel("Outs When Up");

%%
% runners
runners_on = [ [T_conf{:,"on_1b"}, T_conf{:,"on_2b"}, T_conf{:,"on_3b"}];
               [T_over{:,"on_1b"}, T_over{:,"on_2b"}, T_over{:,"on_3b"}] ];
all_runners_on=[runners_on;T_unchall{:,"on_1b"},T_unchall{:,"on_2b"},T_unchall{:,"on_3b"}];
runners_count=sum(~isnan(runners_on),2);
all_runners_count=sum(~isnan(all_runners_on),2);

[unique_runners, ~,idx_runners]=unique(runners_count);
[unique_runners_all, ~,idx_runners_all]=unique(all_runners_count);
runners_avg_distance=accumarray(idx_runners,all_distance,[],@mean);
runners_count=accumarray(idx_runners,1);
runners_count_all=accumarray(idx_runners_all,1);
probability_runners=runners_count./runners_count_all;

figure;
subplot(2,1,1);
bar(categorical(unique_runners),runners_avg_distance.*12);
yline(total_avg_distance*12,'Color','r','LineWidth',2,'Label','Average');
title("Average Distance per Runners On When Up");
ylabel("Distance (in)");
xlabel("Runners When Up");

subplot(2,1,2);
bar(categorical(unique_runners),runners_count);
title("Challenges per Runners On When Up");
ylabel("Challenges");
xlabel("Runners When Up");

figure;
bar(categorical(unique_runners),runners_count);
title("Challenges per Runners On When Up");
ylabel("Challenges");
xlabel("Runners When Up");

figure;
bar(categorical(unique_runners), probability_runners);
title("Probability of Challenge by Runners On When Up");
ylabel("Probability");
xlabel("Runners On When Up");


%%
% number of pitches
pitches=[T_conf{:,"pitch_number"};T_over{:,"pitch_number"}];
all_pitches=[pitches;T_unchall{:,"pitch_number"}];
[unique_pitches, ~,idx_pitches]=unique(pitches);
[unique_pitches_all, ~,idx_pitches_all]=unique(all_pitches);
pitches_avg_distance=accumarray(idx_pitches,all_distance,[],@mean);
pitches_count=accumarray(idx_pitches,1);
all_pitches_count=accumarray(idx_pitches_all,1);


figure;
subplot(2,1,1);
bar(categorical(unique_pitches),pitches_avg_distance.*12);
yline(total_avg_distance*12,'Color','r','LineWidth',2,'Label','Average');
title("Average Distance per Number of Pitches");
ylabel("Distance (in)");
xlabel("Number of Pitches");

subplot(2,1,2);
bar(categorical(unique_pitches),pitches_count);
title("Challenges per Number of Pitches");
ylabel("Challenges");
xlabel("Number of Pitches");

pitches_count=[pitches_count;0];
prob_pitches=pitches_count./all_pitches_count;
figure;
bar(categorical(unique_pitches_all),prob_pitches);
title("Probability of Challenge by Number of Pitches");
ylabel("Probability");
xlabel("Number of Pitches");

