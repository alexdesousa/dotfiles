# Dotfiles

This repository contains scripts to generate a basic installation for myself
and adapted to my working laptop.

This is a work in progress. The objective is to automate repetitive
installation steps:

```
# src/install.sh <TASK> [-u <USERNAME>]
```

The available tasks are:
  - `base`: It installs missing packages for a fresh Debian installation
    (`vim`, `zsh`, `tmux`, `asdf`, among others) and configures them according
    to my taste.
  - `vim`: It installs `vim` according to my taste.
  - `zsh`: It installs `zsh` and `oh-my-zsh` according to my taste.
  - `asdf`: It installs `asdf` version manager.
  - `truffle`: It installs `truffle` (solidity contracts framework).

In the future, i'll add:
  - `redis`    - It installs the latest version of Redis.
  - `erlang`   - It installs the latest version of Erlang.
  - `rabbitmq` - It installs the latest version of RabbitMQ and Erlang.
  - `elixir`   - It installs the latest version of Elixir and Erlang.
  - `firefox`  - It installs the latest stable version of Firefox.
  - `spotify`  - It installs the latest Spotify client version.
