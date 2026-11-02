function scr_lab_draw() {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var board_left = gui_width * 0.055;
    var board_top = gui_height * 0.12;
    var board_width = gui_width * 0.59;
    var board_height = gui_height * 0.54;
    var scientist_x = gui_width * 0.81;
    var scientist_y = gui_height * 0.36;

    draw_set_alpha(1);
    draw_set_color(make_color_rgb(203, 195, 175));
    draw_rectangle(0, 0, gui_width, gui_height, false);

    draw_set_color(make_color_rgb(151, 139, 119));
    draw_rectangle(0, gui_height * 0.71, gui_width, gui_height, false);

    draw_set_color(make_color_rgb(179, 150, 112));
    draw_rectangle(board_left - 12, board_top - 12, board_left + board_width + 12, board_top + board_height + 12, false);
    draw_set_color(make_color_rgb(35, 70, 57));
    draw_rectangle(board_left, board_top, board_left + board_width, board_top + board_height, false);

    draw_set_font(fnt_ui_title);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(230, 238, 219));
    draw_text(board_left + 28, board_top + 42, "BRIEFING DA MISSÃO");

    draw_set_color(make_color_rgb(190, 211, 183));
    draw_rectangle(board_left + 28, board_top + 73, board_left + board_width - 28, board_top + 75, false);

    draw_set_font(fnt_ui);
    draw_set_color(make_color_rgb(221, 232, 210));
    draw_text(board_left + 38, board_top + 118, "DOIS CÁLCULOS, UMA MISSÃO");

    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(board_left + 55, board_top + 184, "RUMO");
    draw_set_color(make_color_rgb(238, 202, 119));
    draw_text(board_left + board_width * 0.53, board_top + 184, "ESCUDO");

    draw_set_color(make_color_rgb(235, 239, 226));
    draw_text(board_left + 55, board_top + 219, "Direção e trajetória da nave");
    draw_text(board_left + board_width * 0.53, board_top + 219, "Proteção da nave");

    draw_set_color(make_color_rgb(120, 213, 255));
    draw_line(board_left + 70, board_top + 310, board_left + board_width * 0.40, board_top + 272);
    draw_line(board_left + board_width * 0.40, board_top + 272, board_left + board_width * 0.72, board_top + 318);
    draw_set_color(make_color_rgb(238, 202, 119));
    draw_circle(board_left + board_width * 0.80, board_top + 318, 24, true);
    draw_set_color(make_color_rgb(235, 239, 226));
    draw_circle(board_left + 70, board_top + 310, 9, false);
    draw_set_color(make_color_rgb(221, 232, 210));
    draw_text(board_left + 48, board_top + 352, "TERRA");
    draw_text(board_left + board_width * 0.75, board_top + 352, "LUA");

    draw_set_color(make_color_rgb(93, 69, 49));
    draw_rectangle(board_left - 8, board_top + board_height + 20, board_left + board_width + 8, board_top + board_height + 39, false);
    draw_rectangle(gui_width * 0.69, gui_height * 0.69, gui_width * 0.97, gui_height * 0.73, false);

    draw_set_color(make_color_rgb(77, 47, 34));
    draw_circle(scientist_x, scientist_y, 54, false);
    draw_set_color(make_color_rgb(201, 145, 105));
    draw_circle(scientist_x, scientist_y + 7, 42, false);
    draw_set_color(make_color_rgb(77, 47, 34));
    draw_circle(scientist_x - 19, scientist_y - 25, 28, false);
    draw_circle(scientist_x + 14, scientist_y - 32, 27, false);

    draw_set_color(make_color_rgb(201, 145, 105));
    draw_rectangle(scientist_x - 13, scientist_y + 35, scientist_x + 13, scientist_y + 70, false);
    draw_set_color(make_color_rgb(240, 240, 231));
    draw_rectangle(scientist_x - 74, scientist_y + 61, scientist_x + 74, gui_height * 0.76, false);
    draw_set_color(make_color_rgb(203, 220, 218));
    draw_line(scientist_x - 18, scientist_y + 68, scientist_x, scientist_y + 91);
    draw_line(scientist_x + 18, scientist_y + 68, scientist_x, scientist_y + 91);
    draw_set_color(make_color_rgb(77, 47, 34));
    draw_circle(scientist_x - 15, scientist_y + 5, 3, false);
    draw_circle(scientist_x + 15, scientist_y + 5, 3, false);
    draw_set_color(make_color_rgb(95, 55, 50));
    draw_line(scientist_x - 8, scientist_y + 24, scientist_x + 8, scientist_y + 24);
    draw_set_color(make_color_rgb(95, 55, 50));
    draw_circle(scientist_x - 15, scientist_y + 5, 9, true);
    draw_circle(scientist_x + 15, scientist_y + 5, 9, true);

    draw_set_color(make_color_rgb(50, 105, 121));
    draw_rectangle(scientist_x - 30, scientist_y + 116, scientist_x - 5, scientist_y + 143, true);
    draw_rectangle(scientist_x + 5, scientist_y + 116, scientist_x + 30, scientist_y + 143, true);

    draw_set_color(make_color_rgb(14, 24, 40));
    draw_rectangle(34, gui_height * 0.755, gui_width - 34, gui_height - 22, false);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_rectangle(34, gui_height * 0.755, gui_width - 34, gui_height * 0.755 + 3, false);

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(66, gui_height * 0.755 + 29, "PESQUISADORA");

    draw_set_color(c_white);
    if (lab_dialogue_index == 0) {
        draw_text(66, gui_height * 0.755 + 69, "Olá, estamos fazendo alguns cálculos para a nave e gostaríamos que você nos ajudasse.");
    } else if (lab_dialogue_index == 1) {
        draw_text(66, gui_height * 0.755 + 69, "Rumo ajuda a orientar a trajetória. Escudo acompanha a proteção da nave.");
    } else {
        draw_text(66, gui_height * 0.755 + 69, "A preparação terminou. Na próxima etapa, você resolverá os cálculos da missão.");
    }

    var continue_label = "CONTINUAR";
    if (lab_dialogue_index >= 2) {
        continue_label = "FINALIZAR";
    }
    scr_ui_draw_button(gui_width - 155, gui_height - 87, 238, 48, continue_label, true);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
