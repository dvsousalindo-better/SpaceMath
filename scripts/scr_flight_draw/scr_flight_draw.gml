function scr_flight_draw(_flight) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var progress = 1 - _flight.distance_remaining / 384400;
    var star_offset = _flight.elapsed_seconds * 30;

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(5, 10, 25));
    draw_rectangle(0, 0, gui_width, gui_height, false);

    for (var i = 0; i < 96; i += 1) {
        var star_x = (i * 197 + i * i * 31 + 83) % gui_width;
        var star_y = (i * 113 + i * i * 17 + floor(star_offset) + 47) % gui_height;
        draw_set_color(c_white);
        draw_set_alpha(0.35 + (i % 4) * 0.15);
        draw_circle(star_x, star_y, 1 + (i % 3 == 0), false);
    }

    for (var i = 0; i < ds_list_size(_flight.meteors); i += 1) {
        var meteor = ds_list_find_value(_flight.meteors, i);
        if (meteor.giant) {
            draw_set_alpha(0.7);
            draw_set_color(make_color_rgb(255, 190, 124));
            draw_circle(meteor.x, meteor.y, meteor.radius + 5, false);
        }
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(153, 94, 67));
        draw_circle(meteor.x, meteor.y, meteor.radius, false);
        draw_set_color(make_color_rgb(207, 142, 94));
        draw_circle(meteor.x - meteor.radius * 0.25, meteor.y - meteor.radius * 0.18, meteor.radius * 0.22, false);
        draw_circle(meteor.x + meteor.radius * 0.28, meteor.y + meteor.radius * 0.24, meteor.radius * 0.16, false);
    }

    draw_set_color(make_color_rgb(79, 181, 222));
    draw_triangle(_flight.ship_x, _flight.ship_y - 29,
        _flight.ship_x - 20, _flight.ship_y + 22,
        _flight.ship_x + 20, _flight.ship_y + 22, false);
    draw_set_color(make_color_rgb(235, 242, 248));
    draw_triangle(_flight.ship_x, _flight.ship_y - 21,
        _flight.ship_x - 11, _flight.ship_y + 14,
        _flight.ship_x + 11, _flight.ship_y + 14, false);
    draw_set_color(make_color_rgb(49, 117, 160));
    draw_circle(_flight.ship_x, _flight.ship_y - 4, 6, false);
    draw_set_color(make_color_rgb(247, 185, 87));
    draw_triangle(_flight.ship_x - 7, _flight.ship_y + 21,
        _flight.ship_x, _flight.ship_y + 37 + (floor(_flight.elapsed_seconds * 20) % 5),
        _flight.ship_x + 7, _flight.ship_y + 21, false);

    for (var i = 0; i < ds_list_size(_flight.explosions); i += 1) {
        var explosion = ds_list_find_value(_flight.explosions, i);
        var explosion_progress = clamp(explosion.timer / explosion.duration, 0, 1);
        var explosion_radius = explosion.max_radius
            * (1 - power(1 - explosion_progress, 2));
        draw_set_alpha(1 - explosion_progress);
        draw_set_color(make_color_rgb(255, 190, 94));
        draw_circle(explosion.x, explosion.y, explosion_radius, false);
        draw_set_color(make_color_rgb(255, 235, 166));
        draw_circle(explosion.x, explosion.y, explosion_radius * 0.55, false);
    }

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(12, 22, 39));
    draw_rectangle(24, 20, gui_width - 24, 135, false);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_rectangle(24, 20, gui_width - 24, 23, false);
    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(48, 47, "DISTÂNCIA: " + string(floor(_flight.distance_remaining)) + " km");
    draw_set_halign(fa_right);
    draw_text(gui_width - 48, 47, "TEMPO: " + string(floor(_flight.elapsed_seconds / 60)) + " min");

    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(48, 118, "PROTEÇÃO");
    for (var i = 0; i < 5; i += 1) {
        if (i < _flight.shield_remaining) {
            draw_set_color(make_color_rgb(82, 205, 146));
        } else {
            draw_set_color(make_color_rgb(76, 83, 99));
        }
        draw_circle(220 + i * 27, 118, 9, false);
    }

    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(48, 77, "COMBUSTÍVEL");
    draw_set_color(make_color_rgb(54, 68, 87));
    draw_rectangle(48, 91, 248, 101, false);
    draw_set_color(make_color_rgb(93, 204, 148));
    draw_rectangle(51, 94, 51 + 194 * _flight.fuel, 98, false);
    draw_set_color(c_white);
    draw_text(260, 96, string(floor(_flight.fuel * 100)) + "%");

    var drift_label = "TRAJETÓRIA NOMINAL";
    if (_flight.route_error_count == 1) {
        drift_label = "DESVIO LEVE";
    } else if (_flight.route_error_count >= 2) {
        drift_label = "DESVIO FORTE";
    }
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(238, 202, 119));
    draw_text(gui_width - 48, 118, drift_label);

    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(gui_width * 0.5, gui_height - 25,
        "A/D ou setas: mover | Toque 2x: teleporte (10% combustível) | Esc: menu");

    if (_flight.hit_flash > 0) {
        draw_set_alpha(_flight.hit_flash * 0.65);
        draw_set_color(make_color_rgb(255, 53, 65));
        draw_rectangle(0, 0, gui_width, gui_height, false);
    }

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(21, 94, 165));
    draw_circle(gui_width * 0.12, gui_height * 0.30, 39, false);
    draw_set_color(make_color_rgb(43, 149, 205));
    draw_circle(gui_width * 0.12 - 9, gui_height * 0.30 - 8, 24, false);
    draw_set_color(make_color_rgb(44, 125, 87));
    draw_circle(gui_width * 0.12 + 10, gui_height * 0.30 + 8, 10, false);
    draw_circle(gui_width * 0.12 - 17, gui_height * 0.30 + 12, 8, false);

    var moon_radius = 17 + progress * 27;
    draw_set_color(make_color_rgb(195, 205, 217));
    draw_circle(gui_width * 0.88, gui_height * 0.30, moon_radius, false);
    draw_set_color(make_color_rgb(145, 158, 177));
    draw_circle(gui_width * 0.88 - moon_radius * 0.35, gui_height * 0.30 - moon_radius * 0.17, moon_radius * 0.18, false);
    draw_circle(gui_width * 0.88 + moon_radius * 0.35, gui_height * 0.30 + moon_radius * 0.28, moon_radius * 0.13, false);
    draw_circle(gui_width * 0.88 - moon_radius * 0.12, gui_height * 0.30 + moon_radius * 0.43, moon_radius * 0.10, false);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(gui_width * 0.12, gui_height * 0.41, "TERRA");
    draw_text(gui_width * 0.88, gui_height * 0.41, "LUA");

    var progress_y = gui_height * 0.37;
    var progress_left = gui_width * 0.12;
    var progress_right = gui_width * 0.88;
    var fuel_red = 1 - _flight.fuel;
    draw_set_color(make_color_rgb(
        lerp(95, 130, fuel_red),
        lerp(117, 30, fuel_red),
        lerp(153, 38, fuel_red)
    ));
    draw_rectangle(progress_left, progress_y - 7, progress_right, progress_y + 7, false);
    draw_set_color(make_color_rgb(
        lerp(120, 255, fuel_red),
        lerp(213, 48, fuel_red),
        lerp(255, 58, fuel_red)
    ));
    draw_rectangle(progress_left, progress_y - 5,
        progress_left + (progress_right - progress_left) * progress,
        progress_y + 5, false);

    if (_flight.teleport_flash > 0) {
        draw_set_alpha(_flight.teleport_flash / 0.28);
        draw_set_color(make_color_rgb(140, 235, 255));
        draw_circle(_flight.ship_x, _flight.ship_y, 34, false);
        draw_set_alpha(1);
    }

    if (_flight.meteor_cutscene_active) {
        var zoom_progress = clamp((_flight.meteor_cutscene_timer - 0.75) / 3.5, 0, 1);
        var zoom_ease = zoom_progress * zoom_progress * (3 - 2 * zoom_progress);
        var camera_zoom = lerp(2.8, 0.48, zoom_ease);
        var camera_x = gui_width * 0.5;
        var camera_y = gui_height * 0.52;
        var rocket_x = camera_x;
        var rocket_y = camera_y;

        draw_set_alpha(0.98);
        draw_set_color(make_color_rgb(3, 8, 20));
        draw_rectangle(0, 0, gui_width, gui_height, false);
        draw_set_alpha(1);

        for (var i = 0; i < 150; i += 1) {
            var star_world_x = (i * 7919 + i * i * 1049 + 173) % 3601 - 1800;
            var star_world_y = (i * 6151 + i * i * 733 + 89) % 2401 - 1200;
            var star_x = camera_x + star_world_x * camera_zoom;
            var star_y = camera_y + star_world_y * camera_zoom;
            draw_set_color(c_white);
            draw_set_alpha(0.3 + (i % 4) * 0.12);
            draw_circle(star_x, star_y, max(1, camera_zoom * (0.7 + (i % 3) * 0.35)), false);
        }

        var meteor_count = 240;
        for (var i = 0; i < meteor_count; i += 1) {
            var meteor_depth = (i % 11) / 10;
            var forward_distance = 220 + (i * 6151 + i * i * 733 + 431) % 1781;
            var meteor_lane = ((i * 7919 + i * i * 1049 + 617) % 2001) / 1000 - 1;
            var meteor_world_x = meteor_lane * (90 + forward_distance * 0.38)
                + sin(i * 17) * forward_distance * 0.035;
            var meteor_world_y = -forward_distance;
            var meteor_x = camera_x + meteor_world_x * camera_zoom;
            var meteor_y = camera_y + meteor_world_y * camera_zoom;
            var giant_scale = i % 31 == 0 ? 2.8 : 1;
            var meteor_world_radius = min((14 + (i * 37) % 35) * giant_scale,
                forward_distance * 0.35);
            var meteor_radius = meteor_world_radius * camera_zoom
                * lerp(0.72, 1.15, meteor_depth);
            var meteor_alpha = lerp(0.42, 0.96, meteor_depth);

            draw_set_alpha(meteor_alpha);
            draw_set_color(meteor_depth > 0.72
                ? make_color_rgb(207, 142, 94)
                : make_color_rgb(153, 94, 67));
            draw_circle(meteor_x, meteor_y, meteor_radius, false);
            if (meteor_depth > 0.58 || giant_scale > 1) {
                draw_set_color(make_color_rgb(235, 174, 111));
                draw_circle(meteor_x - meteor_radius * 0.26,
                    meteor_y - meteor_radius * 0.2, meteor_radius * 0.22, false);
            }
        }

        draw_set_alpha(1);
        draw_set_color(make_color_rgb(79, 181, 222));
        draw_triangle(rocket_x, rocket_y - 29 * camera_zoom,
            rocket_x - 20 * camera_zoom, rocket_y + 22 * camera_zoom,
            rocket_x + 20 * camera_zoom, rocket_y + 22 * camera_zoom, false);
        draw_set_color(make_color_rgb(235, 242, 248));
        draw_triangle(rocket_x, rocket_y - 21 * camera_zoom,
            rocket_x - 11 * camera_zoom, rocket_y + 14 * camera_zoom,
            rocket_x + 11 * camera_zoom, rocket_y + 14 * camera_zoom, false);
        draw_set_color(make_color_rgb(49, 117, 160));
        draw_circle(rocket_x, rocket_y - 4 * camera_zoom, 6 * camera_zoom, false);

        draw_set_font(fnt_ui_title);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 190, 124));
        if (_flight.meteor_cutscene_stage == "focus") {
            draw_text(gui_width * 0.5, gui_height * 0.16, "SINAL DE ALERTA");
        } else if (_flight.meteor_cutscene_stage == "reveal") {
            draw_text(gui_width * 0.5, gui_height * 0.16, "CAMPO DE METEOROS DETECTADO");
        } else if (_flight.meteor_cutscene_stage == "intensify") {
            draw_text(gui_width * 0.5, gui_height * 0.16, "A CHUVA DE METEOROS SE APROXIMA");
        } else {
            draw_text(gui_width * 0.5, gui_height * 0.16, "PREPARE-SE PARA ATRAVESSAR O CAMPO");
        }
        draw_set_font(fnt_ui);
        draw_set_color(c_white);
        if (_flight.meteor_cutscene_stage == "stabilize") {
            draw_text(gui_width * 0.5, gui_height * 0.86, "Controle da nave em instantes...");
        } else {
            draw_text(gui_width * 0.5, gui_height * 0.86, "A nave está entrando em uma região perigosa.");
        }
        draw_set_alpha(1);
    }

    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
