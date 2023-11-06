function visualization_pi(varargin)
    % Visualize the irrationality of pi
    % 
    % Additional Args:
    %    * FPS (float): frames per second
    %    * points (float): number of tiles to advance
    %    * radius0 (float): radius of the inner arm
    %    * radius1 (float): radius of the outer arm
    %
    % Examples:
    %    visualization_pi('fps', 144);
    %    visualization_pi('fps', 144, 'points', 20);
    %    visualization_pi('fps', 144, 'points', 20, 'radius0', 0.5);
    %    visualization_pi('fps', 144, 'points', 20, 'radius0', 0.5, 'radius1', 2); 
    %
    % @author: Alberto Cuadra Lara
    %          Postdoctoral researcher - Group Fluid Mechanics
    %          Universidad Carlos III de Madrid
    %
    % Last update Oct 22 2023

    % Default
    FPS = 60;    % Frames per second
    points = 5;  % Number of points to advance
    radius0 = 1; % Radius for the inner arm
    radius1 = 1; % Radius for the outer arm
    
    % Miscellaneous
    color_draw = [0, 0, 0];
    color_arm = [1, 0.5961, 0.0902];
    
    % Get inputs
    for i = 1:2:nargin
        
        switch lower(varargin{i})
            case 'fps'
                FPS = varargin{i + 1};
            case 'points'
                points = varargin{i + 1};
            case 'radius0'
                radius0 = varargin{i + 1};
            case 'radius1'
                radius1 = varargin{i + 1};
        end

    end

    % Define the complex function
    z0 = @(theta) radius0 * exp(1i * theta);
    z1 = @(theta) radius0 * exp(1i * theta) + radius1 * exp(1i * pi * theta);
    
    % Initialize plot
    fig = figure('WindowKeyPressFcn', @keyPressFcn);

    % Plot settings
    hold on;
    axis equal;
    axis off;
    xlim([-1, 1] * (radius0 + radius1));
    ylim([-1, 1] * (radius0 + radius1));

    % Initialization
    timer_val = tic;
    running = true; 
    iteration = 1;
    range = [0, 0];
    line0 = plot(range, range, '-', 'Color', color_arm, 'LineWidth', 1.5);
    line1 = plot(range, range, '-o', 'Color', color_arm, 'LineWidth', 1.5);
    
    while running
        
        % Get values
        real_part = real(z1(range));
        imaginary_part = imag(z1(range));
    
        real_part0 = real(z0(range(end)));
        imaginary_part0 = imag(z0(range(end)));
    
        % Plot
        plot(real_part, imaginary_part, '-', 'Color', color_draw);

        % Update the position of the arms
        set(line0, 'XData', [0, real_part0], 'YData', [0, imaginary_part0]);
        set(line1, 'XData', [real_part0, real_part(end)], 'YData', [imaginary_part0, imaginary_part(end)]);

        % Update title
        titletext = sprintf('Frame %d, Time %.2f [s]', round(range(end) * 180 / pi), toc(timer_val));
        title(titletext, 'Interpreter', 'latex', 'FontSize', 16)

        % Pause to control frame rate
        pause(1 / FPS);
    
        % Update the iteration counter
        iteration = iteration + points;
        
        % Update the range of values to plot
        range = (iteration : (iteration + points)) / 180 * pi;

        % Check if the loop should stop
        if fig.UserData
            running = false;
        end

    end

end

% SUB-PASS FUNCTIONS
function keyPressFcn(obj, input)
    % Callback function for key presses

    % Check if the key pressed is the escape key
    if strcmpi(input.Key, 'escape')
        obj.UserData = true;
    end

end