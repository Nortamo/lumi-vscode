## Lumi-vscode

Proof of concept for VS code
with some sort of fortran support on LUMI





https://user-images.githubusercontent.com/40563680/215087935-5dd994b9-d381-4ee2-b551-909512a70e57.mp4






## Components

- code-server https://github.com/coder/code-server
- Modern fortran https://github.com/fortran-lang/vscode-fortran-support
- Fortls (dependency for the fortran extension) https://github.com/fortran-lang/fortls 

## Usage

run `build_base.sh` to install everything.
run `start.sh` to launch vs code. a password and port information will be printed to the screen.
Edit the user  settings in vs code, either the json or through the ui.
and set the correct path for source dirs ` "fortran.fortls.extraArgs": ["--source_dirs=/Repo/use_mpi_interface"]`
insert the full path to the `use_mpi_interface` in this repo. 


## Notes

The linting for cray fortran compiler is done through a very hacky wrapper
The proper way would be to implement a new linting class to the modern fortran extensions
which should not be to hard...

As interfaces can not be generated from .mod files automatically the mpi
interfaces have been pulled from an mpich installation, these should be compatible
with the cray-mpich. Note that mpich source code does not contain the fortran interfaces
as they are generated at build time. 
