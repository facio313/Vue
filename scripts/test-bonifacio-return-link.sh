#!/bin/sh
set -eu

header='frontend/indiv/src/components/layout/Header.vue'

assert_contains() {
  needle=$1
  if ! grep -Fq -- "$needle" "$header"; then
    printf 'Expected %s to contain: %s\n' "$header" "$needle" >&2
    exit 1
  fi
}

assert_contains '<a class="bonifacio-return-link" href="https://bonifacio.work/">← Bonifacio</a>'
assert_contains 'min-width: 44px;'
assert_contains 'min-height: 44px;'
assert_contains '.bonifacio-return-link:focus-visible'

printf 'Bonifacio return-link contract passed.\n'
