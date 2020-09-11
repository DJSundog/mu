fn main args-on-stack: (addr array addr array byte) -> exit-status/ebx: int {
  var args/eax: (addr array addr array byte) <- copy args-on-stack
  var tmp/ecx: int <- length args
  $main-body: {
    # if (len(args) <= 1) print usage and exit
    compare tmp, 1
    {
      break-if->
      print-string-to-real-screen "usage: browse [filename]\n"
      print-string-to-real-screen "    or browse test\n"
      exit-status <- copy 1
      break $main-body
    }
    # if (args[1] == "test") run-tests()
    var tmp2/ecx: (addr addr array byte) <- index args, 1
    var tmp3/eax: boolean <- string-equal? *tmp2, "test"
    compare tmp3, 0
    {
      break-if-=
      run-tests
      exit-status <- copy 0  # TODO: get at Num-test-failures somehow
      break $main-body
    }
    # otherwise interactive mode
    exit-status <- interactive args-on-stack
  }
}

fn interactive args: (addr array addr array byte) -> exit-status/ebx: int {
  # initialize fs from args[1]
  var filename/eax: (addr array byte) <- first-arg args
  var file-storage: (handle buffered-file)
  var file-storage-addr/esi: (addr handle buffered-file) <- address file-storage
  open filename, 0, file-storage-addr
  var _fs/eax: (addr buffered-file) <- lookup file-storage
  var fs/esi: (addr buffered-file) <- copy _fs
  #
  enable-screen-grid-mode
  enable-keyboard-immediate-mode
  # initialize screen state
  var paginated-screen-storage: paginated-screen
  var paginated-screen/eax: (addr paginated-screen) <- address paginated-screen-storage
  initialize-paginated-screen paginated-screen, 0x40, 2, 5
  normal-text paginated-screen
  #
  {
    render paginated-screen, fs
    var key/eax: byte <- read-key
    compare key, 0x71  # 'q'
    loop-if-!=
  }
  enable-keyboard-type-mode
  enable-screen-type-mode
  exit-status <- copy 0
}

fn render screen: (addr paginated-screen), fs: (addr buffered-file) {
  start-drawing screen
  render-normal screen, fs
}

fn test-render-multicolumn-text {
  # input text
  var input-storage: (handle buffered-file)
  var input-ah/eax: (addr handle buffered-file) <- address input-storage
  populate-buffered-file-containing "abcdefgh", input-ah
  var in/eax: (addr buffered-file) <- lookup input-storage
  # output screen
  var pg: paginated-screen
  var pg-addr/ecx: (addr paginated-screen) <- address pg
  initialize-fake-paginated-screen pg-addr, 3, 6, 2, 1, 1  # 3 rows, 6 columns, 2 pages * 2 columns each
  #
  render pg-addr, in
  var screen-ah/eax: (addr handle screen) <- get pg, screen
  var screen/eax: (addr screen) <- lookup *screen-ah
  check-screen-row screen, 1, "      ", "F - test-render-multicolumn-text/row1"
  check-screen-row screen, 2, " ab ef", "F - test-render-multicolumn-text/row2"
  check-screen-row screen, 3, " cd gh", "F - test-render-multicolumn-text/row3"
}

fn test-render-heading-text {
  # input text
  var input-storage: (handle buffered-file)
  var input-ah/eax: (addr handle buffered-file) <- address input-storage
  populate-buffered-file-containing "# abc\n\ndef", input-ah
  var in/eax: (addr buffered-file) <- lookup input-storage
  # output screen
  var pg: paginated-screen
  var pg-addr/ecx: (addr paginated-screen) <- address pg
  initialize-fake-paginated-screen pg-addr, 8, 6, 5, 1, 1  # 6 columns, single page
  #
  render pg-addr, in
  var screen-ah/eax: (addr handle screen) <- get pg, screen
  var screen/eax: (addr screen) <- lookup *screen-ah
  check-screen-row          screen,       1, "      ", "F - test-render-heading-text/row1"
  check-screen-row-in-color screen, 0xa0, 2, " abc  ", "F - test-render-heading-text/heading"
  check-screen-row          screen,       3, "      ", "F - test-render-heading-text/row3"
  check-screen-row          screen,       4, " def  ", "F - test-render-heading-text/row4"
}

