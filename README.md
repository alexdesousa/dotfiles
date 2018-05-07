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
  - `firefox`  - It installs the latest stable version of Firefox.
  - `ganache`  - It installs Ganache 1.1.0.
  - `spotify`  - It installs the latest Spotify client version.
  - `slack`    - It installs the latest version of Slack.
  - `erlang`   - It installs the latest version of Erlang.
  - `elixir`   - It installs the latest versions of Erlang and Elixir.

In the future, i'll add:
  - `redis`    - It installs the latest version of Redis.
  - `rabbitmq` - It installs the latest version of RabbitMQ and Erlang.
