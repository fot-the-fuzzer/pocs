Version: https://github.com/gpac/gpac/commit/c00723674cb4a9d6ab513081394300e176784a3e

```
MP42TS -src $FILE -dst-file /dev/null
```

may trigger SEGV error where ASAN reports an invalid read.

GDB reports:

```
Reading symbols from ./MP42TS...
gdb$ run
Starting program: /home/hongxu/FOT/gpac/gpac-orig/install/bin/MP42TS -src m0215.mp4 -dst-file /dev/null
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[iso file] Incomplete box ftyp - start 0 size 808464424
[iso file] Incomplete file while reading for dump - aborting parsing
Setting up program ID 1 - send rates: PSI 200 ms PCR 100 ms - PCR offset 0

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff77b3eba in gf_m2ts_stream_process_pmt () from /home/hongxu/FOT/gpac/gpac-fuzz/install/bin/../lib/libgpac.so.8
gdb$ bt
#0  0x00007ffff77b3eba in gf_m2ts_stream_process_pmt () from /home/hongxu/FOT/gpac/gpac-fuzz/install/bin/../lib/libgpac.so.8
#1  0x00007ffff77c2955 in gf_m2ts_mux_update_config () from /home/hongxu/FOT/gpac/gpac-fuzz/install/bin/../lib/libgpac.so.8
#2  0x0000000000406eca in main (argc=0x5, argv=0x7fffffffba68) at main.c:2683
```
