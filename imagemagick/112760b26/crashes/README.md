Command lines:
```
convert $FILE /dev/null
# or
identify -verbose $FILE
```

```
$ convert --version
Version: ImageMagick 7.0.8-41 Q16 x86_64 2019-04-20 https://imagemagick.org
Copyright: © 1999-2019 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI OpenMP
Delegates (built-in): bzlib djvu fftw fontconfig freetype jbig jng jp2 jpeg lcms lqr lzma openexr pangocairo png raw tiff webp wmf x xml zlib

# git commit
112760b26

# also affected DEB version (Ubuntu 18.04 LTS):
Version: ImageMagick 6.9.7-4 Q16 x86_64 20170114 http://www.imagemagick.org
Copyright: © 1999-2017 ImageMagick Studio LLC
License: http://www.imagemagick.org/script/license.php
Features: Cipher DPC Modules OpenMP
Delegates (built-in): bzlib djvu fftw fontconfig freetype jbig jng jpeg lcms lqr ltdl lzma openexr pangocairo png tiff wmf x xml zlib

```

This is firstly detected when fuzzing GraphicsMagick.
