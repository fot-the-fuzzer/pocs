# CVE-2019-15144
- https://sourceforge.net/p/djvu/bugs/299/
- POCs: so_GContainer.h:557_1.pbm, so_GContainer.h:557_2.pbm
```
cjb2 $FILE /dev/null
```

# CVE-2019-15145
- https://sourceforge.net/p/djvu/bugs/298/
- POCs: read_JB2Image.h:741_1.jb2, read_JB2Image.h:741_2.jb2, read_jb2tune.cpp:294_1.jb2, read_jb2tune.cpp:294_2.jb2
```bash
cjb2 $FILE /dev/null
# cpaldjvu
```
