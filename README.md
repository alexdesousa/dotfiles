# Dotfiles

> In computing, a hidden folder or hidden file is a folder or file which
> filesystem utilities do not display by default when showing a directory
> listing.
>
> They are commonly used for storing user preferences or preserving the state of
> a utility, and are frequently created implicitly by using various utilities.

This repository configures my laptop automatically using Ansible e.g:

```
# bin/bootstrap.sh
```

Requires the following environment variables set into the file `.envrc` at the
root of this project.

```bash
# .envrc file
export DOTFILES_BOOTSTRAP_USER="<OS username>"
export DOTFILES_BOOTSTRAP_GIT_NAME="<Git name>"
export DOTFILES_BOOTSTRAP_GIT_EMAIL="<Git email>"
```
