load test_helper

@test "-V / --version shows version info" {
  run slack-notify -V

  assert_success
  assert_output --regexp "slack-notify v[0-9]+\.[0-9]+\.[0-9]+"

  run slack-notify --version

  assert_success
  assert_output --regexp "slack-notify v[0-9]+\.[0-9]+\.[0-9]+"
}

@test "-h shows short usage" {
  run slack-notify -h

  assert_success
  assert_output --partial "Usage: slack-notify"
}

@test "--h shows shows full help" {
  run slack-notify --help

  assert_success
  assert_output --partial "SYNOPSIS"
}

@test "sends a plain text message via arg" {
  run slack-notify -P "Test message"

  assert_json ".text" "Test message"
}

@test "sends a plain text message via STDIN" {
  # shellcheck disable=SC2317
  _run() {
    echo "Test message" | slack-notify -P -
  }

  run _run

  assert_json ".text" "Test message"
}

@test "requires a plain text message via arg/STDIN or --fields" {
  _run() {
    echo | slack-notify -P
  }

  run _run

  assert_failure
  assert_output "Must supply text to send via argument, STDIN, or --field"
}

@test "-C / --channel sets the channel" {
  run slack-notify -P -C "#test" "Test message"

  assert_json ".channel" "#test"

  run slack-notify -P --channel "#test2" "Test message 2"

  assert_json ".channel" "#test2"
}

@test "-i / --icon sets an emoji icon" {
  run slack-notify -P -i ":mega:" "Test message"

  assert_json ".icon_emoji" ":mega:"

  run slack-notify -P --icon ":trollface:" "Test message 2"

  assert_json ".icon_emoji" ":trollface:"
}

@test "-i / --icon sets an icon url" {
  run slack-notify -P -i "http://example.com/icon" "Test message"

  assert_json ".icon_url" "http://example.com/icon"

  run slack-notify -P --icon "http://example.com/icon2" "Test message 2"

  assert_json ".icon_url" "http://example.com/icon2"
}

@test "-u / --user sets a custom user" {
  run slack-notify -P -u "Bot McBotface" "Test message"

  assert_json ".username" "Bot McBotface"

  run slack-notify -P --username "Bot McBotface 2" "Test message 2"

  assert_json ".username" "Bot McBotface 2"
}

@test "-F / --field sets attachment fields" {
  run slack-notify -P \
    -F      "Field 1|Value 1" \
    --field "long:Field 2|Value 2" \
    --field "short:Field 3|Value 3"

  assert_json ".attachments[0].fields[0].title" "Field 1"
  assert_json ".attachments[0].fields[0].value" "Value 1"
  assert_json ".attachments[0].fields[0].short" "true"

  assert_json ".attachments[0].fields[1].title" "Field 2"
  assert_json ".attachments[0].fields[1].value" "Value 2"
  assert_json ".attachments[0].fields[1].short" "false"

  assert_json ".attachments[0].fields[2].title" "Field 3"
  assert_json ".attachments[0].fields[2].value" "Value 3"
  assert_json ".attachments[0].fields[2].short" "true"
}

@test "-F / --field with index sets additional attachments" {
  run slack-notify -P \
    -F       "Attachment 1 - Field 1|Value 1" \
    --field  "Attachment 1 - Field 2|Value 2" \
    -F1      "Attachment 2 - Field 1|Value 3" \
    --field1 "Attachment 2 - Field 2|Value 4"

  assert_json ".attachments[0].fields[0].title" "Attachment 1 - Field 1"
  assert_json ".attachments[0].fields[0].value" "Value 1"
  assert_json ".attachments[0].fields[1].title" "Attachment 1 - Field 2"
  assert_json ".attachments[0].fields[1].value" "Value 2"

  assert_json ".attachments[1].fields[0].title" "Attachment 2 - Field 1"
  assert_json ".attachments[1].fields[0].value" "Value 3"
  assert_json ".attachments[1].fields[1].title" "Attachment 2 - Field 2"
  assert_json ".attachments[1].fields[1].value" "Value 4"
}

