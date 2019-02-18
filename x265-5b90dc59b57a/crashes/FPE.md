# [FPE during encoding y4m](https://bitbucket.org/multicoreware/x265/issues/468/floating-point-exception-during-encoding)

# Description

A floating point exception may happen during encoding a crafted y4m file for x265 (3.0_Au, hg commit 5b90dc59b57a).

```
x265 --input c00.y4m --pools 1 -F 1 --output /tmp/test.265
```

Root cause is the division by `rateDenom` at Line 304
source/input/y4m.cpp inside function Y4MInput::parseHeader.

```c
302     if (width < MIN_FRAME_WIDTH || width >MAX_FRAME_WIDTH
303         height < MIN_FRAME_HEIGHT || height > MAX_FRAME_HEIGHT
304         (rateNum / rateDenom) < 1 || (rateNum / rateDenom) > MAX_FRAME_RATE
305         colorSpace < X265_CSP_I400 || colorSpace >= X265_CSP_COUNT)
306         return false;

```

Before entering
Y4MInput::parseHeader, `rateDenom` is 0 and there is no additional assignment
for this value, which results in a divide-by-zero error.
