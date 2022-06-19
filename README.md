cliptester
==========

## The idea

```
setup:
  local = /tmp/blah
  mkdir $local
  compile -o $local my_program
 
run:
  $local/my_program 

test:
  stdout "should have something"
```
