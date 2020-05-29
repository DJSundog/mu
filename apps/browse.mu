# render text with word-wrap

fn main args: (addr array (addr array byte)) -> exit-status/ebx: int {
  var filename/eax: (addr array byte) <- first-arg args
  var file/esi: (addr buffered-file) <- load-file filename
  enable-screen-grid-mode
  var nrows/eax: int <- copy 0
  var ncols/ecx: int <- copy 0
  nrows, ncols <- screen-size
  enable-keyboard-immediate-mode
  {
    render file, nrows, ncols
    var key/eax: byte <- read-key
    compare key, 0x71  # 'q'
    loop-if-!=
  }
  enable-keyboard-type-mode
  enable-screen-type-mode
  exit-status <- copy 0
}

# decide how to lay out pages on screen
fn render in: (addr buffered-file), nrows: int, ncols: int {
  # Fit n pages on screen on separate columns, each wide enough to read
  # comfortably.
  # Pages are separated horizontally by a 'page margin'. Among other reasons,
  # this allows the odd line to bleed out on the right if necessary.
  #
  # hardcoded parameters:
  #   top-margin
  #   page-margin
  #   text-width
  var npages/eax: int <- num-pages ncols, 0x40, 5  # text-width, page-margin
  var toprow/eax: int <- copy 2  # top-margin
  var botrow/ecx: int <- copy nrows
  var leftcol/edx: int <- copy 5  # page-margin
  var rightcol/ebx: int <- copy leftcol
  rightcol <- add 0x40  # text-width = 64 characters
  {
    compare rightcol, ncols
    break-if->=
    render-page in, toprow, leftcol, botrow, rightcol
    leftcol <- copy rightcol
    leftcol <- add 5  # page-margin
    rightcol <- copy leftcol
    rightcol <- add 0x40  # text-width
    loop
  }
}

fn num-pages ncols: int, text-width: int, page-margin: int -> result/eax: int {
  result <- copy 3
}

fn render-page in: (addr buffered-file), toprow: int, leftcol: int, botrow: int, rightcol: int {
  clear toprow, leftcol, botrow, rightcol
  # render screen rows
  var row/ecx: int <- copy toprow
$line-loop:  {
    compare row, botrow
    break-if->=
    var col/edx: int <- copy leftcol
    move-cursor row, col
    {
      compare col, rightcol
      break-if->=
      var c/eax: byte <- read-byte-buffered in
      compare c, 0xffffffff  # EOF marker
      break-if-= $line-loop
      compare c, 0xa  # newline
      break-if-=  # no need to print newlines
      print-byte c
      col <- increment
      loop
    }
    flush-stdout
    row <- increment
    loop
  }
  flush-stdout
}

fn clear toprow: int, leftcol: int, botrow: int, rightcol: int {
  var row/ecx: int <- copy toprow
  {
    compare row, botrow
    break-if->=
    var col/edx: int <- copy leftcol
    move-cursor row, col
    {
      compare col, rightcol
      break-if->=
      print-string " "
      col <- increment
      loop
    }
    row <- increment
    loop
  }
}

fn first-arg args-on-stack: (addr array (addr array byte)) -> out/eax: (addr array byte) {
  var args/eax: (addr array (addr array byte)) <- copy args-on-stack
  var result/eax: (addr addr array byte) <- index args, 1
  out <- copy *result
}

fn load-file filename: (addr array byte) -> out/esi: (addr buffered-file) {
  var result: (handle buffered-file)
  {
    var tmp1/eax: (addr handle buffered-file) <- address result
    open filename, 0, tmp1
  }
  var tmp2/eax: (addr buffered-file) <- lookup result
  out <- copy tmp2
}

fn dump in: (addr buffered-file) {
  var c/eax: byte <- read-byte-buffered in
  compare c, 0xffffffff  # EOF marker
  break-if-=
  print-byte c
  loop
}