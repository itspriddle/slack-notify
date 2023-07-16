# slack-notify

Send notifications via legacy Slack incoming webhooks.

Why? Slack keeps letting us create them, so we'll keep using them.

## Usage

TODO

### Options

TODO

### Examples

TODO

### Optional Configuration

TODO

## Installation

`slack-notify` includes the main [`bin/slack-notify`](./bin/slack-notify) bash
script and an optional man page
[`share/man/man1/slack-notify.1`](./share/man/man1/slack-notify.1).

To install `slack-notify`, the bash script needs to be copied to a directory
in your `$PATH`. If you want `man slack-notify` to work, the man page needs to
be copied to a directory in your `$MANPATH`.

### Install globally via Homebrew on macOS

On macOS, `slack-notify` can be installed via Homebrew with:

    brew install itspriddle/brews/slack-notify

### Install globally via make

macOS and most Linux distributions add `/usr/local/bin` to `$PATH` and
`/usr/local/share/man` to `$MANPATH`. If you are the only user on the machine,
or if you want to make `slack-notify` available for all users, you can install
it globally as follows:

    git clone https://github.com/itspriddle/slack-notify /tmp/slack-notify
    cd /tmp/slack-notify
    sudo make install PREFIX=/usr/local
    cd
    rm -rf /tmp/slack-notify

### Install locally via make

If you don't want a global installation, another common pattern is to install
to `~/.local`. This is enabled on Ubuntu by default.

    mkdir -p ~/.local/src
    git clone https://github.com/itspriddle/slack-notify ~/.local/src/slack-notify
    cd ~/.local/src/slack-notify
    make install PREFIX=~/.local

To test, verify that `slack-notify -V` works and that `man slack-notify`
prints the man page.

If you see `slack-notify: command not found`, you need to update your `$PATH`.
If you are using Bash, add the following to `~/.bash_profile`, or if you are
using ZSH, add it to `~/.zshenv`:

    export PATH="$HOME/.local/bin:$PATH"

If `man slack-notify` reports `No manual entry for slack-notify`, you need to
update your `$MANPATH`. This can be done by adding the following to
`~/.manpath` (note, change USER to your username):

    MANDATORY_MANPATH /home/USER/.manpath

### Copy the script manually

The `slack-notify` script can also be downloaded manually and saved to any
directory in your `$PATH` (such as `/usr/local/bin` or `~/.local/bin` as
described above).

    curl -s -L https://github.com/itspriddle/slack-notify/raw/master/bin/slack-notify > /tmp/slack-notify
    sudo mv /tmp/slack-notify /usr/local/bin
    sudo chmod +x /usr/local/bin/slack-notify
    slack-notify -V

## Development

### Tests

Tests for this project are written using
[Bats](https://github.com/bats-core/bats-core) and are in the
[`test/`](./test) directory. To install Bats and run the test suite run:

    make bootstrap
    make bats

Bash files are also checked with [ShellCheck](https://www.shellcheck.net). To
run ShellCheck:

    make shellcheck

To run Bats tests and ShellCheck:

    make test

### Documentation

Documentation for this project exists in:

- This README file
- The [`bin/slack-notify`](./bin/slack-notify) script's comments at the top of
  the file (shown when `slack-notify --help` is used)
- The Markdown file at
  [`doc/man/slack-notify.1.md`](./doc/man/slack-notify.1.md) that the man page
  is generated from

If documentation is updated it should be done in all of the places above.

The man page is written in Markdown in the
[`doc/man/slack-notify.1.md`](./doc/man/slack-notify.1.md) file. The
[kramdown-man](https://github.com/postmodern/kramdown-man) Ruby Gem is used to
generate a roff file that `man` uses.

If you have Ruby installed, the kramdown-man gem can be installed as follows:

    gem install kramdown-man

The roff file can be generated using one of the following:

    make man
    make share/man/man1/slack-notify.1

This will regenerate `share/man/man1/slack-notify.1` from the contents of
`doc/man/slack-notify.1.md`. Both files should be committed to the repo.

## Bug Reports

Issues can be reported on GitHub:

<https://github.com/itspriddle/slack-notify/issues>

## Author

Joshua Priddle <jpriddle@me.com>

<https://github.com/itspriddle/slack-notify#readme>

## License

MIT License. See [LICENSE](./LICENSE) in this repo.
