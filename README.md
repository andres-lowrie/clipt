cliptester
==========

## The idea

```
# Comments
suite: "prog sub-command"
  case: "It should do something"
    .$ = /bin/sh                  # Override settings per scope
    .image = ubuntu:20.04

    # Create files in the target runtime
    file: /some/input/somewhere
      Write these contents to the file specified, literally.

    # Reference files locally
    file: /local_disk/file, /some/input/somewhere  

    setup:
      local = /tmp/blah            # set variables for exapansion
      mkdir local                  # run commands that you don't need output just as you normally would

      compile -o local my_program
      some_cmd = $(blah blah)      # run commands you do want output for in "sub-shell" like construct
     
    # This whole block runs in whatever shell is set
    # but clipt variables in scope are expanded before running
    run:
      local/my_program <some/input/somewhere >some/output/file

    # Use builtins to quickly assert things
    test:
      stdout == "exact stdout string"
      @some/output/file ~= /^blah/

    # In case you're running locally on your machine instead of some image
    cleanup:
      rm -rf local
```

### Built-in Details
```
.<setting>:
  Set a property for the block

@<path>:
  Read contents of file

stdout:
  Variable that captures stdout

stderr:
  Variable that captures stderr

==:
  Does <left> exactly match <right>

~=:
  Does <left> kinda match <right>

!=:
  Does <left> not match <right>
```
