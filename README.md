# PyBundle

*Experiment* in building python single-file bundled dependency executables with the [`zipapp`][zipapp] module.


Place a `__main__.py` in your app directory and call `pybundle.sh bundle <app_dir>` on it.
See the included example `app`.


The included example use [`click`][click]'s
hello-world example to show how dependencies work.



``` 
Usage:
  pybundle.sh bundle  <app_dir> [<executable_name> [<shebang>]]
  pybundle.sh install <app_dir> [<pip_arguments>...]
  pybundle.sh patchmain <app_dir>
```

```
# bundle
    Will bundle files in <app_dir> in to <executable_name> with an optional <shebang>
    given as something like `/usr/local/env python3`

# install
    Will install a package via pip, but place it with <app_dir> as the install prefix
    (so, <app_dir>/lib/<python version>/site-packages). This directly 

# patchmain
    Will patch your __main__.py so it loads packages from the directory where `install`
    installs packages to.

# run
    Will build and run your application directly.
    Practical for development.
```


# Python 2

If you are building a python2 application, you want to use python2 to build and run your
bundle. Note that bybundle.sh use the python 3.5+ `zipapp` module to bundle your application,
so you still need python3.
You can build for python2 by setting the `PY` env variable like so:

```
PY=python2 pybundle.sh install <app_dir> <dep>
```

# Example

Clone the repo and call `./pybundle.sh install app -r app/requirements.txt` to install the dependencies.

Then call `./bybundle.sh bundle app` to produce an executable `app.pyz` file.

You can now run this file and see the `click` hello world example

[zipapp]: https://docs.python.org/3/library/zipapp.html
[click]: http://click.pocoo.org/
