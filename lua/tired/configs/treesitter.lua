pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

local parser_list = {
  "lua",
  "luadoc",
  "printf",
  "vim",
  "vimdoc",
  "c",
  "cpp",
  "java",
  "rust",
  "go",
  "haskell",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "json",
  "jsonc",
  "yaml",
  "dockerfile",
  "gotmpl",
  "htmldjango",
  "jinja",
  "jinja_inline",
  "templ",
  "twig",
  "markdown",
  "markdown_inline",
  "xml",
  "sql",
  "zig",
}

local function parsers()
  return parser_list
end

local function setup()
  require("nvim-treesitter").setup {
    install_dir = vim.fs.joinpath(vim.fn.stdpath "data", "site"),
  }

  if not vim.g.tired_no_autoinstall then
    require("nvim-treesitter").install(parser_list)
  end
end

setup()

return {
  parsers = parsers,
  setup = setup,
}
