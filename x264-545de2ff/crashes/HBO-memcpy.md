# [heap-buffer-overflow inside x264_cli_plane_copy (internal.c:34:9)](https://mailman.videolan.org/pipermail/x264-devel/2019-February/012579.html)

# Description

There is a heap-buffer-overflow issue inside x264. Here is an error reported by AddressSanitizer when executing

```
x264 --threads 1 --quiet --output /dev/null $FILE
```
POC files: [file1](https://github.com/ntu-sec/pocs/blob/master/x264-545de2ff/crashes/hbo_internal.c_34_1?raw=true), [file2](https://github.com/ntu-sec/pocs/blob/master/x264-545de2ff/crashes/hbo_internal.c_34_2?raw=true) and [another](https://github.com/ntu-sec/pocs/blob/master/x264-545de2ff/crashes/another_poc?raw=true).

```
=================================================================
==66950==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x7f32d900d82f at pc 0x0000004bf7e1 bp 0x7ffd9ba0ac70 sp 0x7ffd9ba0a420
READ of size 1408 at 0x7f32d900d82f thread T0
    #0 0x4bf7e0 in __asan_memcpy (/home/ubuntu/work/x264/x264-asan/install/bin/x264+0x4bf7e0)
    #1 0x525a7d in x264_cli_plane_copy /home/ubuntu/work/x264/x264-asan/filters/video/internal.c:34:9
    #2 0x525dec in x264_cli_pic_copy /home/ubuntu/work/x264/x264-asan/filters/video/internal.c:56:9
    #3 0x529fb8 in get_frame /home/ubuntu/work/x264/x264-asan/filters/video/fix_vfr_pts.c:100:13
    #4 0x512ff7 in encode /home/ubuntu/work/x264/x264-asan/x264.c:1980:13
    #5 0x50ea89 in main_internal /home/ubuntu/work/x264/x264-asan/x264.c:388:15
    #6 0x5b66cb in x264_stack_align (/home/ubuntu/work/x264/x264-asan/install/bin/x264+0x5b66cb)

0x7f32d900d82f is located 0 bytes to the right of 405551-byte region [0x7f32d8faa800,0x7f32d900d82f)
allocated by thread T0 here:
    #0 0x4d51f8 in __interceptor_posix_memalign (/home/ubuntu/work/x264/x264-asan/install/bin/x264+0x4d51f8)
    #1 0x7f32f0215762 in av_malloc (/usr/lib/x86_64-linux-gnu/libavutil.so.55+0x31762)

SUMMARY: AddressSanitizer: heap-buffer-overflow (/home/ubuntu/work/x264/x264-asan/install/bin/x264+0x4bf7e0) in __asan_memcpy
Shadow bytes around the buggy address:
  0x0fe6db1f9ab0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0fe6db1f9ac0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0fe6db1f9ad0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0fe6db1f9ae0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0fe6db1f9af0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0fe6db1f9b00: 00 00 00 00 00[07]fa fa fa fa fa fa fa fa fa fa
  0x0fe6db1f9b10: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0fe6db1f9b20: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0fe6db1f9b30: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0fe6db1f9b40: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0fe6db1f9b50: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==66950==ABORTING
[1]    66950 abort      ~/work/x264/x264-asan/install/bin/x264 --threads 1 --quiet --output /dev/null
```

The crash site is a call to memcpy which overflows the `dst` buffer. The root
cause seems to be inproper validation check that parses the wrong width/height
information.  Plus, there seem some non-deterministic behaviors since each time
it may crash at different iterations of call to memcpy.

Another separate bug report: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=906532.
The crash backtrace is the almost same however with different input file format.
