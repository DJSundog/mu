# Wrappers for real screen primitives that can be passed in a fake screen.

type screen {
  num-rows: int
  num-cols: int
  data: (handle array screen-cell)
  pending-scroll?: boolean
  top-index: int
  cursor-row: int
  cursor-col: int
  cursor-hide?: boolean
  curr-attributes: screen-cell
}

type screen-cell {
  color: int
  background-color: int
  bold?: boolean
  underline?: boolean
  reverse?: boolean
  blink?: boolean
}

fn initialize-screen screen: (addr screen), nrows: int, ncols: int {
  var screen-addr/esi: (addr screen) <- copy screen
  var tmp/eax: int <- copy 0
  var dest/edi: (addr int) <- copy 0
  # screen->num-rows = nrows
  dest <- get screen-addr, num-rows
  tmp <- copy nrows
  copy-to *dest, tmp
  # screen->num-cols = ncols
  dest <- get screen-addr, num-cols
  tmp <- copy ncols
  copy-to *dest, tmp
  # screen->data = new screen-cell[nrows*ncols]
  {
    var data-addr/edi: (addr handle array screen-cell) <- get screen-addr, data
    tmp <- multiply nrows
    populate data-addr, tmp
  }
  # screen->cursor-row = 1
  dest <- get screen-addr, cursor-row
  copy-to *dest, 1
  # screen->cursor-col = 1
  dest <- get screen-addr, cursor-col
  copy-to *dest, 1
  # screen->curr-attributes->background-color = 7  (simulate light background)
  var tmp2/eax: (addr screen-cell) <- get screen-addr, curr-attributes
  dest <- get tmp2, background-color
  copy-to *dest, 7
}

fn screen-size screen: (addr screen) -> nrows/eax: int, ncols/ecx: int {
$screen-size:body: {
  compare screen, 0
  {
    break-if-!=
    nrows, ncols <- real-screen-size
    break $screen-size:body
  }
  {
    break-if-=
    # fake screen
    var screen-addr/esi: (addr screen) <- copy screen
    var tmp/edx: (addr int) <- get screen-addr, num-rows
    nrows <- copy *tmp
    tmp <- get screen-addr, num-cols
    ncols <- copy *tmp
  }
}
}

fn clear-screen screen: (addr screen) {
$clear-screen:body: {
  compare screen, 0
  {
    break-if-!=
    clear-real-screen
    break $clear-screen:body
  }
  {
    break-if-=
    # fake screen
    var space/edi: grapheme <- copy 0x20
    move-cursor screen, 1, 1
    var screen-addr/esi: (addr screen) <- copy screen
    var i/eax: int <- copy 1
    var nrows/ecx: (addr int) <- get screen-addr, num-rows
    {
      compare i, *nrows
      break-if->
      var j/edx: int <- copy 1
      var ncols/ebx: (addr int) <- get screen-addr, num-cols
      {
        compare j, *ncols
        break-if->
        print-grapheme screen, space
        j <- increment
        loop
      }
      i <- increment
      loop
    }
    move-cursor screen, 1, 1
  }
}
}

fn move-cursor screen: (addr screen), row: int, column: int {
$move-cursor:body: {
  compare screen, 0
  {
    break-if-!=
    move-cursor-on-real-screen row, column
    break $move-cursor:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn print-string screen: (addr screen), s: (addr array byte) {
$print-string:body: {
  compare screen, 0
  {
    break-if-!=
    print-string-to-real-screen s
    break $print-string:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn print-grapheme screen: (addr screen), c: grapheme {
$print-grapheme:body: {
  compare screen, 0
  {
    break-if-!=
    print-grapheme-to-real-screen c
    break $print-grapheme:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn print-int32-hex screen: (addr screen), n: int {
$print-int32-hex:body: {
  compare screen, 0
  {
    break-if-!=
    print-int32-hex-to-real-screen n
    break $print-int32-hex:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn reset-formatting screen: (addr screen) {
$reset-formatting:body: {
  compare screen, 0
  {
    break-if-!=
    reset-formatting-on-real-screen
    break $reset-formatting:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn start-color screen: (addr screen), fg: int, bg: int {
$start-color:body: {
  compare screen, 0
  {
    break-if-!=
    start-color-on-real-screen fg, bg
    break $start-color:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn start-bold screen: (addr screen) {
$start-bold:body: {
  compare screen, 0
  {
    break-if-!=
    start-bold-on-real-screen
    break $start-bold:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn start-underline screen: (addr screen) {
$start-underline:body: {
  compare screen, 0
  {
    break-if-!=
    start-underline-on-real-screen
    break $start-underline:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn start-reverse-video screen: (addr screen) {
$start-reverse-video:body: {
  compare screen, 0
  {
    break-if-!=
    start-reverse-video-on-real-screen
    break $start-reverse-video:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn start-blinking screen: (addr screen) {
$start-blinking:body: {
  compare screen, 0
  {
    break-if-!=
    start-blinking-on-real-screen
    break $start-blinking:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn hide-cursor screen: (addr screen) {
$hide-cursor:body: {
  compare screen, 0
  {
    break-if-!=
    hide-cursor-on-real-screen
    break $hide-cursor:body
  }
  {
    break-if-=
    # fake screen
  }
}
}

fn show-cursor screen: (addr screen) {
$show-cursor:body: {
  compare screen, 0
  {
    break-if-!=
    show-cursor-on-real-screen
    break $show-cursor:body
  }
  {
    break-if-=
    # fake screen
  }
}
}
