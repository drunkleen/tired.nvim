local autocmd = vim.api.nvim_create_autocmd
local config = require "tiredconfig"

-- load tireddash only on empty file
if config.tireddash.load_on_startup then
  local opening_file = vim.api.nvim_buf_get_name(0)
  local is_dir = vim.fn.isdirectory(opening_file) == 1
  local bufmodifed = vim.api.nvim_get_option_value("modified", { buf = 0 })

  if not bufmodifed and (is_dir or opening_file == "") then
    local current_buffer = vim.api.nvim_get_current_buf()
    require("tired.tireddash").open()
    vim.api.nvim_buf_delete(current_buffer, { force = true, unload = false })
  end
end

if config.lsp.signature then
  autocmd("LspAttach", {
    callback = function(args)
      vim.schedule(function()
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client then
          local signatureProvider = client.server_capabilities.signatureHelpProvider
          if signatureProvider and signatureProvider.triggerCharacters then
            require("tired.lsp.signature").setup(client, args.buf)
          end
        end
      end)
    end,
  })
end

-- reload the plugin!
autocmd("BufWritePost", {
  pattern = vim.tbl_map(function(path)
    return vim.fs.normalize(vim.uv.fs_realpath(path))
  end, vim.fn.glob(vim.fn.stdpath "config" .. "/lua/**/*.lua", true, true, true)),
  group = vim.api.nvim_create_augroup("ReloadTired", {}),

  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")

    require("tired.utils").reload(module)
    -- vim.cmd("redraw!")
  end,
})

vim.api.nvim_create_user_command("MasonInstallAll", function()
  require("tired.mason").install_all()
end, {})

-- install any enabled LSP (and configured formatters/linters) that are missing.
-- only runs when the set of missing binaries changed, so servers that cannot
-- be built here (e.g. gopls/sqls without a Go toolchain) don't retry forever.
if not vim.g.tired_no_autoinstall then
  vim.defer_fn(function()
    local binaries = require("tired.configs.lspconfig").binaries
    local missing = {}

    for _, bin in pairs(binaries) do
      if vim.fn.executable(bin) == 0 then
        table.insert(missing, bin)
      end
    end

    if #missing == 0 then
      return
    end

    table.sort(missing)
    local key = table.concat(missing, ",")
    local marker = vim.fn.stdpath "state" .. "/tired_mason_attempted"
    local previous = vim.fn.filereadable(marker) == 1 and table.concat(vim.fn.readfile(marker), ",") or nil

    if previous == key then
      return
    end

    vim.fn.writefile({ key }, marker)
    pcall(require("tired.mason").install_all)
  end, 2000)
end

if config.colorify.enabled then
  require("tired.colorify").run()
end

local dir = vim.fn.stdpath "data" .. "/nvnotify1"

if not vim.uv.fs_stat(dir) then
  vim.fn.mkdir(dir, "p")
  require "tired.winmes" {
    { "* Blink.cmp plugin integration has been added, will be tested for 2 months" },
    { " " },
    { '* { import = "tired.blink.lazyspec" } in your plugins file' },
    { " " },
    { "* Discuss at https://github.com/drunkleen/tired.nvim" },
  }
end
