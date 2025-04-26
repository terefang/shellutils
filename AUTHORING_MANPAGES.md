# how to authoring man-pages

create your manpage in pandoc.

```
% COMMAND(1)
% Max Mustermann
% August 1974

# NAME

command – shovel off to execute command

# SYNOPSIS

**command** [**-h**] [**--configfile** *CONFIGFILE*] [**--sort**] *arg* [*arg ...*]

# DESCRIPTION

**command** is a simple-minded tool that executes commands

# GENERAL OPTIONS

**-h**, **-\-help**
:   Display a friendly help message.

# NOTES

this is `command`.

# REFERENCES

none
```

### convert to man format

```
pandoc -s -t man test.man.md > /tmp/test.man
```

### convert to pdf

```
pdfroff -man test.man > test.man.pdf
```
