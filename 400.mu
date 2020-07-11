# The 4xx series is for primitives implemented in Mu.

# Signatures for major SubX functions defined so far.

# autogenerated
sig run-tests

# init.linux
# TODO: make this OS-specific
# TODO: include result type at least, even if register args are too much
sig syscall_exit  # status/ebx: int
sig syscall_read  # fd/ebx: int, buf/ecx: addr, size/edx: int -> nbytes-or-error/eax: int
sig syscall_write  # fd/ebx: int, buf/ecx: addr, size/edx: int -> nbytes-or-error/eax: int
sig syscall_open  # filename/ebx: (addr kernel-string), flags/ecx: int, dummy=0x180/edx -> fd-or-error/eax: int
sig syscall_close  # fd/ebx: int -> status/eax
sig syscall_creat  # filename/ebx: (addr kernel-string) -> fd-or-error/eax: int
sig syscall_unlink  # filename/ebx: (addr kernel-string) -> status/eax: int
sig syscall_rename  # source/ebx: (addr kernel-string), dest/ecx: (addr kernel-string) -> status/eax: int
sig syscall_mmap  # arg/ebx: (addr mmap_arg_struct) -> status/eax: int
sig syscall_ioctl  # fd/ebx: int, cmd/ecx: int, arg/edx: (addr _)
sig syscall_nanosleep  # req/ebx: (addr timespec)
sig syscall_clock_gettime  # clock/ebx: int, out/ecx: (addr timespec)

