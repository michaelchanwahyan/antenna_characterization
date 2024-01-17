classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        LeftPanel                 matlab.ui.container.Panel
        CasethicknessSlider       matlab.ui.control.Slider
        CasethicknessSliderLabel  matlab.ui.control.Label
        PermitivitySlider         matlab.ui.control.Slider
        PermitivitySliderLabel    matlab.ui.control.Label
        RightPanel                matlab.ui.container.Panel
        UIAxes                    matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Callback function
        function UIAxesButtonDown(app, event)

        end

        % Value changed function: CasethicknessSlider
        function CasethicknessSliderValueChanged(app, event)
            value_w = app.CasethicknessSlider.Value;
            value_Es = app.PermitivitySlider.Value;
c = 3e8;
f = 60e9;
g = 0.0046;
w = value_w ; % 0.0015;
Es = value_Es;
lambd = c / f;


TR13C_origin = [0,0,0];
TR13C_Tx_pt = [-lambd/2, +lambd/2, 0];
TR13C_R1_pt = [-lambd/2, -lambd/2, 0];
TR13C_R2_pt = [+lambd/2, +lambd/2, 0];
TR13C_R3_pt = [+lambd/2, -lambd/2, 0];

R = 1;
reflector_pt = [0, R, 0];

azi_start = -80;
azi_stop = +80;
azi_step = 4;

ele_start = -80;
ele_stop = +80;
ele_step =4;

phased_r31 = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);
phased_r32 = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);
ee = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);
aa = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);

