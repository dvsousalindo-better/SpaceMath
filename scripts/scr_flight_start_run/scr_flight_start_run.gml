function scr_flight_start_run(_math_run) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var route_error_count = _math_run.route_error_count;
    var drift_speed = 0;

    if (route_error_count == 1) {
        drift_speed = 14;
    } else if (route_error_count >= 2) {
        drift_speed = 30;
    }

    var flight = {
        distance_remaining: 384400,
        elapsed_seconds: 0,
        ship_x: gui_width * 0.5,
        ship_y: gui_height * 0.81,
        shield_remaining: _math_run.shield_remaining,
        fuel: 1,
        left_tap_timer: 0,
        right_tap_timer: 0,
        teleport_flash: 0,
        route_error_count: route_error_count,
        drift_speed: drift_speed,
        drift_direction: choose(-1, 1),
        meteor_timer: 1.2,
        meteors: ds_list_create(),
        meteor_spawn_counts: [0, 0, 0],
        giant_meteor_target: irandom_range(1, 3),
        giant_meteors_spawned: 0,
        next_giant_meteor_progress: random_range(0.12, 0.18),
        meteor_collision_target: irandom_range(1, 2),
        meteor_collision_pairs_spawned: 0,
        meteor_collision_events: 0,
        next_meteor_collision_progress: random_range(0.12, 0.20),
        explosions: ds_list_create(),
        meteor_cutscene_seen: false,
        meteor_cutscene_active: false,
        meteor_cutscene_timer: 0,
        meteor_cutscene_stage: "inactive",
        hit_flash: 0,
        collision_count: 0,
        outcome: ""
    };

    if (flight.shield_remaining <= 0) {
        flight.outcome = "defeat";
    }

    return flight;
}
