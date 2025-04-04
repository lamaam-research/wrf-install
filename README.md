# Automatic installation of the environment for WRF 4.2 

This script is designed to automatically install the minimum dependencies for building WRF with the GNU compiler, mpich, Zlib, hdf5, netcdf-c, netcdf-fortran, jasper and libpng will be installed at user level. 

## How to use:
Make the script executable:

```
chmod +x install_dependencies.sh
```
Run it with:
```
bash install_dependencies.sh
```


## After running the script, the environment will be ready to install WRF and WPS. 

```
git clone --recurse-submodule https://github.com/wrf-model/WRF.git
cd WRF
```
As the build is based on gnu, after running the setup, choose options 34 and then 1.

```
./configure 
```

