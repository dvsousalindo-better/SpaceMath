function scr_ui_draw_button(_center_x, _center_y, _width, _height, _label, _selected) {
    var left = _center_x - _width * 0.5;
    var top = _center_y - _height * 0.5;

    if (_selected) {
        draw_set_color(make_color_rgb(19, 92, 130));
    } else {
        draw_set_color(make_color_rgb(20, 35, 60));
    }

    draw_rectangle(left, top, left + _width, top + _height, false);

    if (_selected) {
        draw_set_color(make_color_rgb(120, 213, 255));
    } else {
        draw_set_color(make_color_rgb(64, 86, 118));
    }

    draw_rectangle(left, top, left + _width, top + _height, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_ui);
    draw_set_color(c_white);
    draw_text(_center_x, _center_y, _label);
}
