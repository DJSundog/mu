# Playing with emitting cool textures.
#
# To run (on Linux):
#   $ git clone https://github.com/akkartik/mu
#   $ cd mu
#   $ ./translate_mu apps/texture.mu
#   $ ./a.elf > a.ppm

fn main -> _/ebx: int {
#?   var width/esi: int <- copy 0x190  # 400
#?   var height/edi: int <- copy 0xe1  # 225; aspect ratio 16:9
  var width/esi: int <- copy 0xff
  var height/edi: int <- copy 0xff
  print-string 0, "P3\n"
  print-int32-decimal 0, width
  print-string 0, " "
  print-int32-decimal 0, height
  print-string 0, "\n"
  print-string 0, "255\n"  # color depth
  var row/ecx: int <- copy 0
  {
    compare row, height
    break-if->=
    var col/edx: int <- copy 0
    {
      compare col, width
      break-if->=
      # r
      var tmp/eax: int <- copy col
      tmp <- multiply row
      tmp <- and 0x7f
      tmp <- add 0x80
      tmp <- copy 0xff
      print-int32-decimal 0, tmp
      print-string 0, " "
      # g
      tmp <- copy row
      tmp <- multiply col
      tmp <- and 0x7f
      tmp <- add 0x80
#?       tmp <- copy 0xcf
      print-int32-decimal 0, tmp
      print-string 0, " "
      # b
      tmp <- copy row
      tmp <- multiply col
      tmp <- and 0x7f
      tmp <- add 0x80
      print-int32-decimal 0, tmp
      print-string 0, "\n"
      col <- increment
      loop
    }
    row <- increment
    loop
  }
  return 0
}
