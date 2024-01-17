function func_plot_radiation( ...
    fname, ...
    R_POWER, ...
    R_PHASE_r32, ...
    R_AZIM_DEGREE_err, ...
    R_PHASE_r31, ...
    R_ELEV_DEGREE_err, ...
    elev_arr, ...
    azim_arr, ...
    ee, ...
    aa, ...
    savefig ...
    )
fig = figure(); set(fig, 'Name', strrep(fname, '.npy', ' power'));
subplot(1,3,1);
    h1 = surf(ee,aa,10*log10(R_POWER(:,:,1)));
    set(h1, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('power dB');
    zlim([-20, 20]);
    view(50, 30); colormap jet;
    title('Rx1 Antenna Power');
subplot(1,3,2);
    h2 = surf(ee,aa,10*log10(R_POWER(:,:,2)));
    set(h2, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('power dB');
    zlim([-20, 20]);
    view(50, 30); colormap jet;
    title('Rx2 Antenna Power');
subplot(1,3,3);
    h3 = surf(ee,aa,10*log10(R_POWER(:,:,3)));
    set(h3, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('power dB');
    zlim([-20, 20]);
    view(50, 30); colormap jet;
    title('Rx3 Antenna Power');
set( ...
    fig, ...
    'units', 'normalized', ...
    'outerposition', [0 0 1 1] ...
);

if savefig
    saveas(fig, [strrep(fname, '.npy', '_power.fig')]);
    saveas(fig, [strrep(fname, '.npy', '_power.png')]);
end

fig = figure(); set(fig, 'Name', strrep(fname, '.npy', ' power'));
subplot(1,3,1);
    h1 = pcolor(aa,ee,10*log10(R_POWER(:,:,1)));
    set(h1, 'EdgeColor', 'none');
    xlabel('elev deg'); ylabel('azim deg');
    clim([-20, 30]);
    colormap jet;
    title('Rx1 Antenna Power');
subplot(1,3,2);
    h2 = pcolor(aa,ee,10*log10(R_POWER(:,:,2)));
    set(h2, 'EdgeColor', 'none');
    xlabel('elev deg'); ylabel('azim deg');
    clim([-20, 30]);
    colormap jet;
    title('Rx2 Antenna Power');
subplot(1,3,3);
    h3 = pcolor(aa,ee,10*log10(R_POWER(:,:,3)));
    set(h3, 'EdgeColor', 'none');
    xlabel('elev deg'); ylabel('azim deg');
    clim([-20, 30]);
    colormap jet;
    title('Rx3 Antenna Power');
    colorbar;
set( ...
    fig, ...
    'units', 'normalized', ...
    'outerposition', [0 0 1 0.6] ...
);

if savefig
    saveas(fig, [strrep(fname, '.npy', '_flatpower.fig')]);
    saveas(fig, [strrep(fname, '.npy', '_flatpower.png')]);
end

fig = figure(); set(fig, 'Name', strrep(fname, '.npy', ' horiz phase'));
subplot(2,2,1);
    h1 = surf(ee,aa,R_PHASE_r32);
    set(h1, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('phase diff deg');
    view(50, 30); colormap jet; colorbar;
    title('Phase difference Rx 3 - Rx 2');
subplot(2,2,2);
    h2 = contourf(ee,aa,R_PHASE_r32, 24);
    xlabel('elev deg'); ylabel('azim deg');
    axis equal; colorbar;
    title('Phase difference Rx 3 - Rx 2');
subplot(2,2,3);
    h3 = surf(ee,aa,abs(R_AZIM_DEGREE_err));
    set(h3, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('azim offset deg');
    view(50, 30); colormap jet; colorbar; clim([0,40]);
    title('azim absolute offset deg');
subplot(2,2,4);
    h4 = contourf(ee,aa,abs(R_AZIM_DEGREE_err), 24);
    xlabel('elev deg'); ylabel('azim deg'); clim([0,40]);
    axis equal; colorbar;
    title('azim absolute offset deg');

set( ...
    fig, ...
    'units', 'normalized', ...
    'outerposition', [0 0 1 1] ...
);

if savefig
    saveas(fig, [strrep(fname, '.npy', '_horiz_phase.fig')]);
    saveas(fig, [strrep(fname, '.npy', '_horiz_phase.png')]);
end

fig = figure(); set(fig, 'Name', strrep(fname, '.npy', ' vert phase'));
subplot(2,2,1);
    h1 = surf(ee,aa,R_PHASE_r31);
    set(h1, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('phase diff deg');
    view(-50, 30); colormap jet; colorbar;
    title('Phase difference Rx 3 - Rx 1');
subplot(2,2,2);
    h2 = contourf(ee,aa,R_PHASE_r31, 24);
    xlabel('elev deg'); ylabel('azim deg');
    axis equal; colorbar;
    title('Phase difference Rx 3 - Rx 1');
subplot(2,2,3);
    h3 = surf(ee,aa,abs(R_ELEV_DEGREE_err));
    set(h3, 'EdgeColor', 'black');
    xlabel('elev deg'); ylabel('azim deg'); zlabel('azim offset deg');
    view(-50, 30); colormap jet; colorbar; clim([0,40]);
    title('elev absolute offset deg');
subplot(2,2,4);
    h4 = contourf(ee,aa,abs(R_ELEV_DEGREE_err), 24);
    xlabel('elev deg'); ylabel('azim deg'); clim([0,40]);
    axis equal; colorbar;
    title('elev absolute offset deg');

set( ...
    fig, ...
    'units', 'normalized', ...
    'outerposition', [0 0 1 1] ...
);

if savefig
    saveas(fig, [strrep(fname, '.npy', '_elev_phase.fig')]);
    saveas(fig, [strrep(fname, '.npy', '_elev_phase.png')]);
end

fig = figure; set(fig, 'Name', strrep(fname, '.npy', ' power lineplot'));
vi = 0;
azim_view_deg_arr = [ -16:8:16 ];
elev_view_deg_arr = [ -32:8:0 ];
for azim_view_deg = azim_view_deg_arr
    vi = vi + 1; subplot(length(azim_view_deg_arr),2,vi*2-1);
        normal_azim_idx = find(azim_arr == azim_view_deg);
        r1_verti0_power = R_POWER(:, normal_azim_idx, 1);
        r2_verti0_power = R_POWER(:, normal_azim_idx, 2);
        r3_verti0_power = R_POWER(:, normal_azim_idx, 3);
    hold on;
        h7 = plot(elev_arr, 10*log10(r1_verti0_power)); set(h7, 'LineWidth', 2);
        h8 = plot(elev_arr, 10*log10(r2_verti0_power)); set(h8, 'LineWidth', 2);
        h9 = plot(elev_arr, 10*log10(r3_verti0_power)); set(h9, 'LineWidth', 2);
    ylim([-20,20]); xlabel('elev'); ylabel('power dB');
    title(sprintf('vertical direction power @ azim %d deg', azim_view_deg));
    hl = legend('r1 elev power', 'r2 elev power', 'r3 elev power');
    set(hl, 'Location', 'South');
    grid on;
end

vi = 0;
for elev_view_deg = elev_view_deg_arr
    vi = vi + 1; subplot(length(elev_view_deg_arr),2,vi*2-0);
        normal_elev_idx = find(elev_arr == elev_view_deg);
        r1_horiz0_power = R_POWER(normal_elev_idx, :, 1);
        r2_horiz0_power = R_POWER(normal_elev_idx, :, 2);
        r3_horiz0_power = R_POWER(normal_elev_idx, :, 3);
    hold on;
        h7 = plot(azim_arr, 10*log10(r1_horiz0_power)); set(h7, 'LineWidth', 2);
        h8 = plot(azim_arr, 10*log10(r2_horiz0_power)); set(h8, 'LineWidth', 2);
        h9 = plot(azim_arr, 10*log10(r3_horiz0_power)); set(h9, 'LineWidth', 2);
    ylim([-20,20]); xlabel('azim'); ylabel('power dB');
    title(sprintf('horizontal direction power @ elev %d deg', elev_view_deg));
    hl = legend('r1 azim power', 'r2 azim power', 'r3 azim power');
    set(hl, 'Location', 'South');
    grid on;
end

set( ...
    fig, ...
    'units', 'normalized', ...
    'outerposition', [0 0 1 1] ...
);

if savefig
    saveas(fig, [strrep(fname, '.npy', '_power_lineplot.fig')]);
    saveas(fig, [strrep(fname, '.npy', '_power_lineplot.png')]);
end
end % END OF function func_plot_radiation(