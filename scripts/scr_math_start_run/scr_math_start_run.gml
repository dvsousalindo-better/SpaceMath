function scr_math_start_run(_difficulty) {
    var bank = [];

    if (_difficulty == "easy") {
        array_push(bank,
            {category: "RUMO", prompt: "12 + 8 = ?", options: ["18", "20", "22", "24"], answer_index: 1},
            {category: "RUMO", prompt: "35 - 17 = ?", options: ["16", "18", "20", "22"], answer_index: 1},
            {category: "RUMO", prompt: "6 x 4 = ?", options: ["20", "22", "24", "28"], answer_index: 2},
            {category: "RUMO", prompt: "48 / 6 = ?", options: ["6", "7", "8", "9"], answer_index: 2},
            {category: "RUMO", prompt: "15 + 9 = ?", options: ["20", "22", "24", "26"], answer_index: 2},
            {category: "ESCUDO", prompt: "7 x 5 = ?", options: ["30", "32", "35", "40"], answer_index: 2},
            {category: "ESCUDO", prompt: "42 / 7 = ?", options: ["5", "6", "7", "8"], answer_index: 1},
            {category: "ESCUDO", prompt: "28 + 16 = ?", options: ["42", "44", "46", "48"], answer_index: 1},
            {category: "ESCUDO", prompt: "50 - 23 = ?", options: ["25", "27", "29", "31"], answer_index: 1},
            {category: "ESCUDO", prompt: "9 x 3 = ?", options: ["24", "26", "27", "30"], answer_index: 2}
        );
    } else {
        array_push(bank,
            {category: "RUMO", prompt: "(18 + 6) x 3 = ?", options: ["66", "72", "78", "84"], answer_index: 1},
            {category: "RUMO", prompt: "144 / 12 + 9 = ?", options: ["19", "21", "23", "25"], answer_index: 1},
            {category: "RUMO", prompt: "(45 - 17) x 2 = ?", options: ["52", "54", "56", "58"], answer_index: 2},
            {category: "RUMO", prompt: "7 x 8 - 15 = ?", options: ["39", "40", "41", "42"], answer_index: 2},
            {category: "RUMO", prompt: "96 / 8 x 3 = ?", options: ["30", "33", "36", "39"], answer_index: 2},
            {category: "ESCUDO", prompt: "(32 + 16) / 4 = ?", options: ["10", "12", "14", "16"], answer_index: 1},
            {category: "ESCUDO", prompt: "9 x 7 - 18 = ?", options: ["42", "45", "48", "54"], answer_index: 1},
            {category: "ESCUDO", prompt: "120 / 5 + 14 = ?", options: ["34", "36", "38", "40"], answer_index: 2},
            {category: "ESCUDO", prompt: "6 x (15 - 8) = ?", options: ["36", "40", "42", "48"], answer_index: 2},
            {category: "ESCUDO", prompt: "84 / 7 + 19 = ?", options: ["28", "30", "31", "33"], answer_index: 2}
        );
    }

    var question_order = array_create(array_length(bank));
    for (var i = 0; i < array_length(question_order); i += 1) {
        question_order[i] = i;
    }

    for (var i = array_length(question_order) - 1; i > 0; i -= 1) {
        var swap_index = irandom(i);
        var current_index = question_order[i];
        question_order[i] = question_order[swap_index];
        question_order[swap_index] = current_index;
    }

    var selected_questions = [];
    for (var i = 0; i < 5; i += 1) {
        array_push(selected_questions, bank[question_order[i]]);
    }

    return {
        questions: selected_questions,
        question_index: 0,
        selected_answer: 0,
        answered: false,
        last_answer_correct: false,
        correct_count: 0,
        error_count: 0,
        route_error_count: 0,
        shield_error_count: 0
    };
}
