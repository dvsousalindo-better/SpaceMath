function scr_math_prepare_flight(_math_run) {
    _math_run.shield_remaining = max(0, 5 - _math_run.shield_error_count);

    if (_math_run.route_error_count == 0) {
        _math_run.route_deviation = "none";
    } else if (_math_run.route_error_count == 1) {
        _math_run.route_deviation = "light";
    } else {
        _math_run.route_deviation = "strong";
    }

    return _math_run;
}
