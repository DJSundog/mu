# Meaningless conventional example.
#
# To run:
#   $ ./translate_mu apps/hello.mu
#   $ ./a.elf

fn main -> _/ebx: int {
  print-string 0, "Hello world!\n"
  return 0
}
