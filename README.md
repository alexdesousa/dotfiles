# Dotfiles

> In computing, a hidden folder or hidden file is a folder or file which
> filesystem utilities do not display by default when showing a directory
> listing.
>
> They are commonly used for storing user preferences or preserving the state of
> a utility, and are frequently created implicitly by using various utilities.

This repository configures my laptop automatically using Ansible.

## Setup

We need to install Ansible:

```
$ sudo apt install ansible
```

then download the file `keys.tar.gz.enc` into our project root and finally we
need to run the following:

```
$  GPG_GITHUB_KEY="<... my Github master password ...>" \
   GPG_PASSWORD_STORE_KEY="<... my Password Store master password ...>" \
   ./bin/engage.sh
```

> **Note**: Remember the space at the beginning of the command to avoid logging
> the passwords in the command log.

![Shell preview](shell.gif)

## Secrets

The secrets file has the following format:

```yaml
vault_password: "... Keys vault password ..."
base:
  git:
    name: "... My name ..."
    email: "... My email address ..."
    key: "... My Github's public key ..."
exporter:
  gpg:
    github:
      public_key: "... My Github's public key ..."
    password_store:
      public_key: "... My Password Store public key  ..."
```

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
