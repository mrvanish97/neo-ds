return {
  background = {
    secondary = "background.primary",
    tertiary = "background.secondary",
    quaternary = "background.tertiary",
    cursorline = "background.secondary",
    selection = "background.secondary",

    editor = "background.primary",
    sidebar = "background.secondary",
    float = "background.secondary",

    popup = {
      _ = "background.secondary",
      selected = "background.selection",
      scrollbar = "background.tertiary",
      thumb = "background.quaternary",
    },

    search = {
      _ = "background.selection",
      active = "background.search",
    },

    reference = {
      _ = "background.secondary",
      subtle = "background.reference",
      write = "background.reference",
    },

    feedback = {
      info = "background.reference",
      success = "background.primary",
      warning = "background.primary",
      danger = "background.primary",
    },
  },

  foreground = {
    secondary = "foreground.primary",
    muted = "foreground.secondary",
    inverse = "background.primary",
    disabled = "foreground.muted",
    deprecated = "foreground.muted",
    link = "accent.primary",
  },

  border = {
    primary = "background.quaternary",
    secondary = "background.tertiary",
    subtle = "border.secondary",
    focus = "accent.primary",
  },

  accent = {
    secondary = "accent.primary",
    tertiary = "accent.secondary",
    quaternary = "accent.tertiary",
    literal = "accent.primary",
    note = "accent.secondary",
  },

  interaction = {
    active = "accent.secondary",
    focus = "accent.primary",
    hover = "background.cursorline",
    selected = "background.selection",
    match = "accent.literal",
  },

  feedback = {
    info = "accent.literal",
    hint = "accent.primary",
    success = "accent.primary",
    warning = "accent.note",
    danger = "accent.primary",
  },

  entity = {
    file = "foreground.primary",
    directory = {
      _ = "accent.primary",
      icon = "entity.directory",
    },
    link = "foreground.link",
  },

  syntax = {
    comment = "foreground.muted",
    keyword = {
      _ = "accent.secondary",
      primary = "syntax.keyword",
      secondary = "foreground.secondary",
      directive = "syntax.preprocessor",
    },
    annotation = "syntax.keyword",
    variable = "foreground.primary",
    property = "foreground.primary",
    constant = "accent.literal",
    string = "feedback.danger",
    number = "syntax.constant",
    boolean = "syntax.keyword",
    operator = "foreground.secondary",
    punctuation = "syntax.operator",
    bracket = "syntax.punctuation",
    preprocessor = "accent.note",
    builtin = "syntax.keyword",
    tag = "syntax.keyword",

    type = {
      _ = "foreground.primary",
      parameter = "accent.quaternary",
    },

    ["function"] = {
      _ = "accent.tertiary",
      call = "syntax.function",
      definition = "syntax.function",
    },

    markup = {
      heading = "foreground.primary",
      raw = "syntax.string",
    },
  },

  vcs = {
    added = "feedback.success",
    changed = "accent.primary",
    deleted = "feedback.danger",
    untracked = "foreground.muted",
  },

  chrome = {
    base = "background.tertiary",
    inactive = "background.secondary",
    mode = {
      normal = "accent.primary",
      insert = "accent.secondary",
      visual = "accent.literal",
      replace = "feedback.danger",
      command = "feedback.warning",
    },
  },
}
