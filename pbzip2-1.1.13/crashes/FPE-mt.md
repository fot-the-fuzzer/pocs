# Floating point exception when processors are more than file size<Paste>

# Description:

As of pbzip2-1.1.13 (latest version for Linux distributions such as Debian/Ubuntu, a floating point exception may happen when the number of processors are more than the file size.
For example, the following command will cause a FPE error.

```bash
echo > FILE
pbzip2 -r -f -k -p2 FILE
```

The root cause is that at pbzip2.cpp:4126, the `blockSize` is 0 since it is initially calculated at Line 4087 as:

4086                // determine block size to try and spread data equally over # CPUs
4087                blockSize = InFileSize / numCPU;

Given that the default number of processors to be used for compression is the core count, many larger files may cause this exception.