# Generated using:
#   grep -h '^[a-z]' [0-9]*.subx |grep -v '^test-'
# Functions we don't want to make accessible from Mu are commented out.
# Many functions here may not be usable yet because of missing features
# (global variable support, type definitions for stuff like `stream`)
sig check-ints-equal a: int, b: int, msg: (addr array byte)
sig kernel-string-equal? s: (addr kernel-string), benchmark: (addr array byte) -> result/eax: boolean
sig new-segment len: int, ad: (addr allocation-descriptor)
sig string-equal? s: (addr array byte), benchmark: (addr array byte) -> result/eax: boolean
sig string-starts-with? s: (addr array byte), benchmark: (addr array byte) -> result/eax: boolean
sig check-strings-equal s: (addr array byte), expected: (addr array byte), msg: (addr array byte)
sig clear-stream f: (addr stream byte)
sig rewind-stream f: (addr stream byte)
sig initialize-trace-stream n: int
sig trace line: (addr array byte)
sig check-trace-contains line: (addr string), msg: (addr string)
sig check-trace-scans-to line: (addr string), msg: (addr string)
sig trace-scan line: (addr array byte) -> result/eax: boolean
sig next-line-matches? t: (addr stream byte), line: (addr array byte) -> result/eax: boolean
sig skip-next-line t: (addr stream byte)
sig clear-trace-stream
#sig write f: fd or (addr stream byte), s: (addr array byte)
sig stream-data-equal? f: (addr stream byte), s: (addr array byte) -> result/eax: boolean
sig check-stream-equal f: (addr stream byte), s: (addr array byte), msg: (addr array byte)
sig next-stream-line-equal? f: (addr stream byte), s: (addr array byte) -> result/eax: boolean
sig check-next-stream-line-equal
sig tailor-exit-descriptor ed: (addr exit-descriptor), nbytes: int
sig stop ed: (addr exit-descriptor), value: int
#sig read f: fd or (addr stream byte), s: (addr stream byte) -> num-bytes-read/eax: int
sig read-byte-buffered f: (addr buffered-file) -> byte-or-Eof/eax: int
#sig write-stream f: fd or (addr stream byte), s: (addr stream byte)
#sig error ed: (addr exit-descriptor), out: fd or (addr stream byte), msg: (addr array byte)
sig write-byte-buffered f: (addr buffered-file), n: int
sig flush f: (addr buffered-file)
sig append-byte f: (addr stream byte), n: int
sig write-buffered f: (addr buffered-file), msg: (addr array byte)
#sig to-hex-char in/eax: int -> out/eax: int
sig append-byte-hex f: (addr stream byte), n: int
sig write-byte-hex-buffered f: (addr buffered-file), n: int
sig write-int32-hex f: (addr stream byte), n: int
sig write-int32-hex-buffered f: (addr buffered-file), n: int
sig is-hex-int? in: (addr slice) -> result/eax: boolean
sig parse-hex-int in: (addr array byte) -> result/eax: int
sig parse-hex-int-from-slice in: (addr slice) -> result/eax: int
#sig parse-hex-int-helper start: (addr byte), end: (addr byte) -> result/eax: int
sig is-hex-digit? c: byte -> result/eax: boolean
#sig from-hex-char in/eax: byte -> out/eax: nibble
sig error-byte ed: (addr exit-descriptor), out: (addr buffered-file), msg: (addr array byte), n: byte
#sig allocate ad: (addr allocation-descriptor), n: int, out: (addr handle)
#sig allocate-raw ad: (addr allocation-descriptor), n: int, out: (addr handle)
sig lookup h: (handle T) -> result/eax: (addr T)
sig handle-equal? a: handle, b: handle -> result/eax: boolean
sig copy-handle src: handle, dest: (addr handle)
sig allocate-region ad: (addr allocation-descriptor), n: int, out: (addr handle allocation-descriptor)
sig allocate-array ad: (addr allocation-descriptor), n: int, out: (addr handle)
sig copy-array ad: (addr allocation-descriptor), src: (addr array), out: (addr handle)
sig zero-out start: (addr byte), len: int
sig new-stream ad: (addr allocation-descriptor), length: int, elemsize: int, out: (addr handle stream _)
sig read-line-buffered f: (addr buffered-file), s: (addr stream byte)
sig read-line f: (addr stream byte), s: (addr stream byte)
sig slice-empty? s: (addr slice) -> result/eax: boolean
sig slice-equal? s: (addr slice), p: (addr array byte) -> result/eax: boolean
sig slice-starts-with? s: (addr slice), head: (addr array byte) -> result/eax: boolean
sig write-slice out: (addr stream byte), s: (addr slice)
sig write-slice-buffered out: (addr buffered-file), s: (addr slice)
sig slice-to-string ad: (addr allocation-descriptor), in: (addr slice), out: (addr handle array byte)
sig next-token in: (addr stream byte), delimiter: byte, out: (addr slice)
sig next-token-from-slice start: (addr byte), end: (addr byte), delimiter: byte, out: (addr slice)
sig skip-chars-matching in: (addr stream byte), delimiter: byte
sig skip-chars-matching-whitespace in: (addr stream byte)
sig skip-chars-not-matching in: (addr stream byte), delimiter: byte
sig skip-chars-not-matching-whitespace in: (addr stream byte)
sig skip-chars-matching-in-slice curr: (addr byte), end: (addr byte), delimiter: byte -> curr/eax: (addr byte)
sig skip-chars-matching-whitespace-in-slice curr: (addr byte), end: (addr byte) -> curr/eax: (addr byte)
sig skip-chars-not-matching-in-slice curr: (addr byte), end: (addr byte), delimiter: byte -> curr/eax: (addr byte)
sig skip-chars-not-matching-whitespace-in-slice curr: (addr byte), end: (addr byte) -> curr/eax: (addr byte)
sig skip-string line: (addr stream byte)
sig skip-string-in-slice curr: (addr byte), end: (addr byte) -> new_curr/eax: (addr byte)
sig skip-until-close-paren line: (addr stream byte)
sig skip-until-close-paren-in-slice curr: (addr byte), end: (addr byte) -> new_curr/eax: (addr byte)
sig write-stream-data f: (addr buffered-file), s: (addr stream byte)
sig write-int32-decimal out: (addr stream byte), n: int32
sig is-decimal-digit? c: byte -> result/eax: boolean
sig to-decimal-digit in: byte -> out/eax: int
sig next-word line: (addr stream byte), out: (addr slice)
sig has-metadata? word: (addr slice), s: (addr string) -> result/eax: boolean
sig is-valid-name? in: (addr slice) -> result/eax: boolean
sig is-label? word: (addr slice) -> result/eax: boolean
sig emit-hex out: (addr buffered-file), n: int, width: int
sig emit out: (addr buffered-file), word: (addr slice), width: int
#sig get table: (addr stream {(handle array byte), T}), key: (addr array byte), row-size: int, abort-message-prefix: (addr array byte) -> result/eax: (addr T)
#sig get-slice table: (addr stream {(handle array byte), T}), key: (addr slice), row-size: int, abort-message-prefix: (addr array byte) -> result/eax: (addr T)
#sig get-or-insert table: (addr stream {(handle array byte), T}), key: (addr array byte), row-size: int, ad: (addr allocation-descriptor) -> result/eax: (addr T)
#sig get-or-insert-handle table: (addr stream {(handle array byte), T}), key: (handle array byte), row-size: int -> result/eax: (addr T)
#sig get-or-insert-slice table: (addr stream {(handle array byte), T}), key: (addr slice), row-size: int, ad: (addr allocation-descriptor) -> result/eax: (addr T)
#sig get-or-stop table: (addr stream {(handle array byte), T}), key: (addr array byte), row-size: int,
#sig get-slice-or-stop table: (addr stream {(handle array byte), _}), key: (addr slice), row-size: int,
#sig maybe-get table: (addr stream {(handle array byte), T}), key: (addr array byte), row-size: int -> result/eax: (addr T)
#sig maybe-get-slice table: (addr stream {(handle array byte), T}), key: (addr slice), row-size: int -> result/eax: (addr T)
sig slurp f: (addr buffered-file), s: (addr stream byte)
sig compute-width word: (addr array byte) -> result/eax: int
sig compute-width-of-slice s: (addr slice) -> result/eax: int
sig emit-hex-array out: (addr buffered-file), arr: (addr array byte)
sig next-word-or-string line: (addr stream byte), out: (addr slice)
sig write-int out: (addr stream byte), n: int
sig clear-stack s: (addr stack)
sig push s: (addr stack), n: int
sig pop s: (addr stack) -> n/eax: int
sig top s: (addr stack) -> n/eax: int
sig array-equal? a: (addr array int), b: (addr array int) -> result/eax: boolean
sig parse-array-of-ints ad: (addr allocation-descriptor), s: (addr string), out: (addr handle array int)
sig check-array-equal a: (addr array int), expected: (addr string), msg: (addr string)
#sig push-n-zero-bytes n: int
sig kernel-string-to-string ad: (addr allocation-descriptor), in: (addr kernel-string), out: (addr handle array byte)
sig kernel-string-length in: (addr kernel-string) -> result/eax: int
sig enable-screen-grid-mode
sig enable-screen-type-mode
sig screen-size -> nrows/eax: int, ncols/ecx: int
sig clear-screen
sig move-cursor-on-screen row: int, column: int
sig print-string-to-screen s: (addr array byte)
sig print-byte-to-screen c: byte
sig print-int32-hex-to-screen n: int
sig reset-formatting-on-screen
sig start-color-on-screen fg: int, bg: int
sig start-bold-on-screen
sig start-underline-on-screen
sig start-reverse-video-on-screen
sig start-blinking-on-screen
sig hide-cursor-on-screen
sig show-cursor-on-screen
sig enable-keyboard-immediate-mode
sig enable-keyboard-type-mode
sig read-key -> result/eax: byte
sig open filename: (addr array byte), write?: boolean, out: (addr handle buffered-file)
sig size in: (addr array _) -> result/eax: int
