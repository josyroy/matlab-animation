function [] = P1b_Roy_Josyline(r1,r2,r3,r4,r5,speed)
% ENME 473 2026 - P. Goldsmith
%
% Function to animate 3 cycles of an inverted slider mechanism and plot
% arm angle vs crank angle for a single crank rotation.
%
% INPUTS:
% r1 is the distance from the crank-ground pin joint to the arm-ground
%   pin joint, which is to the left of the crank-ground pin joint,
% r2 is the length of the crank,
% r3 is the length of the arm,
% speed is the angular speed of the crank in rad/s CCW.
%
r1 = input('input the ground length');
r2 = input('input the crank length');
r3 = input('input the arm length');
r4 = input('input the arm extension length');
r5 = input('input the vertical ground length');
speed = input('input the speed of the animation');
% OUTPUTS:
% theta2 is a sequence (1-d array) of crank angles between 0 and 2*pi,
% alpha is the corresponding sequence of arm angles in radians 
% measured CCW from the horizontal.

% This function checks that the arm is long enough to support the slider
%   through a full crank rotation; otherwise it prints an error message. 
%   It then generates 3 figures:

% Figure 1 animates the mechanism completing 3 crank revolutions at the
%   given speed. The crank should start horizontally, at 0 rad (see
%   sample animation).

% Figure 2 is a plot of arm angle versus crank angle over a single rotation.

% Finally, the function should return the sequence of arm angles
%   for one revolution.

%--------------------------------------------------------------------------
% This section should contain a logical check, such as an if statement,
% which will display an error if the arm is not long enough to support the
% slider over a full rotation.
if  r3<r2+abs(r1) % If the crank can't move, throw an error message:
    disp 'The crank cannot rotate: a connecting rod is too short.'
else    % If the crank can move, animate the rest of the system:
    % Sequence of crank angles, theta:
    astep = 0.02; % step change in crank angle (in radians)
    theta=0:astep:6*pi; % sequence of crank angles over 3 revolutions

    % starting positions
    r1_start = [0, 0];
    r2_start = [r1, 0];
    %% Animate the System:
    figure(1)
    ax = axes;
    axis equal
    axis(ax,[-r5*3 r3*3 -r5*3 r3*3]) % big graph
    hold on
    % initialize starting positions for parts
    arm = plot(ax,[r1_start(1) r1 r4],[r1_start(2) 0 0],'-o','linewidth',2, 'Color', 'b');
    crank = plot(ax,[r2_start(1) r2],[r2_start(2),0],'-o','LineWidth',2,'Color','y');
    slider = patch(ax, NaN, NaN, [1 1 1], 'EdgeColor', 'w', 'LineWidth', 1);
    slider2 = patch(ax, NaN, NaN, [1 1 1], 'EdgeColor', 'm', 'LineWidth', 1);
    timestep = astep/speed; % pause timestep
    % animate over time
    for n = 1:length(theta)
        pause(timestep)
        slider_pos = r2_start + r2 * [cos(theta(n)), sin(theta(n))]; %calculate slider pos
        v = slider_pos - r1_start;
        arm_angle = atan2(v(2), v(1)); % calculate the angle
        arm_end = r1_start + r3 * [cos(arm_angle), sin(arm_angle)]; % calculate the end position
        y_pos = 1.5*arm_end(2)-r5; % the x and y pos of slider2
        x_pos = 0.75*r3;
        slider2_pos = [x_pos, y_pos]; % slider 2 starting coords and then over time
        %update arm and crank, including second arm attachment
        set(arm, 'XData', [r1_start(1) arm_end(1) x_pos], 'YData', [r1_start(2) arm_end(2) y_pos]);
        set(crank, 'XData', [r2_start(1) slider_pos(1)], 'YData', [r2_start(2) slider_pos(2)]);
        %animate rectangles and rotate
        w = r1/2; h = r1/4;
        rect = [-w/2 -h/2; w/2, -h/2; w/2 h/2; -w/2 h/2];
        cosine = cos(arm_angle); % angles to calculate pos
        sine = sin(arm_angle);
        R = [cosine -sine;
            sine cosine];
        rect_rotate = (R * rect')' + slider_pos;
        %update slider patch vertices
        set(slider, 'XData', rect_rotate(:,1), 'YData', rect_rotate(:,2));

        %vertical slider
        rect2 = [-h/2, -w/2; h/2, -w/2; h/2, w/2; -h/2, w/2];
        rect2_pos = rect2 + slider2_pos;
        set(slider2, 'XData', rect2_pos(:,1), 'YData', rect2_pos(:,2));
        drawnow;
    end
end
clc;