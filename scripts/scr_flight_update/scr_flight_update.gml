function scr_flight_update(_flight, _delta_seconds) {
    if (_flight.outcome != "") {
        return;
    }

    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var elapsed = min(_delta_seconds, 0.05);

    if (_flight.meteor_cutscene_active) {
        _flight.meteor_cutscene_timer += elapsed;
        if (_flight.meteor_cutscene_timer < 0.8) {
            _flight.meteor_cutscene_stage = "focus";
        } else if (_flight.meteor_cutscene_timer < 3.5) {
            _flight.meteor_cutscene_stage = "reveal";
        } else if (_flight.meteor_cutscene_timer < 4.25) {
            _flight.meteor_cutscene_stage = "intensify";
        } else {
            _flight.meteor_cutscene_stage = "stabilize";
        }

        if (_flight.meteor_cutscene_timer >= 5) {
            _flight.meteor_cutscene_active = false;
            _flight.meteor_cutscene_stage = "inactive";
        }
        return;
    }

    var horizontal_input = 0;
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        horizontal_input -= 1;
    }
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        horizontal_input += 1;
    }

    _flight.left_tap_timer = max(0, _flight.left_tap_timer - elapsed);
    _flight.right_tap_timer = max(0, _flight.right_tap_timer - elapsed);
    _flight.teleport_flash = max(0, _flight.teleport_flash - elapsed);

    var left_pressed = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
    var right_pressed = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
    if (left_pressed) {
        if (_flight.left_tap_timer > 0) {
            if (_flight.fuel >= 0.1) {
                _flight.ship_x = max(34, _flight.ship_x - 300);
                _flight.fuel = max(0, _flight.fuel - 0.1);
                _flight.teleport_flash = 0.28;
            }
            _flight.left_tap_timer = 0;
        } else {
            _flight.left_tap_timer = 0.32;
        }
    } else if (right_pressed) {
        if (_flight.right_tap_timer > 0) {
            if (_flight.fuel >= 0.1) {
                _flight.ship_x = min(gui_width - 34, _flight.ship_x + 300);
                _flight.fuel = max(0, _flight.fuel - 0.1);
                _flight.teleport_flash = 0.28;
            }
            _flight.right_tap_timer = 0;
        } else {
            _flight.right_tap_timer = 0.32;
        }
    }

    var drift = _flight.drift_speed * _flight.drift_direction;
    _flight.ship_x += (horizontal_input * 420 + drift) * elapsed;
    _flight.ship_x = clamp(_flight.ship_x, 34, gui_width - 34);

    _flight.elapsed_seconds += elapsed;
    var previous_progress = clamp(1 - _flight.distance_remaining / 384400, 0, 1);
    var fuel_speed_multiplier = lerp(0.75, 1, _flight.fuel);
    _flight.distance_remaining = max(0,
        _flight.distance_remaining - (384400 / 240) * fuel_speed_multiplier * elapsed);
    var flight_progress = clamp(1 - _flight.distance_remaining / 384400, 0, 1);
    _flight.fuel = max(0, _flight.fuel - (flight_progress - previous_progress) * 0.5);
    _flight.hit_flash = max(0, _flight.hit_flash - elapsed);

    if (flight_progress >= 0.5 && !_flight.meteor_cutscene_seen) {
        _flight.meteor_cutscene_seen = true;
        _flight.meteor_cutscene_active = true;
        _flight.meteor_cutscene_timer = 0;
        _flight.meteor_cutscene_stage = "focus";
        return;
    }

    _flight.meteor_timer -= elapsed;
    var spawn_collision_pair = _flight.meteor_collision_pairs_spawned < _flight.meteor_collision_target
        && flight_progress >= _flight.next_meteor_collision_progress;

    if (_flight.meteor_timer <= 0 || spawn_collision_pair) {
        var meteor_speed_multiplier = global.game_difficulty == "medium"
            ? choose(2.5, 3)
            : choose(1.5, 2);
        var meteor_size_multiplier = global.game_difficulty == "medium" ? 3 : 2;
        var maximum_spawn_rate_increase = global.game_difficulty == "medium" ? 2 : 1;
        var meteor_spawn_rate_multiplier = 1
            + min(flight_progress / 0.5, 1) * maximum_spawn_rate_increase;

        if (spawn_collision_pair) {
            var boundary_one_count = _flight.meteor_spawn_counts[0] + _flight.meteor_spawn_counts[1];
            var boundary_two_count = _flight.meteor_spawn_counts[1] + _flight.meteor_spawn_counts[2];
            var boundary_index = boundary_one_count == boundary_two_count
                ? irandom_range(1, 2)
                : (boundary_one_count < boundary_two_count ? 1 : 2);
            var boundary_x = gui_width * boundary_index / 3;
            var pair_radius = irandom_range(12, 24) * meteor_size_multiplier;
            var pair_offset = pair_radius * 1.25;
            var pair_speed = irandom_range(170, 270) * meteor_speed_multiplier;
            var pair_horizontal_speed = max(120, pair_radius * 1.5);
            var pair_x_left = boundary_x - pair_offset;
            var pair_x_right = boundary_x + pair_offset;
            var left_zone = clamp(floor(pair_x_left / (gui_width / 3)), 0, 2);
            var right_zone = clamp(floor(pair_x_right / (gui_width / 3)), 0, 2);

            var left_meteor = {
                x: pair_x_left,
                y: -30,
                radius: pair_radius,
                speed: pair_speed,
                vx: pair_horizontal_speed,
                vy: pair_speed,
                giant: false,
                rotation: irandom(359),
                spin: irandom_range(-80, 80)
            };
            var right_meteor = {
                x: pair_x_right,
                y: -30,
                radius: pair_radius,
                speed: pair_speed,
                vx: -pair_horizontal_speed,
                vy: pair_speed,
                giant: false,
                rotation: irandom(359),
                spin: irandom_range(-80, 80)
            };

            ds_list_add(_flight.meteors, left_meteor);
            ds_list_add(_flight.meteors, right_meteor);
            _flight.meteor_spawn_counts[left_zone] += 1;
            _flight.meteor_spawn_counts[right_zone] += 1;
            _flight.meteor_collision_pairs_spawned += 1;
            _flight.next_meteor_collision_progress += random_range(0.30, 0.38);
        } else {
            var is_giant = false;
            if (_flight.giant_meteors_spawned < _flight.giant_meteor_target
                && flight_progress >= _flight.next_giant_meteor_progress) {
                is_giant = true;
                _flight.giant_meteors_spawned += 1;
                _flight.next_giant_meteor_progress += random_range(0.20, 0.24);
            }

            var meteor_radius = irandom_range(12, 24) * meteor_size_multiplier;
            if (is_giant) {
                meteor_radius *= 6;
            }

            var minimum_spawn_count = min(_flight.meteor_spawn_counts[0],
                min(_flight.meteor_spawn_counts[1], _flight.meteor_spawn_counts[2]));
            var available_zone_count = 0;
            for (var zone = 0; zone < 3; zone += 1) {
                if (_flight.meteor_spawn_counts[zone] == minimum_spawn_count) {
                    available_zone_count += 1;
                }
            }

            var zone_pick = irandom(available_zone_count - 1);
            var spawn_zone = -1;
            for (var zone = 0; zone < 3; zone += 1) {
                if (_flight.meteor_spawn_counts[zone] == minimum_spawn_count) {
                    if (zone_pick == 0) {
                        spawn_zone = zone;
                        break;
                    }
                    zone_pick -= 1;
                }
            }

            var zone_width = gui_width / 3;
            var spawn_left = max(meteor_radius, spawn_zone * zone_width);
            var spawn_right = min(gui_width - meteor_radius, (spawn_zone + 1) * zone_width);
            var meteor_speed = irandom_range(170, 270) * meteor_speed_multiplier;
            var meteor = {
                x: random_range(spawn_left, spawn_right),
                y: -30,
                radius: meteor_radius,
                speed: meteor_speed,
                vx: 0,
                vy: meteor_speed,
                giant: is_giant,
                rotation: irandom(359),
                spin: irandom_range(-80, 80)
            };
            ds_list_add(_flight.meteors, meteor);
            _flight.meteor_spawn_counts[spawn_zone] += 1;
        }

        _flight.meteor_timer = random_range(1.25, 2.1) / meteor_spawn_rate_multiplier;
    }

    for (var i = ds_list_size(_flight.meteors) - 1; i >= 0; i -= 1) {
        var meteor = ds_list_find_value(_flight.meteors, i);
        meteor.x += meteor.vx * elapsed;
        meteor.y += meteor.vy * elapsed;
        meteor.rotation += meteor.spin * elapsed;

        if (meteor.x < meteor.radius || meteor.x > gui_width - meteor.radius) {
            meteor.x = clamp(meteor.x, meteor.radius, gui_width - meteor.radius);
            meteor.vx = -meteor.vx;
        }
        ds_list_replace(_flight.meteors, i, meteor);

        if (meteor.y > gui_height + meteor.radius
            || (meteor.y < -meteor.radius && meteor.vy < 0)) {
            ds_list_delete(_flight.meteors, i);
        } else if (point_distance(_flight.ship_x, _flight.ship_y, meteor.x, meteor.y)
            <= meteor.radius + 22) {
            _flight.shield_remaining = max(0, _flight.shield_remaining - 1);
            _flight.collision_count += 1;
            _flight.hit_flash = 0.28;
            ds_list_delete(_flight.meteors, i);

            if (_flight.shield_remaining <= 0) {
                _flight.outcome = "defeat";
                return;
            }
        }
    }

    for (var i = ds_list_size(_flight.explosions) - 1; i >= 0; i -= 1) {
        var explosion = ds_list_find_value(_flight.explosions, i);
        explosion.timer += elapsed;
        if (explosion.timer >= explosion.duration) {
            ds_list_delete(_flight.explosions, i);
        } else {
            ds_list_replace(_flight.explosions, i, explosion);
        }
    }

    var meteor_count = ds_list_size(_flight.meteors);
    var grouped_meteors = array_create(meteor_count, false);
    var remove_meteors = array_create(meteor_count, false);

    for (var i = 0; i < meteor_count; i += 1) {
        if (grouped_meteors[i]) {
            continue;
        }

        var collision_group = ds_list_create();
        ds_list_add(collision_group, i);
        grouped_meteors[i] = true;
        var group_cursor = 0;

        while (group_cursor < ds_list_size(collision_group)) {
            var member_index = ds_list_find_value(collision_group, group_cursor);
            var member = ds_list_find_value(_flight.meteors, member_index);
            group_cursor += 1;

            for (var j = 0; j < meteor_count; j += 1) {
                if (!grouped_meteors[j]) {
                    var candidate = ds_list_find_value(_flight.meteors, j);
                    if (point_distance(member.x, member.y, candidate.x, candidate.y)
                        <= member.radius + candidate.radius) {
                        grouped_meteors[j] = true;
                        ds_list_add(collision_group, j);
                    }
                }
            }
        }

        var group_size = ds_list_size(collision_group);
        if (group_size > 1) {
            var group_has_giant = false;
            var explosion_x = 0;
            var explosion_y = 0;

            for (var j = 0; j < group_size; j += 1) {
                var member_index = ds_list_find_value(collision_group, j);
                var member = ds_list_find_value(_flight.meteors, member_index);
                group_has_giant = group_has_giant || member.giant;
                explosion_x += member.x;
                explosion_y += member.y;
            }

            if (group_has_giant) {
                for (var a = 0; a < group_size; a += 1) {
                    var index_a = ds_list_find_value(collision_group, a);
                    var meteor_a = ds_list_find_value(_flight.meteors, index_a);
                    for (var b = a + 1; b < group_size; b += 1) {
                        var index_b = ds_list_find_value(collision_group, b);
                        var meteor_b = ds_list_find_value(_flight.meteors, index_b);
                        var dx = meteor_b.x - meteor_a.x;
                        var dy = meteor_b.y - meteor_a.y;
                        var distance = point_distance(meteor_a.x, meteor_a.y,
                            meteor_b.x, meteor_b.y);
                        var normal_x = distance > 0.001 ? dx / distance : 1;
                        var normal_y = distance > 0.001 ? dy / distance : 0;
                        var overlap = meteor_a.radius + meteor_b.radius - distance;

                        if (overlap > 0) {
                            var relative_speed = (meteor_a.vx - meteor_b.vx) * normal_x
                                + (meteor_a.vy - meteor_b.vy) * normal_y;
                            if (relative_speed > 0) {
                                var inverse_mass_a = 1 / (meteor_a.radius * meteor_a.radius);
                                var inverse_mass_b = 1 / (meteor_b.radius * meteor_b.radius);
                                var impulse = 2 * relative_speed / (inverse_mass_a + inverse_mass_b);
                                meteor_a.vx -= impulse * inverse_mass_a * normal_x;
                                meteor_a.vy -= impulse * inverse_mass_a * normal_y;
                                meteor_b.vx += impulse * inverse_mass_b * normal_x;
                                meteor_b.vy += impulse * inverse_mass_b * normal_y;
                            }

                            var separation = overlap * 0.5 + 0.5;
                            meteor_a.x -= normal_x * separation;
                            meteor_a.y -= normal_y * separation;
                            meteor_b.x += normal_x * separation;
                            meteor_b.y += normal_y * separation;
                            ds_list_replace(_flight.meteors, index_a, meteor_a);
                            ds_list_replace(_flight.meteors, index_b, meteor_b);
                        }
                    }
                }
            } else {
                for (var j = 0; j < group_size; j += 1) {
                    var member_index = ds_list_find_value(collision_group, j);
                    remove_meteors[member_index] = true;
                }

                _flight.meteor_collision_events += 1;
                ds_list_add(_flight.explosions, {
                    x: explosion_x / group_size,
                    y: explosion_y / group_size,
                    meteor_count: group_size,
                    timer: 0,
                    duration: 0.9,
                    max_radius: 20 + group_size * 16
                });
            }
        }

        ds_list_destroy(collision_group);
    }

    for (var i = meteor_count - 1; i >= 0; i -= 1) {
        if (remove_meteors[i]) {
            ds_list_delete(_flight.meteors, i);
        }
    }

    if (_flight.distance_remaining <= 0 && _flight.shield_remaining > 0) {
        _flight.outcome = "victory";
    }
}
