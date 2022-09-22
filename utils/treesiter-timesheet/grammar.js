module.exports = grammar({
  name: 'timesheet',

  word: $ => $._identifier,

  rules: {
    // TODO: add the actual grammar rules
    source_file: $ => repeat(choice($.time_entry, $.task_entry, $._newline)),

    timestamp: $ => seq($._number, $._number, ':', $._number, $._number),

    time_entry: $ => seq(
      field('timestamp', $.timestamp),
      optional(field('title', $.words)),
      optional($.story),
      $._newline
    ),

    task_entry: $ => seq(choice('*', '-'), field('entry', $.words), $._newline),

    story: $ => seq(
      '#STORY',
      field('details', $.words)
    ),

    words: $ => repeat1($._identifier),

    _identifier: $ => /\S+/,

    _number: $ => /[0-9]/,

    _newline: $ => '\n',

    _whitespace: $ => /\s+/
  }
});
