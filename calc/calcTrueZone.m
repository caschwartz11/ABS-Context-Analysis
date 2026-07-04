function [is_true_strike, is_true_ball] = calcTrueZone(x,z,sz_top,sz_bot)
% calculate if a pitch is a ball or strike (ABS)
% inputs:
% x: horz coordinates of pitch
% z: vert coordinates of pitch
% sz_top: top of strike zone
% sz_bot: bottom of strike zone
% outputs:
% is_true_strike: logical array (true if strike)
% is_true_ball: logical array (true if ball)

sz_out=.8308;
sz_top=sz_top+.1225;
sz_bot=sz_bot-.1225;
is_true_strike=(abs(x)<=sz_out) & (z>=sz_bot) & (z<=sz_top);
is_true_ball=~is_true_strike;
end



