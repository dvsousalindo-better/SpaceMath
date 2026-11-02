function scr_math_draw() {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var center_x = gui_width * 0.5;
    var question = math_run.questions[math_run.question_index];
    var question_count = array_length(math_run.questions);
    var board_left = gui_width * 0.09;
    var board_top = gui_height * 0.12;
    var board_width = gui_width * 0.82;
    var board_bottom = gui_height * 0.66;

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(7, 14, 33));
    draw_rectangle(0, 0, gui_width, gui_height, false);

    for (var i = 0; i < 72; i += 1) {
        var star_x = (i * 197 + i * i * 31 + 83) % gui_width;
        var star_y = (i * 113 + i * i * 17 + 47) % gui_height;
        draw_set_alpha(0.35 + (i % 4) * 0.15);
        draw_set_color(c_white);
        draw_circle(star_x, star_y, 1 + (i % 3 == 0), false);
    }

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(179, 150, 112));
    draw_rectangle(board_left - 12, board_top - 12, board_left + board_width + 12, board_bottom + 12, false);
    draw_set_color(make_color_rgb(35, 70, 57));
    draw_rectangle(board_left, board_top, board_left + board_width, board_bottom, false);

    draw_set_font(fnt_ui_title);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 238, 219));
    draw_text(center_x, board_top + 45, "CÁLCULO " + string(math_run.question_index + 1) + " DE " + string(question_count));

    draw_set_font(fnt_ui);
    draw_set_color(make_color_rgb(190, 211, 183));
    draw_text(center_x, board_top + 93, "RESOLVA E ESCOLHA UMA RESPOSTA");

    if (question.category == "RUMO") {
        draw_set_color(make_color_rgb(120, 213, 255));
    } else {
        draw_set_color(make_color_rgb(238, 202, 119));
    }
    draw_text(center_x, board_top + 145, question.category);

    draw_set_color(c_white);
    draw_text(center_x, board_top + 203, question.prompt);

    var option_x = [center_x - 215, center_x + 215, center_x - 215, center_x + 215];
    var option_y = [board_top + 283, board_top + 283, board_top + 346, board_top + 346];

    for (var i = 0; i < 4; i += 1) {
        var option_left = option_x[i] - 170;
        var option_top = option_y[i] - 24;
        if (math_run.answered && i == question.answer_index) {
            draw_set_color(make_color_rgb(31, 105, 75));
        } else if (math_run.answered && i == math_run.selected_answer) {
            draw_set_color(make_color_rgb(126, 48, 48));
        } else if (!math_run.answered && i == math_run.selected_answer) {
            draw_set_color(make_color_rgb(19, 92, 130));
        } else {
            draw_set_color(make_color_rgb(20, 35, 60));
        }
        draw_rectangle(option_left, option_top, option_left + 340, option_top + 48, false);

        if (math_run.answered && i == question.answer_index) {
            draw_set_color(make_color_rgb(135, 231, 173));
        } else {
            draw_set_color(make_color_rgb(120, 213, 255));
        }
        draw_rectangle(option_left, option_top, option_left + 340, option_top + 48, true);

        draw_set_color(c_white);
        draw_text(option_x[i], option_y[i], question.options[i]);
    }

    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(center_x, gui_height * 0.71, "Setas ou W/S para escolher; Enter confirma. Também é possível clicar.");

    draw_set_color(make_color_rgb(14, 24, 40));
    draw_rectangle(34, gui_height * 0.755, gui_width - 34, gui_height - 22, false);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_rectangle(34, gui_height * 0.755, gui_width - 34, gui_height * 0.755 + 3, false);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    if (math_run.answered) {
        if (math_run.last_answer_correct) {
            draw_set_color(make_color_rgb(135, 231, 173));
            draw_text(66, gui_height * 0.755 + 34, "CORRETO! A resposta é " + question.options[question.answer_index] + ".");
        } else {
            draw_set_color(make_color_rgb(255, 164, 151));
            draw_text(66, gui_height * 0.755 + 34, "AINDA NÃO. A resposta correta é " + question.options[question.answer_index] + ".");
        }

        var next_label = "PRÓXIMO CÁLCULO";
        if (math_run.question_index == question_count - 1) {
            next_label = "VER RESULTADO";
        }
        scr_ui_draw_button(gui_width - 185, gui_height - 82, 280, 46, next_label, true);
    } else {
        draw_set_color(make_color_rgb(200, 213, 230));
        draw_text(66, gui_height * 0.755 + 34, "Respostas certas: " + string(math_run.correct_count) + "     Erros: " + string(math_run.error_count));
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
