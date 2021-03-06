# Test out the video mode by filling in the screen with pixels.
#
# To build a disk image:
#   ./translate_mu_baremetal baremetal/ex2.mu     # emits disk.img
# To run:
#   qemu-system-i386 disk.img
# Or:
#   bochs -f baremetal/boot.bochsrc               # boot.bochsrc loads disk.img
#
# Expected output:
#   html/baremetal.png

fn main {
  var y/eax: int <- copy 0
  {
    compare y, 0x300  # screen-height = 768
    break-if->=
    var x/edx: int <- copy 0
    {
      compare x, 0x400  # screen-width = 1024
      break-if->=
      var color/ecx: int <- copy x
      color <- and 0xff
      pixel-on-real-screen x, y, color
      x <- increment
      loop
    }
    y <- increment
    loop
  }
}