fn test-render-bold-text {
  # input text
  var input-storage: (handle buffered-file)
  var input-ah/eax: (addr handle buffered-file) <- address input-storage
  populate-buffered-file-containing "a *b* c", input-ah
  var in/eax: (addr buffered-file) <- lookup input-storage
  # output screen
  var pg: paginated-screen
  var pg-addr/ecx: (addr paginated-screen) <- address pg
  initialize-fake-paginated-screen pg-addr, 8, 6, 5, 1, 1  # 6 columns, single page
  #
  render pg-addr, in
  var screen-ah/eax: (addr handle screen) <- get pg, screen
  var screen/eax: (addr screen) <- lookup *screen-ah
  check-screen-row         screen, 2, " a b c", "F - test-render-bold-text/text"
  check-screen-row-in-bold screen, 2, "   b  ", "F - test-render-bold-text/bold"
}

# terminals don't always support italics, so we'll just always render italics
# as bold.
fn test-render-pseudoitalic-text {
  # input text
  var input-storage: (handle buffered-file)
  var input-ah/eax: (addr handle buffered-file) <- address input-storage
  populate-buffered-file-containing "a _b_ c", input-ah
  var in/eax: (addr buffered-file) <- lookup input-storage
  # output screen
  var pg: paginated-screen
  var pg-addr/ecx: (addr paginated-screen) <- address pg
  initialize-fake-paginated-screen pg-addr, 8, 6, 5, 1, 1  # 6 columns, single page
  #
  render pg-addr, in
  var screen-ah/eax: (addr handle screen) <- get pg, screen
  var screen/eax: (addr screen) <- lookup *screen-ah
  check-screen-row         screen, 2, " a b c", "F - test-render-pseudoitalic-text/text"
  check-screen-row-in-bold screen, 2, "   b  ", "F - test-render-pseudoitalic-text/bold"
}

fn test-render-asterisk-in-text {
  # input text
  var input-storage: (handle buffered-file)
  var input-ah/eax: (addr handle buffered-file) <- address input-storage
  populate-buffered-file-containing "a*b*c", input-ah
  var in/eax: (addr buffered-file) <- lookup input-storage
  # output screen
  var pg: paginated-screen
  var pg-addr/ecx: (addr paginated-screen) <- address pg
  initialize-fake-paginated-screen pg-addr, 8, 6, 5, 1, 1  # 6 columns, single page
  #
  render pg-addr, in
  var screen-ah/eax: (addr handle screen) <- get pg, screen
  var screen/eax: (addr screen) <- lookup *screen-ah
  check-screen-row         screen, 2, " a*b*c", "F - test-render-bold-text/text"
  check-screen-row-in-bold screen, 2, "      ", "F - test-render-bold-text/bold"
}

fn render-normal screen: (addr paginated-screen), fs: (addr buffered-file) {
  var newline-seen?/esi: boolean <- copy 0  # false
  var start-of-paragraph?/edi: boolean <- copy 1  # true
  var previous-grapheme/ebx: grapheme <- copy 0
$render-normal:loop: {
    # if done-drawing?(screen) break
    var done?/eax: boolean <- done-drawing? screen
    compare done?, 0  # false
    break-if-!=
    var c/eax: grapheme <- read-grapheme-buffered fs
$render-normal:loop-body: {
      # if (c == EOF) break
      compare c, 0xffffffff  # EOF marker
      break-if-= $render-normal:loop

      ## if (c == newline) perform some fairly sophisticated parsing for soft newlines
      compare c, 0xa  # newline
      {
        break-if-!=
        # if it's the first newline, buffer it
        compare newline-seen?, 0
        {
          break-if-!=
          newline-seen? <- copy 1  # true
          break $render-normal:loop-body
        }
        # otherwise render two newlines
        {
          break-if-=
          add-grapheme screen, 0xa  # newline
          add-grapheme screen, 0xa  # newline
          newline-seen? <- copy 0  # false
          start-of-paragraph? <- copy 1  # true
          break $render-normal:loop-body
        }
      }
      # if start of paragraph and c == '#', switch to header
      compare start-of-paragraph?, 0
      {
        break-if-=
        compare c, 0x23  # '#'
        {
          break-if-!=
          render-header-line screen, fs
          newline-seen? <- copy 1  # true
          break $render-normal:loop-body
        }
      }
      # c is not a newline
      start-of-paragraph? <- copy 0  # false
      # if c is unprintable (particularly a '\r' CR), skip it
      compare c, 0x20
      loop-if-< $render-normal:loop
      # If there's a newline buffered and c is a space, print the buffered
      # newline (hard newline).
      # If there's a newline buffered and c is not a newline or space, print a
      # space (soft newline).
      compare newline-seen?, 0  # false
$render-normal:flush-buffered-newline: {
        break-if-=
        newline-seen? <- copy 0  # false
        {
          compare c, 0x20
          break-if-!=
          add-grapheme screen, 0xa  # newline
          break $render-normal:flush-buffered-newline
        }
        add-grapheme screen, 0x20  # space
        # fall through to print c
      }
      ## end soft newline support

$render-normal:whitespace-separated-regions: {
        # if previous-grapheme wasn't whitespace, skip this block
        {
          compare previous-grapheme, 0x20  # space
          break-if-=
          compare previous-grapheme, 0xa  # newline
          break-if-=
          break $render-normal:whitespace-separated-regions
        }
        # if (c == '*') switch to bold
        compare c, 0x2a  # '*'
        {
          break-if-!=
          start-color-on-paginated-screen screen, 0xec, 7  # 236 = darkish gray
          start-bold-on-paginated-screen screen
            render-until-asterisk screen, fs
          normal-text screen
          break $render-normal:loop-body
        }
        # if (c == '_') switch to bold
        compare c, 0x5f  # '_'
        {
          break-if-!=
          start-color-on-paginated-screen screen, 0xec, 7  # 236 = darkish gray
          start-bold-on-paginated-screen screen
            render-until-underscore screen, fs
          normal-text screen
          break $render-normal:loop-body
        }
      }
      #
      add-grapheme screen, c
    }  # $render-normal:loop-body
    previous-grapheme <- copy c
    loop
  }  # $render-normal:loop
}