for azi_deg = azi_start : azi_step : azi_stop
    for ele_deg = ele_start : ele_step : ele_stop
        if azi_deg == 0 && ele_deg == 0
            ;
        end
        e_idx = (ele_deg-ele_start)/ele_step+1;
        a_idx = (azi_deg-azi_start)/azi_step+1;
        ee(e_idx, a_idx) = ele_deg;
        aa(e_idx, a_idx) = azi_deg;
        reflector_pt = ...
            [ R * cosd(ele_deg) * sind(azi_deg) , ...
              R * sind(ele_deg) , ...
              R * cosd(ele_deg) * cosd(azi_deg) ];
        pathd_tr1 = norm(reflector_pt - TR13C_Tx_pt, 2) + norm(reflector_pt - TR13C_R1_pt, 2);
        pathd_tr2 = norm(reflector_pt - TR13C_Tx_pt, 2) + norm(reflector_pt - TR13C_R2_pt, 2);
        pathd_tr3 = norm(reflector_pt - TR13C_Tx_pt, 2) + norm(reflector_pt - TR13C_R3_pt, 2);
        if w > 0 && Es > 1
            % adjustment on pathd of tr1
            theta_t_2_refl = pi/2-atan2((reflector_pt(3) - TR13C_Tx_pt(3)), (reflector_pt(1) - TR13C_Tx_pt(1)));
            phi_t_2_refl = atan((reflector_pt(2) - TR13C_Tx_pt(2)) / sqrt((reflector_pt(1) - TR13C_Tx_pt(1))^2 + (reflector_pt(3) - TR13C_Tx_pt(3))^2));
            casing_medium_pathd_t = ...
                w * sqrt( ...
                        (1 / (cos(phi_t_2_refl) * sin(theta_t_2_refl)))^2 ...
                        + (1 / sin(phi_t_2_refl))^2 ...
                        + (1 / (cos(phi_t_2_refl) * cos(theta_t_2_refl)))^2 );
            % update
            pathd_tr1 = pathd_tr1 - casing_medium_pathd_t + 1/sqrt(Es)*casing_medium_pathd_t;
            theta_r1_2_refl = pi-atan2((reflector_pt(3) - TR13C_R1_pt(3)), (reflector_pt(1) - TR13C_R1_pt(1)));
            phi_r1_2_refl = atan((reflector_pt(2) - TR13C_R1_pt(2)) / sqrt((reflector_pt(1) - TR13C_R1_pt(1))^2 + (reflector_pt(3) - TR13C_R1_pt(3))^2));
            casing_medium_pathd_r1 = ...
                w * sqrt( ...
                        (1 / (cos(phi_r1_2_refl) * sin(theta_r1_2_refl)))^2 ...
                        + (1 / sin(phi_r1_2_refl))^2 ...
                        + (1 / (cos(phi_r1_2_refl) * cos(theta_r1_2_refl)))^2 );
            % update
            pathd_tr1 = pathd_tr1 - casing_medium_pathd_r1 + 1/sqrt(Es)*casing_medium_pathd_r1;

            % adjustment on pathd of tr2
            % update
            pathd_tr2 = pathd_tr2 - casing_medium_pathd_t + 1/sqrt(Es)*casing_medium_pathd_t;
            theta_r2_2_refl = pi/2-atan2((reflector_pt(3) - TR13C_R2_pt(3)), (reflector_pt(1) - TR13C_R2_pt(1)));
            phi_r2_2_refl = atan((reflector_pt(2) - TR13C_R2_pt(2)) / sqrt((reflector_pt(1) - TR13C_R2_pt(1))^2 + (reflector_pt(3) - TR13C_R2_pt(3))^2));
            casing_medium_pathd_r2 = ...
                w * sqrt( ...
                        (1 / (cos(phi_r2_2_refl) * sin(theta_r2_2_refl)))^2 ...
                        + (1 / sin(phi_r2_2_refl))^2 ...
                        + (1 / (cos(phi_r2_2_refl) * cos(theta_r2_2_refl)))^2 );
            % update
            pathd_tr2 = pathd_tr2 - casing_medium_pathd_r2 + 1/sqrt(Es)*casing_medium_pathd_r2;

            % adjustment on pathd of tr3
            % update
            pathd_tr3 = pathd_tr3 - casing_medium_pathd_t + 1/sqrt(Es)*casing_medium_pathd_t;
            theta_r3_2_refl = pi/2-atan2((reflector_pt(3) - TR13C_R3_pt(3)), (reflector_pt(1) - TR13C_R3_pt(1)));
            phi_r3_2_refl = atan((reflector_pt(2) - TR13C_R3_pt(2)) / sqrt((reflector_pt(1) - TR13C_R3_pt(1))^2 + (reflector_pt(3) - TR13C_R3_pt(3))^2));
            casing_medium_pathd_r3 = ...
                w * sqrt( ...
                        (1 / (cos(phi_r3_2_refl) * sin(theta_r3_2_refl)))^2 ...
                        + (1 / sin(phi_r3_2_refl))^2 ...
                        + (1 / (cos(phi_r3_2_refl) * cos(theta_r3_2_refl)))^2 );
            % update
            pathd_tr3 = pathd_tr3 - casing_medium_pathd_r3 + 1/sqrt(Es)*casing_medium_pathd_r3;
        end
        phased_r31(e_idx, a_idx) = 2*pi*(pathd_tr3 - pathd_tr1)/lambd;
        phased_r32(e_idx, a_idx) = 2*pi*(pathd_tr3 - pathd_tr2)/lambd;
    end % END OF for ele_deg = ele_start : ele_step : ele_stop
end % END OF for azi_deg = azi_start : azi_step : azi_stop
h = surf(app.UIAxes, ee, aa, phased_r31);
set(h, 'EdgeColor', 'black');
xlabel(app.UIAxes, 'elev deg'); ylabel(app.UIAxes, 'azim deg'); zlabel(app.UIAxes, 'phase diff');
zlim(app.UIAxes, [-8,8]); colormap(app.UIAxes, 'jet'); colorbar(app.UIAxes, 'east');
clim(app.UIAxes, [-4, 4]);
view(app.UIAxes, -130, 30);
grid(app.UIAxes, 'on');;
        end

        % Value changed function: PermitivitySlider
        function PermitivitySliderValueChanged(app, event)
            value_w = app.CasethicknessSlider.Value;
            value_Es = app.PermitivitySlider.Value;
c = 3e8;
f = 60e9;
g = 0.0046;
w = value_w ; % 0.0015;
Es = value_Es;
lambd = c / f;


TR13C_origin = [0,0,0];
TR13C_Tx_pt = [-lambd/2, +lambd/2, 0];
TR13C_R1_pt = [-lambd/2, -lambd/2, 0];
TR13C_R2_pt = [+lambd/2, +lambd/2, 0];
TR13C_R3_pt = [+lambd/2, -lambd/2, 0];

