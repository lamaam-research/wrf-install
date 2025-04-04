# Automatic installation of the environment for WRF 4.2 

This script is designed to automatically install the minimum dependencies for building WRF with the GNU compiler, mpich, zlib, hdf5, netcdf-c, netcdf-fortran, jasper and libpng. 

## If you are using a Debian-based Linux for the first time, run:
```
sudo apt install build-essential gcc cpp gfortran g++ make cmake coreutils m4 ncview flex bison libcurl4-openssh-dev git automake
```

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
### WRF 
```
git clone --recurse-submodule https://github.com/wrf-model/WRF.git
cd WRF
export $WRF_DIR=$PWD
```
As the build is based on gnu, after running the setup (choose options 34 and then 1).

```
./configure 
```
This step is one of the most time-consuming and can take 30 ~ 40 minutes
```
./compile -j 4 em_real 2>&1 | tee compile.log
```
Check the instalation

```
ls -lah main/*.exe
ls -lah run/*.exe
ls -lah test/em_real/*.exe
```


### WPS

```
cd ..
git clone https://github.com/wrf-model/WPS.git
cd WPS
```

Run (choose option 1):
```
./configure 
```
And:
```
./compile >& log.compile
```
