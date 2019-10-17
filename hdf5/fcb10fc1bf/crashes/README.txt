help@hdfgroup.org

VERSION:
   HDF5-1.13.0

USER:
   Hongxu Chen (hchen017@e.ntu.edu.sg)

SYNOPSIS:
    HDF5 utilties h5dump and gif2h5 emit several crashes, which may result from lack of validity checks.

MACHINE / OPERATING SYSTEM:
    Linux C11 4.15.0-51-generic #55-Ubuntu SMP Wed May 15 14:27:21 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
    Ubuntu 18.04.3 LTS

COMPILER:
    clang-6.0(tags/RELEASE_601/final)

DESCRIPTION:
    These crashes are triggered with 2 command line options.
    1) `h5dump $FILE`. The detected crashes are due to buffer-overflows (most of them are essentially out-of-bound read/write), assertion failures, and null-pointer read.
    2) `gif2h5 $FILE /dev/null`. The detected crashes are due to heap-buffer-overflows and invalid read.
    The root causes are mostly lack of validity checking.
    Please refer to the attachment for $FILE and the corresponding AddressSanitizer error message.


REPEAT BUG BY:
    To reproduce, compile hdf5 project with AddressSanitizer flags and execute the command line options.
    I suppose there should be no other dependencies.
    
    ldd ./h5dump
        linux-vdso.so.1 (0x00007ffcf7ba1000)
        libhdf5.so.1000 => /home/exp/FOT/Targets/hdf5/hdf5-asan/install/lib/libhdf5.so.1000 (0x00007f86816ca000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f86814ad000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f86812a9000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f8680f0b000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f8680cec000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f8680ae4000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f86808cc000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f86804db000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f86838a0000)

    ldd ./gif2h5
        linux-vdso.so.1 (0x00007ffc8efb8000)
        libhdf5_hl.so.1000 => /home/exp/FOT/Targets/hdf5/hdf5-asan/install/lib/libhdf5_hl.so.1000 (0x00007f4f411d9000)
        libhdf5.so.1000 => /home/exp/FOT/Targets/hdf5/hdf5-asan/install/lib/libhdf5.so.1000 (0x00007f4f3f003000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f4f3ede6000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f4f3ebe2000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f4f3e844000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f4f3e625000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f4f3e41d000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f4f3e205000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f4f3de14000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f4f41430000)
    

SAMPLE FIX:
    Not yet.
   