R = 1;
reflector_pt = [0, R, 0];

azi_start = -80;
azi_stop = +80;
azi_step = 4;

ele_start = -80;
ele_stop = +80;
ele_step =4;

phased_r31 = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);
phased_r32 = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);
ee = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);
aa = zeros((ele_stop-ele_start)/ele_step+1, (azi_stop-azi_start)/azi_step+1);

for azi_deg = azi_start : azi_step : azi_stop
    for ele_deg = ele_start : ele_step : ele_stop
        if azi_deg == 0 && ele_deg == 0
            ;
        end
        e_idx = (ele_deg-ele_start)/ele_step+1;
        a_idx = (azi_deg-azi_start)/azi_step+1;
        ee(e_idx, a_idx) = ele_deg;
        aa(e_idx, a_idx) = azi_deg;
        reflector_pt = ...
            [ R * cosd(ele_deg) * sind(azi_deg) , ...
              R * sind(ele_deg) , ...
              R * cosd(ele_deg) * cosd(azi_deg) ];
        pathd_tr1 = norm(reflector_pt - TR13C_Tx_pt, 2) + norm(reflector_pt - TR13C_R1_pt, 2);
        pathd_tr2 = norm(reflector_pt - TR13C_Tx_pt, 2) + norm(reflector_pt - TR13C_R2_pt, 2);
        pathd_tr3 = norm(reflector_pt - TR13C_Tx_pt, 2) + norm(reflector_pt - TR13C_R3_pt, 2);
        if w > 0 && Es > 1
            % adjustment on pathd of tr1
            theta_t_2_refl = pi/2-atan2((reflector_pt(3) - TR13C_Tx_pt(3)), (reflector_pt(1) - TR13C_Tx_pt(1)));
            phi_t_2_refl = atan((reflector_pt(2) - TR13C_Tx_pt(2)) / sqrt((reflector_pt(1) - TR13C_Tx_pt(1))^2 + (reflector_pt(3) - TR13C_Tx_pt(3))^2));
            casing_medium_pathd_t = ...
                w * sqrt( ...
                        (1 / (cos(phi_t_2_refl) * sin(theta_t_2_refl)))^2 ...
                        + (1 / sin(phi_t_2_refl))^2 ...
                        + (1 / (cos(phi_t_2_refl) * cos(theta_t_2_refl)))^2 );
            % update
            pathd_tr1 = pathd_tr1 - casing_medium_pathd_t + 1/sqrt(Es)*casing_medium_pathd_t;
            theta_r1_2_refl = pi-atan2((reflector_pt(3) - TR13C_R1_pt(3)), (reflector_pt(1) - TR13C_R1_pt(1)));
            phi_r1_2_refl = atan((reflector_pt(2) - TR13C_R1_pt(2)) / sqrt((reflector_pt(1) - TR13C_R1_pt(1))^2 + (reflector_pt(3) - TR13C_R1_pt(3))^2));
            casing_medium_pathd_r1 = ...
                w * sqrt( ...
                        (1 / (cos(phi_r1_2_refl) * sin(theta_r1_2_refl)))^2 ...
                        + (1 / sin(phi_r1_2_refl))^2 ...
                        + (1 / (cos(phi_r1_2_refl) * cos(theta_r1_2_refl)))^2 );
            % update
            pathd_tr1 = pathd_tr1 - casing_medium_pathd_r1 + 1/sqrt(Es)*casing_medium_pathd_r1;

            % adjustment on pathd of tr2
            % update
            pathd_tr2 = pathd_tr2 - casing_medium_pathd_t + 1/sqrt(Es)*casing_medium_pathd_t;
            theta_r2_2_refl = pi/2-atan2((reflector_pt(3) - TR13C_R2_pt(3)), (reflector_pt(1) - TR13C_R2_pt(1)));
            phi_r2_2_refl = atan((reflector_pt(2) - TR13C_R2_pt(2)) / sqrt((reflector_pt(1) - TR13C_R2_pt(1))^2 + (reflector_pt(3) - TR13C_R2_pt(3))^2));
            casing_medium_pathd_r2 = ...
                w * sqrt( ...
                        (1 / (cos(phi_r2_2_refl) * sin(theta_r2_2_refl)))^2 ...
                        + (1 / sin(phi_r2_2_refl))^2 ...
                        + (1 / (cos(phi_r2_2_refl) * cos(theta_r2_2_refl)))^2 );
            % update
            pathd_tr2 = pathd_tr2 - casing_medium_pathd_r2 + 1/sqrt(Es)*casing_medium_pathd_r2;

            % adjustment on pathd of tr3
            % update
            pathd_tr3 = pathd_tr3 - casing_medium_pathd_t + 1/sqrt(Es)*casing_medium_pathd_t;
            theta_r3_2_refl = pi/2-atan2((reflector_pt(3) - TR13C_R3_pt(3)), (reflector_pt(1) - TR13C_R3_pt(1)));
            phi_r3_2_refl = atan((reflector_pt(2) - TR13C_R3_pt(2)) / sqrt((reflector_pt(1) - TR13C_R3_pt(1))^2 + (reflector_pt(3) - TR13C_R3_pt(3))^2));
            casing_medium_pathd_r3 = ...
                w * sqrt( ...
                        (1 / (cos(phi_r3_2_refl) * sin(theta_r3_2_refl)))^2 ...
                        + (1 / sin(phi_r3_2_refl))^2 ...
                        + (1 / (cos(phi_r3_2_refl) * cos(theta_r3_2_refl)))^2 );
            % update
            pathd_tr3 = pathd_tr3 - casing_medium_pathd_r3 + 1/sqrt(Es)*casing_medium_pathd_r3;
        end
        phased_r31(e_idx, a_idx) = 2*pi*(pathd_tr3 - pathd_tr1)/lambd;
        phased_r32(e_idx, a_idx) = 2*pi*(pathd_tr3 - pathd_tr2)/lambd;
    end % END OF for ele_deg = ele_start : ele_step : ele_stop
