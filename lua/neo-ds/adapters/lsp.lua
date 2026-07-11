return function()
  local groups = {
    ["@lsp.type.namespace"] = "syntax.variable",
    ["@lsp.type.type"] = "syntax.type",
    ["@lsp.type.class"] = "syntax.type",
    ["@lsp.type.enum"] = "syntax.type",
    ["@lsp.type.interface"] = "syntax.type",
    ["@lsp.type.struct"] = "syntax.type",
    ["@lsp.type.record"] = "syntax.type",
    ["@lsp.type.typeParameter"] = "syntax.type.parameter",
    ["@lsp.type.parameter"] = "syntax.variable",
    ["@lsp.type.variable"] = "syntax.variable",
    ["@lsp.type.property"] = "syntax.property",
    ["@lsp.type.enumMember"] = "syntax.constant",
    ["@lsp.type.function"] = "syntax.function.call",
    ["@lsp.type.method"] = "syntax.function.call",
    ["@lsp.type.macro"] = "syntax.preprocessor",
    ["@lsp.type.decorator"] = "syntax.annotation",
    ["@lsp.type.annotation"] = "syntax.annotation",
    ["@lsp.type.keyword"] = {},
    ["@lsp.type.comment"] = "syntax.comment",
    ["@lsp.type.string"] = "syntax.string",
    ["@lsp.type.number"] = "syntax.number",
    ["@lsp.type.operator"] = "syntax.operator",
    ["@lsp.mod.static"] = { style = "italic" },
    ["@lsp.mod.deprecated"] = { style = "strikethrough" },
    ["@lsp.typemod.variable.readonly.go"] = "syntax.constant",
    ["@lsp.typemod.property.readonly.python"] = "syntax.constant",
    ["@lsp.typemod.property.static.java"] = { link = "Constant" },
  }

  for _, kind in ipairs({ "function", "method" }) do
    groups["@lsp.typemod." .. kind .. ".definition"] = "syntax.function.definition"
    groups["@lsp.typemod." .. kind .. ".declaration"] = "syntax.function.definition"
  end

  for _, kind in ipairs({ "class", "interface", "enum", "struct", "record" }) do
    groups["@lsp.typemod." .. kind .. ".definition"] = "syntax.type.definition"
    groups["@lsp.typemod." .. kind .. ".declaration"] = "syntax.type.definition"
  end

  for _, lang in ipairs({ "python", "java", "bash", "javascript", "typescript", "rust", "lua", "go" }) do
    groups["@lsp.type.keyword." .. lang] = {}
  end

  groups["@lsp.type.property.python"] = "syntax.property"
  groups["@lsp.type.method.python"] = "syntax.function.call"
  groups["@lsp.mod.classMember.python"] = {}
  groups["@lsp.mod.parameter.python"] = {}
  groups["@lsp.mod.static.python"] = {}
  groups["@lsp.typemod.class.parameter.python"] = "syntax.variable"
  groups["@lsp.typemod.property.classMember.python"] = "syntax.property"
  groups["@lsp.typemod.property.static.python"] = "syntax.property"
  groups["@lsp.typemod.method.builtin.python"] = "syntax.function.call"
  groups["@lsp.typemod.method.classMember.python"] = "syntax.function.call"
  groups["@lsp.typemod.method.defaultLibrary.python"] = "syntax.function.call"

  return groups
end
