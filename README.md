### Docker Boxes

I'm going to collect definitions for several boxes I use in this repository. There is some script to help me build and connect to them.

#### Build

* `./build.sh 01-clojure-neovim.dockerfile` to build box number 01 for example.
* `./connect.sh devbox` will connect to the box with name "devbox"

#### Configuration

* You need to change authorized_keys so it contains a different public key. The key is used to accept ssh connections into the box (in case it is deployed remotely).
* Other things inside the docker files are specific to my setup, so they are going to pull my rc files (and so on).

### Box Summary

#### Clojure-Neovim

This is a development box mounting some host file system path containing locally checked-out projects. It installs neovim, java, lein and everything else for sane vim-based Clojure development such as clj-refactor.
