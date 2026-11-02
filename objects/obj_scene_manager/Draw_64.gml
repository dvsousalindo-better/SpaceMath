var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var center_x = gui_width * 0.5;

draw_set_alpha(1);
draw_set_color(make_color_rgb(7, 14, 33));
draw_rectangle(0, 0, gui_width, gui_height, false);

var background_time = background_animation_time;
var blink_alpha = 0.35 + 0.65 * abs(sin(background_time * 4));

for (var i = 0; i < 72; i += 1) {
    var star_x = (i * 197 + i * i * 31 + 83) % gui_width;
    var star_y = (i * 113 + i * i * 17 + 47 + background_time * (8 + i mod 10)) % gui_height;
    draw_set_alpha(0.25 + (i % 4) * 0.12 + abs(sin(background_time * 1.8 + i)) * 0.25);
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
    scr_ui_draw_button(center_x, gui_height * 0.53 + 88, 400, 58, "CRÉDITOS", selection == 1);

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
    draw_text(center_x, gui_height * 0.17, "COMO JOGAR");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_set_color(make_color_rgb(135, 231, 173));
    draw_text(center_x, gui_height * 0.29, "1. PREPARE A MISSÃO");
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.35, "Resolva os cálculos: eles influenciam a proteção da nave.");

    draw_set_color(make_color_rgb(135, 231, 173));
    draw_text(center_x, gui_height * 0.45, "2. CONTROLES");
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.51, "Nos cálculos: use as setas ou W/S e confirme com Enter.");
    draw_text(center_x, gui_height * 0.57, "Na viagem: use A/D ou as setas para desviar dos meteoros.");
    draw_text(center_x, gui_height * 0.63, "Toque duas vezes na direção desejada para teleportar.");

    draw_set_color(make_color_rgb(135, 231, 173));
    draw_text(center_x, gui_height * 0.72, "3. COMBUSTÍVEL");
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.78, "Cada teleporte gasta 10%; menos combustível reduz a velocidade.");

    draw_set_alpha(blink_alpha);
    draw_set_color(make_color_rgb(255, 220, 140));
    draw_text(center_x, gui_height * 0.91,
        "Clique/Enter: continuar | Esc: voltar | Inicia em "
        + string(max(0, ceil(10 - instructions_elapsed))) + " s");
    draw_set_alpha(1);
} else if (scene == "credits") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.25, "CRÉDITOS");

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.42, "Projeto educativo inspirado na trajetória de Katherine Johnson.");
    draw_text(center_x, gui_height * 0.48, "A missão e seus diálogos são fictícios, não falas históricas.");
    draw_set_alpha(blink_alpha);
    draw_set_color(make_color_rgb(255, 220, 140));
    draw_text(center_x, gui_height * 0.66, "Clique ou pressione Enter/Esc para voltar ao menu.");
    draw_set_alpha(1);
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
    draw_text(center_x, gui_height * 0.71, "Enter inicia a viagem; Esc retorna ao menu.");
    scr_ui_draw_button(center_x, gui_height * 0.80, 310, 48, "INICIAR VIAGEM", true);
} else if (scene == "countdown") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.30, "PREPARANDO A VIAGEM");

    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.50, string(max(1, ceil(countdown_seconds))));

    draw_set_font(fnt_ui);
    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(center_x, gui_height * 0.67, "Esc retorna ao menu.");
} else if (scene == "flight") {
    scr_flight_draw(flight);
} else if (scene == "flight_result") {
    draw_set_font(fnt_ui_title);
    if (flight.outcome == "victory") {
        draw_set_color(make_color_rgb(135, 231, 173));
        draw_text(center_x, gui_height * 0.25, "CHEGADA À LUA");
    } else {
        draw_set_color(make_color_rgb(255, 164, 151));
        draw_text(center_x, gui_height * 0.25, "VIAGEM INTERROMPIDA");
    }

    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(center_x, gui_height * 0.40, "Distância percorrida: " + string(floor(384400 - flight.distance_remaining)) + " km");
    draw_text(center_x, gui_height * 0.48, "Proteção restante: " + string(flight.shield_remaining));
    draw_text(center_x, gui_height * 0.56, "Colisões: " + string(flight.collision_count));
    draw_text(center_x, gui_height * 0.64, "Acertos matemáticos: " + string(math_run.correct_count) + " de 5");

    var button_count = flight.outcome == "victory" ? 3 : 2;
    var button_x = [];
    var button_labels = [];
    var button_width = button_count == 3 ? 310 : 340;

    if (button_count == 3) {
        button_x = [gui_width * 0.20, gui_width * 0.50, gui_width * 0.80];
        button_labels = ["JOGAR NOVAMENTE", "INFORMAÇÕES HISTÓRICAS", "MENU PRINCIPAL"];
    } else {
        button_x = [gui_width * 0.35, gui_width * 0.65];
        button_labels = ["JOGAR NOVAMENTE", "MENU PRINCIPAL"];
    }

    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(center_x, gui_height * 0.74, "Use as setas e Enter, ou clique em uma opção.");
    for (var i = 0; i < button_count; i += 1) {
        scr_ui_draw_button(button_x[i], gui_height * 0.84, button_width, 48,
            button_labels[i], selection == i);
    }
} else if (scene == "history") {
    draw_set_font(fnt_ui_title);
    draw_set_color(make_color_rgb(120, 213, 255));
    draw_text(center_x, gui_height * 0.12, "KATHERINE JOHNSON E A EXPLORAÇÃO ESPACIAL");

    draw_set_font(fnt_ui);
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(76, gui_height * 0.25, "Katherine Johnson (1918-2020) foi uma matemática que trabalhou na NASA.");
    draw_text(76, gui_height * 0.36, "Seus cálculos de trajetórias contribuíram para voos espaciais tripulados.");
    draw_text(76, gui_height * 0.47, "Em 1961, Alan Shepard realizou o Freedom 7, primeiro voo espacial tripulado dos EUA.");
    draw_text(76, gui_height * 0.58, "Em 1962, John Glenn pediu que Johnson conferisse os cálculos orbitais do computador.");
    draw_text(76, gui_height * 0.69, "Apollo 11: Armstrong e Aldrin pousaram em 20 de julho de 1969; Collins ficou em órbita.");

    draw_set_color(make_color_rgb(238, 202, 119));
    draw_text(76, gui_height * 0.79, "Personagem, diálogos e viagem são ficcionais; não reconstituem fatos nem falas reais.");

    draw_set_color(make_color_rgb(200, 213, 230));
    draw_text(76, gui_height * 0.80, "Fontes: NASA Langley | Katherine Johnson; NASA | Mercury-Redstone 3; NASA | Apollo 11.");
    scr_ui_draw_button(center_x, gui_height * 0.88, 350, 44,
        "VOLTAR AOS RESULTADOS", true);
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
