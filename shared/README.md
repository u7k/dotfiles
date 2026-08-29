# Shared dotfiles

This directory is the platform-neutral source for the macOS and Omarchy setups.
Each platform links the configs it supports and keeps only its integration
wrappers under `mac/` or `omarchy/`.

The shared terminal toolset is:

| Command | macOS package | Omarchy package |
| --- | --- | --- |
| `atuin` | `atuin` | `atuin` |
| `bat` | `bat` | `bat` |
| `btop` | `btop` | `btop` |
| `dua` | `dua-cli` | `dua-cli` |
| `eza` | `eza` | `eza` |
| `fastfetch` | `fastfetch` | `fastfetch` |
| `fd` | `fd` | `fd` |
| `fzf` | `fzf` | `fzf` |
| `lazydocker` | `lazydocker` | `lazydocker` |
| `lazygit` | `lazygit` | `lazygit` |
| `lumen` | `jnsahaj/lumen/lumen` | `lumen-bin` (AUR) |
| `nvim` | `neovim` | `neovim` |
| `rg` | `ripgrep` | `ripgrep` |
| `starship` | `starship` | `starship` |
| `thefuck` | `thefuck` | `fuck` (AUR) |
| `tldr` | `tlrc` | `tldr` |
| `tmux` | `tmux` | `tmux` |
| `yazi` | `yazi` | `yazi` |
| `zoxide` | `zoxide` | `zoxide` |
| `zsh` | `zsh` | `zsh` |
| Zsh completion | `zsh-autocomplete` | `zsh-autocomplete` |
| Zsh suggestions | `zsh-autosuggestions` | `zsh-autosuggestions` |
| Zsh highlighting | `zsh-syntax-highlighting` | `zsh-syntax-highlighting` |

Compared with the original setups, macOS gains `atuin`, `bat`, `dua`,
`lazydocker`, `tldr`, `zoxide`, and uses Ghostty instead of Warp. Omarchy gains the missing Yazi
package and keeps `thefuck` explicit through its AUR package. The shared shell
also merges the navigation, Git, eza tree, fuzzy-file, tmux, Yazi, Docker, and
clipboard shortcuts from both sides.

Ghostty uses a portable base with one platform wrapper. Foot is kept in the
Omarchy layer because it is a Wayland terminal. Omarchy's Ghostty, btop,
Neovim, and tmux integrations preserve dynamic themes and Omarchy-only commands.
Both platforms use Oh My Zsh for plugins and Starship for a Warp-like Tokyo
Night prompt, so Powerlevel10k is intentionally not installed.

The shared Codex defaults select **Approve for me** with the workspace sandbox.
`shared/scripts/install-codex-config.sh` merges only those portable permission
keys into `~/.codex/config.toml`, preserving machine-local project trust, plugin,
and MCP settings. Both platform bootstraps run the merge automatically; use
`make -C mac codex` or `make -C omarchy codex` to apply it separately.
