local M = {}

M.roles = {
  keyword_primary = "syntax.keyword",
  keyword_secondary = "syntax.keyword.secondary",
  keyword_directive = "syntax.keyword.directive",
}

M.treesitter = {
  primary = {
    "@keyword",
    "@keyword.conditional",
    "@keyword.exception",
    "@keyword.function",
    "@keyword.repeat",
    "@keyword.return",
    "@keyword.type",
  },

  secondary = {
    "@keyword.coroutine",
    "@keyword.debug",
    "@keyword.import",
    "@keyword.modifier",
    "@keyword.operator",
    "@keyword.storage",
    "@type.qualifier",
  },

  directive = {
    "@keyword.directive",
    "@keyword.directive.define",
  },
}

M.treesitter_by_lang = {
  bash = {
    ["@keyword"] = "keyword_secondary",
    ["@operator"] = "keyword_secondary",
    ["@punctuation.delimiter"] = "keyword_secondary",
  },

  go = {
    ["@keyword.coroutine"] = "keyword_primary",
    ["@keyword.import"] = "keyword_primary",
  },

  java = {
    ["@keyword"] = "keyword_secondary",
  },

  lua = {
    ["@keyword"] = "keyword_secondary",
  },

  typescript = {
    ["@keyword"] = "keyword_secondary",
  },

  tsx = {
    ["@keyword"] = "keyword_secondary",
  },
}

M.syntax_by_group = {
  Include = "keyword_secondary",
  StorageClass = "keyword_secondary",
  pythonInclude = "keyword_secondary",
  pythonOperator = "keyword_secondary",
  javaOperator = "keyword_secondary",
  javaScriptOperator = "keyword_secondary",
  luaOperator = "keyword_secondary",
}

function M.role(bucket)
  return M.roles[bucket] or bucket
end

function M.apply_treesitter(groups)
  for bucket, captures in pairs(M.treesitter) do
    local role = M.role("keyword_" .. bucket)
    for _, capture in ipairs(captures) do
      groups[capture] = role
    end
  end

  for lang, captures in pairs(M.treesitter_by_lang) do
    for capture, bucket in pairs(captures) do
      groups[capture .. "." .. lang] = M.role(bucket)
    end
  end
end

function M.apply_syntax(groups)
  for group, bucket in pairs(M.syntax_by_group) do
    groups[group] = M.role(bucket)
  end
end

return M