end % END OF for azi_deg = azi_start : azi_step : azi_stop
h = surf(app.UIAxes, ee, aa, phased_r31);
set(h, 'EdgeColor', 'black');
xlabel(app.UIAxes, 'elev deg'); ylabel(app.UIAxes, 'azim deg'); zlabel(app.UIAxes, 'phase diff');
zlim(app.UIAxes, [-8,8]); colormap(app.UIAxes, 'jet'); colorbar(app.UIAxes, 'east');
clim(app.UIAxes, [-4, 4]);
view(app.UIAxes, -130, 30);
grid(app.UIAxes, 'on');
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create PermitivitySliderLabel
            app.PermitivitySliderLabel = uilabel(app.LeftPanel);
            app.PermitivitySliderLabel.HorizontalAlignment = 'right';
            app.PermitivitySliderLabel.Position = [13 45 60 22];
            app.PermitivitySliderLabel.Text = 'Permitivity';

            % Create PermitivitySlider
            app.PermitivitySlider = uislider(app.LeftPanel);
            app.PermitivitySlider.Limits = [1 3];
            app.PermitivitySlider.MajorTicks = [1 1.5 2 2.5 2.8 3];
            app.PermitivitySlider.Orientation = 'vertical';
            app.PermitivitySlider.ValueChangedFcn = createCallbackFcn(app, @PermitivitySliderValueChanged, true);
            app.PermitivitySlider.Position = [94 54 3 116];
            app.PermitivitySlider.Value = 1;

            % Create CasethicknessSliderLabel
            app.CasethicknessSliderLabel = uilabel(app.LeftPanel);
            app.CasethicknessSliderLabel.HorizontalAlignment = 'right';
            app.CasethicknessSliderLabel.Position = [12 281 87 22];
            app.CasethicknessSliderLabel.Text = 'Case thickness';

            % Create CasethicknessSlider
            app.CasethicknessSlider = uislider(app.LeftPanel);
            app.CasethicknessSlider.Limits = [0 0.003];
            app.CasethicknessSlider.MajorTicks = [0 0.0015 0.003];
            app.CasethicknessSlider.Orientation = 'vertical';
            app.CasethicknessSlider.ValueChangedFcn = createCallbackFcn(app, @CasethicknessSliderValueChanged, true);
            app.CasethicknessSlider.Position = [120 290 3 69];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Phase Response')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [60 148 300 185];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end