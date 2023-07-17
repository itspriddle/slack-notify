# slack-notify 1 "Jul 2023" slack-notify "User Manuals"

## SYNOPSIS

`slack-notify [options] <message>`

`echo "Message" | slack-notify [options]`

`slack-notify -F "Field Title|Body" [options]`

## DESCRIPTION

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

## OPTIONS

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
    attachment with the specified index. Eg: `-F1 FIELD`, `--field10
    FIELD`.

*-b FALLBACK*, *--fallback FALLBACK*  
    Fallback text to send. This is displayed in notifications. If not
    supplied, a default fallback is created using a line "Title: Value"
    for each field. Ignored if at least one field is not supplied with
    `-F` / `--field`.

*-b[0-9]+ FALLBACK*, *--fallback[0-9]+ FALLBACK*  
    Same as `-f` / `--fallback` above, but adds the fallback text to the
    message attachment with the specified index. Eg: `-b1 FALLBACK`,
    `--fallback10 FALLBACK`.

*-p PRETEXT*, *--pretext PRETEXT*  
    Message pretext, displayed above the fieldset. Ignored if at least one
    field is not supplied with `-F` / `--field`.

*-p[0-9]+ PRETEXT*, *--pretext[0-9]+ PRETEXT*  
    Same as `-p` / `--pretext` above, but adds the pretext to the message
    attachment with the specified index. Eg: `-p1 PRETEXT`, `--pretext10
    PRETEXT`.

*-c COLOR*, *--color COLOR*  
    Color of the fieldset in CSS hex format (i.e. `#FF0000`). Ignored if at
    least one field is not supplied with `-F` / `--field`.

*-c[0-9]+ COLOR*, *--color[0-9]+ COLOR*  
    Same as `-c` / `--color` above, but adds the color to the message
    attachment with the specified index. Eg: `-c1 COLOR`, `--color10
    COLOR`.

*-f FOOTER*, *--footer FOOTER*  
    Footer text, displayed below the fieldset. Ignored if at least one
    field is not supplied with `-F` / `--field`.

*-f[0-9]+ FOOTER*, *--footer[0-9]+ FOOTER*  
    Same as `--footer` above, but adds the footer to the message
    attachment with the specified index. Eg: `-f1FOOTER`, `--footer10
    FOOTER`.

*-P*, *--print-payload*  
    Print the Slack payload instead of sending it.

*-h*, *--help*  
    Print this help message.

## EXAMPLES

TODO

## OPTIONAL CONFIGURATION

`$SLACK_WEBHOOK_URL` can be set to avoid passing webhooks via `-w` /
`--webhook-url` when calling this script. Example:

    export SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...

## BUG REPORTS

Issues can be reported on GitHub:

<https://github.com/itspriddle/slack-notify/issues>

## AUTHOR

Joshua Priddle <jpriddle@me.com>

https://github.com/itspriddle/slack-notify#readme

## LICENSE

MIT License

Copyright (c) 2023 Joshua Priddle <jpriddle@me.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
