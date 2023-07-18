# slack-notify

Send notifications via legacy Slack incoming webhooks.

Why? Slack keeps letting us create them, so we'll keep using them.

## Synopsis

    slack-notify [options] <message>
    echo "Message" | slack-notify [options]
    slack-notify -F "Field Title|Body" [options]

## Description

Without the `-F` / `--field` option, a standard text message sent to the
webhook, either as the first argument or STDIN.

Text Example:

    $ slack-notify "This is a message"
    $ echo "This is a message | slack-notify"

When `-F` / `--field` is used, a Slack message "attachment" is used (not
to be confused with a file attachment). Messages sent via legacy webhooks
can have more than one attachment, or none at all as with th text example
above. Attachments have one or more fields. By default, one attachment is
used and multiple fields can be added to it by specifying `-F` / `--field`
more than once. To send more than one attachment, `-F` / `--field` can be
used with an index; eg: `-F1` / `--field2`. To further style messages, the
`-c` / `--color`, `-p` / `--pretext`, `-b` / `--fallback`, and `-f` /
`--footer` options can also be used with an index.

Fields have a title and a value. The option can be used more than
once. The argument to `-F` / `--field` is a string, separated by the `-s`
/ `--separator` character (`|` by default).

Slack allows specifying long or short fields. If multiple short fields are
sent, they will be displayed in 2 columns in Slack clients. Long fields
span both columns. Fields are marked short by default or when the title is
prefixed with `short:`. Fields are marked long when the title is prefixed
with `long:`.

Single attachment example with 2 fields:

    $ slack-notify -F "Field Title|Body" -F "Another Field|Body"

Multiple attachments, red and green:

    $ slack-notify \
      -F "Field Title|Body" \
      -F "Another Field|Body" \
      -c FF0000 \
      -f "The First Footer" \
      -F1 "Attachment 2 - Field Title|Body" \
      -F1 "Attachment 2 - Another Field|Body" \
      -F1 "long:Attachment 2 - Big Long Field|Body" \
      -c1 00FF00 \
      -p1 "Attachment 2 Ready"

The following options have no effect when sending a plaintext message:

- `-b` / `--fallback`
- `-p` / `--pretext`
- `-c` / `--color`
- `-s` / `--separator`
- `-f` / `--footer`

## Options

*-w URL*, *--webhook-url URL*  
    Slack webhook URL. Required unless the `$SLACK_WEBHOOK_URL` environment
    variable is set.

*-c CHANNEL*, *--channel CHANNEL*  
    Slack channel/user to send the message to. If not supplied, the
    default channel configured on the webhook is used by Slack.

*-i ICON*, *--icon ICON*  
    Icon to use, either an emoji code like `:megaphone:`, or an image URL.
    If not supplied, the default icon configured on the webhook is used by
    Slack.

*-u USER*, *--username USER*  
    User to send the message as. If not supplied, the default user
    configured on the webhook is used by Slack.

*-F FIELD*, *--field FIELD*  
    Send a message field in the format where FIELD is one of the following
    formats: `Title|Value`, `long:Title|Value`, `short:Title|Value`. The field
    separator `|` character can be customized with the `-s` / `--separator`
    option.

*-F[0-9]+ FIELD*, *--field[0-9]+ FIELD*  
    Same as `-F` / `--field` above, but adds the field a to the message
    attachment with the specified index. Eg: `-F1 FIELD`,
    `--field2 FIELD`.

*-b FALLBACK*, *--fallback FALLBACK*  
    Fallback text to send. This is displayed in notifications. If not
    supplied, a default fallback is created using a line "Title: Value"
    for each field. Ignored if at least one field is not supplied with
    `-F` / `--field`.

*-b[0-9]+ FALLBACK*, *--fallback[0-9]+ FALLBACK*  
    Same as `-f` / `--fallback` above, but adds the fallback text to the
    message attachment with the specified index. Eg: `-b1 FALLBACK`,
    `--fallback2 FALLBACK`.

*-p PRETEXT*, *--pretext PRETEXT*  
    Message pretext, displayed above the attachment. Ignored if at least one
    field is not supplied with `-F` / `--field`.

*-p[0-9]+ PRETEXT*, *--pretext[0-9]+ PRETEXT*  
    Same as `-p` / `--pretext` above, but adds the pretext to the message
    attachment with the specified index. Eg: `-p1 PRETEXT`,
    `--pretext2 PRETEXT`.

*-c COLOR*, *--color COLOR*  
    Color of the attachment in CSS hex format (i.e. `#FF0000`). Ignored if at
    least one field is not supplied with `-F` / `--field`.

*-c[0-9]+ COLOR*, *--color[0-9]+ COLOR*  
    Same as `-c` / `--color` above, but adds the color to the message
    attachment with the specified index. Eg: `-c1 COLOR`,
    `--color2 COLOR`.

*-f FOOTER*, *--footer FOOTER*  
    Footer text, displayed below the attachment. Ignored if at least one
    field is not supplied with `-F` / `--field`.

*-f[0-9]+ FOOTER*, *--footer[0-9]+ FOOTER*  
    Same as `--footer` above, but adds the footer to the message
    attachment with the specified index. Eg: `-f1 FOOTER`,
    `--footer2 FOOTER`.

*-P*, *--print-payload*  
    Print the Slack payload instead of sending it.

*-h*, *--help*  
    Print this help message.

## Examples

TODO

## Optional Configuration

`$SLACK_WEBHOOK_URL` can be set to avoid passing webhooks via `-w` /
`--webhook-url` when calling this script. Example:

    export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...

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

    git clone https://github.com/itspriddle/slack-notify
    cd slack-notify
    sudo make install PREFIX=/usr/local

### Install locally via make

If you don't want a global installation, another common pattern is to install
to `~/.local`. This is enabled on Ubuntu by default.

    git clone https://github.com/itspriddle/slack-notify
    cd slack-notify
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

    wget https://github.com/itspriddle/slack-notify/raw/master/bin/slack-notify
    chmod +x slack-notify
    sudo mv slack-notify /usr/local/bin
    slack-notify -V

Install the man page:

    wget https://github.com/itspriddle/slack-notify/raw/master/share/man/man1/slack-notify.1
    mkdir -p /usr/local/share/man/man1
    mv slack-notify.1 /usr/local/share/man/man1
    man slack-notify

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
