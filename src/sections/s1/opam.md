## Installing `opam`
`opam` is a package manager for OCaml. You will later use it to install OCaml compilers, interpreters, and other third-party libraries needed for this course.



### Installing for Linux
Follow the steps [here](https://opam.ocaml.org/doc/Install.html#Binary-distribution), under the "Binary distribution" section header.



### Installing for macOS
If you have [homebrew](https://brew.sh/), just run
```
brew install gpatch
brew install opam
```

Otherwise, follow the same steps in "Installing for Linux" section.



### Installing for Windows
Windows users are recommended to use CSIL instead, since OCaml doesn't work too well on Windows.



### Installing on CSIL Machines

`opam` is a little trickier to set up on CSIL. Log onto a CSIL machine (you can do it [remotely](https://ucsb-engr.atlassian.net/wiki/spaces/EPK/pages/575373494/Can+I+remote+log+in+to+CSIL+Linux+from+home)). Once you're logged in, fire up a terminal, and type the following command to download an `opam` binary:
```bash
curl -LR 'https://github.com/ocaml/opam/releases/download/2.1.0/opam-2.1.0-x86_64-linux' -o opam
```

Then make sure the downloaded binary is executable, and move it to `~/bin/opam`:
```bash
chmod +x opam
mkdir -p ~/bin/
mv opam ~/bin/opam
```
Check to make sure it's on `PATH`:
```
[junrui@csil-08 ~]$ opam --version
2.1.0
```
Lastly, run `opam init`. This will take 20-40 minutes because it has to download a bunch of stuff. It will prompt you once or twice afterwards; you can safely respond with Y to make your life more convenient.



[^1]: Aadapted from [this guide](https://github.com/fredfeng/CS162/blob/master/sections/section1/install_ocaml.md) written by Bryan Tan.