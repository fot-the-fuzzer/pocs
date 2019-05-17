FOT/gpmf > gdb --args ./gpmf-orig/BUILD/gpmf-parser ~/FOT/ALL/gpmf-parser/e27b702/hangs/h01.mp4
Reading symbols from ./gpmf-orig/BUILD/gpmf-parser...done.
gdb$ run
Starting program: /home/exp/FOT/gpmf/gpmf-orig/BUILD/gpmf-parser /home/exp/FOT/ALL/gpmf-parser/e27b702/hangs/h01.mp4
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
^C
Program received signal SIGINT, Interrupt.
0x00007ffff6f13217 in __lseek64 (fd=0x3, offset=0x64, whence=0x0) at ../sysdeps/unix/sysv/linux/lseek64.c:35
35      ../sysdeps/unix/sysv/linux/lseek64.c: No such file or directory.
gdb$ bt
#0  0x00007ffff6f13217 in __lseek64 (fd=0x3, offset=0x64, whence=0x0) at ../sysdeps/unix/sysv/linux/lseek64.c:35
#1  0x00007ffff6e8e0ce in _IO_new_file_seekoff (fp=0x616000000080, offset=0x58, dir=0x0, mode=<optimized out>) at fileops.c:1074
#2  0x00007ffff6e8bdd9 in fseeko (fp=0x616000000080, offset=<optimized out>, whence=<optimized out>) at fseeko.c:36
#3  0x000000000054b6ea in OpenMP4Source (filename=0x7fffffffc929 "/home/exp/FOT/ALL/gpmf-parser/e27b702/hangs/h01.mp4", traktype=0x6174656d, traksubtype=0x646d7067) at /home/exp/FOT/gpmf/gpmf-orig/demo/GPMF_mp4reader.c:140
#4  0x0000000000549107 in main (argc=0x2, argv=0x7fffffffc378) at /home/exp/FOT/gpmf/gpmf-orig/demo/GPMF_demo.c:48
