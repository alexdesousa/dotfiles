# Dotfiles

> In computing, a hidden folder or hidden file is a folder or file which
> filesystem utilities do not display by default when showing a directory
> listing.
>
> They are commonly used for storing user preferences or preserving the state of
> a utility, and are frequently created implicitly by using various utilities.

This repository configures my laptop automatically using Ansible:

```
$ sudo apt install ansible
$ ./bin/engage.sh
```

![Shell preview](shell.gif)

## Elixir Language Server

After everything is done, sometimes we still need to ensure the Elixir LS is
built:

```bash
$ cd ~/.config/nvim/plugged/elixir-ls/
$ mix deps.get
$ mix elixir_ls.release -o release
```

And this should finish the setup.

## Author

Alexander de Sousa.

## License

`Dotfiles` is released under the MIT License. See the LICENSE file for further
details.
