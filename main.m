close all
clear all
clc


c = 3e8;
f = 60e9;
g = 0.0046;
w = 0.0015;
Es = 3;
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

fig = figure;
h = surf(ee, aa, phased_r31);
set(h, 'EdgeColor', 'black');
xlabel('elev deg'); ylabel('azim deg'); zlabel('phase diff');
zlim([-8,8]); colormap jet; colorbar;
caxis([-4, 4]);
view(-130, 30); colormap jet; colorbar;
title('Phase difference Rx 3 - Rx 1');
