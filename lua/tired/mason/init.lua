local M = {}
local names = require "tired.mason.names"
local pkgs = require("tiredconfig").mason.pkgs
local skipped = require("tiredconfig").mason.skip

M.get_pkgs = function()
  local tools = {}

  local add = function(name)
    local pkg = names[name]
    if pkg and not vim.tbl_contains(pkgs, pkg) and not vim.tbl_contains(skipped, pkg) then
      table.insert(pkgs, pkg)
    end
  end

  -- only the servers actually enabled by this config
  local binaries = require("tired.configs.lspconfig").binaries or {}
  for server in pairs(binaries) do
    add(server)
  end

  -- only formatters/linters actually configured by this config
  local conform = require "tired.configs.conform"
  for _, fmts in pairs(conform.formatters_by_ft or {}) do
    for _, fmt in ipairs(fmts) do
      table.insert(tools, fmt)
    end
  end

  local lint = require "tired.configs.lint"
  for _, linters in pairs(lint.linters_by_ft or {}) do
    for _, linter in ipairs(linters) do
      table.insert(tools, linter)
    end
  end

  for _, tool in ipairs(tools) do
    add(tool)
  end

  return pkgs
end

local function parse_package(package_name)
  local name, version = package_name:match "^([^@]+)@?(.*)$"
  return {
    name = name,
    version = version ~= "" and version or nil,
  }
end

M.install_all = function()
  local mr = require "mason-registry"

  mr.refresh(function()
    for _, tool in ipairs(M.get_pkgs()) do
      local pkg = parse_package(tool)
      local p = mr.get_package(pkg.name)

      if not p:is_installed() then
        p:install { version = pkg.version }
      end
    end
  end)
end

return M
