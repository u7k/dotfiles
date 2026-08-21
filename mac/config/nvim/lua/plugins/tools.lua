return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "flake8",
        "shellcheck",
        "shfmt",
        "stylua",
      },
    },
  },
}
