# the-silent-ones
When we install software, the procedures can be quite long.
This is an effort to have automated scripts that will install\setup softwares without having to go through procedure again.
This is typically needed when you want to start from scratch or change your machine\VM.
Code will be mostly in batch files on Windows and bash scripts on Linux with calls to utilities\native scripts whereever they are unavoidable.


## gtk3
Procedure Based on https://www.gtk.org/docs/installations/windows/ as it stands on 15th July 2021.
gtk script `setup_gtk.bat` depends on `setup_msys2.bat` since MSYS2 is needed by gtk.

## MSYS2
setup gtk

Call `script_name` with parameters either of following to get help: `-h, --help, /?, -?`


