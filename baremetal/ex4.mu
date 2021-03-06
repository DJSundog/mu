# Draw a character using the built-in font (GNU unifont)
#
# To build a disk image:
#   ./translate_mu_baremetal baremetal/ex4.mu     # emits disk.img
# To run:
#   qemu-system-i386 disk.img
# Or:
#   bochs -f baremetal/boot.bochsrc               # boot.bochsrc loads disk.img
#
# Expected output: letter 'A' in green near the top-left corner of screen

fn main {
  var g/eax: grapheme <- copy 0x41  # 'A'
  draw-grapheme 0, g, 2, 1, 0xa  # x of 2 graphemes = 16px from top-left; y of 1 grapheme = 16px down from top-left
}
