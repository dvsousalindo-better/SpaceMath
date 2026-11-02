if (transition_phase == 1) {
    transition_alpha = min(1, transition_alpha + 0.12);

    if (transition_alpha >= 1) {
        scene = transition_target;
        if (scene == "lab") {
            lab_dialogue_index = 0;
        }
        transition_phase = 2;
        selection = 0;
    }
} else if (transition_phase == 2) {
    transition_alpha = max(0, transition_alpha - 0.12);

    if (transition_alpha <= 0) {
        transition_phase = 0;
    }
}

if (transition_phase != 0) {
    exit;
}

if (scene == "lab") {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var continue_x = gui_width - 155;
    var continue_y = gui_height - 87;
    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);
    var clicked_continue = mouse_check_button_pressed(mb_left)
        && abs(mouse_x_gui - continue_x) <= 119
        && abs(mouse_y_gui - continue_y) <= 24;
    var advance = keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_space)
        || clicked_continue;

    if (keyboard_check_pressed(vk_escape)) {
        transition_target = "menu";
        transition_phase = 1;
    } else if (advance) {
        if (lab_dialogue_index < 2) {
            lab_dialogue_index += 1;
        } else {
            math_run = scr_math_start_run(selected_difficulty);
            transition_target = "math";
            transition_phase = 1;
        }
    }

    exit;
}

if (scene == "math") {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var question = math_run.questions[math_run.question_index];
    var option_x = [gui_width * 0.5 - 215, gui_width * 0.5 + 215, gui_width * 0.5 - 215, gui_width * 0.5 + 215];
    var option_y = [gui_height * 0.12 + 283, gui_height * 0.12 + 283, gui_height * 0.12 + 346, gui_height * 0.12 + 346];
    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);
    var clicked_option = -1;

    if (!math_run.answered) {
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
            if (math_run.selected_answer % 2 == 1) {
                math_run.selected_answer -= 1;
            }
        } else if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
            if (math_run.selected_answer % 2 == 0) {
                math_run.selected_answer += 1;
            }
        } else if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            math_run.selected_answer = (math_run.selected_answer + 2) % 4;
        } else if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            math_run.selected_answer = (math_run.selected_answer + 2) % 4;
        }
    }

    if (mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < 4; i += 1) {
            if (abs(mouse_x_gui - option_x[i]) <= 170
                && abs(mouse_y_gui - option_y[i]) <= 24) {
                clicked_option = i;
            }
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        transition_target = "menu";
        transition_phase = 1;
    } else if (!math_run.answered) {
        if (clicked_option >= 0) {
            math_run.selected_answer = clicked_option;
        }

        if (keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(vk_space)
            || clicked_option >= 0) {
            math_run.last_answer_correct = math_run.selected_answer == question.answer_index;
            if (math_run.last_answer_correct) {
                math_run.correct_count += 1;
            } else {
                math_run.error_count += 1;
                if (question.category == "RUMO") {
                    math_run.route_error_count += 1;
                } else {
                    math_run.shield_error_count += 1;
                }
            }
            math_run.answered = true;
        }
    } else {
        var continue_x = gui_width - 185;
        var continue_y = gui_height - 82;
        var clicked_continue = mouse_check_button_pressed(mb_left)
            && abs(mouse_x_gui - continue_x) <= 140
            && abs(mouse_y_gui - continue_y) <= 23;
        var advance = keyboard_check_pressed(vk_enter)
            || keyboard_check_pressed(vk_space)
            || clicked_continue;

        if (advance) {
            if (math_run.question_index < array_length(math_run.questions) - 1) {
                math_run.question_index += 1;
                math_run.selected_answer = 0;
                math_run.answered = false;
            } else {
                math_run = scr_math_prepare_flight(math_run);
                transition_target = "math_results";
                transition_phase = 1;
            }
        }
    }

    exit;
}

if (scene == "math_results") {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);
    var clicked_menu = mouse_check_button_pressed(mb_left)
        && abs(mouse_x_gui - gui_width * 0.5) <= 155
        && abs(mouse_y_gui - gui_height * 0.79) <= 24;

    if (keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_space)
        || keyboard_check_pressed(vk_escape)
        || clicked_menu) {
        transition_target = "menu";
        transition_phase = 1;
    }
    exit;
}

var option_count = 0;
if (scene == "menu" || scene == "difficulty") {
    option_count = 3;
}

if (option_count > 0) {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        selection = (selection + option_count - 1) % option_count;
    }

    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        selection = (selection + 1) % option_count;
    }

    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var button_x = gui_width * 0.5;
    var button_start_y = gui_height * 0.53;
    var button_gap = 88;
    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);
    var mouse_option = floor((mouse_y_gui - button_start_y + button_gap * 0.5) / button_gap);
    var mouse_over_option = mouse_option >= 0
        && mouse_option < option_count
        && abs(mouse_x_gui - button_x) <= 210
        && abs(mouse_y_gui - (button_start_y + mouse_option * button_gap)) <= 34;

    if (mouse_over_option) {
        selection = mouse_option;
    }

    var confirm = keyboard_check_pressed(vk_enter)
        || keyboard_check_pressed(vk_space)
        || (mouse_over_option && mouse_check_button_pressed(mb_left));

    if (scene == "difficulty" && keyboard_check_pressed(vk_escape)) {
        transition_target = "menu";
        transition_phase = 1;
    } else if (confirm) {
        if (scene == "menu") {
            if (selection == 0) {
                transition_target = "difficulty";
                transition_phase = 1;
            } else if (selection == 1) {
                transition_target = "instructions";
                transition_phase = 1;
            } else {
                transition_target = "credits";
                transition_phase = 1;
            }
        } else if (scene == "difficulty") {
            if (selection == 0) {
                selected_difficulty = "easy";
                global.game_difficulty = selected_difficulty;
                transition_target = "lab";
                transition_phase = 1;
            } else if (selection == 1) {
                selected_difficulty = "medium";
                global.game_difficulty = selected_difficulty;
                transition_target = "lab";
                transition_phase = 1;
            } else {
                transition_target = "menu";
                transition_phase = 1;
            }
        }
    }
} else if (keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
    || keyboard_check_pressed(vk_escape)) {
    transition_target = "menu";
    transition_phase = 1;
}
