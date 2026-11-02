var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var center_x = gui_width * 0.5;

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
draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (scene == "menu") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.25, "RUMO À LUA");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.34, "Uma missão educativa de matemática e exploração espacial");

    scr_ui_draw_button(center_x, gui_height * 0.53, 400, 58, "INICIAR MISSÃO", selection == 0);
    scr_ui_draw_button(center_x, gui_height * 0.53 + 88, 400, 58, "INSTRUÇÕES", selection == 1);
    scr_ui_draw_button(center_x, gui_height * 0.53 + 176, 400, 58, "CRÉDITOS", selection == 2);

    draw_set_color(make_color_rgb(160, 177, 201));
    draw_text(center_x, gui_height - 34, "Use as setas ou W/S e pressione Enter; também é possível clicar nos botões.");
} else if (scene == "difficulty") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.25, "SELECIONE A DIFICULDADE");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.35, "A dificuldade altera somente os cálculos.");

    scr_ui_draw_button(center_x, gui_height * 0.53, 400, 58, "FÁCIL", selection == 0);
    scr_ui_draw_button(center_x, gui_height * 0.53 + 88, 400, 58, "MÉDIO", selection == 1);
    scr_ui_draw_button(center_x, gui_height * 0.53 + 176, 400, 58, "VOLTAR", selection == 2);

    draw_set_color(make_color_rgb(160, 177, 201));
    draw_text(center_x, gui_height - 34, "Esc também retorna ao menu.");
} else if (scene == "instructions") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.25, "INSTRUÇÕES");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.42, "Resolva cálculos para ajudar a equipe a preparar a missão.");
    draw_text(center_x, gui_height * 0.48, "Use as setas ou W/S para navegar; Enter confirma.");
    draw_text(center_x, gui_height * 0.54, "Na viagem, A/D ou as setas movimentarão a nave.");
    draw_text(center_x, gui_height * 0.66, "Pressione Enter ou Esc para voltar ao menu.");
} else if (scene == "credits") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.25, "CRÉDITOS");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.42, "Projeto educativo inspirado na trajetória de Katherine Johnson.");
    draw_text(center_x, gui_height * 0.48, "A missão e seus diálogos são fictícios, não falas históricas.");
    draw_text(center_x, gui_height * 0.66, "Pressione Enter ou Esc para voltar ao menu.");
} else if (scene == "lab") {
    scr_lab_draw();
} else if (scene == "math") {
    scr_math_draw();
} else if (scene == "math_results") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.19, "CONFERÊNCIA PRÉ-VOO");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.30, "Cálculos corretos: " + string(math_run.correct_count) + " de 5");
    draw_set_color(make_color_rgb(255, 164, 151));
    draw_text(center_x, gui_height * 0.37, "Erros totais: " + string(math_run.error_count));
    draw_set_color(make_color_rgb(135, 231, 173));
    draw_text(center_x, gui_height * 0.44, "Proteção restante: " + string(math_run.shield_remaining) + " de 5");
    draw_set_color(make_color_rgb(255, 164, 151));
    draw_text(center_x, gui_height * 0.51, "Erros de Escudo: " + string(math_run.shield_error_count));

    if (math_run.route_deviation == "none") {
        draw_set_color(make_color_rgb(135, 231, 173));
        draw_text(center_x, gui_height * 0.58, "Trajetória: nominal");
    } else if (math_run.route_deviation == "light") {
        draw_set_color(make_color_rgb(238, 202, 119));
        draw_text(center_x, gui_height * 0.58, "Trajetória: desvio leve");
    } else {
        draw_set_color(make_color_rgb(255, 164, 151));
        draw_text(center_x, gui_height * 0.58, "Trajetória: desvio forte");
    }

    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(center_x, gui_height * 0.65, "Erros de Rumo: " + string(math_run.route_error_count));
    draw_text(center_x, gui_height * 0.71, "Na próxima etapa, estas condições serão usadas na viagem espacial.");
    scr_ui_draw_button(center_x, gui_height * 0.80, 310, 48, "VOLTAR AO MENU", true);
}

if (transition_phase > 0) {
    draw_set_alpha(transition_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
