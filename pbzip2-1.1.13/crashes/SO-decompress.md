# Decompression in multithreading mode causes SIGSEGV

# Description

As of pbzip2-1.1.13 (latest version for Linux distributions such as Debian/Ubuntu, the decompression in multithreading mode may cause SIGSEGV.

When executing

```bash
./pbzip2 -f -k -p2 -S16 -d ./c01.bz2
```

It may termininate unexpectedly with the following message:

pbzip2: *ERROR during BZ2_bzDecompress - failure exit code: ret=-4; block=4; seq=-1; isLastInSeq=1; avail_in=10
[1] 40436 segmentation fault ./pbzip2 -f -k -p2 -S16 -d ./c01.bz2

The root cause is that under the multithreading execution environment, the call to vfprintf inside function `handle_error` may use up all the thread stack, which causes the crash.

The suggested fix is to allow larger specified stack size as can set by the users.

GDB shows the backtrace like:

```
Starting program: ./pbzip2 -f -k -p2 -S16 -d ./c01.bz2
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7ffff7ff6700 (LWP 62914)]
[New Thread 0x7ffff7ff1700 (LWP 62915)]
[New Thread 0x7ffff7fec700 (LWP 62916)]
[New Thread 0x7ffff7fdd700 (LWP 62917)]
[New Thread 0x7ffff7fd8700 (LWP 62918)]
[Thread 0x7ffff7fdd700 (LWP 62917) exited]
pbzip2: *ERROR during BZ2_bzDecompress - failure exit code: ret=-4; block=4; seq=-1; isLastInSeq=1; avail_in=10

Thread 4 "pbzip2" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff7fec700 (LWP 62916)]
_IO_vfprintf_internal (s=0x7ffff7fe9520, format=0x40e515 "pbzip2: *ERROR: system call failed with errno=[%d: %s]!\n", ap=0x7ffff7febbe0) at vfprintf.c:1320
1320 vfprintf.c: No such file or directory.
gdb$ bt
#0 _IO_vfprintf_internal (s=0x7ffff7fe9520, format=0x40e515 "pbzip2: *ERROR: system call failed with errno=[%d: %s]!\n", ap=0x7ffff7febbe0) at vfprintf.c:1320
#1 0x00007ffff6cd4680 in buffered_vfprintf (s=s@entry=0x7ffff7062680 <_IO_2_1_stderr_>, format=format@entry=0x40e515 "pbzip2: *ERROR: system call failed with errno=[%d: %s]!\n", args=args@entry=0x7ffff7febbe0) at vfprintf.c:2329
#2 0x00007ffff6cd1726 in _IO_vfprintf_internal (s=0x7ffff7062680 <_IO_2_1_stderr_>, format=0x40e515 "pbzip2: *ERROR: system call failed with errno=[%d: %s]!\n", ap=ap@entry=0x7ffff7febbe0) at vfprintf.c:1301
#3 0x00007ffff6cdae54 in __fprintf (stream=<optimized out>, format=<optimized out>) at fprintf.c:32
#4 0x000000000040b9a5 in pbzip2::ErrorContext::printErrnoMsg (err=0x2, out=<optimized out>) at ErrorContext.cpp:43
#5 pbzip2::ErrorContext::printErrorMessages (this=0x622e70, out=0x7ffff7062680 <_IO_2_1_stderr_>) at ErrorContext.cpp:59
#6 0x0000000000402806 in handle_error (exitFlag=EF_EXIT, exitCode=0xffffffff, fmt=<optimized out>) at pbzip2.cpp:638
#7 0x0000000000402c5c in issueDecompressError (bzret=0xfffffffc, fileData=<optimized out>, outSequenceNumber=0xffffffff, strm=..., errmsg=0x40be9a "*ERROR during BZ2_bzDecompress - failure exit code", exitCode=0xffffffff) at pbzip2.cpp:769
#8 decompressErrCheckSingle (bzret=0xfffffffc, fileData=<optimized out>, outSequenceNumber=0xffffffff, strm=..., errmsg=0x40be9a "*ERROR during BZ2_bzDecompress - failure exit code", isTrailingGarbageErr=0x0) at pbzip2.cpp:807
#9 0x0000000000403e2a in consumer_decompress (q=0x623190) at pbzip2.cpp:1557
#10 0x00007ffff79ad6db in start_thread (arg=0x7ffff7fec700) at pthread_create.c:463
#11 0x00007ffff6d9788f in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:95

And the AddressSanitizer compiled version reports a stack-overflow:

AddressSanitizer:DEADLYSIGNAL
=================================================================
==51048==ERROR: AddressSanitizer: stack-overflow on address 0x7efc9e9a2e18 (pc 0x7efc9d4223c6 bp 0x7efc9e9a32d0 sp 0x7efc9e9a2d60 T3)
    #0 0x7efc9d4223c5 in _IO_vfprintf /build/glibc-OTsEL5/glibc-2.27/stdio-common/vfprintf.c:1275
    #1 0x7efc9d42567f in buffered_vfprintf /build/glibc-OTsEL5/glibc-2.27/stdio-common/vfprintf.c:2329
    #2 0x7efc9d422725 in _IO_vfprintf /build/glibc-OTsEL5/glibc-2.27/stdio-common/vfprintf.c:1301
    #3 0x441c24 in __interceptor_vfprintf (/home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2+0x441c24)
    #4 0x4f60a9 in handle_error(ExitFlag, int, char const*, ...) /home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2.cpp:637:2
    #5 0x4f6708 in issueDecompressError(int, outBuff const*, int, bz_stream const&, char const*, int) /home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2.cpp:769:2
    #6 0x4f6708 in decompressErrCheckSingle(int, outBuff const*, int, bz_stream const&, char const*, bool) /home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2.cpp:830
    #7 0x4f9358 in consumer_decompress /home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2.cpp:1557:14
    #8 0x7efc9e50a6da in start_thread (/lib/x86_64-linux-gnu/libpthread.so.0+0x76da)
    #9 0x7efc9d4e888e in clone /build/glibc-OTsEL5/glibc-2.27/misc/../sysdeps/unix/sysv/linux/x86_64/clone.S:95

SUMMARY: AddressSanitizer: stack-overflow /build/glibc-OTsEL5/glibc-2.27/stdio-common/vfprintf.c:1275 in _IO_vfprintf
Thread T3 created by T0 here:
    #0 0x4ac4fd in pthread_create (/home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2+0x4ac4fd)
    #1 0x503c1b in main /home/ubuntu/work/pbzip2/pbzip2-asan-2/pbzip2.cpp:4252:12
    #2 0x7efc9d3e8b96 in __libc_start_main /build/glibc-OTsEL5/glibc-2.27/csu/../csu/libc-start.c:310

==51048==ABORTING
```