fn render-header-line screen: (addr paginated-screen), fs: (addr buffered-file) {
$render-header-line:body: {
  # compute color based on number of '#'s
  var header-level/esi: int <- copy 1  # caller already grabbed one
  var c/eax: grapheme <- copy 0
  {
    # if done-drawing?(screen) return
    {
      var done?/eax: boolean <- done-drawing? screen
      compare done?, 0  # false
      break-if-!= $render-header-line:body
    }
    #
    c <- read-grapheme-buffered fs
    # if (c != '#') break
    compare c, 0x23  # '#'
    break-if-!=
    #
    header-level <- increment
    #
    loop
  }
  start-heading screen, header-level
  {
    # if done-drawing?(screen) break
    {
      var done?/eax: boolean <- done-drawing? screen
      compare done?, 0  # false
      break-if-!=
    }
    #
    c <- read-grapheme-buffered fs
    # if (c == EOF) break
    compare c, 0xffffffff  # EOF marker
    break-if-=
    # if (c == newline) break
    compare c, 0xa  # newline
    break-if-=
    #
    add-grapheme screen, c
    #
    loop
  }
  normal-text screen
}
}

# colors for a light background, going from bright to dark (meeting up with bold-text)
fn start-heading screen: (addr paginated-screen), header-level: int {
$start-heading:body: {
  start-bold-on-paginated-screen screen
  compare header-level, 1
  {
    break-if-!=
    start-color-on-paginated-screen screen, 0xa0, 7
    break $start-heading:body
  }
  compare header-level, 2
  {
    break-if-!=
    start-color-on-paginated-screen screen, 0x7c, 7
    break $start-heading:body
  }
  compare header-level, 3
  {
    break-if-!=
    start-color-on-paginated-screen screen, 0x58, 7
    break $start-heading:body
  }
  compare header-level, 4
  {
    break-if-!=
    start-color-on-paginated-screen screen, 0x34, 7
    break $start-heading:body
  }
  start-color-on-paginated-screen screen, 0xe8, 7
}
}

fn render-until-asterisk screen: (addr paginated-screen), fs: (addr buffered-file) {
  {
    # if done-drawing?(screen) break
    var done?/eax: boolean <- done-drawing? screen
    compare done?, 0  # false
    break-if-!=
    #
    var c/eax: grapheme <- read-grapheme-buffered fs
    # if (c == EOF) break
    compare c, 0xffffffff  # EOF marker
    break-if-=
    # if (c == '*') break
    compare c, 0x2a  # '*'
    break-if-=
    #
    add-grapheme screen, c
    #
    loop
  }
}

fn render-until-underscore screen: (addr paginated-screen), fs: (addr buffered-file) {
  {
    # if done-drawing?(screen) break
    var done?/eax: boolean <- done-drawing? screen
    compare done?, 0  # false
    break-if-!=
    #
    var c/eax: grapheme <- read-grapheme-buffered fs
    # if (c == EOF) break
    compare c, 0xffffffff  # EOF marker
    break-if-=
    # if (c == '_') break
    compare c, 0x5f  # '_'
    break-if-=
    #
    add-grapheme screen, c
    #
    loop
  }
}

fn first-arg args-on-stack: (addr array addr array byte) -> out/eax: (addr array byte) {
  var args/eax: (addr array addr array byte) <- copy args-on-stack
  var result/eax: (addr addr array byte) <- index args, 1
  out <- copy *result
}

fn normal-text screen: (addr paginated-screen) {
  reset-formatting-on-paginated-screen screen
  start-color-on-paginated-screen screen, 0xec, 7  # 236 = darkish gray
}
