# Dotfiles

> In computing, a hidden folder or hidden file is a folder or file which
> filesystem utilities do not display by default when showing a directory
> listing.
>
> They are commonly used for storing user preferences or preserving the state of
> a utility, and are frequently created implicitly by using various utilities.

This repository configures **Debian Testing** in my laptop automatically using
Ansible e.g:

```
# ./bin/bootstrap.sh
```

Requires the following environment variables set into the file `.envrc` at the
root of this project.

```bash
# .envrc file
export DOTFILES_BOOTSTRAP_USER="<OS username>"
export DOTFILES_BOOTSTRAP_GIT_NAME="<Git name>"
export DOTFILES_BOOTSTRAP_GIT_EMAIL="<Git email>"
export DOTFILES_BOOTSTRAP_ZSH_OATH_KEY="<Oath key>"
export DOTFILES_BOOTSTRAP_ZSH_OATH_EMAIL="<Oath email>"
```

> **NOTE**: The reason for not having defaults for these variables is to avoid
> commiting personal data to the repository.

When `./bin/bootstrap.sh` is executed with a tag, will install all roles
necessary for that tag. This is useful for specific updates e.g:

```
# ./bin/bootstrap.sh -t erlang
```

> For more information just run `./bin/bootstrap.sh -h`

## Overriding Variables

All predefined variables can be overriden by creating the file `vars/custom.yml`
with the overrides inside e.g:

```yaml
---

docker_compose_version: 1.25.3
fzf_bat_version: 0.12.0
asdf_version: 0.7.4
```

## Base Role

Installs and configures my base system. The available `vars/custom.yml`
overrides are:

- `base_repositories`: Defaults to the repositories for Debian Testing.
- `base_dependencies`: Defaults to the base dependencies for my laptop.

## Git Role

Installs and configures git. Depends on the following OS environment variables:

- `$DOTFILES_BOOTSTRAP_GIT_NAME`: Git user name.
- `$DOTFILES_BOOTSTRAP_GIT_EMAIL`: Git email.

Relevant files:

- `roles/git/templates/gitconfig.j2`: Template for generating git's config.
- `roles/git/files/gitignore_global.link`: File for ignoring files globally.

## ZSH Role

Installs and configures ZSH with `oh-my-zsh`. For using
[oath zsh plugin](https://github.com/alexdesousa/oath) these variables are needed:

- `$DOTFILES_BOOTSTRAP_ZSH_OATH_KEY_`: Oath key.
- `$DOTFILES_BOOTSTRAP_ZSH_OATH_EMAIL`: Oath email.

Relevant files:

- `roles/zsh/templates/zshrc.j2`: Template for my zsh configuration.
- `roles/zsh/files/aliases.zsh`: My aliases.

Other relevant files gathered from other roles:

- `roles/asdf/files/asdf.zsh`: ASDF configuration.
- `roles/erlang/files/erlang.zsh`: Erlang configuration.
- `roles/docker/files/docker.zsh`: Docker configuration.
- `roles/fzf/files/fzf.zsh`: FZF configuration.
- `roles/flutter/files/flutter.zsh`: Flutter configuration.
- `roles/microsoft/files/microsoft.zsh`: Microsoft configuration.

## Tmux Role

Installs and configures Tmux.

Relevant files:

- `roles/tmux/files/tmux.conf.link`: File for tmux configuration.

## FZF Role

Installs and configures FZF with `fd` and `bat` support. The available
`vars/custom.yml` overrides are:

- `fzf_bat_version`: `bat` version to be used.

## Docker Role

Installs and configures docker. The available `vars/custom.yml` overrides are:

- `docker_dependencies`: Defaults to the apt dependencies for docker.
- `docker_repository`: Defaults to docker's Debian buster repository.
- `docker_packages`: Defaults to docker's packages to be installed.
- `docker_compose_version`: `docker-compose` version to be used.

## ASDF Role

Installs and configures asdf. The available `vars/custom.yml` overrides are:

- `asdf_version`: `asdf` version to be used.

> **NOTE**: For roles depending on `asdf` role, they have the following
> variables available:
>
> - `asdf_dir`: `asdf` directory.
> - `asdf_bin`: `asdf` binary.
> - `asdf_src`: `source`-able `asdf` script to load `asdf` commands in current
>   shell.

## Erlang Role

Installs and configures Erlang. The available `vars/custom.yml` overrides are:

- `erlang_dependencies`: Erlang apt dependencies.
- `erlang_versions`: Erlang versions to be used.

## Elixir Role

Instals and configures Elixir. The available `vars/custom.yml` overrides are:

- `elixir_versions`: Elixir versions to be used.

## NodeJS Role

Instals and configures NodeJS. The available `vars/custom.yml` overrides are:

- `nodejs_dependencies`: NodeJS apt dependencies.
- `nodejs_versions`: NodeJS versions to be used.

## Haskell Role

Installs and configures Haskell. The available `vars/custom.yml` overrides are:

- `haskell_versions`: Haskell versions to be used.

## NeoVIm Role

Installs and configures Neovim and its plugins.

Relevant files:

- `roles/neovim/files/init.vim.link`: File for Neovim configuration.
- `roles/neovim/files/tabs.vim.link`: Tab numbers configuration.
- `roles/neovim/files/mkdir.vim.link`: Automatically creates directories on
  file creation when they don't exist.
- `roles/neovim/files/elixir-ls.vim.link`: Automatically downloads and compiles
  Elixir's language server.
- `roles/neovim/files/coc.vim.link`: coc.nvim configuration.
- `roles/neovim/files/coc-settings.json.link`: coc.nvim JSON configuration.

## Visual Code Role

Installs Visual Code and configures it.

## Author

Alexander de Sousa.

## License

`Dotfiles` is released under the MIT License. See the LICENSE file for further
details.