@test "-c / --color sets the attachment color" {
  run slack-notify -P \
    -c "#00ff00" \
    --field "Field|Value"

  assert_json ".attachments[0].color" "#00ff00"

  run slack-notify -P \
    --color "#ff0000" \
    --field "Field|Value"

  assert_json ".attachments[0].color" "#ff0000"
}

@test "-c / --color with index sets the attachment color for additional attachments" {
  run slack-notify -P \
    --field  "Field 1|Value" \
    -c       "#ff0000" \
    --field1 "Field 2|Value" \
    --color1 "#00ff00" \
    --field2 "Field 2|Value" \
    -c2      "#0000ff"

  assert_json ".attachments[0].color" "#ff0000"
  assert_json ".attachments[1].color" "#00ff00"
  assert_json ".attachments[2].color" "#0000ff"
}

@test "-b / --fallback sets the attachment fallback" {
  run slack-notify -P \
    -b      "Fallback" \
    --field "Field|Value"

  assert_json ".attachments[0].fallback" "Fallback"

  run slack-notify -P \
    --fallback "Fallback 2" \
    --field "Field|Value"

  assert_json ".attachments[0].fallback" "Fallback 2"
}

@test "-b / --fallback with index sets the attachment fallback for additional attachments" {
  run slack-notify -P \
    -b "Fallback 1" \
    --fallback1 "Fallback 2" \
    --field "Field 1|Value" \
    --field1 "Field 2|Value"

  assert_json ".attachments[0].fallback" "Fallback 1"
  assert_json ".attachments[1].fallback" "Fallback 2"
}

@test "--fallback defaults to 'title: value' for all fields joined by newline" {
  run slack-notify -P \
    --field "Field 1|Value 1" \
    --field "Field 2|Value 2" \
    --field1 "Field 3|Value 3" \
    --field1 "Field 4|Value 4"

  assert_json ".attachments[0].fallback" "Field 1: Value 1"$'\n'"Field 2: Value 2"
  assert_json ".attachments[1].fallback" "Field 3: Value 3"$'\n'"Field 4: Value 4"
}

@test "-p / --pretext sets the attachment pretext" {
  run slack-notify -P \
    --pretext "Pretext" \
    --field "Field|Value"

  assert_json ".attachments[0].pretext" "Pretext"

  run slack-notify -P \
    -p "Pretext 2" \
    --field "Field|Value"

  assert_json ".attachments[0].pretext" "Pretext 2"
}

@test "-p / --pretext sets the attachment pretext for additional attachments" {
  run slack-notify -P \
    -p "Pretext 1" \
    --pretext1 "Pretext 2" \
    --field "Field 1|Value" \
    --field1 "Field 2|Value"

  assert_json ".attachments[0].pretext" "Pretext 1"
  assert_json ".attachments[1].pretext" "Pretext 2"
}

@test "-f / --footer sets the attachment footer" {
  run slack-notify -P \
    -f "Footer" \
    --field "Field|Value"

  assert_json ".attachments[0].footer" "Footer"

  run slack-notify -P \
    --footer "Footer 2" \
    --field "Field|Value"

  assert_json ".attachments[0].footer" "Footer 2"
}

@test "-f / --footer with index sets the attachment footer for additional attachments" {
  run slack-notify -P \
    -f "Footer 1" \
    --footer1 "Footer 2" \
    --field "Field 1|Value" \
    --field1 "Field 2|Value"

  assert_json ".attachments[0].footer" "Footer 1"
  assert_json ".attachments[1].footer" "Footer 2"
}

@test "-s / --separator sets the field title/value separator" {
  run slack-notify -P \
    -s "@" \
    --field "Field@Value"

  assert_json ".attachments[0].fields[0].title" "Field"
  assert_json ".attachments[0].fields[0].value" "Value"

  run slack-notify -P \
    --separator "^" \
    --field "Field 2^Value 2"

  assert_json ".attachments[0].fields[0].title" "Field 2"
  assert_json ".attachments[0].fields[0].value" "Value 2"
}
