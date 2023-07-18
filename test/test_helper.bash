# Load bats-support/bats-assert
load test_helper/bats-support/load
load test_helper/bats-assert/load

# Run on test suite setup
setup() {
  # get the containing directory of this file use $BATS_TEST_FILENAME instead
  # of ${BASH_SOURCE[0]} or $0, as those will point to the bats executable's
  # location or the preprocessed file respectively
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"

  # make executables in bin/ and test/bin visible to PATH
  PATH="$DIR/../bin:$DIR/../test/bin:$PATH"
}

# Assert the given jq query matches the expected result.
#
# $1 - query
# $2 - expected value
assert_json() {
  # shellcheck disable=SC2154
  assert_equal "$(jq -r -e "$1" <<< "$output")" "$2"
}
