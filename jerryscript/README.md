`bin/jerry $FILE`

```
#  this is because jerryscript does not handle call stack
./f58f150/crashes/so_ecma-function-object.c:979.js -- https://github.com/jerryscript-project/jerryscript/issues/4242

# these stack-overflows are relevant with proxy objects, which seems an incomplete fix for CVE-2020-13623 (https://github.com/googleprojectzero/fuzzilli#jerryscript)
./f58f150/crashes/so_ecma-proxy-object.c:1024.js -- https://github.com/jerryscript-project/jerryscript/issues/4243
./f58f150/crashes/so_ecma-proxy-object.c:277_1.js -- https://github.com/jerryscript-project/jerryscript/issues/4243
./f58f150/crashes/so_ecma-proxy-object.c:277_2.js -- https://github.com/jerryscript-project/jerryscript/issues/4243
```
